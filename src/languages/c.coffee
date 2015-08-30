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
SOCKET_TOKENS = ['Identifier', 'StringLiteral', 'Constant', 'Int', 'Long','Double', 'Short', 'Signed', 'Void', 'Char']
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
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD, PLAIN_SOCKETS: [],
  VALUE_TYPES: ['expression'], BLOCK_TYPES: ['statement'],
  BLOCK_TOKENS: [],
  INDENT_START_EXCLUDE_TOKEN: 'LeftBrace', INDENT_END_EXCLUDE_TOKEN: 'RightBrace'
}

wrappedParser = parser.wrapParser antlrHelper.createANTLRParser 'C', config
wrappedParser.parens =  (leading, trailing, node, context) ->
  if context?.type is 'socket'
    trailing trailing().replace(/;?\s*$/, '')
  else
    trailing trailing().replace(/;?\s*$/, ';')
module.exports = wrappedParser
