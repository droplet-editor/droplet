# Droplet Java mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

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

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
