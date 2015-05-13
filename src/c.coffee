# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-parser', 'droplet-antlr-parser'], (parser, antlrHelper) ->
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
    INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD
  }

  return parser.wrapParser antlrHelper.createANTLRParser config, 'C'
