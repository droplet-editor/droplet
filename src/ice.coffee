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
    return this
  
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
    return this
  
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
    return this

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
    return this

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
    return this

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
