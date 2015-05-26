###
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
###

define ['droplet-helper', 'droplet-parser', 'parse5', 'html-nodes', 'html-stack'], (helper, parser, parse5, model, html_stack) ->

  exports = {}

  COLORS = {
    'Default': 'cyan',
    'a': 'grey',
    'b': 'teal',
    'body': 'return',
    'br': 'command',
    'button': 'yellow',
    'center': 'red',
    'div': 'amber',
    'document': 'bluegrey',
    'font': 'value',
    'form': 'deeporange',
    'h1': 'teal',
    'h3': 'indigo',
    'head': 'cyan',
    'hr': 'lime',
    'html': 'amber',
    'iframe': 'green',
    'img': 'grey',
    'input': 'brown',
    'label': 'lightblue',
    'li': 'pink',
    'link': 'purple',
    'marquee': 'command',
    'meta': 'error',
    'option': 'control',
    'p': 'deeppurple',
    'script': 'orange',
    'select': 'indigo',
    'strong': 'yellow',
    'table': 'lightgreen',
    'td': 'lightblue',
    'title': 'green',
    'tr': 'bluegrey',
    'ul': 'blue'
  }

  MOSTLY_VALUE = ['any-drop']

  DEFAULT_INDENT_DEPTH = '  '

  SELF_CLOSING_LIST = ['area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr', 'basefont', 'bgsound', 'frame', 'isindex']

  stack = new html_stack.Stack()

  htmlParser = new parse5.SimpleApiParser {
    doctype: (name, publicId, systemId, location) ->
      #console.log(name, publicId, systemId, location)
      stack.push(new model.tagNode 'empty', 'doctype', location)
      #stack.debug()
    startTag: (tagName, attrs, selfClosing, location) ->
      #console.log( tagName, attrs, selfClosing, location)
      if selfClosing is false and tagName in SELF_CLOSING_LIST
        selfClosing = true

      if selfClosing
        stack.push(new model.tagNode 'empty', tagName, location)
      else
        node = new model.tagNode('start', tagName, location)
        stack.start(new model.blockNode node)
      #stack.debug()
    endTag: (tagName, location) ->
      if stack.top().name isnt tagName
        throw new Error "The open tag (" + stack.top().name + ") must close, but found - " + tagName + " at location " + JSON.stringify location
      #console.log(tagName, location)
      stack.end(location)
      #stack.debug()
    text: (text, location) ->
      #console.log(text.length, text, location)
      leftTrimtext = text.trimLeft()
      location.start += text.length - leftTrimtext.length
      rigthtTrimText = leftTrimtext.trimRight()
      location.end -= leftTrimtext.length - rigthtTrimText.length
      if rigthtTrimText.length isnt 0
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

    getAcceptsRule: (node) -> default: helper.NORMAL

    getPrecedence: (node) -> 1

    getClasses: (node) -> MOSTLY_VALUE

    getColor: (node) ->
      COLORS[node.name] ? COLORS['Default']

    getBounds: (node) ->
      bounds = {
        start: @positions[node.location.start]
        end: @positions[node.location.end]
      }

      return bounds

    inline: (node) ->
      bounds = @getBounds node
      return bounds.start.line is bounds.end.line

    getSocketLevel: (node) -> helper.ANY_DROP

    htmlBlock: (node, depth, bounds) ->
      #console.log "Adding Block: ", JSON.stringify(bounds ? @getBounds node)
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: @getPrecedence node
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    htmlSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes) ->
      #console.log "Adding Socket: ", JSON.stringify(bounds ? @getBounds node)
      @addSocket
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: precedence
        classes: classes ? []
        acccepts: @getAcceptsRule node

    getIndentPrefix: (bounds, indentDepth, depth) ->
      #console.log JSON.stringify(bounds), indentDepth, depth
      if bounds.end.line - bounds.start.line < 1
        return DEFAULT_INDENT_DEPTH
      else
        tmp = 1
        while @lines[bounds.start.line + tmp].trim().length is 0
          tmp++
        line = @lines[bounds.start.line + tmp]
        lineIndent = line[indentDepth...(line.length - line.trimLeft().length)]
        if lineIndent.length >= DEFAULT_INDENT_DEPTH.length
          return lineIndent
        else
          return DEFAULT_INDENT_DEPTH

    markRoot: ->
      @positions = []
      line = 0
      column = 0
      for val, i in @text
        @positions[i] = {'line': line, 'column': column}
        column++
        if val is '\n'
          line++
          column = 0
      @positions[@text.length] = {'line': line, 'column': column}

      try
        stack.clear()
        stack.set_html @text
        stack.start(new model.blockNode(new model.tagNode('start', 'document', {start: null})))
        htmlParser.parse @text
        console.log stack.length()
        if stack.length() isnt 1
          stack.debug()
          throw new Error "Stack size should be 1"
        root = stack.top()
        @mark 0, root, 0, null
      catch e
        console.log e
        stack.debug()
        console.log e.stack

    mark: (indentDepth, node, depth, bounds) ->
      if node.name is 'document'
        for child in node.consequent.children
          @mark indentDepth, child, depth + 1, null
        return

      switch node.type
        when 'blockTag'
          @htmlBlock node, depth, bounds
          @mark indentDepth, node.consequent, depth + 1, null
          html_stack.setAttribs(node, @text[node.location.start...node.consequent.location.start], node.location.start);
          for attrib in node.attributes
            @htmlSocketAndMark indentDepth, {location: attrib}, depth + 1, null

        when 'consequent'
          if not @inline node
            prefix = @getIndentPrefix(@getBounds(node), indentDepth, depth)
            indentDepth += prefix.length
            #console.log "Adding Indent: ", JSON.stringify(@getBounds node)
            @addIndent
              bounds: @getBounds node
              depth: depth
              prefix: prefix
          else
            if node.children.length isnt 0
              @htmlSocketAndMark indentDepth, node, depth, null

            #@htmlBlock node, depth, bounds

          for child in node.children
            #@htmlSocketAndMark indentDepth, child, depth + 1, null
            @mark indentDepth, child, depth + 1, null

        when 'emptyTag'
          @htmlBlock node, depth, bounds
          html_stack.setAttribs(node, @text[node.location.start...node.location.end], node.location.start);
          for attrib in node.attributes
            @htmlSocketAndMark indentDepth, {location: attrib}, depth + 1, null

        when 'text'
          @htmlBlock node, depth, bounds
          #console.log node.location
          @htmlSocketAndMark indentDepth, node, depth + 1, null

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

  HTMLParser.parens = (leading, trainling, node, context) ->
    return [leading, trainling]

  return parser.wrapParser HTMLParser