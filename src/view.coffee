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

  exports.View = class View
    map = {}
    self = null

    constructor: (@opts) ->
      self = this
      draw._setCTX @opts.ctx

    clearCache: -> map = {}

    class GenericView
      constructor: (@model) ->
        map[@model.id] = this
        
        # First pass
        @lineLength = 0 # How many lines does this take up?
        @children = [] # All children, flat
        @lineChildren = [] # Children who own each line
        @indentData = [] # Where do indents start/end?

        @parentStack = []

        @dimensions = [] # Dimensions on each line
        @bounds = [] # Bounding boxes on each line

        @totalBounds = new draw.NoRectangle()
        
        # Fourth pass
        @path = new draw.Path()

        @versions =
          children: -1
          dimensions: -1
          path: -1
          bounds: {}

        @dropArea = @highlightArea = null
        @boundingBoxFlag = true

        @padding = self.opts.padding

      computeChildren: -> @lineLength
      
      computeDimensions: -> @dimensions
      
      computeBoundingBox: (upperLeft, line) ->
        if @versions.bounds[line] is @model.version and
           upperLeft.x is @bounds[line]?.x and
           upperLeft.y is @bounds[line]?.y
          return @bounds[line]
        else
          @versions.bounds[line] = @model.version

        @bounds[line] = new draw.Rectangle(
          upperLeft.x,
          upperLeft.y,
          @dimensions[line].width,
          @dimensions[line].height
        )

        @totalBounds.unite @bounds[line]

        return @bounds[line]

      getBounds: -> @totalBounds

      computeOwnPath: -> @path = new draw.Path()

      computeDropAreas: ->
        if @boundingBoxFlag
          @computeOwnDropArea()
          for childObj in @children
            self.getViewFor(childObj.child).computeDropAreas()

        @boundingBoxFlag = false

        return null

      computeOwnDropArea: ->

      computePath: ->
        if @versions.path is @model.version and not @boundingBoxFlag
          return null
        else
          @versions.path = @model.version

        if @boundingBoxFlag
          @computeOwnPath()

        @totalBounds.unite @path.bounds()

        for childObj in @children
          self.getViewFor(childObj.child).computePath()

        return null

      drawSelf: (ctx, style) ->

      draw: (ctx, boundingRect, style) ->
        if @totalBounds.overlap boundingRect
          window.drawNumber++
          style ?= selected: 0

          @drawSelf ctx, style

          
          # Draw our children
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) is 0
            self.getViewFor(childObj.child).draw ctx, boundingRect, style
          
          # Draw marked blocks last, so that they
          # appear on top.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) > 0
            self.getViewFor(childObj.child).draw ctx, boundingRect, style

        return null

      drawShadow: ->

    class ContainerView extends GenericView
      constructor: (@model) ->
        super

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
            view = self.getViewFor(head)
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
            if head.type is 'indent'
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
          dimensions = self.getViewFor(childObject.child).computeDimensions()
          
          # We treat children differently if they are Indents,
          # because padding is all off.
          if childObject.child.type is 'indent'
            for size, line in dimensions
              desiredLine = line + childObject.startLine
              
              # An Indent is "padded" by a strip of width opts.indentWidth on the left.
              @dimensions[desiredLine].width += size.width + self.opts.indentWidth +
                (if line is (dimensions.length - 1) then @padding else 0)

              # An Indent usually has no vertical padding,
              # except at start and end. At start and end,
              # we add a "tounge" at top and bottom.
              @dimensions[desiredLine].height = Math.max @dimensions[desiredLine].height,
                size.height +
                (if line is (dimensions.length - 1) then self.opts.indentToungeHeight # TODO allow for top indent thing
                else 0)
          
          # Normally, we just render blocks with padding.
          else
            for size, line in dimensions
              desiredLine = line + childObject.startLine
        
              @dimensions[desiredLine].width += size.width + @padding
              @dimensions[desiredLine].height = Math.max @dimensions[desiredLine].height,
                size.height +
                (if @indentData[desiredLine] in [NO_INDENT, INDENT_START] then 2 * @padding
                else if @indentData[desiredLine] is INDENT_END then @padding
                else 0)

        for children, line in @lineChildren
          if children.length is 0
            @dimensions[line].height = Math.max @dimensions[line].height, self.opts.emptyLineHeight
        
        return @dimensions
      
      parentStackMatches: ->
        head = @model.parent
        for parent in @parentStack
          if head isnt parent then return false
          else head = head.parent

        return not head?

      updateParentStack: ->
        @parentStack.length = 0
        head = @model.parent
        while head?
          @parentStack.push head
          head = head.parent

      getBounds: -> @totalBounds
      
      computeBoundingBox: (upperLeft, line) ->
        if @versions.bounds[line] is @model.version and
           upperLeft.x is @bounds[line]?.x and
           upperLeft.y is @bounds[line]?.y
          return @bounds[line]
        else
          @versions.bounds[line] = @model.version
        
        unless @bounds[line]? and
           @bounds[line].x is upperLeft.x and
           @bounds[line].y is upperLeft.y and
           @bounds[line].width is @dimensions[line].width and
           @bounds[line].height is @dimensions[line].height

          # Assign our own bounding box given
          # this center-left coordinate
          @bounds[line] = new draw.Rectangle(
            upperLeft.x
            upperLeft.y
            @dimensions[line].width
            @dimensions[line].height
          )

          @boundingBoxFlag = true

        @totalBounds.unite @bounds[line]
        
        # Ask all our children to compute bounding
        # boxes as well.
        leftX = upperLeft.x + @padding
        axis = upperLeft.y + @dimensions[line].height / 2
        
        for lineChild, i in @lineChildren[line]
          childView = self.getViewFor lineChild.child
          childLine = line - lineChild.startLine

          # Indents are special; they are not padded,
          # and are guaranteed to match the top of the block.
          #
          # Exception: the first line of an indent should not match
          # the top of its surrounding block, but rather
          # have a "tounge" on top of it.
          if lineChild.child.type is 'indent'
            childView.computeBoundingBox new draw.Point(
              leftX + self.opts.indentWidth,
              upperLeft.y
            ), childLine
            
            leftX += self.opts.indentWidth + childView.dimensions[childLine].width

          # Special case: when an indent ends
          # on the same line as some other blocks,
          # make sure it sticks to the top of the line.
          else if @indentData[line] is INDENT_END and i is 0
            childView.computeBoundingBox new draw.Point(
              leftX
              upperLeft.y
            ), childLine

            leftX += @padding + childView.dimensions[childLine].width

          # Otherwise, add padding.
          else
            childView.computeBoundingBox new draw.Point(
              leftX
              axis - childView.dimensions[childLine].height / 2
            ), childLine

            leftX += @padding + childView.dimensions[childLine].width

        @updateParentStack()
        
        return @bounds[line]
      
      computeBoundingBoxes: (left = 0, top = 0) ->
        for size, line in @dimensions
          @computeBoundingBox(
            new draw.Point(left, top),
            line
          )

          top += size.height

        return true

      layout: (left = 0, top = 0) ->
        @computeChildren()
        @computeDimensions()
        @computeBoundingBoxes left, top
        @computePath()
        @computeDropAreas()

        @boundingBoxFlag = false

        return null
      
      addTab: (array, point, invert = false) ->
        @addRectilinear array, new draw.Point(point.x + self.opts.tabOffset + self.opts.tabWidth,
          point.y), if invert then 'y' else 'x'
        array.push new draw.Point point.x + self.opts.tabOffset + self.opts.tabWidth * (1 - self.opts.tabSideWidth),
          point.y + self.opts.tabHeight
        array.push new draw.Point point.x + self.opts.tabOffset + self.opts.tabWidth * self.opts.tabSideWidth,
          point.y + self.opts.tabHeight
        array.push new draw.Point point.x + self.opts.tabOffset,
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
          
          # Cases 1 and 2. Normal rendering.
          if @indentData[line] in [NO_INDENT, INDENT_START]
            @addRectilinear left, new draw.Point bounds.x, bounds.y
            @addRectilinear left, new draw.Point bounds.x, bounds.bottom()

            @addRectilinear right, new draw.Point bounds.right(), bounds.y
            @addRectilinear right, new draw.Point bounds.right(), bounds.bottom()

            # Add the top tab of the indent if necessary
            if @indentData[line] is INDENT_START
              @addTab right, new draw.Point(@bounds[line + 1].x + self.opts.indentWidth + @padding, @bounds[line + 1].y), true

          # Case 3. Middle of an indent.
          if @indentData[line] is INDENT_MIDDLE

            @addRectilinear left, new draw.Point bounds.x, bounds.y
            @addRectilinear left, new draw.Point bounds.x, bounds.bottom()

            @addRectilinear right, new draw.Point bounds.x + self.opts.indentWidth + @padding,
              bounds.y
            @addRectilinear right, new draw.Point bounds.x + self.opts.indentWidth + @padding,
              bounds.bottom()
          
          # Case 4. End of an indent.
          if @indentData[line] is INDENT_END
            @addRectilinear left, new draw.Point bounds.x, bounds.y
            @addRectilinear left, new draw.Point bounds.x, bounds.bottom()
            
            # Find the child that is the indent
            indentChild = @lineChildren[line][0]
            indentBounds = self.getViewFor(indentChild.child).bounds[line - indentChild.startLine]
            
            # Avoid the indented area
            @addRectilinear right, new draw.Point indentBounds.x, indentBounds.y
            @addRectilinear right, new draw.Point indentBounds.x, indentBounds.bottom()

            @addRectilinear right, new draw.Point indentBounds.right(), indentBounds.bottom()

            # If we must, make the "G"-shape
            if @lineChildren[line].length > 1
              @addRectilinear right, new draw.Point indentBounds.right(), indentBounds.y
              @addRectilinear right, new draw.Point bounds.right(), bounds.y
            
            # Otherwise, don't.
            else
              @addRectilinear right, new draw.Point bounds.right(), indentBounds.bottom()

            @addRectilinear right, new draw.Point bounds.right(), bounds.bottom()
        
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
        @path.drawShadow ctx, x, y, self.opts.shadowBlur
        
        for childObj in @children
          self.getViewFor(childObj.child).drawShadow ctx, x, y

        return null

    class BlockView extends ContainerView
      constructor: -> super

      computeDimensions: ->
        if @versions.dimensions isnt @model.version
          super

          for size, i in @dimensions
            size.width = Math.max size.width, self.opts.tabWidth + self.opts.tabOffset

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
          @bounds[@lineLength - 1].bottom() - self.opts.dropAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          self.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[@lineLength - 1].x,
          @bounds[@lineLength - 1].bottom() - self.opts.highlightAreaHeight / 2,
          @bounds[@lineLength - 1].width,
          self.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 0
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
            new draw.Size(self.opts.emptySocketWidth,
              self.opts.emptySocketHeight)
          ]

        # A Socket should copy its content
        # block, if there is a content block
        else if @model.start.next.type is 'blockStart'
          view = self.getViewFor @model.start.next.container
          childDimensions = view.computeDimensions()

          @dimensions = (k for k in childDimensions)

        # Otherwise, render
        # as normal (wrap text).
        else
          # Decrement dimension version number
          # to force super to render
          @versions.dimensions--

          super

      computeBoundingBox: (upperLeft, line) ->
        if @versions.bounds[line] is @model.version and
           upperLeft.x is @bounds[line]?.x and
           upperLeft.y is @bounds[line]?.y
          if @model.stringify() is '' then debugger
          return @bounds[line]
        
        # A Socket should copy its content
        # block, if there is a content block
        if @model.start.next.type is 'blockStart'
          @bounds[line] =
            self.getViewFor(@model.start.next.container).computeBoundingBox upperLeft, line

          @boundingBoxFlag = self.getViewFor(@model.start.next.container).boundingBoxFlag

        else
          super

        return @bounds[line]

      computeOwnPath: ->
        if @model.start.next.type is 'blockStart'
          view = self.getViewFor @model.start.next.container
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
          @dropArea = @highlightArea = @path

    class IndentView extends ContainerView
      constructor: -> super; @padding = 0
      computeOwnPath: -> @path = new draw.Path()
      computeDimensions: ->
        super

        line = @dimensions.length - 1; size = @dimensions[line]
        if @lineChildren[line].length is 0
          size.height = self.opts.emptyLineHeight
          size.width = self.opts.indentDropAreaMinWidth

        return @dimensions
      
      drawSelf: -> null
      computeOwnDropArea: ->
        # Our drop area is a rectangle of
        # height dropAreaHeight and a width
        # equal to our last line width,
        # positioned at the bottom of our last line.
        @dropArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - self.opts.dropAreaHeight / 2,
          Math.max(@bounds[1].width, self.opts.indentDropAreaMinWidth),
          self.opts.dropAreaHeight
        ).toPath()

        # Our highlight area is the a rectangle in the same place,
        # with a height that can be given by a different option.
        @highlightArea = new draw.Rectangle(
          @bounds[1].x,
          @bounds[1].y - self.opts.highlightAreaHeight / 2,
          Math.max(@bounds[1].width, self.opts.indentDropAreaMinWidth),
          self.opts.highlightAreaHeight
        ).toPath()

        @highlightArea.style.lineWidth = 0
        @highlightArea.style.strokeColor = '#fff'
        @highlightArea.style.fillColor = '#fff'

    class SegmentView extends ContainerView
      constructor: -> super; @padding = 0
      computeOwnPath: -> @path = new draw.Path()
      drawSelf: (ctx, style) -> null
      draw: (ctx, boundingRect, style) ->
        if @totalBounds.overlap boundingRect
          style ?= selected: 0

          @drawSelf ctx, style

          if @model.isLassoSegment then style.selected++

          # Draw our children
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) is 0
            self.getViewFor(childObj.child).draw ctx, boundingRect, style
          
          # Draw marked blocks last, so that they
          # appear on top.
          for childObj in @children when (childObj.child.lineMarkStyles?.length ? 0) > 0
            self.getViewFor(childObj.child).draw ctx, boundingRect, style

          if @model.isLassoSegment then style.selected--
        return null

      computeOwnDropArea: -> @dropArea = @highlightArea = null

    class TextView extends GenericView
      constructor: (@model) -> super

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
      
      computeBoundingBox: (upperLeft, line) ->
        @textElement.point = upperLeft
        super
      
      drawSelf: (ctx, style) ->
        @textElement.draw ctx
        return null

    class CursorView extends GenericView
      constructor: (@model) -> super

      computeChildren: ->
        @indentData = [0]
        return 1
      
      computeDimensions: ->
        @dimensions[0] = new draw.Size 0, 0
        return @dimensions
      
      computeBoundingBox: ->

    getViewFor: (model) ->
      if model.id of map
        return map[model.id]
      else
        return @createView(model)

    createView: (model) ->
      switch model.type
        when 'text' then new TextView model
        when 'block' then new BlockView model
        when 'indent' then new IndentView model
        when 'socket' then new SocketView model
        when 'segment' then new SegmentView model
        when 'cursor' then new CursorView model

  return exports
