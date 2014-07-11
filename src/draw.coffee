# Copyright (c) 2014 Anthony Bau
# MIT License
# 
# Minimalistic HTML5 canvas wrapper. Mainly used as conveneince tools in ICE editor.

## Private (convenience) functions

define ->

  # ## _area ##
  # Signed area of the triangle formed by vectors [ab] and [ac]
  _area = (a, b, c) -> (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)

  # ## _intersects ##
  # Test the intersection of two line segments
  _intersects = (a, b, c, d) ->
    ((_area(a, b, c) > 0) != (_area(a, b, d) > 0)) and ((_area(c, d, a) > 0) != (_area(c, d, b) > 0))

  ## Public functions

  exports = {}

  # ## Point ##
  # A point knows its x and y coordinate, and can do some vector operations.
  exports.Point = class Point
    constructor: (@x, @y) ->

    clone: -> new Point @x, @y

    magnitude: -> Math.sqrt @x * @x + @y * @y

    translate: (vector) ->
      @x += vector.x; @y += vector.y

    add: (x, y) -> @x += x; @y += y

    copy: (point) ->
      @x = point.x; @y = point.y

    from: (point) -> new Point @x - point.x, @y - point.y

    clear: -> @x = @y = 0

  # ## Size ##
  # A Size knows its width and height.
  exports.Size = class Size
    constructor: (@width, @height) ->

  # ## Rectangle ##
  # A Rectangle knows its upper-left corner, width, and height,
  # and can do rectangular overlap, polygonal intersection,
  # and rectangle or point union (point union is called "swallow").
  exports.Rectangle = class Rectangle
    constructor: (@x, @y, @width, @height) ->
    
    contains: (point) -> @x? and @y? and not ((point.x < @x) or (point.x > @x + @width) or (point.y < @y) or (point.y > @y + @height))
    
    identical: (other) ->
      @x is other.x and
      @y is other.y and
      @width is other.width and
      @height is other.height

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

    overlap: (rectangle) -> @x? and @y? and not ((rectangle.right()) < @x or (rectangle.bottom() < @y) or (rectangle.x > @right()) or (rectangle.y > @bottom()))

    translate: (vector) ->
      @x += vector.x; @y += vector.y

    stroke: (ctx, style) ->
      ctx.strokeStyle = style
      ctx.strokeRect @x, @y, @width, @height

    fill: (ctx, style) ->
      ctx.fillStyle = style
      ctx.fillRect @x, @y, @width, @height

    upperLeftCorner: -> new Point @x, @y

    toPath: ->
      path = new Path()
      path.push new Point(point[0], point[1]) for point in [
        [@x, @y]
        [@x, @bottom()]
        [@right(), @bottom()]
        [@right(), @y]
      ]
      return path

  # ## NoRectangle ##
  # NoRectangle is an alternate constructor for Rectangle which starts
  # the rectangle as nothing (without even a location). It can gain location and size
  # via unite() and swallow().
  exports.NoRectangle = class NoRectangle extends Rectangle
    constructor: -> super(null, null, 0, 0)

  # ## Path ##
  # This is called Path, but is forced to be closed so is actually a polygon.
  # It can do fast translation and rectangular intersection.
  exports.Path = class Path
    constructor: ->
      @_points = []
      @_cachedTranslation = new Point 0, 0
      @_cacheFlag = false
      @_bounds = new NoRectangle()

      @style = {
        'strokeColor': '#000'
        'lineWidth': 1
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
      @_points.push point
      @_bounds.swallow point

    unshift: (point) ->
      @_points.unshift point
      @_bounds.swallow point
    
    # ### Point containment ###
    # Accomplished with ray-casting
    contains: (point) ->
      @_clearCache()

      if @_points.length is 0 then return false

      # "Ray" to the left
      dest = new Point @_bounds.x - 10, point.y
      
      # Count intersections
      count = 0
      last = @_points[@_points.length - 1]
      for end in @_points
        if _intersects(last, end, point, dest) then count += 1
        last = end

      return count % 2 is 1
    
    # ### Rectangular intersection ###
    # Succeeds if any edges intersect or either shape is
    # entirely within the other.
    intersects: (rectangle) ->
      @_clearCache()

      if @_points.length is 0 then return false
      
      if not rectangle.overlap @_bounds then return false
      else
        # Try each pair of edges for intersections
        last = @_points[@_points.length - 1]
        rectSides = [
          new Point rectangle.x, rectangle.y
          new Point rectangle.right(), rectangle.y
          new Point rectangle.right(), rectangle.bottom()
          new Point rectangle.x, rectangle.bottom()
        ]
        for end in @_points
          lastSide = rectSides[rectSides.length - 1]
          for side in rectSides
            if _intersects(last, end, lastSide, side) then return true
            lastSide = side
          last = end

        # Intersections failed; see if we contain the rectangle.
        # Note that if we contain the rectangle we must contain all of its vertices,
        # so it suffices to test one vertex.
        if @contains rectSides[0] then return true

        # We don't contain the rectangle; see if it contains us.
        if rectangle.contains @_points[0] then return true
        
        # No luck
        return false

    bounds: -> @_clearCache(); @_bounds

    translate: (vector) ->
      @_cachedTranslation.translate vector
      @_cacheFlag = true

    draw: (ctx) ->
      @_clearCache()

      if @_points.length is 0 then return

      ctx.strokeStyle = @style.strokeColor
      ctx.lineWidth = @style.lineWidth

      if @style.fillColor? then ctx.fillStyle = @style.fillColor

      ctx.beginPath()
      ctx.moveTo @_points[0].x, @_points[0].y
      for point in @_points
        ctx.lineTo point.x, point.y # DEFAULT
      ctx.lineTo @_points[0].x, @_points[0].y
      
      # Wrap around again so that the origin
      # has a normal corner
      if @_points.length > 1
        ctx.lineTo @_points[1].x, @_points[1].y

      # Fill and stroke
      if @style.fillColor? then ctx.fill()

      ctx.stroke()

    clone: ->
      clone = new Path()
      clone.push el for el in @_points
      return clone

    drawShadow: (ctx, offsetX, offsetY, blur) ->
      @_clearCache()

      ctx.fillStyle = @style.fillColor

      if @_points.length is 0 then return
      
      oldValues = {
        shadowColor: ctx.shadowColor
        shadowBlur: ctx.shadowBlur
        shadowOffsetY: ctx.shadowOffsetY
        shadowOffsetX: ctx.shadowOffsetX
        globalAlpha: ctx.globalAlpha
      }
      
      ctx.globalAlpha = 0.5
      ctx.shadowColor = '#000'; ctx.shadowBlur = blur
      ctx.shadowOffsetX = offsetX; ctx.shadowOffsetY = offsetY

      ctx.beginPath()
      
      ctx.moveTo @_points[0].x, @_points[0].y
      for point in @_points
        ctx.lineTo point.x, point.y # DEFAULT
      ctx.lineTo @_points[0].x, @_points[0].y

      ctx.fill()

      for own key, value of oldValues
        ctx[key] = value

  _CTX = null #Hacky, hacky, hacky
  _FONT_SIZE = 15

  # ## Text ##
  # A Text element. Mainly this exists for computing bounding boxes, which is
  # accomplished via ctx.measureText().
  exports.Text = class Text
    constructor: (@point, @value) ->
      @wantedFont = _FONT_SIZE + 'px Courier New'

      unless _CTX.font is @wantedFont
        _CTX.font = _FONT_SIZE + 'px Courier New'

      @_bounds = new Rectangle @point.x, @point.y, _CTX.measureText(@value).width, _FONT_SIZE

    bounds: -> @_bounds
    contains: (point) -> @_bounds.contains point
     
    translate: (vector) ->
      @point.translate vector
      @_bounds.translate vector

    setPosition: (point) -> @translate point.from @point
    
    draw: (ctx) ->
      ctx.textBaseline = 'top'
      ctx.font = _FONT_SIZE + 'px Courier New'
      ctx.fillStyle = '#000'
      ctx.fillText @value, @point.x, @point.y

  exports._setCTX = (ctx) -> _CTX = ctx
  exports._setGlobalFontSize = (size) ->
    _FONT_SIZE = size

  exports._getGlobalFontSize = -> _FONT_SIZE

  return exports

