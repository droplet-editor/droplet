# Droplet JavaScript mode
#
# Copyright (c) 2015 Anthony Bau (dab1998@gmail.com)
# MIT License.

helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'

acorn = require '../../vendor/acorn'

STATEMENT_NODE_TYPES = [
  'ExpressionStatement'
  'ReturnStatement'
  'BreakStatement'
  'ThrowStatement'
]

NEVER_PAREN = 100

KNOWN_FUNCTIONS =
  'alert'       : {}
  'prompt'      : {}
  'console.log' : {}
  '*.toString'  : {value: true}
  'Math.abs'    : {value: true}
  'Math.acos'   : {value: true}
  'Math.asin'   : {value: true}
  'Math.atan'   : {value: true}
  'Math.atan2'  : {value: true}
  'Math.cos'    : {value: true}
  'Math.sin'    : {value: true}
  'Math.tan'    : {value: true}
  'Math.ceil'   : {value: true}
  'Math.floor'  : {value: true}
  'Math.round'  : {value: true}
  'Math.exp'    : {value: true}
  'Math.ln'     : {value: true}
  'Math.log10'  : {value: true}
  'Math.pow'    : {value: true}
  'Math.sqrt'   : {value: true}
  'Math.max'    : {value: true}
  'Math.min'    : {value: true}
  'Math.random' : {value: true}

CATEGORIES = {
  functions: {color: 'purple'}
  returns: {color: 'yellow'}
  comments: {color: 'gray'}
  arithmetic: {color: 'green'}
  logic: {color: 'cyan'}
  containers: {color: 'teal'}
  assignments: {color: 'blue'}
  loops: {color: 'orange'}
  conditionals: {color: 'orange'}
  value: {color: 'green'}
  command: {color: 'blue'}
  errors: {color: '#f00'}
}

LOGICAL_OPERATORS = {
  '==': true
  '!=': true
  '===': true
  '!==': true
  '<': true
  '<=': true
  '>': true
  '>=': true
  'in': true
  'instanceof': true
  '||': true
  '&&': true
  '!': true
}

NODE_CATEGORIES = {
  'BinaryExpression': 'arithmetic'  # actually, some are logic
  'UnaryExpression': 'arithmetic'   # actually, some are logic
  'ConditionalExpression': 'arithmetic'
  'LogicalExpression': 'logic'
  'FunctionExpression': 'functions'
  'FunctionDeclaration': 'functions'
  'AssignmentExpression': 'assignments'
  'UpdateExpression': 'assignments'
  'VariableDeclaration': 'assignments'
  'ReturnStatement': 'returns'
  'IfStatement': 'conditionals'
  'SwitchStatement': 'conditionals'
  'ForStatement': 'loops'
  'ForInStatement': 'loops'
  'WhileStatement': 'loops'
  'DoWhileStatement': 'loops'
  'NewExpression': 'containers'
  'ObjectExpression': 'containers'
  'ArrayExpression': 'containers'
  'MemberExpression': 'containers'
  'BreakStatement': 'returns'
  'ThrowStatement': 'returns'
  'TryStatement': 'returns'
  'CallExpression': 'command'
  'SequenceExpression': 'command'
  'Identifier': 'value'
}

# See https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_Precedence
# These numbers are "19 - x" so that the lowest numbers bind most tightly.
OPERATOR_PRECEDENCES = {
  '++': 3
  '--': 3
  '!': 4
  '~': 4
  '*': 5
  '/': 5
  '%': 5
  '+': 6
  '-': 6
  '<<': 7
  '>>': 7
  '>>>': 7
  '<': 8
  '>': 8
  '>=': 8
  'in': 8
  'instanceof': 8
  '==': 9
  '!=': 9
  '===': 9
  '!==': 9
  '&': 10
  '^': 11
  '|': 12
  '&&': 13
  '||': 14
}

CLASS_EXCEPTIONS = {
  'ForStatement': ['ends-with-brace', 'block-only']
  'FunctionDeclaration': ['ends-with-brace', 'block-only']
  'IfStatement': ['ends-with-brace', 'block-only']
  'WhileStatement': ['ends-with-brace', 'block-only']
  'DoWhileStatement': ['ends-with-brace', 'block-only']
  'SwitchStatement': ['ends-with-brace', 'block-only']
  'AssignmentExpression': ['mostly-block']
}

DEFAULT_INDENT_DEPTH = '  '

exports.JavaScriptParser = class JavaScriptParser extends parser.Parser
  constructor: (@text, opts) ->
    super

    @opts.functions ?= KNOWN_FUNCTIONS
    @opts.categories = helper.extend({}, CATEGORIES, @opts.categories)

    @lines = @text.split '\n'

  markRoot: ->
    tree = acorn.parse(@text, {
      locations: true
      line: 0
      allowReturnOutsideFunction: true
    })

    @mark 0, tree, 0, null

  fullFunctionNameArray: (node) ->
    if node.type isnt 'CallExpression' and node.type isnt 'NewExpression'
      throw new Error
    obj = node.callee
    props = []
    while obj.type is 'MemberExpression'
      props.unshift obj.property.name
      obj = obj.object
    if obj.type is 'Identifier'
      props.unshift obj.name
    else
      props.unshift '*'
    props

  lookupFunctionName: (node) ->
    fname = @fullFunctionNameArray node
    full = fname.join '.'
    if full of @opts.functions
      return name: full, anyobj: false, fn: @opts.functions[full]
    last = fname[fname.length - 1]
    if fname.length > 1 and (wildcard = '*.' + last) not of @opts.functions
      wildcard = null  # no match for '*.foo'
    if not wildcard and (wildcard = '?.' + last) not of @opts.functions
      wildcard = null  # no match for '?.foo'
    if wildcard isnt null
      return name: last, anyobj: true, fn: @opts.functions[wildcard]
    return null

  getAcceptsRule: (node) -> default: helper.NORMAL
  getClasses: (node) ->
    if node.type of CLASS_EXCEPTIONS
      return CLASS_EXCEPTIONS[node.type].concat([node.type])
    else
      if node.type is 'CallExpression'
        known = @lookupFunctionName node
        if not known or (known.fn.value and known.fn.command)
          return [node.type, 'any-drop']
        if known.fn.value
          return [node.type, 'mostly-value']
        else
          return [node.type, 'mostly-block']
      if node.type.match(/Expression$/)?
        return [node.type, 'mostly-value']
      else if node.type.match(/Declaration$/)?
        return [node.type, 'block-only']
      else if node.type.match(/Statement$/)?
        return [node.type, 'mostly-block']
      else
        return [node.type, 'any-drop']

  getPrecedence: (node) ->
    switch node.type
      when 'BinaryExpression', 'LogicalExpression'
        return OPERATOR_PRECEDENCES[node.operator]
      when 'AssignStatement'
        return 16
      when 'UnaryExpression'
        if node.prefix
          return OPERATOR_PRECEDENCES[node.operator] ? 4
        else
          return OPERATOR_PRECEDENCES[node.operator] ? 3
      when 'CallExpression'
        return 2
      when 'NewExpression'
        return 2
      when 'MemberExpression'
        return 1
      when 'ExpressionStatement'
        return @getPrecedence node.expression
      else
        return 0

  lookupCategory: (node) ->
    switch node.type
      when 'BinaryExpression', 'UnaryExpression'
        if LOGICAL_OPERATORS.hasOwnProperty node.operator
          category = 'logic'
        else
          category = 'arithmetic'
      else
        category = NODE_CATEGORIES[node.type]
    return @opts.categories[category]

  getColor: (node) ->
    switch node.type
      when 'ExpressionStatement'
        return @getColor node.expression
      when 'CallExpression'
        known = @lookupFunctionName node
        if not known
          return @opts.categories.command.color
        else if known.fn.color
          return known.fn.color
        else if known.fn.value and not known.fn.command
          return @opts.categories.value.color
        else
          return @opts.categories.command.color
      else
        category = @lookupCategory node
        return category?.color or 'command'

  getSocketLevel: (node) -> helper.ANY_DROP

  getBounds: (node) ->
    # If we are a statement, scan
    # to find the semicolon
    if node.type is 'BlockStatement'
      bounds = {
        start: {
          line: node.loc.start.line
          column: node.loc.start.column + 1
        }
        end: {
          line: node.loc.end.line
          column: node.loc.end.column - 1
        }
      }

      if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
        bounds.end.line -= 1
        bounds.end.column = @lines[bounds.end.line].length

      return bounds

    else if node.type in STATEMENT_NODE_TYPES
      line = @lines[node.loc.end.line]
      semicolon = @lines[node.loc.end.line][node.loc.end.column - 1..].indexOf ';'
      if semicolon >= 0
        semicolonLength = @lines[node.loc.end.line][node.loc.end.column - 1..].match(/;\s*/)[0].length
        return {
          start: {
            line: node.loc.start.line
            column: node.loc.start.column
          }
          end: {
            line: node.loc.end.line
            column: node.loc.end.column + semicolon + semicolonLength - 1
          }
        }

    return {
      start: {
        line: node.loc.start.line
        column: node.loc.start.column
      }
      end: {
        line: node.loc.end.line
        column: node.loc.end.column
      }
    }

  getCaseIndentBounds: (node) ->
    bounds = {
      start: @getBounds(node.consequent[0]).start
      end: @getBounds(node.consequent[node.consequent.length - 1]).end
    }

    if @lines[bounds.start.line][...bounds.start.column].trim().length is 0
      bounds.start.line -= 1
      bounds.start.column = @lines[bounds.start.line].length

    if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
      bounds.end.line -= 1
      bounds.end.column = @lines[bounds.end.line].length

    return bounds

  getIndentPrefix: (bounds, indentDepth) ->
    if bounds.end.line - bounds.start.line < 1
      return DEFAULT_INDENT_DEPTH
    else
      line = @lines[bounds.start.line + 1]
      return line[indentDepth...(line.length - line.trimLeft().length)]

  isComment: (text) ->
    text.match(/^\s*\/\/.*$/)

  mark: (indentDepth, node, depth, bounds) ->
    switch node.type
      when 'Program'
        for statement in node.body
          @mark indentDepth, statement, depth + 1, null
      when 'Function'
        @jsBlock node, depth, bounds
        @mark indentDepth, node.body, depth + 1, null
      when 'SequenceExpression'
        @jsBlock node, depth, bounds
        for expression in node.expressions
          @jsSocketAndMark indentDepth, expression, depth + 1, null
      when 'FunctionDeclaration'
        @jsBlock node, depth, bounds
        @mark indentDepth, node.body, depth + 1, null
        @jsSocketAndMark indentDepth, node.id, depth + 1, null, null, ['no-drop']
        if node.params.length > 0
          @addSocket {
            bounds: {
              start: @getBounds(node.params[0]).start
              end: @getBounds(node.params[0]).end
            }
            depth: depth + 1
            precedence: 0
            dropdown: null
            classes: ['no-drop']
            empty: ''
          }
        else
          nodeBoundsStart = @getBounds(node.id).end
          match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*\()\s*\)/)
          if match?
            position = {
              line: nodeBoundsStart.line
              column: nodeBoundsStart.column + match[1].length
            }
            @addSocket {
              bounds: {
                start: position
                end: position
              },
              depth,
              precedence: 0,
              dropdown: null,
              classes: ['forbid-all', '__function_param__']
              empty: ''
            }
      when 'FunctionExpression'
        @jsBlock node, depth, bounds
        @mark indentDepth, node.body, depth + 1, null
        if node.id?
          @jsSocketAndMark indentDepth, node.id, depth + 1, null, null, ['no-drop']
        if node.params.length > 0
          @addSocket {
            bounds: {
              start: @getBounds(node.params[0]).start
              end: @getBounds(node.params[0]).end
            }
            depth: depth + 1
            precedence: 0
            dropdown: null
            classes: ['no-drop']
            empty: ''
          }
        else
          if node.id?
            nodeBoundsStart = @getBounds(node.id).end
            match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*\()\s*\)/)
          else
            nodeBoundsStart = @getBounds(node).start
            match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*function\s*\()\s*\)/)
          if match?
            position = {
              line: nodeBoundsStart.line
              column: nodeBoundsStart.column + match[1].length
            }
            @addSocket {
              bounds: {
                start: position
                end: position
              },
              depth,
              precedence: 0,
              dropdown: null,
              classes: ['forbid-all', '__function_param__']
              empty: ''
            }
      when 'AssignmentExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.left, depth + 1, null
        @jsSocketAndMark indentDepth, node.right, depth + 1, null
      when 'ReturnStatement'
        @jsBlock node, depth, bounds
        if node.argument?
          @jsSocketAndMark indentDepth, node.argument, depth + 1, null
      when 'IfStatement', 'ConditionalExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.test, depth + 1, NEVER_PAREN
        @jsSocketAndMark indentDepth, node.consequent, depth + 1, null

        # As long as the else fits the "else-if" pattern,
        # don't mark a new block. Instead, mark the condition
        # and body and continue down the elseif chain.
        currentElif = node.alternate
        while currentElif?
          if currentElif.type is 'IfStatement'
            @jsSocketAndMark indentDepth, currentElif.test, depth + 1, null
            @jsSocketAndMark indentDepth, currentElif.consequent, depth + 1, null
            currentElif = currentElif.alternate
          else
            @jsSocketAndMark indentDepth, currentElif, depth + 1, 10
            currentElif = null
      when 'ForInStatement'
        @jsBlock node, depth, bounds
        if node.left?
          @jsSocketAndMark indentDepth, node.left, depth + 1, NEVER_PAREN, null, ['foreach-lhs']
        if node.right?
          @jsSocketAndMark indentDepth, node.right, depth + 1, 10
        @mark indentDepth, node.body, depth + 1
      when 'BreakStatement', 'ContinueStatement'
        @jsBlock node, depth, bounds
        if node.label?
          @jsSocketAndMark indentDepth, node.label, depth + 1, null
      when 'ThrowStatement'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.argument, depth + 1, null
      when 'IfStatement', 'ConditionalExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.test, depth + 1, NEVER_PAREN
        @jsSocketAndMark indentDepth, node.consequent, depth + 1, null
        if node.alternate?
          @jsSocketAndMark indentDepth, node.alternate, depth + 1, 10
      when 'ForStatement'
        @jsBlock node, depth, bounds

        # If we are in beginner mode, check to see if the for loop
        # matches the "standard" way, and if so only mark the loop
        # limit (the "b" in "for (...;a < b;...)").
        if @opts.categories.loops.beginner and isStandardForLoop(node)
           @jsSocketAndMark indentDepth, node.test.right

        else
          if node.init?
            @jsSocketAndMark indentDepth, node.init, depth + 1, NEVER_PAREN, null, ['for-statement-init']
          if node.test?
            @jsSocketAndMark indentDepth, node.test, depth + 1, 10
          if node.update?
            @jsSocketAndMark indentDepth, node.update, depth + 1, 10, null, ['for-statement-update']

        @mark indentDepth, node.body, depth + 1
      when 'BlockStatement'
        prefix = @getIndentPrefix(@getBounds(node), indentDepth)
        indentDepth += prefix.length
        @addIndent
          bounds: @getBounds node
          depth: depth
          prefix: prefix

        for statement in node.body
          @mark indentDepth, statement, depth + 1, null
      when 'BinaryExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.left, depth + 1, OPERATOR_PRECEDENCES[node.operator]
        @jsSocketAndMark indentDepth, node.right, depth + 1, OPERATOR_PRECEDENCES[node.operator]
      when 'UnaryExpression'
        unless node.operator in ['-', '+'] and
            node.argument.type in ['Identifier', 'Literal']
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1, @getPrecedence node
      when 'ExpressionStatement'
        @mark indentDepth, node.expression, depth + 1, @getBounds node
      when 'Identifier'
        if node.name is '__'
          block = @jsBlock node, depth, bounds
          block.flagToRemove = true
      when 'CallExpression', 'NewExpression'
        @jsBlock node, depth, bounds
        known = @lookupFunctionName node
        if not known
          @jsSocketAndMark indentDepth, node.callee, depth + 1, NEVER_PAREN
        else if known.anyobj and node.callee.type is 'MemberExpression'
          @jsSocketAndMark indentDepth, node.callee.object, depth + 1, NEVER_PAREN
        for argument, i in node.arguments
          @jsSocketAndMark indentDepth, argument, depth + 1, NEVER_PAREN, null, null, known?.fn?.dropdown?[i]
      when 'MemberExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.object, depth + 1
        @jsSocketAndMark indentDepth, node.property, depth + 1
      when 'UpdateExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.argument, depth + 1
      when 'VariableDeclaration'
        @jsBlock node, depth, bounds
        for declaration in node.declarations
          @mark indentDepth, declaration, depth + 1
      when 'VariableDeclarator'
        @jsSocketAndMark indentDepth, node.id, depth
        if node.init?
          @jsSocketAndMark indentDepth, node.init, depth, NEVER_PAREN
      when 'LogicalExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.left, depth + 1, @getPrecedence node
        @jsSocketAndMark indentDepth, node.right, depth + 1, @getPrecedence node
      when 'WhileStatement', 'DoWhileStatement'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.body, depth + 1
        @jsSocketAndMark indentDepth, node.test, depth + 1
      when 'ObjectExpression'
        @jsBlock node, depth, bounds
        for property in node.properties
          @jsSocketAndMark indentDepth, property.key, depth + 1
          @jsSocketAndMark indentDepth, property.value, depth + 1
      when 'SwitchStatement'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.discriminant, depth + 1
        for switchCase in node.cases
          @mark indentDepth, switchCase, depth + 1, null
      when 'SwitchCase'
        if node.test?
          @jsSocketAndMark indentDepth, node.test, depth + 1

        if node.consequent.length > 0
          bounds = @getCaseIndentBounds node
          prefix = @getIndentPrefix(@getBounds(node), indentDepth)
          indentDepth += prefix.length

          @addIndent
            bounds: bounds
            depth: depth + 1
            prefix: prefix

          for statement in node.consequent
            @mark indentDepth, statement, depth + 2
      when 'TryStatement'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.block, depth + 1, null
        if node.handler?
          if node.handler.guard?
            @jsSocketAndMark indentDepth, node.handler.guard, depth + 1, null
          if node.handler.param?
            @jsSocketAndMark indentDepth, node.handler.param, depth + 1, null
          @jsSocketAndMark indentDepth, node.handler.body, depth + 1, null
        if node.finalizer?
          @jsSocketAndMark indentDepth, node.finalizer, depth + 1, null
      when 'ArrayExpression'
        @jsBlock node, depth, bounds
        for element in node.elements
          if element?
            @jsSocketAndMark indentDepth, element, depth + 1, null
      when 'Literal'
        null
      else
        console.log 'Unrecognized', node

  jsBlock: (node, depth, bounds) ->
    @addBlock
      bounds: bounds ? @getBounds node
      depth: depth
      precedence: @getPrecedence node
      color: @getColor node
      classes: @getClasses node
      socketLevel: @getSocketLevel node

  jsSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes, dropdown) ->
    unless node.type is 'BlockStatement'
      @addSocket
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: precedence
        classes: classes ? []
        dropdown: dropdown

    @mark indentDepth, node, depth + 1, bounds

JavaScriptParser.parens = (leading, trailing, node, context) ->
  # Don't attempt to paren wrap comments
  return if '__comment__' in node.classes

  if context?.type is 'socket' or
     (not context? and 'mostly-value' in node.classes or 'value-only' in node.classes) or
     'ends-with-brace' in node.classes or
     node.type is 'document'
    trailing trailing().replace(/;?\s*$/, '')
  else
    trailing trailing().replace(/;?\s*$/, ';')

  while true
    if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
      leading leading().replace(/^\s*\(\s*/, '')
      trailing trailing().replace(/\s*\)\s*$/, '')
    else
      break

  unless context is null or context.type isnt 'socket' or
      context.precedence > node.precedence
    leading '(' + leading()
    trailing trailing() + ')'

JavaScriptParser.drop = (block, context, pred) ->
  if context.type is 'socket'
    if 'lvalue' in context.classes
      if 'Value' in block.classes and block.properties?.length > 0
        return helper.ENCOURAGE
      else
        return helper.FORBID

    else if 'no-drop' in context.classes
      return helper.FORBID

    else if 'property-access' in context.classes
      if 'works-as-method-call' in block.classes
        return helper.ENCOURAGE
      else
        return helper.FORBID

    else if 'value-only' in block.classes or
        'mostly-value' in block.classes or
        'any-drop' in block.classes or
        'for-statement-init' in context.classes or
        ('mostly-block' in block.classes and
        'for-statement-update' in context.classes)
      return helper.ENCOURAGE

    else if 'mostly-block' in block.classes
      return helper.DISCOURAGE

  else if context.type in ['indent', 'document']
    if 'block-only' in block.classes or
        'mostly-block' in block.classes or
        'any-drop' in block.classes or
        block.type is 'document'
      return helper.ENCOURAGE

    else if 'mostly-value' in block.classes
      return helper.DISCOURAGE

  return helper.DISCOURAGE

# Check to see if a "for" loop is standard, for beginner mode.
# We will simplify any loop of the form:
# ```
# for (var i = X; i < Y; i++) {
#   // etc...
# }
# `
# Where "var" is optional and "i++" can be pre- or postincrement.
isStandardForLoop = (node) ->
  unless node.init? and node.test? and node.update?
    return false

  # A standard for loop starts with "var a =" or "a = ".
  # Determine the variable name so that we can check against it
  # in the other two expression.
  if node.init.type is 'VariableDeclaration'
    variableName = node.init.declarations[0].id.name
  else if node.init.type is 'AssignmentExpression' and
      node.operator is '=' and
      node.left.type is 'Identifier'
    variableName = node.left.name
  else
    return false

  return (node.test.type is 'BinaryExpression' and
      node.test.operator is '<' and
      node.test.left.type is 'Identifier' and
      node.test.left.name is variableName and
      node.update.type is 'UpdateExpression' and
      node.update.operator is '++' and
      node.update.argument.type is 'Identifier' and
      node.update.argument.name is variableName)

JavaScriptParser.empty = "__"
JavaScriptParser.emptyIndent = ""
JavaScriptParser.startComment = '/*'
JavaScriptParser.endComment = '*/'

JavaScriptParser.getDefaultSelectionRange = (string) ->
  start = 0; end = string.length
  if string[0] is string[string.length - 1] and string[0] in ['"', '\'', '/']
    start += 1; end -= 1
  return {start, end}

module.exports = parser.wrapParser JavaScriptParser
