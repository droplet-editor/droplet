# ANTLR4 grammar file analysis for Droplet mode creation.
# Copyright (c) Anthony Bau 2016
# MIT License.

from antlr4 import *
from ANTLRv4Lexer import ANTLRv4Lexer
from ANTLRv4Parser import ANTLRv4Parser
import json
import sys

EMPTY = 0

class DirectedGraphNode():
    def __init__(self, label = None):
        self.label = label
        self.out_edges = set()
        self.in_edges = set()

    def connect_out(self, other):
        other.in_edges.append(self)
        self.out_edges.append(other)

    def connect_in(self, other):
        other.connect_out(self)

class DirectedGraph():
    def __init__(self):
        self.nodes = dict()

    def append(self, label):
        self.nodes[label] = DirectedGraphNode(label = label)

    def add_connection(self, source, dest):
        self.nodes[source].connect_out(self.nodes[dest])

# EBNF SUFFIXES have the following properties:
#
# QUESTION -> ONE OR ZERO
# STAR -> ONE OR ZERO
# PLUS -> ONE

class Expression():
    def __init__(self, alt_list):
        self.alternatives = [Alternative(alternative) for alternative in alt_list]

    def get_options(self, lookup_table):
        result = set()

        for alternative in self.alternatives:
            result = result.union(alternative.get_options(lookup_table))

        return result

class Alternative():
    def __init__(self, alternative):
        self.elements = [Element(el) for el in alternative.filter_children('element')]

    def get_options(self, lookup_table):
        element_options = [element.get_options(lookup_table) for element in self.elements]

        number_zeroable = sum(1 for element in element_options if EMPTY in element)

        # If everything can be the empty string,
        # Then we could take on the value of any of our children
        if number_zeroable == len(element_options):
            result = set()
            for options in element_options:
                result = result.union(options)
            return result

        # If only one thing can't be the empty string, we have exactly its options.
        elif number_zeroable == len(element_options) - 1:
            for option in element_options:
                if EMPTY not in option:
                    return option

        # Otherwise, there is no other single rule that we can be.
        else:
            return set()

class Element():
    def __init__(self, element):
        suffix = element.find_child('ebnfSuffix')
        if suffix is not None and suffix.children[0].type in ['QUESTION', 'STAR']:
            self.add_zero = True
        else:
            self.add_zero = False

        child = element.find_child('labeledElement')
        if child is not None:
            atom = child.find_child('atom')
            if atom is not None:
                self.child = Atom(atom)
                return

            block = child.find_child('block')
            if block is not None:
                self.child = Expression(block.find_child('altList').filter_children('alternative'))
                return

        child = element.find_child('atom')
        if child is not None:
            self.child = Atom(child)
            return

        child = element.find_child('ebnf')
        if child is not None:
            # EBNF can also have a suffix
            suffix = child.find_child('blockSuffix')
            if suffix is not None and suffix.find_child('ebnfSuffix').children[0].type in ['QUESTION', 'STAR']:
                self.add_zero = True

            # EBNF contains and additional expression
            self.child = Expression(child.find_child('block').find_child('altList').filter_children('alternative'))
            return

        self.child = None

    def get_options(self, lookup_table):
        if self.child is not None:
            result = self.child.get_options(lookup_table)
            if self.add_zero:
                result.add(EMPTY)
            return result
        else:
            return set()

class Atom():
    def __init__(self, atom):
        ruleref = atom.find_child('ruleref')
        if ruleref is not None:
            self.ruleref = ruleref.find_child('RULE_REF').text
        else:
            self.ruleref = None

    def get_options(self, lookup_table):
        if self.ruleref is not None:
            if lookup_table[self.ruleref]:
                return {self.ruleref, EMPTY}
            else:
                return {self.ruleref}
        else:
            return set()

# Get the rules from the grammar spec
def process(grammarSpec):
    graph = DirectedGraph()
    can_rule_be_empty = dict()

    # Search for the rule node
    for child in grammarSpec.children:
        if child.type == 'rules':
            rules = child

    # How many rules did we extract?
    # Get the array of rule names
    rule_names = set()
    rule_expressions = dict()
    for rule in rules.children:
        if rule.children[0].type == 'parserRuleSpec':
            parser_rule = rule.children[0]

            rule_name = parser_rule.find_child('RULE_REF').text
            rule_names.add(rule_name)

            alt_list = parser_rule.find_child('ruleBlock').find_child('ruleAltList')
            rule_expressions[rule_name] = Expression([el.find_child('alternative') for el in alt_list.filter_children('labeledAlt')])

    lookup_table = dict()
    for rule_name in rule_names:
        lookup_table[rule_name] = False

    connections = dict()
    for rule_name in rule_names:
        connections[rule_name] = set()

    # Keep updating the list of things that can be empty
    # until it does not change.
    changed = True
    while changed:
        changed = False
        for rule_name in rule_names:
            new_connections = rule_expressions[rule_name].get_options(lookup_table)
            if not changed and new_connections != connections[rule_name]:
                changed = True
            connections[rule_name] = new_connections

        for rule_name in rule_names:
            if EMPTY in connections[rule_name]:
                lookup_table[rule_name] = True

    print(lookup_table)

    return connections

# Raw parse tree nodes
class Node():
    def __init__(self, type, children):
        self.type = type
        self.children = children

    def dictify(self):
        return {"type": self.type, "children": [child.dictify() for child in self.children]}

    def find_child(self, type):
        for child in self.children:
            if child.type == type:
                return child
        return None

    def filter_children(self, type):
        result = []
        for child in self.children:
            if child.type == type:
                result.append(child)
        return result

class Token():
    def __init__(self, type, text):
        self.type = type
        self.text = text

    def dictify(self):
        return {"type": self.type, "text": self.text}

def format(tree):
    if isinstance(tree, ParserRuleContext):
        children = [format(child) for child in tree.getChildren()]
        return Node(
            tree.parser.ruleNames[tree.getRuleIndex()],
            children
        )
    else:
        return Token(
            tree.parentCtx.parser.symbolicNames[tree.symbol.type],
            tree.symbol.text
        )


# Main runtime
def main(argv):
    input = FileStream(argv[1])
    lexer = ANTLRv4Lexer(input)
    stream = CommonTokenStream(lexer)
    parser = ANTLRv4Parser(stream)
    parser.buildParseTrees = True
    tree = parser.grammarSpec()
    result = format(tree)

    connections = process(result)

    final_json = {}
    for rule in connections:
        final_json[rule] = list(connections[rule])

    print(json.dumps(final_json, indent=2))

if __name__ == "__main__":
    main(sys.argv)
