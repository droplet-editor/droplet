# Droplet editor view.
#
# Copyright (c) 2015 Anthony Bau (dab1998@gmail.com)
# MIT License

helper = require './helper.coffee'
draw = require './draw.coffee'
model = require './model.coffee'

NO_MULTILINE = 0
MULTILINE_START = 1
MULTILINE_MIDDLE = 2
MULTILINE_END = 3
MULTILINE_END_START = 4

ANY_DROP = helper.ANY_DROP
BLOCK_ONLY = helper.BLOCK_ONLY
MOSTLY_BLOCK = helper.MOSTLY_BLOCK
MOSTLY_VALUE = helper.MOSTLY_VALUE
VALUE_ONLY = helper.VALUE_ONLY

CARRIAGE_ARROW_SIDEALONG = 0
CARRIAGE_ARROW_INDENT = 1
CARRIAGE_ARROW_NONE = 2
CARRIAGE_GROW_DOWN = 3

DROPDOWN_ARROW_HEIGHT = 8

DROP_TRIANGLE_COLOR = '#555'
DROP_TRIANGLE_INVERT_COLOR = '#CCC'

BUTTON_GLYPH_COLOR = 'rgba(0, 0, 0, 0.3)'
BUTTON_GLYPH_INVERT_COLOR = 'rgba(255, 255, 255, 0.5)'
SVG_STANDARD = helper.SVG_STANDARD

DEFAULT_OPTIONS =
  buttonWidth: 15
  lockedSocketButtonWidth: 15
  buttonHeight: 15
  extraLeft: 0
  buttonVertPadding: 6
  buttonHorizPadding: 3
  minIndentTongueWidth: 150
  showDropdowns: true
  padding: 5
  indentWidth: 20
  indentTongueHeight: 20
  tabOffset: 10
  tabWidth: 15
  tabHeight: 5
  tabSideWidth: 0.125
  dropAreaHeight: 20
  indentDropAreaMinWidth: 50
  minSocketWidth: 10
  invisibleSocketWidth: 5
  textHeight: 15
  textPadding: 1
  emptyLineWidth: 50
  highlightAreaHeight: 10
  bevelClip: 3
  shadowBlur: 5
  colors:
    error: '#ff0000'
    comment: '#c0c0c0'  # gray
    return: '#fff59d'   # yellow
    control: '#ffcc80'  # orange
    value: '#a5d6a7'    # green
    command: '#90caf9'  # blue
    red: '#ef9a9a'
    pink: '#f48fb1'
    purple: '#ce93d8'
    deeppurple: '#b39ddb'
    indigo: '#9fa8da'
    blue: '#90caf9'
    lightblue: '#81d4fa'
    cyan: '#80deea'
    teal: '#80cbc4'
    green: '#a5d6a7'
    lightgreen: '#c5e1a5'
    lime: '#e6ee9c'
    yellow: '#fff59d'
    amber: '#ffe082'
    orange: '#ffcc80'
    deeporange: '#ffab91'
    brown: '#bcaaa4'
    grey: '#eeeeee'
    bluegrey: '#b0bec5'
    function: '#90caf9'
    declaration: '#e6ee9c'
    value: '#a5d6a7'
    logic: '#ffab91'
    assign: '#fff59d'
    functionCall: '#90caf9'
    control: '#ffab91'

YES = -> yes
NO = -> no

arrayEq = (a, b) ->
  return false if a.length isnt b.length
  return false if k isnt b[i] for k, i in a
  return true

# # View
# The View class contains options and caches
# for rendering. The controller instantiates a View
# and interacts with things through it.
#
# Inner classes in the View correspond to Model
# types (e.g. SocketViewNode, etc.) all of which
# will have access to their View's caches
# and options object.
exports.View = class View
  constructor: (@ctx, @opts = {}) ->
    @ctx ?= document.createElementNS SVG_STANDARD, 'svg'

    # @map maps Model objects
    # to corresponding View objects,
    # so that rerendering the same model
    # can be fast
    @map = {}

    @oldRoots = {}
    @newRoots = {}
    @auxiliaryMap = {}

    @flaggedToDelete = {}
    @unflaggedToDelete = {}

    @marks = {}

    @draw = new draw.Draw(@ctx)

    # Apply default options
    for option of DEFAULT_OPTIONS
      unless option of @opts
        @opts[option] = DEFAULT_OPTIONS[option]

    for color of DEFAULT_OPTIONS.colors
      unless color of @opts.colors
        @opts.colors[color] = DEFAULT_OPTIONS.colors[color]

    if @opts.invert
      @opts.colors['comment'] = '#606060'

  # Simple method for clearing caches
  clearCache: ->
    for id of @map
      @map[id].destroy()
      @destroy id

  # Remove everything from the canvas
  clearFromCanvas: ->
    @beginDraw()
    @cleanupDraw()

  # ## getViewNodeFor
  # Given a model object,
  # give the corresponding renderer object
  # under this View. If one does not exist,
  # create one, then preserve it in our map.
  getViewNodeFor: (model) ->
    if model.id of @map
      return @map[model.id]
    else
      return @createView(model)

  registerMark: (id) ->
    @marks[id] = true

  clearMarks: ->
    for key, val of @marks
      @map[key].unmark()
    @marks = {}

  beginDraw: ->
    @newRoots = {}

  hasViewNodeFor: (model) ->
    model? and model.id of @map

  getAuxiliaryNode: (node) ->
    if node.id of @auxiliaryMap
      return @auxiliaryMap[node.id]
    else
      return @auxiliaryMap[node.id] = new AuxiliaryViewNode(@, node)

  registerRoot: (node) ->
    if node instanceof model.List and not (
       node instanceof model.Container)
      node.traverseOneLevel (head) =>
        unless head instanceof model.NewlineToken
          @registerRoot head
      return
    for id, aux of @newRoots
      if aux.model.hasParent(node)
        delete @newRoots[id]
      else if node.hasParent(aux.model)
        return

    @newRoots[node.id] = @getAuxiliaryNode(node)

  cleanupDraw: ->
    @flaggedToDelete = {}
    @unflaggedToDelete = {}

    for id, el of @oldRoots
      unless id of @newRoots
        @flag el

    for id, el of @newRoots
      el.cleanup()

    for id, el of @flaggedToDelete when id of @unflaggedToDelete
      delete @flaggedToDelete[id]

    for id, el of @flaggedToDelete when id of @map
      @map[id].hide()

    @oldRoots = @newRoots

  flag: (auxiliaryNode) ->
    @flaggedToDelete[auxiliaryNode.model.id] = auxiliaryNode

  unflag: (auxiliaryNode) ->
    @unflaggedToDelete[auxiliaryNode.model.id] = auxiliaryNode

  garbageCollect: ->
    @cleanupDraw()

    for id, el of @flaggedToDelete when id of @map
      @map[id].destroy()
      @destroy id

    for id, el of @newRoots
      el.update()

  destroy: (id) ->
    for child in @map[id].children
      if @map[child.child.id]? and not @unflaggedToDelete[child.child.id]
        @destroy child.child.id
    delete @map[id]
    delete @auxiliaryMap[id]
    delete @flaggedToDelete[id]

  hasViewNodeFor: (model) -> model? and model.id of @map

  # ## createView
  # Given a model object, create a renderer object
  # of the appropriate type.
  createView: (entity) ->
    if (entity instanceof model.List) and not
       (entity instanceof model.Container)
      return new ListViewNode entity, this
    switch entity.type
      when 'text' then new TextViewNode entity, this
      when 'block' then new BlockViewNode entity, this
      when 'indent' then new IndentViewNode entity, this
      when 'socket' then new SocketViewNode entity, this
      when 'buttonContainer' then new ContainerViewNode entity, this
      when 'lockedSocket' then new ContainerViewNode entity, this # LockedSocketViewNode entity, this
      when 'document' then new DocumentViewNode entity, this

  # Looks up a color name, or passes through a #hex color.
  getColor: (color) ->
    if color and '#' is color.charAt(0)
      color
    else
      @opts.colors[color] ? '#ffffff'

  class AuxiliaryViewNode
    constructor: (@view, @model) ->
      @children = {}
      @computedVersion = -1

    cleanup: ->
      @view.unflag @

      if @model.version is @computedVersion
        return

      children = {}
      if @model instanceof model.Container
        @model.traverseOneLevel (head) =>
          if head instanceof model.NewlineToken
            return
          else
            children[head.id] = @view.getAuxiliaryNode head

      for id, child of @children
        unless id of children
          @view.flag child

      for id, child of children
        @children[id] = child
        child.cleanup()

    update: ->
      @view.unflag @

      if @model.version is @computedVersion
        return

      children = {}
      if @model instanceof model.Container
        @model.traverseOneLevel (head) =>
          if head instanceof model.NewlineToken
            return
          else
            children[head.id] = @view.getAuxiliaryNode head

      @children = children

      for id, child of @children
        child.update()

      @computedVersion = @model.version

  # # GenericViewNode
  # Class from which all renderer classes will
  # extend.
  class GenericViewNode
    constructor: (@model, @view) ->
      # Record ourselves in the map
      # from model to renderer
      @view.map[@model.id] = this

      @view.registerRoot @model

      @lastCoordinate = new @view.draw.Point 0, 0

      @invalidate = false

      # *Zeroth pass variables*
      # computeChildren
      @lineLength = 0 # How many lines does this take up?
      @children = [] # All children, flat
      @oldChildren = [] # Previous children, for removing
      @lineChildren = [] # Children who own each line
      @multilineChildrenData = [] # Where do indents start/end?

      # *First pass variables*
      # computeMargins
      @margins = {left:0, right:0, top:0, bottom:0}
      @topLineSticksToBottom = false
      @bottomLineSticksToTop = false

      # *Pre-second pass variables*
      # computeMinDimensions
      # @view.draw.Size type, {width:n, height:m}
      @minDimensions = [] # Dimensions on each line
      @minDistanceToBase = [] # {above:n, below:n}

      # *Second pass variables*
      # computeDimensions
      # @view.draw.Size type, {width:n, height:m}
      @dimensions = [] # Dimensions on each line
      @distanceToBase = [] # {above:n, below:n}

      @carriageArrow = CARRIAGE_ARROW_NONE

      @bevels =
        top: false
        bottom: false

      # *Third/fifth pass variables*
      # computeBoundingBoxX, computeBoundingBoxY
      # @view.draw.Rectangle type, {x:0, y:0, width:200, height:100}
      @bounds = [] # Bounding boxes on each line
      @changedBoundingBox = true # Did any bounding boxes change just now?

      # *Fourth pass variables*
      # computeGlue
      # {height:2, draw:true}
      @glue = {}

      @elements = []
      @activeElements = []

      # Versions. The corresponding
      # Model will keep corresponding version
      # numbers, and each of our passes can
      # become a no-op when we are up-to-date (so
      # that rerendering is fast when there are
      # few or no changes to the Model).
      @computedVersion = -1

    draw: (boundingRect, style = {}, parent = null) ->
      @drawSelf style, parent

    root: ->
      for element in @elements
        element.setParent @view.draw.ctx

    serialize: (line) ->
      result = []
      for prop in [
          'lineLength'
          'margins'
          'topLineSticksToBottom'
          'bottomLineSticksToTop'
          'changedBoundingBox'
          'path'
          'highlightArea'
          'computedVersion'
          'carriageArrow'
          'bevels']
        result.push(prop + ': ' + JSON.stringify(@[prop]))
      for child, i in @children
        result.push("child #{i}: {startLine: #{child.startLine}, " +
                    "endLine: #{child.endLine}}")
      if line?
        for prop in [
            'multilineChildrenData'
            'minDimensions'
            'minDistanceToBase'
            'dimensions'
            'distanceToBase'
            'bounds'
            'glue']
          result.push("#{prop} #{line}: #{JSON.stringify(@[prop][line])}")
        for child, i in @lineChildren[line]
          result.push("line #{line} child #{i}: " +
                      "{startLine: #{child.startLine}, " +
                      "endLine: #{child.endLine}}}")
      else
        for line in [0...@lineLength]
          for prop in [
              'multilineChildrenData'
              'minDimensions'
              'minDistanceToBase'
              'dimensions'
              'distanceToBase'
              'bounds'
              'glue']
            result.push("#{prop} #{line}: #{JSON.stringify(@[prop][line])}")
          for child, i in @lineChildren[line]
            result.push("line #{line} child #{i}: " +
                        "{startLine: #{child.startLine}, " +
                        "endLine: #{child.endLine}}}")

      return result.join('\n')

    # ## computeChildren (GenericViewNode)
    # Find out which of our children lie on each line that we
    # own, and also how many lines we own.
    #
    # Return the number of lines we own.
    #
    # This is basically a void computeChildren that should be
    # overridden.
    computeChildren: -> @lineLength

    focusAll: ->
      @group.focus()

    computeCarriageArrow: ->
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeCarriageArrow()

      return @carriageArrow

    # ## computeMargins (GenericViewNode)
    # Compute the amount of margin required outside the child
    # on the top, bottom, left, and right.
    #
    # This is a void computeMargins that should be overridden.
    computeMargins: ->
      if @computedVersion is @model.version and
         (not @model.parent? or not @view.hasViewNodeFor(@model.parent) or
         @model.parent.version is @view.getViewNodeFor(@model.parent).computedVersion)
        return @margins

      # the margins I need depend on the type of my parent
      parenttype = @model.parent?.type
      padding = @view.opts.padding

      left = if @model.isFirstOnLine() or @lineLength > 1 then padding else 0
      right = if @model.isLastOnLine() or @lineLength > 1 then padding else 0

      if parenttype is 'block' and @model.type is 'indent'
        @margins =
          top: 0
          bottom: if @lineLength > 1 then @view.opts.indentTongueHeight else padding

          firstLeft: padding
          midLeft: @view.opts.indentWidth
          lastLeft: @view.opts.indentWidth

          firstRight: 0
          midRight: 0
          lastRight: padding

      else if @model.type is 'text' and parenttype is 'socket'
        @margins =
          top: @view.opts.textPadding
          bottom: @view.opts.textPadding

          firstLeft: @view.opts.textPadding
          midLeft: @view.opts.textPadding
          lastLeft: @view.opts.textPadding

          firstRight: @view.opts.textPadding
          midRight: @view.opts.textPadding
          lastRight: @view.opts.textPadding

      else if @model.type is 'text' and parenttype is 'block'
        if @model.prev?.type is 'newline' and @model.next?.type in ['newline', 'indentStart'] or @model.prev?.prev?.type is 'indentEnd'
          textPadding = padding / 2
        else
          textPadding = padding
        @margins =
          top: textPadding
          bottom: textPadding #padding

          firstLeft: left
          midLeft: left
          lastLeft: left

          firstRight: right
          midRight: right
          lastRight: right

      else if parenttype is 'block'
        @margins =
          top: padding
          bottom: padding

          firstLeft: left
          midLeft: padding
          lastLeft: padding

          firstRight: right
          midRight: 0
          lastRight: right
      else
        @margins = {
          firstLeft: 0, midLeft:0, lastLeft: 0
          firstRight: 0, midRight:0, lastRight: 0
          top:0, bottom:0
        }

      @firstMargins =
        left: @margins.firstLeft
        right: @margins.firstRight
        top: @margins.top
        bottom: if @lineLength is 1 then @margins.bottom else 0

      @midMargins =
        left: @margins.midLeft
        right: @margins.midRight
        top: 0
        bottom: 0

      @lastMargins =
        left: @margins.lastLeft
        right: @margins.lastRight
        top: if @lineLength is 1 then @margins.top else 0
        bottom: @margins.bottom

      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeMargins()

      return null

    getMargins: (line) ->
      if line is 0 then @firstMargins
      else if line is @lineLength - 1 then @lastMargins
      else @midMargins

    computeBevels: ->
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeBevels()

      return @bevels

    # ## computeMinDimensions (GenericViewNode)
    # Compute the size of our bounding box on each
    # line that we contain.
    #
    # Return child node.
    #
    # This is a void computeDimensinos that should be overridden.
    computeMinDimensions: ->
      if @minDimensions.length > @lineLength
        @minDimensions.length = @minDistanceToBase.length = @lineLength
      else
        until @minDimensions.length is @lineLength
          @minDimensions.push new @view.draw.Size 0, 0
          @minDistanceToBase.push {above: 0, below: 0}

      for i in [0...@lineLength]
        @minDimensions[i].width = @minDimensions[i].height = 0
        @minDistanceToBase[i].above = @minDistanceToBase[i].below = 0

      return null


    # ## computeDimensions (GenericViewNode)
    # Compute the size of our bounding box on each
    # line that we contain.
    #
    # Return child node.
    computeDimensions: (force, root = false) ->
      if @computedVersion is @model.version and not force and not @invalidate
        return

      oldDimensions = @dimensions
      oldDistanceToBase = @distanceToBase

      @dimensions = (new @view.draw.Size 0, 0 for [0...@lineLength])
      @distanceToBase = ({above: 0, below: 0} for [0...@lineLength])

      for size, i in @minDimensions
        @dimensions[i].width = size.width; @dimensions[i].height = size.height
        @distanceToBase[i].above = @minDistanceToBase[i].above
        @distanceToBase[i].below = @minDistanceToBase[i].below

      if @model.parent? and @view.hasViewNodeFor(@model.parent) and not root and
          (@topLineSticksToBottom or @bottomLineSticksToTop or
           (@lineLength > 1 and not @model.isLastOnLine()))
        parentNode = @view.getViewNodeFor @model.parent
        startLine = @model.getLinesToParent()

        # grow below if "stick to bottom" is set.
        if @topLineSticksToBottom
          distance = @distanceToBase[0]
          distance.below = Math.max(distance.below,
              parentNode.distanceToBase[startLine].below)
          @dimensions[0] = new @view.draw.Size(
              @dimensions[0].width,
              distance.below + distance.above)

        # grow above if "stick to top" is set.
        if @bottomLineSticksToTop
          lineCount = @distanceToBase.length
          distance = @distanceToBase[lineCount - 1]
          distance.above = Math.max(distance.above,
              parentNode.distanceToBase[startLine + lineCount - 1].above)
          @dimensions[lineCount - 1] = new @view.draw.Size(
              @dimensions[lineCount - 1].width,
              distance.below + distance.above)

        if @lineLength > 1 and not @model.isLastOnLine() and @model.type is 'block'
          distance = @distanceToBase[@lineLength - 1]
          distance.below = parentNode.distanceToBase[startLine + @lineLength - 1].below
          @dimensions[lineCount - 1] = new @view.draw.Size(
              @dimensions[lineCount - 1].width,
              distance.below + distance.above)

      changed = (oldDimensions.length != @lineLength)
      if not changed then for line in [0...@lineLength]
        if !oldDimensions[line].equals(@dimensions[line]) or
            oldDistanceToBase[line].above != @distanceToBase[line].above or
            oldDistanceToBase[line].below != @distanceToBase[line].below
          changed = true
          break

      @changedBoundingBox or= changed

      for childObj in @children
        if childObj in @lineChildren[0] or childObj in @lineChildren[@lineLength - 1]
          @view.getViewNodeFor(childObj.child).computeDimensions(changed, not (@model instanceof model.Container)) #(hack)
        else
          @view.getViewNodeFor(childObj.child).computeDimensions(false, not (@model instanceof model.Container)) #(hack)

      return null

    # ## computeBoundingBoxX (GenericViewNode)
    # Given the left edge coordinate for our bounding box on
    # this line, recursively layout the x-coordinates of us
    # and all our children on this line.
    computeBoundingBoxX: (left, line) ->
      # Attempt to use our cache. Because modifications in the parent
      # can affect the shape of child blocks, we can't only rely
      # on versioning. For instance, changing `fd 10` to `forward 10`
      # does not update the version on `10`, but the bounding box for
      # `10` still needs to change. So we must also check
      # that the coordinate we are given to begin the bounding box on matches.
      if @computedVersion is @model.version and
         left is @bounds[line]?.x and not @changedBoundingBox or
         @bounds[line]?.x is left and
         @bounds[line]?.width is @dimensions[line].width
        return @bounds[line]

      @changedBoundingBox = true

      # Avoid re-instantiating a Rectangle object,
      # if possible.
      if @bounds[line]?
        @bounds[line].x = left
        @bounds[line].width = @dimensions[line].width

      # If not, create one.
      else
        @bounds[line] = new @view.draw.Rectangle(
          left, 0
          @dimensions[line].width, 0
        )

      return @bounds[line]

    # ## computeAllBoundingBoxX (GenericViewNode)
    # Call `@computeBoundingBoxX` on all lines,
    # thus laying out the entire document horizontally.
    computeAllBoundingBoxX: (left = 0) ->
      for size, line in @dimensions
        @computeBoundingBoxX left, line

      return @bounds

    # ## computeGlue (GenericViewNode)
    # If there are disconnected bounding boxes
    # that belong to the same block,
    # insert "glue" spacers between lines
    # to connect them. For instance:
    #
    # ```
    # someLongFunctionName ''' hello
    # world '''
    # ```
    #
    # would require glue between 'hello' and 'world'.
    #
    # This is a void function that should be overridden.
    computeGlue: ->
      @glue = {}

    # ## computeBoundingBoxY (GenericViewNode)
    # Like computeBoundingBoxX. We must separate
    # these passes because glue spacers from `computeGlue`
    # affect computeBoundingBoxY.
    computeBoundingBoxY: (top, line) ->
      # Again, we need to check to make sure that the coordinate
      # we are given matches, since we cannot only rely on
      # versioning (see computeBoundingBoxX).
      if @computedVersion is @model.version and
         top is @bounds[line]?.y and not @changedBoundingBox or
         @bounds[line].y is top and
         @bounds[line].height is @dimensions[line].height
        return @bounds[line]

      @changedBoundingBox = true

      # Accept the bounding box edge we were given.
      # We assume here that computeBoundingBoxX was
      # already run for this version, so we
      # should be guaranteed that `@bounds[line]` exists.
      @bounds[line].y = top
      @bounds[line].height = @dimensions[line].height

      return @bounds[line]

    # ## computeAllBoundingBoxY (GenericViewNode)
    # Call `@computeBoundingBoxY` on all lines,
    # thus laying out the entire document vertically.
    #
    # Account for glue spacing between lines.
    computeAllBoundingBoxY: (top = 0) ->
      for size, line in @dimensions
        @computeBoundingBoxY top, line
        top += size.height
        if line of @glue then top += @glue[line].height

      return @bounds

    # ## getBounds (GenericViewNode)
    # Deprecated. Access `@totalBounds` directly instead.
    getBounds: -> @totalBounds

    # ## computeOwnPath
    # Using bounding box data, compute the vertices
    # of the polygon that will wrap them. This function
    # will be called from `computePath`, which does this
    # recursively so as to draw the entire tree.
    #
    # Many nodes do not have paths at all,
    # and so need not override this function.
    computeOwnPath: ->

    # ## computePath (GenericViewNode)
    # Call `@computeOwnPath` and recurse. This function
    # should never need to be overridden; override `@computeOwnPath`
    # instead.
    computePath: ->
      # Here, we cannot just rely on versioning either.
      # We need to know if any bounding box data changed. So,
      # look at `@changedBoundingBox`, which should be set
      # to `true` whenever a bounding box changed on the bounding box
      # passes.
      if @computedVersion is @model.version and
           (@model.isLastOnLine() is @lastComputedLinePredicate) and
           not @changedBoundingBox
        return null

      # Recurse.
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computePath()

      # It is possible that we have a version increment
      # without changing bounding boxes. If this is the case,
      # we don't need to recompute our own path.
      if @changedBoundingBox or (@model.isLastOnLine() isnt @lastComputedLinePredicate)
        @computeOwnPath()

        # Recompute `totalBounds`, which is used
        # to avoid re*drawing* polygons that
        # are not on-screen. `totalBounds` is the AABB
        # of the everything that has to do with the element,
        # and we redraw iff it overlaps the AABB of the viewport.
        @totalBounds = new @view.draw.NoRectangle()
        if @bounds.length > 0
          @totalBounds.unite @bounds[0]
          @totalBounds.unite @bounds[@bounds.length - 1]

        # Figure out our total bounding box however is faster.
        if @bounds.length > @children.length
          for child in @children
            @totalBounds.unite @view.getViewNodeFor(child.child).totalBounds
        else
          maxRight = @totalBounds.right()
          for bound in @bounds
            @totalBounds.x = Math.min @totalBounds.x, bound.x
            maxRight = Math.max maxRight, bound.right()

          @totalBounds.width = maxRight - @totalBounds.x

        if @path?
          @totalBounds.unite @path.bounds()

      @lastComputedLinePredicate = @model.isLastOnLine()

      return null

    # ## computeOwnDropArea (GenericViewNode)
    # Using bounding box data, compute the drop area
    # for drag-and-drop blocks, if it exists.
    #
    # If we cannot drop something on this node
    # (e.g. a socket that already contains a block),
    # set `@dropArea` to null.
    #
    # Simultaneously, compute `@highlightArea`, which
    # is the white polygon that lights up
    # when we hover over a drop area.
    computeOwnDropArea: ->

    # ## computeDropAreas (GenericViewNode)
    # Call `@computeOwnDropArea`, and recurse.
    #
    # This should never have to be overridden;
    # override `@computeOwnDropArea` instead.
    computeDropAreas: ->
      # Like with `@computePath`, we cannot rely solely on versioning,
      # so we check the bounding box flag.
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return null

      # Compute drop and highlight areas for ourself
      @computeOwnDropArea()

      # Recurse.
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeDropAreas()

      return null

    computeNewVersionNumber: ->
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return null

      @changedBoundingBox = false
      @invalidate = false
      @computedVersion = @model.version

      # Recurse.
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeNewVersionNumber()

      return null


    # ## drawSelf (GenericViewNode)
    # Draw our own polygon on a canvas context.
    # May require special effects, like graying-out
    # or blueing for lasso select.
    drawSelf: (style = {}) ->

    hide: ->
      for element in @elements
        element?.deactivate?()
      @activeElements = []

    destroy: (root = true) ->
      if root
        for element in @elements
          element?.destroy?()
      else if @highlightArea?
        @highlightArea.destroy()

      @activeElements = []

      for child in @children
        @view.getViewNodeFor(child.child).destroy(false)

  class ListViewNode extends GenericViewNode
    constructor: (@model, @view) ->
      super

    draw: (boundingRect, style = {}, parent = null) ->
      super
      for childObj in @children
        @view.getViewNodeFor(childObj.child).draw boundingRect, style, @group

    root: ->
      for child in @children
        @view.getViewNodeFor(child.child).root()

    destroy: (root = true) ->
      for child in @children
        @view.getViewNodeFor(child.child).destroy()

    # ## computeChildren (ListViewNode)
    # Figure out which children lie on each line,
    # and compute `@multilineChildrenData` simultaneously.
    #
    # We will do this by going to all of our immediate children,
    # recursing, then calculating their starting and ending lines
    # based on their computing line lengths.
    computeChildren: ->
      # If we can, use our cached information.
      if @computedVersion is @model.version
        return @lineLength

      # Otherwise, recompute.
      @lineLength = 0
      @lineChildren = [[]]
      @children = []
      @multilineChildrenData = []
      @topLineSticksToBottom = false
      @bottomLineSticksToTop = false

      line = 0

      # Go to all our immediate children.
      @model.traverseOneLevel (head) =>
        # If the child is a newline, simply advance the
        # line counter.
        if head.type is 'newline'
          line += 1
          @lineChildren[line] ?= []

        # Otherwise, get the view object associated
        # with this model, and ask it to
        # compute children.
        else
          view = @view.getViewNodeFor(head)
          childLength = view.computeChildren()

          # Construct a childObject,
          # which will remember starting and endling lines.
          childObject =
            child: head
            startLine: line
            endLine: line + childLength - 1

          # Put it into `@children`.
          @children.push childObject

          # Put it into `@lineChildren`.
          for i in [line...line + childLength]
            @lineChildren[i] ?= []

            # We don't want to store cursor tokens
            # in `@lineChildren`, as they are inconvenient
            # to deal with in layout, which is the only
            # thing `@lineChildren` is used for.
            unless head.type is 'cursor'
              @lineChildren[i].push childObject

          # If this object is a multiline child,
          # update our multiline child data to reflect
          # where it started and ended.
          if view.lineLength > 1
            if @multilineChildrenData[line] is MULTILINE_END
              @multilineChildrenData[line] = MULTILINE_END_START
            else
              @multilineChildrenData[line] = MULTILINE_START

            @multilineChildrenData[i] = MULTILINE_MIDDLE for i in [line + 1...line + childLength - 1]
            @multilineChildrenData[line + childLength - 1] = MULTILINE_END

          # Advance our line counter
          # by however long the child was
          # (i.e. however many newlines
          # we skipped).
          line += childLength - 1

      # Set @lineLength to reflect
      # what we just found out.
      @lineLength = line + 1

      # If we have changed in line length,
      # there has obviously been a bounding box change.
      # The bounding box pass as it stands only deals
      # with lines it knows exists, so we need to chop off
      # the end of the array.
      if @bounds.length isnt @lineLength
        @changedBoundingBox = true
        @bounds = @bounds[...@lineLength]

      # Fill in gaps in @multilineChildrenData with NO_MULTILINE
      @multilineChildrenData[i] ?= NO_MULTILINE for i in [0...@lineLength]

      if @lineLength > 1
        @topLineSticksToBottom = true
        @bottomLineSticksToTop = true

      return @lineLength

    # ## computeDimensions (ListViewNode)
    # Compute the size of our bounding box on each line.
    computeMinDimensions: ->
      # If we can, use cached data.
      if @computedVersion is @model.version
        return null

      # start at zero min dimensions
      super

      # Lines immediately after the end of Indents
      # have to be extended to a minimum width.
      # Record the lines that need to be extended here.
      linesToExtend = []
      preIndentLines = []

      # Recurse on our children, updating
      # our dimensions as we go to contain them.
      for childObject in @children
        # Ask the child to compute dimensions
        childNode = @view.getViewNodeFor(childObject.child)
        childNode.computeMinDimensions()
        minDimensions = childNode.minDimensions
        minDistanceToBase = childNode.minDistanceToBase

        # Horizontal margins get added to every line.
        for size, line in minDimensions
          desiredLine = line + childObject.startLine
          margins = childNode.getMargins line

          # Unless we are in the middle of an indent,
          # add padding on the right of the child.
          #
          # Exception: Children with invisible bounding boxes
          # should remain invisible. This matters
          # mainly for indents starting at the end of a line.
          @minDimensions[desiredLine].width += size.width +
            margins.left +
            margins.right

          # Compute max distance above and below text
          #
          # Exception: do not add the bottom padding on an
          # Indent if we own the next line as well.

          if childObject.child.type is 'indent' and
              line is minDimensions.length - 1 and
              desiredLine < @lineLength - 1
            bottomMargin = 0
            linesToExtend.push desiredLine + 1
          else if childObject.child.type is 'indent' and
              line is 0
            preIndentLines.push desiredLine
            bottomMargin = margins.bottom
          else
            bottomMargin = margins.bottom


          @minDistanceToBase[desiredLine].above = Math.max(
            @minDistanceToBase[desiredLine].above,
            minDistanceToBase[line].above + margins.top)
          @minDistanceToBase[desiredLine].below = Math.max(
            @minDistanceToBase[desiredLine].below,
            minDistanceToBase[line].below + Math.max(bottomMargin, (
              if @model.buttons? and @model.buttons.length > 0 and
                  desiredLine is @lineLength - 1 and
                  @multilineChildrenData[line] is MULTILINE_END and
                  @lineChildren[line].length is 1
                @view.opts.buttonVertPadding + @view.opts.buttonHeight
              else
                0
            )))

      # Height is just the sum of the above-base and below-base counts.
      # Empty lines should have some height.
      for minDimension, line in @minDimensions
        if @lineChildren[line].length is 0
          # Socket should be shorter than other blocks
          if @model.type is 'socket'
            @minDistanceToBase[line].above = @view.opts.textHeight + @view.opts.textPadding
            @minDistanceToBase[line].below = @view.opts.textPadding

          # Text should not claim any padding
          else if @model.type is 'text'
            @minDistanceToBase[line].above = @view.opts.textHeight
            @minDistanceToBase[line].below = 0

          # The first line of an indent is often empty; this is the desired behavior
          else if @model.type is 'indent' and line is 0
            @minDistanceToBase[line].above = 0
            @minDistanceToBase[line].below = 0

          # Empty blocks should be the height of lines with text
          else
            @minDistanceToBase[line].above = @view.opts.textHeight + @view.opts.padding
            @minDistanceToBase[line].below = @view.opts.padding

        minDimension.height =
          @minDistanceToBase[line].above +
          @minDistanceToBase[line].below

      # Make space for mutation buttons. In lockedSocket,
      # these will go on the left; otherwise they will go on the right.
      @extraLeft = 0
      @extraWidth = 0

      if @model.type in ['block', 'buttonContainer']
        if @model.buttons? then for {key} in @model.buttons
          @extraWidth += @view.opts.buttonWidth + @view.opts.buttonHorizPadding

        @minDimensions[@minDimensions.length - 1].width += @extraWidth

      if @model.type is 'lockedSocket'
        if @model.buttons? then for {key} in @model.buttons
          @extraLeft += @view.opts.buttonWidth + @view.opts.buttonHorizPadding

        @minDimensions[@minDimensions.length - 1].width += @extraLeft

      # Go through and adjust the width of rectangles
      # immediately after the end of an indent to
      # be as long as necessary
      for line in linesToExtend
        @minDimensions[line].width = Math.max(
          @minDimensions[line].width, Math.max(
            @view.opts.minIndentTongueWidth,
            @view.opts.indentWidth + @view.opts.tabWidth + @view.opts.tabOffset + @view.opts.bevelClip
        ))

      for line in preIndentLines
        @minDimensions[line].width = Math.max(
          @minDimensions[line].width, Math.max(
            @view.opts.minIndentTongueWidth,
            @view.opts.indentWidth + @view.opts.tabWidth + @view.opts.tabOffset + @view.opts.bevelClip
        ))

      # Add space for carriage arrow
      for lineChild in @lineChildren[@lineLength - 1]
        lineChildView = @view.getViewNodeFor lineChild.child
        if lineChildView.carriageArrow isnt CARRIAGE_ARROW_NONE
          @minDistanceToBase[@lineLength - 1].below += @view.opts.padding
          @minDimensions[@lineLength - 1].height =
            @minDistanceToBase[@lineLength - 1].above +
            @minDistanceToBase[@lineLength - 1].below
          break

      return null

    # ## computeBoundingBoxX (ListViewNode)
    # Layout bounding box positions horizontally.
    # This needs to be separate from y-coordinate computation
    # because of glue spacing (the space between lines
    # that keeps weird-shaped blocks continuous), which
    # can shift y-coordinates around.
    computeBoundingBoxX: (left, line, offset = 0) ->
      # Use cached data if possible
      if @computedVersion is @model.version and
          left is @bounds[line]?.x and not @changedBoundingBox
        return @bounds[line]

      offset += @extraLeft

      # If the bounding box we're being asked
      # to layout is exactly the same,
      # avoid setting `@changedBoundingBox`
      # for performance reasons (also, trivially,
      # avoid changing bounding box coords).
      unless @bounds[line]?.x is left and
             @bounds[line]?.width is @dimensions[line].width

        # Assign our own bounding box given
        # this center-left coordinate
        if @bounds[line]?
          @bounds[line].x = left
          @bounds[line].width = @dimensions[line].width
        else
          @bounds[line] = new @view.draw.Rectangle(
            left, 0
            @dimensions[line].width, 0
          )

        @changedBoundingBox = true

      # Now recurse. We will keep track
      # of a "cursor" as we go along,
      # placing children down and
      # adding padding and sizes
      # to make them not overlap.
      childLeft = left + offset

      # Get rendering info on each of these children
      for lineChild, i in @lineChildren[line]
        childView = @view.getViewNodeFor lineChild.child
        childLine = line - lineChild.startLine
        childMargins = childView.getMargins childLine

        childLeft += childMargins.left
        childView.computeBoundingBoxX childLeft, childLine
        childLeft +=
          childView.dimensions[childLine].width + childMargins.right

      # Return the bounds we just
      # computed.
      return @bounds[line]


    # ## computeBoundingBoxY
    # Layout a line vertically.
    computeBoundingBoxY: (top, line) ->
      # Use our cache if possible.
      if @computedVersion is @model.version and
          top is @bounds[line]?.y and not @changedBoundingBox
        return @bounds[line]

      # Avoid setting `@changedBoundingBox` if our
      # bounding box has not actually changed,
      # for performance reasons. (Still need to
      # recurse, in case children have changed
      # but not us)
      unless @bounds[line]?.y is top and
         @bounds[line]?.height is @dimensions[line].height

        # Assign our own bounding box given
        # this center-left coordinate
        @bounds[line].y = top
        @bounds[line].height = @dimensions[line].height

        @changedBoundingBox = true

      # Go to each child and lay them out so that their distanceToBase
      # lines up.
      above = @distanceToBase[line].above
      for lineChild, i in @lineChildren[line]
        childView = @view.getViewNodeFor lineChild.child
        childLine = line - lineChild.startLine
        childAbove = childView.distanceToBase[childLine].above
        childView.computeBoundingBoxY top + above - childAbove, childLine

      # Return the bounds we just computed.
      return @bounds[line]

    # ## layout
    # Run all of these layout steps in order.
    #
    # Takes two arguments, which can be changed
    # to translate the entire document from the upper-left corner.
    layout: (left = @lastCoordinate.x, top = @lastCoordinate.y) ->
      @view.registerRoot @model

      @lastCoordinate = new @view.draw.Point left, top

      @computeChildren()
      @computeCarriageArrow true
      @computeMargins()
      @computeBevels()
      @computeMinDimensions()
      @computeDimensions 0, true
      @computeAllBoundingBoxX left
      @computeGlue()
      @computeAllBoundingBoxY top
      @computePath()
      @computeDropAreas()

      changedBoundingBox = @changedBoundingBox
      @computeNewVersionNumber()

      return changedBoundingBox

    # ## absorbCache
    # A hacky thing to get a view node of a new List
    # to acquire all the properties of its children
    # TODO re-examine
    absorbCache: ->
      @view.registerRoot @model

      @computeChildren()
      @computeCarriageArrow true
      @computeMargins()
      @computeBevels()
      @computeMinDimensions()
      # Replacement for computeDimensions
      for size, line in @minDimensions
        @distanceToBase[line] = {
          above: @lineChildren[line].map((child) => @view.getViewNodeFor(child.child).distanceToBase[line - child.startLine].above).reduce((a, b) -> Math.max(a, b))
          below: @lineChildren[line].map((child) => @view.getViewNodeFor(child.child).distanceToBase[line - child.startLine].below).reduce((a, b) -> Math.max(a, b))
        }
        @dimensions[line] = new draw.Size @minDimensions[line].width, @minDimensions[line].height

      #@computeDimensions false, true
      # Replacement for computeAllBoundingBoxX
      for size, line in @dimensions
        child = @lineChildren[line][0]
        childView = @view.getViewNodeFor child.child
        left = childView.bounds[line - child.startLine].x
        @computeBoundingBoxX left, line
      @computeGlue()
      # Replacement for computeAllBoundingBoxY
      for size, line in @dimensions
        child = @lineChildren[line][0]
        childView = @view.getViewNodeFor child.child
        oldY = childView.bounds[line - child.startLine].y
        top = childView.bounds[line - child.startLine].y +
          childView.distanceToBase[line - child.startLine].above -
          @distanceToBase[line].above
        @computeBoundingBoxY top, line
      @computePath()
      @computeDropAreas()

      return true

    # ## computeGlue
    # Compute the necessary glue spacing between lines.
    #
    # If a block has disconnected blocks, e.g.
    # ```
    # someLongFunctionName '''hello
    # world'''
    # ```
    #
    # it requires glue spacing. Then, any surrounding blocks
    # must add their padding to that glue spacing, until we
    # reach an Indent, at which point we can stop.
    #
    # Parents outside the indent must stil know that there is
    # a space between these line, but they wil not have
    # to colour in that space. This will be flaged
    # by the `draw` flag on the glue objects.
    computeGlue: ->
      # Use our cache if possible
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return @glue

      # Immediately recurse, as we will
      # need to know child glue info in order
      # to compute our own (adding padding, etc.).
      for childObj in @children
        @view.getViewNodeFor(childObj.child).computeGlue()

      @glue = {}

      # Go through every pair of adjacent bounding boxes
      # to see if they overlap or not
      for box, line in @bounds when line < @bounds.length - 1

        @glue[line] = {
          type: 'normal'
          height: 0
          draw: false
        }

        # We will always have glue spacing at least as big
        # as the biggest child's glue spacing.
        for lineChild in @lineChildren[line]
          childView = @view.getViewNodeFor lineChild.child
          childLine = line - lineChild.startLine

          if childLine of childView.glue
            # Either add padding or not, depending
            # on whether there is an indent between us.
            @glue[line].height = Math.max @glue[line].height, childView.glue[childLine].height

          if childView.carriageArrow isnt CARRIAGE_ARROW_NONE
            @glue[line].height = Math.max @glue[line].height, @view.opts.padding

      # Return the glue we just computed.
      return @glue

  # # ContainerViewNode
  # Class from which `socketView`, `indentView`, `blockView`, and `documentView` extend.
  # Contains function for dealing with multiple children, making polygons to wrap
  # multiple lines, etc.
  class ContainerViewNode extends ListViewNode
    constructor: (@model, @view) ->
      super

      # *Sixth pass variables*
      # computePath
      @group = @view.draw.group('droplet-container-group')

      if @model.type is 'block'
        @path = @view.draw.path([], true, {
          cssClass: 'droplet-block-path'
        })
      else
        @path = @view.draw.path([], false, {
          cssClass: "droplet-#{@model.type}-path"
        })
      @totalBounds = new @view.draw.NoRectangle()

      @path.setParent @group

      # *Seventh pass variables*
      # computeDropAreas
      # each one is a @view.draw.Path (or null)
      @dropPoint = null
      @highlightArea = @view.draw.path([], false, {
        fillColor: '#FF0'
        strokeColor: '#FF0'
        lineWidth: 1
      })
      @highlightArea.deactivate()

      @buttonGroups = {}
      @buttonTexts = {}
      @buttonPaths = {}
      @buttonRects = {}

      if @model.buttons? then for {key, glyph} in @model.buttons
        @buttonGroups[key] = @view.draw.group()
        @buttonPaths[key] = @view.draw.path([
          new @view.draw.Point 0, 0
          new @view.draw.Point @view.opts.buttonWidth, 0
          new @view.draw.Point @view.opts.buttonWidth, @view.opts.buttonHeight
          new @view.draw.Point 0, @view.opts.buttonHeight
        ], false, {
          fillColor: 'none'
          cssClass: 'droplet-button-path'
        })
        ###
          new @view.draw.Point 0, @view.opts.bevelClip
          new @view.draw.Point @view.opts.bevelClip, 0

          new @view.draw.Point @view.opts.buttonWidth - @view.opts.bevelClip, 0
          new @view.draw.Point @view.opts.buttonWidth, @view.opts.bevelClip

          new @view.draw.Point @view.opts.buttonWidth, @view.opts.buttonHeight - @view.opts.bevelClip
          new @view.draw.Point @view.opts.buttonWidth - @view.opts.bevelClip, @view.opts.buttonHeight

          new @view.draw.Point @view.opts.bevelClip, @view.opts.buttonHeight
          new @view.draw.Point 0, @view.opts.buttonHeight - @view.opts.bevelClip
        ###

        @buttonGroups[key].style = {}

        @buttonTexts[key] = @view.draw.text(new @view.draw.Point(
          (@view.opts.buttonWidth - @view.draw.measureCtx.measureText(glyph).width)/ 2,
          (@view.opts.buttonHeight - @view.opts.textHeight) / 2
        ), glyph, if @view.opts.invert then BUTTON_GLYPH_INVERT_COLOR else BUTTON_GLYPH_COLOR)
        @buttonPaths[key].setParent @buttonGroups[key]
        @buttonTexts[key].setParent @buttonGroups[key]

        @buttonGroups[key].setParent @group
        @elements.push @buttonGroups[key]

        @activeElements.push @buttonPaths[key]
        @activeElements.push @buttonTexts[key]
        @activeElements.push @buttonGroups[key]

      @elements.push @group
      @elements.push @path
      @elements.push @highlightArea

    destroy: (root = true) ->
      if root
        for element in @elements
          element?.destroy?()
      else if @highlightArea?
        @highlightArea.destroy()

      for child in @children
        @view.getViewNodeFor(child.child).destroy(false)

    root: ->
      @group.setParent @view.draw.ctx

    # ## draw (GenericViewNode)
    # Call `drawSelf` and recurse, if we are in the viewport.
    draw: (boundingRect, style = {}, parent = null) ->
      if not boundingRect? or @totalBounds.overlap boundingRect
        @drawSelf style, parent

        @group.activate(); @path.activate()

        for element in @activeElements
          element.activate()

        if @highlightArea?
          @highlightArea.setParent @view.draw.ctx

        if parent?
          @group.setParent parent

        for childObj in @children
          @view.getViewNodeFor(childObj.child).draw boundingRect, style, @group

      else
        @group.destroy()
        if @highlightArea?
          @highlightArea.destroy()

    computeCarriageArrow: (root = false) ->
      oldCarriageArrow = @carriageArrow
      @carriageArrow = CARRIAGE_ARROW_NONE

      parent = @model.parent

      if (not root) and parent?.type is 'indent' and @view.hasViewNodeFor(parent) and
          @view.getViewNodeFor(parent).lineLength > 1 and
          @lineLength is 1
        head = @model.start
        until head is parent.start or head.type is 'newline'
          head = head.prev

        if head is parent.start
          if @model.isLastOnLine()
            @carriageArrow = CARRIAGE_ARROW_INDENT
          else
            @carriageArrow = CARRIAGE_GROW_DOWN
        else unless @model.isFirstOnLine()
          @carriageArrow = CARRIAGE_ARROW_SIDEALONG

      if @carriageArrow isnt oldCarriageArrow
        @changedBoundingBox = true

      if @computedVersion is @model.version and
         (not @model.parent? or not @view.hasViewNodeFor(@model.parent) or
         @model.parent.version is @view.getViewNodeFor(@model.parent).computedVersion)
        return null

      super

    computeGlue: ->
      # Use our cache if possible
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return @glue

      super

      for box, line in @bounds when line < @bounds.length - 1
        # Additionally, we add glue spacing padding if we are disconnected
        # from the bounding box on the next line.
        unless @multilineChildrenData[line] is MULTILINE_MIDDLE
          # Find the horizontal overlap between these two bounding rectangles,
          # which is our right edge minus their left, or vice versa.
          overlap = Math.min @bounds[line].right() - @bounds[line + 1].x, @bounds[line + 1].right() - @bounds[line].x

          # If we are starting an indent, then our "bounding box"
          # on the next line is not actually how we will be visualized;
          # instead, we must connect to the small rectangle
          # on the left of a C-shaped indent thing. So,
          # compute overlap with that as well.
          if @multilineChildrenData[line] in [MULTILINE_START, MULTILINE_END_START]
            overlap = Math.min overlap, @bounds[line + 1].x + @view.opts.indentWidth - @bounds[line].x

          # If the overlap is too small, demand glue.
          if overlap < @view.opts.padding and @model.type isnt 'indent'
            @glue[line].height += @view.opts.padding
            @glue[line].draw = true

      return @glue

    computeBevels: ->
      oldBevels = @bevels
      @bevels =
        top: true
        bottom: true

      if (@model.parent?.type in ['indent', 'document']) and
         @model.start.prev?.type is 'newline' and
         @model.start.prev?.prev isnt @model.parent.start
        @bevels.top = false

      if (@model.parent?.type in ['indent', 'document']) and
         @model.end.next?.type is 'newline'
        @bevels.bottom = false

      unless oldBevels.top is @bevels.top and
          oldBevels.bottom is @bevels.bottom
        @changedBoundingBox = true

      if @computedVersion is @model.version
        return null

      super

    # ## computeOwnPath
    # Using bounding box data, compute the polygon
    # that represents us. This contains a lot of special cases
    # for glue and multiline starts and ends.

    computeOwnPath: ->
      # There are four kinds of line,
      # for the purposes of computing the path.
      #
      # 1. Normal block line; we surround the bounding rectangle.
      # 2. Beginning of a multiline block. Avoid that block on the right and bottom.
      # 3. Middle of a multiline block. We avoid to the left side
      # 4. End of a multiline block. We make a G-shape if necessary. If it is an Indent,
      #    this will leave a thick tongue due to things done in dimension
      #    computation.

      # We will keep track of two sets of coordinates,
      # the left side of the polygon and the right side.
      #
      # At the end, we will reverse `left` and concatenate these
      # so as to create a counterclockwise path.
      left = []
      right = []

      # If necessary, add tab
      # at the top.
      if @shouldAddTab() and @model.isFirstOnLine() and
          @carriageArrow isnt CARRIAGE_ARROW_SIDEALONG
        @addTabReverse right, new @view.draw.Point @bounds[0].x + @view.opts.tabOffset, @bounds[0].y

      for bounds, line in @bounds

        # Case 1. Normal rendering.
        if @multilineChildrenData[line] is NO_MULTILINE
          # Draw the left edge of the bounding box.
          left.push new @view.draw.Point bounds.x, bounds.y
          left.push new @view.draw.Point bounds.x, bounds.bottom()

          # Draw the right edge of the bounding box.
          right.push new @view.draw.Point bounds.right(), bounds.y
          right.push new @view.draw.Point bounds.right(), bounds.bottom()

        # Case 2. Start of a multiline block.
        if @multilineChildrenData[line] is MULTILINE_START
          # Draw the left edge of the bounding box.
          left.push new @view.draw.Point bounds.x, bounds.y
          left.push new @view.draw.Point bounds.x, bounds.bottom()

          # Find the multiline child that's starting on this line,
          # so that we can know its bounds
          multilineChild = @lineChildren[line][@lineChildren[line].length - 1]
          multilineView = @view.getViewNodeFor multilineChild.child
          multilineBounds = multilineView.bounds[line - multilineChild.startLine]

          # If the multiline child here is invisible,
          # draw the line just normally.
          if multilineBounds.width is 0
            right.push new @view.draw.Point bounds.right(), bounds.y

          # Otherwise, avoid the block by tracing out its
          # top and left edges, then going to our bound's bottom.
          else
            right.push new @view.draw.Point bounds.right(), bounds.y
            right.push new @view.draw.Point bounds.right(), multilineBounds.y
            if multilineChild.child.type is 'indent'
              @addTab right, new @view.draw.Point multilineBounds.x + @view.opts.tabOffset, multilineBounds.y
            right.push new @view.draw.Point multilineBounds.x, multilineBounds.y
            right.push new @view.draw.Point multilineBounds.x, multilineBounds.bottom()

        # Case 3. Middle of an indent.
        if @multilineChildrenData[line] is MULTILINE_MIDDLE
          multilineChild = @lineChildren[line][0]
          multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

          # Draw the left edge normally.
          left.push new @view.draw.Point bounds.x, bounds.y
          left.push new @view.draw.Point bounds.x, bounds.bottom()

          # Draw the right edge straight down,
          # exactly to the left of the multiline child.
          unless @multilineChildrenData[line - 1] in [MULTILINE_START, MULTILINE_END_START] and
                 multilineChild.child.type is 'indent'
            right.push new @view.draw.Point multilineBounds.x, bounds.y
          right.push new @view.draw.Point multilineBounds.x, bounds.bottom()

        # Case 4. End of an indent.
        if @multilineChildrenData[line] in [MULTILINE_END, MULTILINE_END_START]
          left.push new @view.draw.Point bounds.x, bounds.y
          left.push new @view.draw.Point bounds.x, bounds.bottom()

          # Find the child that is the indent
          multilineChild = @lineChildren[line][0]
          multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

          # Avoid the indented area
          unless @multilineChildrenData[line - 1] in [MULTILINE_START, MULTILINE_END_START] and
                 multilineChild.child.type is 'indent'
            right.push new @view.draw.Point multilineBounds.x, multilineBounds.y
          right.push new @view.draw.Point multilineBounds.x, multilineBounds.bottom()

          if multilineChild.child.type is 'indent'
            @addTabReverse right, new @view.draw.Point multilineBounds.x + @view.opts.tabOffset, multilineBounds.bottom()

          right.push new @view.draw.Point multilineBounds.right(), multilineBounds.bottom()

          # If we must, make the "G"-shape
          if @lineChildren[line].length > 1
            right.push new @view.draw.Point multilineBounds.right(), multilineBounds.y

            if @multilineChildrenData[line] is MULTILINE_END
              right.push new @view.draw.Point bounds.right(), bounds.y
              right.push new @view.draw.Point bounds.right(), bounds.bottom()
            else
              # Find the multiline child that's starting on this line,
              # so that we can know its bounds
              multilineChild = @lineChildren[line][@lineChildren[line].length - 1]
              multilineView = @view.getViewNodeFor multilineChild.child
              multilineBounds = multilineView.bounds[line - multilineChild.startLine]

              # Draw the upper-right corner
              right.push new @view.draw.Point bounds.right(), bounds.y

              # If the multiline child here is invisible,
              # draw the line just normally.
              if multilineBounds.width is 0
                right.push new @view.draw.Point bounds.right(), bounds.y
                right.push new @view.draw.Point bounds.right(), bounds.bottom()

              # Otherwise, avoid the block by tracing out its
              # top and left edges, then going to our bound's bottom.
              else
                right.push new @view.draw.Point bounds.right(), multilineBounds.y
                right.push new @view.draw.Point multilineBounds.x, multilineBounds.y
                right.push new @view.draw.Point multilineBounds.x, multilineBounds.bottom()

          # Otherwise, don't.
          else
            right.push new @view.draw.Point bounds.right(), multilineBounds.bottom()
            right.push new @view.draw.Point bounds.right(), bounds.bottom()

        # "Glue" phase
        # Here we use our glue spacing data
        # to draw glue, if necessary.
        #
        # If we are being told to draw some glue here,
        # do so.
        if line < @lineLength - 1 and line of @glue and @glue[line].draw
          # Extract information from the glue spacing
          # and bounding box data combined.
          #
          # `glueTop` will be the top of the "glue" box.
          # `leftmost` and `rightmost` are the leftmost
          # and rightmost extremes of this and the next line's
          # bounding boxes.
          glueTop = @bounds[line + 1].y - @glue[line].height
          leftmost = Math.min @bounds[line + 1].x, @bounds[line].x
          rightmost = Math.max @bounds[line + 1].right(), @bounds[line].right()

          # Bring the left down to the glue top line, then down to the
          # level of the next line's bounding box. This prepares
          # it to go straight horizontally over
          # to the top of the next bounding box,
          # once the loop reaches that point.
          left.push new @view.draw.Point @bounds[line].x, glueTop
          left.push new @view.draw.Point leftmost, glueTop
          left.push new @view.draw.Point leftmost, glueTop + @view.opts.padding

          # Do the same for the right side, unless we can't
          # because we're avoiding intersections with a multiline child that's
          # in the way.
          unless @multilineChildrenData[line] is MULTILINE_START
            right.push new @view.draw.Point @bounds[line].right(), glueTop
            right.push new @view.draw.Point rightmost, glueTop
            right.push new @view.draw.Point rightmost, glueTop + @view.opts.padding

        # Otherwise, bring us gracefully to the next line
        # without lots of glue (minimize the extra colour).
        else if @bounds[line + 1]? and @multilineChildrenData[line] isnt MULTILINE_MIDDLE
          # Instead of outward extremes, we take inner extremes this time,
          # to minimize extra colour between lines.
          innerLeft = Math.max @bounds[line + 1].x, @bounds[line].x
          innerRight = Math.min @bounds[line + 1].right(), @bounds[line].right()

          # Drop down to the next line on the left, minimizing extra colour
          left.push new @view.draw.Point innerLeft, @bounds[line].bottom()
          left.push new @view.draw.Point innerLeft, @bounds[line + 1].y

          # Do the same on the right, unless we need to avoid
          # a multiline block that's starting here.
          unless @multilineChildrenData[line] in [MULTILINE_START, MULTILINE_END_START]
            right.push new @view.draw.Point innerRight, @bounds[line].bottom()
            right.push new @view.draw.Point innerRight, @bounds[line + 1].y
        else if @carriageArrow is CARRIAGE_GROW_DOWN
          parentViewNode = @view.getViewNodeFor @model.parent
          destinationBounds = parentViewNode.bounds[1]

          right.push new @view.draw.Point @bounds[line].right(), destinationBounds.y - @view.opts.padding
          left.push new @view.draw.Point @bounds[line].x, destinationBounds.y - @view.opts.padding

        else if @carriageArrow is CARRIAGE_ARROW_INDENT
          parentViewNode = @view.getViewNodeFor @model.parent
          destinationBounds = parentViewNode.bounds[1]

          right.push new @view.draw.Point @bounds[line].right(), destinationBounds.y
          right.push new @view.draw.Point destinationBounds.x + @view.opts.tabOffset + @view.opts.tabWidth, destinationBounds.y

          left.push new @view.draw.Point @bounds[line].x, destinationBounds.y - @view.opts.padding
          left.push new @view.draw.Point destinationBounds.x, destinationBounds.y - @view.opts.padding
          left.push new @view.draw.Point destinationBounds.x, destinationBounds.y

          @addTab right, new @view.draw.Point destinationBounds.x + @view.opts.tabOffset, destinationBounds.y
        else if @carriageArrow is CARRIAGE_ARROW_SIDEALONG and @model.isLastOnLine()
          parentViewNode = @view.getViewNodeFor @model.parent
          destinationBounds = parentViewNode.bounds[@model.getLinesToParent()]

          right.push new @view.draw.Point @bounds[line].right(), destinationBounds.bottom() + @view.opts.padding
          right.push new @view.draw.Point destinationBounds.x + @view.opts.tabOffset + @view.opts.tabWidth,
            destinationBounds.bottom() + @view.opts.padding

          left.push new @view.draw.Point @bounds[line].x, destinationBounds.bottom()
          left.push new @view.draw.Point destinationBounds.x, destinationBounds.bottom()
          left.push new @view.draw.Point destinationBounds.x, destinationBounds.bottom() + @view.opts.padding

          @addTab right, new @view.draw.Point destinationBounds.x + @view.opts.tabOffset,
            destinationBounds.bottom() + @view.opts.padding

        # If we're avoiding intersections with a multiline child in the way,
        # bring us gracefully to the next line's top. We had to keep avoiding
        # using bounding box right-edge data earlier, because it would have overlapped;
        # instead, we want to use the left edge of the multiline block that's
        # starting here.
        if @multilineChildrenData[line] in [MULTILINE_START, MULTILINE_END_START]
          multilineChild = @lineChildren[line][@lineChildren[line].length - 1]
          multilineNode = @view.getViewNodeFor multilineChild.child
          multilineBounds = multilineNode.bounds[line - multilineChild.startLine]

          if @glue[line]?.draw
            glueTop = @bounds[line + 1].y - @glue[line].height + @view.opts.padding
          else
            glueTop = @bounds[line].bottom()

          # Special case for indents that start with newlines;
          # don't do any of the same-line-start multiline stuff.
          if multilineChild.child.type is 'indent' and multilineChild.child.start.next.type is 'newline'
              right.push new @view.draw.Point @bounds[line].right(), glueTop

              @addTab right, new @view.draw.Point(@bounds[line + 1].x +
                @view.opts.indentWidth +
                @extraLeft +
                @view.opts.tabOffset, glueTop), true
          else
            right.push new @view.draw.Point multilineBounds.x, glueTop

          unless glueTop is @bounds[line + 1].y
            right.push new @view.draw.Point multilineNode.bounds[line - multilineChild.startLine + 1].x, glueTop
          right.push new @view.draw.Point multilineNode.bounds[line - multilineChild.startLine + 1].x, @bounds[line + 1].y

      # If necessary, add tab
      # at the bottom.
      if @shouldAddTab() and @model.isLastOnLine() and
            @carriageArrow is CARRIAGE_ARROW_NONE
          @addTab right, new @view.draw.Point @bounds[@lineLength - 1].x + @view.opts.tabOffset,
            @bounds[@lineLength - 1].bottom()

      topLeftPoint = left[0]

      # Reverse the left and concatenate it with the right
      # to make a counterclockwise path
      path = dedupe left.reverse().concat right

      newPath = []

      for point, i in path
        if i is 0 and not @bevels.bottom
          newPath.push point
          continue

        if (not @bevels.top) and point.almostEquals(topLeftPoint)
          newPath.push point
          continue

        next = path[(i + 1) %% path.length]
        prev = path[(i - 1) %% path.length]

        if (point.x is next.x) isnt (point.y is next.y) and
           (point.x is prev.x) isnt (point.y is prev.y) and
           point.from(prev).magnitude() >= @view.opts.bevelClip * 2 and
           point.from(next).magnitude() >= @view.opts.bevelClip * 2
          newPath.push point.plus(point.from(prev).toMagnitude(-@view.opts.bevelClip))
          newPath.push point.plus(point.from(next).toMagnitude(-@view.opts.bevelClip))
        else
          newPath.push point

      # Make a Path object out of these points
      @path.setPoints newPath
      if @model.type is 'block'
        @path.style.fillColor = @view.getColor @model.color

      if @model.buttons? and @model.type is 'lockedSocket'
        # Add the add button if necessary
        firstRect = @bounds[0]

        start = firstRect.x

        top = firstRect.y + firstRect.height / 2 - @view.opts.buttonHeight / 2

        for {key} in @model.buttons

          @buttonGroups[key].style.transform = "translate(#{start}, #{top})"
          @buttonGroups[key].update()
          @buttonPaths[key].update()
          @buttonRects[key] = new @view.draw.Rectangle start, top, @view.opts.buttonWidth, @view.opts.buttonHeight

          @elements.push @buttonPaths[key]

          start += @view.opts.buttonWidth + @view.opts.buttonHorizPadding

      else if @model.buttons?
        # Add the add button if necessary
        lastLine = @bounds.length - 1
        lastRect = @bounds[lastLine]

        if @model.type is 'block'
          start = lastRect.x + lastRect.width - @extraWidth - @view.opts.buttonHorizPadding
        else
          start = lastRect.x + lastRect.width - @extraWidth + @view.opts.buttonHorizPadding

        top = lastRect.y + lastRect.height / 2 - @view.opts.buttonHeight / 2

        for {key} in @model.buttons

          # Cases when last line is MULTILINE
          if @multilineChildrenData[lastLine] is MULTILINE_END
            multilineChild = @lineChildren[lastLine][0]
            multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[lastLine - multilineChild.startLine]
            # If it is a G-Shape
            if @lineChildren[lastLine].length > 1
              height = multilineBounds.bottom() - lastRect.y
              top = lastRect.y + height / 2 - @view.opts.buttonHeight/2
            else
              height = lastRect.bottom() - multilineBounds.bottom()
              top = multilineBounds.bottom() + height/2 - @view.opts.buttonHeight/2

          @buttonGroups[key].style.transform = "translate(#{start}, #{top})"
          @buttonGroups[key].update()
          @buttonPaths[key].update()
          @buttonRects[key] = new @view.draw.Rectangle start, top, @view.opts.buttonWidth, @view.opts.buttonHeight

          @elements.push @buttonPaths[key]

          start += @view.opts.buttonWidth + @view.opts.buttonHorizPadding

      # Return it.
      return @path

    # ## addTab
    # Add the tab graphic to a path in a given location.
    addTab: (array, point) ->
      # Rightmost point of the tab, where it begins to dip down.
      array.push new @view.draw.Point(point.x + @view.opts.tabWidth,
        point.y)
      # Dip down.
      array.push new @view.draw.Point point.x +  @view.opts.tabWidth * (1 - @view.opts.tabSideWidth),
        point.y + @view.opts.tabHeight
      # Bottom plateau.
      array.push new @view.draw.Point point.x + @view.opts.tabWidth * @view.opts.tabSideWidth,
        point.y + @view.opts.tabHeight
      # Rise back up.
      array.push new @view.draw.Point point.x, point.y
      # Move over to the given corner itself.
      array.push point

    # ## addTabReverse
    # Add the tab in reverse order
    addTabReverse: (array, point) ->
      array.push point
      array.push new @view.draw.Point point.x, point.y
      array.push new @view.draw.Point point.x + @view.opts.tabWidth * @view.opts.tabSideWidth,
        point.y + @view.opts.tabHeight
      array.push new @view.draw.Point point.x +  @view.opts.tabWidth * (1 - @view.opts.tabSideWidth),
        point.y + @view.opts.tabHeight
      array.push new @view.draw.Point(point.x + @view.opts.tabWidth,
        point.y)

    mark: (style) ->
      @view.registerMark @model.id
      @markStyle = style
      @focusAll()

    unmark: -> @markStyle = null

    # ## drawSelf
    # Draw our path, with applied
    # styles if necessary.
    drawSelf: (style = {}) ->
      # We might want to apply some
      # temporary color changes,
      # so store the old colors
      oldFill = @path.style.fillColor
      oldStroke = @path.style.strokeColor

      if style.grayscale
        # Change path color
        if @path.style.fillColor isnt 'none'
          @path.style.fillColor = avgColor @path.style.fillColor, 0.5, '#888'
        if @path.style.strokeColor isnt 'none'
          @path.style.strokeColor = avgColor @path.style.strokeColor, 0.5, '#888'

      if style.selected
        # Change path color
        if @path.style.fillColor isnt 'none'
          @path.style.fillColor = avgColor @path.style.fillColor, 0.7, '#00F'
        if @path.style.strokeColor isnt 'none'
          @path.style.strokeColor = avgColor @path.style.strokeColor, 0.7, '#00F'

      @path.setMarkStyle @markStyle

      @path.update()
      if @model.buttons? then for {key} in @model.buttons
        @buttonPaths[key].update()
        @buttonGroups[key].update()

        for element in [@buttonPaths[key], @buttonGroups[key], @buttonTexts[key]]
          unless element in @activeElements # TODO unlikely but might be performance chokehold?
            @activeElements.push element    # Possibly replace activeElements with a more set-like structure.

      # Unset all the things we changed
      @path.style.fillColor = oldFill
      @path.style.strokeColor = oldStroke

      if @model.buttons? then for {key} in @model.buttons
        if @buttonPaths[key].active
          @buttonPaths[key].style.fillColor = oldFill
          @buttonPaths[key].style.strokeColor = oldStroke

      return null

    # ## computeOwnDropArea
    # By default, we will not have a
    # drop area (not be droppable).
    computeOwnDropArea: ->
      @dropPoint = null
      if @highlightArea?
        @elements = @elements.filter (x) -> x isnt @highlightArea
        @highlightArea.destroy()
        @highlightArea = null

    # ## shouldAddTab
    # By default, we will ask
    # not to have a tab.
    shouldAddTab: NO

  # # BlockViewNode
  class BlockViewNode extends ContainerViewNode
    constructor: ->
      super

    computeMinDimensions: ->
      if @computedVersion is @model.version
        return null

      super

      # Blocks have a shape including a lego nubby "tab", and so
      # they need to be at least wide enough for tabWidth+tabOffset.
      for size, i in @minDimensions
        size.width = Math.max size.width,
            @view.opts.tabWidth + @view.opts.tabOffset
        size.width += @extraLeft

      return null

    shouldAddTab: ->
      if @model.parent? and @view.hasViewNodeFor(@model.parent) and not
         (@model.parent.type is 'document' and @model.parent.opts.roundedSingletons and
          @model.start.prev is @model.parent.start and @model.end.next is @model.parent.end)
        return @model.parent?.type isnt 'socket'
      else
        return not (@model.shape in [helper.MOSTLY_VALUE, helper.VALUE_ONLY])

    computeOwnDropArea: ->
      unless @model.parent?.type in ['indent', 'document']
        @dropPoint = null
        return

      # Our drop area is a puzzle-piece shaped path
      # of height opts.highlightAreaHeight and width
      # equal to our last line width,
      # positioned at the bottom of our last line.
      if @carriageArrow is CARRIAGE_ARROW_INDENT
        parentViewNode = @view.getViewNodeFor @model.parent
        destinationBounds = parentViewNode.bounds[1]

        @dropPoint = new @view.draw.Point destinationBounds.x, destinationBounds.y
        lastBoundsLeft = destinationBounds.x
        lastBoundsRight = destinationBounds.right()
      else if @carriageArrow is CARRIAGE_ARROW_SIDEALONG
        parentViewNode = @view.getViewNodeFor @model.parent
        destinationBounds = parentViewNode.bounds[1]

        @dropPoint = new @view.draw.Point destinationBounds.x,
          @bounds[@lineLength - 1].bottom() + @view.opts.padding
        lastBoundsLeft = destinationBounds.x
        lastBoundsRight = @bounds[@lineLength - 1].right()
      else
        @dropPoint = new @view.draw.Point @bounds[@lineLength - 1].x, @bounds[@lineLength - 1].bottom()
        lastBoundsLeft = @bounds[@lineLength - 1].x
        lastBoundsRight = @bounds[@lineLength - 1].right()

      # Our highlight area is the a rectangle in the same place,
      # with a height that can be given by a different option.

      highlightAreaPoints = []

      highlightAreaPoints.push new @view.draw.Point lastBoundsLeft, @dropPoint.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBoundsLeft + @view.opts.bevelClip, @dropPoint.y - @view.opts.highlightAreaHeight / 2

      @addTabReverse highlightAreaPoints, new @view.draw.Point lastBoundsLeft + @view.opts.tabOffset, @dropPoint.y - @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBoundsRight - @view.opts.bevelClip, @dropPoint.y - @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBoundsRight, @dropPoint.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip

      highlightAreaPoints.push new @view.draw.Point lastBoundsRight, @dropPoint.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBoundsRight - @view.opts.bevelClip, @dropPoint.y + @view.opts.highlightAreaHeight / 2

      @addTab highlightAreaPoints, new @view.draw.Point lastBoundsLeft + @view.opts.tabOffset, @dropPoint.y + @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBoundsLeft + @view.opts.bevelClip, @dropPoint.y + @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBoundsLeft, @dropPoint.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip

      @highlightArea.setPoints highlightAreaPoints
      @highlightArea.deactivate()

  # # SocketViewNode
  class SocketViewNode extends ContainerViewNode
    constructor: ->
      super
      if @view.opts.showDropdowns and @model.dropdown?
        @dropdownElement ?= @view.draw.path([], false, {
          fillColor: (if @view.opts.invert then DROP_TRIANGLE_INVERT_COLOR else DROP_TRIANGLE_COLOR),
          cssClass: 'droplet-dropdown-arrow'
        })
        @dropdownElement.deactivate()

        @dropdownElement.setParent @group

        @elements.push @dropdownElement
        @activeElements.push @dropdownElement

    shouldAddTab: NO

    isInvisibleSocket: ->
      '' is @model.emptyString and @model.start?.next is @model.end

    # ## computeDimensions (SocketViewNode)
    # Sockets have a couple exceptions to normal dimension computation.
    #
    # 1. Sockets have minimum dimensions even if empty.
    # 2. Sockets containing blocks mimic the block exactly.
    computeMinDimensions: ->
      # Use cache if possible.
      if @computedVersion is @model.version
        return null

      super

      @minDistanceToBase[0].above = Math.max(@minDistanceToBase[0].above,
          @view.opts.textHeight + @view.opts.textPadding)
      @minDistanceToBase[0].below = Math.max(@minDistanceToBase[0].below,
          @view.opts.textPadding)

      @minDimensions[0].height =
          @minDistanceToBase[0].above + @minDistanceToBase[0].below

      for dimension in @minDimensions
        dimension.width = Math.max(dimension.width,
          if @isInvisibleSocket()
            @view.opts.invisibleSocketWidth
          else
            @view.opts.minSocketWidth)

        if @model.hasDropdown() and @view.opts.showDropdowns
          dimension.width += helper.DROPDOWN_ARROW_WIDTH

      return null

    # ## computeBoundingBoxX (SocketViewNode)
    computeBoundingBoxX: (left, line) ->
      super left, line, (
        if @model.hasDropdown() and @view.opts.showDropdowns
          helper.DROPDOWN_ARROW_WIDTH
        else 0
      )

    # ## computeGlue
    # Sockets have one exception to normal glue spacing computation:
    # sockets containing a block should **not** add padding to
    # the glue.
    computeGlue: ->
      # Use cache if possible
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return @glue

      # Do not add padding to the glue
      # if our child is a block.
      if @model.start.next.type is 'blockStart'
        view = @view.getViewNodeFor @model.start.next.container
        @glue = view.computeGlue()

      # Otherwise, decrement the glue version
      # to force super to recompute,
      # and call super.
      else
        super

    # ## computeOwnPath (SocketViewNode)
    # Again, exception: sockets containing block
    # should mimic blocks exactly.
    #
    # Under normal circumstances this shouldn't
    # actually be an issue, but if we decide
    # to change the Block's path,
    # the socket should not have stuff sticking out,
    # and should hit-test properly.
    computeOwnPath: ->
      # Use cache if possible.
      if @computedVersion is @model.version and
          not @changedBoundingBox
        return @path

      @path.style.fillColor = if @view.opts.invert then '#333' else '#FFF'

      if @model.start.next.type is 'blockStart'
        @path.style.fillColor = 'none'

      # Otherwise, call super.
      else
        super

      # If the socket is empty, make it invisible except
      # for mouseover
      if '' is @model.emptyString and @model.start?.next is @model.end
        @path.style.cssClass = 'droplet-socket-path droplet-empty-socket-path'
        @path.style.fillColor = 'none'
      else
        @path.style.cssClass = 'droplet-socket-path'

      return @path

    # ## drawSelf (SocketViewNode)
    drawSelf: (style = {}) ->
      super

      if @model.hasDropdown() and @view.opts.showDropdowns
        @dropdownElement.setPoints([new @view.draw.Point(@bounds[0].x + helper.DROPDOWN_ARROW_PADDING,
            @bounds[0].y + (@bounds[0].height - DROPDOWN_ARROW_HEIGHT) / 2),
          new @view.draw.Point(@bounds[0].x + helper.DROPDOWN_ARROW_WIDTH - helper.DROPDOWN_ARROW_PADDING,
            @bounds[0].y + (@bounds[0].height - DROPDOWN_ARROW_HEIGHT) / 2),
          new @view.draw.Point(@bounds[0].x + helper.DROPDOWN_ARROW_WIDTH / 2,
            @bounds[0].y + (@bounds[0].height + DROPDOWN_ARROW_HEIGHT) / 2)
        ])
        @dropdownElement.update()

        unless @dropdownElement in @activeElements
          @activeElements.push @dropdownElement

      else if @dropdownElement?
        @activeElements = @activeElements.filter (x) -> x isnt @dropdownElement
        @dropdownElement.deactivate()

    # ## computeOwnDropArea (SocketViewNode)
    # Socket drop areas are actually the same
    # shape as the sockets themselves, which
    # is different from most other
    # things.
    computeOwnDropArea: ->
      if @model.start.next.type is 'blockStart'
        @dropPoint = null
        @highlightArea.deactivate()
      else
        @dropPoint = @bounds[0].upperLeftCorner()
        @highlightArea.setPoints @path._points
        @highlightArea.style.strokeColor = '#FF0'
        @highlightArea.style.fillColor = 'none'
        @highlightArea.style.lineWidth = @view.opts.highlightAreaHeight / 2
        @highlightArea.update()
        @highlightArea.deactivate()

  # # IndentViewNode
  class IndentViewNode extends ContainerViewNode
    constructor: ->
      super
      @lastFirstChildren = []
      @lastLastChildren = []

    # ## computeOwnPath
    # An Indent should also have no drawn
    # or hit-tested path.
    computeOwnPath: ->

    # ## computeChildren
    computeChildren: ->
      super

      unless arrayEq(@lineChildren[0], @lastFirstChildren) and
             arrayEq(@lineChildren[@lineLength - 1], @lastLastChildren)
        for childObj in @children
          childView = @view.getViewNodeFor childObj.child

          if childView.topLineSticksToBottom or childView.bottomLineSticksToTop
            childView.invalidate = true
          if childView.lineLength is 1
            childView.topLineSticksToBottom =
              childView.bottomLineSticksToTop = false

      for childRef in @lineChildren[0]
        childView = @view.getViewNodeFor(childRef.child)
        unless childView.topLineSticksToBottom
          childView.invalidate = true
        childView.topLineSticksToBottom = true
      for childRef in @lineChildren[@lineChildren.length - 1]
        childView = @view.getViewNodeFor(childRef.child)
        unless childView.bottomLineSticksToTop
          childView.invalidate = true
        childView.bottomLineSticksToTop = true

      return @lineLength


    # ## computeDimensions (IndentViewNode)
    #
    # Give width to any empty lines
    # in the Indent.
    computeMinDimensions: ->
      super

      for size, line in @minDimensions[1..] when size.width is 0
        size.width = @view.opts.emptyLineWidth

    # ## drawSelf
    #
    # Again, an Indent should draw nothing.
    drawSelf: ->

    # ## computeOwnDropArea
    #
    # Our drop area is a rectangle of
    # height dropAreaHeight and a width
    # equal to our first line width,
    # positioned at the top of our firs tline
    computeOwnDropArea: ->
      lastBounds = new @view.draw.NoRectangle()
      if @model.start.next.type is 'newline'
        @dropPoint = @bounds[1].upperLeftCorner()
        lastBounds.copy @bounds[1]
      else
        @dropPoint = @bounds[0].upperLeftCorner()
        lastBounds.copy @bounds[0]
      lastBounds.width = Math.max lastBounds.width, @view.opts.indentDropAreaMinWidth

      # Our highlight area is the a rectangle in the same place,
      # with a height that can be given by a different option.

      highlightAreaPoints = []

      highlightAreaPoints.push new @view.draw.Point lastBounds.x, lastBounds.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBounds.x + @view.opts.bevelClip, lastBounds.y - @view.opts.highlightAreaHeight / 2

      @addTabReverse highlightAreaPoints, new @view.draw.Point lastBounds.x + @view.opts.tabOffset, lastBounds.y - @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBounds.right() - @view.opts.bevelClip, lastBounds.y - @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBounds.right(), lastBounds.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip

      highlightAreaPoints.push new @view.draw.Point lastBounds.right(), lastBounds.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBounds.right() - @view.opts.bevelClip, lastBounds.y + @view.opts.highlightAreaHeight / 2

      @addTab highlightAreaPoints, new @view.draw.Point lastBounds.x + @view.opts.tabOffset, lastBounds.y + @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBounds.x + @view.opts.bevelClip, lastBounds.y + @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBounds.x, lastBounds.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip

      @highlightArea.setPoints highlightAreaPoints
      @highlightArea.deactivate()


  # # DocumentViewNode
  # Represents a Document. Draws little, but
  # recurses.
  class DocumentViewNode extends ContainerViewNode
    constructor: -> super

    # ## computeOwnPath
    #
    computeOwnPath: ->

    # ## computeOwnDropArea
    #
    # Root documents
    # can be dropped at their beginning.
    computeOwnDropArea: ->
      @dropPoint = @bounds[0].upperLeftCorner()

      highlightAreaPoints = []

      lastBounds = new @view.draw.NoRectangle()
      lastBounds.copy @bounds[0]
      lastBounds.width = Math.max lastBounds.width, @view.opts.indentDropAreaMinWidth

      highlightAreaPoints.push new @view.draw.Point lastBounds.x, lastBounds.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBounds.x + @view.opts.bevelClip, lastBounds.y - @view.opts.highlightAreaHeight / 2

      @addTabReverse highlightAreaPoints, new @view.draw.Point lastBounds.x + @view.opts.tabOffset, lastBounds.y - @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBounds.right() - @view.opts.bevelClip, lastBounds.y - @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBounds.right(), lastBounds.y - @view.opts.highlightAreaHeight / 2 + @view.opts.bevelClip

      highlightAreaPoints.push new @view.draw.Point lastBounds.right(), lastBounds.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip
      highlightAreaPoints.push new @view.draw.Point lastBounds.right() - @view.opts.bevelClip, lastBounds.y + @view.opts.highlightAreaHeight / 2

      @addTab highlightAreaPoints, new @view.draw.Point lastBounds.x + @view.opts.tabOffset, lastBounds.y + @view.opts.highlightAreaHeight / 2

      highlightAreaPoints.push new @view.draw.Point lastBounds.x + @view.opts.bevelClip, lastBounds.y + @view.opts.highlightAreaHeight / 2
      highlightAreaPoints.push new @view.draw.Point lastBounds.x, lastBounds.y + @view.opts.highlightAreaHeight / 2 - @view.opts.bevelClip

      @highlightArea.setPoints highlightAreaPoints
      @highlightArea.deactivate()

      return null

  # # TextViewNode
  #
  # TextViewNode does not extend ContainerViewNode.
  # We contain a @view.draw.TextElement to measure
  # bounding boxes and draw text.
  class TextViewNode extends GenericViewNode
    constructor: (@model, @view) ->
      super
      @textElement = @view.draw.text(
        new @view.draw.Point(0, 0),
        @model.value,
        if @view.opts.invert then '#FFF' else '#000'
      )
      @textElement.destroy()
      @elements.push @textElement

    # ## computeChildren
    #
    # Text elements are one line
    # and contain no children (and thus
    # no multiline children, either)
    computeChildren: ->
      @multilineChildrenData = [NO_MULTILINE]
      return @lineLength = 1

    # ## computeMinDimensions (TextViewNode)
    #
    # Set our dimensions to the measured dimensinos
    # of our text value.
    computeMinDimensions: ->
      if @computedVersion is @model.version
        return null

      @textElement.point = new @view.draw.Point 0, 0
      @textElement.value = @model.value

      height = @view.opts.textHeight
      @minDimensions[0] = new @view.draw.Size(@textElement.bounds().width, height)
      @minDistanceToBase[0] = {above: height, below: 0}

      return null

    # ## computeBoundingBox (x and y)
    #
    # Assign the position of our textElement
    # to match our laid out bounding box position.
    computeBoundingBoxX: (left, line) ->
      @textElement.point.x = left; super

    computeBoundingBoxY: (top, line) ->
      @textElement.point.y = top; super

    # ## drawSelf
    #
    # Draw the text element itself.
    drawSelf: (style = {}, parent = null) ->
      @textElement.update()
      if style.noText
        @textElement.deactivate()
      else
        @textElement.activate()

      if parent?
        @textElement.setParent parent

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

avgColor = (a, factor, b) ->
  a = toRGB a
  b = toRGB b

  newRGB = (a[i] * factor + b[i] * (1 - factor) for k, i in a)

  return toHex newRGB

dedupe = (path) ->
  path = path.filter((x, i) ->
    not x.equals(path[(i - 1) %% path.length])
  )

  path = path.filter((x, i) ->
    not draw._collinear(path[(i - 1) %% path.length], x, path[(i + 1) %% path.length])
  )

  return path
