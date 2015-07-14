# Copyright (c) 2014 Anthony Bau (dab1998@gmail.com)
# MIT License
#
# Minimalistic HTML5 canvas wrapper. Mainly used as conveneince tools in Droplet.

## Private (convenience) functions
SVG_STANDARD = 'http://www.w3.org/2000/svg'
BEVEL_SIZE = 1.5

helper = require './helper.coffee'

# ## _area ##
# Signed area of the triangle formed by vectors [ab] and [ac]
_area = (a, b, c) -> (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)

# ## _intersects ##
# Test the intersection of two line segments
_intersects = (a, b, c, d) ->
  ((_area(a, b, c) > 0) != (_area(a, b, d) > 0)) and ((_area(c, d, a) > 0) != (_area(c, d, b) > 0))

max = (a, b) -> `(a > b ? a : b)`
min = (a, b) -> `(b > a ? a : b)`

toRGB = (hex) ->
  # Convert to 6-char hex if not already there
  if hex.length is 4
    hex = (c + c for c in hex).join('')[1..]

  # Extract integers from hex
  r = parseInt hex[1..2], 16
  g = parseInt hex[3..4], 16
  b = parseInt hex[5..6], 16

  return [r, g, b]

zeroPad = (str, len) ->
  if str.length < len
    ('0' for [str.length...len]).join('') + str
  else
    str

twoDigitHex = (n) -> zeroPad Math.round(n).toString(16), 2

toHex = (rgb) ->
  return '#' + (twoDigitHex(k) for k in rgb).join ''

memoizedAvgColor = {}

avgColor = (a, factor, b) ->
  c = (a + ',' + factor + ',' + b)
  if c of memoizedAvgColor
    return memoizedAvgColor[c]
  a = toRGB a
  b = toRGB b

  newRGB = (a[i] * factor + b[i] * (1 - factor) for k, i in a)

  return memoizedAvgColor[c] = toHex newRGB

getGuid = -> 'draw-guid-' + Math.random().toString() # For

exports.Draw = class Draw
  ## Public functions
  constructor: ->
    canvas = document.createElement('canvas')
    @ctx = canvas.getContext '2d'
    @fontSize = 15
    @fontFamily = 'Courier New, monospace'
    @fontAscent = 2
    @fontBaseline = 8

    self = this

    # ## Point ##
    # A point knows its x and y coordinate, and can do some vector operations.
    @Point = class Point
      constructor: (@x, @y) ->

      clone: -> new Point @x, @y

      magnitude: -> Math.sqrt @x * @x + @y * @y

      translate: (vector) ->
        @x += vector.x; @y += vector.y

      add: (x, y) -> @x += x; @y += y

      plus: ({x, y}) -> new Point @x + x, @y + y

      toMagnitude: (mag) ->
        r = mag / @magnitude()
        return new Point @x * r, @y * r

      copy: (point) ->
        @x = point.x; @y = point.y

      from: (point) -> new Point @x - point.x, @y - point.y

      clear: -> @x = @y = 0

      equals: (point) -> point.x is @x and point.y is @y

    # ## Size ##
    # A Size knows its width and height.
    @Size = class Size
      constructor: (@width, @height) ->
      equals: (size) ->
        @width is size.width and @height is size.height
      @copy: (size) ->
        new Size(size.width, size.height)

    # ## Rectangle ##
    # A Rectangle knows its upper-left corner, width, and height,
    # and can do rectangular overlap, polygonal intersection,
    # and rectangle or point union (point union is called "swallow").
    @Rectangle = class Rectangle
      constructor: (@x, @y, @width, @height) ->

      contains: (point) -> @x? and @y? and not ((point.x < @x) or (point.x > @x + @width) or (point.y < @y) or (point.y > @y + @height))

      equals: (other) ->
        unless other instanceof Rectangle
          return false
        return @x is other.x and
        @y is other.y and
        @width is other.width and
        @height is other.height

      copy: (rect) ->
        @x = rect.x; @y = rect.y
        @width = rect.width; @height = rect.height

      clip: (ctx) ->
        ctx.rect @x, @y, @width, @height
        ctx.clip()

      clearRect: (ctx) ->
        ctx.clearRect @x, @y, @width, @height

      clone: ->
        rect = new Rectangle(0, 0, 0, 0)
        rect.copy this
        return rect

      clear: -> @width = @height = 0; @x = @y = null

      bottom: -> @y + @height
      right: -> @x + @width

      fill: (ctx, style) ->
        ctx.fillStyle = style
        ctx.fillRect @x, @y, @width, @height

      unite: (rectangle) ->
        unless @x? and @y? then @copy rectangle
        else unless rectangle.x? and rectangle.y? then return
        else
          @width = max(@right(), rectangle.right()) - (@x = min @x, rectangle.x)
          @height = max(@bottom(), rectangle.bottom()) - (@y = min @y, rectangle.y)

      swallow: (point) ->
        unless @x? and @y? then @copy new Rectangle point.x, point.y, 0, 0
        else
          @width = max(@right(), point.x) - (@x = min @x, point.x)
          @height = max(@bottom(), point.y) - (@y = min @y, point.y)

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
    @NoRectangle = class NoRectangle extends Rectangle
      constructor: -> super(null, null, 0, 0)

    # ## Path ##
    # This is called Path, but is forced to be closed so is actually a polygon.
    # It can do fast translation and rectangular intersection.
    @Path = class Path
      constructor: ->
        @_points = []
        @_cachedTranslation = new Point 0, 0
        @_cacheFlag = false
        @_bounds = new NoRectangle()

        @style = {
          'strokeColor': '#000'
          'lineWidth': 0
          'fillColor': null
        }

      _clearCache: ->
        @_cacheFlag = true
        if @_cacheFlag
          if @_points.length is 0
            @_bounds = new NoRectangle()
          else
            minX = minY = Infinity
            maxX = maxY = 0
            for point in @_points
              minX = min minX, point.x
              maxX = max maxX, point.x

              minY = min minY, point.y
              maxY = max maxY, point.y

            @_bounds.x = minX; @_bounds.y = minY
            @_bounds.width = maxX - minX; @_bounds.height = maxY - minY

            @_cacheFlag = false

      push: (point) ->
        @_points.push point
        @_cacheFlag = true

      unshift: (point) ->
        @_points.unshift point
        @_cacheFlag = true

      # ### Point containment ###
      # Accomplished with ray-casting
      contains: (point) ->
        @_clearCache()

        if @_points.length is 0 then return false

        unless @_bounds.contains point then return false

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

        pathElement = document.createElementNS SVG_STANDARD, 'path'

        if @style.fillColor?
          pathElement.setAttribute 'fill', @style.fillColor

        pathCommands = []

        pathCommands.push "M#{@_points[0].x} #{@_points[0].y}"
        for point in @_points
          pathCommands.push "L#{point.x} #{point.y}"
        pathCommands.push "M#{@_points[0].x} #{@_points[0].y}"
        pathCommands.push "Z"

        pathElement.setAttribute 'd', pathCommands.join ' '

        if @bevel
          backgroundPathElement = pathElement
          foregroundPathElement = document.createElementNS SVG_STANDARD, 'path'
          foregroundPathElement.setAttribute 'd', pathCommands.join ' '
          foregroundPathElement.setAttribute 'fill', @style.fillColor
          container = document.createElementNS SVG_STANDARD, 'g'
          pathElement = document.createElementNS SVG_STANDARD, 'g'

          bigClipPath = document.createElementNS SVG_STANDARD, 'clipPath'
          bigClipPathElement = document.createElementNS SVG_STANDARD, 'path'
          bigClipPathElement.setAttribute 'd', pathCommands.join ' '
          bigClipPath.appendChild bigClipPathElement
          bigClipPath.setAttribute 'id', clipId = 'droplet-clip-path-' + Math.random()
          container.appendChild bigClipPath

          littleClipPathA = document.createElementNS SVG_STANDARD, 'clipPath'
          littleClipPathAElement = document.createElementNS SVG_STANDARD, 'path'
          littleClipPathAElement.setAttribute 'd', pathCommands.join ' '
          littleClipPathAElement.setAttribute 'transform', "translate(#{BEVEL_SIZE},#{BEVEL_SIZE})"
          littleClipPathA.appendChild littleClipPathAElement
          littleClipPathA.setAttribute 'id', littleClipAId = 'droplet-clip-path-' + Math.random()
          container.appendChild littleClipPathA

          littleClipPath = document.createElementNS SVG_STANDARD, 'clipPath'
          littleClipPath.setAttribute 'clip-path', "url(##{littleClipAId})"
          littleClipPathElement = document.createElementNS SVG_STANDARD, 'path'
          littleClipPathElement.setAttribute 'd', pathCommands.join ' '
          littleClipPathElement.setAttribute 'transform', "translate(#{-BEVEL_SIZE},#{-BEVEL_SIZE})"
          littleClipPath.appendChild littleClipPathElement
          littleClipPath.setAttribute 'id', littleClipId = 'droplet-clip-path-' + Math.random()
          container.appendChild littleClipPath

          pathElement.setAttribute 'clip-path', "url(##{clipId})"
          foregroundPathElement.setAttribute 'clip-path', "url(##{littleClipId})"

          darkPathElement = document.createElementNS SVG_STANDARD, 'path'
          darkPathElement.setAttribute 'd', pathCommands.join ' '
          darkPathElement.setAttribute 'fill', avgColor @style.fillColor, 0.7, '#000'
          darkPathElement.setAttribute 'transform', "translate(#{BEVEL_SIZE},#{BEVEL_SIZE})"

          lightPathElement = document.createElementNS SVG_STANDARD, 'path'
          lightPathElement.setAttribute 'd', pathCommands.join ' '
          lightPathElement.setAttribute 'fill', avgColor @style.fillColor, 0.7, '#FFF'
          lightPathElement.setAttribute 'transform', "translate(#{-BEVEL_SIZE},#{-BEVEL_SIZE})"

          pathElement.appendChild backgroundPathElement
          pathElement.appendChild darkPathElement
          pathElement.appendChild lightPathElement
          pathElement.appendChild foregroundPathElement
          container.appendChild pathElement

          pathElement = container

        else
          pathElement.setAttribute 'stroke', @style.strokeColor
          pathElement.setAttribute 'stroke-width', @style.lineWidth

        ctx.appendChild pathElement
        return pathElement

      clone: ->
        clone = new Path()
        clone.push el for el in @_points
        return clone

      drawShadow: (ctx, offsetX, offsetY, blur) ->
        ###
        # TODO
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
      ###
      0

    # ## Text ##
    # A Text element. Mainly this exists for computing bounding boxes, which is
    # accomplished via ctx.measureText().
    @Text = class Text
      constructor: (@point, @value) ->
        @wantedFont = self.fontSize + 'px ' + self.fontFamily

        unless self.ctx.font is @wantedFont
          self.ctx.font = self.fontSize + 'px ' + self.fontFamily

        @_bounds = new Rectangle @point.x, @point.y, self.ctx.measureText(@value).width, self.fontSize

      bounds: -> @_bounds
      contains: (point) -> @_bounds.contains point

      translate: (vector) ->
        @point.translate vector
        @_bounds.translate vector

      setPosition: (point) -> @translate point.from @point

      draw: (ctx) ->
        element = document.createElementNS SVG_STANDARD, 'text'
        element.setAttribute 'fill', '#000'

        # We use the alphabetic baseline and add the distance
        # to base ourselves to avoid a chrome bug where text zooming
        # doesn't work for non-alphabetic baselines
        element.setAttribute 'x', @point.x
        element.setAttribute 'y', @point.y + self.fontBaseline - self.fontAscent
        element.setAttribute 'dominant-baseline', 'alphabetic'

        element.setAttribute 'font-family', self.fontFamily
        element.setAttribute 'font-size', self.fontSize

        text = document.createTextNode @value.replace(/ /g, '\u00A0') # Preserve whitespace
        element.appendChild text

        ctx.appendChild element

  refreshFontCapital:  ->
    metrics = helper.fontMetrics(@fontFamily, @fontSize)
    @fontAscent = metrics.prettytop
    @fontBaseline = metrics.baseline

  setGlobalFontSize:  (size) ->
    @fontSize = size
    @refreshFontCapital()

  setGlobalFontFamily:  (family) ->
    @fontFamily = family
    @refreshFontCapital()

  getGlobalFontSize:  -> @fontSize
