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
    'indentContext': 'blockItemList',
  },
  'structDeclarationsBlock': {
    'type': 'indent',
    'indentContext': 'structDeclaration'
  },
  'switchBlockItemList': (node) ->
    if node.parent?.type is 'switchCase' then {
      'type': 'indent',
      'indentContext': 'switchBlockItemList'
    } else 'skip'

  'switchCompoundStatement': 'skip'
  'switchCaseList': 'skip'
  'switchCase': 'skip'
  'switchLabel': 'skip'

  # Parens
  'expressionStatement': 'parens',
  'primaryExpression': 'parens',
  'structDeclaration': 'parens',

  #'declarator': 'skip',
  'directDeclarator': 'skip',
  ###(node) ->
    if not node.parent? or (node.parent.type is 'declarator' and
       node.parent.parent?.type isnt 'functionDefinition' and
       node.parent.children.length is 1)
      'block'
    else
      'skip'###

  # Skips
  'structDeclaratorList': 'skip',
  'blockItemList': 'skip',
  'macroParamList': 'skip',
  'compilationUnit': 'skip',
  'translationUnit': 'skip',
  #'declarationSpecifier': 'skip',
  #'typeSpecifier': 'skip',
  #'structOrUnionSpecifier': 'skip',
  'structDeclarationList': 'skip',
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
    else if node.children.length is 3
      return {type: 'block', buttons: ADD_BUTTON}
    else if node.children.length is 2 and node.children[1].type is 'Semi'
      return 'parens'
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
    else if node.children[0].data.text is 'switch'
      return {
        type: 'block', buttons: [
          {
            key: 'subtract-button-switch'
            glyph: '\u25B2'
            border: false
          },
          {
            key: 'add-button-switch'
            glyph: '\u25BC'
            border: false
          }
        ]
      }
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
         node.children[0].children[0].children[0].type isnt 'Identifier' or not opts.functions? or
         node.children[0].children[0].children[0].data.text not of opts.functions or
         opts.functions[node.children[0].children[0].children[0].data.text].minArgs?
       )
      if node.children.length is 3
        return {type: 'block', buttons: ADD_BUTTON}
      else if opts.functions? and node.children[0].children[0].children[0].data?.text of opts.functions
        minimum = opts.functions[node.children[0].children[0].children[0].data.text].minArgs
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
        not opts.functions? or
        node.children[0].data.text not of opts.functions
       )
      return {type: 'block', buttons: BOTH_BUTTON}
    else if opts.functions[node.children[0].data.text].minArgs?
      if opts.functions[node.children[0].data.text].minArgs is 0
        return {type: 'block', buttons: BOTH_BUTTON}
      else
        return {type: 'block', buttons: ADD_BUTTON}
    else
      return 'block'

  # Special: declarationSpecifiers (type names) should be surrounded by single sockets
  #'declarationSpecifiers': (node) -> 'skip' #if node.parent.type is 'declaration' then 'skip' else 'block'  #socket'
  #'declarationSpecifiers2': (node) -> 'skip' #if node.parent.type is 'declaration' then 'skip' else 'block'  #socket'

  'declarationSpecifiers': (node) ->
    if node.children.every((child) -> child.children[0].type isnt 'typeSpecifier' or child.children[0].children[0].children.length is 0)
      'socket'
    else
      'block'

  'declarationSpecifiers2': (node) ->
    if node.children.every((child) -> child.children[0].type isnt 'typeSpecifier' or child.children[0].children[0].children.length is 0)
      'socket'
    else
      'block'

  'specifierQualifierList': (node) ->
    if node.children.every((child) -> child.children[0].type isnt 'typeSpecifier' or child.children[0].children[0].children.length is 0)
      'socket'
    else
      'block'

  # Sockets
  'Int': 'socket'
  'Long': 'socket'
  'Short': 'socket'
  'Float': 'socket'
  'Double': 'socket'
  'Char': 'socket'

  'Identifier': 'socket',
  'StringLiteral': 'socket',
  'SharedIncludeLiteral': 'socket',
  'Constant': 'socket'
}

COLOR_DEFAULTS = {
}

COLOR_RULES = {
  'declarationSpecifiers': 'type'
  'declarationSpecifiers2': 'type'

  'specialFunctionDeclaration': 'function'

  'structOrUnionSpecifier': 'struct' # e.g. `struct a { }`
  'structDeclaration': 'struct' # e.g. `int a;` within `struct a { int a; }`

  'declarator': 'declaration',
  'pointerDeclarator': 'declaration',
  'directDeclarator': 'declaration',
  'specifierQualifierList': 'declaration',# e.g `int a;` when inside `struct {}`
  'declaration': 'declaration', # e.g. `int a;`
  'parameterDeclaration': 'declaration', # e.g. `int a` when in `int myMethod(int a) { }`
  'externalDeclaration': 'declaration', # e.g. `int a = b` when global

  'functionDefinition': 'function', # e.g. `int myMethod() { }`

  'expression': 'value', # Any expression, like `a + b`
  'additiveExpression': 'value', # e.g. `a + b`
  'multiplicativeExpression': 'value', # e.g. `a * b`
  'unaryExpression': 'value', # e.g. `sizeof(a)`
  'typeName': 'value', # e.g. `int`
  'initializer': 'value', # e.g. `{a, b, c}` when in `int x[] = {a, b, c};`
  'castExpression': 'value' # e.g. `(b)a`

  'equalityExpression': 'logic' # e.g. `a == b`
  'relationalExpression': 'logic' # e.g. `a == b`
  'logicalAndExpression': 'logic', # e.g. `a && b`
  'logicalOrExpression': 'logic', # e.g. `a || b`

  'jumpStatement': 'return', # e.g. `return 0;`

  'postfixExpression': 'value', # e.g. `a(b, c);` OR `a++`
  'assignmentExpression': 'assign', # e.g. `a = b;` OR `a = b`
  'specialMethodCall': 'functionCall', # e.g. `a(b);`
  #'initDeclarator': 'assign', # e.g. `a = b` when inside `int a = b;`

  'iterationStatement': 'control', # e.g. `for (int i = 0; i < 10; i++) { }`
  'selectionStatement': 'control', # e.g. if `(a) { } else { }` OR `switch (a) { }`
  #'blockItemList': 'control', # List of commands
  'compoundStatement': 'control', # List of commands inside braces
  'declarationSpecifier': 'control', # e.g. `int` when in `int a = b;`
}

SHAPE_RULES = {
  'blockItem': helper.BLOCK_ONLY, # Any statement, like `return 0;`
  'expression': helper.VALUE_ONLY, # Any expression, like `a + b`
  'postfixExpression': helper.VALUE_ONLY, # e.g. `a(b, c);` OR `a++`
  'equalityExpression': helper.VALUE_ONLY, # e.g. `a == b`
  'logicalAndExpression': helper.VALUE_ONLY, # e.g. `a && b`
  'logicalOrExpression': helper.VALUE_ONLY, # e.g. `a || b`
  'iterationStatement': helper.BLOCK_ONLY, # e.g. `for (int i = 0; i < 10; i++) { }`
  'selectionStatement': helper.BLOCK_ONLY, # e.g. if `(a) { } else { }` OR `switch (a) { }`
  'assignmentExpression': helper.BLOCK_ONLY, # e.g. `a = b;` OR `a = b`
  'relationalExpression': helper.VALUE_ONLY, # e.g. `a < b`
  'initDeclarator': helper.BLOCK_ONLY, # e.g. `a = b` when inside `int a = b;`
  'externalDeclaration': helper.BLOCK_ONLY, # e.g. `int a = b` when global
  'structDeclaration': helper.BLOCK_ONLY, # e.g. `struct a { }`
  'declarationSpecifier': helper.BLOCK_ONLY, # e.g. `int` when in `int a = b;`
  'statement': helper.BLOCK_ONLY, # Any statement, like `return 0;`
  'functionDefinition': helper.BLOCK_ONLY, # e.g. `int myMethod() { }`
  'expressionStatement': helper.BLOCK_ONLY, # Statement that consists of an expression, like `a = b;`
  'additiveExpression': helper.VALUE_ONLY, # e.g. `a + b`
  'multiplicativeExpression': helper.VALUE_ONLY, # e.g. `a * b`
  'declaration': helper.BLOCK_ONLY, # e.g. `int a;`
  'parameterDeclaration': helper.BLOCK_ONLY, # e.g. `int a` when in `int myMethod(int a) { }`
  'unaryExpression': helper.VALUE_ONLY, # e.g. `sizeof(a)`
  'typeName': helper.VALUE_ONLY, # e.g. `int`
  'initializer': helper.VALUE_ONLY, # e.g. `{a, b, c}` when in `int x[ = {a, b, c};`
  'castExpression': helper.VALUE_ONLY # e.g. `(b)a`
}

NATIVE_TYPES =[
  'int'
  'char'
  'double'
  'long long'
  'string'
  'bool'
  'FILE'
  'float'
]
DROPDOWNS = {
  'specifierQualifierList': NATIVE_TYPES
  'declarationSpecifiers': NATIVE_TYPES
  'declarationSpecifiers2': NATIVE_TYPES
}

config = {
  RULES, COLOR_RULES, SHAPE_RULES, COLOR_DEFAULTS, DROPDOWNS
}

ADD_PARENS = (leading, trailing, node, context) ->
  leading '(' + leading()
  trailing trailing() + ')'

ADD_SEMICOLON = (leading, trailing, node, context) ->
  trailing trailing() + ';'

REMOVE_SEMICOLON = (leading, trailing, node, context) ->
  trailing trailing().replace /\s*;\s*$/, ''

config.PAREN_RULES = {
  'primaryExpression': {
    'expression': ADD_PARENS
  },
  'expressionStatement': {
    'expression': ADD_SEMICOLON
  }
  'postfixExpression': {
    'specialMethodCall': REMOVE_SEMICOLON
  }
  ###
  # These two rules seem to be wrong and I don't
  # remember why I put them here in the first place.
  # Commenting out for now.
  'declaration': {
    'declarationSpecifiers': ADD_SEMICOLON
  }
  'structDeclaration': {
    'specifierQualifierList': ADD_SEMICOLON
  }
  ###
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
  if ((node.parent? and node.parent.parent? and node.parent.parent.parent?) or
      node.parent?.type is 'specialMethodCall') and

      (node.parent?.type is 'specialMethodCall' or getMethodName(node.parent.parent.parent)? and

      # Check to see whether we are the first child
      node.parent.parent is node.parent.parent.parent.children[0] and
      node.parent is node.parent.parent.children[0] and
      node is node.parent.children[0])

    # If the checks pass, do not socket.
    return {
      type: 'locked'
      dropdown: if opts.functions? then generateDropdown(opts.functions) else null
    }

  # We will do a locked socket for all type declarations
  else if node.type in ['declarationSpecifiers', 'declarationSpecifiers2', 'Int', 'Long', 'Short', 'Float', 'Double', 'Char']
    return {
      type: 'locked'
      dropdown: NATIVE_TYPES
    }

  else if node.type is 'Identifier' and node.parent.type is 'typedefName'
    return {
      type: 'locked'
      dropdown: NATIVE_TYPES
    }

  else
    return true

generateDropdown = (knownFunctions) ->
  result = []
  for func, val of knownFunctions
    result.push func
  result.sort()
  return result

# Color and shape callbacks look up the method name
# in the known functions list if available.
config.COLOR_CALLBACK = (opts, node) ->
  return null unless opts.functions?

  if node.type is 'declarationSpecifiers' and node.children[0].children[0].children[0].type is 'Typedef'
    return 'declaration'

  name = getMethodName node

  if name?
    return 'functionCall'
  else
    return null

config.SHAPE_CALLBACK = (opts, node) ->
  return null unless opts.functions?

  if node.type is 'postfixExpression'
    name = getMethodName node

    if name?
      return helper.BLOCK_ONLY
    else
      return helper.VALUE_ONLY
  else
    return null

config.isComment = (text) ->
  text.match(/^(\s*\/\/.*)|(#.*)$/)?

config.parseComment = (text) ->
  # Try standard comment
  comment = text.match(/^(\s*\/\/)(.*)$/)
  if comment?
    sockets =  [
      [comment[1].length, comment[1].length + comment[2].length]
    ]
    color = 'comment'

    return {sockets, color}

  if text.match(/^#\s*((?:else)|(?:endif))$/)
    sockets =  []
    color = 'purple'

    return {sockets, color}

  # Try #define directive
  binary = text.match(/^(#\s*(?:(?:define))\s*)([a-zA-Z_][0-9a-zA-Z_]*)(\s+)(.*)$/)
  if binary?
    sockets =  [
      [binary[1].length, binary[1].length + binary[2].length]
      [binary[1].length + binary[2].length + binary[3].length, binary[1].length + binary[2].length + binary[3].length + binary[4].length]
    ]
    color = 'purple'

    return {sockets, color}

  # Try functional #define directive.
  binary = text.match(/^(#\s*define\s*)([a-zA-Z_][0-9a-zA-Z_]*\s*\((?:[a-zA-Z_][0-9a-zA-Z_]*,\s)*[a-zA-Z_][0-9a-zA-Z_]*\s*\))(\s+)(.*)$/)
  if binary?
    sockets =  [
      [binary[1].length, binary[1].length + binary[2].length]
      [binary[1].length + binary[2].length + binary[3].length, binary[1].length + binary[2].length + binary[3].length + binary[4].length]
    ]
    color = 'purple'

    return {sockets, color}

  # Try any of the unary directives: #define, #if, #ifdef, #ifndef, #undef, #pragma
  unary = text.match(/^(#\s*(?:(?:define)|(?:ifdef)|(?:if)|(?:ifndef)|(?:undef)|(?:pragma))\s*)(.*)$/)
  if unary?
    sockets =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

    return {sockets, color}

  # Try #include, which must include the quotations
  unary = text.match(/^(#\s*include\s*<)(.*)>\s*$/)
  if unary?
    sockets =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

    return {sockets, color}

  unary = text.match(/^(#\s*include\s*")(.*)"\s*$/)
  if unary?
    sockets =  [
      [unary[1].length, unary[1].length + unary[2].length]
    ]
    color = 'purple'

    return {sockets, color}

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
config.EMPTY_STRINGS = {
  'Identifier': '__0_droplet__',
  'declaration': '__0_droplet__ __0_droplet__;',
  'statement': '__0_droplet__;'
}
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
  blockType = block.nodeContext?.type ? block.parseContext

  if type is 'add-button-switch'

    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indent = indents[indents.length - 1]
    preindent = indents[indents.length - 2]

    # Determine if the last indent is a default
    # or a case
    if preindent?
      {string: infix} = model.stringThrough(
        preindent.end,
        ((token) -> token is indent.start),
        false
      )

      # If it's a case, go ahead and append
      # at the end. Otherwise, append
      # before the end.
      if infix.indexOf('case') is -1
        indent = preindent

    {string: prefix} = model.stringThrough(
      block.start,
      ((token) -> token is indent.end),
      false
    )

    suffix = str[prefix.length + 1...]

    return prefix + '\n  case n:\n    break;\n' + suffix

  else if type is 'subtract-button-switch'

    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indents = indents[-3...]

    if indents.length is 1
      return str

    if indents.length is 3
      {string: infix} = model.stringThrough(
        indents[1].end,
        ((token) -> token is indents[2].start),
        false
      )

      if infix.indexOf('case') >= 0
        indents.shift()

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

  if type is 'add-button'

    if blockType is 'selectionStatement'
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

    else if blockType is 'postfixExpression' or blockType is 'specialMethodCall'
      if str.match(/\(\s*\)\s*;?$/)?
        return str.replace(/(\s*\)\s*;?\s*)$/, "#{config.empty}$1")
      else
        return str.replace(/(\s*\)\s*;?\s*)$/, ", #{config.empty}$1")
    else if blockType is 'parameterList'
      if str.match(/^\s*void\s*$/)
        return "type param"
      return str + ", type param"
    else if blockType is 'declaration'
        return str.replace(/(\s*;?\s*)$/, ", #{config.empty} = #{config.empty}$1")
    else if blockType is 'initializer'
      return str.replace(/(\s*}\s*)$/, ", #{config.empty}$1")
    else if blockType is 'expression'
      return str.replace(/(\s*;\s*)?$/, ", #{config.empty}$1")


  else if type is 'subtract-button'

    if blockType is 'selectionStatement'
      indents = []
      block.traverseOneLevel (child) ->
        if child.type is 'indent'
          indents.push child
      indents = indents[-3...]

      if indents.length is 1
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

    else if blockType is 'postfixExpression' or blockType is 'specialMethodCall'
      return removeLastSocketAnd str, block, /\s*,\s*$/
    else if blockType is 'declaration'
      reparsed = config.__antlrParse 'declaration', str

      lines = str.split '\n'
      prefix = helper.clipLines lines, {line: 0, column: 0}, reparsed.children[1].children[2].bounds.start
      suffix = str.match(/\s*;?\s*$/)[0]

      prefix = prefix.replace /\s*,\s*$/, ''

      return prefix + suffix
    else if blockType is 'initializer'
      return removeLastSocketAnd str, block, /\s*,\s*$/
    else if blockType is 'parameterList'
      count = 0
      block.traverseOneLevel (x) -> if x.type is 'socket' then count++
      if count is 1
        return 'void'
      else
        return removeLastSocketAnd str, block, /\s*,\s*$/
    else if blockType is 'expression'
      return removeLastSocketAnd str, block, /\s*,\s*$/

  return str

config.rootContext = 'translationUnit'

config.lockedSocketCallback = (opts, socketText, parentText, parseContext) ->
  if opts.functions? and socketText of opts.functions and 'prototype' of opts.functions[socketText]
    if parseContext in ['expressionStatement', 'specialMethodCall']
      return opts.functions[socketText].prototype
    else
      return opts.functions[socketText].prototype.replace /;$/, ''
  else
    return parentText

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CPP14', config