# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

INDENTS = ['compoundStatement']
SKIPS = ['blockItemList',
  'compilationUnit',
  'declarator',
  'directDeclarator',
  'parameterTypeList',
  'parameterList',
  'argumentExpressionList',
  'initDeclaratorList']
PARENS = ['expressionStatement', 'primaryExpression']
SOCKET_TOKENS = ['Identifier', 'StringLiteral', 'Constant']
COLORS_FORWARD = {
  'statement': 'command'
  'selectionStatement': 'control'
  'iterationStatement': 'control'
  'functionDefinition': 'control'
  'expression': 'value'
  'additiveExpression': 'value'
  'multiplicativeExpression': 'value'
  'declaration': 'command'
  'parameterDeclaration': 'command'
}
COLORS_BACKWARD = {
  'iterationStatement': 'control'
  'selectionStatement': 'control'
  'postfixExpression': 'command'
  'assignmentExpression': 'command'
  'relationalExpression': 'value'
  'initDeclarator': 'command'
}

config = {
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD, PLAIN_SOCKETS: [], VALUE_TYPES: [], BLOCK_TYPES: [], BLOCK_TOKENS: []
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'C', config
