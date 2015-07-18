helper = require '../helper.coffee'
parser = require '../parser.coffee'

parse5 = require 'parse5'

ATTRIBUTE_CLASSES = ['#attribute']

TAGS = {
  #Metadata
  '#documentType': {category: 'metadata'}
  html: {category: 'metadata'}
  head: {category: 'metadata'}
  title: {category: 'metadata'}
  link: {category: 'metadata'}
  meta: {category: 'metadata'}
  style: {category: 'metadata'}
  script: {category: 'metadata'}
  base: {category: 'metadata'}

  #Grouping
  p: {category: 'grouping'}
  hr: {category: 'grouping'}
  div: {category: 'grouping'}
  ul: {category: 'grouping'}
  ol: {category: 'grouping'}
  li: {category: 'grouping'}
  dl: {category: 'grouping'}
  dt: {category: 'grouping'}
  dd: {category: 'grouping'}
  pre: {category: 'grouping'}
  blockquote: {category: 'grouping'}
  figure: {category: 'grouping'}
  figcaption: {category: 'grouping'}
  main: {category: 'grouping'}
  dd: {category: 'grouping'}

  #Content
  a: {category: 'content'}
  i: {category: 'content'}
  b: {category: 'content'}
  u: {category: 'content'}
  sub: {category: 'content'}
  sup: {category: 'content'}
  br: {category: 'content'}
  em: {category: 'content'}
  strong: {category: 'content'}
  small: {category: 'content'}
  s: {category: 'content'}
  cite: {category: 'content'}
  q: {category: 'content'}
  dfn: {category: 'content'}
  abbr: {category: 'content'}
  ruby: {category: 'content'}
  rt: {category: 'content'}
  rp: {category: 'content'}
  data: {category: 'content'}
  time: {category: 'content'}
  code: {category: 'content'}
  var: {category: 'content'}
  samp: {category: 'content'}
  kbd: {category: 'content'}
  mark: {category: 'content'}
  bdi: {category: 'content'}
  bdo: {category: 'content'}
  span: {category: 'content'}
  wbr: {category: 'content'}
  '#text': {category: 'content'}

  #Sections
  body: {category: 'sections'}
  article: {category: 'sections'}
  section: {category: 'sections'}
  nav: {category: 'sections'}
  aside: {category: 'sections'}
  h1: {category: 'sections'}
  h2: {category: 'sections'}
  h3: {category: 'sections'}
  h4: {category: 'sections'}
  h5: {category: 'sections'}
  h6: {category: 'sections'}
  hgroup: {category: 'sections'}
  header: {category: 'sections'}
  footer: {category: 'sections'}
  address: {category: 'sections'}

  #Table
  table: {category: 'table'}
  caption: {category: 'table'}
  colgroup: {category: 'table'}
  col: {category: 'table'}
  tbody: {category: 'table'}
  thead: {category: 'table'}
  tfoot: {category: 'table'}
  tr: {category: 'table'}
  td: {category: 'table'}
  th: {category: 'table'}

  #Form
  form: {category: 'form'}
  input: {category: 'form'}
  textarea: {category: 'form', content: 'optional'}
  label: {category: 'form'}
  button: {category: 'form'}
  select: {category: 'form'}
  option: {category: 'form'}
  optgroup: {category: 'form'}
  datalist: {category: 'form'}
  keygen: {category: 'form'}
  output: {category: 'form'}
  progress: {category: 'form', content: 'optional'}
  meter: {category: 'form', content: 'optional'}
  fieldset: {category: 'form'}
  legend: {category: 'form'}

  #Embedded
  img: {category: 'embedded'}
  iframe: {category: 'embedded', content: 'optional'}
  embed: {category: 'embedded'}
  object: {category: 'embedded'}
  param: {category: 'embedded'}
  video: {category: 'embedded'}
  audio: {category: 'embedded'}
  source: {category: 'embedded'}
  track: {category: 'embedded'}
  map: {category: 'embedded'}
  area: {category: 'embedded'}

  #Other known tags
  ins: {category: 'other'}
  del: {category: 'other'}
  details: {category: 'other'}
  summary: {category: 'other'}
  menu: {category: 'other'}
  menuitem: {category: 'other'}
  dialog: {category: 'other'}
  noscript: {category: 'other'}
  template: {category: 'other'}
  canvas: {category: 'other', content: 'optional'}
  svg: {category: 'other'}
  frameset: {category: 'other'}
}

CATEGORIES = {
  metadata: {color: 'lightblue'}
  grouping: {color: 'purple'}
  content: {color: 'lightgreen'}
  sections: {color: 'orange'}
  table: {color: 'indigo'}
  form: {color: 'deeporange'}
  embedded: {color: 'teal'}
  other: {color: 'pink'}
  Default: {color: 'yellow'}
}

DEFAULT_INDENT_DEPTH = '  '

EMPTY_ELEMENTS = ['area', 'base', 'basefont', 'bgsound', 'br', 'col', 'command', 'embed', 'frame', 'hr', 'img', 'input', 'keygen', 'link', 'menuitem', 'meta', 'param', 'source', 'track', 'wbr']

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
htmlSerializer = new parse5.Serializer null, {encodeHtmlEntities: false}

exports.HTMLParser = class HTMLParser extends parser.Parser

  constructor: (@text, @opts = {}) ->
    super

    @opts.tags = helper.extend({}, TAGS, @opts.tags)
    @opts.categories = helper.extend({}, CATEGORIES, @opts.categories)

    @lines = @text.split '\n'

  getPrecedence: (node) -> 1

  getClasses: (node) ->
    classes = [node.nodeName]
    if node.nodeName in ['thead', 'tbody', 'tr', 'table', 'div']
      classes = classes.concat 'add-button'
      if node.childNodes.length isnt 0
        classes = classes.concat 'subtract-button'
    return classes

  getColor: (node) ->
    if @opts.tags[node.nodeName]
      return @opts.categories[@opts.tags[node.nodeName].category].color
    return @opts.categories.Default.color

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
    string = string.toLowerCase()

    if node.nodeName isnt "#documentType"
      end = string.indexOf(node.nodeName) + node.nodeName.length
      offset += end
      string = string[end...]
      start = 0
      end = 0

      for att in node.attrs
        start = string.indexOf att.name.toLowerCase()
        end = start + att.name.length
        string = string[end...]
        if string.trimLeft()[0] is '='
          add = 0
          newStr = string.trimLeft()[1...].trimLeft()
          add = string.length - newStr.length
          string = string[add...]
          if string[0] in ['"', '\''] and string[0] is string[1]
            add += 2
            string = string[2...]
          end += add
        if att.value.length isnt 0
          diff = string.indexOf(att.value.toLowerCase())
          if string[diff-1] in ['"', '\''] and string[diff-1] is string[diff + att.value.length]
            diff++
          diff += att.value.length
          string = string[diff...]
          end += diff
        node.attributes.push {start: offset + start, end: offset + end}
        offset += end

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

    node.__indentLocation = {start: node.__location.startTag.end}

    if node.childNodes?.length > 0
      node.__indentLocation.end = node.childNodes[node.childNodes.length - 1].__location.end
    else
      node.__indentLocation.end = node.__location.startTag.end

    if not node.__location.endTag
      node.__location.end = node.__indentLocation.end

    @setAttribs node, @text[node.__location.start...node.__indentLocation.start]

  makeIndentBounds: (node) ->
    bounds = {
      start: @positions[node.__indentLocation.start]
      end: @positions[node.__indentLocation.end]
    }

    if node.__location.endTag?
      lastLine = @positions[node.__location.endTag.start].line - 1
      if lastLine > bounds.end.line or (lastLine is bounds.end.line and @lines[lastLine].length > bounds.end.column)
        bounds.end = {
          line: lastLine
          column: @lines[lastLine].length
        }
      else if node.__indentLocation.start is node.__indentLocation.end and node.__location.endTag
        bounds.end = @positions[node.__location.endTag.start]

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

  getSocketLevel: (node) -> helper.ANY_DROP

  htmlBlock: (node, depth, bounds) ->
    @addBlock
      bounds: bounds ? @getBounds node
      depth: depth
      precedence: @getPrecedence node
      color: @getColor node
      classes: @getClasses node
      socketLevel: @getSocketLevel node
      parseContext: node.nodeName

  htmlSocket: (node, depth, precedence, bounds, classes) ->
    @addSocket
      bounds: bounds ? @getBounds node
      depth: depth
      precedence: precedence
      classes: classes ? @getClasses node

  getIndentPrefix: (bounds, indentDepth, depth) ->
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

    parseContext = @opts.parseOptions?.context

    if parseContext and parseContext not in ['html', 'head', 'body']
      root = htmlParser.parseFragment @text
      @cleanTree root
      @fixBounds root
    else
      root = htmlParser.parse @text
      @cleanTree root
      @fixBounds root
      if root.childNodes.length is 0
        root = htmlParser.parseFragment @text
        @cleanTree root
        @fixBounds root
    @mark 0, root, 0, null

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
          unless TAGS[node.nodeName].content is 'optional' or
              (node.nodeName is 'script' and @hasAttribute node, 'src') or
              node.__indentLocation.end is node.__location.end
            @htmlSocket node, depth + 1, null, indentBounds

      when 'text'
        @htmlBlock node, depth, bounds
        @htmlSocket node, depth + 1, null

      when 'comment'
        @htmlBlock node, depth, bounds
        node.__location.start += 4
        node.__location.end -= 3
        @htmlSocket node, depth + 1, null

  isComment: (text) ->
    text.match(/<!--.*-->/)

HTMLParser.parens = (leading, trailing, node, context) ->
  return [leading, trailing]

HTMLParser.drop = (block, context, pred, next) ->

  blockType = block.classes[0]
  contextType = context.classes[0]
  predType = pred?.classes[0]
  nextType = next?.classes[0]

  check = (blockType, allowList, forbidList = []) ->
    if blockType in allowList and blockType not in forbidList
      return helper.ENCOURAGE
    return helper.FORBID

  switch contextType
    when 'html'
      if blockType is 'head'
        if predType is 'html' and (not next or nextType in ['body', 'frameset'])
          return helper.ENCOURAGE
      if blockType in ['body', 'frameset']
        if predType in ['html', 'head'] and not next
          return helper.ENCOURAGE
        return helper.FORBID
      return helper.FORBID
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
    when '__document__'
      if blockType is '#documentType'
        if pred.type is 'document' and (not next or nextType is 'html')
          return helper.ENCOURAGE
        return helper.FORBID
      if blockType is 'html'
        if (pred.type is 'document' or predType is '#documentType') and not next
          return helper.ENCOURAGE
        return helper.FORBID
      return helper.FORBID

  if contextType in HEADING_CONTENT
    return check blockType, PHRASING_CONTENT

  if contextType in ['sub', 'sup', 'i', 'b', 'u']
    return check blockType, PHRASING_CONTENT

  return helper.FORBID

module.exports = parser.wrapParser HTMLParser
