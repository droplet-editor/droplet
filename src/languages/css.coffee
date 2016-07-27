helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'

parserlib = require '../../vendor/node-parserlib.js'

NODES = {
  # Rules and related
  rule: {color: 'orange'}
  selector: {color: 'green'}
  'selector-modifier': {color: 'lightblue'}
  property: {color: 'amber'}
  'property-value': {color: 'teal'}
  'property-part': {color: 'indigo'}

  # Single line commands
  charset: {color: 'yellow'}
  namespace: {color: 'yellow'}
  import: {color: 'yellow'}

  # @ Rules
  fontface: {color: 'purple'}
  viewport: {color: 'purple'}
  keyframes: {color: 'purple'}
  keyframerule: {color: 'blue'}
  page: {color: 'purple'}
  pagemargin: {color: 'blue'}
  mediaquery: {color: 'purple'}

  # Default fallback
  Default: {color: 'cyan'}
}

DEFAULT_INDENT_DEPTH = '  '

PARSE_CONTEXTS = {
  selector: 'parseSelector'
  'selector-modifier': 'parseSelectorSubPart'
  property: 'parseStyleAttribute'
  'property-value': 'parsePropertyValue'
  'property-part': 'parsePropertyValue'
}

UNITS = {
  length: ['em', 'px', 'mm', 'in', 'pt']
  angle: ['deg', 'rad', 'grad']
  time: ['ms', 's']
  frequency: ['hz', 'khz']
  resolution: ['dpi', 'dpcm']
  pseudoElements: ['before', 'after', 'first-letter', 'first-line', 'selection']
  pseudoClasses: ['active', 'hover', 'link', 'focus', 'visited']
}

PROPERTY_CONTAINING = ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule']

Stack = []
Stack.setValid = (state) -> Stack._valid = state
Stack.getValid = -> return (Stack._valid is true)
Stack.init = ->
  Stack.length = 0
  Stack.start {}, 'stylesheet'
Stack.top = -> return Stack[Stack.length - 1]
Stack.add = (element, type) ->
  element.nodeType = type
  Stack.top().children.push element
Stack.start = (element, type) ->
  element.nodeType = type
  element.children = []
  Stack.push element
Stack.end = (element) ->
  top = Stack.top()
  Stack.pop()
  top.loc.content = {}
  top.loc.content.startLine = top.loc.endLine
  top.loc.content.startCol = top.loc.endCol
  top.loc.endLine = element.loc.line
  top.loc.endCol = element.loc.col
  top.loc.content.endLine = top.loc.endLine
  top.loc.content.endCol = top.loc.endCol - 1
  Stack.add top, top.nodeType

cssParser = new parserlib.css.Parser()
cssParser.addListener("startstylesheet", -> null)
cssParser.addListener("endstylesheet", -> null)
cssParser.addListener("charset", (event) -> Stack.add event, 'charset')
cssParser.addListener("namespace", (event) ->  Stack.add event, 'namespace')
cssParser.addListener("startfontface", (event) -> Stack.start event, 'fontface')
cssParser.addListener("endfontface", (event) -> Stack.end event)
cssParser.addListener("startviewport", (event) -> Stack.start event, 'viewport')
cssParser.addListener("endviewport", (event) -> Stack.end event)
cssParser.addListener("startkeyframes", (event) -> Stack.start event, 'keyframes')
cssParser.addListener("startkeyframerule", (event) -> Stack.start event, 'keyframerule')
cssParser.addListener("endkeyframerule", (event) -> Stack.end event)
cssParser.addListener("endkeyframes", (event) -> Stack.end event)
cssParser.addListener("startpage", (event) -> Stack.start event, 'page')
cssParser.addListener("endpage", (event) -> Stack.end event)
cssParser.addListener("startpagemargin", (event) -> Stack.start event, 'pagemargin')
cssParser.addListener("endpagemargin", (event) -> Stack.end event)
cssParser.addListener("import", (event) -> Stack.add event, 'import')
cssParser.addListener("startrule", (event) -> Stack.start event, 'rule')
cssParser.addListener("endrule", (event) -> Stack.end event)
cssParser.addListener("property", (event) -> Stack.add event, 'property')
cssParser.addListener("startmedia", (event) -> Stack.start event, 'mediaquery')
cssParser.addListener("endmedia", (event) -> Stack.end event)
cssParser.addListener("error", (event) -> Stack.setValid false)

# Though we are not parsing style Attribute
# it is the same as parsing a set of declarations
# and we use it to parse a single declaration
ParseOrder = ["parse", "parseSelectorSubPart", "parseSelector", "parsePropertyValue", "parseMediaQuery", "parseStyleAttribute"]

exports.CSSParser = class CSSParser extends parser.Parser

  constructor: (@text, @opts = {}) ->
    super

    @opts.nodes = helper.extend({}, NODES, @opts.nodes)
    @opts.properties = @opts.properties || {}

    @lines = @text.split '\n'

  getAcceptsRule: (node) -> default: helper.NORMAL

  getPrecedence: (node) -> 1

  getClasses: (node, type) ->
    classes = [type || node.nodeType || "unknown"]
    if node.nodeType is 'property'
      bounds = @getBounds node
      if @lines[bounds.end.line][bounds.end.column - 1] isnt ';'
        classes = classes.concat 'no-semicolon'
    return classes

  getColor: (node) ->
    if node.nodeType is 'property'
      type = node.property.text
      if @opts.properties[type]?.color?
        return @opts.properties[type].color
    return @opts.nodes[node.nodeType]?.color ? @opts.nodes.Default.color

  getBounds: (node) ->
    bounds = {
      start: {
        line: node.loc.startLine - 1
        column: node.loc.startCol - 1
      }
      end: {
        line: node.loc.endLine - 1
        column: node.loc.endCol - 1
      }
    }

    return bounds

  getSocketLevel: (node) -> helper.ANY_DROP

  getPropertyChoices: (node) ->
    str = parserlib.css.Properties[node.property.text]
    if typeof str is 'string'
      types = str.split('|').map((x)->x.trim()).filter((x)->x.length isnt 0 and x[0] isnt '-')
      lst = types.filter((x)->x[0]!='<')
      if lst.length > 0
        lst.dropdownOnly = types.length is lst.length
        return lst
    return null

  cssBlock: (node, depth) ->
    if not node
      return
    @addBlock
      bounds: @getBounds node
      depth: depth
      precedence: @getPrecedence node
      color: @getColor node
      classes: @getClasses node
      socketLevel: @getSocketLevel node
      parseContext: node.nodeType

  cssSocket: (node, depth, precedence, bounds, dropdown, type) ->
    if not node
      return
    empty = ''
    switch node.nodeType
      when 'selector'
        empty = '__'
      when 'selector-modifier'
        empty = '__'
      when 'property-value'
        empty = '__'
      when 'property-part'
        empty = '__'
    @addSocket
      bounds: bounds ? @getBounds node
      depth: depth
      precedence: precedence ? @getPrecedence node
      classes: @getClasses node, type
      acccepts: @getAcceptsRule node
      dropdown: dropdown
      empty: empty
      parseContext: node.nodeType

  getIndentPrefix: (bounds, indentDepth) ->
    if bounds.end.line - bounds.start.line < 1
      return DEFAULT_INDENT_DEPTH
    else
      line = @lines[bounds.start.line + 1]
      return line[indentDepth...(line.length - line.trimLeft().length)]

  getIndentBounds: (node) ->
    bounds = {
      start: {
        line: node.loc.content.startLine - 1
        column: node.loc.content.startCol - 1
      }
      end: {
        line: node.loc.content.endLine - 1
        column: node.loc.content.endCol - 1
      }
    }

    if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
      bounds.end.line--
      bounds.end.column = @lines[bounds.end.line].length

    return bounds

  nameTree: (node) ->
    if not node
      return

    unless node.nodeType
      if node instanceof parserlib.css.Selector
        node.nodeType = 'selector'
      else if node instanceof parserlib.css.SelectorPart
        node.nodeType = 'selector-part'
      else if node instanceof parserlib.css.SelectorSubPart
        if node.type is 'elementName'
          node.nodeType = 'selector-elementname'
        else
          node.nodeType = 'selector-modifier'
      else if node instanceof parserlib.css.PropertyValue
        node.nodeType = 'property-value'
      else if node instanceof parserlib.css.PropertyValuePart
        node.nodeType = 'property-part'
      else if node instanceof parserlib.css.MediaQuery
        node.nodeType = 'media'

    switch node.nodeType
      when 'keyframerule'
        for key in node.keys
          key.nodeType = 'key'
      when 'rule'
        for sel in node.selectors
          @nameTree sel
      when 'selector'
        for part in node.parts
          @nameTree part
      when 'selector-part'
        for mod in node.modifiers
          @nameTree mod
        @nameTree node.elementName
      when 'property'
        @nameTree node.value
      when 'property-value'
        for part in node.parts
          @nameTree part
      when 'property-part'
        @nameTree node.args

    if node.children?
      for child in node.children
        @nameTree child

  markRoot: ->
    ast = null
    parseContext = PARSE_CONTEXTS[@opts.parseOptions?.context]
    # Required because 'selector' parse
    # preference is higher than 'property'
    # The other way round would also require some if-elses (probably more than this)
    if parseContext
      # Reparse property-value as property-value instead of selector
      if @opts.parseOptions.context in ['selector', 'selector-part'] and @opts.parseOptions.parentContext is 'property'
        parseContext = PARSE_CONTEXTS['property-value']
      Stack.init()
      Stack.setValid true
      ast = cssParser[parseContext] @text
    else
      foundSolution = false
      # Parse `a:b` inside a rule(or similar) as property instead of selector
      if @opts.parseOptions?.parentContext in PROPERTY_CONTAINING
        Stack.init()
        Stack.setValid true
        cssParser[PARSE_CONTEXTS.property] @text
        if Stack.top().children[0]?.type is 'property'
          foundSolution = true
      if not foundSolution
        for parse in ParseOrder
          try
            Stack.init()
            Stack.setValid true
            ast = cssParser[parse] @text
          catch e
            Stack.setValid false
          if Stack.getValid()
            break
    if Stack.getValid()
      root = ast ? Stack.top()
      @nameTree root
      @mark 0, root, 0
    else
      throw "Invalid Data"

  mark: (indentDepth, node, depth) ->
    switch node.nodeType
      when 'stylesheet'
        for child in node.children
          @mark indentDepth, child, depth + 1, null
      when 'charset'
        @cssBlock node, depth
        @cssSocket node.charset, depth + 1
      when 'namespace'
        @cssBlock node, depth
        @cssSocket node.prefix, depth + 1
        @cssSocket node.uri, depth + 1
      when 'import'
        @cssBlock node, depth
        @cssSocket node.uri, depth + 1
        for media in node.media
          @cssSocket media, depth + 1
      when 'property'
        @cssBlock node, depth
        #@cssSocket node.property, depth + 1
        dropdown = @getPropertyChoices node
        if dropdown
          @cssSocket node.value, depth + 1, null, null, dropdown
        else
          @mark indentDepth, node.value, depth + 1, null
      when 'fontface'
        @cssBlock node, depth
        @handleCompoundNode indentDepth, node, depth + 1
      when 'viewport'
        @cssBlock node, depth
        @handleCompoundNode indentDepth, node, depth + 1
      when 'keyframes'
        @cssBlock node, depth
        @cssSocket node.name, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'keyframerule'
        @cssBlock node, depth
        for key in node.keys
          @cssSocket key, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'page'
        @cssBlock node, depth
        @cssSocket node.id, depth + 1
        @cssSocket node.pseudo, + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'pagemargin'
        @cssBlock node, depth
        @cssSocket node.margin, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'rule'
        @cssBlock node, depth
        for selector in node.selectors
          @cssSocket selector, depth + 1
          @mark indentDepth, selector, depth + 2
        @handleCompoundNode indentDepth, node, depth + 1
      when 'mediaquery'
        @cssBlock node, depth
        for media in node.media
          @cssSocket media, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'selector'
        @cssBlock node, depth
        depth++
        for part in node.parts
          if part.modifiers?.length > 0
            for mod in part.modifiers
              @cssSocket mod, depth + 1
              @mark indentDepth, mod, depth + 2
          if part.elementName
            @cssSocket part.elementName, depth + 1
      when 'selector-modifier'
        if node.type in ['class', 'id']
          @cssBlock node, depth + 3
          node.loc.startCol++
          @cssSocket node, depth + 4, null, null, null, node.type
        else if node.type is 'pseudo'
          @cssBlock node, depth + 3
          node.loc.startCol++
          if node.text[1] is ':'
            node.loc.startCol++
            @cssSocket node, depth + 4, null, null, UNITS['pseudoElements'], node.type
          else
            @cssSocket node, depth + 4, null, null, UNITS['pseudoClasses'], node.type
        else if node.type is 'attribute'
          @cssBlock node, depth + 3
          @cssSocket node.attrib, depth + 4, null, null, null, node.type
          @cssSocket node.val, depth + 4, null, null, null, node.type
        else if node.type is 'not'
          @cssBlock node, depth + 3
          arg = node.args[0]
          arg = arg.elementName ? arg.modifiers[0]
          @cssSocket arg, depth + 4, null, null, null, node.type
          @mark indentDepth, arg, depth + 4

      when 'property-value'
        if node.parts.length > 1
          @cssSocket node, depth
          @cssBlock node, depth + 1
        for part in node.parts
          if UNITS[part.type]   #dimension
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            bounds = @getBounds part
            @cssSocket part, depth + 4, null, {
              start: bounds.start
              end: {line: bounds.end.line, column: bounds.end.column - part.units.length}
            }
            @cssSocket part, depth + 4, null, {
              start: {line: bounds.end.line, column: bounds.end.column - part.units.length}
              end: bounds.end
            }, UNITS[part.type]
          else if part.args
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            @mark indentDepth, part.args, depth + 4
          else if part.type is 'percentage'
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            bounds = @getBounds part
            @cssSocket part, depth + 4, null, {
              start: bounds.start
              end: {line: bounds.end.line, column: bounds.end.column - 1}
            }
          else if part.type in ['string', 'integer', 'number', 'uri', 'color', 'identifier']
            @cssSocket part, depth + 2
          else
            null

  handleCompoundNode: (indentDepth, node, depth) ->
    indentBounds = @getIndentBounds node
    prefix = @getIndentPrefix indentBounds, indentDepth
    indentDepth += prefix.length
    @addIndent
      bounds: indentBounds
      depth: depth
      prefix: prefix
      classes: @getClasses node
    for child in node.children
      @mark indentDepth, child, depth + 1

  isComment: (text) ->
    text.match(/^\s*\/\*.*\*\/*$/)

CSSParser.empty = ''

CSSParser.parens = (leading, trailing, node, context) ->
  if context?.type is 'indent' and context?.classes[0] in ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule'] and node.classes[0] in ['selector', 'property']
    trailing ';'
  return

CSSParser.drop = (block, context, pred, next) ->
  blockType = block.classes[0]
  contextType = context.classes[0]
  predType = pred?.classes[0]
  nextType = next?.classes[0]

  if contextType is 'unknown'
    return helper.FORBID

  if blockType is 'charset'
    if context.type is 'document' and pred.type is 'document' and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'import'
    if context.type is 'document' and (pred.type is 'document' or predType in ['charset', 'import']) and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'namespace'
    if context.type is 'document' and (pred.type is 'document' or predType in ['charset', 'import', 'namespace']) and nextType not in ['charset', 'import']
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'property'
    if contextType in ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule']
      if 'no-semicolon' in pred.classes
        return helper.FORBID
      if 'no-semicolon' not in block.classes
        return helper.ENCOURAGE
      if not next
        return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'selector-modifier'
    if contextType in ['selector', 'selector-part', 'selector-elementname', 'selector-modifier']
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'selector'
    if contextType is 'selector'
      return helper.ENCOURAGE
    return helper.FORBID

  if context.type is 'document'
    if blockType in ['rule', 'mediaquery', 'page', 'fontface', 'keyframes', 'viewport'] and nextType not in ['charset', 'import', 'namespace']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'mediaquery'
    if blockType in ['rule', 'page', 'viewport', 'fontface']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'page'
    if blockType is 'pagemargin'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'keyframes'
    if blockType is 'keyframerule'
      return helper.ENCOURAGE
    return helper.FORBID

  return helper.DISCOURAGE

CSSParser.handleButton = (text, command, classes) ->
  isComment = (str) ->
    text.match(/^\s*\/\*.\*\/*$/)

  if command is 'add-button'
    text = text.split('}')[0] + '  a: b;\n' + '}';

  return text

module.exports = parser.wrapParser CSSParser