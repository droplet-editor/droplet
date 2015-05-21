###
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
###

define ['droplet-helper', 'droplet-parser', 'parse5', 'html-nodes', 'html-stack'], (helper, parser, parse5, model, html_stack) ->

  exports = {}

  COLORS = {
    'Default': 'cyan',
  }

  MOSTLY_VALUE = ['any-drop']

  DEFAULT_INDENT_DEPTH = '  '

  stack = new html_stack.Stack()
  htmlParser = new parse5.SimpleApiParser {
    doctype: (name, publicId, systemId, location) ->
      #console.log(name, publicId, systemId, location)
      stack.push(new model.tagNode 'empty', 'doctype', location)
      #stack.debug()
    startTag: (tagName, attrs, selfClosing, location) ->
      #console.log( tagName, attrs, selfClosing, location)
      if selfClosing
        stack.push(new model.tagNode 'empty', tagName, location)
      else
        node = new model.tagNode('start', tagName, location)
        stack.start(new model.blockNode node)
      #stack.debug()
    endTag: (tagName, location) ->
      #console.log( tagName, location)
      stack.end(location)
      #stack.debug()
    text: (text, location) ->
      #console.log(text.length, text, location)
      textTmp = text.trimLeft()
      location.start += text.length - textTmp.length
      text = textTmp.trimRight()
      location.end -= textTmp.length - text.length
      stack.push new model.textNode location
      #stack.debug()
    comment: (text, location) ->
      #console.log( text, location)
      stack.push new model.commentNode location
      #stack.debug()
    }, {locationInfo: true}


  exports.HTMLParser = class HTMLParser extends parser.Parser

    constructor: (@text, @opts = {}) ->
      super

      @lines = @text.split '\n'

      @positions = []
      line = 0
      column = 0
      for val, i in @text
        @positions[i] = {'line': line, 'column': column}
        column++
        if val is '\n'
          line++
          column = 0

    getAcceptsRule: (node) -> default: helper.NORMAL

    getPrecedence: (node) -> 1

    getClasses: (node) -> MOSTLY_VALUE

    getColor: (node) -> COLORS[node.type] ? COLORS['Default']

    getBounds: (node) ->
      bounds = {
        start: @positions[node.location.start]
        end: @positions[node.location.end]
      }

      return bounds

    makeBounds: (location) ->
      line = @positions[location.end].line - 1
      column = @lines[line].length
      return {
        start: @positions[location.start]
        end: {line: line, column: column}
      }

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

      #@mark indentDepth, node, depth + 1, bounds

    getIndentPrefix: (bounds, indentDepth) ->
      if bounds.end.line - bounds.start.line < 1
        return DEFAULT_INDENT_DEPTH
      else
        line = @lines[bounds.start.line + 1]
        return line[indentDepth...(line.length - line.trimLeft().length)]

    markRoot: ->
      try
        stack.clear()
        stack.start(new model.blockNode(new model.tagNode('start', 'document', {start:null, end:null})))
        htmlParser.parse @text
        root = stack.top()
        console.log root
        @mark 0, root, 0, null
      catch e
        console.log e
        console.log e.stack

    mark: (indentDepth, node, depth, bounds) ->
      if node.name is 'document'
        for child in node.children
          @mark indentDepth, child, depth + 1, null
        return

      switch node.type
        when 'blockTag'
          @htmlBlock node, depth, bounds
          depth += 1
          prefix = @getIndentPrefix(@makeBounds(node.consequentLocation), indentDepth)
          indentDepth += prefix.length
          console.log "Adding Indent: ", JSON.stringify(@makeBounds node.consequentLocation)
          @addIndent
            bounds: @makeBounds(node.consequentLocation)
            depth: depth
            prefix: prefix
          for child in node.children
            @mark indentDepth, child, depth + 1, null
        when 'emptyTag'
          @htmlBlock node, depth, bounds
        #when 'text'
        #  if node.location.start isnt node.location.end
        #    @htmlSocketAndMark indentDepth, node, depth + 1, null
      ###
      if node.type is 'document'
        for rule in node.childNodes
          @mark indentDepth, rule, depth + 1, null

      else if node.type is 'doctype'
        @htmlBlock node, depth, bounds

      else if isSpecial node.nodeName
        #Do something...

      else if isBlock node.nodeName
        @htmlBlock node, depth, bounds

        if node.childNodes? and node.childNodes.length isnt 0
          console.log node
          bounds = @makeBounds(node.childNodes[0].__location.start, node.childNodes[node.childNodes.length - 1].__location.end)
          prefix = @getIndentPrefix(bounds, indentDepth)
          indentDepth += prefix.length
          @addIndent
            bounds: bounds
            depth: depth
            prefix: prefix

          for child in node.childNodes
            @mark indentDepth, child, depth+1, null

      else if isEmpty node.nodeName
        @htmlBlock node, depth, bounds

      else if node.nodeName is 'declaration'
        @htmlBlock node, depth, bounds
        @htmlSocketAndMark indentDepth, node.property, depth + 1, null
        @htmlSocketAndMark indentDepth, node.value, depth + 1, null
      ###

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

  HTMLParser.parens = (leading, trainling, node, context) ->
    return [leading, trainling]

  return parser.wrapParser HTMLParser