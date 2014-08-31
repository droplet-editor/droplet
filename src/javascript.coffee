define ['melt-helper', 'melt-model', 'melt-parser', 'acorn'], (helper, model, parser, acorn) ->
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
  ]

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

      @mark tree, 0, null

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
        when 'BinaryExpression'
          return 'value'
        when 'FunctionExpression'
          return 'command'
        when 'FunctionDeclaration'
          return 'control'
        when 'AssignmentExpression'
          return 'command'
        when 'CallExpression'
          return 'command'
        when 'ReturnStatement'
          return 'return'
        when 'MemberExpression'
          return 'value'

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
        semicolon = @lines[node.loc.end.line][node.loc.end.column...].indexOf ';'
        if semicolon > 0
          return {
            start: {
              line: node.loc.start.line
              column: node.loc.start.column
            }
            end: {
              line: node.loc.end.line
              column: node.loc.end.column + semicolon
            }
          }

      return node.loc

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

    mark: (node, depth, bounds) ->
      switch node.type
        when 'Program'
          for statement in node.body
            @mark statement, depth + 1, null
        when 'Function'
          @jsBlock node, depth, bounds
          @mark node.body, depth + 1, null
        when 'FunctionDeclaration'
          @jsBlock node, depth, bounds
          @mark node.body, depth + 1, null
          @jsSocketAndMark node.id, depth + 1
        when 'FunctionExpression'
          @jsBlock node, depth, bounds
          @mark node.body, depth + 1, null
          if node.id?
            @jsSocketAndMark node.id, depth + 1
        when 'AssignmentExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark node.left, depth + 1, null
          @jsSocketAndMark node.right, depth + 1, null
        when 'ReturnStatement'
          @jsBlock node, depth, bounds
          if node.argument?
            @jsSocketAndMark node.argument, depth + 1, null
        when 'BlockStatement'
          @addIndent
            bounds: @getBounds node
            depth: depth
            prefix: '  '

          for statement in node.body
            @mark statement, depth + 1, null
        when 'BinaryExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark node.left, depth + 1, operatorPrecedences[node.operator]
          @jsSocketAndMark node.right, depth + 1, operatorPrecedences[node.operator]
        when 'ExpressionStatement'
          @mark node.expression, depth + 1, @getBounds node
        when 'CallExpression'
          @jsBlock node, depth, bounds
          for argument in node.arguments
            @jsSocketAndMark argument, depth, 10
        when 'MemberExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark node.object, depth + 1
          @jsSocketAndMark node.property, depth + 1

    jsBlock: (node, depth, bounds) ->
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: @getPrecedence node
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    jsSocketAndMark: (node, depth, precedence, bounds) ->
      @addSocket
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: precedence
        accepts: @getAcceptsRule node

      @mark node, depth + 1, bounds

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
