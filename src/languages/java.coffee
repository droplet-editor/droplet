# Droplet Java mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License
# Updated 2018 Jeremiah Blanchard

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

############################################################
# Rules tell Droplet what to do with different markers.
#
# ### Format: 'tokenName': 'type' ###
#
# Type			Description
# ----			-----------
# skip			skip this token (don't display it)
# comment		Mark as a code comment
# parens		???
# block			An actual block
# indent		Node that marks indentation
# socket                Location for input
# buttonContainer
# lockedSocket
# document


  # Parens : defines nodes that can have parenthesis in them
  # (used to wrap parenthesis in a block with the
  # expression that is inside them, instead
  # of having the parenthesis be a block with a
  # socket that holds an expression)

  # buttonContainer: defines a node that acts as
  # a "button" that can be placed inside of another block (these nodes generally should not
  # be able to be "by themselves", and wont be blocks if they are by themselves)
  # NOTE: the handleButton function in this file determines the behavior for what
  # happens when one of these buttons is pressed

#
############################################################

RULES = {
  # Indents (These elements should have indentation)
  'classBody': {
    'type': 'indent',
    'indexContext': 'classBodyDeclaration',
  },
  'block': {
    'type': 'indent',
    'indexContext': 'blockStatement',
  },

  # Parens

  ##### Skips (no block for these elements in the tree)
  # Parsing artifacts
  'compilationUnit': 'skip',

  # Modifier wrappers
  'classOrInterfaceModifier': 'skip',
  'modifier': 'skip',

  # Type wrappers
  'classDeclaration': 'skip',
  'memberDeclaration': 'skip',
  'methodDeclaration': 'skip',
  'fieldDeclaration': 'skip',
  'typeTypeOrVoid': 'skip',
  'typeName': 'skip',

  # Method wrappers
  'formalParameterList': 'skip',
  'formalParameters': 'skip',
  'formalParameter': 'skip',
  'methodBody': 'skip',
  'methodCall': 'skip',
  'expressionList': 'skip',

  # Statement wrappers
  'expression': 'skip',
  'localVariableDeclaration': 'skip',
  'variableDeclarators': 'skip',
  'variableDeclarator': 'skip',
  'variableDeclaratorId': 'skip',
  'literal': 'skip',

  # Type wrappers

  # Sockets (We can put or type stuff here)
  # Import directives
  
  # Variables / constants / typenames / literals
  'IDENTIFIER': 'socket',
  'qualifiedName': 'socket',
  'typeType': 'socket',
  'STRING_LITERAL': 'socket',

  # General modifiers (methods, variables, classes, etc)
  'PRIVATE': 'socket',
  'PROTECTED': 'socket',
  'PUBLIC': 'socket',
  'STATIC': 'socket',
  'FINAL': 'socket',

  # Class modifiers (classes only)
  'ABSTRACT': 'socket',

  # Interface method modifiers (interface methods only)
  'DEFAULT': 'socket', # WARNING: TODO: this clashes with "default" for switch statements

  # Method modifiers
  'SYNCHRONIZED': 'socket',
  'NATIVE': 'socket',
  
  # Field modifiers
  #'CONST': 'socket', Not actually a keyword - just reserved?
  'VOLATILE': 'socket',

  # Primitive types
  'BOOLEAN': 'socket',
  'BYTE': 'socket',
  'CHAR': 'socket',
  'DOUBLE': 'socket',
  'FLOAT': 'socket',
  'INT': 'socket',
  'LONG': 'socket',
  'SHORT': 'socket',
  'VOID': 'socket',

  # Object types
  'CLASS': 'socket',

  #### What about these?: ENUM, INTERFACE, EXTENDS, IMPLEMENTS

  # Blocks
  'classBodyDeclaration': 'block',
  'typeDeclaration': 'block',


}

###################################################################
# Color rules tell Droplet what color-type each token should use.
#
# ### Format: 'tokenName': 'tokenStyle' ###
#
#
# Styles
# ------
#
#
####################################################################

COLOR_RULES = {
  # Import declarations
  'importDeclaration': 'import',

  # Object-types and methods
  'typeDeclaration': 'type',
  'classBodyDeclaration': 'class',
  'methodDeclaration': 'class',
  'fieldDeclaration': 'class',
  'blockStatement': 'statement',
  'statement': 'statement',
#  'localVariableDeclarationStatement': 'statement',

  # Variables
  
#  'variableDeclarator': 'command'
#  'formalParameter': 'command'
#  'statementExpression': 'command'
#  'expression': 'value'
}

# Acceptance mapping is [drag][drop]
ACCEPT_MAPPING =
{
  'statement': {
    'document': helper.FORBID,
    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'IDENTIFIER': helper.DISCOURAGE,

    'classBodyDeclaration': helper.ENCOURAGE,
  },

}

getType = (block) ->
  if block.parseContext?
    return block.parseContext
  if block.nodeContext?
    return block.nodeContext.type
  if block.type == "indent"
    return block.parentParseContext
  return block.type

# defines behavior for what happens if we try to drop a block
handleAcceptance = (block, context, pred, next) ->
  dragType = getType(block)
  dropType = getType(context)

  if !dragType? || dragType == null
    console.log "Could not extract block type: " + helper.noCycleStringify(block)
    return null

  if !dropType? || dropType == null
    console.log "Could not extract context type: " + helper.noCycleStringify(context)
    return null

  if ACCEPT_MAPPING[dragType]? && ACCEPT_MAPPING[dragType][dropType]?
      return ACCEPT_MAPPING[dragType][dropType]

  console.log "Uncaught context: " + helper.noCycleStringify(context)
#  return null
  return helper.FORBID


SHAPE_RULES = { }

# Use a callback function to determine the color/shape of a construct
COLOR_CALLBACK = { }
SHAPE_CALLBACK = { }

# Default colors for various token types
COLOR_DEFAULTS = {
  'type': 'purple',
  'import': 'grey',
  'class': 'blue',
  'statement': 'green',
 }

# Dropdown menu setup
MODIFIERS = [
  'private',
  'protected',
  'public',
  'static',
  'final',
]

CLASS_MODS = MODIFIERS.concat([
  'abstract',
])

METHOD_MODS = MODIFIERS.concat([
  'synchronized',
  'native',
])

# Basic types
BASIC_TYPES = [
  'byte',
  'short',
  'int',
  'long',
  'float',
  'double',
  'char',
  'boolean',
  'String'
]

RETURN_TYPES = BASIC_TYPES.concat([
  'void',
])

DROPDOWNS = {
  'typeType': BASIC_TYPES,
  'classOrInterfaceModifier': CLASS_MODS,
  'modifier': METHOD_MODS,
  'typeTypeOrVoid': RETURN_TYPES,
  
} # Dropdown types? See C file for clues

EMPTY_STRINGS = { } # Empty string representations? See other languages and code for clues

SHOULD_SOCKET = (opts, node) ->
  return true

PARENS = [
  'statement'
#  'primary'
]
config = {
  RULES, COLOR_RULES, SHAPE_RULES, COLOR_CALLBACK, SHAPE_CALLBACK, COLOR_DEFAULTS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET, handleAcceptance
#  RULES, INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLOR_RULES, COLOR_DEFAULTS, COLOR_CALLBACK, COLORS_BACKWARD, SHAPE_RULES, SHAPE_CALLBACK
}

#config.PAREN_RULES = {
#  'statement'
#  'blockStatement'
#  'localVariableDeclarationStatement'
#  'primary'
#}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
