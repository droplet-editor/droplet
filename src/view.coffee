# ICE Editor View
# 
# Copyright (c) 2014 Anthony Bau.
#
# MIT License


## Magic constants
PADDING = 5
INDENT_SPACING = 10
TOUNGE_HEIGHT = 10
FONT_HEIGHT = 15
EMPTY_SOCKET_HEIGHT = FONT_HEIGHT + PADDING * 2
EMPTY_SOCKET_WIDTH = 20
EMPTY_INDENT_HEIGHT = FONT_HEIGHT + PADDING * 2
EMPTY_INDENT_WIDTH = 50
MIN_SEGMENT_DROP_AREA_WIDTH = 100
TAB_WIDTH = 15
TAB_HEIGHT = 5
TAB_OFFSET = 10

class BoundingBoxState
  constructor: (point) ->
    @x = point.x
    @y = point.y

class PathWaypoint
  constructor: (@left, @right) ->

## IceView
# This is the base class from which all other View elements (except the CursorView) extend.
# Code here handles most tree operations that need to be performed (all of which occur in
# FIRST PASS).
class IceView

  constructor: (@block) ->
    @children = [] # All child blocks, for event delegation. (IceView[])
    
    # Start and end lines
    @lineStart = @lineEnd = null

    @lineChildren = {} # Children on each line, computed in FIRST PASS (int:IceView[])

    @dimensions = {} # Bounding box on each line, computed in SECOND PASS (int:draw.Size)

    @cursors = []

    @indented = {}

    @indentEndsOn = {}

    @indentStartsOn = {}

    @pathWaypoints = {} # PathWaypoint[]

    @bounds = {} # Bounding boxes on each line, computed in THIRD PASS (int:draw.Rectangle)

  # ## FIRST PASS: generate @lineChildren and @children ##
  computeChildren: (line) -> # (line) is the starting line

    # Re-init all variables to blank.
    @children = []
    @lineStart = @lineEnd = null
    @lineChildren = {}
    @dimensions = {}
    @indented = {}
    @indentEndsOn = {}
    @indentStartsOn = {}
    @pathWaypoints = {}
    @bounds = {}
    @cursors = []

    # Record the starting line
    @lineStart = line

    # Linked-list loop through inner tokens
    head = @block.start.next
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          # Ask this child to compute its children (thus determining its ending line, as well)
          line = head.block.view.computeChildren line

          # Append to children array
          @children.push head.block.view

          # Append to line children array
          for occupiedLine in [head.block.view.lineStart..head.block.view.lineEnd] # (iterate over all blocks which this indent occupies)
            # (initialize empty array if it doesn't already exist
            @lineChildren[occupiedLine] ?= []

            # Push to the children on this line
            @lineChildren[occupiedLine].push head.block.view

            @indented[occupiedLine] ||= head.block.view.indented[occupiedLine]
            @indentEndsOn[occupiedLine] ||= head.block.view.indentEndsOn[occupiedLine]

          # Skip to the end of this indent
          head = head.block.end

        when 'indentStart'
          # Act analagously for indents
          line = head.indent.view.computeChildren line

          # Append to children array
          @children.push head.indent.view

          # Append to line children array
          for occupiedLine in [head.indent.view.lineStart..head.indent.view.lineEnd] # (iterate over all lines which this indent occupies)
            # (initialize empty array if it doesn't already exist
            @lineChildren[occupiedLine] ?= []

            # Push to the children on this line
            @lineChildren[occupiedLine].push head.indent.view
            
            # Mark that this line is indented here in this block
            @indented[occupiedLine] = true

          @indentEndsOn[head.indent.view.lineEnd] = true
          @indentStartsOn[head.indent.view.lineStart] = true

          # Skip to the end of this indent
          head = head.indent.end

        when 'socketStart'
          # Act analagously for sockets
          line = head.socket.view.computeChildren line

          @children.push head.socket.view

          for occupiedLine in [head.socket.view.lineStart..head.socket.view.lineEnd]
            @lineChildren[occupiedLine] ?= []

            @lineChildren[occupiedLine].push head.socket.view

            @indented[occupiedLine] ||= head.socket.view.indented[occupiedLine]
            @indentEndsOn[occupiedLine] ||= head.socket.view.indentEndsOn[occupiedLine]

          head = head.socket.end

        when 'segmentStart'
          # Act analagously for segments
          line = head.segment.view.computeChildren line

          @children.push head.segment.view

          for occupiedLine in [head.segment.view.lineStart..head.segment.view.lineEnd]
            @lineChildren[occupiedLine] ?= []

            @lineChildren[occupiedLine].push head.segment.view

            @indented[occupiedLine] ||= head.segment.view.indented[occupiedLine]
            @indentEndsOn[occupiedLine] ||= head.segment.view.indentEndsOn[occupiedLine]

          head = head.segment.end

        when 'text'
          # Act analagously for text and cursor
          head.view.computeChildren line
          
          # (For text and cursor the token itself is also the manifested thing)
          @children.push head.view
          
          @lineChildren[line] ?= []; @lineChildren[line].push head.view

        when 'cursor'
          @cursors.push
            token: head
            line: line

        when 'newline'
          line += 1
      
      # Advance our head token (linked-loop list)
      head = head.next
    
    # Record the last line
    @lineEnd = line

    # Default any empty lines to having children []
    for l in [@lineStart..@lineEnd]
      @lineChildren[l] ?= []

    return line
  
  # ## SECOND PASS: compute dimensions on each line ##
  computeDimensions: -> # A block's dimensions on each line is strictly a function of its children, so this function has no arguments.
    # Event propagate
    for child in @children then child.computeDimensions()

    return @dimensions
  
  # THIRD PASS: compute bounding boxes on each line ##
  computeBoundingBox: (line, state) -> # (line) and (state) are given by the calling parent and signify restrictions on the position of the line (e.g. padding, etc).
    # Event propagate
    for child in @lineChildren[line] then child.computeBoundingBox line, state # In an instance of this function, you will want to change (state) as you move along @lineChildren[line], to adjust for padding and such.

    return @bounds[line] = new draw.NoRectangle() # Should actually equal something

  # ## FOURTH PASS: join "path bits" into a path ##
  computePath: ->
    # Event propagate
    for child in @children then child.computePath()

    return @bounds
  

  # ## FIFTH PASS: draw ##
  drawPath: (ctx) ->
    # Event propagate
    for child in @children then child.drawPath ctx

  # ## SIXTH Pass: draw cursor ##
  drawCursor: (ctx) ->
    for child in @children then child.drawCursor ctx

    for cursor in @cursors
      if cursor.token.prev.type is 'newline' or cursor.token.prev.type is 'segmentStart'
        yCoordinate = @bounds[cursor.line].y
      else
        yCoordinate = @bounds[cursor.line].bottom()

      cursor.token.view.point.y = yCoordinate

      ctx.fillStyle = '#000'
      ctx.strokeSTyle = '#000'
      ctx.beginPath()

      if @bounds[cursor.line].x >= 5
        ctx.moveTo @bounds[cursor.line].x, yCoordinate
        ctx.lineTo @bounds[cursor.line].x - 5, yCoordinate - 5
        ctx.lineTo @bounds[cursor.line].x - 5, yCoordinate + 5
      else
        ctx.moveTo @bounds[cursor.line].x, yCoordinate
        ctx.lineTo @bounds[cursor.line].x + 5, yCoordinate - 5
        ctx.lineTo @bounds[cursor.line].x + 5, yCoordinate + 5

      ctx.stroke()
      ctx.fill()
  
  # ### Convenience function: full draw ###
  draw: (ctx) ->
    @drawPath ctx
    @drawCursor ctx

  # ###Convenience function: computeBoundingBoxes. ##
  # Normally called on root
  computeBoundingBoxes: ->
    cursor = new draw.Point 0, 0
    for line in [@lineStart..@lineEnd]
      @computeBoundingBox line, new BoundingBoxState cursor
      cursor.y += @dimensions[line].height

    return @bounds
  
  # ### getBounds ##
  # Get the enclosing bounds of this entire element
  # Must be called after passes
  getBounds: ->
    bound = new draw.NoRectangle()

    for line in [@lineStart..@lineEnd]
      bound.unite @bounds[line]

    return bound
  

  # ### Convenience function: compute ###
  compute: (line = 0) ->
    @computeChildren line
    @computeDimensions(); @computeBoundingBoxes(); @computePath()

  translate: (point) ->
    for line, bound of @bounds then bound.translate point
    for child in @children then child.translate point

# # BlockView
# The renderer for an ICE.Block(). Most paths and colors
# in ICE editor stem from here.
class BlockView extends IceView
  constructor: (block) ->
    super block
    @path = null

  # ## computeDimensions ##
  # Each line of a block adds padding on all four sides;
  # besides this height = max(children_heights), and
  # width = sum(children_widths).
  computeDimensions: ->
    # Event propagate, and any other necessary wrappers
    super

    for line in [@lineStart..@lineEnd]
      width = PADDING; height = 2 * PADDING

      for child in @lineChildren[line]

        if child.block.type is 'indent'
          # The width of a block on a line is the sum of the widths of the child blocks, plus padding.
          width += child.dimensions[line].width + INDENT_SPACING

          # The height of a block on a line is the maximum height of a child block, plus padding.
          # We add 10 if the indent ends, so as to draw the bottom of the mouth.
          height = Math.max height, child.dimensions[line].height + (if child.lineEnd is line then TOUNGE_HEIGHT else 0)

        else if child.indented[line]
          width += child.dimensions[line].width + PADDING

          # The height of a block on a line is the maximum height of a child block. Indented things do not use any padding.
          height = Math.max height, child.dimensions[line].height

        else
          width += child.dimensions[line].width + PADDING

          # The height of a block on a line is the maximum height of a child block, plus padding.
          height = Math.max height, child.dimensions[line].height + 2 * PADDING

      @dimensions[line] = new draw.Size width, height
  
  # ## computeBoundingBox ##
  # This function is probably the most computation-intensive function in this entire file.
  # It has has a lot of special cases to deal with indented blocks
  # inside us -- the tounge, G-shape, and left side of an indent mouth.
  # It is responsible for aligning block coordinates on each line, and setting up waypoints
  # to later connect with the container polygon.
  computeBoundingBox: (line, state) ->

    # Find the middle of this rectangle
    axis = state.y + @dimensions[line].height / 2
    cursor = state.x
    
    # Accept the bounds given by our parent.
    @bounds[line] = new draw.Rectangle state.x, state.y, @dimensions[line].width, @dimensions[line].height

    for child in @lineChildren[line]
      # Special case for indented things; always jam them together.
      if child.block.type is 'indent'
        # Add the padding on the left of this
        cursor += INDENT_SPACING
        
        child.computeBoundingBox line, new BoundingBoxState new draw.Point cursor,
          state.y # Position the child at the top of the line.
      
      else
        # Add the padding on the left of this
        cursor += PADDING

        child.computeBoundingBox line, new BoundingBoxState new draw.Point cursor,
          axis - child.dimensions[line].height / 2 # Position the child in the middle of the line

      cursor += child.dimensions[line].width

    # Compute the path waypoints
    if @lineChildren[line].length >  0 and not (@lineChildren[line][0].indented[line] or @lineChildren[line][0].block.type is 'indent')
      # Normally, we just enclose everything within these bounds
      @pathWaypoints[line] = new PathWaypoint [
        new draw.Point @bounds[line].x, @bounds[line].y
        new draw.Point @bounds[line].x, @bounds[line].bottom()
      ], [
        new draw.Point @bounds[line].right(), @bounds[line].y
        new draw.Point @bounds[line].right(), @bounds[line].bottom()
      ]

    else if @lineChildren[line].length > 0
      # There is, however, the special case when a child on this line is indented, or is an indent.

      if line is @lineChildren[line][0].lineEnd and @lineChildren[line][0].block.type is 'indent'
        # If the indent ends on this line, we draw the piece underneath it, and any 'G'-shape elements after it.

        # We name this for conveniency
        indentChild = @lineChildren[line][0]

        paddingLeft = if @lineChildren[line][0].block.type is 'indent' then INDENT_SPACING else PADDING

        if @lineChildren[line].length is 1
          @pathWaypoints[line] = new PathWaypoint [
            # The line down the left of the child
            new draw.Point @bounds[line].x, @bounds[line].y
            new draw.Point @bounds[line].x, @bounds[line].bottom()
          ], [
            # The box to the left of the child
            new draw.Point @bounds[line].x + paddingLeft, @bounds[line].y
            new draw.Point @bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()
            
            # The 'tounge' underneath the child
            new draw.Point indentChild.bounds[line].right(), indentChild.bounds[line].bottom()
            
            # For robustness, make sure that we go all the way to the right here.
            new draw.Point @bounds[line].right(), indentChild.bounds[line].bottom()

            # Pop down to the bottom, ready for next rectangle.
            new draw.Point @bounds[line].right(), @bounds[line].bottom()
          ]

        else
          @pathWaypoints[line] = new PathWaypoint [
            # The line down the left of the child
            new draw.Point @bounds[line].x, @bounds[line].y
            new draw.Point @bounds[line].x, @bounds[line].bottom()
          ], [
            # The box to the left of the child
            new draw.Point @bounds[line].x + paddingLeft, @bounds[line].y
            new draw.Point @bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()
            
            # The 'tounge' underneath the child
            new draw.Point indentChild.bounds[line].right(), indentChild.bounds[line].bottom()

            # The 'hook' of the G, coming up from the tounge
            new draw.Point indentChild.bounds[line].right(), @bounds[line].y

            # Finish the box, ready for next rectangle.
            new draw.Point @bounds[line].right(), @bounds[line].y
            new draw.Point @bounds[line].right(), @bounds[line].bottom()
          ]

      else
        # When the child in front of us is indented, we only draw a thin strip
        # of conainer block to the left of them, with width INDENT_SPACING
        @pathWaypoints[line] = new PathWaypoint [
          # (Left side)
          new draw.Point @bounds[line].x, @bounds[line].y
          new draw.Point @bounds[line].x, @bounds[line].bottom()
        ], [
          # (Right side)
          new draw.Point @bounds[line].x + INDENT_SPACING, @bounds[line].y
          new draw.Point @bounds[line].x + INDENT_SPACING, @bounds[line].bottom()
        ]

  # ## computePath ##
  # Here we connect the pathBits we set up in computeBoundingBox.
  # Each pathBits contains points for the right edge and points for the left edge,
  # and we simply extend the ends of our path to consume them on either side.
  # This function is responsible for keeping paths rectilinear and adding tabs on blocks.
  computePath: ->
    super
    
    @path = new draw.Path()
    @dropArea = new draw.Rectangle @bounds[@lineEnd].x, @bounds[@lineEnd].bottom() - 5, @bounds[@lineEnd].width, 10
    
    # Add the top tab (if applicable)
    unless (@block.inSocket() ? false)
      @path.push new draw.Point @bounds[@lineStart].x + TAB_OFFSET, @bounds[@lineStart].y
      @path.push new draw.Point @bounds[@lineStart].x + TAB_OFFSET + TAB_WIDTH / 8, @bounds[@lineStart].y + TAB_HEIGHT
      @path.push new draw.Point @bounds[@lineStart].x + TAB_OFFSET + TAB_WIDTH * 7 / 8, @bounds[@lineStart].y + TAB_HEIGHT
      @path.push new draw.Point @bounds[@lineStart].x + TAB_OFFSET + TAB_WIDTH, @bounds[@lineStart].y

    for line, waypoint of @pathWaypoints
      
      if @indentStartsOn[line]
        # Add top tab on an indent, if applicable
        entryPoint = new draw.Point @bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH, @bounds[line].y

        # Keep things rectilinear (except for the tab itself)
        if @path._points.length > 0 and entryPoint.y isnt @path._points[@path._points.length - 1].y
          @path.push new draw.Point @path._points[@path._points.length - 1].x, entryPoint.y

        # Now actually add the top tab
        @path.push entryPoint
        @path.push new draw.Point @bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH * 7 / 8, @bounds[line].y + TAB_HEIGHT
        @path.push new draw.Point @bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH / 8, @bounds[line].y + TAB_HEIGHT
        @path.push new draw.Point @bounds[line].x + INDENT_SPACING + TAB_OFFSET, @bounds[line].y

      for point in waypoint.left
        # Keep things rectilinear
        if @path._points.length > 0 and point.x isnt @path._points[0].x
          @path.unshift new draw.Point point.x, @path._points[0].y

        @path.unshift point

      for point in waypoint.right
        # Keep things rectilinear
        if @path._points.length > 0 and point.y isnt @path._points[@path._points.length - 1].y
          @path.push new draw.Point @path._points[@path._points.length - 1].x, point.y

        @path.push point

    # Add the bottom tab (if applicable)
    unless (@block.inSocket() ? false)
      @path.unshift new draw.Point @bounds[@lineEnd].x + TAB_OFFSET, @bounds[@lineEnd].bottom()
      @path.unshift new draw.Point @bounds[@lineEnd].x + TAB_OFFSET + TAB_WIDTH / 8, @bounds[@lineEnd].bottom() + TAB_HEIGHT
      @path.unshift new draw.Point @bounds[@lineEnd].x + TAB_OFFSET + TAB_WIDTH * 7 / 8, @bounds[@lineEnd].bottom() + TAB_HEIGHT
      @path.unshift new draw.Point @bounds[@lineEnd].x + TAB_OFFSET + TAB_WIDTH, @bounds[@lineEnd].bottom()

    @path.style.fillColor = @block.color
    @path.style.strokeColor = '#000'
    
  # ## drawPath ##
  # This just executes that path we constructed in computePath
  drawPath: (ctx) ->
    if @path._points.length is 0 then debugger
    @path.draw ctx

    super

  translate: (point) ->
    @path.translate point

    super

class TextView extends IceView
  constructor: (block) ->
    super block
    @textElement = null
    
  computeChildren: (line) ->
    # A text element cannot contain anything
    @lineStart = @lineEnd = line

  computeDimensions: ->
    # Construct a manifest text element for this text token
    @textElement = new draw.Text new draw.Point(0, 0),
      @block.value
    
    # A text element only occupies one line
    @dimensions[@lineStart] = new draw.Size @textElement.bounds().width,
      @textElement.bounds().height

    return @dimesions
  
  computeBoundingBox: (line, state) ->
    if line is @lineStart
      # Accept the bounds our parent gave us
      @bounds[line] = new draw.Rectangle state.x, state.y, @dimensions[line].width, @dimensions[line].height

      # Move the text element to where we want it to go
      @textElement.setPosition new draw.Point state.x, state.y
  
  computePath: -> # Do nothing

  drawPath: (ctx) ->
    @textElement.draw ctx

  translate: (point) ->
    @textElement.translate point

    super

# # IndentView
# This is the renderer for and indent. It doesn't actually draw anything,
# but handles some coordinate placement.
class IndentView extends IceView
  constructor: (block) ->
    super block

  # ## computeChildren ##
  # We need to override this, because every Indent
  # starts with a newline. We don't actually want that
  # newline to be part of our rendering domain, so we
  # skip it.
  computeChildren: (line) ->
    super

    # Skip over the leading newline required by every indent
    @lineStart += 1

    return @lineEnd
  
  # ## computeDimensions ##
  # Like BlockView, this has height = max(child_heights),
  # width = sum(child_widths). An Indent, however, adds no padding.
  computeDimensions: ->
    super
    
    # If an indent is empty, then we don't actually want to deal with any lines.
    if @lineEnd >= @lineStart then for line in [@lineStart..@lineEnd]
      height = width = 0

      for child in @lineChildren[line]
        # Indents undertake no padding.
        width += child.dimensions[line].width
        height = Math.max height, child.dimensions[line].height

      height = Math.max height, EMPTY_INDENT_HEIGHT
      width = Math.max width, EMPTY_INDENT_WIDTH
      
      @dimensions[line] = new draw.Size width, height
    
  # ## computeBoundingBox ##
  # Delegate immediately to our children;
  # since we aren't planning to draw anything,
  # this function is pretty minimal.
  computeBoundingBox: (line, state) ->
    cursorX = state.x
    cursorY = state.y
    
    # Accept the bounds that our parent gave us
    @bounds[line] = new draw.Rectangle state.x, state.y, @dimensions[line].width, @dimensions[line].height

    for child in @lineChildren[line]
      child.computeBoundingBox line, new BoundingBoxState new draw.Point cursorX, cursorY
      
      cursorX += child.dimensions[line].width
  
  # ## computePath ##
  # We must override this method in order to produce a drop area
  # for drag-and-drop.
  computePath: ->
    @dropArea = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, @bounds[@lineStart].width, 10

    super

# # SocketView
# The renderer for a socket. When a socket is occupied
# by a block, it simply delegates all render tasks to the occupying block.
# However, if it is occupied by text or is empty, it will render itself
# appropriately. That is this class's responsibility.
class SocketView extends IceView
  constructor: (block) -> super block
  
  # ## computeDimensions ##
  # We add padding around text if that is what
  # we contain, but not around blocks. If we 
  # are empty, our dimensions are a default value
  # specified in the constants at the top of this
  # file.
  computeDimensions: ->
    super
    
    if (content = @block.content())? then switch @block.content().type
      when 'block'
        # If we contain a block, then we mimick that block
        for line, value of content.view.dimensions
          # (Clone the sizes of the contained block)
          @dimensions[line] = new draw.Size value.width, value.height

      when 'text'
        # If we contain some text, then we add padding around it.
        @dimensions[content.view.lineStart] = new draw.Size content.view.dimensions[content.view.lineStart].width + 2 * PADDING,
          content.view.dimensions[content.view.lineStart].height + 2 * PADDING
        
        # Don't allow ourselves to get smaller than an empty socket, though>
        @dimensions[content.view.lineStart].width = Math.max @dimensions[content.view.lineStart].width, EMPTY_SOCKET_WIDTH
    else
      @dimensions[@lineStart] = new draw.Size EMPTY_SOCKET_WIDTH, EMPTY_SOCKET_HEIGHT

    return @dimensions
  
  # ## computeBoundingBox ##
  # Again, we delegate to our content
  # block if it exists. If we have text as content,
  # we position the text as aligns with our added padding.
  # If we are empty, we simply accept the bounds our parent give us
  # and end.
  computeBoundingBox: (line, state) ->
    # Accept the bounds given by our parent
    @bounds[line] = new draw.Rectangle state.x, state.y, @dimensions[line].width, @dimensions[line].height
    
    if @lineChildren[line].length is 0 then return

    else if @lineChildren[line].length > 1
      # This is not allowed.
      throw 'Error: more than one child inside a socket'
    
    else if @block.content().type is 'text'
      # Add padding around the text
      @lineChildren[line][0].computeBoundingBox line, new BoundingBoxState new draw.Point state.x + PADDING, state.y + PADDING

    else
      # Delegate to our content block
      @lineChildren[line][0].computeBoundingBox line, state
  
  # ## computePath ##
  # We must override this to produce a drop area.
  # We have no drop area if we are filled by a block
  # (as we are not droppable).
  computePath: ->
    unless @block.content()?.type is 'block'
      (@dropArea = new draw.Rectangle()).copy @bounds[@lineStart]

    super
  
  # ## drawPath ##
  # If we are empty or contain text,
  # then we must draw the white rectangle.
  # Otherwise, simply delegate.
  drawPath: (ctx) ->
    if not @block.content()? or @block.content().type is 'text'
      # If we are empty, then draw our unit rectangle. If we have text inside, then draw the wrapping rectangle.
      @bounds[@lineStart].stroke ctx, '#000'
      @bounds[@lineStart].fill ctx, '#FFF'
    
    # Event propagate (this deals with block children)
    super

# # SegmentView
# The renderer for a Segment. Segments are meant to
# be entirely invisible, so this simply delegates to children
# and manages their y-coordinates as necessary (putting them
# one after another, if there are multiple children).
class SegmentView extends IceView
  constructor: (block) -> super block
  
  # ## computeDimensions ##
  # Like an Indent, height = max(child_heights),
  # width = sum(child_widths) for each line.
  computeDimensions: ->
    super

    for line in [@lineStart..@lineEnd]
      height = width = 0

      for child in @lineChildren[line]
        # Segments undertake no padding.
        width += child.dimensions[line].width
        height = Math.max height, child.dimensions[line].height
      
      @dimensions[line] = new draw.Size width, height
  
  # ## computeBoundingBox ##
  computeBoundingBox: (line, state) ->
    # A Segment can compute its bounds the same way an Indent does.
    cursorX = state.x
    cursorY = state.y

    # Accept the bounds that our parent gave us
    @bounds[line] = new draw.Rectangle state.x, state.y, @dimensions[line].width, @dimensions[line].height

    for child in @lineChildren[line]
      child.computeBoundingBox line, new BoundingBoxState new draw.Point cursorX, cursorY
      
      cursorX += child.dimensions[line].width
  
  # ## drawPath ##
  # We must override this to provide a drop area
  drawPath: ->
    @dropArea = new draw.Rectangle @bounds[@lineStart].x,
      @bounds[@lineStart].y - 5,
      Math.max(@bounds[@lineStart].width,MIN_SEGMENT_DROP_AREA_WIDTH),
      10

    super

# # CursorView
# This class is a bit degenerate;
# it's mainly used by the controller to determine the position
# at which a cursor was rendered. The drawing function for a cursor
# is actually the responsibility of the cursor's parent.
class CursorView
  constructor: (@block)->
    # This will be the point at which the cursor was drawn.
    @point = new draw.Point 0, 0
