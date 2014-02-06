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

    @selected = false # Are we the selected block?

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
          unless head.type is 'cursorToken' then cursor = cursor.append head.clone()
      head = head.next
    cursor.append clone.end

    return clone
  
  inSocket: ->
    head = @start.prev
    while head? and head.type is 'segmentStart' then head = head.prev
    return head? and head.type is 'socketStart'
  
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
      @start.prev.segment.remove()

    # Don't leave empty lines behind
    if @end.next? and @start.prev?
      last = @end.next
      while last? and (last.type is 'segmentEnd' or last.type is 'cursor') then last = last.next

      first = @start.prev
      while first? and (first.type is 'segmentStart' or first.type is 'cursor') then first = first.prev

      if first? and (first.type is 'newline') and ((not last?) or last.type is 'newline' or last.type is 'indentEnd')
        first.remove()
      else if last? and (last.type is 'newline') and ((not first?) or first.type is 'newline')
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
          unless head.type is 'cursorToken' then cursor = cursor.append head.clone()
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
          unless head.type is 'cursorToken' then cursor = cursor.append head.clone()
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
      while last? and (last.type is 'segmentEnd' or last.type is 'cursor') then last = last.next

      first = @start.prev
      while first? and (first.type is 'segmentStart' or first.type is 'cursor') then first = first.prev

      if first? and (first.type is 'newline') and ((not last?) or last.type is 'newline' or last.type is 'indentEnd')
        first.remove()
      else if last? and (last.type is 'newline') and ((not first?) or first.type is 'newline')
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

    @handwritten = false # A handwritten socket is a special kind of socket that doesn't accept blocks
                         # Its controller instance also has special key bindings

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
  
  insertBefore: (token) ->
    if @prev?
      token.prev = @prev
      @prev.next = token

    token.next = this
    @prev = token

    return @prev

  remove: ->
    if @prev? then @prev.next = @next
    if @next? then @next.prev = @prev
    @prev = @next = null

  toString: (state) -> if @next? then @next.toString(state) else ''

###
# Special kinds of tokens
###

exports.CursorToken = class CursorToken extends Token
  constructor: ->
    @prev = @next = null
    @paper = new CursorTokenPaper this
    @type = 'cursor'

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

###
# TODO Trigger rewrite this coming weekend.
###

# Constants
PADDING = 5
INDENT = 10
MOUTH_BOTTOM = 50
DROP_AREA_MAX_WIDTH = 50
FONT_SIZE = 15
EMPTY_INDENT_WIDTH = 50
PALETTE_WIDTH = 300
PALETTE_WHITESPACE = 10
MIN_INDENT_DROP_WIDTH = 20
EMPTY_SEGMENT_DROP_WIDTH = 100
DEFAULT_CURSOR_WIDTH = 100

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

    if @_lineChildren[line][0].block.type is 'indent' and @_lineChildren[line][0].lineStart is line
      # Add the tab at the top of an indent if necessary
      child = @_lineChildren[line][0]
      @_pathBits[line].right.unshift new draw.Point @bounds[line].x + INDENT + PADDING + 10, @bounds[line].y
      @_pathBits[line].right.unshift new draw.Point @bounds[line].x + INDENT + PADDING + 10, @bounds[line].y + 5
      @_pathBits[line].right.unshift new draw.Point @bounds[line].x + INDENT + PADDING + 30, @bounds[line].y + 5
      @_pathBits[line].right.unshift new draw.Point @bounds[line].x + INDENT + PADDING + 30, @bounds[line].y

    if @indentEnd[line] and @_lineChildren[line].length > 1
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].y
      @_pathBits[line].right.push new draw.Point @bounds[line].right(), @bounds[line].bottom() + _bottomModifier

      @bounds[line].height += 10

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

    unless @block.inSocket()
      @_container.push new draw.Point @bounds[@lineStart].x + 10, @bounds[@lineStart].y
      @_container.push new draw.Point @bounds[@lineStart].x + 10, @bounds[@lineStart].y + 5
      @_container.push new draw.Point @bounds[@lineStart].x + 30, @bounds[@lineStart].y + 5

    # Assemble our path from the recorded @_pathBits
    for line of @_pathBits
      for bit in @_pathBits[line].left
        @_container.unshift bit
      for bit in @_pathBits[line].right
        @_container.push bit

    unless @block.inSocket()
      @_container.unshift new draw.Point @bounds[@lineEnd].x + 10, @bounds[@lineEnd].bottom() + 5
      @_container.unshift new draw.Point @bounds[@lineEnd].x + 30, @bounds[@lineEnd].bottom() + 5
      @_container.unshift new draw.Point @bounds[@lineEnd].x + 30, @bounds[@lineEnd].bottom()

    # Do some styling
    @_container.style.strokeColor = if @block.selected then '#FFF' else '#000'
    @_container.style.fillColor = @block.color

    @dropArea = new draw.Rectangle @bounds[@lineEnd].x, @bounds[@lineEnd].bottom() - 5, @bounds[@lineEnd].width, 10
    @topCursorArea = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, @bounds[@lineStart].width, 10
    
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

class CursorTokenPaper extends IcePaper
  constructor: (block) ->
    super(block)
    @_rect = new draw.NoRectangle()

  compute: (state) ->
    @lineStart = @lineEnd = state.line
    this
  
  setRect: (rect) ->
    @_rect = rect
    @useTop = false
    #@_rect.copy new draw.Rectangle rect.x, rect.bottom() - 5, rect.width, 10

  setRectTop: (rect) ->
    @_rect = rect
    @useTop = true
    
  finish: ->

  draw: (ctx) ->
    # TODO The following hack should be dealt with by the parent indent.
    setTimeout (=>
      ctx.strokeStyle = '#000'
      ctx.fillStyle = '#FFF'
      y = if @useTop then @_rect.y else @_rect.bottom()

      ctx.beginPath()
      ctx.moveTo @_rect.x, y
      ctx.lineTo @_rect.x - 5, y + 5
      ctx.lineTo @_rect.x - 5, y - 5
      ctx.lineTo @_rect.x, y
      ctx.lineTo @_rect.x + @_rect.width, y
      ctx.lineTo @_rect.x + @_rect.width + 5, y - 5
      ctx.lineTo @_rect.x + @_rect.width + 5, y + 5
      ctx.lineTo @_rect.x + @_rect.width, y

      ctx.stroke()
      ctx.fill()
    ), 0

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
    head = @block.start.next
    if head.type is 'cursor' then head = head.next
    if head.type is 'newline' then head = head.next

    # This is a hack to deal with empty indents
    if @block.start.next is @block.end then head = @block.end

    # Loop
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          @children.push head.block.paper.compute state
          @group.push head.block.paper.group
          head = head.block.end

        when 'cursor'
          @children.push head.paper.compute state
          @group.push head.paper.group

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

        setCursor = false
        # If we need to draw the cursor before this block, do so
        if @children[i]? and @children[i].block.type is 'cursor'
          setCursor = true
          i += 1

        # Copy the block we're on here
        @bounds[line] = @children[i].bounds[line]
        @lineGroups[line] = new draw.Group()
        @indentEnd[line] = @children[i].indentEnd[line]
        @lineGroups[line].push @children[i].lineGroups[line]
        @_lineBlocks[line] = @children[i]

        if setCursor
          @children[i-1].setRectTop @bounds[line]
      
        # If we need to draw the cursor after this block, do so.
        else if @children[i+1]? and @children[i+1].block.type is 'cursor'
          @children[i+1].setRect @bounds[line]

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
        
        when 'cursor'
          @children.push head.paper.compute state
          if @children.length > 2
            head.paper.setRect new draw.Rectangle 0,
              running_height,
              @children[@children.length-2].
                bounds[@children[@children.length-2].lineEnd].
                width,
              0
          else
            head.paper.setRect new draw.Rectangle 0, running_height, DEFAULT_CURSOR_WIDTH, 0
          @group.push head.paper.group

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
      until line <= @children[i].lineEnd and @children[i].block.type isnt 'cursor'
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

INDENT_SPACES = 2
INPUT_LINE_HEIGHT = 15
PALETTE_MARGIN = 10

exports.Editor = class Editor
  constructor: (el, @paletteBlocks) ->

    ###
    # Field declaration
    # (useful to have all in one place)
    ###
    
    # If we did not recieve palette blocks in the constructor, we have no palette.
    @paletteBlocks ?= []
    
    # We discard the blocks we are fed, preferring to clone them
    # To be as unintrusive as possible (also to get blocks unattached to any
    # token stream
    @paletteBlocks = (paletteBlock.clone() for paletteBlock in @paletteBlocks)

    ###
    # MODEL instances (program state)
    ###
    @tree = null # The root tree
    @floatingBlocks = [] # The other root blocks that are not attached to the root tree
    
    ###
    # TEXT INPUT interactive fields
    ###
    @focus = null # The focused empty socket, if such thing exists.
    @editedText = null # The focused textToken, if such thing exists (associated with @focus).
    @handwritten = false # Are we editing a handwritten line?
    @hiddenInput = null

    @isEditingText = => @hiddenInput is document.activeElement

    textInputAnchor = textInputHead = null # The selection anchor and head in the input

    textInputSelecting = false

    _editedInputLine = -1

    ###
    # NORMAL DRAG interactive fields
    ###
    @selection = null # The currently-dragged set of blocks

    ###
    # LASSO SELECT interactive fields
    ###
    @lassoSegment = null
    @_lassoBounds = null

    ###
    # CURSOR interactive fields
    ###
    @cursor = new CursorToken()

    # Scroll offset
    @scrollOffset = new draw.Point 0, 0

    offset = null
    highlight = null
    
    ###
    # DOM SETUP
    ###

    # The main canvas
    main = document.createElement 'canvas'; main.className = 'canvas'
    main.height = el.offsetHeight
    main.width = el.offsetWidth - PALETTE_WIDTH

    # The palette canvas
    palette = document.createElement 'canvas'; palette.className = 'palette'
    palette.height = el.offsetHeight
    palette.width = PALETTE_WIDTH

    # The drag canvas
    drag = document.createElement 'canvas'; drag.className = 'drag'
    drag.height = el.offsetHeight
    drag.width = el.offsetWidth - PALETTE_WIDTH

    # The hidden input
    @hiddenInput = document.createElement 'input'; @hiddenInput.className = 'hidden_input'

    # The mouse tracking div
    track = document.createElement 'div'; track.className = 'trackArea'

    # Append the children
    for child in [main, palette, drag, track, @hiddenInput]
      el.appendChild child

    # Get the contexts from each canvas
    mainCtx = main.getContext '2d'
    dragCtx = drag.getContext '2d'
    paletteCtx = palette.getContext '2d'

    # The main context will be used for draw.js's text measurements (this is a bit of a hack)
    draw._setCTX mainCtx

    ###
    # General-purpose methods that call the view.
    ###
    
    @clear = =>
      mainCtx.clearRect @scrollOffset.x, @scrollOffset.y, main.width, main.height

    @redraw = =>
      # Clear the main canvas
      @clear()

      # Compute the root tree
      @tree.paper.compute line: 0

      # Draw it on the main context
      @tree.paper.finish()
      @tree.paper.draw mainCtx
      
      # Alert the lasso segment, if it exists, to recompute its bounds
      if @lassoSegment?
        # Ask the lasso segment to recompute its bounds
        @lassoSegment.paper.prepBounds()

        # Get those compute bounds
        @_lassoBounds = @lassoSegment.paper.getBounds()

        for float in @floatingBlocks
          if @lassoSegment is float.block
            @_lassoBounds.translate float.position
        
        # Unless we're already drawing it on the drag canvas, draw the lasso segment borders on the main canvas
        unless @lassoSegment is @selection
          @_lassoBounds.stroke mainCtx, '#000'
          @_lassoBounds.fill mainCtx, 'rgba(0, 0, 256, 0.3)'

      for float in @floatingBlocks
        paper = float.block.paper
        
        # Recompute this floating block's coordinates
        paper.compute line: 0
        paper.translate float.position

        # Draw it on the main context
        paper.finish()
        paper.draw mainCtx

    @attemptReparse = =>
      try
        @tree = (coffee.parse @getValue()).segment
        @redraw()
    
    ###
    # The redrawPalette function ought to be called only once in the current code structure.
    # If we want to scroll the palette later on, then this will be called to do so.
    ###
    @redrawPalette = =>
      # We need to keep track of the bottom edge of the last element,
      # so we know where to put the top of the next one (there will be a margin of PALETTE_MARGIN between them)
      lastBottomEdge = 0

      for paletteBlock in @paletteBlocks
        # Compute the coordinates
        paletteBlock.paper.compute line: 0

        # Translate it into position
        paletteBlock.paper.translate new draw.Point 0, lastBottomEdge

        # Increment the running height count
        lastBottomEdge = paletteBlock.paper.bounds[paletteBlock.paper.lineEnd].bottom() + PALETTE_MARGIN # Add margin

        # Finish and draw the palette block
        paletteBlock.paper.finish()
        paletteBlock.paper.draw paletteCtx
    
    # (call it right away)
    @redrawPalette()
    
    ###
    # Cursor operations
    ###
    insertHandwrittenBlock = =>
      # Create the new block and socket for a new handwritten line
      newBlock = new Block []; newSocket = new Socket []
      newSocket.handwritten = true

      # Put the new socket into the new block
      newBlock.start.insert newSocket.start; newBlock.end.prev.insert newSocket.end
      
      # Move it to where the cursor should be
      if @cursor.next.type is 'newline' or @cursor.next.type is 'indentEnd' or @cursor.next.type is 'segmentEnd'
        newBlock._moveTo @cursor.prev.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

      else if @cursor.prev.type is 'newline' or @cursor.prev.type is 'segmentStart'
        newBlock._moveTo @cursor.prev
        newBlock.end.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

    moveCursorTo = (token) =>
      # Splice out
      @cursor.remove()

      # Splice in
      token.insert @cursor

    
    moveCursorBefore = (token) =>
      # Splice out
      @cursor.remove()
      
      # Splice in
      token.insertBefore @cursor

    deleteFromCursor = =>
      # Seek the block that we want to delete (i.e. the block that ends first before the cursor, if such thing exists)
      head = @cursor.prev
      console.log head, head.toString indent:''
      while head isnt null and head.type isnt 'indentStart' and head.type isnt 'blockEnd'
        console.log head, head.block?.toString?()
        head = head.prev; console.log head.toString indent:''

      console.log head.toString indent:''

      # Delete that block and redraw
      if head.type is 'blockEnd' then head.block._moveTo null; @redraw()
    
    ###
    # TODO the following are known not to be able to navigate to the end of an indent.
    ###
    moveCursorUp = =>
      # Seek newline
      head = @cursor.prev.prev
      while head isnt null and not (head.type in ['newline', 'indentEnd', 'segmentStart'])
        head = head.prev
      
      # If head is null, we are at the beginning of the file.
      # So, give up.
      if head is null then return

      if head.type is 'indentEnd'
        moveCursorBefore head
      else
        moveCursorTo head

    moveCursorDown = =>
      # Seek newline or newline-like character.
      head = @cursor.next.next
      while head isnt null and not (head.type in ['newline', 'indentEnd', 'segmentEnd'])
        head = head.next

      # If head is null, we are at the end of the file.
      # So, give up.
      if head is null then return

      if head.type is 'indentEnd' or head.type is 'segmentEnd'
        moveCursorBefore head
      else
        moveCursorTo head
    
    ###
    # Bind events to the hidden input
    ###
    
    # For normal text input, we use the "input", "keydownhtml event
    for eventName in ['input', 'keydown', 'keyup', 'keypress']
      @hiddenInput.addEventListener eventName, (event) =>
        # If we haven't focused anything, this input does nothing.
        unless @isEditingText() then return true

        redrawTextInput()

    # For keyboard shortcuts, we use the "keydown" html event
    @hiddenInput.addEventListener 'keydown', (event) =>
      # If we're not on a handwritten line, return immediately
      unless @isEditingText() then return true

      # Otherwise, see if we want to make a keyboard shortcut.
      switch event.keyCode
        when 13
          if @handwritten then insertHandwrittenBlock()
          else setTextInputFocus null; @hiddenInput.blur(); @redraw()
        when 8 then if @handwritten and @hiddenInput.value.length is 0
          deleteFromCursor(); setTextInputFocus null; @hiddenInput.blur()
        when 9 then if @handwritten
          # Seek the block right before this handwritten block
          head = @focus.start.prev.prev
          head = head.prev while head isnt null and head.type isnt 'blockEnd' and head.type isnt 'blockStart'
          
          # If we have found a wrapping (parent) block, then we can't do an indent, so give up.
          if head.type is 'blockStart' then return

          # Otherwise, see if the last child of this block is an indent
          else if head.prev.type is 'indentEnd'
            # Note that it is guaranteed that a handwritten block satisfies @focus.start.prev.block is (the wrapping block)
            @focus.start.prev.block._moveTo head.prev.prev.insert new NewlineToken() # Move the block we're editing into the indent

            # Move the cursor into its proper position (after this block)
            moveCursorTo @focus.start.prev.block.end

            @redraw()
            event.preventDefault(); return false
          
          # We have found a block we want to move into, but there's no indent here, so create one.
          else
            # Create and insert a new indent
            newIndent = new Indent [], INDENT_SPACES
            head.prev.insert newIndent.start; head.prev.insert newIndent.end

            # Move the block we're editing into this new indent
            @focus.start.prev.block._moveTo newIndent.start.insert new NewlineToken()

            # Move the cursor into its proper position (after this block)
            moveCursorTo @focus.start.prev.block.end

            @redraw()
            event.preventDefault(); return false
        when 38 then setTextInputFocus null; @hiddenInput.blur(); moveCursorUp(); @redraw()
        when 40 then setTextInputFocus null; @hiddenInput.blur(); moveCursorDown(); @redraw()
    
    # When we blur the hidden input, also blur the canvas text focus
    ###
    @hiddenInput.addEventListener 'blur', (event) =>
      console.log 'blurred'
      # If we have actually blurred (as opposed to simply unfocused the browser window)
      if event.target isnt document.activeElement then setTextInputFocus null
    ###
    
    ###
    # Bind keyboard shortcut events to the document
    ###

    document.body.addEventListener 'keydown', (event) =>
      # Keyboard shortcuts don't apply if they were executed in a text input area
      if event.target.tagName in ['INPUT', 'TEXTAREA'] then return
      
      switch event.keyCode
        when 13 then unless @isEditingText() then insertHandwrittenBlock()
        when 38 then if @cursor? then moveCursorUp()
        when 40 then if @cursor? then moveCursorDown()
        when 8 then if @cursor? then deleteFromCursor()
        when 37 then if @cursor?
          head = @cursor
          while head.type isnt 'socketEnd' then head = head.prev
          setTextInputFocus head.socket
      
      # If we manipulated the root tree, redraw.
      if event.keyCode in [13, 38, 40, 8] then @redraw()

    ###
    # Hit-testing functions
    ###

    hitTest = (point, root) =>
      head = root; seek = null
      while head isnt seek
        if head.type is 'blockStart' and head.block.paper._container.contains point
          seek = head.block.end
        head = head.next
      
      if seek? then seek.block else null

    hitTestRoot = (point) => hitTest point, @tree.start
    
    hitTestFloating = (point) =>
      for float in @floatingBlocks
        if hitTest(point, float.block.start) isnt null then return float.block
      return null
    
    hitTestFocus = (point) =>
      head = @tree.start
      while head isnt null
        if head.type is 'socketStart' and
            (head.next.type is 'text' or head.next.type is 'socketEnd') and
            head.socket.paper.bounds[head.socket.paper._line].contains point
          return head.socket
        head = head.next

      return null
    
    hitTestLasso = (point) => if @lassoSegment? and @_lassoBounds.contains point then @lassoSegment else null

    hitTestPalette = (point) =>
      point = new draw.Point point.x + PALETTE_WIDTH, point.y
      for block in @paletteBlocks
        if hitTest(point, block.start)? then return block
      return null

    ###
    # Mouse events
    ###

    getPointFromEvent = (event) =>
      switch
        when event.offsetX? then new draw.Point event.offsetX - PALETTE_WIDTH, event.offsetY + @scrollOffset.y
        when event.layerX then new draw.Point event.layerX - PALETTE_WIDTH, event.layerY + @scrollOffset.y

    ###
    # The mousedown event, which sets fields according to what we have just selected.
    ###
    
    track.addEventListener 'mousedown', (event) =>
      point = getPointFromEvent event

      # See what we picked up
      @selection = hitTestFloating(point) ?
        hitTestLasso(point) ?
        hitTestFocus(point) ?
        hitTestRoot(point) ?
        hitTestPalette(point)
      
      if not @selection?
        ###
        # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
        ###
        
        # If there is already a selection, remove it.
        if @lassoSegment?

          # First, check to see if the block is floating
          flag = false
          for float in @floatingBlocks
            if float.block is @lassoSegment
              flag = true
              break

          unless flag # Don't remove the segment if it's floating, because it still needs to hold those blocks together
            @lassoSegment.remove()

          @lassoSegment = null
          @redraw()

        # Set the lasso anchor
        @lassoAnchor = point

      else if @selection.type is 'socket'
        ###
        # If we have clicked on a socket, then TEXT INPUT, indicated by (@isEditingText())
        ###
        
        # Set the text input up for editing
        setTextInputFocus @selection

        # We must set a timeout for the following, because until
        # A render has passed, the hidden input is not actually focused.
        setTimeout (=>
          console.log 'setting anchor', @focus

          setTextInputAnchor point
          redrawTextInput()
          
          # While the mouse is down, we are trying to select text in the input
          textInputSelecting = true

          @selection = null), 0

      else
        ###
        # If we have clicked on a block or segment, then NORMAL DRAG, indicated by (@selection?)
        ###

        # A flag as to whether we are selecting something in the palette
        selectionInPalette = false
        
        # If we clicked something in the palette, we need to compute offset etc. with a point that has been computed
        # with offset to the palette.
        if @selection in @paletteBlocks then point.add PALETTE_WIDTH, 0; selectionInPalette = true

        # Compute the offset of the selection position from the mouse
        rect = @selection.paper.bounds[@selection.paper.lineStart]
        offset = point.from new draw.Point rect.x, rect.y

        # If we have clicked something in the palette, the clone first.
        if selectionInPalette then @selection = @selection.clone()

        # If we have clicked something floating, then delete it from the list of floating blocks
        for float, i in @floatingBlocks
          if float.block is @selection then @floatingBlocks.splice i, 1; break

        # Move it to nowhere
        @selection._moveTo null

        # Draw it in the drag canvas
        @selection.paper.compute line: 0
        @selection.paper.finish()
        @selection.paper.draw dragCtx

        # CSS-transform the drag canvas to where it ought to be
        if selectionInPalette
          # If we picked up from the palette, then rect.x is actually relative to the palette
          fixedDest = new draw.Point rect.x - PALETTE_WIDTH, rect.y
        else
          # Otherwise, do as we would with mousemove
          fixedDest = new draw.Point rect.x - @scrollOffset.x, rect.y - @scrollOffset.y
        

        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
        
        # Redraw the main canvas
        @redraw()

    ###
    # Track mouse events for NORMAL DRAG (only)
    ###

    track.addEventListener 'mousemove', (event) =>
      if @selection?
        # Determine the position of the mouse
        point = getPointFromEvent event

        point.add -@scrollOffset.x, -@scrollOffset.y

        # First we find the highlighted area
        fixedDest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things exactly in relation to the canvas?

        point.translate @scrollOffset
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things as related to the way we draw the root tree?

        old_highlight = highlight

        highlight = @tree.find (block) ->
          (not (block.inSocket?() ? false)) and block.paper.dropArea? and block.paper.dropArea.contains dest

        # If highlight changed, redraw
        if old_highlight isnt highlight then @redraw()

        # Highlight the highlight
        if highlight? then highlight.paper.dropArea.fill mainCtx, '#fff'

        # CSS-transform the drag canvas to where it ought to be
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
    
    track.addEventListener 'mouseup', (event) =>
      if @selection?
        # Determine the position of the mouse and the place we want to render the block
        point = getPointFromEvent event
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y

        if highlight?
          ###
          # Drop areas signify different things depending on the block that they belong to
          ###
          switch highlight.type
            when 'indent'
              # An insert drop signifies that we want to drop the block at the start of the indent
              @selection._moveTo highlight.start.insert new NewlineToken()

            when 'block'
              # A block drop signifies that we want to drop the block after (the end of) the block.
              @selection._moveTo highlight.end.insert new NewlineToken()

            when 'socket'
              # Remove any previously occupying block or text
              if highlight.content()? then highlight.content().remove()

              # Insert
              @selection._moveTo highlight.start
            
            else
              if highlight is @tree
                # We can also drop on the root tree (insert at the start of the program)
                @selection._moveTo @tree.start
                @selection.end.insert new NewlineToken()

        else
          if point.x > 0
            # If we have dropped the block in nowhere, append it (and it's floating position) to @floatingBlocks.
            @floatingBlocks.push
              position: dest
              block: @selection
          
          # (If we have dropped the block on the palette, delete it. This requires no operations).

        
        # CSS-transform the drag canvas back to the origin
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(0px, 0px)"
        
        # Clear the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted into root, move the cursor to the end of the selection.
        if highlight?
          # Seek the next newline after the end of this block,
          # which is where we'll want to move the cursor
          # (so that it looks like we put it directly after the block).
          head = @selection.end
          while head isnt @tree.end and head.type isnt 'newline' then head = head.next
          if head is @tree.end then moveCursorBefore head
          else moveCursorTo head

        # Signify that we are no longer in a NORMAL DRAG
        @selection = null
        
        # Redraw after the selection has been set to null, since @redraw is sensitive to what things are being dragged.
        @redraw()

    ###
    # Track mouse events for LASSO SELECT
    ###

    getRectFromPoints = (a, b) ->
      return new draw.Rectangle(
        # Take the minimum coordinates for the top-left corner
        Math.min(a.x, b.x), #x
        Math.min(a.y, b.y), #y
        
        # Distances are always positive
        Math.abs(a.x - b.x), #width
        Math.abs(a.y - b.y)) #height

    track.addEventListener 'mousemove', (event) =>
      if @lassoAnchor?
        # Determine the position of the mouse
        point = getPointFromEvent event
        point.translate @scrollOffset # (position fixed, as in relation to the drag canvas, on which we will draw it)

        # Get the rectangle we want to draw
        rect = getRectFromPoints @lassoAnchor, point

        # Clear and redraw the lasso on the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height
        dragCtx.strokeStyle = '#00f'
        dragCtx.strokeRect rect.x, rect.y, rect.width, rect.height

    track.addEventListener 'mouseup', (event) =>
      if @lassoAnchor?
        # Determine the position of the mouse
        point = getPointFromEvent event
        point.translate @scrollOffset

        # Get the rectangle we want to test
        rect = getRectFromPoints @lassoAnchor, point

        ###
        # First pass for lasso segment detection: get intersecting blocks.
        ###
        
        # Find the first matching block
        head = @tree.start
        firstLassoed = null
        while head isnt @tree.end
          # A block matches if it intersects the lasso rectangle
          if head.type is 'blockStart' and head.block.paper._container.intersects rect
            firstLassoed = head
            break
          head = head.next
        
        # Find the last matching block analagously
        head = @tree.end
        lastLassoed = null
        while head isnt @tree.start
          if head.type is 'blockEnd' and head.block.paper._container.intersects rect
            lastLassoed = head
            break
          head = head.prev

        # Unless we have selected anything, give up.
        if firstLassoed? and lastLassoed?
          ###
          # Second pass for lasso segment detection: validate the selection and record wrapping blocks as necessary.
          ###
          
          tokensToInclude = []

          head = firstLassoed
          while head isnt lastLassoed
            ###
            # For each bit of markup, make sure to include both its start token and end token
            ###
            switch head.type
              when 'blockStart', 'blockEnd'
                tokensToInclude.push head.block.start
                tokensToInclude.push head.block.end
              when 'indentStart', 'indentEnd'
                tokensToInclude.push head.indent.start
                tokensToInclude.push head.indent.end
              when 'segmentStart', 'segmentEnd'
                tokensToInclude.push head.segment.start
                tokensToInclude.push head.segment.end
            head = head.next

          ###
          # Third pass for lasso segment detection: include all necessary tokens demanded by validation
          ###

          # Find the first block in tokensToInclude
          head = @tree.start
          while head isnt @tree.end
            if head in tokensToInclude
              firstLassoed = head; break
            head = head.next
          
          # Find the last matching block analagously
          head = @tree.end
          lastLassoed = null
          while head isnt @tree.start
            if head in tokensToInclude
              lastLassoed = head; break
            head = head.prev

          ###
          # Fourth pass for lasso segment detection: make sure that we have selected the wrapping block for any indents
          #
          # Note that this will only occur when we have inserted the indentStart at the beginning or indentEnd at the end
          # in the second and third pass. This in turn will occur ONLY when the user has selected multiple blocks belonging to the
          # same wrapping block, and nothing outside it (i.e. the wrapping block of the indent wraps the entire selection).
          #
          # So it suffices to select that entire wrapping block.
          ###

          if firstLassoed.type is 'indentStart'
            # Seek the wrapping block for this indent
            depth = 0
            while depth > 0 or head.type isnt 'blockStart' # We need to find the wrapping block, so we keep track of block depth
              # Increment block depth
              if firstLassoed.type is 'blockStart' then depth -= 1
              else if firstLassoed.type is 'blockEnd' then depth += 1

              firstLassoed = firstLassoed.prev
            
            # Set lastLassoed in accordance.
            lastLassoed = firstLassoed.block.end

          if firstLassoed.type is 'indentStart'
            # Seek the wrapping block for this indent
            depth = 0
            while depth > 0 or head.type isnt 'blockEnd' # We need to find the wrapping block, so we keep track of block depth
              # Increment block depth
              if lastLassoed.type is 'blockEnd' then depth -= 1
              else if lastLassoed.type is 'blockStart' then depth += 1
            
            # Set firstLassoed in accordance
            firstLassoed = lastLassoed.block.start

          # Now, insert the actual lasso segment.
          @lassoSegment = new Segment []

          firstLassoed.insertBefore @lassoSegment.start
          lastLassoed.insert @lassoSegment.end

          @redraw()
        
        # Clear the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted a lasso segment, move the cursor appropriately
        if @lassoSegment? then moveCursorTo @lassoSegment.end
        
        # Flag that we are no longer in a LASSO SELECT.
        @lassoAnchor = null

        @redraw()


    ###
    # Utility functions for TEXT INPUT
    ###

    redrawTextInput = =>
      # Change the edited text
      @editedText.value = @hiddenInput.value

      # Redraw the background (main canvas)
      @redraw()
      
      # Determine the position (coordinate-wise) of the typing cursor
      start = @editedText.paper.bounds[_editedInputLine].x +
        mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionStart]).width

      end = @editedText.paper.bounds[_editedInputLine].x +
        mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionEnd]).width
      
      # Draw the typing cursor itself
      if start is end
        # This is just a line
        mainCtx.strokeRect start, @editedText.paper.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT
      else
        # This is the translucent rectangle
        mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3'
        mainCtx.fillRect start, @editedText.paper.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT

    setTextInputFocus = (focus) =>
      # Literally set the focus
      @focus = focus
      
      # If we just removed the focus, then we are done.
      if @focus is null then return
      
      # Record the line that the focus is on
      _editedInputLine = @focus.paper._line

      # Flag whether we are editing handwritten
      @handwritten = @focus.handwritten
      
      if not @focus.content()
        # If the socket is empty, put a text thing in, setting that to the edited text
        @editedText = new TextToken ''
        @focus.start.insert @editedText
      
      else if @focus.content().type is 'text'
        # If the socket is not empty but contains only text, edit that text
        @editedText = @focus.content()

      else
        # Otherwise, we have an error condition.
        throw 'Cannot edit occupied socket.'


      # Find the wrapping block and move the cursor to
      head = @focus.end; depth = 0
      while head.type isnt 'newline' and head.type isnt 'indentEnd' and head.type isnt 'segmentEnd' then head = head.next
      
      if head.type is 'newline' then moveCursorTo head
      else moveCursorBefore head
      
      # Set the contents of the hidden input
      @hiddenInput.value = @editedText.value

      # Focus the hidden input
      setTimeout (=> @hiddenInput.focus()), 0

    setTextInputHead = (point) =>
      textInputHead = Math.round (point.x - @focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width

      @hiddenInput.setSelectionRange Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead)

    setTextInputAnchor = (point) =>
      textInputAnchor = textInputHead = Math.round (point.x - @focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width
      @hiddenInput.setSelectionRange textInputAnchor, textInputHead

    ###
    # Track mouse events for TEXT INPUT
    ###

    track.addEventListener 'mousemove', (event) =>
      if @isEditingText() and textInputSelecting
        # See where the mouse is
        point = getPointFromEvent event
        
        # Set the input head
        setTextInputHead point

        # Redraw
        redrawTextInput()

    track.addEventListener 'mouseup', (event) =>
      if @isEditingText()
        textInputSelecting = false

    ###
    # Track events for SCROLLING
    ###
    track.addEventListener 'mousewheel', (event) =>
      @clear()

      if event.wheelDelta > 0
        if @scrollOffset.y >= 100
          @scrollOffset.add 0, -100
          mainCtx.translate 0, 100
      else
        @scrollOffset.add 0, 100
        mainCtx.translate 0, -100

      @redraw()

  setValue: (value) ->
    @tree = coffee.parse(value).segment
    @redraw()

  getValue: -> @tree.toString()

window.onload = ->
  # Tests
  window.editor = new Editor document.getElementById('editor'), (coffee.parse(paletteElement).next.block for paletteElement in [
    '''
    for i in [1..10]
      alert 'hello'
    '''
    '''
    alert 'hello'
    '''
    '''
    if a is b
      alert 'hi'
    else
      alert 'bye'
    '''
    '''
    a = b
    '''
  ])
  editor.setValue '''
  for i in [1..10]
    if i % 2 is 0
      alert i
      alert 'bye'
    else
      alert 'fizz'
    alert 'buzz'
  '''
