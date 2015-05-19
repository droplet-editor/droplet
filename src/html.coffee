###
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
###

define ['droplet-helper', 'droplet-parser', 'parse5'], (helper, parser, parse5) ->

  exports = {}

  COLORS = {
    'Default': 'cyan',
  }

  MOSTLY_VALUE = ['any-drop']

  DEFAULT_INDENT_DEPTH = '  '

  exports.HTMLParser = class HTMLParser extends parser.Parser

    constructor: (@text, @opts = {}) ->
      super
      @htmlParser = new parse5.Parser parse5.TreeAdapters.default, {locationInfo: true}
      @positions = []
      line = 0
      column = 0
      for val, i in @text
        if val is '\n'
          line++
          column = 0
          continue
        @positions[i] = {'line': line, 'column': column}
        column++

    getAcceptsRule: (node) -> default: helper.NORMAL

    getPrecedence: (node) -> 1

    getClasses: (node) -> MOSTLY_VALUE

    getColor: (node) -> COLORS[node.type] ? COLORS['Default']

    getBounds: (node) ->
      bounds = {
        start: @positions[node.__location.start]
        end: @positions[node.__location.end-1]
      }
      bounds.end.column += 1

      return bounds

    getSocketLevel: (node) -> helper.ANY_DROP

    htmlBlock: (node, depth, bounds) ->
      console.log "Adding Block: ", JSON.stringify(bounds ? @getBounds node)
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: @getPrecedence node
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    htmlSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes) ->
      console.log "Adding Socket: ", JSON.stringify(bounds ? @getBounds node)
      @addSocket
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: precedence
        classes: classes ? []
        acccepts: @getAcceptsRule node

      @mark indentDepth, node, depth + 1, bounds

    getIndentPrefix: (bounds, indentDepth) ->
      if bounds.end.line - bounds.start.line < 1
        return DEFAULT_INDENT_DEPTH
      else
        line = @lines[bounds.start.line + 1]
        return line[indentDepth...(line.length - line.trimLeft().length)]

    markRoot: ->
      root = @htmlParser.parse @text
      console.log root
      @mark 0, root, 0, null

    mark: (indentDepth, node, depth, bounds) ->
      switch node.nodeName
        when '#document'
          for rule in node.childNodes
            @mark indentDepth, rule, depth + 1, null
        when '#documentType'
          @htmlBlock node, depth, bounds
        when 'html'
          @htmlBlock node, depth, bounds
          for child in node.childNodes
            @mark indentDepth, child, depth+1, null
        when 'declaration'
          @htmlBlock node, depth, bounds
          @htmlSocketAndMark indentDepth, node.property, depth + 1, null
          @htmlSocketAndMark indentDepth, node.value, depth + 1, null

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

  HTMLParser.parens = (leading, trainling, node, context) ->
    return [leading, trainling]

  return parser.wrapParser HTMLParser