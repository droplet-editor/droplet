# Droplet helper functions.
#
# Copyright (c) 2015 Anthony Bau (dab1998@gmail.com).
# MIT License.
sax = require 'sax'

exports.ANY_DROP = 0
exports.BLOCK_ONLY = 1
exports.MOSTLY_BLOCK = 2
exports.MOSTLY_VALUE = 3
exports.VALUE_ONLY = 4
exports.SVG_STANDARD = 'http://www.w3.org/2000/svg'

exports.ENCOURAGE = 1
exports.DISCOURAGE = 0
exports.FORBID = -1

exports.DROPDOWN_ARROW_WIDTH = 15
exports.DROPDOWN_ARROW_PADDING = 3

if window?
  window.String.prototype.trimLeft = ->
    @replace /^\s+/, ''

  window.String.prototype.trimRight = ->
    @replace /\s+$/, ''

# Like $.extend
exports.extend = (target) ->
  sources = [].slice.call(arguments, 1)
  sources.forEach (source) ->
    if source
      Object.getOwnPropertyNames(source).forEach (prop) ->
        Object.defineProperty(target, prop,
            Object.getOwnPropertyDescriptor(source, prop))
  return target

exports.xmlPrettyPrint = (str) ->
  result = ''
  xmlParser = sax.parser true

  xmlParser.ontext = (text) -> result += exports.escapeXMLText text
  xmlParser.onopentag = (node) ->
    result += '<' + node.name
    for attr, val of node.attributes
      result += '\n  ' + attr + '=' + JSON.stringify(val)
    result += '>'
  xmlParser.onclosetag = (name) -> result += '</' + name + '>'

  xmlParser.write(str).close()

  return result

fontMetricsCache = {}
exports.fontMetrics = fontMetrics = (fontFamily, fontHeight) ->
  fontStyle = "#{fontHeight}px #{fontFamily}"
  result = fontMetricsCache[fontStyle]

  textTopAndBottom = (testText) ->
    ctx.fillStyle = 'black'
    ctx.fillRect(0, 0, width, height)
    ctx.textBaseline = 'top'
    ctx.fillStyle = 'white'
    ctx.fillText(testText, 0, 0)
    right = Math.ceil(ctx.measureText(testText).width)
    pixels = ctx.getImageData(0, 0, width, height).data
    first = -1
    last = height
    for row in [0...height]
      for col in [1...right]
        index = (row * width + col) * 4
        if pixels[index] != 0
          if first < 0
            first = row
          break
      if first >= 0 and col >= right
        last = row
        break
    return {top: first, bottom: last}

  if not result
    canvas = document.createElement 'canvas'
    ctx = canvas.getContext '2d'
    ctx.font = fontStyle
    metrics = ctx.measureText 'Hg'
    if canvas.height < fontHeight * 2 or
       canvas.width < metrics.width
      canvas.width = Math.ceil(metrics.width)
      canvas.height = fontHeight * 2
      ctx = canvas.getContext '2d'
      ctx.font = fontStyle
    width = canvas.width
    height = canvas.height
    capital = textTopAndBottom 'H'
    ex = textTopAndBottom 'x'
    lf = textTopAndBottom 'lf'
    gp = textTopAndBottom 'g'
    baseline = capital.bottom
    result =
      ascent: lf.top
      capital: capital.top
      ex: ex.top
      baseline: capital.bottom
      descent: gp.bottom
    result.prettytop = Math.max(0, Math.min(result.ascent,
      result.ex - (result.descent - result.baseline)))
    fontMetricsCache[fontStyle] = result
  return result

exports.clipLines = (lines, start, end) ->
  if start.line isnt end.line
    #console.log 'pieces:',
    #  "'#{lines[start.line][start.column..]}'",
    #  "'#{lines[start.line + 1...end.line].join('\n')}'",
    #  "'#{lines[end.line][...end.column]}'"
    return lines[start.line][start.column..] + '\n' +
    lines[start.line + 1...end.line].map((x) -> x + '\n').join('') +
    lines[end.line][...end.column]
  else
    #console.log 'clipping', lines[start.line], 'from', start.column + 1, 'to', end.column
    return lines[start.line][start.column...end.column]

exports.subtractBounds = (a, b) ->
  return {
    start: {
      line: a.start.line - b.line
      column: a.start.column - b.column
    }
    end: {
      line: a.start.line - b.line
      column: a.start.column - b.column
    }
  }

exports.getFontHeight = (family, size) ->
  metrics = fontMetrics family, size
  return metrics.descent - metrics.prettytop

exports.escapeXMLText = (str) ->
  str.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&apos;')

exports.serializeShallowDict = (dict) ->
  props = []
  for key, val of dict
    props.push key + ':' + val
  return props.join ';'

exports.deserializeShallowDict = (str) ->
  unless str? then return undefined
  dict = {}; props = str.split ';'
  for prop in props
    [key, val] = prop.split ':'
    dict[key] = val
  return dict

exports.connect = (a, b) ->
  if a?
    a.next = b
  if b?
    b.prev = a
  return b

exports.string = (arr) ->
  last = arr[0]
  for el, i in arr when i > 0
    last = exports.connect last, el
  return last

exports.deepCopy = deepCopy = (a) ->
  if a instanceof Array
    return a.map (el) -> deepCopy el
  else if a instanceof Object
    newObject = {}

    for key, val of a
      if val instanceof Function
        newObject[key] = val
      else
        newObject[key] = deepCopy val

    return newObject

  else
    return a

exports.deepEquals = deepEquals = (a, b) ->
  if a instanceof Object and b instanceof Object
    for own key, val of a
      unless deepEquals b[key], val
        return false

    for own key, val of b when not key of a
      unless deepEquals a[key], val
        return false

    return true
  else
    return a is b

_guid = 0
exports.generateGUID = -> (_guid++).toString(16)

# General quoted-string-fixing functionality, for use in various
# language modes' stringFixer functions.

# To fix quoting errors, we first do a lenient C-unescape, then
# we do a string C-escaping, to add backlsashes where needed, but
# not where we already have good ones.
exports.fixQuotedString = (lines) ->
  line = lines[0]
  quotechar = if /^"|"$/.test(line) then '"' else "'"
  if line.charAt(0) is quotechar
    line = line.substr(1)
  if line.charAt(line.length - 1) is quotechar
    line = line.substr(0, line.length - 1)
  return lines[0] = quoteAndCEscape looseCUnescape(line), quotechar

exports.looseCUnescape = looseCUnescape = (str) ->
  codes =
    '\\b': '\b'
    '\\t': '\t'
    '\\n': '\n'
    '\\f': '\f'
    '\\"': '"'
    "\\'": "'"
    "\\\\": "\\"
    "\\0": "\0"
  str.replace /\\[btnf'"\\0]|\\x[0-9a-fA-F]{2}|\\u[0-9a-fA-F]{4}/g, (m) ->
    if m.length is 2 then return codes[m]
    return String.fromCharCode(parseInt(m.substr(1), 16))

exports.quoteAndCEscape = quoteAndCEscape = (str, quotechar) ->
  result = JSON.stringify(str)
  if quotechar is "'"
    return quotechar +
      result.substr(1, result.length - 2).
             replace(/((?:^|[^\\])(?:\\\\)*)\\"/g, '$1"').
      replace(/'/g, "\\'") + quotechar
  return result

# A naive dictionary mapping arbitrary objects to arbitrary objects, for use in
# ace-to-droplet session matching.
#
# May replace with something more sophisticated if performance becomes an issue,
# but we don't envision any use cases where sessions flip really fast, so this is unexpected.
exports.PairDict = class PairDict
  constructor: (@pairs) ->

  get: (index) ->
    for el, i in @pairs
      if el[0] is index
        return el[1]

  contains: (index) ->
    @pairs.some (x) -> x[0] is index

  set: (index, value) ->
    for el, i in @pairs
      if el[0] is index
        el[1] = index
        return true
    @pairs.push [index, value]
    return false

  remove: (index) ->
    @pairs = @pairs.filter (pair) -> pair[0] isnt index

  forEach: (fn) ->
    for pair, i in @pairs
      fn pair[1], pair[0]
    return

dfs = (graph, a, b, visited = {}) ->
  if visited[a]
    return false
  visited[a] = true

  if a is b
    return true

  for out_edge of graph.vertices[a]
    if dfs(graph, out_edge, b, visited)
      return true
  return false

exports.dfs = dfs
