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
# Type		Description
# ----		-----------
# skip		skip this token (don't display it)
# comment	Mark as a code comment
#
#
############################################################

RULES = {
  # Indents (These elements should have indentation)
  'block': {
    'type': 'indent',
    'indexContext': 'blockStatement',
  },
  'classBody': {
    'type': 'indent',
    'indexContext': 'classBodyDeclaration',
  },

  ##### Skips (no block for these elements in the tree)
  # Parsing artifacts
  'compilationUnit': 'skip',

  # Type wrappers
  'typeName': 'skip',
  'modifier': 'skip',
  'classDeclaration': 'skip',
  'memberDeclaration': 'skip',
  'methodDeclaration': 'skip',
  'typeTypeOrVoid': 'skip',

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

  #Type wrappers

  ##### Sockets (We can put or type stuff here)
  # Import directives
  
  # Variables / constants / typenames / literals
  'IDENTIFIER': 'socket',
  'qualifiedName': 'socket',
  'typeType': 'socket',
  'literal': 'socket',

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

  #### What about these?: ENUM, INTERFACE, EXTENDS, IMPLEMENTS

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
  'primary'
]
config = {
  RULES, COLOR_RULES, SHAPE_RULES, COLOR_CALLBACK, SHAPE_CALLBACK, COLOR_DEFAULTS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET
#  RULES, INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLOR_RULES, COLOR_DEFAULTS, COLOR_CALLBACK, COLORS_BACKWARD, SHAPE_RULES, SHAPE_CALLBACK
}

#config.PAREN_RULES = {
#  'statement'
#  'blockStatement'
#  'localVariableDeclarationStatement'
#  'primary'
#}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
