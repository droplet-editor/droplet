# Droplet Java mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

config = {
  INDENTS : ['block', 'classBody']
  SKIPS : ['compilationUnit',
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
  PARENS : [
    'statement'
    'typeDeclaration'
    'blockStatement'
    'localVariableDeclarationStatement'
    'primary'
    'parExpression'
    'classBodyDeclaration'
  ]
  SOCKET_TOKENS : [
    'Identifier'
    'IntegerLiteral'
    'FloatingPointLiteral'
    'CharacterLiteral'
    'StringLiteral'
    'NullLiteral'
    'BooleanLiteral'
    'THIS', 'INT', 'FLOAT', 'BOOLEAN', 'VOID'
  ]
  BLOCK_TOKENS : [
    'BREAK'
  ]
  PLAIN_SOCKETS : [
    'importName'
  ]
  COLORS_FORWARD : {
    'statement': 'command'
    'typeDeclaration': 'control'
    'classBodyDeclaration': 'purple'
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
  COLORS_BACKWARD : {
    'controlStatement': 'control'
    'terminalStatement': 'return'
  }
  VALUE_TYPES: ['expression'], BLOCK_TYPES: ['statement'],
  INDENT_START_EXCLUDE_TOKEN: 'LBRACE', INDENT_END_EXCLUDE_TOKEN: 'RBRACE'
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
