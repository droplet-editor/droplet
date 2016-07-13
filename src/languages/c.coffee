# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

model = require '../model.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

ADD_BUTTON = [
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]
BOTH_BUTTON = [
  {
    key: 'subtract-button'
    glyph: '\u25C0'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

ADD_BUTTON_VERT = [
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_VERT = [
  {
    key: 'subtract-button'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

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
  'parameterList': (node) ->
    if node.parent?.type is 'parameterList'
      return 'skip'
    else if node.children.length is 1 and node.children[0].children[0].children[0].children[0].children[0].type is 'Void'
      {type: 'buttonContainer', buttons: ADD_BUTTON}
    else
      {type: 'buttonContainer', buttons: BOTH_BUTTON}
  'argumentExpressionList': 'skip'
  'initializerList': 'skip',
  'initDeclarator': 'skip',
  'initDeclaratorList': 'skip'
  'declaration': (node) ->
    if node.children.length is 3 and node.children[1].children.length is 3
      return {type: 'block', buttons: BOTH_BUTTON}
    else if node.children.length >= 2
      return {type: 'block', buttons: ADD_BUTTON}
    else
      return 'block'

  'initializer': (node) ->
    if node.children[0].data?.text is '{'
      if node.children[1].children.length > 2
        return {type: 'block', buttons: BOTH_BUTTON}
      else
        return {type: 'block', buttons: ADD_BUTTON}
    else
      return 'block'

  'expression': (node) ->
    if node.parent?.type is 'expression'
      'skip'
    else if node.children[0].type is 'expression'
      {type: 'block', buttons: ADD_BUTTON}
    else
      return 'block'

  # Special: nested selection statement. Skip iff we are an if statement
  # in the else clause of another if statement.
  'selectionStatement': (node) ->
    if node.children[0].data.text is 'if' and
       # Check to make sure the parent is an if. Actually,
       # our immediate parent is a 'statement'; the logical wrapping
       # parent is parent.parent
       node.parent?.type is 'statement' and
       node.parent.parent?.type is 'selectionStatement' and
       node.parent.parent.children[0].data?.text is 'if' and
       # This last one will only occur if we are the else clause
       node.parent is node.parent.parent.children[6]
      return 'skip'
    # Otherwise, if we are an if statement, give us a mutation button
    else if node.children[0].data.text is 'if'
      if node.children.length is 7
        return {type: 'block', buttons: BOTH_BUTTON_VERT}
      else
        return {type: 'block', buttons: ADD_BUTTON_VERT}
    else
      return 'block'

  # Special: functions
  'postfixExpression': (node, opts) ->
    if (
        node.children.length is 3 and node.children[1].data?.text is '(' and node.children[2].data?.text is ')' or
        node.children.length is 4 and node.children[1].data?.text is '(' and node.children[3].data?.text is ')'
       ) and
       (
         (not node.children[0].children[0]?.children?[0]?) or
         node.children[0].children[0].children[0].type isnt 'Identifier' or not opts.knownFunctions?
         node.children[0].children[0].children[0].data.text not of opts.knownFunctions or
         opts.knownFunctions[node.children[0].children[0].children[0].data.text].minArgs?
       )
      if node.children.length is 3
        return {type: 'block', buttons: ADD_BUTTON}
      else if opts.knownFunctions? and node.children[0].children[0].children[0].data.text of opts.knownFunctions
        minimum = opts.knownFunctions[node.children[0].children[0].children[0].data.text].minArgs
        nargs = 0
        param = node.children[2]
        while param.type is 'argumentExpressionList'
          nargs += 1
          param = param.children[0]
        if nargs > minimum
          return {type: 'block', buttons: BOTH_BUTTON}
        else
          return {type: 'block', buttons: ADD_BUTTON}
      else
        return {type: 'block', buttons: BOTH_BUTTON}
    else
      return 'block'

  'specialMethodCall': (node, opts) ->
    if (
        not opts.knownFunctions? or
        node.children[0].data.text not of opts.knownFunctions
       )
      return {type: 'block', buttons: BOTH_BUTTON}
    else if opts.knownFunctions[node.children[0].data.text].minArgs?
      if opts.knownFunctions[node.children[0].data.text].minArgs is 0
        return {type: 'block', buttons: BOTH_BUTTON}
      else
        return {type: 'block', buttons: ADD_BUTTON}
    else
      return 'block'


  # Sockets
  'Identifier': 'socket',
  'StringLiteral': 'socket',
  'SharedIncludeLiteral': 'socket',
  'Constant': 'socket'
}

COLOR_RULES = [
  ['jumpStatement', 'return'] # e.g. `return 0;`
  ['declaration', 'control'], # e.g. `int a;`
  ['specialMethodCall', 'value'], # e.g. `a(b);`
  ['equalityExpression', 'value'] # e.g. `a == b`
  ['additiveExpression', 'value'], # e.g. `a + b`
  ['multiplicativeExpression', 'value'], # e.g. `a * b`
  ['postfixExpression', 'command'], # e.g. `a(b, c);` OR `a++`
  ['iterationStatement', 'control'], # e.g. `for (int i = 0; i < 10; i++) { }`
  ['selectionStatement', 'control'], # e.g. if `(a) { } else { }` OR `switch (a) { }`
  ['assignmentExpression', 'command'], # e.g. `a = b;` OR `a = b`
  ['relationalExpression', 'value'], # e.g. `a < b`
  ['initDeclaratorList', 'command'], # e.g. `a = b` when inside `int a = b;`
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
  ['initDeclaratorList', 'value-only'], # e.g. `a = b` when inside `int a = b;`
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

STATEMENT_TO_EXPRESSION = (leading, trailing, node, context) ->
  matching = false
  for c in node.classes when c[...'__parse__'.length] is '__parse__'
    if c in context.classes
      matching = true
      break
  if matching
    leading '(' + leading()
    trailing trailing().replace(/\s*;\s*$/, '') + ')'
  else
    trailing trailing().replace(/\s*;\s*$/, '')

EXPRESSION_TO_STATEMENT = (leading, trailing, node, context) ->
  while true
    if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
      leading leading().replace(/^\s*\(\s*/, '')
      trailing trailing().replace(/\s*\)\s*$/, '')
    else
      break

  trailing trailing() + ';'

parenWrapClasses = (classes) -> classes.map (x) -> x.replace /^__parse__/, '__paren__'
unParenWrapClasses = (classes) -> classes.filter((x) -> not x.match(/^__parse__/)).map (x) -> x.replace /^__paren__/, '__parse__'
firstParenWrappedClass = (classes) -> classes.filter((x) -> x.match(/^__paren__/))[0][9..]

config.PAREN_RULES = {
  'primaryExpression': {
    'expression': ADD_PARENS
    'additiveExpression': ADD_PARENS
    'multiplicativeExpression': ADD_PARENS
    'assignmentExpression': ADD_PARENS
    'postfixExpression': ADD_PARENS
    'expressionStatement': STATEMENT_TO_EXPRESSION
    'specialMethodCall': STATEMENT_TO_EXPRESSION
  }
  'blockItem': {
    'expression': EXPRESSION_TO_STATEMENT
    'additiveExpression': EXPRESSION_TO_STATEMENT
    'multiplicativeExpression': EXPRESSION_TO_STATEMENT
    'assignmentExpression': EXPRESSION_TO_STATEMENT
    'postfixExpression': EXPRESSION_TO_STATEMENT
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
config.emptyIndent = ''

insertAfterLastSocket = (str, block, insert) ->

  {string: suffix} = model.stringThrough(
    block.end,
    ((token) -> token.parent is block and token.type is 'socketEnd'),
    ((token) -> token.prev)
  )

  prefix = str[...-suffix.length]

  return prefix + insert + suffix

removeLastSocketAnd = (str, block, prefixClip = null, suffixClip = null) ->
  {string: suffix, token: socketToken} = model.stringThrough(
    block.end,
    ((token) -> token.parent is block and token.type is 'socketEnd'),
    true
  )

  if suffixClip?
    suffix = suffix.replace suffixClip, ''

  {string: prefix} = model.stringThrough(
    block.start,
    ((token) -> token.container is socketToken.container),
    false
  )

  if prefixClip?
    prefix = prefix.replace prefixClip, ''

  return prefix + suffix

config.handleButton = (str, type, block) ->
  if type is 'add-button'
    if '__parse__selectionStatement' in block.classes
      indents = []
      block.traverseOneLevel (child) ->
        if child.type is 'indent'
          indents.push child
      indents = indents[-3...]

      if indents.length is 1
        return str + '\nelse\n{\n  \n}\n'

      else if indents.length is 2
        {string: prefix} = model.stringThrough(
          block.start,
          ((token) -> token is indents[0].end),
          false
        )

        suffix = str[prefix.length + 1...]

        return prefix + '\n}\nelse if (a == b)\n{\n  \n' + suffix

      else if indents.length is 3
        {string: prefix} = model.stringThrough(
          block.start,
          ((token) -> token is indents[1].end),
          false
        )

        suffix = str[prefix.length + 1...]

        return prefix + '\n}\nelse if (a == b)\n{\n  \n' + suffix

    else if '__parse__postfixExpression' in block.classes or '__paren__postfixExpression' in block.classes or '__parse__specialMethodCall' in block.classes
      if str.match(/\(\s*\)\s*;?$/)?
        return str.replace(/(\s*\)\s*;?\s*)$/, "#{config.empty}$1")
      else
        return str.replace(/(\s*\)\s*;?\s*)$/, ", #{config.empty}$1")
    else if '__parse__parameterList' in block.classes
      if str.match(/^\s*void\s*$/)
        return "type param"
      return str + ", type param"
    else if '__parse__declaration' in block.classes
        return str.replace(/(\s*;?\s*)$/, ", #{config.empty} = #{config.empty}$1")
    else if '__parse__initializer' in block.classes
      return str.replace(/(\s*}\s*)$/, ", #{config.empty}$1")
    else if '__parse__expression' in block.classes or '__paren__expression' in block.classes
      return str.replace(/(\s*;\s*)?$/, ", #{config.empty}$1")
  else
    if '__parse__selectionStatement' in block.classes
      indents = []
      block.traverseOneLevel (child) ->
        if child.type is 'indent'
          indents.push child
      indents = indents[-3...]

      if indents.length < 3
        return str
      else
        {string: prefix} = model.stringThrough(
          block.start,
          ((token) -> token is indents[0].end),
          false
        )

        {string: suffix} = model.stringThrough(
          block.end,
          ((token) -> token is indents[1].end),
          true
        )

        return prefix + suffix

    else if '__parse__postfixExpression' in block.classes or '__paren__postfixExpression' in block.classes or '__parse__specialMethodCall' in block.classes
      return removeLastSocketAnd str, block, /\s*,\s*$/
    else if '__parse__declaration' in block.classes
      reparsed = config.__antlrParse 'declaration', str

      lines = str.split '\n'
      prefix = helper.clipLines lines, {line: 0, column: 0}, reparsed.children[1].children[2].bounds.start
      suffix = str.match(/\s*;?\s*$/)[0]

      prefix = prefix.replace /\s*,\s*$/, ''

      return prefix + suffix
    else if '__parse__initializer' in block.classes
      return removeLastSocketAnd str, block, /\s*,\s*$/
    else if '__parse__parameterList' in block.classes
      count = 0
      block.traverseOneLevel (x) -> if x.type is 'socket' then count++
      if count is 1
        return 'void'
      else
        return removeLastSocketAnd str, block, /\s*,\s*$/
    else if '__parse__expression' in block.classes or '__paren__expression' in block.classes
      return removeLastSocketAnd str, block, /\s*,\s*$/

  return str

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
