###
# Constants
###
PADDING = 5
LINE_HEIGHT = 15

class TextTokenPaper
  ###
  # Plain text
  ###
  constructor: (@block) ->
    @_initd = false
    try @_init()

  _init: ->
    @initd = true
    @text = new paper.PointText
      point: [0, 0]
      content: @block.value
      font: 'Courier New'
      fillColor: 'black'

  draw: (state) ->
    unless @initd then @_init()
    @text.bounds.point.x = state.point.x
    @text.position.y = state.axis
    state.point.x += @text.bounds.size.width
    @text.bringToFront()

class BlockPaper
  ###
  # (A block)
  ###

  constructor: (@block) ->
    @padding = 1

    @_initd = false
    
    @_linerect =
      head: new paper.Point 0, 0
      tail: new paper.Point 0, 0

    try @_init
  
  init: (state) ->
    @_linerect.head = new paper.Point state.point.x, state.axis - (LINE_HEIGHT / 2 + @padding * PADDING)
    @container = new paper.Path()
    @container.strokeColor = 'black'
    @container.fillColor = 'white'
    state.point.x += PADDING

  line: (state) ->
    console.log 'lining with', @_linerect

    # Left edge
    @container.insert 0, @_linerect.head
    @container.insert 0, new paper.Point @_linerect.head.x, @_linerect.tail.y

    # Right edge
    @container.add new paper.Point @_linerect.tail.x, @_linerect.head.y
    @container.add @_linerect.tail

    @_linerect = {}

    @padding = 1

  finish: (state) ->
    state.point.x += PADDING
    @_linerect.tail = new paper.Point state.point.x, state.axis + (LINE_HEIGHT / 2 + @padding * PADDING)
    @line state
    @container.closed = true

# Convenience linked-list iterator
_iter = (start, end, f) ->
  while start isnt end
    f start
    start = start.next

# Draw a single line
drawLine = (start, end, state) ->
  # Record the upper-left corner of this line
  state.lineStart = state.point.clone()

  # Draw the left edge of all the present blocks
  for mouth in state.mouthStack
    for block, i in mouth.blockStack
      block._linerect.head = new paper.Point mouth.leftEdge + i * PADDING, state.lineStart.y
  
  # Get the preexisting padding
  mouth = state.mouthStack[state.mouthStack.length - 1]
  tempStack = mouth.blockStack.slice 0
  maxPadding = padding = mouth.padding
  
  # Determine the maximum padding
  _iter start, end, (block) ->
    switch block.type
      when 'blockStart'
        padding++
        tempStack.push block.block.paper
      when 'blockEnd'
        padding--
        tempStack.push block.block.paper

    # Record the required thickness for each block
    for el in tempStack
      if tempStack.length - i > el.padding then el.padding = tempStack.length - i

    # Update maxPadding
    if padding > maxPadding then maxPadding = padding

  # Determine the line axis from the maximum padding
  state.axis = state.point.y + maxPadding * PADDING + (LINE_HEIGHT / 2)
  
window.onload = ->
  paper.setup document.getElementById 'canvas'
  window.blocks = a = ICE.indentParse '''
if a is b
  do a, ->
    b c
  do b, ->
    c d
else
  do c, ->
    d e
  '''
  lastStart = a
  
  state =
    point: new paper.Point 0, 10
    axis: null
    padding: 0
    mouthStack: []
    lastMouth: -> state.lastMouthStack[state.lastMouthStack.length - 1] ? 0
    mouthStack: [corner: new paper.Point 0, 0]

  _iter a, null, (block) ->
    if block.constructor.name is 'NewlineToken'
      drawLine lastStart, block, state
      lastStart = block.next
  
  drawLine lastStart, null, state

  paper.view.draw()
