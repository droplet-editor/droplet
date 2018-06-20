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
  # tell parser to indent blocks within the main part of a namespace body (indent everything past namespace_member_declarations)
  'namespace_body': {
    'type': 'indent',
    'indexContext': 'namespace_member_declaration',
  },

  'class_body': {
    'type': 'indent',
    'indexContext': 'class_member_declaration',
  },

  # Skips : no block for these elements
  'compilationUnit' : 'skip',
  'using_directives' : 'skip',
  'namespace_or_type_name' : 'skip',
  'namespace_member_declarations' : 'skip',
  'namespace_member_declaration' : 'skip',
  'class_definition' : 'skip', # TODO: maybe have to get rid if we need to have separate logic for class defs vs. enums, for example
  'class_member_declarations' : 'skip',
  'class_member_declaration' : 'skip',
  'common_member_declaration' : 'skip',
  'all_member_modifiers' : 'skip',
  'all_member_modifier' : 'skip',
  'qualified_identifier' : 'skip', # TODO: this may cause conflicts later (originally done for namespace names like "foo.bar")
  'field_declaration' : 'skip',
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
  'assignment' : 'skip',
  'non_assignment_expression' : 'skip',
  'lambda_expression' : 'skip',
  'query_expression' : 'skip',
  'conditional_expression' : 'skip',
  'null_coalescing_expression' : 'skip',
  'conditional_or_expression' : 'skip',
  'conditional_and_expression' : 'skip',
  'inclusive_or_expression' : 'skip',
  'exclusive_or_expression' : 'skip',
  'and_expression' : 'skip',
  'equality_expression' : 'skip',
  'relational_expression' : 'skip',
  'shift_expression' : 'skip',
  'additive_expression' : 'skip',
  'multiplicative_expression' : 'skip',
  'unary_expression' : 'skip',
  'primary_expression' : 'skip',
  'primary_expression_start' : 'skip',

  # Sockets : can be used to enter inputs into a form or specify types
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

  'INTEGER_LITERAL' : 'socket',
  'HEX_INTEGER_LITERAL' : 'socket',
  'REAL_LITERAL' : 'socket',
  'CHARACTER_LITERAL' : 'socket',
  'NULL' : 'socket',
  'REGULAR_STRING' : 'socket',
  'VERBATIUM_STRING' : 'socket',
  'TRUE' : 'socket',
  'FALSE' : 'socket',

  #'VAR' : 'socket', # TODO: add vars

  #### special: require functions to process blocks based on context/position in AST ####

  # need to skip the block that defines a class if there are class modifiers for the class
  # (will not detect a class with no modifiers otherwise)
  'class_definition' : (node) ->
    if (node.parent?)
      if (node.parent.type is 'type_declaration') and (node.parent.children.length > 1)
        return 'skip'
      else if (node.parent.type is 'type_declaration') and (node.parent.children.length == 1)
        return {type : 'block'}
    else
      return 'skip'

  # need to process class variable declarations so these blocks can have the arrow buttons that
  # lets one add or remove variable names/declarations by clicking on those arrows
  # NOTE: the handleButton function in this file determines the behavior for what
  # happens when either the ADD_BUTTON or BOTH_BUTTON is pressed
  'typed_member_declaration' : (node) ->
    if (node.children[1].children[0].children.length == 1)
      return {type: 'block', buttons: ADD_BUTTON}
    else if (node.children[1].children[0].children.length > 1)
      return {type: 'block', buttons: BOTH_BUTTON}
    else
      return 'block'
}

# Used to color nodes
# See view.coffee for a list of colors
COLOR_RULES = {
  'using_directive' : 'using',
  'namespace_declaration' : 'namespace',
  'type_declaration' : 'type',
  'class_definition' : 'type',
  'typed_member_declaration' : 'variable'
  'expression' : 'expression'
}

# defines categories for different colors, for better reusability
COLOR_DEFAULTS = {
  'using' : 'purple'
  'namespace' : 'green'
  'type' : 'lightblue'
  'variable' : 'yellow'
  'expression' : 'deeporange'
}

SHAPE_RULES = {
  'typed_member_declaration' : helper.BLOCK_ONLY,
  'expression' : helper.VALUE_ONLY,
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
}

# defines an empty character to be used
# in various functions in this language file (like handleButton)
# done for reusability's sake
EMPTY = {
  '_'
}

COLOR_CALLBACK = {

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

PARENS = [

]

SHOULD_SOCKET = (opts, node) ->
  # defines behavior for adding a locked socket + dropdown menu for class modifiers
  # NOTE: any node/token that can/should be turned into a dropdown must be defined as a socket,
  # like in the "rules" section
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
      newStr = str.replace(";", ", _ = _;")

      return newStr

  else if (type is 'subtract-button')
    if (blockType is 'typed_member_declaration')
      newStr = str.slice(0, str.lastIndexOf(",")) + ";"

      return newStr

  return str

config = {
  RULES,
  COLOR_DEFAULTS,
  COLOR_RULES,
  COLOR_CALLBACK,
  SHAPE_RULES,
  SHAPE_CALLBACK,
  EMPTY_STRINGS,
  COLOR_DEFAULTS,
  DROPDOWNS,
  EMPTY_STRINGS,
  PARENS,
  SHOULD_SOCKET,
  handleButton
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config