###
# A Block is a bunch of tokens that are grouped together.
###
class Block
  constructor: (contents) ->
    @start = new BlockStartToken this
    @end = new BlockEndToken this
    @type = 'block'

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
        #else head = head.block.end
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
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
  
  # TODO This is really only usable for debugging
  toString: (state) ->
    string = @start.toString(state)
    return string[..string.length-@end.toString(state).length-1]

class Indent
  constructor: (contents, @depth) ->
    @start = new IndentStartToken this
    @end = new IndentEndToken this
    @type = 'indent'

    head = @start
    for block in contents
      head = head.append block.clone()
    head.append @end
    
    @paper = new IndentPaper this

  embedded: -> false

  # TODO This is really only usable for debugging
  toString: (state) ->
    string = @start.toString(state)
    return string[..string.length-@end.toString(state).length-1]

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

class Socket
  constructor: (content) ->
    @start = new SocketStartToken this
    @end = new SocketEndToken this
    
    if content?
      @start.next = @content.start
      @end.prev = @content.end
    else
      @start.next = @end
      @end.prev = @start

    @type = 'socket'

    @paper = new SocketPaper this
  
  embedded: -> false

  content: ->
    if @start.next isnt @end
      return @start.next.block
    else
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

  toString: (state) -> if @content then @content.toString() else ''
  
class Token
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
class TextToken extends Token
  constructor: (@value) ->
    @prev = @next = null
    @paper = new TextTokenPaper this
    @type = 'text'

  toString: (state) ->
    @value + if @next? then @next.toString(state) else ''

class BlockStartToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockStart'

class BlockEndToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockEnd'

class NewlineToken extends Token
  constructor: ->
    @prev = @next = null
    @type = 'newline'

  toString: (state) ->
    '\n' + state.indent + if @next then @next.toString(state) else ''

class IndentStartToken extends Token
  constructor: (@indent) ->
    @prev = @next =  null
    @type = 'indentStart'

  toString: (state) ->
    state.indent += (' ' for [1..@indent.depth]).join ''
    if @next then @next.toString(state) else ''

class IndentEndToken extends Token
  constructor: (@indent) ->
    @prev = @next =  null
    @type = 'indentEnd'

  toString: (state) ->
    state.indent = state.indent[...-@indent.depth]
    if @next then @next.toString(state) else ''

class SocketStartToken extends Token
  constructor: (@socket) ->
    @prev = @next = null
    @type = 'socketStart'

class SocketEndToken extends Token
  constructor: (@socket) ->
    @prev = @next = null
    @type = 'socketEnd'

###
# Example LISP parser/
###

lispParse = (str) ->
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

indentParse = (str) ->

  # First, generate an indent AST
  lines = str.split '\n'
  node = root =
    parent: null
    head: null
    indent: -1
    children: []
  for line in lines
    indent = line.length - line.trimLeft().length
    
    while indent <= node.indent
      node = node.parent

    new_node =
      parent: node
      head: line
      indent: indent
      children: []
    node.children.push new_node
    node = new_node


  # Then generate the ICE token list
  head = first = new TextToken ''
  
  block_stack = []
  socket_stack = []
  indent_stack = []

  (lineate = (_node) ->
    # Put the text on this line
    if _node.head?
      head = head.append new NewlineToken()
      
      currentString = ''
      for char in _node.head[_node.indent..-1]
        switch char
          when '('
            head = head.append new TextToken currentString

            # Make a new Block
            block_stack.push block = new Block []
            socket_stack.push socket = new Socket block
            indents_stack.push null
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
          else
            currentString += char
      head = head.append new TextToken currentString

    # Recurse
    if _node.children.length > 0
      _indent = new Indent [], _node.children[0].indent - _node.indent
      head = head.append _indent.start

      indents_stack.pop()
      indents_stack.push _indent
      
      for child in _node.children
        lineate child
      head = head.append _indent.end
  ) root

  first = first.next.next.next.next.next
  return first

window.ICE =
  lispParse: lispParse
  indentParse: indentParse
