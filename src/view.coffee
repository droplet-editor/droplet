# # ICE Editor view
#
# Copyright (c) 2014 Anthony Bau
# MIT License

define ['ice-draw', 'ice-model'], (draw, model) ->
  NO_INDENT = 0
  INDENT_START = 1
  INDENT_MIDDLE = 2
  INDENT_END = 3

  YES = -> yes
  NO = -> no

  window.drawNumber = 0

  exports = {}

  defaultStyleObject = -> {selected: 0, grayscale: 0}
  
  # # View
  # The View class contains options and caches
  # for rendering. The controller instantiates a View
  # and interacts with things through it.
  #
  # Inner classes in the View correspond to Model
  # types (e.g. SocketView, etc.) all of which
  # will have access to their View's caches
  # and options object.
  exports.View = class View
    constructor: (@opts) ->
      # @map maps Model objects
      # to corresponding View objects,
      # so that rerendering the same model
      # can be fast
      @map = {}

      # Do our measurement hack
      draw._setCTX @opts.ctx
    
    # Simple method for clearing caches
    clearCache: -> @map = {}
    
    # ## getViewFor
    # Given a model object,
    # give the corresponding renderer object
    # under this View. If one does not exist,
    # create one, then preserve it in our map.
    getViewFor: (model) ->
      if model.id of @map
        return @map[model.id]
      else
        return @createView(model)
    
    # ## createView
    # Given a model object, create a renderer object
    # of the appropriate type.
    createView: (model) ->
      switch model.type
        when 'text' then new TextView model, this
        when 'block' then new BlockView model, this
        when 'indent' then new IndentView model, this
        when 'socket' then new SocketView model, this
        when 'segment' then new SegmentView model, this
        when 'cursor' then new CursorView model, this
    
    # # GenericView
    # Class from which all renderer classes will
    # extend.
    class GenericView
      constructor: (@model, @self) ->
        # Record ourselves in the map
        # from model to renderer
        @self.map[@model.id] = this
        
        # *First pass variables*
        @lineLength = 0 # How many lines does this take up?
        @children = [] # All children, flat
        @lineChildren = [] # Children who own each line
        @indentData = [] # Where do indents start/end?

        # *Second pass variables*
        @dimensions = [] # Dimensions on each line
        
        # *Third/fifth pass variables*
        @bounds = [] # Bounding boxes on each line
        @boundingBoxFlag = true # Did any bounding boxes change just now?

        # *Fourth pass variables*
        @glue = {}

        # *Sixth pass variables*
        @path = new draw.Path()

        # *Seventh pass variables*
        @dropArea = @highlightArea = null
        
        # Versions. The corresponding
        # Model will keep corresponding version
        # numbers, and each of our passes can
        # become a no-op when we are up-to-date (so
        # that rerendering is fast when there are
        # few or no changes to the Model).
        @versions =
          children: -1
          dimensions: -1

          # Version objects are per line
          bounds_x: {}
          glue: {}
          bounds_y: {}

          path: -1
          dropAreas: -1
        
        # Our personal padding, which may differ
        # from global padding in special cases
        # (e.g. Indents)
        @padding = @self.opts.padding
      
      # ## computeChildren
      # Find out which of our children lie on each line that we
      # own, and also how many lines we own.
      #
      # Return the number of lines we own.
      #
      # This is basically a void computeChildren that should be
      # overridden.
      computeChildren: -> @lineLength
      
      # ## computeDimensions
      # Compute the size of our bounding box on each
      # line that we contain.
      #
      # Return an array of our dimensions.
      #
      # This is a void computeDimensinos that should be overridden.
      computeDimensions: -> @dimensions
      
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
        if @versions.bounds_x[line] is @model.version and
           left is @bounds[line]?.x
          return @bounds[line]
        
        # Update our version, for caching.
        @versions.bounds_x[line] = @model.version
        
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
        if @versions.bounds_y[line] is @model.version and
           top is @bounds[line]?.y
          return @bounds[line]
        
        # Update our version
        @versions.bounds_y[line] = @model.version
        
        # Accept the bounding box edge we were given.
        # We assume here that computeBoundingBoxX was
        # already run for this version, so we
        # should be guaranteed that `@bounds[line]` exists.
        @bounds[line].y = top
        @bounds[line].height = @dimensions[line].height

        return @bounds[line]
      
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
        if @versions.path is @model.version and not @boundingBoxFlag
          return null
        
        # Update our version
        @versions.path = @model.version
        
        # It is possible that we have a version increment
        # without changing bounding boxes. If this is the case,
        # we don't need to recompute our own path.
        if @boundingBoxFlag
          @computeOwnPath()
          
          # Recompute `totalBounds`, which is used
          # to avoid re**drawing** polygons that
          # are not on-screen. `totalBounds` is the AABB
          # of the everything that has to do with the element,
          # and we redraw iff it overlaps the AABB of the viewport.
          @totalBounds = new draw.NoRectangle()
          @totalBounds.unite bound for bound in @bounds
          @totalBounds.unite @path.bounds()
        
        # Recurse.
        for childObj in @children
          @self.getViewFor(childObj.child).computePath()

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
        if @versions.dropAreas is @model.version and not @boundingBoxFlag
          return null

        else
          # If we have to recompute, update our version
          @versions.dropAreas = @model.version
          
          # Compute drop and highlight areas for ourself
          @computeOwnDropArea()
          
          # Recurse.
          for childObj in @children
            @self.getViewFor(childObj.child).computeDropAreas()
          
          # This is the last pass, so we can now
          # reset the bounding box flag, avoiding work
          # in the future.
          @boundingBoxFlag = false

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
          if @model.ephemeral and @self.opts.respectEphemeral
            style.grayscale++
          
          # Call `@drawSelf`
          @drawSelf ctx, style
          
          # Draw our children. We will want to draw blocks with line marks
          # last, so that they appear on top, so we will abstain from them
          # for now.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) is 0
            @self.getViewFor(childObj.child).draw ctx, boundingRect, style
          
          # Draw marked blocks.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) > 0
            @self.getViewFor(childObj.child).draw ctx, boundingRect, style
          
          # Decrement our grayscale if necessary
          if @model.ephemeral and @self.opts.respectEphemeral
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
        # Draw a rectangle with out dimensions
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
          childView = @self.getViewFor childObj.child

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
          @self.getViewFor(childObj.child).debugAllBoundingBoxes ctx
        
        ctx.globalAlpha = 1
    
    # # ContainerView
    # Class from which `socketView`, `indentView`, `blockView`, and `segmentView` extend.
    # Contains function for dealing with multiple children, making polygons to wrap
    # multiple lines, etc.
    class ContainerView extends GenericView
      constructor: (@model, @self) ->
        super
      
      # ## computeChildren
      # Figure out which children lie on each line
      computeChildren: ->
        # If we can, use our cached information.
        if @versions.children is @model.version then return @lineLength
        else @versions.children = @model.version

        # Otherwise, recompute.
        line = 0
        
        # Reset fields
        @lineLength = 0
        @lineChildren = [[]]
        @children = []
        @indentData = []

        @model.traverseOneLevel (head, isContainer) =>
          # Advance our line counter
          # if we encounter a newline.
          if head.type is 'newline'
            line += 1
            @lineChildren[line] ?= []
          
          else
            # Get the view object associated
            # with this model, and ask it to
            # compute children.
            view = @self.getViewFor(head)
            childLength = view.computeChildren()
            
            # Construct a childObject,
            # which will remember starting and endling lines.
            childObject =
              child: head
              startLine: line
              endLine: line + childLength - 1
            
            # Populate @children
            @children.push childObject
            
            # Populate @lineChildren
            for i in [line...line + childLength]
              @lineChildren[i] ?= []

              unless head.type is 'cursor'
                @lineChildren[i].push childObject
            
            # If this object is an indent,
            # then we know what we want our indent
            # data to be
            if view.lineLength > 1 #type is 'indent'
              @indentData[line] = INDENT_START
              @indentData[i] = INDENT_MIDDLE for i in [line + 1...line + childLength - 1]
              @indentData[line + childLength - 1] = INDENT_END

            # Otherwise, copy it.
            else
              @indentData[i] ?= view.indentData[i - line] for i in [line...line + childLength]
            
            # Advance our line counter
            # by however far our child dictates.
            line += childLength - 1

        # Set @lineLength to reflect
        # what we just found out.
        @lineLength = line + 1
        
        if @bounds.length isnt @lineLength
          @boundingBoxFlag = true
          @bounds = @bounds[...@lineLength]
        
        # Fill in gaps in @indentData with NO_INDENT
        @indentData[i] ?= NO_INDENT for i in [0...@lineLength]

        return @lineLength
      
      computeDimensions: ->
        # If we can, use cached data.
        if @versions.dimensions is @model.version then return @dimensions
        else @versions.dimensions = @model.version
        
        # Otherwise, recompute.
        @dimensions = (new draw.Size(
            @padding,
            2 * @padding
        ) for [0...@lineLength])
        
        for childObject in @children
          dimensions = @self.getViewFor(childObject.child).computeDimensions()
          
          # We treat children differently if they are Indents,
          # because padding is all off.
          if childObject.child.type is 'indent'
            for size, line in dimensions
              desiredLine = line + childObject.startLine
              
              # An Indent is "padded" by a strip of width opts.indentWidth on the left.
              @dimensions[desiredLine].width += size.width + @self.opts.indentWidth +
                (if line is (dimensions.length - 1) then @padding else 0)

              # An Indent usually has no vertical padding,
              # except at start and end. At start and end,
              # we add a "tounge" at top and bottom.
              @dimensions[desiredLine].height = Math.max @dimensions[desiredLine].height,
                size.height +
                (if line is (dimensions.length - 1) then @self.opts.indentToungeHeight # TODO allow for top indent thing
                else 0)
          
          # Normally, we just render blocks with padding.
          else
            for size, line in dimensions
              desiredLine = line + childObject.startLine
        
              @dimensions[desiredLine].width += size.width +
                (if @indentData[desiredLine] is INDENT_MIDDLE then 0 else @padding)
              @dimensions[desiredLine].height = Math.max @dimensions[desiredLine].height,
                size.height +
                (if @indentData[desiredLine] in [NO_INDENT, INDENT_START] then 2 * @padding
                else if @indentData[desiredLine] is INDENT_END then @padding
                else 0)

        for children, line in @lineChildren
          if children.length is 0
            @dimensions[line].height = Math.max @dimensions[line].height, @self.opts.emptyLineHeight
        
        return @dimensions
        
      getBounds: -> @totalBounds

      computeBoundingBoxX: (left, line) ->
        if @versions.bounds_x[line] is @model.version and
           left is @bounds[line]?.x
          return @bounds[line]
        
        @versions.bounds_x[line] = @model.version
        
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
        
        # Ask all our children to compute bounding
        # boxes as well.
        childLeft = left + @padding
        
        for lineChild, i in @lineChildren[line]
          childView = @self.getViewFor lineChild.child
          childLine = line - lineChild.startLine

          # Indents are special; they are not padded,
          # and are guaranteed to match the top of the block.
          #
          # Exception: the first line of an indent should not match
          # the top of its surrounding block, but rather
          # have a "tounge" on top of it.
          if lineChild.child.type is 'indent'
            childView.computeBoundingBoxX childLeft + @self.opts.indentWidth, childLine
            
            childLeft += @self.opts.indentWidth + childView.dimensions[childLine].width
          else
            childView.computeBoundingBoxX childLeft, childLine

            childLeft += @padding + childView.dimensions[childLine].width

        return @bounds[line]
      
      computeBoundingBoxY: (top, line) ->
        if @versions.bounds_y[line] is @model.version and
           top is @bounds[line]?.y
          return @bounds[line]

        @versions.bounds_y[line] = @model.version

        unless @bounds[line]?.y is top and
           @bounds[line]?.height is @dimensions[line].height

          # Assign our own bounding box given
          # this center-left coordinate
          @bounds[line].y = top
          @bounds[line].height = @dimensions[line].height

          @boundingBoxFlag = true

        axis = top + @dimensions[line].height / 2

        for lineChild, i in @lineChildren[line]
          childView = @self.getViewFor lineChild.child
          childLine = line - lineChild.startLine

          if (lineChild.child.type is 'indent') or (@indentData[line] is INDENT_END and i is 0)
            childView.computeBoundingBoxY top, childLine
          else
            childView.computeBoundingBoxY axis - childView.dimensions[childLine].height / 2, childLine
        
        return @bounds[line]
      
      computeBoundingBox: (upperLeft, line) ->
        @computeBoundingBoxX upperLeft.x, line
        @computeBoundingBoxY upperLeft.y, line

        return @bounds[line]
      
      computeAllBoundingBoxX: (left = 0) ->
        for size, line in @dimensions
          @computeBoundingBoxX left, line

        return @bounds

      computeGlue: ->
        if @versions.glue is @model.version and not @boundingBoxFlag
          return @glue
        
        @versions.glue = @model.version

        for childObj in @children
          @self.getViewFor(childObj.child).computeGlue()

        @glue = {}

        for box, line in @bounds
          if @bounds[line + 1]?
            unless @indentData[line] is INDENT_MIDDLE
              overlap = Math.min @bounds[line].right() - @bounds[line + 1].x, @bounds[line + 1].right() - @bounds[line].x

              if @indentData[line] is INDENT_START
                overlap = Math.min overlap, @bounds[line + 1].x + @self.opts.indentWidth - @bounds[line].x
              
              if overlap < @self.opts.padding and @model.type isnt 'indent'
                @glue[line] ?= {
                  height: @self.opts.padding
                  draw: true
                }

            for lineChild in @lineChildren[line]
              childView = @self.getViewFor lineChild.child
              childLine = line - lineChild.startLine

              if childLine of childView.glue
                @glue[line] ?= {
                  height: childView.glue[childLine].height
                  draw: true
                }
                @glue[line].height = Math.max @glue[line].height, childView.glue[childLine].height +
                  (if @indentData[line] is INDENT_MIDDLE then 0 else @padding)
                @glue[line].draw = @indentData[line] isnt INDENT_MIDDLE

        return @glue

      computeAllBoundingBoxY: (top = 0) ->
        for size, line in @dimensions
          @computeBoundingBoxY top, line
          top += size.height
          if line of @glue then top += @glue[line].height

        return @bounds

      layout: (left = 0, top = 0) ->
        @computeChildren()
        @computeDimensions()
        @computeAllBoundingBoxX left
        @computeGlue()
        @computeAllBoundingBoxY top
        @computePath()
        @computeDropAreas()

        @boundingBoxFlag = false

        return null
      
      addTab: (array, point, invert = false) ->
        array.push new draw.Point(point.x + @self.opts.tabOffset + @self.opts.tabWidth,
          point.y)
        array.push new draw.Point point.x + @self.opts.tabOffset + @self.opts.tabWidth * (1 - @self.opts.tabSideWidth),
          point.y + @self.opts.tabHeight
        array.push new draw.Point point.x + @self.opts.tabOffset + @self.opts.tabWidth * @self.opts.tabSideWidth,
          point.y + @self.opts.tabHeight
        array.push new draw.Point point.x + @self.opts.tabOffset,
          point.y
        array.push point

      addRectilinear: (array, point, first = 'x') ->
        if array.length > 0 and array[array.length - 1].x isnt point.x
          if first is 'x'
            array.push new draw.Point point.x, array[array.length - 1].y
          else if first is 'y'
            array.push new draw.Point array[array.length - 1].x, point.y

        array.push point
      
      computeOwnPath: ->
        # There are four kinds of line,
        # for the purposes of computing the path.
        #
        # 1. Normal block line; we surround the bounding rectangle.
        # 2. Beginning of an Indent. Currently we treat this as nothing. TODO. Allow some kind of gravity-bottom hook thing.
        # 3. Middle or beginning of an Indent. We avoid to the left side.
        # 4. End of an Indent. We make a tounge, and, if necessary,
        #    a hook-shaped thing off the right end.
        left = []
        right = []
        
        # If necessary, add tab
        # at the top.
        if @shouldAddTab()
          @addTab left, new draw.Point @bounds[0].x, @bounds[0].y

        for bounds, line in @bounds
          if @indentData[line] is NO_INDENT
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            right.push new draw.Point bounds.right(), bounds.y
            right.push new draw.Point bounds.right(), bounds.bottom()

          if @indentData[line] is INDENT_START
            indentChild = @lineChildren[line][@lineChildren[line].length - 1]
            indentBounds = @self.getViewFor(indentChild.child).bounds[line - indentChild.startLine]

            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            right.push new draw.Point bounds.right(), bounds.y
            if indentBounds.width > 0
              right.push new draw.Point bounds.right(), indentBounds.y
              right.push new draw.Point indentBounds.x, indentBounds.y
              right.push new draw.Point indentBounds.x, bounds.bottom()
            else
              right.push new draw.Point bounds.right(), bounds.bottom()

          # Case 3. Middle of an indent.
          if @indentData[line] is INDENT_MIDDLE

            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()

            right.push new draw.Point bounds.x + @self.opts.indentWidth + @padding,
              bounds.y
            right.push new draw.Point bounds.x + @self.opts.indentWidth + @padding,
              bounds.bottom()
          
          # Case 4. End of an indent.
          if @indentData[line] is INDENT_END
            left.push new draw.Point bounds.x, bounds.y
            left.push new draw.Point bounds.x, bounds.bottom()
            
            # Find the child that is the indent
            indentChild = @lineChildren[line][0]
            indentBounds = @self.getViewFor(indentChild.child).bounds[line - indentChild.startLine]
            
            # Avoid the indented area
            right.push new draw.Point indentBounds.x, indentBounds.y
            right.push new draw.Point indentBounds.x, indentBounds.bottom()

            right.push new draw.Point indentBounds.right(), indentBounds.bottom()

            # If we must, make the "G"-shape
            if @lineChildren[line].length > 1
              right.push new draw.Point indentBounds.right(), indentBounds.y
              right.push new draw.Point bounds.right(), bounds.y
            
            # Otherwise, don't.
            else
              right.push new draw.Point bounds.right(), indentBounds.bottom()

            right.push new draw.Point bounds.right(), bounds.bottom()

          # "Glue" phase

          if line of @glue and @glue[line].draw
            glueAxis = @bounds[line + 1].y - @glue[line].height
            leftmost = Math.min @bounds[line + 1].x, @bounds[line].x
            rightmost = Math.max @bounds[line + 1].right(), @bounds[line].right()

            left.push new draw.Point @bounds[line].x, glueAxis
            left.push new draw.Point leftmost, glueAxis
            left.push new draw.Point leftmost, @bounds[line + 1].y
            
            unless @indentData[line] is INDENT_START
              right.push new draw.Point @bounds[line].right(), glueAxis
              right.push new draw.Point rightmost, glueAxis
              right.push new draw.Point rightmost, @bounds[line + 1].y

          else if @bounds[line + 1]? and @indentData[line] isnt INDENT_MIDDLE
            innerLeft = Math.max @bounds[line + 1].x, @bounds[line].x
            innerRight = Math.min @bounds[line + 1].right(), @bounds[line].right()

            left.push new draw.Point innerLeft, @bounds[line].bottom()
            left.push new draw.Point innerLeft, @bounds[line + 1].y

            unless @indentData[line] is INDENT_START
              right.push new draw.Point innerRight, @bounds[line].bottom()
              right.push new draw.Point innerRight, @bounds[line + 1].y
          
          if @indentData[line] is INDENT_START
            indentChild = @lineChildren[line][@lineChildren[line].length - 1]
            indentBounds = @self.getViewFor(indentChild.child).bounds[line - indentChild.startLine]
            
            right.push new draw.Point indentBounds.x, @bounds[line].bottom()
            right.push new draw.Point indentBounds.x, @bounds[line + 1].y


          # Add the top tab of the indent if necessary
          if @indentData[line] is INDENT_START and @lineChildren[line][@lineChildren[line].length - 1].child.type is 'indent'
            @addTab right, new draw.Point(@bounds[line + 1].x + @self.opts.indentWidth + @padding, @bounds[line + 1].y), true

        # If necessary, add tab
        # at the bottom.
        if @shouldAddTab()
          @addTab right, new draw.Point @bounds[@lineLength - 1].x, @bounds[@lineLength - 1].bottom()
        
        path = left.reverse().concat right

        @path = new draw.Path()

        @path.push el for el in path

        return @path
      
      computeOwnDropArea: -> @dropArea = @highlightArea = null
      shouldAddTab: NO

      drawSelf: (ctx, style) ->
        if style.grayscale > 0
          oldFill = @path.style.fillColor
          @path.style.fillColor = grayscale oldFill

          @path.draw ctx

          @path.style.fillColor = oldFill

        else
          @path.draw ctx

        if style.selected > 0
          oldFill = @path.style.fillColor
          @path.style.fillColor = '#00F'

          oldStroke = @path.style.strokeColor
          @path.style.strokeColor = '#008'

          oldAlpha = ctx.globalAlpha
          ctx.globalAlpha *= 0.3

          @path.draw ctx

          ctx.globalAlpha = oldAlpha
          @path.style.fillColor = oldFill
          @path.style.strokeColor = oldStroke

        return null

      drawShadow: (ctx, x, y) ->
        @path.drawShadow ctx, x, y, @self.opts.shadowBlur
        
        for childObj in @children
          @self.getViewFor(childObj.child).drawShadow ctx, x, y

        return null

    class BlockView extends ContainerView
      constructor: -> super

      computeDimensions: ->
        if @versions.dimensions isnt @model.version
          super

          for size, i in @dimensions
            size.width = Math.max size.width, @self.opts.tabWidth + @self.opts.tabOffset

        return @dimensions

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
          @bounds[@lineLength - 1].bottom() - @self.opts.dropAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          @self.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[@lineLength - 1].x,
          @bounds[@lineLength - 1].bottom() - @self.opts.highlightAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          @self.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 1
        @highlightArea.style.strokeColor = '#fff'
        @highlightArea.style.fillColor = '#fff'
      
    class SocketView extends ContainerView
      constructor: -> super

      shouldAddTab: NO

      computeDimensions: ->
        if @versions.dimensions is @model.version then return @bounds
        else @versions.dimensions = @model.version
        
        # An empty Socket should have some size
        if @model.start.nextVisibleToken() is @model.end
          @dimensions = [
            new draw.Size(@self.opts.emptySocketWidth,
              @self.opts.emptySocketHeight)
          ]

        # A Socket should copy its content
        # block, if there is a content block
        else if @model.start.next.type is 'blockStart'
          @padding = 0
          view = @self.getViewFor @model.start.next.container
          childDimensions = view.computeDimensions()

          @dimensions = (k for k in childDimensions)

        # Otherwise, render
        # as normal (wrap text).
        else
          @padding = @self.opts.padding
          # Decrement dimension version number
          # to force super to render
          @versions.dimensions--

          super

      computeGlue: ->
        if @versions.glue is @model.version and not @boundingBoxFlag
          return @glue
        
        @versions.glue = @model.version

        if @model.start.next.type is 'blockStart'
          view = @self.getViewFor @model.start.next.container
          @glue = view.computeGlue()
        else
          @versions.glue--

          super

      computeBoundingBoxX: (left, line) ->
        if @versions.bounds_x[line] is @model.version and
           left is @bounds[line]?.x
          return @bounds[line]
        
        # A Socket should copy its content
        # block, if there is a content block
        if @model.start.next.type is 'blockStart'
          @bounds[line] =
            @self.getViewFor(@model.start.next.container).computeBoundingBoxX left, line

          @boundingBoxFlag = @self.getViewFor(@model.start.next.container).boundingBoxFlag

        else
          super

        return @bounds[line]
      
      computeBoundingBoxY: (top, line) ->
        if @versions.bounds_y[line] is @model.version and
           top is @bounds[line]?.y
          return @bounds[line]
        
        # A Socket should copy its content
        # block, if there is a content block
        if @model.start.next.type is 'blockStart'
          @bounds[line] =
            @self.getViewFor(@model.start.next.container).computeBoundingBoxY top, line

          @boundingBoxFlag = @self.getViewFor(@model.start.next.container).boundingBoxFlag

        else
          super

        return @bounds[line]

      computeOwnPath: ->
        if @model.start.next.type is 'blockStart'
          view = @self.getViewFor @model.start.next.container
          @path = view.computeOwnPath().clone()
        else
          super

        @path.style.fillColor = '#FFF'
        @path.style.strokeColor = '#888'

        return @path

      computeOwnDropArea: ->
        if @model.start.next.type is 'blockStart'
          @dropArea = @highlightArea = null
        else
          @dropArea = @path
          @highlightArea = @path.clone()
          @highlightArea.style.strokeColor = '#FFF'
          @highlightArea.style.lineWidth = @self.opts.padding

    class IndentView extends ContainerView
      constructor: -> super; @padding = 0
      computeOwnPath: -> @path = new draw.Path()
      computeDimensions: ->
        super

        line = @dimensions.length - 1; size = @dimensions[line]
        if @lineChildren[line].length is 0
          size.height = @self.opts.emptyLineHeight
          size.width = @self.opts.indentDropAreaMinWidth

        return @dimensions
      
      drawSelf: -> null
      computeOwnDropArea: ->
        # Our drop area is a rectangle of
        # height dropAreaHeight and a width
        # equal to our last line width,
        # positioned at the bottom of our last line.
        @dropArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - @self.opts.dropAreaHeight / 2,
          Math.max(@bounds[1].width, @self.opts.indentDropAreaMinWidth),
          @self.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - @self.opts.highlightAreaHeight / 2,
          Math.max(@bounds[1].width, @self.opts.indentDropAreaMinWidth),
          @self.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 1
        @highlightArea.style.strokeColor = '#fff'
        @highlightArea.style.fillColor = '#fff'

    class SegmentView extends ContainerView
      constructor: -> super; @padding = 0
      computeOwnPath: -> @path = new draw.Path()
      computeOwnDropArea: ->
        if @model.isLassoSegment
          return @dropArea = null
        else
          @dropArea = new draw.Rectangle(
            @bounds[0].x
            @bounds[0].y - @self.opts.dropAreaHeight / 2
            Math.max(@bounds[0].width, @self.opts.indentDropAreaMinWidth)
            @self.opts.dropAreaHeight
          ).toPath()

          @highlightArea = new draw.Rectangle(
            @bounds[0].x
            @bounds[0].y - @self.opts.highlightAreaHeight / 2
            Math.max(@bounds[0].width, @self.opts.indentDropAreaMinWidth)
            @self.opts.highlightAreaHeight
          ).toPath()

          @highlightArea.style.fillColor = '#fff'
          @highlightArea.style.strokeColor = '#fff'

          return null
      drawSelf: (ctx, style) -> null
      draw: (ctx, boundingRect, style) ->
        if @model.isLassoSegment then style.selected++
        super
        if @model.isLassoSegment then style.selected--

    class TextView extends GenericView
      constructor: (@model, @self) -> super

      computeChildren: ->
        @indentData = [0]
        return 1
      
      computeDimensions: ->
        if @versions.dimensions is @model.version then return @bounds
        else @versions.dimensions = @model.version

        @textElement = new draw.Text(
          new draw.Point(0, 0),
          @model.value
        )

        @dimensions[0] = new draw.Size(
          @textElement.bounds().width,
          @textElement.bounds().height
        )

        return @dimensions
      
      computeBoundingBoxX: (left, line) ->
        @textElement.point.x = left
        super

      computeBoundingBoxY: (top, line) ->
        @textElement.point.y = top
        super
      
      drawSelf: (ctx, style) ->
        @textElement.draw ctx
        return null
      
      debugDimensions: (x, y, line, ctx) ->
        ctx.globalAlpha = 1
        oldPoint = @textElement.point
        @textElement.point = new draw.Point x, y
        @textElement.draw ctx
        @textElement.point = oldPoint
        ctx.globalAlpha = 0.1

      debugAllBoundingBoxes: (ctx) ->
        ctx.globalAlpha = 1
        @textElement.draw ctx
        ctx.globalAlpha = 0.1

    class CursorView extends GenericView
      constructor: (@model, @self) -> super

      computeChildren: ->
        @indentData = [0]
        return 1
      
      computeDimensions: ->
        @dimensions[0] = new draw.Size 0, 0
        return @dimensions
      
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
