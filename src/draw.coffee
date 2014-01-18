###
# Copyright (c) 2014 Anthony Bau
# MIT License
# 
# Minimalistic HTML5 canvas wrapper. Mainly used as conveneince tools in ICE editor.
###

###
# Secret functions
###

# Signed area of the triangle formed by vectors [ab] and [ac]
_area = (a, b, c) -> (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)

# Test the intersection of two line segments
_intersects = (a, b, c, d) ->
  ((_area(a, b, c) > 0) != (_area(a, b, d) > 0)) and ((_area(c, d, a) > 0) != (_area(c, d, b) > 0))

###
# Public functions
###

exports = {}

exports.Point = class Point
  constructor: (@x, @y) ->

  clone: -> new Point @x, @y

  translate: (vector) ->
    @x += vector.x; @y += vector.y

  add: (x, y) -> @x += x; @y += y

  copy: (point) ->
    @x = point.x; @y = point.y

  from: (point) -> new Point @x - point.x, @y - point.y

  clear: -> @x = @y = 0

exports.Rectangle = class Rectangle
  constructor: (@x, @y, @width, @height) ->
  
  contains: (point) -> @x? and @y? and not ((point.x < @x) or (point.x > @x + @width) or (point.y < @y) or (point.y > @y + @height))

  copy: (rect) ->
    @x = rect.x; @y = rect.y
    @width = rect.width; @height = rect.height

  clear: -> @width = @height = 0; @x = @y = null

  bottom: -> @y + @height
  right: -> @x + @width

  fill: (ctx, style) ->
    ctx.fillStyle = style
    ctx.fillRect @x, @y, @width, @height

  unite: (rectangle) ->
    unless @x? and @y? then @copy rectangle
    else
      @width = Math.max(@right(), rectangle.right()) - (@x = Math.min @x, rectangle.x)
      @height = Math.max(@bottom(), rectangle.bottom()) - (@y = Math.min @y, rectangle.y)

  swallow: (point) ->
    unless @x? and @y? then @copy new Rectangle point.x, point.y, 0, 0
    else
      @width = Math.max(@right(), point.x) - (@x = Math.min @x, point.x)
      @height = Math.max(@bottom(), point.y) - (@y = Math.min @y, point.y)

  overlap: (rectangle) -> @x? and @y? and not ((rectangle.x) < @x or (rectangle.y < y) or (rectangle.right() > @right()) or (rectangle.bottom() > @bottom()))

  translate: (vector) ->
    @x += vector.x; @y += vector.y

exports.NoRectangle = class NoRectangle extends Rectangle
  constructor: -> super(null, null, 0, 0)

exports.Path = class Path
  constructor: ->
    @_points = []
    @_cachedTranslation = new Point 0, 0
    @_cacheFlag = false
    @_bounds = new NoRectangle()

    @style = {
      'strokeColor': '#000'
      'fillColor': null
    }
  
  _clearCache: ->
    if @_cacheFlag
      for point in @_points
        point.translate @_cachedTranslation
      @_bounds.translate @_cachedTranslation
      @_cachedTranslation.clear()
      @_cacheFlag = false
  
  recompute: ->
    @_bounds = new NoRectangle()
    for point in @_points
      @_bounds.swallow point
  
  push: (point) ->
    if @_points.length > 0
      @_points.push new draw.Point @_points[@_points.length - 1].x, point.y #EXPERIMENTAL
    @_points.push point
    @_bounds.swallow point

  unshift: (point) ->
    if @_points.length > 0
      @_points.unshift new draw.Point point.x, @_points[0].y #EXPERIMENTAL
    @_points.unshift point
    @_bounds.swallow point

  contains: (point) ->
    @_clearCache()

    # "Ray" to the left
    dest = new Point @_bounds.x - 10, point.y
    
    # Count intersections
    count = 0
    last = @_points[@_points.length - 1]
    for end in @_points
      if _intersects(last, end, point, dest) then count += 1
      last = end

    return count % 2 is 1

  bounds: -> @_clearCache(); @_bounds

  translate: (vector) ->
    @_cachedTranslation.translate vector
    @_cacheFlag = true

  draw: (ctx) ->
    @_clearCache()
    ctx.strokeStyle = @style.strokeColor
    if @style.fillColor? then ctx.fillStyle = @style.fillColor
    ctx.beginPath()
    ctx.moveTo @_points[0].x, @_points[0].y
    for point in @_points
      ctx.lineTo point.x, point.y # DEFAULT
    ctx.lineTo @_points[0].x, @_points[0].y

    # Fill and stroke
    if @style.fillColor? then ctx.fill()
    ctx.stroke()

_CTX = null #Hacky, hacky, hacky

exports.Text = class Text
  _FONT_SIZE: 15

  constructor: (@point, @value) ->
    _CTX.font = Text::_FONT_SIZE + 'px Courier New'
    @_bounds = new Rectangle @point.x, @point.y, _CTX.measureText(@value).width, Text::_FONT_SIZE
   
  bounds: -> @_bounds
  contains: (point) -> @_bounds.contains point
   
  translate: (vector) ->
    @point.translate vector
    @_bounds.translate vector

  setPosition: (point) -> @translate point.from @point
  
  draw: (ctx) ->
    ctx.textBaseline = 'top'
    ctx.font = Text::_FONT_SIZE + 'px Courier New'
    ctx.fillStyle = '#000'
    ctx.fillText @value, @point.x, @point.y

exports._setCTX = (ctx) -> _CTX = ctx

exports.Group = class Group
  constructor: ->
    @children = []
    @_cachedTranslation = new Point 0, 0
    @_cacheFlag = false
    @_bounds = new NoRectangle()

  _clearCache: ->
    if @_cacheFlag
      for child in @children
        child.translate @_cachedTranslation
      @_cachedTranslation.clear()
      @_cacheFlag = false

  empty: -> @children.length = 0; @_bounds.clear()

  recompute: ->
    @_bounds.clear()
    for child in @children
      @_bounds.unite child.bounds()

  translate: (vector) ->
    @_cachedTranslation.translate vector

  push: (child) ->
    @children.push child
    @_bounds.unite child.bounds()

  bounds: -> @_clearCache(); @_bounds

  setPosition: (point) ->
    @translate point.from new Point @bounds().x, @bounds.y

  contains: (point) ->
    @_clearCache
    for child in @children
      if child.contains point
        return true
    return false
  
  draw: (ctx) ->
    for child in @children
      child.draw ctx

exports.QuadTree = class QuadTree
  # To be used for dropArea and mouse fire events
  constructor: (@bounds) ->
    @children = null
    @contents = []

  _split: ->
    @children = [
      new QuadTree new Rectangle @bounds.x + @bounds.width / 2, @bounds.y, @bounds.height / 2, @bounds.width / 2 #I
      new QuadTree new Rectangle @bounds.x, @bounds.y, @bounds.height / 2, @bounds.width / 2 # II
      new QuadTree new Rectangle @bounds.x, @bounds.y + @bounds.width / 2, @bounds.height / 2, @bounds.width / 2 #III
      new QuadTree new Rectangle @bounds.x + @bounds.width / 2, @bounds.y + @bounds.width / 2, @bounds.height / 2, @bounds.width / 2 # IV
    ]
    for content in @contents
      for child in @children
        if content.rect.overlap child.bounds
          child.insert content
    @contents = []

  insert: (obj) ->
    if @children?
      for child in @children
        if obj.rect.overlap child.bounds
          child.insert obj
    else
      @contents.push obj

  find: (point) ->
    if @children?
      for child in @children
        if child.bounds.contains point
          return child.find point
    else
      for content in @contents
        if content.rect.contains point
          return content

window.draw = exports
###
# Performance strategy (might not be faster): convert paths to images in offscreen canvas once drawn, then translate those instead.
###
