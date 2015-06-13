# Droplet helper functions.
#
# Copyright (c) 2015 Anthony Bau.
# MIT License.
sax = require 'sax'

exports.ANY_DROP = 0
exports.BLOCK_ONLY = 1
exports.MOSTLY_BLOCK = 2
exports.MOSTLY_VALUE = 3
exports.VALUE_ONLY = 4

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
    console.log 'pieces:',
      "'#{lines[start.line][start.column..]}'",
      "'#{lines[start.line + 1...end.line].join('\n')}'",
      "'#{lines[end.line][...end.column]}'"
    return lines[start.line][start.column..] +
    lines[start.line + 1...end.line].join('\n') +
    lines[end.line][...end.column]
  else
    console.log 'clipping', lines[start.line], 'from', start.column + 1, 'to', end.column
    return lines[start.line][start.column...end.column]

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
