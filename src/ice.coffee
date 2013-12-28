###
# A RecomputeState is a vanilla stack
###
class RecomputeState
  constructor: ->
    @stack =
      next: null
      data: null
  
  first: -> @stack.data

  push: (element) ->
    @stack =
      next: @stack
      data: element

  pop: ->
    removed = @stack
    @stack = @stack.next
    return removed

###
# A Block is a bunch of tokens that are grouped together.
###
class Block
  constructor: (contents) ->
    # Initialize the start
    @start = new BlockStartToken this

    # Fill up the linked list with the array of tokens we got.
    head = @start
    for token in contents
      head.next = token.clone()
      head.next.previous = head
      head = head.next
    head.next = @end
    
    # Link the token to the end
    @end = new BlockEndToken this

    # Get a visual representation of us
    #@paper = new BlockPaper this

    # Preserve our _recompute state
    #@_recomputeState =

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
    
    # Splice ourselves into the requested parent
    @end.next = parent.next
    parent.next.prev = @end

    parent.next= @start
    @start.prev = parent

  recompute: (state) ->
    # This is really visual-only.
  
  find: (f) ->
    # Find the innermost child fitting function f(x)
    head = @start.next
    while head isnt @end
      # If we found a child block, find in there
      if head.type is 'blockStart' and f head.block
        return head.block.find f
      head = head.next

    # Couldn't find any, so we are the innermost child fitting f()
    return this
  
  # TODO This is really only usable for debugging
  toString: ->
    string = @start.toString()
    return string[..string.length-@end.toString().length-1]
  
class Token
  constructor: ->
    @prev = @next = null

  insert: (token) ->
    if @next? then @next.prev = token
    token.prev = this
    @next = token

  recompute: (state) ->
    if @next? then @next.recompute state

  toString: -> if @next? then @next.toString() else ''

###
# Special kinds of tokens
###
class TextToken extends Token
  constructor: (@value) ->
    @prev = @next = null

  toString: -> @value + if @next? then @next.toString() else ''

class BlockStartToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockStart'
  
  recompute: (state) ->
    # Enter the block
    state.push()
    if @next? then @next.recompute state

class BlockEndToken extends Token
  constructor: (@block) ->
    @prev = @next = null
    @type = 'blockEnd'

  recompute: ->
    # Exit the block
    state.pop()

    # Block.recompute is non-recursive
    @block.recompute state

    # Pass on the linked list
    if @next? then @next.recompute state

class NewlineToken extends Token
  constructor: ->
    @prev = @next = null

  toString: -> '\n' + if @next then @next.toString() else ''

###
# A Socket is a token that a Block can move to.
###
class Socket extends Token
  constructor: (@accepts) ->
    @value = @prev = @next = null
    @type = 'socket'

  toString: -> (if @value? then @value.toString() else '') + (if @next? then @next.toString() else '')

###
# Example LISP parser
###

lispParse = (str) ->
  currentString = ''
  first = head = new TextToken ''
  block_stack = []

  for char in str
    switch char
      when '('
        head = head.insert new TextToken currentString

        # Make a new Block
        block_stack.push block = new Block []
        head = head.insert block.start

        # Append the paren
        head = head.insert new TextToken '('
        
        currentString = ''
      when ')'
        # Append the current string
        head = head.insert new TextToken currentString
        head = head.insert new TextToken ')'
        
        # Pop the Block
        head = head.insert block_stack.pop().end


        currentString = ''
      when ' '
        head = head.insert new TextToken currentString
        head = head.insert new TextToken ' '

        currentString = ''

      when '\n'
        head = head.insert new TextToken currentString
        head = head.insert new NewlineToken()

        currentString = ''
      else
        currentString += char
  
  head = head.insert new TextToken currentString
  return first

window.ICE =
  lispParse: lispParse
