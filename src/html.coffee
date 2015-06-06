###
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
###

define ['droplet-helper', 'droplet-parser', 'parse5'], (helper, parser, parse5) ->

  exports = {}

  ATTRIBUTE_CLASSES = ['#attribute']

  COLORS = {
    'Default': 'cyan',
    '#comment': 'grey'
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
    'img': 'green',
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

  DEFAULT_INDENT_DEPTH = '  '

  EMPTY_ELEMENTS = ['area', 'base', 'basefont', 'br', 'col', 'embed', 'frame', 'hr', 'img', 'input', 'keygen', 'link', 'menuitem', 'meta', 'param', 'source', 'track', 'wbr']

  BLOCK_ELEMENTS = ['address', 'article', 'aside', 'audio', 'blockquote', 'canvas', 'dd', 'div', 'dl', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hgroup', 'hr', 'main', 'nav', 'noscript', 'ol', 'output', 'p', 'pre', 'section', 'table', 'tfoot', 'ul', 'video']

  INLINE_ELEMENTS = ['a', 'abbr', 'acronym', 'b', 'bdi', 'bdo', 'big', 'br', 'button', 'cite', 'dfn', 'em', 'i', 'img', 'input', 'kbd', 'label', 'map', 'object', 'q', 'samp', 'script', 'select', 'small', 'span', 'strong', 'sub', 'sup', 'textarea', 'tt', 'var']

  FLOW_ELEMENTS = (BLOCK_ELEMENTS.concat INLINE_ELEMENTS).sort()

  METADATA_CONTENT = ['base', 'link', 'meta', 'noscript', 'script', 'style', 'template', 'title']

  FLOW_CONTENT = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'bdi', 'bdo', 'blockquote', 'br', 'button', 'canvas', 'cite', 'code', 'data', 'datalist', 'del', 'dfn', 'div', 'dl', 'em', 'embed', 'fieldset', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'main', 'map', 'mark', 'math', 'meter', 'nav', 'noscript', 'object', 'ol', 'output', 'p', 'pre', 'progress', 'q', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'span', 'strong', 'sub', 'sup', 'svg', 'table', 'template', 'textarea', 'time', 'u', 'ul', 'var', 'video', 'wbr', '#text']

  SECTIONING_CONTENT = ['article', 'aside', 'nav', 'section']

  HEADING_CONTENT = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']

  PHRASING_CONTENT = ['a', 'abbr', 'area', 'audio', 'b', 'bdi', 'bdo', 'br', 'button', 'canvas', 'cite', 'code', 'data', 'datalist', 'del', 'dfn', 'em', 'embed', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'map', 'mark', 'math', 'meter', 'noscript', 'object', 'output', 'progress', 'q', 'ruby', 's', 'samp', 'script', 'select', 'small', 'span', 'strong', 'sub', 'sup', 'svg', 'template', 'textarea', 'time', 'u', 'var', 'video', 'wbr', '#text']

  EMBEDDED_CONTENT = ['audio', 'canvas', 'embed', 'iframe', 'img', 'math', 'object', 'svg', 'video']

  INTERACTIVE_CONTENT = ['a', 'audio', 'button', 'embed', 'iframe', 'img', 'input', 'keygen', 'label', 'object', 'select', 'textarea', 'video']

  PALPABLE_CONTENT = ['a', 'abbr', 'address', 'article', 'aside', 'audio', 'b', 'bdi', 'bdo', 'blockquote', 'button', 'canvas', 'cite', 'code', 'data', 'dfn', 'div', 'dl', 'em', 'embed', 'fieldset', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'main', 'map', 'mark', 'math', 'meter', 'nav', 'object', 'ol', 'output', 'p', 'pre', 'progress', 'q', 'ruby', 's', 'samp', 'section', 'select', 'small', 'span', 'strong', 'sub', 'sup', 'svg', 'table', 'textarea', 'time', 'u', 'ul', 'var', 'video', '#text']

  SCRIPT_SUPPORTING = ['script', 'template']

  htmlParser = new parse5.Parser null, {decodeHtmlEntities: false, locationInfo: true}

  exports.HTMLParser = class HTMLParser extends parser.Parser

    constructor: (@text, @opts = {}) ->
      super
      @lines = @text.split '\n'

    getAcceptsRule: (node) -> default: helper.NORMAL

    getPrecedence: (node) -> 1

    getClasses: (node) ->
      return [node.nodeName]

    getColor: (node) ->
      COLORS[node.nodeName] ? COLORS['Default']

    getBounds: (node) ->
      bounds = {
        start: @positions[node.__location.start]
        end: @positions[node.__location.end]
      }

      return bounds

    genBounds: (location) ->
      bounds = {
        start: @positions[location.start]
        end: @positions[location.end]
      }

      return bounds

    isBlockNode: (node) ->
      if node.nodeName is '#documentType'
        return false
      return node.nodeName not in EMPTY_ELEMENTS

    inline: (node) ->
      bounds = @getBounds node
      return bounds.start.line is bounds.end.line

    hasAttribute: (node, attribute) ->
      if node.attrs?
        for attr in node.attrs
          if attr.name is attribute
            return true
      return false

    setAttribs: (node, string) ->
      offset = node.__location.start
      node.attributes = []
      start = 1
      end = 0
      squotes = dquotes = false #Inside single or Double quotes respectively
      for ch, i in string
        if ch is '"' and not squotes
          dquotes = not dquotes
        else if ch is '\'' and not dquotes
          squotes = not squotes
        if not squotes and not dquotes and (ch is '>' or /\s/.test ch)
          end = i
          if start < end
            node.attributes.push {start: start+offset, end: end+offset}
          start = i+1
      node.attributes.shift()
      #console.log node.attributes

    cleanTree: (node) ->
      if not node
        return

      if node.childNodes?
        i = 0
        while i < node.childNodes.length
          @cleanTree node.childNodes[i]
          if not node.childNodes[i].__location
            node.childNodes = node.childNodes[0...i].concat(node.childNodes[i].childNodes || []).concat node.childNodes[i+1...]
          else
            i++

    fixBounds: (node) ->

      if not node
        return

      if node.childNodes?
        for child in node.childNodes
          @fixBounds child
        newList = []
        for child in node.childNodes
          if !child.remove
            newList.push child
        node.childNodes = newList

      if node.nodeName is '#document' or node.nodeName is '#document-fragment'
        node.type = 'document'
        return

      if node.nodeName is '#text'
        node.type = 'text'
        if node.value.trim().length is 0
          node.remove = true
        else
          @trimText node
        return

      if node.nodeName is '#comment'
        node.type = 'comment'
        return

      if not @isBlockNode node
        node.type = 'emptyTag'
        if node.__location?
          @setAttribs node, @text[node.__location.start...node.__location.end]
        return

      node.type = 'blockTag'

      #console.log node

      node.__indentLocation = {start: node.__startTagLocation.end}

      if node.childNodes?.length > 0
        node.__indentLocation.end = node.childNodes[node.childNodes.length - 1].__location.end
      else
        node.__indentLocation.end = node.__startTagLocation.end

      if not node.__endTagLocation
        node.__location.end = node.__indentLocation.end

      @setAttribs node, @text[node.__location.start...node.__indentLocation.start]

    makeIndentBounds: (node) ->
      ###
      loc = node.__indentLocation
      lines = @text[loc.start...loc.end].split('\n')
      for i in [lines.length-1..0] by -1
        if lines[i].trim().length is 0
          loc.end -= lines[i].length + 1
        else
          break

      if loc.start > loc.end
        loc.end = loc.start
      ###
      bounds = {
        start: @positions[node.__indentLocation.start]
        end: @positions[node.__indentLocation.end]
      }

      if node.__endTagLocation?
        lastLine = @positions[node.__endTagLocation.start].line - 1
        if lastLine > bounds.end.line or (lastLine is bounds.end.line and @lines[lastLine].length > bounds.end.column)
          bounds.end = {
            line: lastLine
            column: @lines[lastLine].length
          }

      return bounds

    trimText: (node) ->
      text = node.value
      location = node.__location
      text = text.split '\n'
      i = 0
      while text[i].trim().length is 0
        location.start += text[i].length + 1
        i++
      j = text.length - 1
      while text[j].trim().length is 0
        j--
      text = text[i..j].join '\n'
      location.end = location.start + text.length
      if i isnt 0
        leftTrimText = text.trimLeft()
        location.start += text.length - leftTrimText.length
        text = leftTrimText
      node.value = text
      ###
      rigthtTrimText = text.trimRight()
      leftTrimText = rigthtTrimText.trimLeft()
      node.value = leftTrimText
      location.start += rigthtTrimText.length - leftTrimText.length
      location.end = location.start + leftTrimText.length
      console.log node.value, JSON.stringify location
      ###

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

    htmlSocket: (node, depth, precedence, bounds, classes) ->
      #console.log "Adding Socket: ", JSON.stringify(bounds ? @getBounds node)
      @addSocket
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: precedence
        classes: classes ? @getClasses node
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

    handleText: (node, depth) ->
      text = node.value.split '\n'
      loc = {start: node.__location.start}
      for line in text
        loc.end = loc.start + line.length
        @htmlSocket node, depth, null, @genBounds loc
        loc.start = loc.end + 1

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
      window.positions = @positions
      window.text = @text

      try
        root = htmlParser.parse @text
        @cleanTree root
        @fixBounds root
        if root.childNodes.length is 0
          root = htmlParser.parseFragment @text
          @cleanTree root
          @fixBounds root
        window.root = root
        @mark 0, root, 0, null
      catch e
        console.log e.stack

    mark: (indentDepth, node, depth, bounds) ->

      switch node.type
        when 'document'
          for child in node.childNodes
            @mark indentDepth, child, depth + 1, null

        when 'emptyTag'
          @htmlBlock node, depth, bounds
          for attrib in node.attributes
            if attrib.end - attrib.start > 1
              @htmlSocket node, depth + 1, null, @genBounds(attrib), ATTRIBUTE_CLASSES

        when 'blockTag'
          @htmlBlock node, depth, bounds
          for attrib in node.attributes
            @htmlSocket node, depth + 1, null, @genBounds(attrib), ATTRIBUTE_CLASSES
          indentBounds = @makeIndentBounds node
          if indentBounds.start.line isnt indentBounds.end.line or indentBounds.start.column isnt indentBounds.end.column
            depth++
            #console.log "Adding Indent: ", JSON.stringify @makeIndentBounds node
            prefix = @getIndentPrefix(indentBounds, indentDepth, depth)
            indentDepth += prefix.length
            @addIndent
              bounds: indentBounds
              depth: depth
              prefix: prefix
              classes: @getClasses node
            for child in node.childNodes
              @mark indentDepth, child, depth + 1, null
          else
            if (node.nodeName isnt 'script' or not @hasAttribute node, 'src') and
                node.__indentLocation.end isnt node.__location.end
              @htmlSocket node, depth + 1, null, indentBounds

        when 'text'
          @htmlBlock node, depth, bounds
          @htmlSocket node, depth + 1, null
          #@handleText node, depth + 1

        when 'comment'
          @htmlBlock node, depth, bounds
          node.__location.start += 4
          node.__location.end -= 3
          @htmlSocket node, depth + 1, null
          #node.value = node.data
          #node.__location.start += 4
          #@handleText node, depth + 1

    isComment: (text) ->
      text.match(/<!--.*-->/)

  HTMLParser.parens = (leading, trainling, node, context) ->
    return [leading, trainling]

  HTMLParser.drop = (block, context, pred) ->

    blockType = block.classes[0]
    contextType = context.classes[0]
    predType = pred?.classes[0]

    check = (blockType, allowList, forbidList = []) ->
      if blockType in allowList and blockType not in forbidList
        return helper.ENCOURAGE
      return helper.FORBID

    ###
    # Going by https://www.cs.tut.fi/~jkorpela/html/nesting.html
    if blockType is '#documentType'
      if contextType is '__segment' and predType is '__segment'
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'html'
      if blockType in ['head', 'body']
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'head'
      if blockType in ['title', 'script', 'style', 'isindex', 'base', 'meta', 'link', 'object']
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'body'
      if blockType in ['ins', 'del'] or blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']
      if blockType is '#text' or blockType in INLINE_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['ol', 'ul']
      if blockType is 'li'
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'li'
      if blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['dir', 'menu']
      if blockType is 'li'
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'dl'
      if blockType in ['dt', 'dd']
        return helper.ENCOURAGE

    if contextType is 'dt'
      if blockType in INLINE_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'pre'
      if blockType in INLINE_ELEMENTS and blockType not in ['img', 'object', 'applet', 'big', 'small', 'sub', 'sup', 'font', 'basefont']
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['div', 'center', 'blockquote', 'iframe', 'noscript', 'noframes']
      if blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'form'
      if blockType isnt 'form' and blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'table'
      if blockType in ['caption', 'colgroup', 'col', 'thead', 'tbody', 'tr']
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'tbody'
      if blockType is 'tr'
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'tr'
      if blockType in ['td', 'th']
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['tr' ,'td']
      if blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'address'
      if blockType is 'p' or blockType in INLINE_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'fieldset'
      if blockType in ['#text', 'legend'] or blockType in FLOW_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'legend'
      if blockType in INLINE_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType in ['tt', 'i', 'b', 'u', 's', 'strike', 'big', 'small', 'font', 'em', 'strong', 'dfn', 'code', 'samp', 'kbd', 'var', 'cite', 'abbr', 'acronym', 'sub', 'sup', 'q', 'span', 'bdo']
      if blockType in INLINE_ELEMENTS
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is '#attribute' or contextType is '#text'
      return helper.FORBID

    if blockType is '#text'
      if contextType isnt '__segment'
        return helper.ENCOURAGE
      return helper.FORBID

    if contextType is 'body' or contextType in BLOCK_ELEMENTS
      return helper.ENCOURAGE
    ###

    switch contextType
      when 'html'
        return check blockType, ['head', 'body']
      when 'head'
        return check blockType, METADATA_CONTENT
      when 'title'
        return check blockType, ['#text']
      when 'style'
        return check blockType, ['#text']
      when 'body'
        return check blockType, FLOW_CONTENT
      when 'article'
        return check blockType, FLOW_CONTENT
      when 'section'
        return check blockType, FLOW_CONTENT
      when 'nav'
        return check blockType, FLOW_CONTENT, ['main']
      when 'aside'
        return check blockType, FLOW_CONTENT, ['main']
      when 'header'
        return check blockType, FLOW_CONTENT, ['header', 'footer', 'main']
      when 'footer'
        return check blockType, FLOW_CONTENT, ['header', 'footer', 'main']
      when 'address'
        return check blockType, FLOW_CONTENT, HEADING_CONTENT.concat(SECTIONING_CONTENT).concat(['header', 'footer', 'address'])
      when 'p'
        return check blockType, PHRASING_CONTENT
      when 'pre'
        return check blockType, PHRASING_CONTENT
      when 'blockquote'
        return check blockType, FLOW_CONTENT
      when 'ol'
        return check blockType, SCRIPT_SUPPORTING.concat 'li'
      when 'ul'
        return check blockType, SCRIPT_SUPPORTING.concat 'li'
      when 'li'
        return check blockType, FLOW_CONTENT
      when 'dl'
        return check blockType, ['dt', 'dd']
      when 'dt'
        return check blockType, FLOW_CONTENT, HEADING_CONTENT.concat(SECTIONING_CONTENT).concat(['header', 'footer'])
      when 'dd'
        return check blockType, FLOW_CONTENT
      when 'figure'
        return check blockType, FLOW_CONTENT.concat 'figcaption'
      when 'figcaption'
        return check blockType, FLOW_CONTENT
      when 'div'
        return check blockType, FLOW_CONTENT
      when 'main'
        return check blockType, FLOW_CONTENT
      when 'a'
        return check blockType, PHRASING_CONTENT, INTERACTIVE_CONTENT  #SHOULD BE TRANSPARENT, INTERACTIVE
      when 'em'
        return check blockType, PHRASING_CONTENT
      when 'strong'
        return check blockType, PHRASING_CONTENT
      when 'small'
        return check blockType, PHRASING_CONTENT
      when 's'
        return check blockType, PHRASING_CONTENT
      when 'cite'
        return check blockType, PHRASING_CONTENT
      when 'q'
        return check blockType, PHRASING_CONTENT
      when 'dfn'
        return check blockType, PHRASING_CONTENT, ['dfn']
      when 'abbr'
        return check blockType, PHRASING_CONTENT
      when 'data'
        return check blockType, PHRASING_CONTENT
      when 'time'
        return check blockType, PHRASING_CONTENT
      when 'code'
        return check blockType, PHRASING_CONTENT
      when 'var'
        return check blockType, PHRASING_CONTENT
      when 'samp'
        return check blockType, PHRASING_CONTENT
      when 'kbd'
        return check blockType, PHRASING_CONTENT
      when 'mark'
        return check blockType, PHRASING_CONTENT
      when 'ruby'
        return check blockType, PHRASING_CONTENT.concat ['rb', 'rt', 'rtc', 'rp']
      when 'rb'
        return check blockType, PHRASING_CONTENT
      when 'rt'
        return check blockType, PHRASING_CONTENT
      when 'rtc'
        return check blockType, PHRASING_CONTENT.concat 'rt'
      when 'rp'
        return check blockType, PHRASING_CONTENT
      when 'bdi'
        return check blockType, PHRASING_CONTENT
      when 'bdo'
        return check blockType, PHRASING_CONTENT
      when 'span'
        return check blockType, PHRASING_CONTENT
      when 'ins'
        return check blockType, PHRASING_CONTENT  #Transparent
      when 'del'
        return check blockType, PHRASING_CONTENT  #Transparent
      when 'iframe'
        return check blockType, ['#documentType', '#comment', 'html']
      when 'object'                #HANDLE ALL TYPES OF EMBEDDED CONTENT
        return check blockType, []
      when 'map'
        return check blockType, PHRASING_CONTENT  #Transparent
      when 'table'
        return check blockType, ['caption', 'colgroup', 'thead', 'tfoot', 'tbody', 'tr'].concat SCRIPT_SUPPORTING
      when 'caption'
        return check blockType, FLOW_CONTENT, ['table']
      when 'colgroup'
        return check blockType, ['span', 'col', 'template']
      when 'tbody'
        return check blockType, SCRIPT_SUPPORTING.concat 'tr'
      when 'thead'
        return check blockType, SCRIPT_SUPPORTING.concat 'tr'
      when 'tfoot'
        return check blockType, SCRIPT_SUPPORTING.concat 'tr'
      when 'tr'
        return check blockType, SCRIPT_SUPPORTING.concat ['td', 'th']
      when 'td'
        return check blockType, FLOW_CONTENT
      when 'th'
        return check blockType, FLOW_CONTENT, HEADING_CONTENT.concat(SECTIONING_CONTENT).concat(['header', 'footer'])
      when 'form'
        return check blockType, FLOW_CONTENT, ['form']
      when 'label'
        return check blockType, PHRASING_CONTENT, ['label']
      when 'button'
        return check blockType, PHRASING_CONTENT, INTERACTIVE_CONTENT
      when 'select'
        return check blockType, SCRIPT_SUPPORTING.concat ['option', 'optgroup']
      when 'datalist'
        return check blockType, PHRASING_CONTENT.concat 'option'
      when 'optgroup'
        return check blockType, SCRIPT_SUPPORTING.concat 'option'
      when 'option'
        return check blockType, '#text'
      when 'textarea'
        return check blockType, '#text'
      when 'output'
        return check blockType, PHRASING_CONTENT
      when 'progress'
        return check blockType, PHRASING_CONTENT, ['progress']
      when 'meter'
        return check blockType, PHRASING_CONTENT, ['meter']
      when 'fieldset'
        return check blockType, FLOW_CONTENT.concat 'legend'
      when 'legend'
        return check blockType, PHRASING_CONTENT
      when 'script'
        return check blockType, '#text'
      when 'noscript'
        return check blockType, FLOW_CONTENT.concat ['link', 'style', 'meta']
      when 'template'
        return check blockType, METADATA_CONTENT.concat(FLOW_CONTENT).concat(['ol', 'ul', 'dl', 'figure', 'ruby', 'object', 'video', 'audio', 'table', 'colgroup', 'thead', 'tbody', 'tfoot', 'tr', 'fieldset', 'select'])
      when 'canvas'
        return check blockType, FLOW_CONTENT
      when '__segment'
        if blockType is '#documentType'
          return check predType, [undefined, '__segment']
        return check blockType, ['html']

    if contextType in HEADING_CONTENT
      return check blockType, PHRASING_CONTENT

    if contextType in ['sub', 'sup', 'i', 'b', 'u']
      return check blockType, PHRASING_CONTENT

    return helper.FORBID

  return parser.wrapParser HTMLParser
