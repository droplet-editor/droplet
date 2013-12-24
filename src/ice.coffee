class State
  ###
  # RecomputeState is just a stack.
  ###
  constructor: (elements) ->
    @stack =
      next: null
      element: null
    for element in elements
      @push element

  pop: -> @stack = @stack.next

  push: (element) ->
    new_stack =
      next: @stack
      element: element
    @stack = new_stack
  
  first: -> @stack.element

###
# The "default" state for when we know nothing about a block or field
###
defaultStateElement = ->
  # TODO Metadata
  multiline: false

defaultState = -> new State [defaultStateElement()]

###
# A Block is the draggable wrapper for Sockets
###
class Block
  constructor: (@prev, @next) ->
    @paper = null
    
    #TODO Metadata
    @multiline = false
  
  moveTo: (socket) ->
    # Unlink ourselves from the list
    @prev.empty()
    @prev = null
    
    # Remove whatever value is in there, if it exists
    socket.empty()
    
    # Insert ourselves into the socket
    @prev = socket
    @next = socket.next
    socket.insert this

    # Trigger a recompute
    @next.recompute new State [
      # TODO Metadata
      multiline: @multiline
    ]

  recompute: (state) ->
    # Block recomputes push to the stack
    state.push defaultStateElement()
    @next.recompute state

  _endRecompute: (state, next) ->
    # TODO Metadata
    @multiline = state.first.multiline
    
    # TODO Metadata
    state.pop() # Pop from the stack
    if next.type isnt 'connection' then state.first.multiline = @multiline # All parents are multiline
    
    # Pass on to the next recompute
    next.recompute state

  stringify: ->
    return @next.stringify
  
class Socket
  constructor: (@prev, @next) ->
    @paper = null
    
    # TODO Metadata
    @multiline = false # Does this socket contain a multiline instance?
    @type = null # in [connection, inline, indent, break, end]
  
  empty: -> @next = @next.next

  insert: (next) -> @next = next
  
  recompute: (state) ->
    if type is 'end'
      # If we are a block end socket, pass to the block's _endRecompute
      @block._endRecompute state, @next
    else
      # TODO Metadata
      @next.recompute state

  stringify: ->
    string = if typeof value is 'string' or value instanceof String then value else ''
    return string + @next.stringify()
