# Tree classes and operations for ICE editor.
#
# Copyright (c) 2014 Anthony Bau.
#
# MIT License.

define ['ice-view'], (view) ->
  exports = {}

  window.printSegment = (seg) ->
    head = seg.start
    until head is seg.end
      console.log head
      head = head.next

  # ## cloneTokens ##
  # Return a pointer-unrelated start and end tokens whose linkage
  # structure is the same as the given start and end tokens.
  exports.cloneTokens = cloneTokens = (start, end) ->
    head = start
    cursor = beginning = new Token()
    
    # This is "while true" to simulate a kind of
    # do-while; we want to actually perform this action
    # the first time our condition is true but no more.
    while true
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
        when 'segmentStart'
          block_clone = head.segment.clone()
          block_clone.start.prev = cursor
          cursor.next = block_clone.start
          cursor = block_clone.end
          head = head.segment.end
        else
          unless head.type is 'cursor' then cursor = cursor.append head.clone()
      
      # Here's the condition we talked about earlier
      if head is end then break

      head = head.next
    
    clonedStart = beginning.next
    clonedEnd = cursor

    beginning.remove()

    return [clonedStart, clonedEnd]
  
  lengthBetween = (start, end) ->
    head = start; len = 1
    until head is end
      head = head.next; len++
    return len

  # # Block
  # The basic data structure in ICE Editor is a linked list. A Block is a group of 
  # two tokens, one start token and one end token. Everything between these tokens
  # is a block's content. Thus "tree" operations are linked-list
  # splices.
  #
  # To handle order-of-operations precedence, a block knows a @precedence, an integer.
  # When we drop block A into socket B then if and only if B.precedence > A.precedence does A
  # wrap itself in parentheses

  exports.Block = class Block
    constructor: (@precedence = 0, @color = '#ddf') ->
      @start = new BlockStartToken this
      @end = new BlockEndToken this

      @start.next = @end; @end.prev = @start

      @currentlyParenWrapped = false

      @type = 'block'

      @selected = false # Are we the selected block?

      @view = new view.BlockView this

      @lineMarked = []
    
    # ## Clone ##
    # Cloning produces a new Block entirely independent
    # of this one (there are no linked-list pointers in common).
    clone: ->
      clone = new Block @precedence, @color
      
      unless @start.next is @end
        [clonedStart, clonedEnd] = cloneTokens @start.next, @end.prev
        
        # Splice the cloned string of tokens into
        # the cloned start and end
        if clonedStart? and clonedEnd?
          clone.start.append clonedStart
          clonedEnd.append clone.end
      
      return clone
    
    length: -> lengthBetween @start, @end
      
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

      # Append newlines to the parent if necessary
      switch parent?.type
        when 'indentStart'
          head = parent.indent.end.prev
          while head.type in ['cursor', 'segmentEnd', 'segmentStart'] then head = head.prev

          if head.type is 'newline'
            parent = parent.next
          else
            parent = parent.insert new NewlineToken()
        when 'blockEnd'
          parent = parent.insert new NewlineToken()

        when 'segmentStart'
          unless parent.next is parent.segment.end
            parent.insert new NewlineToken()
        
        # Remove socket content when necessary
        when 'socketStart'
          parent.socket.content()?.remove()
      
      # Splice ourselves into the requested parent
      if parent?
        @end.next = parent.next
        if parent.next? then parent.next.prev = @end

        parent.next = @start
        @start.prev = parent

      # Check to see if we need to wrap ouselves in parentheses
      # To do this, we find our actual parent (not wrapping segment).
      #
      # First, find the parent we actually droped into.
      while parent? and parent.type is 'segmentStart' then parent = parent.prev
      
      # If the parent was a socket, we might need to wrap.
      # Check the precedence to see if we need to.
      if parent?.type is 'socketStart' and parent.socket.precedence >= @precedence
        # If we need to wrap ourselves in parentheses
        # and we are not currently wrapped, wrap.
        unless @currentlyParenWrapped
          @start.insert new TextToken '('
          @end.insertBefore new TextToken ')'
          @currentlyParenWrapped = true
      
      # If we do not need to wrap, unwrap.
      else if @currentlyParenWrapped
        # Make sure we really can unwrap parentheses.
        unless @start.next.type is 'text' and @end.prev.type is 'text'
          throw new Error 'Cannot unwrap parentheses; parentheses do not exist.'

        # Remove the first and last characters, which ought to
        # be the parentheses
        @start.next.value = @start.next.value[1...]
        @end.prev.value = @end.prev.value[...-1]
        
        # If we just generated empty text things, remove them altogether.
        if @start.next.value.length is 0 then @start.next.remove()
        if @end.prev.value.length is 0 then @end.prev.remove()

        @currentlyParenWrapped = false
    
    # ## checkParenWrap ##
    # Wrap ourselves or unwrap in parentheses if necessary, otherwise do nothing.
    checkParenWrap: ->
      parent = @start.prev
      # To do this, we find our actual parent (not wrapping segment).
      while parent? and parent.type is 'segmentStart' then parent = parent.prev
      if parent?.type is 'socketStart' and parent.socket.precedence > @precedence
        unless @currentlyParenWrapped
          @start.insert new TextToken '('
          @end.insertBefore new TextToken ')'
          @currentlyParenWrapped = true
      else if @currentlyParenWrapped
        @start.next.remove(); @end.prev.remove()
        @currentlyParenWrapped = false
    
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
    
    # ## stringify ##
    # This one is mainly used for debugging. The string representation ("compiled code")
    # for anything between our start and end tokens. This is computed by stringifying
    # everything, then splicing off everything after the end token.
    stringify: -> @start.stringify
        indent: ''
        stopToken: @end

  # # Indent
  # An Indent, like a Block, consists of two tokens, start and end. An Indent also knows its @depth,
  # which is the number of spaces that it is indented in. When compiling/stringifying, every newline
  # inside an indent will add @depth spaces after it.
  exports.Indent = class Indent
    constructor: (@depth) ->
      @start = new IndentStartToken this
      @end = new IndentEndToken this
      @type = 'indent'

      @start.next = @end; @end.prev = @start
      
      @view = new view.IndentView this

    # ## clone ##
    # Like Block, creates an Indent whose string representation and data structure 
    # is identical, but shares no linked-list pointers with us.
    clone: ->
      clone = new Indent @depth
      
      unless @start.next is @end
        [clonedStart, clonedEnd] = cloneTokens @start.next, @end.prev
        
        # Splice the cloned string of tokens into
        # the cloned start and end
        if clonedStart? and clonedEnd?
          clone.start.append clonedStart
          clonedEnd.append clone.end
      
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
    
    # ## stringify ##
    # This one is mainly used for debugging. Like Block.stringify, computes
    # the compiled code for everything between the two end tokens, by stringifying
    # the start and splicing of the string representation of the end.
    stringify: -> @start.stringify
      indent: ''
      stopToken: @end


  # # Segment
  # A Segment is a basically invisible piece of markup, which knows its start and end tokens.
  # In rendering, this is usually passed through unnoticed. It is useful for mass tree operations,
  # for instance the Controller's LASSO SELECT, which will drag multiple blocks at once.
  exports.Segment = class Segment
    constructor: ->
      @start = new SegmentStartToken this
      @end = new SegmentEndToken this
      @type = 'segment'

      @start.next = @end; @end.prev = @start
      
      @view = new view.SegmentView this
    
    length: -> lengthBetween @start, @end

    # ## clone ##
    # Like Block, creates an Segment whose string representation and data structure 
    # is identical, but shares no linked-list pointers with us.
    clone: ->
      clone = new Segment()

      unless @start.next is @end
        [clonedStart, clonedEnd] = cloneTokens @start.next, @end.prev
        
        # Splice the cloned string of tokens into
        # the cloned start and end
        if clonedStart? and clonedEnd?
          clone.start.append clonedStart
          clonedEnd.append clone.end
      
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

      # Append newlines to the parent if necessary
      switch parent?.type
        when 'indentStart'
          head = parent.indent.end.prev
          while head.type in ['cursor', 'segmentEnd', 'segmentStart'] then head = head.prev

          if head.type is 'newline'
            parent = parent.next
          else
            parent = parent.insert new NewlineToken()
        when 'blockEnd'
          parent = parent.insert new NewlineToken()

        when 'segmentStart'
          unless parent.next is parent.segment.end
            parent = parent.insert new NewlineToken()
      
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
      until head is @end
        # If we found a child block, find in there
        if head.type is 'blockStart' and f(head.block) then return head.block.find f
        else if head.type is 'indentStart' and f(head.indent) then return head.indent.find f
        else if head.type is 'socketStart' and f(head.socket) then return head.socket.find f
        head = head.next

      # Couldn't find any, so we are the innermost child fitting f()
      if f(this) then return this
      else return null
    
    # ## stringify ##
    # This one is actually called often from the Controller, since
    # Segments serve as the root elements of every tree. As with Blocks and Indents,
    # this is computed by stringifying the start token (get all code) and splicing off things after
    # the end token.
    stringify: -> @start.stringify
      indent: ''
      stopToken: @end
    
    # ## getTokenAtLocation ##
    # Get the token at serialized location (location), produced
    # with Token::getSerializedLocation()
    getTokenAtLocation: (location) ->
      # A location of "null" means token "null"
      unless location? then return null
      
      # A location of 0 means that the only tokens between
      # the desired location and the start are segmentStart, segmentEnd, and cursor.
      # Doing a normal linked-list thing might result in (null) if the list is empty,
      # so make sure things work.
      if location is 0 then return @start

      # Otherwise, location (n) means the (nth) token
      # from the start (not including segments or the cursor)
      head = @start
      count = 1
      until count is location or not head?
        unless head?.type is 'cursor' then count += 1
        head = head.next

      while head?.type is 'cursor'
        head = head.next
      
      # If we have already reached the end of the document
      # (may happen if the last token is specified),
      # return the end of the document.
      unless head?
        return @end

      return head

    getBlockOnLine: (line) ->
      head = @start; lineCount = 0
      stack = []
      until lineCount is line or not head?
        head = head.next
        switch head.type
          when 'newline' then lineCount++
          when 'blockStart' then stack.push head.block
          when 'blockEnd' then stack.pop()

      while head?.type in ['newline', 'cursor', 'segmentStart', 'segmentEnd'] then head = head.next
      if head?.type is 'blockStart' then stack.push head.block

      return stack[stack.length - 1]

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
    constructor: (content, @precedence = 0) ->
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

      @view = new view.SocketView this
    
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

    stringify: -> @start.stringify
      indent: ''
      stopToken: @end
   
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

    # ## stringify ##
    # Converting a Token to a string gets you the compilation of this
    # and every token after it. 
    stringify: (state) -> if @next? and @next isnt state.stopToken then @next.stringify(state) else ''
    
    # ## getSerializedLocation ##
    # Get dead data representing this token's position in the tree.
    #
    # This is the number of tokens before this token, not including the token itself,
    # and discluding segment markup and cursors.
    getSerializedLocation: ->
      head = this
      count = 0
      until head is null
        unless head.type is 'cursor'
          count += 1
        head = head.prev
      return count

  # # Special kinds of tokens

  # ## CursorToken ##
  # A user's cursor, which the Controller can perform operations at
  # and the View renders as a black triangle
  exports.CursorToken = class CursorToken extends Token
    constructor: ->
      @prev = @next = null
      @view = new view.CursorView this
      @type = 'cursor'

    clone: -> new CursorToken()

  # ## TextToken ##
  # A token representing plain text.
  exports.TextToken = class TextToken extends Token
    constructor: (@value) ->
      @prev = @next = null
      @view = new view.TextView this
      @type = 'text'

    clone: -> new TextToken @value

    stringify: (state) ->
      @value + if @next? and @next isnt state.stopToken then @next.stringify(state) else ''

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

    stringify: (state) ->
      state.indent += (' ' for [1..@indent.depth]).join ''
      if @next and @next isnt state.stopToken then @next.stringify(state) else ''

  exports.IndentEndToken = class IndentEndToken extends Token
    constructor: (@indent) ->
      @prev = @next =  null
      @type = 'indentEnd'

    stringify: (state) ->
      state.indent = state.indent[...-@indent.depth]
      if @next and @next isnt state.stopToken then @next.stringify(state) else ''

  # ## NewlineToken ##
  # This token represents a newline. When stringifying, it inserts (state.indent) spaces
  # if necessary.
  exports.NewlineToken = class NewlineToken extends Token
    constructor: ->
      @prev = @next = null
      @type = 'newline'

    clone: -> new NewlineToken()

    stringify: (state) ->
      '\n' + state.indent + if @next and @next isnt state.stopToken then @next.stringify(state) else ''
  
  return exports
