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
    'indexContext': 'blockStatements',
  },
  'classBody': {
    'type': 'indent',
    'indexContext': 'classBodyDeclaration',
  },

  ##### Skips (no block for these elements in the tree)
  # Parsing artifacts
  'compilationUnit': 'skip',
  'ordinaryCompilation': 'skip',

  # Import wrappers
  'importDeclaration': 'skip',
  'packageOrTypeName': 'skip',

  # Type wrappers
  'typeName': 'skip',
  'typeDeclaration': 'skip',
  'classDeclaration': 'skip',
  'classBodyDeclaration': 'skip',
  'classMemberDeclaration': 'skip',

  # Method wrappers
  'methodHeader': 'skip',
  'methodDeclarator': 'skip',
  'formalParameterList': 'skip',
  'lastFormalParameter': 'skip',
  'formalParameter': 'skip',
  'methodBody': 'skip',

  # Statement wrappers
  'blockStatement': 'skip',
  'blockStatements': 'skip',
  'localVariableDeclaration': 'skip',
  'variableDeclarator': 'skip',
  'variableDeclaratorId': 'skip',
  'statementWithoutTrailingSubstatement': 'skip',
  'expressionStatement': 'skip',
  'statementExpression': 'skip',


  #Type wrappers
  'unannPrimitiveType': 'skip',
  'unannReferenceType': 'skip',
  'unannArrayType': 'skip',
  'unannClassOrInterfaceType': 'socket',
  'unannClassType_lfno_unannClassOrInterfaceType': 'skip',
  'numericType': 'skip',
  'integralType': 'skip',
  'dims': 'skip',

  ##### Sockets (We can put or type stuff here)
  # Import directives
  
  # Variables / typenames
  'Identifier': 'socket',
  'unannArrayType': 'socket',
  'integralType': 'socket',

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

  'literal': 'socket',
  #### What about these?: ENUM, INTERFACE, EXTENDS, IMPLEMENTS

#  'modularCompilation': 'skip',
#  'variableDeclarators': 'skip',
#  'variableDeclarator': 'skip',
#  'constructorDeclaration',: 'skip',
#  'formalParameters',: 'skip',
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
  'singleTypeImportDeclaration': 'import',
  'typeImportOnDemandDeclaration': 'import',
  'singleStaticImportDeclaration': 'import',
  'staticImportOnDemandDeclaration': 'import',

  # Object-types and methods
  'normalClassDeclaration': 'class',
  'methodDeclaration': 'method',
  'localVariableDeclarationStatement': 'statement',

  # Variables
  
#  'importDeclaration': 'command',
#  'statement': 'control'
#  'variableDeclarator': 'command'
#  'formalParameter': 'command'
#  'statementExpression': 'command'
#  'blockStatement': 'command'
#  'expression': 'value'
}

SHAPE_RULES = { }

# Use a callback function to determine the color/shape of a construct
COLOR_CALLBACK = { }
SHAPE_CALLBACK = { }

# Default colors for various token types
COLOR_DEFAULTS = {
  'class': 'purple',
  'import': 'grey',
  'method': 'blue',
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
  'unannType': BASIC_TYPES,
  'classModifier': CLASS_MODS,
  'methodModifier': METHOD_MODS,
  'result': RETURN_TYPES,
  
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
