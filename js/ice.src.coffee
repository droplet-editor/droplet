###
# Copyright (c) 2014 Anthony Bau.
# MIT License.
#
# Tree classes and operations for ICE editor.
###

exports = {}

###
# A Block is a bunch of tokens that are grouped together.
###
exports.Block = class Block
  constructor: (contents) ->
    @start = new BlockStartToken this
    @end = new BlockEndToken this
    @type = 'block'
    @color = '#ddf'

    # Fill up the linked list with the array of tokens we got.
    head = @start
    for token in contents
      head = head.append token.clone()
    head.append @end

    @paper = new BlockPaper this

  embedded: -> @start.prev.type is 'socketStart'

  contents: ->
    # The Contents of a block are everything between the start and end.
    contents = []
    head = @start
    while head isnt @end
      contents.push head
      head = head.next
    contents.push @end
    return contents
  
  clone: ->
    clone = new Block []
    clone.color = @color
    head = @start.next
    cursor = clone.start
    while head isnt @end
      switch head.type
        when 'blockStart'
          block_clone = head.block.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.block.end
        when 'socketStart'
          block_clone = head.socket.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.socket.end
        when 'indentStart'
          block_clone = head.indent.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.indent.end
        else
          cursor = cursor.append head.clone()
      head = head.next
    cursor.append clone.end

    return clone
  
  lines: ->
    # The Lines of a block are the \n-separated lists of tokens between the start and end.
    contents = []
    currentLine = []
    head = @start
    while head isnt @end
      contents.push head
      if head.type is 'newline'
        contents.push currentLine
        currentLine = []
      head = head.next
    currentLine.push @end
    contents.push currentLine
    return contents
  
  _moveTo: (parent) ->
    # Check for empty segments
    while @start.prev? and @start.prev.type is 'segmentStart' and @start.prev.segment.end is @end.next
      console.log 'removing a segment'
      @start.prev.segment.remove()

    # Don't leave empty lines behind
    if @end.next? and @start.prev?
      last = @end.next
      while last? and last.type is 'segmentEnd' then last = last.next

      first = @start.prev
      while first? and first.type is 'segmentStart' then first = first.prev

      if first? and first.type is 'newline' and ((not last?) or last.type is 'newline')
        first.remove()
      else if last? and last.type is 'newline' and ((not first?) or first.type is 'newline')
        last.remove()

    # Unsplice ourselves
    if @start.prev? then @start.prev.next = @end.next
    if @end.next? then @end.next.prev = @start.prev
    @start.prev = @end.next = null
    
    # Splice ourselves into the requested parent
    if parent?
      @end.next = parent.next
      parent.next.prev = @end

      parent.next= @start
      @start.prev = parent
  
  findBlock: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.findBlock f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    if f this then return this
    else return null
  
  findSocket: (f) ->
    head = @start.next
    while head isnt @end
      if head.type is 'socketStart' and f(head.socket) then return head.socket.findSocket f
      head = head.next
    return null
  
  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    if f this then return this
    else return null
  
  # TODO This is really only usable for debugging
  toString: ->
    string = @start.toString indent: ''
    return string[..string.length-@end.toString(indent: '').length-1]

exports.Indent = class Indent
  constructor: (contents, @depth) ->
    @start = new IndentStartToken this
    @end = new IndentEndToken this
    @type = 'indent'
    
    head = @start
    for block in contents
      head = head.append block.clone()
    head.append @end
    
    @paper = new IndentPaper this

  clone: ->
    clone = new Indent [], @depth
    head = @start.next
    cursor = clone.start
    while head isnt @end
      switch head.type
        when 'blockStart'
          block_clone = head.block.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.block.end
        when 'socketStart'
          block_clone = head.socket.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.socket.end
        when 'indentStart'
          block_clone = head.indent.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.indent.end
        else
          cursor = cursor.append head.clone()
      head = head.next
    cursor.append clone.end

    return clone

  embedded: -> false

  # TODO This is really only usable for debugging
  toString: (state) ->
    string = @start.toString(state)
    return string[...string.length-@end.toString(state).length-1]

  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    if f this then return this
    else return null

exports.Segment = class Segment
  constructor: (contents) ->
    @start = new SegmentStartToken this
    @end = new SegmentEndToken this
    @type = 'segment'
    
    head = @start
    for block in contents
      head = head.append block.clone()
    head.append @end
    
    @paper = new SegmentPaper this

  clone: ->
    clone = new Segment []
    head = @start.next
    cursor = clone.start
    while head isnt @end
      switch head.type
        when 'blockStart'
          block_clone = head.block.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.block.end
        when 'socketStart'
          block_clone = head.socket.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.socket.end
        when 'indentStart'
          block_clone = head.indent.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.indent.end
        else
          cursor = cursor.append head.clone()
      head = head.next
    cursor.append clone.end

    return clone

  embedded: -> false

  remove: ->
    @start.remove()
    @end.remove()
    @start.next = @end
    @end.prev = @start

  _moveTo: (parent) ->
    # Check for empty segments
    while @start.prev? and @start.prev.type is 'segmentStart' and @start.prev.segment.end is @end.next
      @start.prev.segment.remove()

    # Don't leave empty lines behind
    if @end.next? and @start.prev?
      last = @end.next
      while last? and last.type is 'segmentEnd' then last = last.next

      first = @start.prev
      while first? and first.type is 'segmentStart' then first = first.prev

      if first? and first.type is 'newline' and ((not last?) or last.type is 'newline')
        first.remove()
      else if last? and last.type is 'newline' and ((not first?) or first.type is 'newline')
        last.remove()

    # Unsplice ourselves
    if @start.prev? then @start.prev.next = @end.next
    if @end.next? then @end.next.prev = @start.prev
    @start.prev = @end.next = null
    
    # Splice ourselves into the requested parent
    if parent?
      @end.next = parent.next
      parent.next.prev = @end

      parent.next= @start
      @start.prev = parent
  
  findBlock: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block)
        return head.block.findBlock f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    return null
  
  findSocket: (f) ->
    head = @start.next
    while head isnt @end
      if head.type is 'socketStart' and f(head.socket) then return head.socket.findSocket f
      head = head.next
    return null
  
  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    if f(this) then return this
    else return null
  
  toString: ->
    start = @start.toString(indent: '')
    return start[...start.length-@end.toString(indent: '').length]

exports.Socket = class Socket
  constructor: (content) ->
    @start = new SocketStartToken this
    @end = new SocketEndToken this
    
    if content? and content.start?
      
      @start.next = content.start
      content.start.prev = @start

      @end.prev = content.end
      content.end.next = @end

    else if content?

      @start.next = content
      content.prev = @start

      @end.prev = content
      content.next = @end

    else
      @start.next = @end
      @end.prev = @start

    @type = 'socket'

    @paper = new SocketPaper this

  clone: -> if @content()? then new Socket @content().clone() else new Socket()
  
  embedded: -> false

  content: ->
    unwrap = (el) ->
      switch el.type
        when 'blockStart' then return el.block
        when 'segmentStart' then return unwrap el.next
        else return el
    if @start.next isnt @end
      return unwrap @start.next
    else
      return null

  findSocket: (f) ->
    head = @start.next
    while head isnt @end
      if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    if f this then return this
    else return null

  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    if f this then return this
    else return null

  toString: -> if @content()? then @content().toString({indent:''}) else ''
  
exports.Token = class Token
  constructor: ->
    @prev = @next = null

  append: (token) ->
    token.prev = this
    @next = token

  insert: (token) ->
    if @next?
      token.next = @next
      @next.prev = token
    token.prev = this
    @next = token
    return @next

  remove: ->
    if @prev? then @prev.next = @next
    if @next? then @next.prev = @prev
    @prev = @next = null

  toString: (state) -> if @next? then @next.toString(state) else ''

###
# Special kinds of tokens
###
exports.TextToken = class TextToken extends Token
  constructor: (@value) ->
    @prev = @next = null
    @paper = new TextTokenPaper this
    @type = 'text'

  clone: -> new TextToken @value

  toString: (state) ->
    @value + if @next? then @next.toString(state) else ''

exports.BlockStartToken = class BlockStartToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockStart'

exports.BlockEndToken = class BlockEndToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockEnd'

exports.NewlineToken = class NewlineToken extends Token
  constructor: ->
    @prev = @next = null
    @type = 'newline'

  clone: -> new NewlineToken()

  toString: (state) ->
    '\n' + state.indent + if @next then @next.toString(state) else ''

exports.IndentStartToken = class IndentStartToken extends Token
  constructor: (@indent) ->
    @prev = @next =  null
    @type = 'indentStart'

  toString: (state) ->
    state.indent += (' ' for [1..@indent.depth]).join ''
    if @next then @next.toString(state) else ''

exports.IndentEndToken = class IndentEndToken extends Token
  constructor: (@indent) ->
    @prev = @next =  null
    @type = 'indentEnd'

  toString: (state) ->
    state.indent = state.indent[...-@indent.depth]
    if @next then @next.toString(state) else ''

exports.SocketStartToken = class SocketStartToken extends Token
  constructor: (@socket) ->
    @prev = @next = null
    @type = 'socketStart'

exports.SocketEndToken = class SocketEndToken extends Token
  constructor: (@socket) ->
    @prev = @next = null
    @type = 'socketEnd'

exports.SegmentStartToken = class SegmentStartToken extends Token
  constructor: (@segment) ->
    @prev = @next = null
    @type = 'segmentStart'

exports.SegmentEndToken = class SegmentEndToken extends Token
  constructor: (@segment) ->
    @prev = @next = null
    @type = 'segmentEnd'

###
# Example LISP parser/
###

exports.lispParse = (str) ->
  currentString = ''
  first = head = new TextToken ''
  block_stack = []
  socket_stack = []

  for char in str
    switch char
      when '('
        head = head.append new TextToken currentString

        # Make a new Block
        block_stack.push block = new Block []
        socket_stack.push socket = new Socket block
        head = head.append socket.start
        head = head.append block.start

        # Append the paren
        head = head.append new TextToken '('
        
        currentString = ''
      when ')'
        # Append the current string
        head = head.append new TextToken currentString
        head = head.append new TextToken ')'
        
        # Pop the Block
        head = head.append block_stack.pop().end
        head = head.append socket_stack.pop().end

        currentString = ''
      when ' '
        head = head.append new TextToken currentString
        head = head.append new TextToken ' '

        currentString = ''

      when '\n'
        head = head.append new TextToken currentString
        head = head.append new NewlineToken()

        currentString = ''
      else
        currentString += char
  
  head = head.append new TextToken currentString
  return first

exports.indentParse = (str) ->
  # Then generate the ICE token list
  head = first = new TextToken ''
  
  stack = []
  depth_stack = [0]
  for line in str.split '\n'
    indent = line.length - line.trimLeft().length

    # Push if needed
    if indent > _.last depth_stack
      head = head.append (new Indent([], indent - _.last(depth_stack))).start
      stack.push head.indent
      depth_stack.push indent

    # Pop if needed
    while indent < _.last depth_stack
      head = head.append stack.pop().end
      depth_stack.pop()

    head = head.append new NewlineToken()
    
    currentString = ''
    for char in line.trimLeft()
      switch char
        when '('
          if currentString.length > 0 then head = head.append new TextToken currentString

          # Make a new Block
          if stack.length > 0 and _.last(stack).type is 'block'
            stack.push socket = new Socket block
            head = head.append socket.start
          stack.push block = new Block []
          head = head.append block.start

          # Append the paren
          head = head.append new TextToken '('
          
          currentString = ''
        when ')'
          # Append the current string
          if currentString.length > 0 then head = head.append new TextToken currentString

          # Pop the indents
          popped = {}
          while popped.type isnt 'block'
            popped = stack.pop()
            if popped.type is 'block'
              # Append the paren if necessary
              head = head.append new TextToken ')'
            # Append the close-tag
            head = head.append popped.end
            if head.type is 'indentEnd' then depth_stack.pop()
          
          # Pop the blocks
          if stack.length > 0 and _.last(stack).type is 'socket' then head = head.append stack.pop().end

          currentString = ''
        when ' '
          if currentString.length > 0 then head = head.append new TextToken currentString
          head = head.append new TextToken ' '

          currentString = ''
        else
          currentString += char
    if currentString.length > 0 then head = head.append new TextToken currentString

  # Empty the stack
  while stack.length > 0 then head = head.append stack.pop().end
  
  return first.next.next

window.ICE = exports

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

out = null

exports.Editor = class Editor
  constructor: (el) ->
    # Create all the necessary canvases
    canvas = document.createElement 'canvas'; canvas.className = 'canvas'
    canvas.height = el.offsetHeight
    canvas.width = el.offsetWidth - PALETTE_WIDTH

    paletteCanvas = document.createElement 'canvas'; paletteCanvas.className = 'palette'
    paletteCanvas.height = el.offsetHeight
    paletteCanvas.width = PALETTE_WIDTH
    
    dragCanvas = document.createElement 'canvas'; dragCanvas.className = 'drag'
    dragCanvas.height = el.offsetHeight
    dragCanvas.width = el.offsetWidth - PALETTE_WIDTH

    # Create the tracking div
    div = document.createElement 'div'; div.className = 'trackArea'
    
    # Append them all
    el.appendChild canvas
    el.appendChild dragCanvas
    el.appendChild paletteCanvas
    el.appendChild div
    
    # Get contexts
    ctx = canvas.getContext '2d'
    dragCtx = dragCanvas.getContext '2d'
    paletteCtx = paletteCanvas.getContext '2d'
    
    # Do a hack for text measurement
    draw._setCTX ctx

    tree = coffee.parse '''
      window.onload = ->
        if document.getElementsByClassName('test').length > 0
          for [1..10]
            document.body.appendChild document.createElement 'script'
          alert 'found a test element'
        document.getElementsByTagName('button').onclick = ->
          alert 'somebody clicked a button'
    '''

    ###
    # Dragging
    ###
    scrollOffset = new draw.Point 0, 0 # How far have we scrolled down?
    highlight = null # Highlighted drop area
    selection = null # Selected (dragged) text
    offset = null # Dragging offset

    ###
    # Hidden input hack
    ###
    input = null # Hidden html input for text input
    focus = null # Focused segment that we are modifying
    anchor = head = null # Selected text
    
    ###
    # Lasso select
    ####
    lassoAnchor = null # These will be draw.Points.
    lassoHead = null
    lassoSegment = null # This will be an ICE.Segment
    lassoBounds = null

    # "Root" blocks, floating in space
    floating_blocks = []
    
    # Clear the main canvas
    clear = ->
      ctx.clearRect scrollOffset.x, scrollOffset.y, canvas.width, canvas.height

    # Recompute and redraw. Benchmarked to around 1.142 mils.
    redraw = ->
      clear()
      tree.segment.paper.compute {line: 0}
      tree.segment.paper.finish()
      tree.segment.paper.draw ctx
      out.value = tree.segment.toString {indent: ''}

      if lassoSegment? then lassoSegment.paper.prepBounds()

      for block in floating_blocks
        block.block.paper.compute line: 0
        block.block.paper.translate block.position
        block.block.paper.finish()
        block.block.paper.draw ctx
      
      if lassoSegment?
        unless lassoSegment is selection
          (lassoBounds = lassoSegment.paper.getBounds()).stroke ctx, '#000'
          lassoBounds.fill ctx, 'rgba(0, 0, 256, 0.3)'
    
    # Just redraw (no recompute)
    fastDraw = ->
      clear()
      tree.segment.paper.draw ctx

      for block in floating_blocks
        block.block.paper.draw ctx

      if lassoSegment?
        unless lassoSegment is selection
          lassoBounds.stroke ctx, '#000'
          lassoBounds.fill ctx, 'rgba(0, 0, 256, 0.3)'
    
    redraw()

    ###
    # Here to below will eventually become part of the IceEditor() class
    ###
    
    div.addEventListener 'touchstart', div.onmousedown = (event) ->
      if event.offsetX?
        point = new draw.Point event.offsetX, event.offsetY
      else
        point = new draw.Point event.layerX, event.layerY
      point.add -PALETTE_WIDTH, 0
      point.translate scrollOffset

      # First, see if we are trying to focus an empty socket
      focus = tree.segment.findSocket (block) ->
        block.paper._empty and block.paper.bounds[block.paper._line].contains point

      if focus?
        # Insert the text token we're editing
        if focus.content()? then text = focus.content()
        else focus.start.insert text = new TextToken ''

        if input? then input.parentNode.removeChild input

        # Append the hidden input
        document.body.appendChild input = document.createElement 'input'
        input.className = 'hidden_input'
        line = focus.paper._line
        
        input.value = focus.content().value

        # Here we have to abuse the fact that we use a monospace font (we could do this in linear time otherwise, but this is neat)
        anchor = head = Math.round((start = point.x - focus.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width)
        
        # Do an immediate redraw
        redraw()

        # Bind the update to the input's key handlers
        input.addEventListener 'input',  input.onkeydown = input.onkeyup = input.onkeypress = ->
          text.value = this.value
          
          # Recompute the socket itself
          text.paper.compute line: line
          focus.paper.compute line: line
          
          # Ask the root to recompute the line that we're on (automatically shift everything to the right of us)
          # This is for performance reasons; we don't need to redraw the whole tree.
          old_bounds = tree.segment.paper.bounds[line].y
          tree.segment.paper.setLeftCenter line, new draw.Point 0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2
          if tree.segment.paper.bounds[line].y isnt old_bounds
            # This is totally hacky patch for a bug whose source I don't know.
            tree.segment.paper.setLeftCenter line, new draw.Point 0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2 - 1
          tree.segment.paper.finish()
          
          # Do the fast draw operation and toString() operation.
          fastDraw()
          out.value = tree.segment.toString {indent: ''}

          # Draw the typing cursor
          start = text.paper.bounds[line].x + ctx.measureText(this.value[...this.selectionStart]).width
          end = text.paper.bounds[line].x + ctx.measureText(this.value[...this.selectionEnd]).width

          if start is end
            ctx.strokeRect start, text.paper.bounds[line].y, 0, 15
          else
            ctx.fillStyle = 'rgba(0, 0, 256, 0.3)'
            ctx.fillRect start, text.paper.bounds[line].y, end - start, 15

        setTimeout (->
          input.focus()
          input.setSelectionRange anchor, anchor
          input.dispatchEvent(new CustomEvent('input'))
        ), 0

      else
        # See if we picked up the lasso
        if lassoSegment? and lassoBounds.contains point
          selection = lassoSegment
        else
          # Immediately unlasso
          if lassoSegment?
            if lassoSegment.start.prev? # This will mean that lassoSegment is not a root segment
              console.log lassoSegment.start.prev
              lassoSegment.remove()
            lassoSegment = null
          # Find the block that was just clicked
          selection = tree.segment.findBlock (block) ->
            block.paper._container.contains point
          
        # We aren't copying from the palette
        cloneLater = false

        unless selection?
          selection = null
          for block, i in floating_blocks
            if block.block.findBlock((x) -> x.paper._container.contains point)?
              floating_blocks.splice i, 1
              selection = block.block
              break
            else selection = null

          unless selection?
            # See if we matched any palette blocks
            shiftedPoint = new draw.Point point.x + PALETTE_WIDTH, point.y
            shiftedPoint.add -scrollOffset.x, -scrollOffset.y

            for block in palette_blocks
              if block.findBlock((x) -> x.paper._container.contains shiftedPoint)?
                # We're grabbing this block
                selection = block

                # Actually, we are copying from the palette
                cloneLater = true
                break
              else selection = null

        if selection?
          ### 
          # We've now found the selected text, move it as necessary.
          ###

          # Remove the newline before, if necessary
          if selection.start.prev? and selection.start.prev.type is 'newline'
            selection.start.prev.remove()

          # Compute the offset of our cursor from the selection position (for drag-and-drop)
          bounds = selection.paper.bounds[selection.paper.lineStart]

          if cloneLater then offset = shiftedPoint.from new draw.Point bounds.x, bounds.y
          else offset = point.from new draw.Point bounds.x, bounds.y

          # Remove it from its tree
          if cloneLater then selection = selection.clone()
          else selection._moveTo null

          # Redraw the root tree (now that selection has been removed)
          redraw()
          
          # Redraw the selection on the drag canvas
          selection.paper.compute {line: 0}
          selection.paper.finish()
          selection.paper.draw dragCtx

          if selection is lassoSegment
            lassoSegment.paper.prepBounds()
            (lassoBounds = lassoSegment.paper.getBounds()).stroke dragCtx, '#000'
            lassoBounds.fill dragCtx, 'rgba(0, 0, 256, 0.3)'
          
          # Immediately transform the drag canvas
          div.onmousemove event
        else
          # We haven't clicked on anything. So do a lasso select.
          lassoAnchor = lassoHead = point
          
          # Move the drag canvas into position 0, 0
          dragCanvas.style.webkitTransform = "translate(0px, 0px)"
          dragCanvas.style.mozTransform = "translate(0px, 0px)"
          dragCanvas.style.transform = "translate(0px, 0px)"

      # Immediate redraw
      redraw()
      
    div.addEventListener 'touchmove', div.onmousemove = (event) ->
      # Determine where the point is on the canvas
      if event.offsetX?
        point = new draw.Point event.offsetX, event.offsetY
      else
        point = new draw.Point event.layerX, event.layerY
      point.add -PALETTE_WIDTH, 0

      if selection?
        # Figure out where we want the selection to go
        scrollDest = new draw.Point -offset.x + point.x, -offset.y + point.y
        point.translate scrollOffset
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y

        old_highlight = highlight

        # Find the highlighted area
        highlight = tree.segment.find (block) ->
          (block.start.prev?.type  isnt 'socketStart') and block.paper.dropArea? and block.paper.dropArea.contains dest
        
        # Redraw if we must
        if highlight isnt old_highlight or window.PERFORMANCE_TEST
          fastDraw()
          
          if highlight?
            # Highlight the highlighted area
            highlight.paper.dropArea.fill(ctx, '#fff')
        
        # css-transform the drag canvas to that area
        dragCanvas.style.webkitTransform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"
        dragCanvas.style.mozTransform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"
        dragCanvas.style.transform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"

        event.preventDefault()

      else if focus? and anchor?
        # Compute the points
        text = focus.content(); line = text.paper._line

        head = Math.round((point.x - text.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width)

        # Clear the current selection
        bounds = text.paper.bounds[line]
        ctx.clearRect bounds.x, bounds.y, bounds.width, bounds.height

        # Redraw the text
        text.paper.draw ctx

        # Draw the rectangle
        start = text.paper.bounds[line].x + ctx.measureText(text.value[...head]).width
        end = text.paper.bounds[line].x + ctx.measureText(text.value[...anchor]).width

        # Either draw the selection or the cursor
        if start is end
          ctx.strokeRect start, text.paper.bounds[line].y, 0, 15
        else
          ctx.fillStyle = 'rgba(0, 0, 256, 0.3)'
          ctx.fillRect start, text.paper.bounds[line].y, end - start, 15
      else if lassoAnchor?
        dragCtx.clearRect 0 ,0, dragCanvas.width, dragCanvas.height
        dragCtx.strokeStyle = '#00f'
        
        # Remember the lassoHead
        lassoHead = point

        corner =
          x: Math.min lassoAnchor.x, point.x
          y: Math.min lassoAnchor.y, point.y
        size =
          width: Math.abs lassoAnchor.x - point.x
          height: Math.abs lassoAnchor.y - point.y
        dragCtx.strokeRect corner.x, corner.y, size.width, size.height

    div.addEventListener 'touchend', div.onmouseup = (event) ->
      if selection?
        if highlight?
          switch highlight.type
            when 'indent'
              selection._moveTo highlight.start.insert new NewlineToken()
            when 'block'
              selection._moveTo highlight.end.insert new NewlineToken()
            when 'socket'
              if highlight.content()? then highlight.content().remove()
              selection._moveTo highlight.start

          if highlight is tree.segment # We inserted it in the root.
            selection._moveTo highlight.start

          # Redraw the root tree
          redraw()
        else
          # Determine the place we want to draw the thing
          if event.offsetX?
            point = new draw.Point event.offsetX, event.offsetY
          else
            point = new draw.Point event.layerX, event.layerY
          point.add -PALETTE_WIDTH, 0
          point.translate scrollOffset

          dest = new draw.Point -offset.x + point.x, -offset.y + point.y

          if dest.x > 0 # If we drop in the palette we delete the element
            # Draw the selection on the back canvas
            selection.paper.compute line: 0
            selection.paper.translate dest
            selection.paper.finish()
            selection.paper.draw ctx

            # Push this to the set of floating blocks
            floating_blocks.push block: selection, position: dest

      else if focus?
        # Make the selection
        input.setSelectionRange Math.min(anchor, head), Math.max(anchor, head)

        # Stop selecting
        anchor = head = null

      else if lassoAnchor?
        corner =
          x: Math.min lassoAnchor.x, lassoHead.x
          y: Math.min lassoAnchor.y, lassoHead.y
        size =
          width: Math.abs lassoAnchor.x - lassoHead.x
          height: Math.abs lassoAnchor.y - lassoHead.y

        lassoRect = new draw.Rectangle corner.x, corner.y, size.width, size.height

        # Find the first lassoed element
        # Code structure -- does this belong in ice.coffee? TODO
        
        # Find first
        firstLassoed = null
        head = tree.segment.start
        while head isnt tree.segment.end
          if head.type is 'blockStart' and head.block.paper._container.intersects lassoRect
            firstLassoed = head.block
            break
          head = head.next
        
        # Find last
        lastLassoed = null
        head = tree.segment.end
        while head isnt tree.segment.start
          if head.type is 'blockEnd' and head.block.paper._container.intersects lassoRect
            lastLassoed = head.block
            break
          head = head.prev

        if firstLassoed? and lastLassoed?
          # First, validate the selection
          stack = [firstLassoed]
          head = firstLassoed.start.next
          while head isnt lastLassoed.end
            switch head.type
              when 'blockStart'
                stack.push head.block
              when 'segmentStart'
                stack.push head.segment
              when 'indentStart'
                stack.push head.indent
              when 'blockEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.block
              when 'segmentEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.segment
              when 'indentEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.indent

                  # We can't just drag an indent, so find the surrounding block
                  #
                  # TODO the following is untested
                  _head = head.indent.start
                  _stack = []
                  while _head isnt null
                    if _head.type is 'blockEnd' then _stack.push _head.block
                    else if _head.type is 'blockStart'
                      if _stack.length > 0
                        _stack.pop()
                      else
                        stack.unshift _head.block
                        firstLassoed = _head.block
                        break
                    _head = _head.prev

            head = head.next
        
          # We have a start-tag without its end-tag, so append that as well
          if stack[0].type is 'indent'
            # We can't just drag an indent, so find the surrounding block
            head = stack[0].end
            _stack = []
            while head isnt null
              if head.type is 'blockStart' then console.log 'discards', head.block.toString(); _stack.push head.block
              else if head.type is 'blockEnd'
                console.log head.block.toString(), stack
                if _stack.length > 0
                  _stack.pop()
                else
                  unless head.block in stack
                    firstLassoed = head.block
                  stack[0] = head.block
                  break
              head = head.next

          lastLassoed = stack[0]

          lassoSegment = new Segment []

          firstLassoed.start.prev.insert lassoSegment.start
          lastLassoed.end.insert lassoSegment.end

      # Clear the drag canvas
      dragCtx.clearRect 0, 0, canvas.width, canvas.height

      # Unselect
      selection = null

      # Unlasso
      lassoAnchor = null

      # Full redraw for cleanliness
      redraw()

    div.addEventListener 'mousewheel', (event) ->
      if scrollOffset.y > 0 or event.deltaY > 0
        ctx.translate 0, -event.deltaY
        scrollOffset.add 0, event.deltaY
        fastDraw()

        event.preventDefault()

        return false
      return true
    
    out.onkeyup = ->
      try
        tree = coffee.parse out.value#ICE.indentParse out.value
        redraw()
      catch e
        ctx.fillStyle = "#f00"
        ctx.fillText e.message, 0, 0
    
    # This palette for testing only
    palette_blocks = [
      (coffee.parse '''
        a = b
      ''').segment
      
      (coffee.parse '''
        alert 'hi'
      ''').segment

      (coffee.parse '''
        for i in [1..10]
          alert 'good'
      ''').segment

      (coffee.parse '''
        return 0
      ''').segment
    ]
    
    running_height = 0
    for block in palette_blocks
      block.paper.compute line: 0

      # Translate into position
      block.paper.translate new draw.Point 0, running_height

      block.paper.finish()
      running_height = block.paper.bounds[block.paper.lineEnd].bottom() + PALETTE_WHITESPACE

      block.paper.draw paletteCtx

window.onload = ->
  unless window.RUN_PAPER_TESTS then return
  
  out = document.getElementById 'out'
  new Editor document.getElementById 'editor'
