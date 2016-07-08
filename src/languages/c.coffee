# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

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
  ['jumpStatement', 'return'] # e.g. `return 0;`
  ['declaration', 'control'], # e.g. `int a;`
  ['specialMethodCall', 'command'], # e.g. `a(b);`
  ['additiveExpression', 'value'], # e.g. `a + b`
  ['multiplicativeExpression', 'value'], # e.g. `a * b`
  ['postfixExpression', 'command'], # e.g. `a(b, c);` OR `a++`
  ['iterationStatement', 'control'], # e.g. `for (int i = 0; i < 10; i++) { }`
  ['selectionStatement', 'control'], # e.g. if `(a) { } else { }` OR `switch (a) { }`
  ['assignmentExpression', 'command'], # e.g. `a = b;` OR `a = b`
  ['relationalExpression', 'value'], # e.g. `a < b`
  ['initDeclarator', 'command'], # e.g. `a = b` when inside `int a = b;`
  ['blockItemList', 'control'], # List of commands
  ['compoundStatement', 'control'], # List of commands inside braces
  ['externalDeclaration', 'control'], # e.g. `int a = b` when global
  ['structDeclaration', 'command'], # e.g. `struct a { }`
  ['declarationSpecifier', 'control'], # e.g. `int` when in `int a = b;`
  ['statement', 'command'], # Any statement, like `return 0;`
  ['functionDefinition', 'control'], # e.g. `int myMethod() { }`
  ['expressionStatement', 'command'], # Statement that consists of an expression, like `a = b;`
  ['expression', 'value'], # Any expression, like `a + b`
  ['parameterDeclaration', 'command'], # e.g. `int a` when in `int myMethod(int a) { }`
  ['unaryExpression', 'value'], # e.g. `sizeof(a)`
  ['typeName', 'value'], # e.g. `int`
  ['initializer', 'value'], # e.g. `{a, b, c}` when in `int x[] = {a, b, c};`
  ['castExpression', 'value'] # e.g. `(b)a`
]

SHAPE_RULES = [
  ['blockItem', 'block-only'], # Any statement, like `return 0;`
  ['expression', 'value-only'], # Any expression, like `a + b`
  ['postfixExpression', 'block-only'], # e.g. `a(b, c);` OR `a++`
  ['equalityExpression', 'value-only'], # e.g. `a == b`
  ['logicalAndExpression', 'value-only'], # e.g. `a && b`
  ['logicalOrExpression', 'value-only'], # e.g. `a || b`
  ['iterationStatement', 'block-only'], # e.g. `for (int i = 0; i < 10; i++) { }`
  ['selectionStatement', 'block-only'], # e.g. if `(a) { } else { }` OR `switch (a) { }`
  ['assignmentExpression', 'block-only'], # e.g. `a = b;` OR `a = b`
  ['relationalExpression', 'value-only'], # e.g. `a < b`
  ['initDeclarator', 'block-only'], # e.g. `a = b` when inside `int a = b;`
  ['externalDeclaration', 'block-only'], # e.g. `int a = b` when global
  ['structDeclaration', 'block-only'], # e.g. `struct a { }`
  ['declarationSpecifier', 'block-only'], # e.g. `int` when in `int a = b;`
  ['statement', 'block-only'], # Any statement, like `return 0;`
  ['functionDefinition', 'block-only'], # e.g. `int myMethod() { }`
  ['expressionStatement', 'block-only'], # Statement that consists of an expression, like `a = b;`
  ['additiveExpression', 'value-only'], # e.g. `a + b`
  ['multiplicativeExpression', 'value-only'], # e.g. `a * b`
  ['declaration', 'block-only'], # e.g. `int a;`
  ['parameterDeclaration', 'block-only'], # e.g. `int a` when in `int myMethod(int a) { }`
  ['unaryExpression', 'value-only'], # e.g. `sizeof(a)`
  ['typeName', 'value-only'], # e.g. `int`
  ['initializer', 'value-only'], # e.g. `{a, b, c}` when in `int x[] = {a, b, c};`
  ['castExpression', 'value-only'] # e.g. `(b)a`
]

config = {
  RULES, COLOR_RULES, SHAPE_RULES
}

ADD_PARENS = (leading, trailing, node, context) ->
  leading '(' + leading()
  trailing trailing() + ')'

config.PAREN_RULES = {
  'primaryExpression': {
    'expression': ADD_PARENS
    'additiveExpression': ADD_PARENS
    'multiplicativeExpression': ADD_PARENS
    'assignmentExpression': ADD_PARENS
    'postfixExpression': ADD_PARENS
  }
}

# Test to see if a node is a method call
getMethodName = (node) ->
  if node.type is 'postfixExpression' and
     # The children of a method call are either
     # `(method) '(' (paramlist) ')'` OR `(method) '(' ')'`
     node.children.length in [3, 4] and
     # Check to make sure that the correct children are parentheses
     node.children[1].type is 'LeftParen' and
     (node.children[2].type is 'RightParen' or node.children[3]?.type is 'RightParen') and
     # Check to see whether the called method is a single identifier, like `puts` in
     # `getc()`, rather than `getFunctionPointer()()` or `a.b()`
     node.children[0].children[0].type is 'primaryExpression' and
     node.children[0].children[0].children[0].type is 'Identifier'

    # If all of these are true, we have a function name to give
    return node.children[0].children[0].children[0].data.text

  # Alternatively, we could have the special `a(b)` node.
  else if node.type is 'specialMethodCall'
    return node.children[0].data.text

  return null

config.SHOULD_SOCKET = (opts, node) ->
  # We will not socket if we are the identifier
  # in a single-identifier function call like `a(b, c)`
  # and `a` is in the known functions list.
  #
  # We can only be such an identifier if we have the appropriate number of parents;
  # check.
  unless opts.knownFunctions? and ((node.parent? and node.parent.parent? and node.parent.parent.parent?) or
      node.parent?.type is 'specialMethodCall')
    return true

  # Check to see whether the thing we are in is a function
  if (node.parent?.type is 'specialMethodCall' or getMethodName(node.parent.parent.parent)? and
     # Check to see whether we are the first child
     node.parent.parent is node.parent.parent.parent.children[0] and
     node.parent is node.parent.parent.children[0] and
     node is node.parent.children[0]) and
     # Finally, check to see if our name is a known function name
     node.data.text of opts.knownFunctions

    # If the checks pass, do not socket.
    return false

  return true

# Color and shape callbacks look up the method name
# in the known functions list if available.
config.COLOR_CALLBACK = (opts, node) ->
  return null unless opts.knownFunctions?

  name = getMethodName node

  if name? and name of opts.knownFunctions
    return opts.knownFunctions[name].color
  else
    return null

config.SHAPE_CALLBACK = (opts, node) ->
  return null unless opts.knownFunctions?

  name = getMethodName node

  if name? and name of opts.knownFunctions
    return opts.knownFunctions[name].shape
  else
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

  # Try any of the unary directives: #define, #if, #ifdef, #ifndef, #undef, #pragma
  unary = text.match(/^(#\s*(?:(?:define)|(?:ifdef)|(?:if)|(?:ifndef)|(?:undef)|(?:pragma))\s*)(.*)$/)
  if unary?
    ranges =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

  # Try #include, which must include the quotations
  unary = text.match(/^(#\s*include\s*<)(.*)>\s*$/)
  if unary?
    ranges =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

  unary = text.match(/^(#\s*include\s*")(.*)"\s*$/)
  if unary?
    ranges =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

  return {
    sockets: ranges
    color
  }

config.getDefaultSelectionRange = (string) ->
  start = 0; end = string.length
  if string.length > 1 and string[0] is string[string.length - 1] and string[0] is '"'
    start += 1; end -= 1
  if string.length > 1 and string[0] is '<' and string[string.length - 1] is '>'
    start += 1; end -= 1
  if string.length is 3 and string[0] is string[string.length - 1] is '\''
    start += 1; end -= 1
  return {start, end}

config.stringFixer = (string) ->
  if /^['"]|['"]$/.test string
    return fixQuotedString [string]
  else
    return string

config.empty = '__0_droplet__'

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
