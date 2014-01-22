###
# Copyright (c) 2014 Anthony Bau
# MIT License
#
# Rendering classes and functions for ICE editor.
###

# Constants
PADDING = 3
INDENT = 10
MOUTH_BOTTOM = 50
DROP_AREA_MAX_WIDTH = 50
FONT_SIZE = 15
EMPTY_INDENT_WIDTH = 50
PALETTE_WIDTH = 300
PALETTE_WHITESPACE = 10
MIN_INDENT_DROP_WIDTH = 20
EMPTY_SEGMENT_DROP_WIDTH = 100

###
# For developers, bits of policy:
# 1. Calling IcePaper.draw() must ALWAYS render the entire block and all its children.
# 2. ONLY IcePaper.compute() may modify the pointer value of @lineGroups or @bounds. Use copy() and clear().
###

# Test flag
window.RUN_PAPER_TESTS = false
window.PERFORMANCE_TEST = false

class IcePaper
  constructor: (@block) ->
    @point = new draw.Point 0, 0 # The top-left corner of this block
    @group = new draw.Group() # A Group containing all the elements. @group.draw() must draw all the elements.
    @bounds = {} # The bounding boxes of each state of this block
    @lineGroups = {} # Groups representing all the manifests at each line.
    @children = [] # All the child nodes
    
    @lineStart = @lineEnd = 0 # Start and end lines of this block

  # Recompute this block's line boundaries.
  compute: (state) -> this # For chaining, return self

  # Cement position
  finish: -> for child in @children then child.finish()

  # Draw this block's visual representation.
  draw: ->
  
  # Set the left center of the boundaries of line to (point)
  setLeftCenter: (line, point) ->

  # Translate by (vector)
  translate: (vector) -> @point.translate vector; @group.translate vector
  
  # Set position to (point)
  position: (point) -> @translate @point.from point

class BlockPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_lineChildren = {} # The child nodes at each line.
    @indented = {}
    @indentEnd = {}

  compute: (state) ->
    # Record all the indented states, 'cos we want to keep out of there
    @indented = {}
    @indentEnd = {}

    # Start a record of all the place that we want our container path to go
    @_pathBits = {} # Each element will look like so: [[leftEdge], [rightEdge]].
    
    # Reset all this stuff
    @bounds = {}
    @lineGroups = {}
    @children = []

    # Record our starting line
    @lineStart = state.line

    # Linked-list loop
    head = @block.start.next
    while head isnt @block.end
      switch head.type
        when 'text'
          @children.push head.paper.compute state
          @group.push head.paper.group
        
        when 'blockStart'
          @children.push head.block.paper.compute state
          @group.push head.block.paper.group
          head = head.block.end
        
        when 'indentStart'
          indent = head.indent.paper.compute state
          @children.push indent
          @group.push indent.group

          head = head.indent.end

        when 'socketStart'
          @children.push head.socket.paper.compute state
          @group.push head.socket.paper.group
          head = head.socket.end
        
        when 'newline'
          state.line += 1

      head = head.next

    # Record our ending line
    @lineEnd = state.line

    # Now we've assembled our child nodes; compute the bounding box for each line.

    # For speed reasons, we'll want to keep track of our index in @children globally.
    i = 0
    # We also need to keep track of the center y-coordinate of the line and the top y-coordinate of the line.
    top = 0
    axis = 0

    for line in [@lineStart..@lineEnd]
      # _lineGroups contains all the child blocks that lie on [line]
      @_lineChildren[line] = []

      # By our policy, it's our responsibility to initialize the @lineGroup, @_pathBits, and @bounds entries
      @_pathBits[line] =
        left: []
        right: []
      @lineGroups[line] = new draw.Group()
      @bounds[line] = new draw.NoRectangle()

      # First advance past any blocks that don't fit this line
      while i < @children.length and line > @children[i].lineEnd
        i += 1
      
      # Then consume any blocks that lie on this line
      while i < @children.length and line >= @children[i].lineStart and line <= @children[i].lineEnd # Test to see whether this line is within this child's domain
        @_lineChildren[line].push @children[i]
        i += 1

      # It's possible for a block to span multiple lines, so we back up to the last block on this line
      # in case it continues
      i -= 1
      
      # Compute the dimensions for this bounding box
      height = @_computeHeight line # This will use our @_lineChildren to compute {width, height}
      axis = top + height / 2
      
      # Snap this line into position. This uses our @_lineChildren to generate @lineGroups, @bounds, and @_pathBits
      @setLeftCenter line, new draw.Point 0, axis

      # Increment (top) to the top of the next line
      top += @bounds[line].height

    # We're done! Return (this) for chaining.
    return this
  
  _computeHeight: (line) ->
    height = 0
    _heightModifier = 0
    for child in @_lineChildren[line]
      if child.block.type is 'indent' and line is child.lineEnd
        height = Math.max(height, child.bounds[line].height + 10)
      else
        height = Math.max(height, child.bounds[line].height)

    if @indented[line] or @_lineChildren[line].length > 0 and @_lineChildren[line][0].block.type is 'indent' then height -= 2 * PADDING

    return height + 2 * PADDING

  setLeftCenter: (line, point) ->
    # Get ready to iterate through the children at this line
    cursor = point.clone() # The place we want to move this child's boundaries

    cursor.add PADDING, 0
    @lineGroups[line].empty()
    @_pathBits[line].left.length = 0
    @_pathBits[line].right.length = 0

    @bounds[line].clear()
    @bounds[line].swallow point

    _bottomModifier = 0

    topPoint = null

    @indented[line] = @indentEnd[line] = false
    
    # TODO improve performance here
    indentChild = null


    for child, i in @_lineChildren[line]
      if i is 0 and child.block.type is 'indent' # Special case
        @indented[line] = true
        @indentEnd[line] = (line is child.lineEnd) or child.indentEnd[line]

        # Add the indent bit
        cursor.add INDENT, 0

        indentChild = child

        child.setLeftCenter line, new draw.Point cursor.x, cursor.y - @_computeHeight(line) / 2 + child.bounds[line].height / 2

        # Deal with the special case of an empty indent
        if child.bounds[line].height is 0
          # This is hacky.
          @_pathBits[line].right.push topPoint = new draw.Point child.bounds[line].x, child.bounds[line].y
          @_pathBits[line].right.push new draw.Point child.bounds[line].x, child.bounds[line].y + 10
          @_pathBits[line].right.push new draw.Point child.bounds[line].right(), child.bounds[line].y + 10
          if @_lineChildren[line].length > 1
            @_pathBits[line].right.push new draw.Point child.bounds[line].right(), child.bounds[line].y - 5 - PADDING
        else
          # Make sure to wrap our path around this indent line (or to the left of it)
          @_pathBits[line].right.push topPoint = new draw.Point child.bounds[line].x, child.bounds[line].y
          @_pathBits[line].right.push new draw.Point child.bounds[line].x, child.bounds[line].bottom()

          if line is child.lineEnd and @_lineChildren[line].length > 1 # If there's anyone else here
            # Also wrap the "G" shape
            @_pathBits[line].right.push new draw.Point child.bounds[line].right(), child.bounds[line].bottom()
            @_pathBits[line].right.push new draw.Point child.bounds[line].right(), child.bounds[line].y

          # Circumvent the normal "bottom edge", since we need extra space at the bottom
        if child.lineEnd is line
          _bottomModifier += INDENT

      else
        @indented[line] = @indented[line] or (if child.indented? then child.indented[line] else false)
        @indentEnd[line] = @indentEnd[line] or (if child.indentEnd? then child.indentEnd[line] else false)
        if child.indentEnd? and child.indentEnd[line]
          child.setLeftCenter line, new draw.Point cursor.x, cursor.y - @_computeHeight(line) / 2 + child.bounds[line].height / 2
        else
          child.setLeftCenter line, cursor

      @lineGroups[line].push child.lineGroups[line]
      @bounds[line].unite child.bounds[line]
      cursor.add child.bounds[line].width, 0


    # Add padding
    unless @indented[line]
      @bounds[line].width += PADDING
      @bounds[line].y -= PADDING
      @bounds[line].height += PADDING * 2

    
    if topPoint? then topPoint.y = @bounds[line].y

    # Add the left edge
    @_pathBits[line].left.push new draw.Point @bounds[line].x, @bounds[line].y # top
    @_pathBits[line].left.push new draw.Point @bounds[line].x, @bounds[line].bottom() + _bottomModifier # bottom

    # Add the right edge
    if @indentEnd[line] and @_lineChildren[line].length > 1
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].y
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom() + _bottomModifier

    else if @indented[line] and not(@_lineChildren[line][0].block.type is 'indent' and @_lineChildren[line][0].lineEnd is line) # If we're inside this indent
      @_pathBits[line].right.push new draw.Point @bounds[line].x + INDENT + PADDING, @bounds[line].y
      @_pathBits[line].right.push new draw.Point @bounds[line].x + INDENT + PADDING, @bounds[line].bottom()

    else if @_lineChildren[line][0].block.type is 'indent' and @_lineChildren[line][0].lineEnd is line
      if @_lineChildren[line].length > 1
        @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].y
        @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom() + _bottomModifier
      else
        @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom()
        @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom() + _bottomModifier

      @bounds[line].height += 10

    else
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].y # top
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom() + _bottomModifier #bottom

  finish: ->
    @_container = new draw.Path()

    # Assemble our path from the recorded @_pathBits
    for line of @_pathBits
      for bit in @_pathBits[line].left
        @_container.unshift bit
      for bit in @_pathBits[line].right
        @_container.push bit

    # Do some styling
    @_container.style.strokeColor='#000'
    @_container.style.fillColor = @block.color

    @dropArea = new draw.Rectangle @bounds[@lineEnd].x, @bounds[@lineEnd].bottom() - 5, @bounds[@lineEnd].width, 10
    
    # Propagate this event
    for child in @children
      child.finish()

  draw: (ctx) ->
    # Draw
    @_container.draw ctx

    # And propagate
    for child in @children
      child.draw ctx

  translate: (vector) ->
    @point.translate vector
    
    for line of @bounds
      @lineGroups[line].translate vector
      @bounds[line].translate vector
    
    for line, bit of @_pathBits
      for point in bit.left
        point.translate vector
      for point in bit.right
        point.translate vector

    for child in @children
      child.translate vector

class SocketPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_empty = false # Is this block empty?
    @_content = null # If not empty, who is filling us?
    @_line = 0 # What line is this socket on, if empty?
    @indented = {}
    @children = []

  compute: (state) ->
    @bounds = {}
    @lineGroups = {}
    @group = new draw.Group()
    @dropArea = null
    
    # Check to see if the tree here has a child
    if (@_content = @block.content())?
      # If so, ask it to compute itself
      (contentPaper = @_content.paper).compute state

      # Then copy all of its properties. By our policy, this will stay current until it calls compute(),
      # Which shouldn't happen unless we recompute as well.
      for line of contentPaper.bounds
        if @_content.type is 'text'
          @_line = state.line
          @bounds[line] = new draw.NoRectangle()
          @bounds[line].copy contentPaper.bounds[line]

          # We add padding around text
          @bounds[line].y -= PADDING
          @bounds[line].width += 2 * PADDING
          @bounds[line].x -= PADDING
          @bounds[line].height += 2 * PADDING

          # If our width is less than 20px we extend ourselves
          @bounds[line].width = Math.max(@bounds[line].width, 20)

          @dropArea = @bounds[line]
        else
          @bounds[line] = contentPaper.bounds[line]
        @lineGroups[line] = contentPaper.lineGroups[line]

      
      @indented = @_content.paper.indented
      @indentEnd = @_content.paper.indentEnd

      @group = contentPaper.group
      @children = [@_content.paper]

      @lineStart = contentPaper.lineStart
      @lineEnd = contentPaper.lineEnd

    else
      @dropArea = @bounds[state.line] = new draw.Rectangle 0, 0, 20, 20
      @lineStart = @lineEnd = @_line = state.line
      @children = []
      @indented = {}
      @indented[@_line] = false

      @lineGroups[@_line] = new draw.Group()

    @_empty = not @_content? or @_content.type is 'text'

    # We're done! Return ourselves for chaining
    return this

  setLeftCenter: (line, point) ->
    if @_content?

      if @_content.type is 'text'
        line = @_content.paper._line

        @_content.paper.setLeftCenter line, new draw.Point point.x + PADDING, point.y

        @bounds[line].copy @_content.paper.bounds[line]

        # We add padding around text
        @bounds[line].y -= PADDING
        @bounds[line].width += 2 * PADDING
        @bounds[line].x -= PADDING
        @bounds[line].height += 2 * PADDING

        # If our width is less than 20px we extend ourselves
        @bounds[line].width = Math.max(@bounds[line].width, 20)
      else
        # Try to give this task to our content block instead
        @_content.paper.setLeftCenter line, point

      @lineGroups[line].recompute()
    else
      # If that's not possible move our little empty square
      @bounds[line].x = point.x
      @bounds[line].y = point.y - @bounds[line].height / 2
      @lineGroups[line].setPosition new draw.Point point.x, point.y - @bounds[line].height / 2

  draw: (ctx) ->
    if @_content?
      # Draw the wrapper for input-like content if necessary
      if @_content.type is 'text'
        line = @_content.paper._line
        ctx.strokeStyle = '#000'
        ctx.fillStyle = '#fff'
        ctx.fillRect @bounds[line].x, @bounds[line].y, @bounds[line].width, @bounds[line].height
        ctx.strokeRect @bounds[line].x, @bounds[line].y, @bounds[line].width, @bounds[line].height

      # Try to imitate our content block
      @_content.paper.draw ctx
    else
      # If that's not possible, draw our little empty square
      rect = @bounds[@_line]
      ctx.strokeStyle = '#000'
      ctx.fillStyle = '#fff'
      ctx.fillRect rect.x, rect.y, rect.width, rect.height
      ctx.strokeRect rect.x, rect.y, rect.width, rect.height

  translate: (vector) ->
    # Try to delegate
    if @_content?
      @_content.paper.translate vector
      
      # Manage things if they are text
      if @_content.type is 'text'
        line = @_content.paper._line

        @bounds[line].copy @_content.paper.bounds[line]

        # We add padding around text
        @bounds[line].y -= PADDING
        @bounds[line].width += 2 * PADDING
        @bounds[line].x -= PADDING
        @bounds[line].height += 2 * PADDING

        # If our width is less than 20px we extend ourselves
        @bounds[line].width = Math.max(@bounds[line].width, 20)
    else
      @bounds[@_line].translate vector


class IndentPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_lineBlocks = {} # Which block occupies each line?

  compute: (state) ->
    @bounds = {}
    @lineGroups = {}
    @_lineBlocks = {}
    @indentEnd = {}
    @group = new draw.Group()
    @children = []
    
    # We need to record our starting line
    @lineStart = state.line += 1

    # In an Indent, each line contains exactly one block. So that's all we have to consider.
    head = @block.start.next.next # Note here that we skip over this indent's leading newline

    # This is a hack to deal with empty indents
    if @block.start.next is @block.end then head = @block.end

    # Loop
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          @children.push head.block.paper.compute state
          @group.push head.block.paper.group
          head = head.block.end

        when 'newline'
          state.line += 1

      head = head.next
    
    @lineEnd = state.line

    # Now go through and mimic all the blocks on each line
    
    if @children.length > 0
      i = 0 # Again, performance reasons
      for line in [@lineStart..@lineEnd]
        # If we need to move on to the next block, do so
        until line <= @children[i].lineEnd
          i += 1

        # Copy the block we're on here
        @bounds[line] = @children[i].bounds[line]
        @lineGroups[line] = new draw.Group()
        @indentEnd[line] = @children[i].indentEnd[line]
        @lineGroups[line].push @children[i].lineGroups[line]
        @_lineBlocks[line] = @children[i]
    else
      # We're an empty indent.
      @lineGroups[@lineStart] = new draw.Group()
      @_lineBlocks[@lineStart] = null
      @bounds[@lineStart] = new draw.Rectangle 0, 0, EMPTY_INDENT_WIDTH, 0
    
    # We're done! Return ourselves for chaining.
    return this

  finish: ->
    @dropArea = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, Math.max(@bounds[@lineStart].width, MIN_INDENT_DROP_WIDTH), 10
    for child in @children
      child.finish()
  
  setLeftCenter: (line, point) ->
    # Delegate right away.
    if @_lineBlocks[line]?
      @_lineBlocks[line].setLeftCenter line, point
      @lineGroups[line].recompute()
    else
      @bounds[@lineStart].clear()
      @bounds[@lineStart].swallow(point)
      @bounds[@lineStart].width = EMPTY_INDENT_WIDTH

  draw: (ctx) ->
    # Delegate right away.
    for child in @children
      child.draw ctx

  translate: (vector) ->
    @point.add vector
    
    # If we are empty, we are responsible for translating ourselves
    if @bounds[@lineStart].height is 0 then @bounds[@lineStart].translate vector

    # Otherwise, delegate right away.
    for child in @children
      child.translate vector

  setPosition: (point) -> @translate point.from @point

class SegmentPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_lineBlocks = {} # Which block occupies each line?

  compute: (state) ->
    @bounds = {}
    @lineGroups = {}
    @_lineBlocks = {}
    @indentEnd = {}
    @group = new draw.Group()
    @children = []
    
    # We need to record our starting line
    @lineStart = state.line += 1

    # In a Segment, each line contains exactly one block. So that's all we have to consider.
    head = @block.start.next

    # This is a hack to deal with empty indents
    if @block.start.next is @block.end then head = @block.end

    # Loop
    running_height = 0
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          @children.push head.block.paper.compute state
          head.block.paper.translate new draw.Point 0, running_height
          running_height = head.block.paper.bounds[head.block.paper.lineEnd].bottom()
          @group.push head.block.paper.group
          head = head.block.end

        when 'newline'
          state.line += 1

      head = head.next

    @lineEnd = state.line

    # Now go through and mimic all the blocks on each line
    
    # If we're empty, then return immediately.
    if @children.length is 0
      @bounds[state.line] = new draw.Rectangle 0, 0, 0, 0
      return this
    
    i = 0 # Again, performance reasons
    for line in [@lineStart..@lineEnd]
      # If we need to move on to the next block, do so
      until line <= @children[i].lineEnd
        i += 1

      # Copy the block we're on here
      @bounds[line] = @children[i].bounds[line]
      @lineGroups[line] = new draw.Group()
      @indentEnd[line] = @children[i].indentEnd[line]
      @lineGroups[line].push @children[i].lineGroups[line]
      @_lineBlocks[line] = @children[i]
    
    # We're done! Return ourselves for chaining.
    return this
  
  prepBounds: ->
    @bounds = {}
    @lineGroups = {}
    @_lineBlocks = {}
    @indentEnd = {}
    @group = new draw.Group()
    @children = []
    
    # We need to record our starting line
    @lineStart = Infinity
    @lineEnd = 0

    # In a Segment, each line contains exactly one block. So that's all we have to consider.
    head = @block.start.next

    # This is a hack to deal with empty indents
    if @block.start.next is @block.end then head = @block.end

    # Loop
    running_height = 0
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          @children.push head.block.paper
          @lineStart = Math.min @lineStart, head.block.paper.lineStart
          @lineEnd = Math.max @lineEnd, head.block.paper.lineEnd
          head = head.block.end

      head = head.next

    # Now go through and mimic all the blocks on each line
    
    i = 0 # Again, performance reasons
    for line in [@lineStart..@lineEnd]
      # If we need to move on to the next block, do so
      until line <= @children[i].lineEnd
        i += 1

      # Copy the block we're on here
      @bounds[line] = @children[i].bounds[line]
    
    # We're done! Return ourselves for chaining.
    return this

  getBounds: ->
    # In a Segment, each line contains exactly one block. So that's all we have to consider.
    head = @block.start.next

    # This is a hack to deal with empty indents
    if @block.start.next is @block.end then head = @block.end

    bounds = new draw.NoRectangle()

    # Loop
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          bounds.unite head.block.paper._container.bounds()

      head = head.next

    return bounds

  finish: ->
    @dropArea = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, Math.max(@bounds[@lineStart].width, MIN_INDENT_DROP_WIDTH), 10
    # For empty files, this should be a bit easier.
    if @bounds[@lineStart].width is 0
      @dropArea.width = EMPTY_SEGMENT_DROP_WIDTH

    for child in @children
      child.finish()
  
  setLeftCenter: (line, point) ->
    # Delegate right away.
    if @_lineBlocks[line]?
      @_lineBlocks[line].setLeftCenter line, point
      @lineGroups[line].recompute()
    else
      @bounds[@lineStart].clear()
      @bounds[@lineStart].swallow(point)
      @bounds[@lineStart].width = EMPTY_INDENT_WIDTH

  draw: (ctx) ->
    # Delegate right away.
    for child in @children
      child.draw ctx

  translate: (vector) ->
    @point.add vector

    # Delegate right away.
    for child in @children
      child.translate vector

  setPosition: (point) -> @translate point.from @point

class TextTokenPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_line = 0

  compute: (state) ->
    # Init everything
    @lineStart = @lineEnd = @_line = state.line
    @lineGroups = {}
    @bounds = {}

    @group = @lineGroups[@_line] = new draw.Group()
    @lineGroups[@_line].push @_text = new draw.Text(new draw.Point(0, 0), @block.value)
    @bounds[@_line] = @_text.bounds()
    
    # Return ourselves for chaining
    return this

  draw: (ctx) ->
    @_text.draw ctx
  
  setLeftCenter: (line, point) ->
    if line is @_line
      # Again, by policy, our @bounds should be changed automatically
      @_text.setPosition new draw.Point point.x, point.y - @bounds[@_line].height / 2
      @lineGroups[@_line].recompute()

  translate: (vector) ->
    @_text.translate vector
