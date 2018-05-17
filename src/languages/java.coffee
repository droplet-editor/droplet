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

#RULES = {
  # Skips
#  'compilationUnit': 'skip',
#  'ordinaryCompilation': 'skip',
#  'modularCompilation': 'skip',
#  'variableDeclarators': 'skip',
#  'variableDeclarator': 'skip',
#  'classDeclaration',: 'skip',
#  'memberDeclaration',: 'skip',
#  'constructorDeclaration',: 'skip',
#  'methodDeclaration',: 'skip',
#  'formalParameters',: 'skip',
#  'formalParameterList': 'skip' 
#}

INDENTS = ['block', 'classBody']

SKIPS = ['compilationUnit',
  'variableDeclarators'
  'variableDeclarator'
  'classDeclaration',
  'memberDeclaration',
  'constructorDeclaration',
  'methodDeclaration',
  'formalParameters',
  'formalParameterList'
]

PARENS = [
  'statement'
  'blockStatement'
  'localVariableDeclarationStatement'
  'primary'
]

SOCKET_TOKENS = [
  'Identifier'
  'IntegerLiteral'
  'StringLiteral'
]

COLOR_DEFAULTS = {
}

COLORS_FORWARD = {
  'statement': 'control'
  'typeDeclaration': 'control'
  'classBodyDeclaration': 'control'
  'variableDeclarator': 'command'
  'formalParameter': 'command'
  'statementExpression': 'command'
  'blockStatement': 'command'
  'expression': 'value'
}
COLORS_BACKWARD = {}

config = {
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD,
}

#config.PAREN_RULES = {
#  'statement'
#  'blockStatement'
#  'localVariableDeclarationStatement'
#  'primary'
#}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
