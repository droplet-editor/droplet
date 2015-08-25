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
  'memberDeclaration',
  'constructorDeclaration',
  'methodDeclaration',
  'formalParameters',
  'formalParameterList',
  'forControl',
  'switchBlockStatementGroup'
  'switchLabel',
  'expressionList',
  'finallyBlock',
  'arguments',
  'classCreatorRest',
  'qualifiedName',
  'creator',
  'classOrInterfaceModifier',
  'modifier',
  'catchClause'
]
PARENS = [
  'statement'
  'typeDeclaration'
  'blockStatement'
  'localVariableDeclarationStatement'
  'primary'
  'parExpression'
  'classBodyDeclaration'
]
SOCKET_TOKENS = [
  'Identifier'
  'IntegerLiteral'
  'FloatingPointLiteral'
  'CharacterLiteral'
  'StringLiteral'
  'NullLiteral'
  'BooleanLiteral'
  'THIS'
]
BLOCK_TOKENS = [
  'BREAK'
]
PLAIN_SOCKETS = [
  'importName'
]
COLORS_FORWARD = {
  'statement': 'command'
  'typeDeclaration': 'control'
  'classBodyDeclaration': 'control'
  'variableDeclarator': 'command'
  'formalParameter': 'command'
  'statementExpression': 'command'
  'blockStatement': 'command'
  'expression': 'value'
  'localVariableDeclaration': 'command'
  'importDeclaration': 'command'
  'memberDeclaration': 'command'
  'packageDeclaration': 'command'
  'type': 'value'
  'createdName': 'value'
  'classDeclaration': 'control'
}
COLORS_BACKWARD = {
  'controlStatement': 'control'
  'terminalStatement': 'return'
}

config = {
  INDENTS, SKIPS, PLAIN_SOCKETS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD, BLOCK_TOKENS
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
