# Tree classes and operations for ICE editor.
#
# Copyright (c) 2014 Anthony Bau.
#
# MIT License.

exports = {}

# # Block
# The basic data structure in ICE Editor is a linked list. A Block is a group of 
# two tokens, one start token and one end token. Everything between these tokens
# is a block's content. Thus "tree" operations are linked-list
# splices.

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

    @view = new BlockView this
  
  # ## Clone ##
  # Cloning produces a new Block entirely independent
  # of this one (there are no linked-list pointers in common).
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
    
  # ## inSocket ##
  # Is this block in a Socket? This function is mainly used
  # by the View to determine whether a block needs tabs or not,
  # and by the Controller to determine whether a block can be dropped after.
  inSocket: ->
    head = @start.prev
    while head? and head.type is 'segmentStart' then head = head.prev
    return head? and head.type is 'socketStart'
  
  # ## moveTo ##
  # Splice this block out and place it somewhere else.
  # This will also eliminate any empty lines left behind, and any empty Segments.
  # Whitespace in general is this function's responsibility.
  moveTo: (parent) ->
    # Check for empty segments
    while @start.prev? and @start.prev.type is 'segmentStart' and @start.prev.segment.end is @end.next
      @start.prev.segment.remove()

    # Don't leave empty lines behind
    if @end.next? and @start.prev?
      last = @end.next
      while last? and (last.type is 'segmentEnd' or last.type is 'cursor') then last = last.next

      first = @start.prev
      while first? and (first.type is 'segmentStart' or first.type is 'cursor') then first = first.prev

      if first? and (first.type is 'newline') and ((not last?) or last.type is 'newline' or last.type is 'indentEnd') and not (first.prev?.type is 'indentStart' and last.type is 'indentEnd')
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
      if parent.next? then parent.next.prev = @end

      parent.next = @start
      @start.prev = parent
  
  # ## find ##
  # This one is mainly used for hit-testing during drag-and-drop by the Controller.
  # It finds the first child fitting f(x) that does not have a child who fits f(x).

  # (todo -- move to Controller?)
  find: (f) ->
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next

    # Maybe the _we_ are the first child with no fitting children
    if f this then return this
    
    # We found no results, so return null.
    else return null
  
  # ## toString ##
  # This one is mainly used for debugging. The string representation ("compiled code")
  # for anything between our start and end tokens. This is computed by stringifying
  # everything, then splicing off everything after the end token.
  toString: ->
    string = @start.toString indent: ''
    return string[..string.length-@end.toString(indent: '').length-1]

# # Indent
# An Indent, like a Block, consists of two tokens, start and end. An Indent also knows its @depth,
# which is the number of spaces that it is indented in. When compiling/stringifying, every newline
# inside an indent will add @depth spaces after it.
exports.Indent = class Indent
  constructor: (contents, @depth) ->
    @start = new IndentStartToken this
    @end = new IndentEndToken this
    @type = 'indent'
    
    head = @start
    for block in contents
      head = head.append block.clone()
    head.append @end
    
    @view = new IndentView this

  # ## clone ##
  # Like Block, creates an Indent whose string representation and data structure 
  # is identical, but shares no linked-list pointers with us.
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

  # ## find ##
  # This one is mainly used for hit-testing during drag-and-drop by the Controller.
  # It finds the first child fitting f(x) that does not have a child who fits f(x).

  # (todo -- move to Controller?)
  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f(head.block) then return head.block.find f
      else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
      else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
      head = head.next
    
    # Could _we_ be the first fitting element with no fitting children?
    if f this then return this

    # Couldn't find any, so return null.
    else return null
  
  # ## toString ##
  # This one is mainly used for debugging. Like Block.toString, computes
  # the compiled code for everything between the two end tokens, by stringifying
  # the start and splicing of the string representation of the end.
  toString: (state) ->
    string = @start.toString(state)
    return string[...string.length-@end.toString(state).length-1]

# # Segment
# A Segment is a basically invisible piece of markup, which knows its start and end tokens.
# In rendering, this is usually passed through unnoticed. It is useful for mass tree operations,
# for instance the Controller's LASSO SELECT, which will drag multiple blocks at once.
exports.Segment = class Segment
  constructor: (contents) ->
    @start = new SegmentStartToken this
    @end = new SegmentEndToken this
    @type = 'segment'
    
    head = @start
    for block in contents
      head = head.append block.clone()
    head.append @end
    
    @view = new SegmentView this
  
  # ## clone ##
  # Like Block, creates an Segment whose string representation and data structure 
  # is identical, but shares no linked-list pointers with us.
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
  
  # ## remove ##
  # This method is unique to Segments because you would never want to call it
  # on any other kind of markup. This removes the start and end tokens, thus leaving
  # the string representation of the data unchanged, but removing this Segment from existence.
  remove: ->
    @start.remove()
    @end.remove()
    @start.next = @end
    @end.prev = @start

  # ## moveTo ##
  # Splice this segment out and place it somewhere else.
  # This will also eliminate any empty lines left behind, and any empty Segments.
  # Whitespace in general is this function's responsibility.
  moveTo: (parent) ->
    # Check for empty segments
    while @start.prev? and @start.prev.type is 'segmentStart' and @start.prev.segment.end is @end.next
      @start.prev.segment.remove()

    # Don't leave empty lines behind
    if @end.next? and @start.prev?
      last = @end.next
      while last? and (last.type is 'segmentEnd' or last.type is 'cursor') then last = last.next

      first = @start.prev
      while first? and (first.type is 'segmentStart' or first.type is 'cursor') then first = first.prev

      if first? and (first.type is 'newline') and ((not last?) or last.type is 'newline' or last.type is 'indentEnd') and not (first.prev?.type is 'indentStart' and last.type is 'indentEnd')
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
      if parent.next? then parent.next.prev = @end

      parent.next= @start
      @start.prev = parent

  # ## find ##
  # This one is mainly used for hit-testing during drag-and-drop by the Controller.
  # It finds the first child fitting f(x) that does not have a child who fits f(x).

  # (todo -- move to Controller?)
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
  
  # ## toString ##
  # This one is actually called often from the Controller, since
  # Segments serve as the root elements of every tree. As with Blocks and Indents,
  # this is computed by stringifying the start token (get all code) and splicing off things after
  # the end token.
  toString: ->
    start = @start.toString(indent: '')
    return start[...start.length-@end.toString(indent: '').length]

# # Socket
# A Socket is an inline droppable area for a Block, and
# also a typable area for Text. Like a Block and an Indent,
# a Socket consists of a start and end token. Sockets may only
# contain *one* child element, although this may mean multiple tokens,
# if the child element is a Block, Indent, or Segment.
#
# A special type of Socket is a handwritten socket, for whom
# the @handwritten property will be true, and is handled specially
# by the Controller.

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

    # A handwritten socket is a special kind of socket that doesn't accept blocks
    # Its controller instance also has special key bindings
    @handwritten = false

    @view = new SocketView this
  
  # ## clone ##
  # Cloning produces an identical Socket with no shared linked-list pointers.
  # To produce this clone, we need only delegate to our content block, because
  # there *may only be one*.
  clone: -> if @content()? then new Socket @content().clone() else new Socket()
  
  # ## content ##
  # Get the content block of this Socket
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

  # ## find ##
  # This one is mainly used for hit-testing during drag-and-drop by the Controller.
  # It finds the first child fitting f(x) that does not have a child who fits f(x).

  # (todo -- move to Controller?)
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

  toString: -> @start.toString(indent:'')[...-@end.toString(indent:'').length]
 
# # Token
# This is the class from which all ICE Editor tokens descend.
# It knows basic linked-list operations.
exports.Token = class Token
  constructor: ->
    @prev = @next = null
  
  # ## append ##
  # Splice the linked list starting at (token)
  # to the end of this token. This disconnects us from
  # any linked list segment starting at @next, and conjoins us
  # with that starting at (token).
  append: (token) ->
    token.prev = this
    @next = token
  
  # ## insert ##
  # Insert signle token (token) into this linked list
  # right after us. This retains our linked list order.
  insert: (token) ->
    if @next?
      token.next = @next
      @next.prev = token
    token.prev = this
    @next = token
    return @next
  
  # ## insertBefore ##
  # Insert (token) in this linked list before us, as with insert.
  insertBefore: (token) ->
    if @prev?
      token.prev = @prev
      @prev.next = token

    token.next = this
    @prev = token

    return @prev
  
  # ## remove ##
  # Splice us out of the linked list
  remove: ->
    if @prev? then @prev.next = @next
    if @next? then @next.prev = @prev
    @prev = @next = null
  
  # ## toString ##
  # Converting a Token to a string gets you the compilation of this
  # and every token after it. 
  toString: (state) -> if @next? then @next.toString(state) else ''

## Special kinds of tokens

# ## CursorToken ##
# A user's cursor, which the Controller can perform operations at
# and the View renders as a black triangle
exports.CursorToken = class CursorToken extends Token
  constructor: ->
    @prev = @next = null
    @view = new CursorView this
    @type = 'cursor'

  clone: -> new CursorToken()

# ## TextToken ##
# A token representing plain text.
exports.TextToken = class TextToken extends Token
  constructor: (@value) ->
    @prev = @next = null
    @view = new TextView this
    @type = 'text'

  clone: -> new TextToken @value

  toString: (state) ->
    @value + if @next? then @next.toString(state) else ''

# ## Markup tokens ##
# These are the tokens to which we referred earlier when we discussed
# Blocks, Indents, Segments, and Sockets. They represent the start and end of a piece of markup.
# They should *never* be instantiated, except by their respective markup classes
# (Block, Start, Segment, and Indent).
#
# When stringifying, they do no operations. Thus they have no responsibility
# but to identify their type.
exports.BlockStartToken = class BlockStartToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockStart'

exports.BlockEndToken = class BlockEndToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockEnd'

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

# ## IndentStart and IndentEnd ##
# These tokens must increment or decrement the number of spaces
# to insert at each newline. This number is stored and modified in (state),
# an object passed down whenever a stringification occurs.
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


# ## NewlineToken ##
# This token represents a newline. When stringifying, it inserts (state.indent) spaces
# if necessary.
exports.NewlineToken = class NewlineToken extends Token
  constructor: ->
    @prev = @next = null
    @type = 'newline'

  clone: -> new NewlineToken()

  toString: (state) ->
    '\n' + state.indent + if @next then @next.toString(state) else ''

window.ICE = exports

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
DROP_AREA_HEIGHT = 30
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

    @dropArea = null

    @highlightArea = null

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
    @dropArea = @highlightArea = null
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
      # Depending on whether the cursor is positioned at the beginning or the end of the line,
      # we render it after or before the line it is on.
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
    @dropArea = new draw.Rectangle @bounds[@lineEnd].x, @bounds[@lineEnd].bottom() - DROP_AREA_HEIGHT / 2, @bounds[@lineEnd].width, DROP_AREA_HEIGHT
    @dropHighlightReigon = new draw.Rectangle @bounds[@lineEnd].x, @bounds[@lineEnd].bottom() - 5, @bounds[@lineEnd].width, 10
    
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

  # ## computePlaintextTranslationVector ##
  # The following is a function unique to TextView This will compute the position of the text as if it were
  # rendered as plaintext; used by the Controller to do the animation for freeze and melt.
  #
  # It is passed state and ctx; ctx will remain unchanged and is used for measuring text,
  # whereas state will be modified (so must be mutable) to be passable to the next text token found after this.
  #
  # State has properties:
  #   - indent (num)
  #   - x (num)
  #   - y (num)
  computePlaintextTranslationVector: (state, ctx) ->
    point = new draw.Point state.x, state.y

    state.x += ctx.measureText(@block.value).width

    return point.from new draw.Point @bounds[@lineStart].x, @bounds[@lineStart].y

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
    @dropArea = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - DROP_AREA_HEIGHT / 2, @bounds[@lineStart].width, DROP_AREA_HEIGHT
    @dropHighlightReigon = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, @bounds[@lineStart].width, 10

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
      (@dropHighlightReigon = @dropArea = new draw.Rectangle()).copy @bounds[@lineStart]

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

    @dropHighlightReigon = new draw.Rectangle @bounds[@lineStart].x, @bounds[@lineStart].y - 5, @bounds[@lineStart].width, 10

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

# ICE Editor Controller
#
# Copyright (c) 2014 Anthony Bau.
#
# MIT License

INDENT_SPACES = 2
INPUT_LINE_HEIGHT = 15
PALETTE_MARGIN = 10
PALETTE_WIDTH = 300
MIN_DRAG_DISTANCE = 5
FONT_SIZE = 15
ANIMATION_FRAME_RATE = 50 # FPS

exports.IceEditorChangeEvent = class IceEditorChangeEvent
  constructor: (@block, @target) ->

# #The Editor class
# This class contains all the controller functions for ICE Editor.
# Call:
#   new Editor(DOMElement, palette)
# to initialize an ICE editor in an element.

exports.Editor = class Editor
  constructor: (el, @paletteBlocks) ->

    # ## Field declaration ##
    # (useful to have all in one place)
    
    # If we did not recieve palette blocks in the constructor, we have no palette.
    @paletteBlocks ?= []
    
    # We discard the blocks we are fed, preferring to clone them
    # to be as unintrusive as possible (also to get blocks unattached to any
    # token stream)
    @paletteBlocks = (paletteBlock.clone() for paletteBlock in @paletteBlocks)

    # MODEL instances (program state)
    @tree = null # The root tree
    @floatingBlocks = [] # The other root blocks that are not attached to the root tree
    
    # TEXT INPUT interactive fields
    @focus = null # The focused empty socket, if such thing exists.
    @editedText = null # The focused textToken, if such thing exists (associated with @focus).
    @handwritten = false # Are we editing a handwritten line?
    @hiddenInput = null

    @isEditingText = => @hiddenInput is document.activeElement

    textInputAnchor = textInputHead = null # The selection anchor and head in the input

    textInputSelecting = false

    _editedInputLine = -1

    # NORMAL DRAG interactive fields
    @selection = null # The currently-dragged set of blocks

    # LASSO SELECT interactive fields
    @lassoSegment = null
    @_lassoBounds = null

    # CURSOR interactive fields
    @cursor = new CursorToken()

    # UNDO STACK
    @undoStack = []

    # Scroll offset
    @scrollOffset = new draw.Point 0, 0

    offset = null
    highlight = null
    
    # ## DOM SETUP ##

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
    @mainCtx = main.getContext '2d'
    @dragCtx = drag.getContext '2d'
    @paletteCtx = palette.getContext '2d'

    # The main context will be used for draw.js's text measurements (this is a bit of a hack)
    draw._setCTX @mainCtx

    # ## Convenience Functions ##
    # General-purpose methods that call the view (rendering functions)
    
    @clear = =>
      @mainCtx.clearRect @scrollOffset.x, @scrollOffset.y, main.width, main.height
    
    # ## Redraw ##
    # redraw does three main things: redraws the root tree (@tree)
    # redraws any floating blocks (@floatingBlocks), and draws the bounding rectangle
    # of any lassoed segments.
    @redraw = =>
      # Clear the main canvas
      @clear()

      # Compute the root tree
      @tree.view.compute()

      # Draw it on the main context
      @tree.view.draw @mainCtx
      
      # Alert the lasso segment, if it exists, to recompute its bounds
      if @lassoSegment?
        # Get those compute bounds
        @_lassoBounds = @lassoSegment.view.getBounds()

        for float in @floatingBlocks
          if @lassoSegment is float.block
            @_lassoBounds.translate float.position
        
        # Unless we're already drawing it on the drag canvas, draw the lasso segment borders on the main canvas
        unless @lassoSegment is @selection
          @_lassoBounds.stroke @mainCtx, '#000'
          @_lassoBounds.fill @mainCtx, 'rgba(0, 0, 256, 0.3)'

      for float in @floatingBlocks
        view = float.block.view
        
        # Recompute this floating block's coordinates
        view.compute()
        view.translate float.position

        # Draw it on the main context
        view.draw @mainCtx

    @attemptReparse = =>
      try
        @tree = (coffee.parse @getValue()).segment
        @redraw()

    moveBlockTo = (block, target) =>
      parent = block.start.prev
      while parent? and (parent.type is 'newline' or (parent.type is 'segmentStart' and parent.segment isnt @tree) or parent.type is 'cursor') then parent = parent.prev

      @undoStack.push
        block: block
        target: if parent? then (switch parent.type
          when 'indentStart', 'indentEnd' then parent.indent
          when 'blockStart', 'blockEnd' then parent.block
          when 'socketStart', 'socketEnd' then parent.socket
          when 'segmentStart', 'segmentEnd' then parent.segment
          else parent) else null

      block.moveTo target
      if @onChange? then @onChange new IceEditorChangeEvent block, target

    @undo = =>
      # If the undo stack is empty, give up.
      unless @undoStack.length > 0 then return

      operation = lastOperation = target: null
      
      until operation.target? or operation.block isnt lastOperation.block
        # Otherwise, pop from the undo stack
        operation = @undoStack.pop()

        unless operation? then break
        
        # Simulate dropping the block into its target
        if operation.target? then switch operation.target.type
          when 'indent'
            head = operation.target.end.prev
            while head.type is 'segmentEnd' or head.type is 'segmentStart' or head.type is 'cursor' then head = head.prev

            if head.type is 'newline'
              # There's already a newline here.
              operation.block.moveTo operation.target.start.next
            else
              # An insert drop signifies that we want to drop the block at the start of the indent
              operation.block.moveTo operation.target.start.insert new NewlineToken()

          when 'block'
            # A block drop signifies that we want to drop the block after (the end of) the block.
            operation.block.moveTo operation.target.end.insert new NewlineToken()

          when 'socket'
            # Remove any previously occupying block or text
            if operation.target.content()? then operation.target.content().remove()

            # Insert
            operation.block.moveTo operation.target.start
          
          else
            if operation.target is @tree
              # We can also drop on the root tree (insert at the start of the program)
              operation.block.moveTo @tree.start

              # Don't insert a newline if it would create an empty line at the end of the file.
              unless operation.block.end.next is @tree.end
                operation.block.end.insert new NewlineToken()
        else
          operation.block.moveTo operation.target

      @redraw()

      if @onChange? then @onChange new IceEditorChangeEvent operation.block, operation.target
    
    # The redrawPalette function ought to be called only once in the current code structure.
    # If we want to scroll the palette later on, then this will be called to do so.
    @redrawPalette = =>
      # We need to keep track of the bottom edge of the last element,
      # so we know where to put the top of the next one (there will be a margin of PALETTE_MARGIN between them)
      lastBottomEdge = 0

      for paletteBlock in @paletteBlocks
        # Compute the coordinates
        paletteBlock.view.compute()

        # Translate it into position
        paletteBlock.view.translate new draw.Point 0, lastBottomEdge

        # Increment the running height count
        lastBottomEdge = paletteBlock.view.bounds[paletteBlock.view.lineEnd].bottom() + PALETTE_MARGIN # Add margin

        # Finish and draw the palette block
        paletteBlock.view.draw @paletteCtx
    
    # (call it right away)
    @redrawPalette()
    
    # ##Cursor operations ##
    # Functions that manipulate the cursor. The cursor is a normal ICE editor model token
    # that is rendered specially in the View.

    insertHandwrittenBlock = =>
      # Create the new block and socket for a new handwritten line
      newBlock = new Block []; newSocket = new Socket []
      newSocket.handwritten = true

      # Put the new socket into the new block
      newBlock.start.insert newSocket.start; newBlock.end.prev.insert newSocket.end
      
      # Move it to where the cursor should be
      if @cursor.next.type is 'newline' or @cursor.next.type is 'indentEnd' or @cursor.next.type is 'segmentEnd'
        if @cursor.next.type is 'indentEnd' and @cursor.prev.type is 'newline'
          moveBlockTo newBlock, @cursor.prev
        else
          moveBlockTo newBlock, @cursor.prev.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

      else if @cursor.prev.type is 'newline' or @cursor.prev.type is 'segmentStart'

        moveBlockTo newBlock, @cursor.prev

        newBlock.end.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

      scrollCursorIntoView()

    scrollCursorIntoView = =>
      @redraw()
      
      # If the cursor has scrolled out of view, scroll it back into view.
      if @cursor.view.point.y < @scrollOffset.y
        @mainCtx.translate 0, @scrollOffset.y - @cursor.view.point.y
        @scrollOffset.y = @cursor.view.point.y

        @redraw()
      else if @cursor.view.point.y > (@scrollOffset.y + main.height)
        @mainCtx.translate 0, (@scrollOffset.y + main.height) - @cursor.view.point.y
        @scrollOffset.y = @cursor.view.point.y - main.height

        @redraw()

    moveCursorTo = (token) =>
      # Splice out
      @cursor.remove()

      # Find the newline or end markup after the given token.
      # Special case: we can also focus the very start of the tree.
      head = token
      unless head is @tree.start
        until (not head?) or head.type in ['newline', 'indentEnd', 'segmentEnd'] then head = head.next

      # If there is no place to put the cursor, give up.
      unless head? then return

      # Splice in
      if head.type is 'newline' or head is @tree.start
        head.insert @cursor
      else
        head.insertBefore @cursor

      scrollCursorIntoView()
    
    moveCursorBefore = (token) =>
      # Splice out
      @cursor.remove()
      
      # Splice in
      token.insertBefore @cursor

      scrollCursorIntoView()

    deleteFromCursor = =>
      # Seek the block that we want to delete (i.e. the block that ends first before the cursor, if such thing exists)
      head = @cursor.prev
      while head isnt null and head.type isnt 'indentStart' and head.type isnt 'blockEnd'
        head = head.prev
      
      # If there is no block before the cursor, give up.
      if head is null then return

      # Delete that block and redraw
      if head.type is 'blockEnd' then moveBlockTo head.block, null; @redraw()

      scrollCursorIntoView()
    
    # TODO the following are known not to be able to navigate to the end of an indent.
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

      # Make sure that we're not inside a block only.
      # This requires finding the immediate parent of the cursor
      head = @cursor; depth = 0
      until head.type in ['blockEnd', 'indentEnd', 'segmentEnd'] and depth is 0
        switch head.type
          when 'blockStart', 'indentStart', 'segmentStart', 'socketStart' then depth += 1
          when 'blockEnd', 'indentEnd', 'segmentEnd', 'socketEnd' then depth -= 1
        head = head.next
      
      # If we're in a bad place, then move us further.
      if head.type is 'blockEnd' then moveCursorUp()

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

      # Make sure that we're not inside a block only.
      # This requires finding the immediate parent of the cursor
      head = @cursor; depth = 0
      until head.type in ['blockEnd', 'indentEnd', 'segmentEnd'] and depth is 0
        switch head.type
          when 'blockStart', 'indentStart', 'segmentStart', 'socketStart' then depth += 1
          when 'blockEnd', 'indentEnd', 'segmentEnd', 'socketEnd' then depth -= 1
        head = head.next
      
      # If we're in a bad place, then move us further.
      if head.type is 'blockEnd' then moveCursorDown()
    
    # ## Hidden Input events ##

    # For normal text input, we use the "input", "keydownhtml event
    for eventName in ['input', 'keydown', 'keyup', 'keypress']
      @hiddenInput.addEventListener eventName, (event) =>
        # If we haven't focused anything, this input does nothing.
        unless @isEditingText() then return true

        redrawTextInput()

    # For keyboard shortcuts, we use the "keydown" html event
    @hiddenInput.addEventListener 'keydown', (event) =>
      # If we're not actually editing an input, this isn't our responsibility,
      # so return immediately.
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
            moveBlockTo @focus.start.prev.block, head.prev.prev.insert new NewlineToken() # Move the block we're editing into the indent

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
            moveBlockTo @focus.start.prev.block, newIndent.start.insert new NewlineToken()

            # Move the cursor into its proper position (after this block)
            moveCursorTo @focus.start.prev.block.end

            @redraw()
            event.preventDefault(); return false
        when 38 then setTextInputFocus null; @hiddenInput.blur(); moveCursorUp(); @redraw()
        when 40 then setTextInputFocus null; @hiddenInput.blur(); moveCursorDown(); @redraw()
        when 37 then if @hiddenInput.selectionStart is @hiddenInput.selectionEnd and @hiddenInput.selectionStart is 0
          # Pressing the left-arrow at the leftmost end of a socket brings us to the previous socket
          head = @focus.start
          until not head? or head.type is 'socketEnd' and not (head.socket.content()?.type in ['block', 'socket'])
            head = head.prev
            
          # If we have reached the beginning of the file, give up.
          unless head? then return

          setTextInputFocus head.socket
        when 39 then if @hiddenInput.selectionStart is @hiddenInput.selectionEnd and @hiddenInput.selectionStart is @hiddenInput.value.length
          # Pressing right left-arrow at the rightmost end of a socket brings us to the next socket
          head = @focus.end
          until not head? or head.type is 'socketStart' and not (head.socket.content()?.type in ['block', 'socket'])
            head = head.next
            
          # If we have reached the end of the file, give up.
          unless head? then return

          setTextInputFocus head.socket
    
    # When we blur the hidden input, also blur the canvas text focus
    @hiddenInput.addEventListener 'blur', (event) =>
      # If we have actually blurred (as opposed to simply unfocused the browser window)
      if event.target isnt document.activeElement then setTextInputFocus null
    
    # Bind keyboard shortcut events to the document

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
          
          until not head? or head.type is 'socketEnd' and not (head.socket.content()?.type in ['block', 'socket'])
            head = head.prev
          
          unless head? then return

          setTextInputFocus head.socket
        when 39 then if @cursor?
          # Pressing the left-arrow at the rightmost end of a socket brings us to the next socket
          head = @cursor
          until not head? or head.type is 'socketStart' and not (head.socket.content()?.type in ['block', 'socket'])
            head = head.next
            
          # If we have reached the beginning of the file, give up.
          unless head? then return

          setTextInputFocus head.socket
      
      # If we manipulated the root tree, redraw.
      if event.keyCode in [13, 38, 40, 8] then @redraw()
      
      # If we caught the keypress, prevent default.
      if event.keyCode in [13, 38, 40, 8, 37] then event.preventDefault()

    # Hit-testing functions

    hitTest = (point, root) =>
      head = root; seek = null
      while head isnt seek
        if head.type is 'blockStart' and head.block.view.path.contains point
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
            head.socket.view.bounds[head.socket.view.lineStart].contains point
          return head.socket
        head = head.next

      return null
    
    hitTestLasso = (point) => if @lassoSegment? and @_lassoBounds.contains point then @lassoSegment else null

    hitTestPalette = (point) =>
      point = new draw.Point point.x + PALETTE_WIDTH, point.y
      for block in @paletteBlocks
        if hitTest(point, block.start)? then return block
      return null

    # ## The mousedown event ##
    
    # ### getPointFromEvent ###
    # This is a conveneince function, which will contain compatability layers for getting
    # the offset coordinates of a mouse click point

    getPointFromEvent = (event) =>
      switch
        when event.offsetX? then new draw.Point event.offsetX - PALETTE_WIDTH, event.offsetY + @scrollOffset.y
        when event.layerX then new draw.Point event.layerX - PALETTE_WIDTH, event.layerY + @scrollOffset.y
    
    track.addEventListener 'mousedown', (event) =>
      # Only capture left-click
      unless event.button is 0 then return
      
      # Forcefully blur the hidden input if it is focused, removing
      # the focus from any sockets
      @hiddenInput.blur()

      point = getPointFromEvent event

      # See what we picked up
      @ephemeralSelection = hitTestFloating(point) ?
        hitTestLasso(point) ?
        hitTestFocus(point) ?
        hitTestRoot(point) ?
        hitTestPalette(point)
      
      if not @ephemeralSelection?
        # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
        
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

      else if @ephemeralSelection.type is 'socket'
        # If we have clicked on a socket, then TEXT INPUT, indicated by (@isEditingText())
        
        # Set the text input up for editing
        setTextInputFocus @ephemeralSelection
        
        # Don't actually drag anything
        @ephemeralSelection = null

        # We must set a timeout for the following, because until
        # A render has passed, the hidden input is not actually focused.
        setTimeout (=>
          setTextInputAnchor point
          redrawTextInput()
          
          # While the mouse is down, we are trying to select text in the input
          textInputSelecting = true), 0

      else
        # If we have clicked on a block or segment, then NORMAL DRAG, indicated by (@ephemeralSelection?)

        # A flag as to whether we are selecting something in the palette
        selectionInPalette = false

        @ephemeralPoint = new draw.Point point.x, point.y
        
        # Move the cursor to the place we just clicked
        moveCursorTo @ephemeralSelection.end

    # ## Mouse events for NORMAL DRAG ##

    track.addEventListener 'mousemove', (event) =>
      if @ephemeralSelection?
        point = getPointFromEvent event
        
        if point.from(@ephemeralPoint).magnitude() > MIN_DRAG_DISTANCE

          # Move the ephemeral selection into the selection position
          @selection = @ephemeralSelection
          @ephemeralSelection = null

          # Check to make sure that the selection doesn't contain a cursor
          head = @selection.start
          while head isnt @selection.end
            next_head = head.next
            if head.type is 'cursor' then head.remove() # If there is, remove it
            head = next_head
          
          # If we clicked something in the palette, we need to compute offset etc. with a point that has been computed
          # with offset to the palette.
          if @selection in @paletteBlocks then @ephemeralPoint.add PALETTE_WIDTH, 0; selectionInPalette = true

          # Compute the offset of the selection position from the mouse
          rect = @selection.view.bounds[@selection.view.lineStart]
          offset = @ephemeralPoint.from new draw.Point rect.x, rect.y

          # If we have clicked something in the palette, the clone first.
          if selectionInPalette then @selection = @selection.clone()

          # If we have clicked something floating, then delete it from the list of floating blocks
          for float, i in @floatingBlocks
            if float.block is @selection then @floatingBlocks.splice i, 1; break

          # Move it to nowhere
          moveBlockTo @selection, null

          # Draw it in the drag canvas
          @selection.view.compute()
          @selection.view.draw @dragCtx

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
          (not (block.inSocket?() ? false)) and block.view.dropArea? and block.view.dropArea.contains dest

        # If highlight changed, redraw
        if old_highlight isnt highlight then @redraw()

        # Highlight the highlight
        if highlight? then highlight.view.dropHighlightReigon.fill @mainCtx, '#fff'

        # CSS-transform the drag canvas to where it ought to be
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
    
    track.addEventListener 'mouseup', (event) =>
      if @ephemeralSelection?
        @ephemeralSelection = null
        @ephemeralPoint = null

      if @selection?
        # Determine the position of the mouse and the place we want to render the block
        point = getPointFromEvent event
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y

        if highlight?
          # Drop areas signify different things depending on the block that they belong to
          switch highlight.type
            when 'indent'
              head = highlight.end.prev
              while head.type is 'segmentEnd' or head.type is 'segmentStart' or head.type is 'cursor' then head = head.prev

              if head.type is 'newline'
                # There's already a newline here.
                moveBlockTo @selection, highlight.start.next
              else
                # An insert drop signifies that we want to drop the block at the start of the indent
                moveBlockTo @selection, highlight.start.insert new NewlineToken()

            when 'block'
              # A block drop signifies that we want to drop the block after (the end of) the block.
              moveBlockTo @selection, highlight.end.insert new NewlineToken()

            when 'socket'
              # Remove any previously occupying block or text
              if highlight.content()? then highlight.content().remove()

              # Insert
              moveBlockTo @selection, highlight.start
            
            else
              if highlight is @tree
                # We can also drop on the root tree (insert at the start of the program)
                moveBlockTo @selection, @tree.start

                # Don't insert a newline if it would create an empty line at the end of the file.
                unless @selection.end.next is @tree.end
                  @selection.end.insert new NewlineToken()

        else
          # If we have dropped the block in nowhere, append it (and it's floating position) to @floatingBlocks.
          if dest.x > 0
            @floatingBlocks.push
              position: dest
              block: @selection
          
          # If we have dropped the block on the palette, then delete it.
          # This normally requires no operations, but if we have selected it as the lassoSegment,
          # we want to stop drawing its bounding box.
          else if @selection is @lassoSegment
            @lassoSegment = null

        
        # CSS-transform the drag canvas back to the origin
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(0px, 0px)"
        
        # Clear the drag canvas
        @dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted into root, move the cursor to the end of the selection.
        if highlight?
          # Seek the next newline after the end of this block,
          # which is where we'll want to move the cursor
          # (so that it looks like we put it directly after the block).
          moveCursorTo @selection.end

        # Signify that we are no longer in a NORMAL DRAG
        @selection = null
        
        # Redraw after the selection has been set to null, since @redraw is sensitive to what things are being dragged.
        @redraw()

    # ## Mouse events for LASSO SELECT ##

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
        point.add -@scrollOffset.x, -@scrollOffset.y # (position fixed, as in relation to the drag canvas, on which we will draw it)

        # Get the rectangle we want to draw
        rect = getRectFromPoints (new draw.Point @lassoAnchor.x - @scrollOffset.x, @lassoAnchor.y - @scrollOffset.y), point

        # Clear and redraw the lasso on the drag canvas
        @dragCtx.clearRect 0, 0, drag.width, drag.height
        @dragCtx.strokeStyle = '#00f'
        @dragCtx.strokeRect rect.x, rect.y, rect.width, rect.height

    track.addEventListener 'mouseup', (event) =>
      if @lassoAnchor?
        # Determine the position of the mouse
        point = getPointFromEvent event

        # Get the rectangle we want to test
        rect = getRectFromPoints @lassoAnchor, point

        # First pass for lasso segment detection: get intersecting blocks.
        
        # Find the first matching block
        head = @tree.start
        firstLassoed = null
        while head isnt @tree.end
          # A block matches if it intersects the lasso rectangle
          if head.type is 'blockStart' and head.block.view.path.intersects rect
            firstLassoed = head
            break
          head = head.next
        
        # Find the last matching block analagously
        head = @tree.end
        lastLassoed = null
        while head isnt @tree.start
          if head.type is 'blockEnd' and head.block.view.path.intersects rect
            lastLassoed = head
            break
          head = head.prev

        # Unless we have selected anything, give up.
        if firstLassoed? and lastLassoed?
          # Second pass for lasso segment detection: validate the selection and record wrapping blocks as necessary.
          
          tokensToInclude = []

          head = firstLassoed
          while head isnt lastLassoed
            # For each bit of markup, make sure to include both its start token and end token
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

          # Third pass for lasso segment detection: include all necessary tokens demanded by validation

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

          # Fourth pass for lasso segment detection: make sure that we have selected the wrapping block for any indents
          #
          # Note that this will only occur when we have inserted the indentStart at the beginning or indentEnd at the end
          # in the second and third pass. This in turn will occur ONLY when the user has selected multiple blocks belonging to the
          # same wrapping block, and nothing outside it (i.e. the wrapping block of the indent wraps the entire selection).
          #
          # So it suffices to select that entire wrapping block.

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
        @dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted a lasso segment, move the cursor appropriately
        if @lassoSegment? then moveCursorTo @lassoSegment.end
        
        # Flag that we are no longer in a LASSO SELECT.
        @lassoAnchor = null

        @redraw()


    # ## Utility functions for TEXT INPUT ##

    redrawTextInput = =>
      # Change the edited text
      @editedText.value = @hiddenInput.value

      # Redraw the background (main canvas)
      @redraw()
      
      # Determine the position (coordinate-wise) of the typing cursor
      start = @editedText.view.bounds[_editedInputLine].x +
        @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionStart]).width

      end = @editedText.view.bounds[_editedInputLine].x +
        @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionEnd]).width
      
      # Draw the typing cursor itself
      if start is end
        # This is just a line
        @mainCtx.strokeRect start, @editedText.view.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT
      else
        # This is the translucent rectangle
        @mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3'
        @mainCtx.fillRect start, @editedText.view.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT

    setTextInputFocus = (focus) =>
      console.log 'changing focus', @focus, focus

      # Deal with the previous focus
      if @focus?
        try
          console.log 'trying', @focus.toString()
          # Attempt to reparse what's in the indent
          newParse = coffee.parse(@focus.toString()).next
          console.log 'here now', newParse
          if newParse.type is 'blockStart'
            if @focus.handwritten
              newParse.block.moveTo @focus.start.prev.block.start.prev
              @focus.start.prev.block.moveTo null
            else
              if @focus.content()?.type is 'text' then @focus.content().remove()
              else if @focus.content()?.type is 'block' then @focus.content().moveTo null

              newParse.block.moveTo @focus.start
          

        # Fire the onchange handler
        if @onChange? then @onChange new IceEditorChangeEvent @focus, focus

      # Literally set the focus
      @focus = focus
      
      # If we just removed the focus, then we are done.
      if @focus is null then return
      
      # Record the line that the focus is on
      _editedInputLine = @focus.view.lineStart

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
      textInputHead = Math.round (point.x - @focus.view.bounds[_editedInputLine].x) / @mainCtx.measureText(' ').width

      @hiddenInput.setSelectionRange Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead)

    setTextInputAnchor = (point) =>
      textInputAnchor = textInputHead = Math.round (point.x - @focus.view.bounds[_editedInputLine].x - PADDING) / @mainCtx.measureText(' ').width
      @hiddenInput.setSelectionRange textInputAnchor, textInputHead

    # ## Mouse events for TEXT INPUT ##

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

    # ## Mouse events for SCROLLING ##

    track.addEventListener 'mousewheel', (event) =>
      @clear()

      if event.wheelDelta > 0
        if @scrollOffset.y >= 100
          @scrollOffset.add 0, -100
          @mainCtx.translate 0, 100
        else
          # If we would go past the top of the file, just scroll to exactly the top of the file.
          @mainCtx.translate 0, @scrollOffset.y
          @scrollOffset.y = 0
      else
        @scrollOffset.add 0, 100
        @mainCtx.translate 0, -100

      @redraw()

  setValue: (value) ->
    @tree = coffee.parse(value).segment
    @redraw()

  getValue: -> @tree.toString()
  
  # ## performMeltAnimation ##
  # This will animate all the text elements from their current position to a position
  # that imitates plaintext.
  performMeltAnimation: ->
    @redraw()

    # First, we will need to get all the text elements which we will be animating.
    # Simultaneously, we can ask text elements to compute their position as if they were plaintext. This will be the
    # animation destination. Along the way we will move the cursor around due to newlines and indents.
    textElements = []
    translationVectors = []
    head = @tree.start
    # Set up the state which we will pass to 
    state =
      x: 0
      y: 0
      indent: 0
    while head isnt @tree.end
      if head.type is 'text'
        translationVectors.push head.view.computePlaintextTranslationVector state, @mainCtx
        textElements.push head
      else if head.type is 'newline'
        state.y += FONT_SIZE
        state.x = state.indent * @mainCtx.measureText(' ').width
      else if head.type is 'indentStart'
        state.indent += head.indent.depth
      else if head.type is 'indentEnd'
        state.indent -= head.indent.depth

      head = head.next

    # We have now obtained the destination position for the animation; now we animate.
    count = 0

    tick = =>
      console.log 'ticking'
      count += 1
      
      if count < ANIMATION_FRAME_RATE
        setTimeout tick, 1000 / ANIMATION_FRAME_RATE

      @clear()
      
      @mainCtx.globalAlpha = 1 - count / ANIMATION_FRAME_RATE

      @tree.view.draw @mainCtx

      @mainCtx.globalAlpha = 1
      
      for element, i in textElements
        element.view.textElement.draw @mainCtx
        element.view.translate new draw.Point translationVectors[i].x / ANIMATION_FRAME_RATE, translationVectors[i].y / ANIMATION_FRAME_RATE

    tick()
  
  performFreezeAnimation: ->
    @redraw()
    # First, we will need to get all the text elements which we will be animating.
    # Simultaneously, we can ask text elements to compute their position as if they were plaintext. This will be the
    # animation destination. Along the way we will move the cursor around due to newlines and indents.
    textElements = []
    translationVectors = []
    head = @tree.start
    
    # Set up the state which we will pass to 
    state =
      x: 0
      y: 0
      indent: 0
    while head isnt @tree.end
      if head.type is 'text'
        translationVectors.push head.view.computePlaintextTranslationVector state, @mainCtx
        head.view.translate translationVectors[translationVectors.length - 1]
        textElements.push head
      else if head.type is 'newline'
        state.y += FONT_SIZE
        state.x = state.indent * @mainCtx.measureText(' ').width
      else if head.type is 'indentStart'
        state.indent += head.indent.depth
      else if head.type is 'indentEnd'
        state.indent -= head.indent.depth

      head = head.next

    # We have now obtained the destination position for the animation; now we animate.
    count = 0

    tick = =>
      count += 1
      
      if count <= ANIMATION_FRAME_RATE
        setTimeout tick, 1000 / ANIMATION_FRAME_RATE

      @clear()
      
      @mainCtx.globalAlpha = count / ANIMATION_FRAME_RATE

      @tree.view.draw @mainCtx

      @mainCtx.globalAlpha = 1
      
      for element, i in textElements
        element.view.textElement.draw @mainCtx
        element.view.translate new draw.Point -translationVectors[i].x / ANIMATION_FRAME_RATE, -translationVectors[i].y / ANIMATION_FRAME_RATE

    tick()


window.onload = ->
  # ## Tests ##
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

  editor.onChange = ->
    document.getElementById('out').value = editor.getValue()

  document.getElementById('out').addEventListener 'input', ->
    try
      editor.setValue this.value

  document.getElementById('undo').addEventListener 'click', ->
    editor.undo()

