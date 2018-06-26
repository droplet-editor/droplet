# Droplet C# mode
#
# Copyright (c) 2018 Kevin Jessup
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

model = require '../model.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

ADD_BUTTON = [
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

SUBTRACT_BUTTON = [
  {
    key: 'subtract-button'
    glyph: '\u25C0'
    border: false
  }
]

BOTH_BUTTON = [
  {
    key: 'subtract-button'
    glyph: '\u25C0'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

ADD_BUTTON_VERT = [
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_VERT = [
  {
    key: 'subtract-button'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

RULES = {
  # tell model to indent blocks within the main part of a n
  # namespace body (indent everything past namespace_member_declarations)
  'namespace_body': {
    'type': 'indent',
    'indexContext': 'namespace_member_declarations',
  },

  'class_body': {
    'type': 'indent',
    'indexContext': 'class_member_declaration',
  },

  'block': {
    'type' : 'indent',
    'indexContext': 'statement',
  },

  # Skips : no block for these elements
  'compilationUnit' : 'skip',
  'using_directives' : 'skip',
  'namespace_or_type_name' : 'skip',
  'namespace_member_declarations' : 'skip',
  'namespace_member_declaration' : 'skip',
  'class_definition' : 'skip',
  'class_member_declarations' : 'skip',
  'class_member_declaration' : 'skip',
  'common_member_declaration' : 'skip',
  'constructor_declaration' : 'skip',
  'all_member_modifiers' : 'skip',
  'all_member_modifier' : 'skip',
  'qualified_identifier' : 'skip',
  'field_declaration' : 'skip',
  'method_declaration' : 'skip',
  'method_body' : 'skip',
  'method_member_name' : 'skip',
  'variable_declarators' : 'skip',
  'variable_declarator' : 'skip',
  'var_type' : 'skip',
  'base_type' : 'skip',
  'class_type' : 'skip',
  'simple_type' : 'skip',
  'numeric_type' : 'skip',
  'integral_type' : 'skip',
  'floating_point_type' : 'skip',
  '=' : 'skip',
  'OPEN_PARENS' : 'skip',
  'CLOSE_PARENS' : 'skip',
  ';' : 'skip',
  'statement_list' : 'skip',
  'PARAMS' : 'skip',
  'array_type' : 'skip',
  'rank_specifier' : 'skip',
  'fixed_parameters' : 'skip',
  'fixed_parameter' : 'skip',

  # Parens : defines nodes that can have parenthesis in them
  # (used to wrap parenthesis in a block with the
  # expression that is inside them, instead
  # of having the parenthesis be a block with a
  # socket that holds an expression)
  'primary_expression_start' : 'parens',

  # Sockets : can be used to enter inputs into a form or specify dropdowns
  'IDENTIFIER' : 'socket',
  'NEW' : 'socket',
  'PUBLIC' : 'socket',
  'PROTECTED' : 'socket',
  'INTERNAL' : 'socket',
  'PRIVATE' : 'socket',
  'READONLY' : 'socket',
  'VOLATILE' : 'socket',
  'VIRTUAL' : 'socket',
  'SEALED' : 'socket',
  'OVERRIDE' : 'socket',
  'ABSTRACT' : 'socket',
  'STATIC' : 'socket',
  'UNSAFE' : 'socket',
  'EXTERN' : 'socket',
  'PARTIAL' : 'socket',
  'ASYNC' : 'socket',

  'SBYTE' : 'socket',
  'BYTE' : 'socket',
  'SHORT' : 'socket',
  'USHORT' : 'socket',
  'INT' : 'socket',
  'UINT' : 'socket',
  'LONG' : 'socket',
  'ULONG' : 'socket',
  'CHAR' : 'socket',
  'FLOAT' : 'socket',
  'DOUBLE' : 'socket',
  'DECIMAL' : 'socket',
  'BOOL' : 'socket',

  'VOID' : 'socket',

  'INTEGER_LITERAL' : 'socket',
  'HEX_INTEGER_LITERAL' : 'socket',
  'REAL_LITERAL' : 'socket',
  'CHARACTER_LITERAL' : 'socket',
  'NULL' : 'socket',
  'REGULAR_STRING' : 'socket',
  'VERBATIUM_STRING' : 'socket',
  'TRUE' : 'socket',
  'FALSE' : 'socket',

  # buttonContainer: defines a node that acts as
  # a "button" that can be placed inside of another block (these nodes generally should not
  # be able to be "by themselves", and wont be blocks if they are by themselves)
  'formal_parameter_list' : (node) ->
    if (node.children[node.children.length-1].type is 'parameter_array')
      return {type : 'buttonContainer', buttons : SUBTRACT_BUTTON}
    else
      if (node.children[0].children.length == 1)
        return {type : 'buttonContainer', buttons : ADD_BUTTON}
      else
        return {type : 'buttonContainer', buttons : BOTH_BUTTON}

  #### special: require functions to process blocks based on context/position in AST ####

  # need to skip the block that defines a class if there are class modifiers for the class
  # (will not detect a class with no modifiers otherwise)
  'class_definition' : (node) ->
    if (node.parent?)
      if (node.parent.type is 'type_declaration') and (node.parent.children.length > 1)
        return 'skip'
      else if (node.parent.type is 'type_declaration') and (node.parent.children.length == 1)
        return 'block'
    else
      return 'skip'

  # need to process class variable/method declarations so these blocks can have the arrow buttons that
  # lets one add or remove variable declarations/input parameters by clicking on those arrows
  # NOTE: the handleButton function in this file determines the behavior for what
  # happens when a button is pressed
  'typed_member_declaration' : (node) ->
    # variable declaration
    if (node.children[1].type is 'field_declaration')
      field_decl_node = node.children[1]

      if (field_decl_node.children[0].children.length == 1)
        return {type : 'block', buttons : ADD_BUTTON}
      else if (field_decl_node.children[0].children.length > 1)
        return {type : 'block', buttons : BOTH_BUTTON}

    # method declaration
    else if (node.children[1].type is 'method_declaration')
      return 'block'

    else
      return 'skip'
}

# Used to color nodes
# See view.coffee for a list of colors
COLOR_RULES = {
  'using_directive' : 'using',
  'namespace_declaration' : 'namespace',

  'type_declaration' : 'type',
  'class_definition' : 'type',

  'parameter_array' : 'variable',
  'arg_declaration' : 'variable',

  'expression' : 'expression',
  'assignment' : 'expression',
  'non_assignment_expression' : 'expression',
  'lambda_expression' : 'expression',
  'query_expression' : 'expression',
  'conditional_expression' : 'expression',
  'null_coalescing_expression' : 'expression',
  'conditional_or_expression' : 'expression',
  'conditional_and_expression' : 'expression',
  'inclusive_or_expression' : 'expression',
  'exclusive_or_expression' : 'expression',
  'and_expression' : 'expression',
  'equality_expression' : 'expression',
  'relational_expression' : 'expression',
  'shift_expression' : 'expression',
  'additive_expression' : 'expression',
  'multiplicative_expression' : 'expression',
  'unary_expression' : 'expression',
  'primary_expression' : 'expression',
  'primary_expression_start' : 'expression',
}

# defines categories for different colors, for better reusability
COLOR_DEFAULTS = {
  'using' : 'purple'
  'namespace' : 'green'
  'type' : 'lightblue'
  'variable' : 'yellow'
  'expression' : 'deeporange'
  'method' : 'indigo'
  'comment' : 'grey'
}

# still not exactly sure what this section does, or what the helper does
SHAPE_RULES = {
  'initializer' : helper.BLOCK_ONLY,

  'expression' : helper.VALUE_ONLY,
  'assignment' : helper.VALUE_ONLY,
  'non_assignment_expression' : helper.VALUE_ONLY,
  'lambda_expression' : helper.VALUE_ONLY,
  'query_expression' : helper.VALUE_ONLY,
  'conditional_expression' : helper.VALUE_ONLY,
  'null_coalescing_expression' : helper.VALUE_ONLY,
  'conditional_or_expression' : helper.VALUE_ONLY,
  'conditional_and_expression' : helper.VALUE_ONLY,
  'inclusive_or_expression' : helper.VALUE_ONLY,
  'exclusive_or_expression' : helper.VALUE_ONLY,
  'and_expression' : helper.VALUE_ONLY,
  'equality_expression' : helper.VALUE_ONLY,
  'relational_expression' : helper.VALUE_ONLY,
  'shift_expression' : helper.VALUE_ONLY,
  'additive_expression' : helper.VALUE_ONLY,
  'multiplicative_expression' : helper.VALUE_ONLY,
  'unary_expression' : helper.VALUE_ONLY,
  'primary_expression' : helper.VALUE_ONLY,
  'primary_expression_start' : helper.VALUE_ONLY,
}

# defines what string one should put in an empty socket when going
# from blocks to text (these can be any string, it seems)
# also allows any of the below nodes with these strings to be transformed
# into empty sockets when going from text to blocks (I think)
EMPTY_STRINGS = {
  'IDENTIFIER' : '_',
  'INTEGER_LITERAL' : '_',
  'HEX_INTEGER_LITERAL' : '_',
  'REAL_LITERAL' : '_',
  'CHARACTER_LITERAL' : '_',
  'NULL' : '_',
  'REGULAR_STRING' : '_',
  'VERBATIUM_STRING' : '_',
  'TRUE' : '_',
  'FALSE' : '_',
  'arg_declaration' : '_',
}

# defines an empty character that is created when a block is dragged out of a socket
empty = '_'

emptyIndent = ''

ADD_PARENS = (leading, trailing, node, context) ->
  leading '(' + leading()
  trailing trailing() + ')'

ADD_SEMICOLON = (leading, trailing, node, context) ->
  trailing trailing() + ';'

REMOVE_SEMICOLON = (leading, trailing, node, context) ->
  trailing trailing().replace /\s*;\s*$/, ''

# helps control what can and cannot go into a socket?
PAREN_RULES = {
#  'primary_expression': {
#    'expression': ADD_PARENS
#  },
#  'primary_expression': {
#    'literal': ADD_SEMICOLON
#  }
#  'postfixExpression': {
#    'specialMethodCall': REMOVE_SEMICOLON
#  }
}

SHAPE_CALLBACK = {

}

# defines any nodes that are to be turned into different kinds of dropdown menus;
# the choices for those dropdowns are defined by the items to the left of the semicolon
# these are used only if you aren't using the SHOULD_SOCKET function it seems?
DROPDOWNS = {

}

MODIFIERS = [
  'public',
  'private',
  'protected',
  'internal',
]

CLASS_MODIFIERS = MODIFIERS.concat([
  'abstract',
  'static',
  'partial',
  'sealed',
])

SIMPLE_TYPES = [
  'sbyte',
  'byte',
  'short',
  'ushort',
  'int',
  'uint',
  'long',
  'ulong',
  'char',
  'float',
  'double',
  'decimal',
  'bool',
]

# defines behavior for adding a locked socket + dropdown menu for class modifiers
# NOTE: any node/token that can/should be turned into a dropdown must be defined as a socket,
# like in the "rules" section
SHOULD_SOCKET = (opts, node) ->
  if(node.type in ['PUBLIC', 'PRIVATE', 'PROTECTED', 'INTERNAL', 'ABSTRACT', 'STATIC', 'PARTIAL', 'SEALED'])
    if (node.parent.type is 'using_directive') # skip the static keyword for static using directives
      return 'skip'
    else
      return {
        type: 'locked',
        dropdown: CLASS_MODIFIERS
      }

  # adds a locked socket for variable type specifiers (for simple types)
  else if(node.type in ['SBYTE', 'BYTE', 'SHORT', 'USHORT', 'INT', 'UINT', 'LONG', 'ULONG', 'CHAR', 'FLOAT', 'DOUBLE', 'DECIMAL', 'BOOL'])
    return {
      type: 'locked',
      dropdown: SIMPLE_TYPES
    }

  # return true by default (don't know why we do this)
  return true

# defines behavior for what happens if we click a button in a block (like for
# clicking the arrow buttons in a variable assignment block)
handleButton = (str, type, block) ->
  blockType = block.nodeContext?.type ? block.parseContext

  if (type is 'add-button')
    if (blockType is 'typed_member_declaration')
      newStr = str.slice(0, str.length-1) + ", _ = _;"

      return newStr

    else if (blockType is 'formal_parameter_list')

      newStr = str + ", int param1"

      return newStr

  else if (type is 'subtract-button')
    if (blockType is 'typed_member_declaration')
      newStr = str.slice(0, str.lastIndexOf(",")) + ";"

      return newStr

    else if (blockType is 'formal_parameter_list')
      lastCommaIndex = str.lastIndexOf(",")

      if (lastCommaIndex == -1)
        return "_"

      newStr = str.substring(0, lastCommaIndex)

      return newStr

  return str

# allows us to color the same node in different ways given different
# contexts for it in the AST
COLOR_CALLBACK = (opts, node) ->
  if (node.type is 'typed_member_declaration')
    if (node.children[1].type is 'field_declaration')
      return 'variable'
    else if (node.children[1].type is 'method_declaration')
      return 'method'
    else return 'comment'

  return null

config = {
  RULES,
  COLOR_DEFAULTS,
  COLOR_RULES,
  SHAPE_RULES,
  SHAPE_CALLBACK,
  EMPTY_STRINGS,
  COLOR_DEFAULTS,
  DROPDOWNS,
  EMPTY_STRINGS,
  empty,
  emptyIndent,
  PAREN_RULES,
  SHOULD_SOCKET,
  handleButton,
  COLOR_CALLBACK
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config