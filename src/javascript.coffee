define ['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], (helper, model, parser, acorn) ->
  exports = {}

  operatorPrecedences = {
    '+': 0
    '-': 0
    '/': 1
    '*': 1
  }

  STATEMENT_NODE_TYPES = [
    'ExpressionStatement'
    'ReturnStatement'
    'BreakStatement'
    'ThrowStatement'
  ]

  COLORS = {
    'BinaryExpression': 'value'
    'FunctionExpression': 'value'
    'FunctionDeclaration': 'control'
    'AssignmentExpression': 'command'
    'CallExpression': 'command'
    'ReturnStatement': 'return'
    'MemberExpression': 'value'
    'IfStatement': 'control'
    'ForStatement': 'control'
    'UpdateExpression': 'command'
    'VariableDeclaration': 'command'
    'LogicalExpression': 'value'
    'WhileStatement': 'control'
    'DoWhileStatement': 'control'
    'ObjectExpression': 'value'
    'SwitchStatement': 'control'
    'BreakStatement': 'return'
    'NewExpression': 'command'
    'ThrowStatement': 'return'
    'TryStatement': 'control'
    'ArrayExpression': 'value'
    'SequenceExpression': 'command'
    'ConditionalExpression': 'value'
  }

  DEFAULT_INDENT_DEPTH = '  '

  exports.JavaScriptParser = class JavaScriptParser extends parser.Parser
    constructor: ->
      super

      @lines = @text.split '\n'

    markRoot: ->
      tree = acorn.parse(@text, {
        locations: true
        line: 0
      })

      #console.log 'PROGRAM IS', JSON.stringify tree, null, 2

      @mark 0, tree, 0, null

    getAcceptsRule: (node) -> default: helper.NORMAL
    getClasses: (node) -> []

    getPrecedence: (node) ->
      switch node.type
        when 'BinaryExpression'
          return operatorPrecedences[node.operator]
        when 'CallExpression'
          return 10
        when 'ExpressionStatement'
          return @getPrecedence node.expression
        else
          return 0

    getColor: (node) ->
      switch node.type
        when 'ExpressionStatement'
          return @getColor node.expression
        else
          return COLORS[node.type]

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
          @jsSocketAndMark indentDepth, node.id, depth + 1
        when 'FunctionExpression'
          @jsBlock node, depth, bounds
          @mark indentDepth, node.body, depth + 1, null
          if node.id?
            @jsSocketAndMark indentDepth, node.id, depth + 1
          for param in node.params
            @jsSocketAndMark indentDepth, param, depth + 1
        when 'AssignmentExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.left, depth + 1, null
          @jsSocketAndMark indentDepth, node.right, depth + 1, null
        when 'ReturnStatement'
          @jsBlock node, depth, bounds
          if node.argument?
            @jsSocketAndMark indentDepth, node.argument, depth + 1, null
        when 'BreakStatement', 'ContinueStatement'
          @jsBlock node, depth, bounds
          if node.label?
            @jsSocketAndMark indentDepth, node.label, depth + 1, null
        when 'ThrowStatement'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1, null
        when 'IfStatement', 'ConditionalExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.test, depth + 1, 10
          @jsSocketAndMark indentDepth, node.consequent, depth + 1, null
          if node.alternate?
            @jsSocketAndMark indentDepth, node.alternate, depth + 1, 10
        when 'ForStatement'
          @jsBlock node, depth, bounds
          if node.init?
            @jsSocketAndMark indentDepth, node.init, depth + 1, 10
          if node.test?
            @jsSocketAndMark indentDepth, node.test, depth + 1, 10
          if node.update?
            @jsSocketAndMark indentDepth, node.update, depth + 1, 10

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
          @jsSocketAndMark indentDepth, node.left, depth + 1, operatorPrecedences[node.operator]
          @jsSocketAndMark indentDepth, node.right, depth + 1, operatorPrecedences[node.operator]
        when 'ExpressionStatement'
          @mark indentDepth, node.expression, depth + 1, @getBounds node
        when 'CallExpression', 'NewExpression'
          @jsBlock node, depth, bounds
          if node.callee.type isnt 'Identifier'
            @jsSocketAndMark indentDepth, node.callee, depth + 1, 10
          for argument in node.arguments
            @jsSocketAndMark indentDepth, argument, depth + 1, 10
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
            @jsSocketAndMark indentDepth, node.init, depth
        when 'LogicalExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.left, depth + 1
          @jsSocketAndMark indentDepth, node.right, depth + 1
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

    jsBlock: (node, depth, bounds) ->
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: @getPrecedence node
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    jsSocketAndMark: (indentDepth, node, depth, precedence, bounds) ->
      unless node.type is 'BlockStatement'
        @addSocket
          bounds: bounds ? @getBounds node
          depth: depth
          precedence: precedence
          accepts: @getAcceptsRule node

      @mark indentDepth, node, depth + 1, bounds

  exports.parse = (text, opts) ->
    parser = new JavaScriptParser text
    return parser.parse opts

  exports.parens = (leading, trailing, node, context) ->
    if context?.type is 'socket'
      trailing = trailing.replace(/;?\s*$/, '')
    else
      trailing = trailing.replace(/;?\s*$/, ';')
    if context is null or context.type isnt 'socket' or
        context.precedence < node.precedence
      while true
        if leading.match(/^\s*\(/)? and trailing.match(/\)\s*/)?
          leading = leading.replace(/^\s*\(\s*/, '')
          trailing = trailing.replace(/^\s*\)\s*/, '')
        else
          break
    else
      leading = '(' + leading
      trailing = trailing + ')'

    return [leading, trailing]

  exports.empty = "eval('')"

  return exports
