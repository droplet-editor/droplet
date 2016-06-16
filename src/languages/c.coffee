# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

INDENTS = {
  'compoundStatement': 'blockItem',
  'structDeclarationsBlock': 'structDeclaration'
}
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
  'rootDeclarator',
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
  'expressionStatement': 'command'
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
  'assignmentExpression': 'command'
  'relationalExpression': 'value'
  'initDeclarator': 'command'
}
SHAPES_FORWARD = {
  'externalDeclaration': 'block-only'
  'structDeclaration': 'block-only'
  'declarationSpecifier': 'block-only'
  'statement': 'block-only'
  'selectionStatement': 'block-only'
  'iterationStatement': 'block-only'
  'functionDefinition': 'block-only'
  'expressionStatement': 'value-only'
  'expression': 'value-only'
  'additiveExpression': 'value-only'
  'multiplicativeExpression': 'value-only'
  'declaration': 'block-only'
  'parameterDeclaration': 'block-only'
  'unaryExpression': 'value-only'
  'typeName': 'value-only'
}
SHAPES_BACKWARD = {
  'equalityExpression': 'value-only'
  'logicalAndExpression': 'value-only'
  'logicalOrExpression': 'value-only'
  'iterationStatement': 'block-only'
  'selectionStatement': 'block-only'
  'assignmentExpression': 'block-only'
  'relationalExpression': 'value-only'
  'initDeclarator': 'block-only'
}

config = {
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD, SHAPES_FORWARD, SHAPES_BACKWARD
}

ADD_PARENS = (leading, trailing, node, context) ->
  leading '(' + leading()
  trailing trailing() + ')'

config.parenRules = {
  'primaryExpression': {
    'expression': ADD_PARENS
    'additiveExpression': ADD_PARENS
    'multiplicativeExpression': ADD_PARENS
    'assignmentExpression': ADD_PARENS
    'postfixExpression': ADD_PARENS
  }
}

config.SHOULD_SOCKET = (opts, node) ->
  return true unless node.parent? and node.parent.parent? and node.parent.parent.parent?
  # If it is a function call, and we are the first child
  if node.parent.type is 'primaryExpression' and
     node.parent.parent.type is 'postfixExpression' and
     node.parent.parent.parent.type is 'postfixExpression' and
     node.parent.parent.parent.children.length in [3, 4] and
     node.parent.parent.parent.children[1].type is 'LeftParen' and
     (node.parent.parent.parent.children[2].type is 'RightParen' or node.parent.parent.parent.children[3]?.type is 'RightParen') and
     node.parent.parent is node.parent.parent.parent.children[0] and
     node.data.text of opts.knownFunctions
    return false
  return true

config.COLOR_CALLBACK = (opts, node) ->
  if node.type is 'postfixExpression' and
     node.children.length in [3, 4] and
     node.children[1].type is 'LeftParen' and
     (node.children[2].type is 'RightParen' or node.children[3]?.type is 'RightParen') and
     node.children[0].children[0].type is 'primaryExpression' and
     node.children[0].children[0].children[0].type is 'Identifier' and
     node.children[0].children[0].children[0].data.text of opts.knownFunctions
    return opts.knownFunctions[node.children[0].children[0].children[0].data.text].color
  return null

config.SHAPE_CALLBACK = (opts, node) ->
  if node.type is 'postfixExpression' and
     node.children.length in [3, 4] and
     node.children[1].type is 'LeftParen' and
     (node.children[2].type is 'RightParen' or node.children[3]?.type is 'RightParen') and
     node.children[0].children[0].type is 'primaryExpression' and
     node.children[0].children[0].children[0].type is 'Identifier' and
     node.children[0].children[0].children[0].data.text of opts.knownFunctions
    return opts.knownFunctions[node.children[0].children[0].children[0].data.text].shape
  return null

config.isComment = (text) ->
  text.match(/^(\s*\/\/.*)|(#.*)$/)?

config.parseComment = (text) ->
  # Try standard comment
  comment = text.match(/^(\s*\/\/)(.*)$/)
  if comment?
    ranges =  [
      [comment[1].length, comment[1].length + comment[2].length]
    ]
    color = 'comment'

  if text.match(/^#\s*((?:else)|(?:endif))$/)
    ranges =  []
    color = 'purple'

  # Try #include or #ifdef directive
  unary = text.match(/^(#\s*(?:(?:include)|(?:ifdef)|(?:ifndef)|(?:undef))\s*)(.*)$/)
  if unary?
    ranges =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

  # Try #define directive
  binary = text.match(/^(#\s*(?:(?:define))\s*)([a-zA-Z_][0-9a-zA-Z_]*)(\s+)(.*)$/)
  if binary?
    ranges =  [
      [binary[1].length, binary[1].length + binary[2].length]
      [binary[1].length + binary[2].length + binary[3].length, binary[1].length + binary[2].length + binary[3].length + binary[4].length]
    ]
    color = 'purple'

  # Try functional #define directive.
  binary = text.match(/^(#\s*define\s*)([a-zA-Z_][0-9a-zA-Z_]*\s*\((?:[a-zA-Z_][0-9a-zA-Z_]*,\s)*[a-zA-Z_][0-9a-zA-Z_]*\s*\))(\s+)(.*)$/)
  if binary?
    ranges =  [
      [binary[1].length, binary[1].length + binary[2].length]
      [binary[1].length + binary[2].length + binary[3].length, binary[1].length + binary[2].length + binary[3].length + binary[4].length]
    ]
    color = 'purple'

  return {
    sockets: ranges
    color
  }

# TODO Implement removing parentheses at some point
#config.unParenWrap = (leading, trailing, node, context) ->
#  while true
#   if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
#     leading leading().replace(/^\s*\(\s*/, '')
#      trailing trailing().replace(/\s*\)\s*$/, '')
#    else
#      break

# DEBUG
config.unParenWrap = null

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'C', config
