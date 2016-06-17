# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

RULES = {
  # Indents
  'compoundStatement': {
    'type': 'indent',
    'indentContext': 'blockItem',
  },
  'structDeclarationsBlock': {
    'type': 'indent',
    'indentContext': 'structDeclaration'
  },

  # Parens
  'expressionStatement': 'parens',
  'primaryExpression': 'parens',
  'structDeclaration': 'parens',

  # Skips
  'blockItemList': 'skip',
  'macroParamList': 'skip',
  'compilationUnit': 'skip',
  'translationUnit': 'skip',
  'declarationSpecifiers': 'skip',
  'declarationSpecifier': 'skip',
  'typeSpecifier': 'skip',
  'structOrUnionSpecifier': 'skip',
  'structDeclarationList': 'skip',
  'declarator': 'skip',
  'directDeclarator': 'skip',
  'rootDeclarator': 'skip',
  'parameterTypeList': 'skip',
  'parameterList': 'skip',
  'argumentExpressionList': 'skip',
  'initializerList': 'skip',
  'initDeclaratorList': 'skip',

  # Sockets
  'Identifier': 'socket',
  'StringLiteral': 'socket',
  'SharedIncludeLiteral': 'socket',
  'Constant': 'socket'
}

COLOR_RULES = [
  ['declaration', 'control'],
  ['specialMethodCall', 'command'],
  ['postfixExpression', 'command'],
  ['iterationStatement', 'control'],
  ['selectionStatement', 'control'],
  ['assignmentExpression', 'command'],
  ['relationalExpression', 'value'],
  ['initDeclarator', 'command'],
  ['blockItemList', 'control'],
  ['compoundStatement', 'control'],
  ['externalDeclaration', 'control'],
  ['structDeclaration', 'command'],
  ['declarationSpecifier', 'control'],
  ['statement', 'command'],
  ['selectionStatement', 'control'],
  ['iterationStatement', 'control'],
  ['functionDefinition', 'control'],
  ['expressionStatement', 'command'],
  ['expression', 'value'],
  ['additiveExpression', 'value'],
  ['multiplicativeExpression', 'value'],
  ['parameterDeclaration', 'command'],
  ['unaryExpression', 'value'],
  ['typeName', 'value'],
  ['initializer', 'value'],
  ['castExpression', 'value'],
]

SHAPE_RULES = [
  ['postfixExpression', 'block-only'],
  ['equalityExpression', 'value-only'],
  ['logicalAndExpression', 'value-only'],
  ['logicalOrExpression', 'value-only'],
  ['iterationStatement', 'block-only'],
  ['selectionStatement', 'block-only'],
  ['assignmentExpression', 'block-only'],
  ['relationalExpression', 'value-only'],
  ['initDeclarator', 'block-only'],
  ['externalDeclaration', 'block-only'],
  ['structDeclaration', 'block-only'],
  ['declarationSpecifier', 'block-only'],
  ['statement', 'block-only'],
  ['selectionStatement', 'block-only'],
  ['iterationStatement', 'block-only'],
  ['functionDefinition', 'block-only'],
  ['expressionStatement', 'value-only'],
  ['expression', 'value-only'],
  ['additiveExpression', 'value-only'],
  ['multiplicativeExpression', 'value-only'],
  ['declaration', 'block-only'],
  ['parameterDeclaration', 'block-only'],
  ['unaryExpression', 'value-only'],
  ['typeName', 'value-only'],
  ['initializer', 'value-only'],
  ['castExpression', 'value-only']
]

config = {
  RULES, COLOR_RULES, SHAPES_FORWARD, SHAPES_BACKWARD
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
     node.parent.parent.parent.type in ['postfixExpression', 'specialMethodCall'] and
     node.parent.parent.parent.children.length in [3, 4] and
     node.parent.parent.parent.children[1].type is 'LeftParen' and
     (node.parent.parent.parent.children[2].type is 'RightParen' or node.parent.parent.parent.children[3]?.type is 'RightParen') and
     node.parent.parent is node.parent.parent.parent.children[0] and
     node.data.text of opts.knownFunctions
    return false
  return true

config.COLOR_CALLBACK = (opts, node) ->
  if node.type in ['postfixExpression', 'specialMethodCall'] and
     node.children.length in [3, 4, 5] and
     node.children[1].type is 'LeftParen' and
     (node.children[2].type is 'RightParen' or node.children[3]?.type is 'RightParen') and
     node.children[0].children[0].type is 'primaryExpression' and
     node.children[0].children[0].children[0].type is 'Identifier' and
     node.children[0].children[0].children[0].data.text of opts.knownFunctions
    return opts.knownFunctions[node.children[0].children[0].children[0].data.text].color
  return null

config.SHAPE_CALLBACK = (opts, node) ->
  if node.type in ['postfixExpression', 'specialMethodCall'] and
     node.children.length in [4, 5] and
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

  # Try any of the unary directives: #include, #if, #ifdef, #ifndef, #undef, #pragma
  unary = text.match(/^(#\s*(?:(?:include)|(?:ifdef)|(?:if)|(?:ifndef)|(?:undef)|(?:pragma))\s*)(.*)$/)
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
