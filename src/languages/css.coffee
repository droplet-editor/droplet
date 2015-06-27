helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'

parserlib = require '../../vendor/node-parserlib.js'

COLORS = {
  'Default': 'cyan',
}

MOSTLY_VALUE = []

DEFAULT_INDENT_DEPTH = '  '

Stack = []
Stack.setValid = (state) -> Stack._valid = state
Stack.getValid = -> return (Stack._valid is true)
Stack.clear = -> Stack.length = 0
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
  top.iStartLine = top.endLine
  top.iStartCol = top.endCol
  top.endLine = element.line
  top.endCol = element.col
  top.iEndLine = top.endLine
  top.iEndCol = top.endCol - 1
  Stack.add top, top.nodeType

cssParser = new parserlib.css.Parser()
cssParser.addListener("startstylesheet", -> Stack.start {}, 'stylesheet')
cssParser.addListener("endstylesheet", -> null)
cssParser.addListener("charset", (event) -> Stack.add event, 'charset')
cssParser.addListener("namespace", (event) ->  Stack.add event, 'namespace')
cssParser.addListener("startfontface", (event) -> Stack.start event, 'fontface')
cssParser.addListener("endfontface", (event) -> Stack.end event)
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
cssParser.addListener("startmedia", (event) -> Stack.start event, 'media')
cssParser.addListener("endmedia", (event) -> Stack.end event)
cssParser.addListener("error", (event) -> Stack.setValid false)

ObjectReturning = ["parseSelector", "parsePropertyValue", "parseMediaQuery"]

# Though we are not parsnig style Attribute
# it is the same as parsing a set of declarations
# and we use it to parse a single declaration
ParseOrder = ["parse", "parseStyleAttribute"].concat ObjectReturning

exports.CSSParser = class CSSParser extends parser.Parser

  constructor: (@text, @opts = {}) ->
    super
    @lines = @text.split '\n'

  getAcceptsRule: (node) -> default: helper.NORMAL

  getPrecedence: (node) -> 1

  getClasses: (node) ->
    classes = [node.nodeType || "unknown"]
    if node.nodeType is 'rule'
      classes = classes.concat 'add-button', 'subtract-button'
    #console.log node, classes
    return classes

  getColor: (node) -> COLORS[node.nodeType] ? COLORS['Default']

  getBounds: (node) ->
    bounds = {
      start: {
        line: node.startLine - 1
        column: node.startCol - 1
      }
      end: {
        line: node.endLine - 1
        column: node.endCol - 1
      }
    }

    return bounds

  getSocketLevel: (node) -> helper.ANY_DROP

  cssBlock: (node, depth) ->
    if not node
      return
    #console.log "Adding Block: ", JSON.stringify @getBounds node
    @addBlock
      bounds: @getBounds node
      depth: depth
      precedence: @getPrecedence node
      color: @getColor node
      classes: @getClasses node
      socketLevel: @getSocketLevel node

  cssSocket: (node, depth, precedence) ->
    if not node
      return
    #console.log "Adding Socket: ", JSON.stringify @getBounds node
    @addSocket
      bounds: @getBounds node
      depth: depth
      precedence: precedence ? @getPrecedence node
      classes: @getClasses node
      acccepts: @getAcceptsRule node

  getIndentPrefix: (bounds, indentDepth) ->
    if bounds.end.line - bounds.start.line < 1
      return DEFAULT_INDENT_DEPTH
    else
      line = @lines[bounds.start.line + 1]
      return line[indentDepth...(line.length - line.trimLeft().length)]

  getIndentBounds: (node) ->
    bounds = {
      start: {
        line: node.iStartLine - 1
        column: node.iStartCol - 1
      }
      end: {
        line: node.iEndLine - 1
        column: node.iEndCol - 1
      }
    }

    #console.log bounds

    if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
      bounds.end.line--
      bounds.end.column = @lines[bounds.end.line].length

    return bounds

  markRoot: ->
    #console.log 'Parsing: ', @text
    ast = null
    for parse in ParseOrder
      try
        Stack.setValid true
        #console.log parse
        ast = cssParser[parse] @text
      catch e
        Stack.setValid false
      if Stack.getValid()
        break
    if Stack.getValid()
      root = ast ? Stack.top()
      window.root = root
      window.Stack = Stack
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
        @cssSocket node.property, depth + 1
        @mark indentDepth, node.value, depth + 1, null
      when 'fontface'
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
        @handleCompoundNode indentDepth, node, depth + 1
      when 'media'
        @cssBlock node, depth
        for media in node.media
          @cssSocket media, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1

    if node instanceof parserlib.css.PropertyValue
      @cssSocket node, depth
      if node.parts.length > 1
        @cssBlock node, depth + 1
        for part in node.parts
          @cssSocket part, depth + 2

  handleCompoundNode: (indentDepth, node, depth) ->
    indentBounds = @getIndentBounds node
    prefix = @getIndentPrefix indentBounds, indentDepth
    indentDepth += prefix.length
    #console.log "Adding Indent: ", JSON.stringify indentBounds
    @addIndent
      bounds: indentBounds
      depth: depth
      prefix: prefix
      classes: @getClasses node
    for child in node.children
      @mark indentDepth, child, depth + 1

  isComment: (text) ->
    text.match(/^\s*\/\*.\*\/*$/)

CSSParser.empty = '\'\''

CSSParser.parens = (leading, trainling, node, context) ->
  return [leading, trainling]

CSSParser.drop = (block, context, pred, next) ->
  #console.log block, context, pred
  blockType = block.classes[0]
  contextType = context.classes[0]
  predType = pred?.classes[0]
  nextType = next?.classes[0]

  if contextType is 'unknown'
    return helper.FORBID

  if blockType is 'charset'
    if context.type is 'segment' and pred.type is 'segment' and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'import'
    if context.type is 'segment' and (pred.type is 'segment' or predType in ['charset', 'import']) and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'namespace'
    if context.type is 'segment' and (pred.type is 'segment' or predType in ['charset', 'import', 'namespace']) and nextType not in ['charset', 'import']
      return helper.ENCOURAGE
    return helper.FORBID

  if context.type is 'segment'
    if blockType in ['rule', 'media', 'page', 'fontface', 'keyframes'] and nextType not in ['charset', 'import', 'namespace']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'media'
    if blockType is 'rule'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'page'
    if blockType in ['property', 'pagemargin']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'pagemargin'
    if blockType is 'property'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'fontface'
    if blockType is 'property'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'viewport'
    if blockType is 'property'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'rule'
    if blockType is 'property'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'keyframes'
    if blockType is 'keyframerule'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'keyframerule'
    if blockType is 'property'
      return helper.ENCOURAGE
    return helper.FORBID

  return helper.DISCOURAGE

CSSParser.handleButton = (text, command, classes) ->
  isComment = (str) ->
    text.match(/^\s*\/\*.\*\/*$/)

  if command is 'add-button'
    text = text.split('}')[0] + '  a: b;\n' + '}';
    console.log text

  return text

module.exports = parser.wrapParser CSSParser