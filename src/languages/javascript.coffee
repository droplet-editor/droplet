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

PRECEDENCE = {
  'AssignStatement': 16
  'CallExpression': 2
  'NewExpression': 2
  'MemberExpression': 1
  'Expression': NEVER_PAREN
  'Lvalue': NEVER_PAREN
  'IfTest': NEVER_PAREN
  'ForEachLHS': NEVER_PAREN
  'ForEachRHS': 10
  'ForInit': NEVER_PAREN
  'ForUpdate': 10
  'Callee': NEVER_PAREN # Actually so?
  'CalleeObject': NEVER_PAREN # Actually so?
}

for operator, precedence of OPERATOR_PRECEDENCES
  PRECEDENCE['Operator' + operator] = precedence

getPrecedence = (type) ->
  PRECEDENCE[type] ? 0

SEMICOLON_EXCEPTIONS = {
  'ForStatement': true
  'FunctionDeclaration': true
  'IfStatement': true
  'WhileStatement': true
  'DoWhileStatement': true
  'SwitchStatement': true
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

  fullNameArray: (obj) ->
    props = []
    while obj.type is 'MemberExpression'
      props.unshift obj.property.name
      obj = obj.object
    if obj.type is 'Identifier'
      props.unshift obj.name
    else
      props.unshift '*'
    props

  lookupKnownName: (node) ->
    if node.type is 'CallExpression' or node.type is 'NewExpression'
      identifier = false
    else if node.type is 'Identifier' or node.type is 'MemberExpression'
      identifier = true
    else
      throw new Error
    fname = @fullNameArray if identifier then node else node.callee
    full = fname.join '.'
    fn = @opts.functions[full]
    if fn and ((identifier and fn.property) || (not identifier and not fn.property))
      return name: full, anyobj: false, fn: @opts.functions[full]
    last = fname[fname.length - 1]
    if fname.length > 1 and (wildcard = '*.' + last) not of @opts.functions
      wildcard = null  # no match for '*.foo'
    if not wildcard and (wildcard = '?.' + last) not of @opts.functions
      wildcard = null  # no match for '?.foo'
    if wildcard isnt null
      fn = @opts.functions[wildcard]
      if fn and ((identifier and fn.property) || (not identifier and not fn.property))
        return name: last, anyobj: true, fn: @opts.functions[wildcard]
    return null

  getAcceptsRule: (node) -> default: helper.NORMAL
  getShape: (node) ->
    if node.type is 'CallExpression' or node.type is 'NewExpression' or node.type is 'Identifier'
      known = @lookupKnownName node
      if not known or (known.fn.value and known.fn.command)
        return helper.ANY_DROP
      if known.fn.value
        return helper.MOSTLY_VALUE
      else
        return helper.MOSTLY_BLOCK
    else if node.type in ['ForStatement', 'FunctionDeclaration', 'IfStatement', 'WhileStatement', 'DoWhileStatement', 'SwitchStatement']
      return helper.BLOCK_ONLY
    else if node.type is 'AssignExpression'
      return helper.MOSTLY_BLOCK
    else if node.type.match(/Expression$/)?
      return helper.MOSTLY_VALUE
    else if node.type.match(/Declaration$/)?
      return helper.BLOCK_ONLY
    else if node.type.match(/Statement$/)?
      return helper.MOSTLY_BLOCK
    else
        return helper.ANY_DROP

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
      when 'CallExpression', 'NewExpression', 'MemberExpression', 'Identifier'
        known = @lookupKnownName node
        if known
          if known.fn.color
            return known.fn.color
          else if known.fn.value and not known.fn.command
            return @opts.categories.value.color
    category = @lookupCategory node
    return category?.color or 'command'

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

      bounds.start.column += (@lines[bounds.start.line][bounds.start.column..].match(/^\s*/) ? [''])[0].length

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
    text.match(/^\s*\/\/.*$/)?

  parseComment: (text) ->
    {
      sockets: [[text.match(/^\s*\/\//)[0].length, text.length]]
    }

  handleButton: (text, button, oldBlock) ->
    if button is 'add-button' and 'IfStatement' in oldBlock.classes
      # Parse to find the last "else" or "else if"
      node = acorn.parse(text, {
        locations: true
        line: 0
        allowReturnOutsideFunction: true
      }).body[0]
      currentElif = node
      elseLocation = null
      while true
        if currentElif.type is 'IfStatement'
          if currentElif.alternate?
            elseLocation = {
              line: currentElif.alternate.loc.start.line
              column: currentElif.alternate.loc.start.column
            }
            currentElif = currentElif.alternate
          else
            elseLocation = null
            break
        else
          break

      if elseLocation?
        lines = text.split('\n')
        elseLocation = lines[...elseLocation.line].join('\n').length + elseLocation.column + 1
        return text[...elseLocation].trimRight() + ' if (__) ' + text[elseLocation..].trimLeft() + ''' else {
          __
        }'''
      else
        return text + ''' else {
          __
        }'''
    else if 'CallExpression' in oldBlock.classes
      # Parse to find the last "else" or "else if"
      node = acorn.parse(text, {
        line: 0
        allowReturnOutsideFunction: true
      }).body[0]
      known = @lookupKnownName node.expression
      argCount = node.expression.arguments.length
      if button is 'add-button'
        maxArgs = known?.fn.maxArgs
        maxArgs ?= Infinity
        if argCount >= maxArgs
          return
        if argCount
          lastArgPosition = node.expression.arguments[argCount - 1].end
          return text[...lastArgPosition].trimRight() + ', __' + text[lastArgPosition..].trimLeft()
        else
          lastArgPosition = node.expression.end - 1
          return text[...lastArgPosition].trimRight() + '__' + text[lastArgPosition..].trimLeft()
      else if button is 'subtract-button'
        minArgs = known?.fn.minArgs
        minArgs ?= 0
        if argCount <= minArgs
          return
        if argCount > 0
          lastArgPosition = node.expression.arguments[argCount - 1].end
          if argCount is 1
            newLastArgPosition = node.expression.arguments[0].start
          else
            newLastArgPosition = node.expression.arguments[argCount - 2].end
          return text[...newLastArgPosition].trimRight() + text[lastArgPosition..].trimLeft()

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
        @jsSocketAndMark indentDepth, node.id, depth + 1, 'Identifier', null
        if node.params.length > 0
          @addSocket {
            bounds: {
              start: @getBounds(node.params[0]).start
              end: @getBounds(node.params[node.params.length - 1]).end
            }
            depth: depth + 1
            parseContext: '__comment__'
            dropdown: null
            empty: ''
          }
        else unless @opts.lockZeroParamFunctions
          nodeBoundsStart = @getBounds(node.id).end
          match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*\()(\s*)\)/)
          if match?
            @addSocket {
              bounds: {
                start: {
                  line: nodeBoundsStart.line
                  column: nodeBoundsStart.column + match[1].length
                }
                end: {
                  line: nodeBoundsStart.line
                  column: nodeBoundsStart.column + match[1].length + match[2].length
                }
              },
              depth,
              parseContext: '__comment__'
              dropdown: null,
              empty: ''
            }
      when 'FunctionExpression'
        @jsBlock node, depth, bounds
        @mark indentDepth, node.body, depth + 1, null
        if node.id?
          @jsSocketAndMark indentDepth, node.id, depth + 1, 'Identifier', null
        if node.params.length > 0
          @addSocket {
            bounds: {
              start: @getBounds(node.params[0]).start
              end: @getBounds(node.params[node.params.length - 1]).end
            }
            depth: depth + 1
            parseContext: '__comment__'
            empty: ''
          }
        else unless @opts.lockZeroParamFunctions
          if node.id?
            nodeBoundsStart = @getBounds(node.id).end
            match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*\()(\s*)\)/)
          else
            nodeBoundsStart = @getBounds(node).start
            match = @lines[nodeBoundsStart.line][nodeBoundsStart.column..].match(/^(\s*function\s*\()(\s*)\)/)
          if match?
            position =
            @addSocket {
              bounds: {
                start: {
                  line: nodeBoundsStart.line
                  column: nodeBoundsStart.column + match[1].length
                }
                end: {
                  line: nodeBoundsStart.line
                  column: nodeBoundsStart.column + match[1].length + match[2].length
                }
              },
              depth,
              precedence: 0,
              dropdown: null,
              parseContext: '__comment__'
              empty: ''
            }
      when 'AssignmentExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.left, depth + 1, 'Lvalue'
        @jsSocketAndMark indentDepth, node.right, depth + 1, 'Expression'
      when 'ReturnStatement'
        @jsBlock node, depth, bounds
        if node.argument?
          @jsSocketAndMark indentDepth, node.argument, depth + 1, null
      when 'IfStatement', 'ConditionalExpression'
        @jsBlock node, depth, bounds, {addButton: '+'}
        @jsSocketAndMark indentDepth, node.test, depth + 1, 'Expression'
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
          @jsSocketAndMark indentDepth, node.left, depth + 1, 'ForEachLHS', null, ['foreach-lhs']
        if node.right?
          @jsSocketAndMark indentDepth, node.right, depth + 1, 'ForEachRHS'
        @mark indentDepth, node.body, depth + 1
      when 'BreakStatement', 'ContinueStatement'
        @jsBlock node, depth, bounds
        if node.label?
          @jsSocketAndMark indentDepth, node.label, depth + 1, null
      when 'ThrowStatement'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.argument, depth + 1, null
      when 'ForStatement'
        @jsBlock node, depth, bounds

        # If we are in beginner mode, check to see if the for loop
        # matches the "standard" way, and if so only mark the loop
        # limit (the "b" in "for (...;a < b;...)").
        if @opts.categories.loops.beginner and isStandardForLoop(node)
           @jsSocketAndMark indentDepth, node.test.right

        else
          if node.init?
            @jsSocketAndMark indentDepth, node.init, depth + 1, 'ForInit', null, ['for-statement-init']
          if node.test?
            @jsSocketAndMark indentDepth, node.test, depth + 1, 'Expression'
          if node.update?
            @jsSocketAndMark indentDepth, node.update, depth + 1, 'ForUpdate', null, ['for-statement-update']

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
        @jsSocketAndMark indentDepth, node.left, depth + 1, 'Operator' + node.operator
        @jsSocketAndMark indentDepth, node.right, depth + 1, 'Operator' + node.operator
      when 'UnaryExpression'
        unless node.operator in ['-', '+'] and
            node.argument.type in ['Identifier', 'Literal']
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1, null
      when 'ExpressionStatement'
        @mark indentDepth, node.expression, depth + 1, @getBounds node
      when 'Identifier'
        if node.name is '__'
          block = @jsBlock node, depth, bounds
          block.flagToRemove = true
        else if @lookupKnownName node
          @jsBlock node, depth, bounds
      when 'CallExpression', 'NewExpression'
        known = @lookupKnownName node
        blockOpts = {}
        argCount = node.arguments.length
        if known?.fn
          showButtons = known.fn.minArgs? or known.fn.maxArgs?
          minArgs = known.fn.minArgs ? 0
          maxArgs = known.fn.maxArgs ? Infinity
        else
          showButtons = @opts.paramButtonsForUnknownFunctions and
              (argCount isnt 0 or not @opts.lockZeroParamFunctions)
          minArgs = 0
          maxArgs = Infinity

        if showButtons
          if argCount < maxArgs
            blockOpts.addButton = '\u21A0'
          if argCount > minArgs
            blockOpts.subtractButton = '\u219E'
        @jsBlock node, depth, bounds, blockOpts

        if not known
          @jsSocketAndMark indentDepth, node.callee, depth + 1, 'Callee'
        else if known.anyobj and node.callee.type is 'MemberExpression'
          @jsSocketAndMark indentDepth, node.callee.object, depth + 1, 'CalleeObject', null, null, known?.fn?.objectDropdown
        for argument, i in node.arguments
          @jsSocketAndMark indentDepth, argument, depth + 1, 'Expression', null, null, known?.fn?.dropdown?[i]
        if not known and argCount is 0 and not @opts.lockZeroParamFunctions
          # Create a special socket that can be used for inserting the first parameter
          # (NOTE: this socket may not be visible if the bounds start/end are the same)
          position = {
            line: node.callee.loc.end.line
            column: node.callee.loc.end.column
          }
          string = @lines[position.line][position.column..].match(/^\s*\(/)[0]
          position.column += string.length
          endPosition = {
            line: position.line
            column: position.column
          }
          space = @lines[position.line][position.column..].match(/^(\s*)\)/)
          if space?
            endPosition.column += space[1].length
          @addSocket {
            bounds: {
              start: position
              end: endPosition
            }
            depth: depth + 1
            precedence: NEVER_PAREN
            dropdown: null
            classes: ['mostly-value']
            empty: ''
          }
      when 'MemberExpression'
        @jsBlock node, depth, bounds
        known = @lookupKnownName node
        if not known
          @jsSocketAndMark indentDepth, node.property, depth + 1
        if not known or known.anyobj
          @jsSocketAndMark indentDepth, node.object, depth + 1
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
          @jsSocketAndMark indentDepth, node.init, depth, 'Lvalue'
      when 'LogicalExpression'
        @jsBlock node, depth, bounds
        @jsSocketAndMark indentDepth, node.left, depth + 1, 'Operator' + node.operator
        @jsSocketAndMark indentDepth, node.right, depth + 1, 'Operator' + node.operator
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

  jsBlock: (node, depth, bounds, buttons) ->
    bounds ?= @getBounds node

    @addBlock
      bounds: bounds
      depth: depth
      color: @getColor node
      shape: @getShape node
      buttons: buttons

      parseContext: 'program'
      nodeContext: @getNodeContext node, bounds

  getType: (node) ->
    if node.type in ['BinaryExpression', 'LogicalExpression', 'UnaryExpression', 'UpdateExpression']
      return 'Operator' + node.operator
    else
      return node.type


  getNodeContext: (node, bounds, type) ->
    type ?= @getType node

    innerBounds = @getBounds node
    prefix = helper.clipLines @lines, bounds.start, innerBounds.start
    suffix = helper.clipLines @lines, innerBounds.end, bounds.end

    return new parser.PreNodeContext type, prefix.length, suffix.length

  jsSocketAndMark: (indentDepth, node, depth, type, bounds, classes, dropdown, empty) ->
    unless node.type is 'BlockStatement'
      bounds ?= @getBounds node

      @addSocket
        bounds: bounds
        depth: depth

        parseContext: type ? 'program'

        dropdown: dropdown
        empty: empty

    @mark indentDepth, node, depth + 1, bounds

JavaScriptParser.parens = (leading, trailing, node, context) ->
  # Don't attempt to paren wrap comments
  return if '__comment__' is node.parseContext

  if context?.type is 'socket' or
     (not context? and helper.MOSTLY_VALUE is node.shape or helper.VALUE_ONLY is node.shape) or
     SEMICOLON_EXCEPTIONS[node.nodeContext.type] or
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
      getPrecedence(context.parseContext) > getPrecedence(node.nodeContext.type)
    console.log context.parseContext, node.nodeContext.type, getPrecedence(context.parseContext), getPrecedence(node.nodeContext.type)
    leading '(' + leading()
    trailing trailing() + ')'

JavaScriptParser.drop = (block, context, pred) ->
  if context.parseContext is '__comment__'
    return helper.FORBID

  if context.type is 'socket'
    if context.parseContext in ['Lvalue', 'ForEachLHS']
      if block.nodeContext.type is 'ObjectExpression'
        return helper.ENCOURAGE
      else
        return helper.FORBID

    else if block.shape in [helper.VALUE_ONLY, helper.MOSTLY_VALUE, helper.ANY_DROP] or
        context.parseContext is 'ForInit' or
        (block.shape is helper.MOSTLY_BLOCK and
        context.parseContext is 'ForUpdate')
      return helper.ENCOURAGE

    else if block.shape is helper.MOSTLY_BLOCK
      return helper.DISCOURAGE

  else if context.type in ['indent', 'document']
    if block.shape in [helper.BLOCK_ONLY, helper.MOSTLY_BLOCK, helper.ANY_DROP] or
        block.type is 'document'
      return helper.ENCOURAGE

    else if block.shape is helper.MOSTLY_VALUE
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
      node.test.right.type in ['Literal', 'Identifier'] and
      node.update.type is 'UpdateExpression' and
      node.update.operator is '++' and
      node.update.argument.type is 'Identifier' and
      node.update.argument.name is variableName)

JavaScriptParser.empty = "__"
JavaScriptParser.emptyIndent = ""
JavaScriptParser.startComment = '/*'
JavaScriptParser.endComment = '*/'
JavaScriptParser.startSingleLineComment = '//'

JavaScriptParser.getDefaultSelectionRange = (string) ->
  start = 0; end = string.length
  if string[0] is string[string.length - 1] and string[0] in ['"', '\'', '/']
    start += 1; end -= 1
  return {start, end}

module.exports = parser.wrapParser JavaScriptParser
