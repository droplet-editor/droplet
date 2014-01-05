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
    @start = new BlockStartToken this
    @end = new BlockEndToken this

    # Fill up the linked list with the array of tokens we got.
    head = @start
    for token in contents
      head = head.insert token.clone()
    head.insert @end

    @paper = new BlockPaper this

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
  toString: (state) ->
    string = @start.toString(state)
    return string[..string.length-@end.toString(state).length-1]

class Indent
  constructor: (contents, @depth) ->
    @start = new IndentStartToken this
    @end = new IndentEndToken this

    head = @start
    for block in contents
      head = head.insert block.clone()
    head.insert @end
    
    @paper = new IndentPaper this

  # TODO This is really only usable for debugging
  toString: (state) ->
    string = @start.toString(state)
    return string[..string.length-@end.toString(state).length-1]
  
class Token
  constructor: ->
    @prev = @next = null

  insert: (token) ->
    if @next? then @next.prev = token
    token.prev = this
    @next = token

  recompute: (state) ->
    if @next? then @next.recompute state

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

###
# Example LISP parser/
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
  (lineate = (_node) ->
    _block = new Block []

    # Put the text on this line
    if _node.head?
      head = head.insert new NewlineToken()
      head = head.insert _block.start
      head = head.insert new TextToken _node.head[_node.indent..-1]

    # Recurse
    if _node.children.length > 0
      _indent = new Indent [], _node.children[0].indent - _node.indent
      head = head.insert _indent.start
      for child in _node.children
        lineate child
      head = head.insert _indent.end
    
    # End
    head = head.insert _block.end
  ) root

  first = first.next.next.next


  return first

window.ICE =
  lispParse: lispParse
  indentParse: indentParse
