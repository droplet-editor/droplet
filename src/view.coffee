# # ICE Editor view
#
# Copyright (c) 2014 Anthony Bau
# MIT License

define ['ice-draw', 'ice-model'], (draw, model) ->
  NO_MULTILINE = 0
  MULTILINE_START = 1
  MULTILINE_MIDDLE = 2
  MULTILINE_END = 3

  DEFAULT_OPTIONS =
    padding: 5
    indentWidth: 10
    indentTongueHeight: 10
    tabOffset: 10
    tabWidth: 15
    tabHeight: 5
    tabSideWidth: 0.125
    dropAreaHeight: 20
    indentDropAreaMinWidth: 50
    emptySocketWidth: 20
    emptySocketHeight: 25
    emptyLineHeight: 25
    emptyLineWidth: 50
    highlightAreaHeight: 10
    shadowBlur: 5
    ctx: document.createElement('canvas').getContext('2d')

  YES = -> yes
  NO = -> no

  exports = {}

  defaultStyleObject = -> {selected: 0, grayscale: 0}

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
    constructor: (@opts = {}) ->
      # @map maps Model objects
      # to corresponding View objects,
      # so that rerendering the same model
      # can be fast
      @map = {}
      
      # Apply default options
      for option of DEFAULT_OPTIONS
        unless option of @opts
          @opts[option] = DEFAULT_OPTIONS[option]

      # Do our measurement hack
      draw._setCTX @opts.ctx

    # Simple method for clearing caches
    clearCache: -> @map = {}

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

    # ## createView
    # Given a model object, create a renderer object
    # of the appropriate type.
    createView: (model) ->
      switch model.type
        when 'text' then new TextViewNode model, this
        when 'block' then new BlockViewNode model, this
        when 'indent' then new IndentViewNode model, this
        when 'socket' then new SocketViewNode model, this
        when 'segment' then new SegmentViewNode model, this
        when 'cursor' then new CursorViewNode model, this

    # # GenericViewNode
    # Class from which all renderer classes will
    # extend.
    class GenericViewNode
      constructor: (@model, @view) ->
        # Record ourselves in the map
        # from model to renderer
        @view.map[@model.id] = this

        # *Zeroth pass variables*
        # computeChildren
        @lineLength = 0 # How many lines does this take up?
        @children = [] # All children, flat
        @lineChildren = [] # Children who own each line
        @multilineChildrenData = [] # Where do indents start/end?

        # *First pass variables*
        # computeMargins
        @margins = {left:0, right:0, top:0, bottom:0}

        # *Second pass variables*
        # computeDimensions
        # draw.Size type, {width:n, height:m}
        @dimensions = [] # Dimensions on each line
        @distanceToBase = [] # {above:n, below:n}

        # *Third/fifth pass variables*
        # computeBoundingBoxX, computeBoundingBoxY
        # draw.Rectangle type, {x:0, y:0, width:200, height:100}
        @bounds = [] # Bounding boxes on each line
        @boundingBoxFlag = true # Did any bounding boxes change just now?

        # *Fourth pass variables*
        # computeGlue
        # {height:2, draw:true}
        @glue = {}

        # *Sixth pass variables*
        # computePath
        @path = new draw.Path()

        # *Seventh pass variables*
        # computeDropAreas
        # each one is a draw.Path (or null)
        @dropArea = @highlightArea = null

        # Versions. The corresponding
        # Model will keep corresponding version
        # numbers, and each of our passes can
        # become a no-op when we are up-to-date (so
        # that rerendering is fast when there are
        # few or no changes to the Model).
        @computedVersion = -1

        # TODO: remove
        @padding = @view.opts.padding

      # ## computeChildren
      # Find out which of our children lie on each line that we
      # own, and also how many lines we own.
      #
      # Return the number of lines we own.
      #
      # This is basically a void computeChildren that should be
      # overridden.
      computeChildren: -> @lineLength

      # ## computeMargins
      # Compute the amount of margin required outside the child
      # on the top, bottom, left, and right.
      #
      # This is a void computeMargins that should be overridden.
      computeMargins: ->
        if @computedVersion is @model.version
          return @margins
        # the margins I need depend on the type of my parent
        parenttype = @model.parent?.type
        padding = @view.opts.padding
        if parenttype is 'block' and @model.type is 'indent'
          @margins =
            top: padding
            bottom: @view.opts.indentTongueHeight
            
            firstLeft: 0
            midLeft: @view.opts.indentWidth + @view.opts.padding
            lastLeft: @view.opts.indentWidth + @view.opts.padding

            firstRight: 0
            midRight: 0
            lastRight: padding

        else if parenttype is 'block' or (
            parenttype is 'socket' and @model.type is 'text')
          @margins =
            top: padding
            bottom: padding

            firstLeft: padding
            midLeft: padding
            lastLeft: padding

            firstRight: padding
            midRight: padding
            lastRight: padding
        else
          @margins = {
            firstLeft: 0, midLeft:0, lastLeft: 0
            firstRight: 0, midRight:0, lastRight: 0
            top:0, bottom:0
          }

        for childObj in @children
          @view.getViewNodeFor(childObj.child).computeMargins()

        return null
      
      getMargins: (line) ->
        margins =
          left: @margins.midLeft
          right: @margins.midRight
          top: 0
          bottom: 0

        if line is 0
          margins.top = @margins.top
          margins.left = @margins.firstLeft
          margins.right = @margins.firstRight

        if line is @lineLength - 1
          margins.bottom = @margins.bottom
          margins.left = @margins.lastLeft
          margins.right = @margins.lastRight

        return margins

      # ## computeDimensions
      # Compute the size of our bounding box on each
      # line that we contain.
      #
      # Return child node.
      #
      # This is a void computeDimensinos that should be overridden.
      computeDimensions: ->
        @dimensions[0] = new draw.Size 0, 0
        @distanceToBase[0] = {above:0, below:0}
        return null


      # ## computeBoundingBoxX
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
           left is @bounds[line]?.x
          return @bounds[line]

        # Avoid re-instantiating a Rectangle object,
        # if possible.
        if @bounds[line]?
          @bounds[line].x = left
          @bounds[line].width = @dimensions[line].width

        # If not, create one.
        else
          @bounds[line] = new draw.Rectangle(
            left, 0
            @dimensions[line].width, 0
          )

        return @bounds[line]

      # ## computeAllBoundingBoxX
      # Call `@computeBoundingBoxX` on all lines,
      # thus laying out the entire document horizontally.
      computeAllBoundingBoxX: (left = 0) ->
        for size, line in @dimensions
          @computeBoundingBoxX left, line

        return @bounds

      # ## computeGlue
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
      computeGlue: -> @glue = {}

      # ## computeBoundingBoxY
      # Like computeBoundingBoxX. We must separate
      # these passes because glue spacers from `computeGlue`
      # affect computeBoundingBoxY.
      computeBoundingBoxY: (top, line) ->
        # Again, we need to check to make sure that the coordinate
        # we are given matches, since we cannot only rely on
        # versioning (see computeBoundingBoxX).
        if @computedVersion is @model.version and
           top is @bounds[line]?.y
          return @bounds[line]

        # Accept the bounding box edge we were given.
        # We assume here that computeBoundingBoxX was
        # already run for this version, so we
        # should be guaranteed that `@bounds[line]` exists.
        @bounds[line].y = top
        @bounds[line].height = @dimensions[line].height

        return @bounds[line]

      # ## computeAllBoundingBoxY
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

      # ## getBounds
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
      computeOwnPath: -> @path = new draw.Path()

      # ## computePath
      # Call `@computeOwnPath` and recurse. This function
      # should never need to be overridden; override `@computeOwnPath`
      # instead.
      computePath: ->
        # Here, we cannot just rely on versioning either.
        # We need to know if any bounding box data changed. So,
        # look at `@boundingBoxFlag`, which should be set
        # to `true` whenever a bounding box changed on the bounding box
        # passes.
        if @computedVersion is @model.version and
             not @boundingBoxFlag
          return null

        # It is possible that we have a version increment
        # without changing bounding boxes. If this is the case,
        # we don't need to recompute our own path.
        if @boundingBoxFlag
          @computeOwnPath()

          # Recompute `totalBounds`, which is used
          # to avoid re*drawing* polygons that
          # are not on-screen. `totalBounds` is the AABB
          # of the everything that has to do with the element,
          # and we redraw iff it overlaps the AABB of the viewport.
          @totalBounds = new draw.NoRectangle()
          @totalBounds.unite bound for bound in @bounds
          @totalBounds.unite @path.bounds()

        # Recurse.
        for childObj in @children
          @view.getViewNodeFor(childObj.child).computePath()

        return null

      # ## computeOwnDropArea
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

      # ## computeDropAreas
      # Call `@computeOwnDropArea`, and recurse.
      #
      # This should never have to be overridden;
      # override `@computeOwnDropArea` instead.
      computeDropAreas: ->
        # Like with `@computePath`, we cannot rely solely on versioning,
        # so we check the bounding box flag.
        if @computedVersion is @model.version and
            not @boundingBoxFlag
          return null

        # Compute drop and highlight areas for ourself
        @computeOwnDropArea()

        # Recurse.
        for childObj in @children
          @view.getViewNodeFor(childObj.child).computeDropAreas()

        return null

      computeNewVersionNumber: ->
        if @computedVersion is @model.version and
            not @boundingBoxFlag
          return null

        @boundingBoxFlag = false
        @computedVersion = @model.version

        # Recurse.
        for childObj in @children
          @view.getViewNodeFor(childObj.child).computeNewVersionNumber()

        return null


      # ## drawSelf
      # Draw our own polygon on a canvas context.
      # May require special effects, like graying-out
      # or blueing for lasso select.
      drawSelf: (ctx, style) ->

      # ## draw
      # Call `drawSelf` and recurse, if we are in the viewport.
      draw: (ctx, boundingRect, style) ->
        # First, test to see whether our AABB overlaps
        # with the viewport
        if @totalBounds.overlap boundingRect
          # If it does, we want to render. If we are the root
          # (and have not been passed a style object), create
          # a style object. This includes things like graying-out
          # and blueing.
          style ?= defaultStyleObject()

          # The ephemeral flag is set when a block is being dragged
          # somewhere else at the moment. If we are a model
          # that wants to gray something out in this situation,
          # do so.
          if @model.ephemeral and @view.opts.respectEphemeral
            style.grayscale++

          # Call `@drawSelf`
          @drawSelf ctx, style

          # Draw our children. We will want to draw blocks with line marks
          # last, so that they appear on top, so we will abstain from them
          # for now.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) is 0
            @view.getViewNodeFor(childObj.child).draw ctx, boundingRect, style

          # Draw marked blocks.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) > 0
            @view.getViewNodeFor(childObj.child).draw ctx, boundingRect, style

          # Decrement our grayscale if necessary
          if @model.ephemeral and @view.opts.respectEphemeral
            style.grayscale--

        return null

      # ## drawShadow
      # Draw the shadow of our path
      # on a canvas context. Used
      # for drop shadow when dragging.
      drawShadow: (ctx) ->

      # ## Debug output

      # ### debugDimensions
      # A super-simplified bounding box algorithm
      # made just to show dimensions in context.
      debugDimensions: (x, y, line, ctx) ->
        # Draw a rectangle with our dimensions
        ctx.fillStyle = '#00F'
        ctx.strokeStyle = '#000'
        ctx.lineWidth = 1
        ctx.fillRect x, y, @dimensions[line].width, @dimensions[line].height
        ctx.strokeRect x, y, @dimensions[line].width, @dimensions[line].height

        # Recurse on all our children,
        # advancing x and y so that there
        # is no overlap between boxes
        for childObj in @lineChildren[line]
          x += @padding
          childView = @view.getViewNodeFor childObj.child

          childView.debugDimensions x, y, line - childObj.startLine, ctx
          x += childView.dimensions[line - childObj.startLine].width

      # ### debugAllDimensions
      # Run `debugDimensions` on all lines.
      debugAllDimensions: (ctx) ->
        # Make the context transparent
        # a bit, so that we can see the stack depth
        # of each block
        ctx.globalAlpha = 0.1; y = 0

        for size, line in @dimensions
          @debugDimensions 0, y, line, ctx
          y += size.height

        ctx.globalAlpha = 1

      # ### debugAllBoundingBoxes
      # Draw our bounding box on each line, and ask
      # all our children to do so too.
      debugAllBoundingBoxes: (ctx) ->
        # Make the context transparent for easy depth
        # perception
        ctx.globalAlpha = 0.1

        # Draw bounding box
        for bound in @bounds
          bound.fill ctx, '#00F'
          bound.stroke ctx, '#000'

        # Recurse
        for childObj in @children
          @view.getViewNodeFor(childObj.child).debugAllBoundingBoxes ctx

        ctx.globalAlpha = 1

    # # ContainerViewNode
    # Class from which `socketView`, `indentView`, `blockView`, and `segmentView` extend.
    # Contains function for dealing with multiple children, making polygons to wrap
    # multiple lines, etc.
    class ContainerViewNode extends GenericViewNode
      constructor: (@model, @view) ->
        super

      # ## computeChildren
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

        line = 0

        # Go to all our immediate children.
        @model.traverseOneLevel (head, isContainer) =>
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
          @boundingBoxFlag = true
          @bounds = @bounds[...@lineLength]

        # Fill in gaps in @multilineChildrenData with NO_MULTILINE
        @multilineChildrenData[i] ?= NO_MULTILINE for i in [0...@lineLength]

        return @lineLength

      # ## computeDimensions (ContainerViewNode)
      # Compute the size of our bounding box on each line.
      computeDimensions: ->
        # If we can, use cached data.
        if @computedVersion is @model.version
          return null

        @dimensions = (new draw.Size(0, 0) for [0...@lineLength])
        @distanceToBase = ({above:0, below:0} for [0...@lineLength])

        # Recurse on our children, updating
        # our dimensions as we go to contain them.
        for childObject in @children
          # Ask the child to compute dimensions
          childNode = @view.getViewNodeFor(childObject.child)
          childNode.computeDimensions()
          dimensions = childNode.dimensions
          distanceToBase = childNode.distanceToBase

          # Horizontal margins get added to every line.
          for size, line in dimensions
            desiredLine = line + childObject.startLine
            margins = childNode.getMargins line

            # Unless we are in the middle of an indent,
            # add padding on the right of the child.
            #
            # Exception: Children with invisible bounding boxes
            # should remain invisible. This matters
            # mainly for indents starting at the end of a line.
            @dimensions[desiredLine].width += size.width +
              margins.left +
              margins.right

            # Compute max distance above and below text
            @distanceToBase[desiredLine].above = Math.max(
              @distanceToBase[desiredLine].above,
              distanceToBase[line].above + margins.top)
            @distanceToBase[desiredLine].below = Math.max(
              @distanceToBase[desiredLine].below,
              distanceToBase[line].below + margins.bottom)

        # Height is just the sum of the above-base and below-base counts.
        # Empty lines should have some height.
        for dimension, line in @dimensions
          if @lineChildren[line].length is 0
            @distanceToBase[line].above = @view.opts.emptyLineHeight

          dimension.height =
            @distanceToBase[line].above +
            @distanceToBase[line].below

        return null

      # ## computeBoundingBoxX (ContainerViewNode)
      # Layout bounding box positions horizontally.
      # This needs to be separate from y-coordinate computation
      # because of glue spacing (the space between lines
      # that keeps weird-shaped blocks continuous), which
      # can shift y-coordinates around.
      computeBoundingBoxX: (left, line) ->
        # Use cached data if possible
        if @computedVersion is @model.version and
            left is @bounds[line]?.x
          return @bounds[line]

        # If the bounding box we're being asked
        # to layout is exactly the same,
        # avoid setting `@boundingBoxFlag`
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
            @bounds[line] = new draw.Rectangle(
              left, 0
              @dimensions[line].width, 0
            )

          @boundingBoxFlag = true

        # Now recurse. We will keep track
        # of a "cursor" as we go along,
        # placing children down and
        # adding padding and sizes
        # to make them not overlap.
        childLeft = left

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
            not @boundingBoxFlag
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

              # Set the `draw` flag iff there is no indent between us.
              @glue[line].draw = @multilineChildrenData[line] isnt MULTILINE_MIDDLE
          
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
            if @multilineChildrenData[line] is MULTILINE_START
              overlap = Math.min overlap, @bounds[line + 1].x + @view.opts.indentWidth - @bounds[line].x

            # If the overlap is too small, demand glue.
            if overlap < @view.opts.padding and @model.type isnt 'indent'
              @glue[line].height += @view.opts.padding

        # Return the glue we just computed.
        return @glue

      # ## computeBoundingBoxY
      # Layout a line vertically.
      computeBoundingBoxY: (top, line) ->
        # Use our cache if possible.
        if @computedVersion is @model.version and
            top is @bounds[line]?.y
          return @bounds[line]

        # Avoid setting `@boundingBoxFlag` if our
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

          @boundingBoxFlag = true

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
      layout: (left = 0, top = 0) ->
        @computeChildren()
        @computeMargins()
        @computeDimensions()
        @computeAllBoundingBoxX left
        @computeGlue()
        @computeAllBoundingBoxY top
        @computePath()
        @computeDropAreas()
        @computeNewVersionNumber()

        return null

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
        #    this will leave a thick tounge due to things done in dimension
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
        if @shouldAddTab()
          @addTab left, new draw.Point @bounds[0].x, @bounds[0].y

        for bounds, line in @bounds

          # Case 1. Normal rendering.
          if @multilineChildrenData[line] is NO_MULTILINE
            # Draw the left edge of the bounding box.
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            # Draw the right edge of the bounding box.
            right.push new draw.Point bounds.right(), bounds.y
            right.push new draw.Point bounds.right(), bounds.bottom()

          # Case 2. Start of a multiline block.
          if @multilineChildrenData[line] is MULTILINE_START
            # Draw the left edge normally.
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            # Find the multiline child that's starting on this line,
            # so that we can know its bounds
            multilineChild = @lineChildren[line][@lineChildren[line].length - 1]
            multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

            # Draw the upper-right corner
            right.push new draw.Point bounds.right(), bounds.y

            # If the multiline child here is invisible,
            # draw the line just normally.
            if multilineBounds.width is 0
              right.push new draw.Point bounds.right(), bounds.bottom()

            # Otherwise, avoid the block by tracing out its
            # top and left edges, then going to our bound's bottom.
            else
              right.push new draw.Point bounds.right(), multilineBounds.y
              right.push new draw.Point multilineBounds.x, multilineBounds.y
              right.push new draw.Point multilineBounds.x, bounds.bottom()

          # Case 3. Middle of an indent.
          if @multilineChildrenData[line] is MULTILINE_MIDDLE
            multilineChild = @lineChildren[line][0]
            multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

            # Draw the left edge normally.
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            # Draw the right edge straight down,
            # exactly to the left of the multiline child.
            right.push new draw.Point multilineBounds.x, bounds.y
            right.push new draw.Point multilineBounds.x, bounds.bottom()

          # Case 4. End of an indent.
          if @multilineChildrenData[line] is MULTILINE_END
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            # Find the child that is the indent
            multilineChild = @lineChildren[line][0]
            multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

            # Avoid the indented area
            right.push new draw.Point multilineBounds.x, multilineBounds.y
            right.push new draw.Point multilineBounds.x, multilineBounds.bottom()

            right.push new draw.Point multilineBounds.right(), multilineBounds.bottom()

            # If we must, make the "G"-shape
            if @lineChildren[line].length > 1
              right.push new draw.Point multilineBounds.right(), multilineBounds.y
              right.push new draw.Point bounds.right(), bounds.y

            # Otherwise, don't.
            else
              right.push new draw.Point bounds.right(), multilineBounds.bottom()

            right.push new draw.Point bounds.right(), bounds.bottom()

          # "Glue" phase
          # Here we use our glue spacing data
          # to draw glue, if necessary.
          #
          # If we are being told to draw some glue here,
          # do so.
          if line of @glue and @glue[line].draw
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
            left.push new draw.Point @bounds[line].x, glueTop
            left.push new draw.Point leftmost, glueTop
            left.push new draw.Point leftmost, @bounds[line + 1].y

            # Do the same for the right side, unless we can't
            # because we're avoiding intersections with a multiline child that's
            # in the way.
            unless @multilineChildrenData[line] is MULTILINE_START
              right.push new draw.Point @bounds[line].right(), glueTop
              right.push new draw.Point rightmost, glueTop
              right.push new draw.Point rightmost, @bounds[line + 1].y

          # Otherwise, bring us gracefully to the next line
          # without lots of glue (minimize the extra colour).
          else if @bounds[line + 1]? and @multilineChildrenData[line] isnt MULTILINE_MIDDLE
            # Instead of outward extremes, we take inner extremes this time,
            # to minimize extra colour between lines.
            innerLeft = Math.max @bounds[line + 1].x, @bounds[line].x
            innerRight = Math.min @bounds[line + 1].right(), @bounds[line].right()

            # Drop down to the next line on the left, minimizing extra colour
            left.push new draw.Point innerLeft, @bounds[line].bottom()
            left.push new draw.Point innerLeft, @bounds[line + 1].y

            # Do the same on the right, unless we need to avoid
            # a multiline block that's starting here.
            unless @multilineChildrenData[line] is MULTILINE_START
              right.push new draw.Point innerRight, @bounds[line].bottom()
              right.push new draw.Point innerRight, @bounds[line + 1].y

          # If we're avoiding intersections with a multiline child in the way,
          # bring us gracefully to the next line's top. We had to keep avoiding
          # using bounding box right-edge data earlier, because it would have overlapped;
          # instead, we want to use the left edge of the multiline block that's
          # starting here.
          if @multilineChildrenData[line] is MULTILINE_START
            multilineChild = @lineChildren[line][@lineChildren[line].length - 1]
            multilineBounds = @view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine]

            right.push new draw.Point multilineBounds.x, @bounds[line].bottom()
            right.push new draw.Point multilineBounds.x, @bounds[line + 1].y

          # Add the top tab of the indent if necessary. This only occurs
          # when the last child on this line is an actual Indent node.
          if @multilineChildrenData[line] is MULTILINE_START and
             @lineChildren[line][@lineChildren[line].length - 1].child.type is 'indent'
            @addTab right, new draw.Point(@bounds[line + 1].x + @view.opts.indentWidth + @padding, @bounds[line + 1].y), true

        # If necessary, add tab
        # at the bottom.
        if @shouldAddTab()
          @addTab right, new draw.Point @bounds[@lineLength - 1].x, @bounds[@lineLength - 1].bottom()

        # Reverse the left and concatenate it with the right
        # to make a counterclockwise path
        path = left.reverse().concat right

        # Make a Path object out of these points
        @path = new draw.Path(); @path.push el for el in path

        # Return it.
        return @path

      # ## addTab
      # Add the tab graphic to a path in a given location.
      addTab: (array, point) ->
        # Rightmost point of the tab, where it begins to dip down.
        array.push new draw.Point(point.x + @view.opts.tabOffset + @view.opts.tabWidth,
          point.y)
        # Dip down.
        array.push new draw.Point point.x + @view.opts.tabOffset + @view.opts.tabWidth * (1 - @view.opts.tabSideWidth),
          point.y + @view.opts.tabHeight
        # Bottom plateau.
        array.push new draw.Point point.x + @view.opts.tabOffset + @view.opts.tabWidth * @view.opts.tabSideWidth,
          point.y + @view.opts.tabHeight
        # Rise back up.
        array.push new draw.Point point.x + @view.opts.tabOffset,
          point.y
        # Move over to the given corner itself.
        array.push point

      # ## computeOwnDropArea
      # By default, we will not have a
      # drop area (not be droppable).
      computeOwnDropArea: -> @dropArea = @highlightArea = null

      # ## shouldAddTab
      # By default, we will ask
      # not to have a tab.
      shouldAddTab: NO

      # ## drawSelf
      # Draw our path, with applied
      # styles if necessary.
      drawSelf: (ctx, style) ->
        # Upon grayscale style,
        # apply the gray-out effect
        # (temporarily).
        if style.grayscale > 0
          oldFill = @path.style.fillColor
          @path.style.fillColor = grayscale oldFill

          @path.draw ctx

          # Unset all the things we changed
          @path.style.fillColor = oldFill

        # Upon selected style,
        # draw a transparent blue
        # polygon over the normally-rendered
        # path (to give "selected" feel).
        else if style.selected > 0
          @path.draw ctx

          oldFill = @path.style.fillColor
          @path.style.fillColor = '#00F'

          oldStroke = @path.style.strokeColor
          @path.style.strokeColor = '#008'

          oldAlpha = ctx.globalAlpha
          ctx.globalAlpha *= 0.3

          @path.draw ctx

          # Unset all the things we changed
          ctx.globalAlpha = oldAlpha
          @path.style.fillColor = oldFill
          @path.style.strokeColor = oldStroke

        # Normally, just draw the path.
        else
          @path.draw ctx

        return null

      # ## drawShadow
      # Draw the drop-shadow of the path on the given
      # context.
      drawShadow: (ctx, x, y) ->
        @path.drawShadow ctx, x, y, @view.opts.shadowBlur

        for childObj in @children
          @view.getViewNodeFor(childObj.child).drawShadow ctx, x, y

        return null

    # # BlockViewNode
    class BlockViewNode extends ContainerViewNode
      constructor: -> super

      computeDimensions: ->
        if @computedVersion is @model.version
          return null

        super

        # Blocks have a shape including a lego nubby "tab", and so
        # they need to be at least wide enough for tabWidth+tabOffset.
        for size, i in @dimensions
          size.width = Math.max size.width,
              @view.opts.tabWidth + @view.opts.tabOffset

        return null

      shouldAddTab: ->
        if @model.parent? then @model.parent.type isnt 'socket'
        else not @model.valueByDefault

      computeOwnPath: ->
        super
        @path.style.fillColor = @model.color
        @path.style.strokeColor = '#888'

        if @model.lineMarkStyles.length > 0
          @path.style.strokeColor = @model.lineMarkStyles[0].color
          @path.style.lineWidth = 2

        return @path

      computeOwnDropArea: ->
        # Our drop area is a rectangle of
        # height dropAreaHeight and a width
        # equal to our last line width,
        # positioned at the bottom of our last line.
        @dropArea = new draw.Rectangle(
          @bounds[@lineLength - 1].x,
          @bounds[@lineLength - 1].bottom() - @view.opts.dropAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          @view.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[@lineLength - 1].x,
          @bounds[@lineLength - 1].bottom() - @view.opts.highlightAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          @view.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 1
        @highlightArea.style.strokeColor = '#fff'
        @highlightArea.style.fillColor = '#fff'

    # # SocketViewNode
    class SocketViewNode extends ContainerViewNode
      constructor: -> super

      shouldAddTab: NO

      # ## computeDimensions
      # Sockets have a couple exceptions to normal dimension computation.
      #
      # 1. Empty sockets have size.
      # 2. Sockets containing blocks mimic the block exactly.
      computeDimensions: ->
        # Use cache if possible.
        if @computedVersion is @model.version
          return null

        super
        
        # If it is 
        if @model.start.next is @model.end
          @dimensions[0].height =
            (@distanceToBase[0].above = @view.opts.emptySocketHeight - @view.opts.padding) +
            (@distanceToBase[0].below = @view.opts.padding)

        for dimension in @dimensions
          dimension.width =
              Math.max(dimension.width, @view.opts.emptySocketWidth)

        return null

      # ## computeGlue
      # Sockets have one exception to normal glue spacing computation:
      # sockets containing a block should **not** add padding to
      # the glue.
      computeGlue: ->
        # Use cache if possible
        if @computedVersion is @model.version and
            not @boundingBoxFlag
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

      # ## computeOwnPath
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
            not @boundingBoxFlag
          return @path

        if @model.start.next.type is 'blockStart'
          view = @view.getViewNodeFor @model.start.next.container
          @path = view.computeOwnPath().clone()

        # Otherwise, call super.
        else
          super

        # Make ourselves white, with a
        # gray border.
        @path.style.fillColor = '#FFF'
        @path.style.strokeColor = '#888'

        return @path

      # ## computeOwnDropArea
      # Socket drop areas are actually the same
      # shape as the sockets themselves, which
      # is different from most other
      # things.
      computeOwnDropArea: ->
        if @model.start.next.type is 'blockStart'
          @dropArea = @highlightArea = null
        else
          @dropArea = @path
          @highlightArea = @path.clone()
          @highlightArea.style.strokeColor = '#FFF'
          @highlightArea.style.lineWidth = @view.opts.padding

    # # IndentViewNode
    class IndentViewNode extends ContainerViewNode
      constructor: -> super; @padding = 0

      # ## computeOwnPath
      # An Indent should also have no drawn
      # or hit-tested path.
      computeOwnPath: -> @path = new draw.Path()


      # ## computeDimensions
      #
      # Give width to any empty lines
      # in the Indent.
      computeDimensions: ->
        super
        
        for size, line in @dimensions[1..] when size.width is 0
          size.width = @view.opts.emptyLineWidth

      # ## drawSelf
      #
      # Again, an Indent should draw nothing.
      drawSelf: -> null

      # ## computeOwnDropArea
      #
      # Our drop area is a rectangle of
      # height dropAreaHeight and a width
      # equal to our last line width,
      # positioned at the bottom of our last line.
      computeOwnDropArea: ->
        @dropArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - @view.opts.dropAreaHeight / 2,
          Math.max(@bounds[1].width, @view.opts.indentDropAreaMinWidth),
          @view.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - @view.opts.highlightAreaHeight / 2,
          Math.max(@bounds[1].width, @view.opts.indentDropAreaMinWidth),
          @view.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 1
        @highlightArea.style.strokeColor = '#fff'
        @highlightArea.style.fillColor = '#fff'

    # # SegmentViewNode
    # Represents a Segment. Draws little, but
    # recurses.
    class SegmentViewNode extends ContainerViewNode
      constructor: -> super; @padding = 0

      # ## computeOwnPath
      #
      computeOwnPath: -> @path = new draw.Path()

      # ## computeOwnDropArea
      #
      # Lasso segments are not droppable;
      # root segments of documents
      # can be dropped at their beginning.
      computeOwnDropArea: ->
        if @model.isLassoSegment
          return @dropArea = null
        else
          @dropArea = new draw.Rectangle(
            @bounds[0].x
            @bounds[0].y - @view.opts.dropAreaHeight / 2
            Math.max(@bounds[0].width, @view.opts.indentDropAreaMinWidth)
            @view.opts.dropAreaHeight
          ).toPath()

          @highlightArea = new draw.Rectangle(
            @bounds[0].x
            @bounds[0].y - @view.opts.highlightAreaHeight / 2
            Math.max(@bounds[0].width, @view.opts.indentDropAreaMinWidth)
            @view.opts.highlightAreaHeight
          ).toPath()

          @highlightArea.style.fillColor = '#fff'
          @highlightArea.style.strokeColor = '#fff'

          return null

      # ## drawSelf
      #
      # A Segment has no drawn representation.
      drawSelf: (ctx, style) -> null

      # ## draw
      #
      # A Segment can be a lasso select
      # container, in which case it
      # should set the "selected" style
      # on all of its children during
      # the draw phase.
      draw: (ctx, boundingRect, style) ->
        style ?= defaultStyleObject()

        if @model.isLassoSegment then style.selected++
        super
        if @model.isLassoSegment then style.selected--

    # # TextViewNode
    #
    # TextViewNode does not extend ContainerViewNode.
    # We contain a draw.TextElement to measure
    # bounding boxes and draw text.
    class TextViewNode extends GenericViewNode
      constructor: (@model, @view) -> super

      # ## computeChildren
      #
      # Text elements are one line
      # and contain no children (and thus
      # no multiline children, either)
      computeChildren: ->
        @multilineChildrenData = [NO_MULTILINE]
        return @lineLength = 1

      # ## computeDimensinos
      #
      # Set our dimensions to the measured dimensinos
      # of our text value.
      computeDimensions: ->
        if @computedVersion is @model.version
          return null

        @textElement = new draw.Text(
          new draw.Point(0, 0),
          @model.value
        )

        height = @textElement.bounds().height
        @dimensions[0] = new draw.Size(@textElement.bounds().width, height)
        @distanceToBase[0] = {above: height, below: 0}

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
      drawSelf: (ctx, style) ->
        @textElement.draw ctx
        return null

      # ## Debug output

      # ### debugDimensions
      #
      # Draw the text element wherever we're told.
      debugDimensions: (x, y, line, ctx) ->
        ctx.globalAlpha = 1
        oldPoint = @textElement.point
        @textElement.point = new draw.Point x, y
        @textElement.draw ctx
        @textElement.point = oldPoint
        ctx.globalAlpha = 0.1

      # ### debugAllBoundingBoxes
      # Draw our text element
      debugAllBoundingBoxes: (ctx) ->
        ctx.globalAlpha = 1
        @computeOwnPath()
        @textElement.draw ctx
        ctx.globalAlpha = 0.1

    # # CursorViewNode
    # The Cursor should not be render by the standard view.
    # Thus everything here is a no-op.
    class CursorViewNode extends GenericViewNode
      constructor: (@model, @view) -> super

      computeChildren: ->
        @multilineChildrenData = [0]
        return 1

      computeBoundingBox: ->

  # ## Grayscale
  # Brings a colour closer to gray,
  # for the gray-out effect when dragging or
  # having floating blocks.
  grayscale = (hex) ->
    # Convert to 6-char hex if not already there
    if hex.length is 4
      hex = hex[0] + hex[1] + hex[1] + hex[2] + hex[2] + hex[3] + hex[3]

    # Extract integers from hex
    r = parseInt hex[1..2], 16
    g = parseInt hex[3..4], 16
    b = parseInt hex[5..6], 16

    # Average with gray
    r = Math.round (r + 128) / 2
    g = Math.round (g + 128) / 2
    b = Math.round (b + 128) / 2

    # Reassemble hex string
    return '#' + r.toString(16) + g.toString(16) + b.toString(16)

  return exports
