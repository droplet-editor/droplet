# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-parser', 'droplet-antlr-parser'], (parser, antlrHelper) ->
  INDENTS = ['block', 'classBody']
  SKIPS = ['compilationUnit',
    'classDeclaration',
    'memberDeclaration',
    'constructorDeclaration',
    'methodDeclaration',
    'formalParameters',
    'formalParameterList'
  ]
  PARENS = [
    'statement'
    'primary'
  ]
  SOCKET_TOKENS = [
    'Identifier'
    'IntegerLiteral'
    'StringLiteral'
  ]
  COLORS_FORWARD = {
    'typeDeclaration': 'control'
    'classBodyDeclaration': 'control'
    'variableDeclarator': 'command'
    'formalParameter': 'command'
    'statementExpression': 'command'
    'expression': 'value'
  }
  COLORS_BACKWARD = {}

  config = {
    INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD
  }

  return parser.wrapParser antlrHelper.createANTLRParser config, 'Java'
