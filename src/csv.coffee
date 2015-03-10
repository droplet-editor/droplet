
define ['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], (helper, model, parser, acorn) ->
  COLORS = {
    'SequenceExpression': 'command'
  }
  STATEMENT_NODE_TYPES = [
    'ExpressionStatement'
  ]


  class csv extends parser.Parser
    constructor: (@text, @opts = {}) ->
        super
        @lines = @text.split '\n'
        #console.log(@text)
    markRoot: ->
        tree = acorn.parse(@text, {
          locations: true
          line: 0
          allowReturnOutsideFunction: true
        })
        #console.log @text
        #console.log @lines
        #console.log 'PROGRAM IS', JSON.stringify tree, null, 2

        @mark 0, tree, 0, null

    getBounds: (node) ->
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

    getColor: (node) ->
      return 'command'

    getSocketLevel: (node) -> helper.ANY_DROP
    getAcceptsRule: (node) -> default: helper.NORMAL

    getClasses: (node) ->
      if node.type.match(/Expression$/)?
        return [node.type, 'mostly-value']
      else if node.type.match(/(Statement|Declaration)$/)?
        return [node.type, 'mostly-block']
      else
        return [node.type, 'any-drop']

    mark: (indentDepth, node, depth, bounds) ->
      switch node.type
        when 'Program'
          for statement in node.body
            @mark indentDepth, statement, depth + 1, null
        when 'ExpressionStatement'
          @mark indentDepth, node.expression, depth + 1, @getBounds node
        when 'SequenceExpression'
          @csvBlock node, depth, bounds
          for expression in node.expressions
            @csvSocketAndMark indentDepth, expression, depth + 1, null

    isComment: (str) ->
      str.match(/^\s*#.*$/)?

    csvBlock: (node, depth, bounds) ->
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: 0
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    csvSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes) ->
      unless node.type is 'BlockStatement'
        @addSocket
          bounds: bounds ? @getBounds node
          depth: depth
          precedence: 0
          classes: classes ? []
          accepts: @getAcceptsRule node
      @mark indentDepth, node, depth + 1, bounds

  return parser.wrapParser csv
