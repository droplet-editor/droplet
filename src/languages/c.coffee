# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

INDENTS = ['compoundStatement', 'structDeclarationsBlock']
SKIPS = ['blockItemList',
  'macroParamList',
  'compilationUnit',
  'translationUnit',
  'declarationSpecifiers',
  'declarationSpecifier',
  'typeSpecifier',
  'structOrUnionSpecifier',
  'structDeclarationList',
  'declarator',
  'directDeclarator',
  'parameterTypeList',
  'parameterList',
  'argumentExpressionList',
  'initDeclaratorList']
PARENS = ['expressionStatement', 'primaryExpression', 'structDeclaration']
SOCKET_TOKENS = ['Identifier', 'StringLiteral', 'SharedIncludeLiteral', 'Constant']
COLORS_FORWARD = {
  'externalDeclaration': 'control'
  'structDeclaration': 'command'
  'declarationSpecifier': 'control'
  'statement': 'command'
  'selectionStatement': 'control'
  'iterationStatement': 'control'
  'functionDefinition': 'control'
  'expression': 'value'
  'additiveExpression': 'value'
  'multiplicativeExpression': 'value'
  'declaration': 'command'
  'parameterDeclaration': 'command'
  'unaryExpression': 'value'
  'typeName': 'value'
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
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD
}

config.parenRules = {
  'primaryExpression': {
    'expression': (leading, trailing, node, context) ->
      leading '(' + leading()
      trailing trailing() + ')'
  }
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'C', config
