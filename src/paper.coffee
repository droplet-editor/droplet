# Constants
PADDING = 5
INDENT = 13
MOUTH_BOTTOM = 100
DROP_AREA_MAX_WIDTH = 50
window.RUN_PAPER_TESTS = false

class IcePaper
  constructor: (@block) ->

  compute: (state) ->

  draw: ->

  setLeftCenter: (line, point) ->

  translate: (vector) ->

class IndentPaper extends IcePaper
  constructor: (@block) ->

  compute: (state) ->
    @point = new paper.Point 0, 0
    @lines = {}

    elements = []
    @lineStart = lineStart = state.line += 1

    @group = new paper.Group []
    @children = []
    
    ###
    # Loop through the children and compute them
    ###
    head = @block.start.next
    if head isnt @block.end then head = head.next #TODO this is hacky; indents are supposed to contain a newline.
    while head isnt @block.end # (vanilla linked-list loop)
      switch head.type
        when 'text'
          element = head.paper.compute state
          elements.push element
          @children.push element
          @group.addChild element.group
          head = head.next
        when 'blockStart'
          element = head.block.paper.compute state
          elements.push element
          @children.push element
          @group.addChild element.group
          head = head.block.end.next
        when 'newline'
          state.line += 1
          head = head.next
        else
          head = head.next
    
    @lineEnd = state.line

    @lineGroups = {}
    axis = 0 # The middle of the written line
    bottom = 0 # The bottom of the written line
    for line in [lineStart..state.line]
      @lineGroups[line] = (lineGroup = [])
      for element in elements
        # We enforce that elements wanting to appear to the left must also be earlier in the elements array
        if line of element.lines
          # Get the bounding rectangle for this line and element
          lineGroup.push element
          @group.addChild element.group
      
      # All at once, shift the elements in this line group into position
      @setLeftCenter line, new paper.Point 0, axis # TODO this double-setting is super hacky.
      axis = bottom + @lines[line].height / 2
      @setLeftCenter line, new paper.Point 0, axis

      # Recompute the bottom
      bottom += @lines[line].height

      @lines[line].selected = true

    return this
  
  draw: ->
    @group.addChild @_dropArea = new paper.Path.Rectangle new paper.Rectangle @point.subtract(0, 5), new paper.Size(DROP_AREA_MAX_WIDTH, 10)
    @_dropArea.bringToFront()

    for child in @children
      child.draw()

  erase: -> child.erase() for child in @children

  setLeftCenter: (line, point) ->
    # Recreate the rectangle for this line
    @lines[line] = new paper.Rectangle point, new paper.Size 0, 0
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

    for element in @lineGroups[line]
      # Move this element into position
      element.setLeftCenter line, new paper.Point @lines[line].right, point.y
      
      # Update the line
      @lines[line] = @lines[line].unite element.lines[line]

    # Add padding
    leftCenter = @lines[line].leftCenter
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

    if line is @lineStart then @point = @lines[line].point

  translate: (vector) ->
    @point = @point.add vector

    # Translate line records
    for line of @lines
      @lines[line].point = @lines[line].point.add vector

    # Delegate
    for child in @children
      child.translate vector

  setPosition: (point) ->
    vector = point.subtract @point
    @translate vector

  getHeight: ->
    bounds = new paper.Rectangle @group.bounds.point, new paper.Size 0, 0
    for line of @lines
      bounds = bounds.unite @lines[line]
    return bounds.height


class BlockPaper extends IcePaper
  constructor: (@block) ->

  compute: (state) -> # State contains information about the context for this block.
    @lines = {}

    elements = []
    indents = []
    @lineStart = lineStart = state.line
    @indentedLines = {}

    @group = new paper.Group []
    @children = []
    @indentEnds = []
    
    ###
    # Loop through the children and compute them
    ###
    head = @block.start.next
    while head isnt @block.end # (vanilla linked-list loop)
      switch head.type
        when 'text'
          element = head.paper.compute state
          elements.push element
          @children.push element
          @group.addChild element.group
          head = head.next
        when 'blockStart'
          element = head.block.paper.compute state
          elements.push element
          @children.push element
          @group.addChild element.group
          head = head.block.end.next
        when 'indentStart'
          indent = head.indent.paper.compute state
          indents.push indent
          @children.push indent
          @indentEnds[indent.lineEnd] = indent
          @group.addChild indent.group
          head = head.indent.end.next
        when 'socketStart'
          element = head.socket.paper.compute state
          elements.push element
          @children.push element
          @group.addChild element.group
          head = head.socket.end.next
        when 'newline'
          state.line += 1
          head = head.next
        else
          head = head.next
    
    @lineEnd = state.line

    @bounds = {}

    @lineGroups = {}
    axis = 0 # The middle of the written line
    bottom = 0 # The bottom of the written line
    for line in [@lineStart..@lineEnd]
      @lineGroups[line] = (lineGroup = [])
      
      cont = false
      for indent in indents
        if line of indent.lines
          # Skip a bunch of lines
          if line is indent.lineStart
            indent.setPosition new paper.Point INDENT, bottom
          
          @indentedLines[line] = indent

          @bounds[line] = new paper.Rectangle indent.lines[line].point.subtract(INDENT, 0), new paper.Size INDENT, indent.lines[line].height
          @lines[line] = indent.lines[line]
          
          if line is indent.lineEnd
            @lines[line].height += 10
            @bounds[line].height += 10

          bottom += indent.lines[line].height

          cont = true
      if cont then continue

      for element in elements
        # We enforce that elements wanting to appear to the left must also be earlier in the elements array
        if line of element.lines
          # Get the bounding rectangle for this line and element
          lineGroup.push element
      
      # All at once, shift the elements in this line group into position
      @setLeftCenter line, new paper.Point 0, axis # TODO this double-setting is super hacky.
      axis = bottom + @lines[line].height / 2
      @setLeftCenter line, new paper.Point 0, axis

      # Recompute the bottom
      bottom += @lines[line].height

      @lines[line].selected = true

      #line += 1
    
    return this
  
  draw: ->
    # Draw the container
    if @_container? then @_container.remove()
    @_container = new paper.Path()
    @_container.strokeColor = 'black'
    @_container.fillColor = 'white'
    @group.addChild @_container

    for line in [@lineStart..@lineEnd]
      if line of @indentEnds
        # Special end-of-mouth case

        # Right side
        @_container.add @bounds[line].topRight
        @_container.add @bounds[line].bottomRight.add new paper.Point 0, -10

        # Mouth bottom
        @_container.add @bounds[line].bottomRight.add new paper.Point MOUTH_BOTTOM, -10
        @_container.add @bounds[line].bottomRight.add new paper.Point MOUTH_BOTTOM, 0

        # Left side
        @_container.insert 0, @bounds[line].topLeft
        @_container.insert 0, @bounds[line].bottomLeft
      else
        # Other cases
      
        # Right side
        @_container.add @bounds[line].topRight
        @_container.add @bounds[line].bottomRight

        # Left side
        @_container.insert 0, @bounds[line].topLeft
        @_container.insert 0, @bounds[line].bottomLeft
    
    @group.addChild @_dropArea = new paper.Path.Rectangle new paper.Rectangle @_container.bounds.bottomLeft.subtract(0, 5), new paper.Size Math.min(DROP_AREA_MAX_WIDTH, @group.bounds.width), 10
    @_dropArea.closed = true
    @_container.closed = true

    # Fill it up
    for child in @children
      child.draw()
    
    @_dropArea.bringToFront()
    @_container.sendToBack()

  erase: ->
    if @_container? then @_container.remove()
    if @_dropArea? then @_dropArea.remove()
    for child in @children
      child.erase()
  
  deferIndent: (line) -> (line of @indentedLines) and not (line of @indentEnds)

  setLeftCenter: (line, point) ->
    if line of @indentEnds
      @indentedLines[line].setLeftCenter line, point.add INDENT, -5 # TODO this is hacky and I have no idea why it works.
      @bounds[line].point = point.subtract(0, @lines[line].height / 2) # TODO "bounds" is a bad misnomer
      @lines[line] = @indentedLines[line].lines[line]
      @lines[line].width = Math.max @lines[line].width, MOUTH_BOTTOM
      @lines[line].height += 10
      return
    
    if line of @indentedLines
      @indentedLines[line].setLeftCenter line, point.add INDENT, 0
      @bounds[line].point = point.subtract(0, @lines[line].height / 2)
      @lines[line] = @indentedLines[line].lines[line].clone()
      return

    # Recreate the rectangle for this line
    @lines[line] = new paper.Rectangle point, new paper.Size PADDING, 0
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

    for element in @lineGroups[line]
      # Move this element into position
      element.setLeftCenter line, new paper.Point @lines[line].right, point.y
      if element.block.type is 'socket' and element.block.content()? and element.block.content().paper.deferIndent line
        @bounds[line] = element.block.content().paper.bounds[line].clone()
        @lines[line] = element.lines[line].clone()
        return
      
      # Update the line
      @lines[line] = @lines[line].unite element.lines[line]

    # Add padding
    leftCenter = @lines[line].leftCenter
    @lines[line].width += PADDING
    @lines[line].height += PADDING * 2
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

    @bounds[line] = @lines[line].clone()

  translate: (vector) ->
    # Translate the physical outline
    if @_container? then @_container.translate vector
    
    # Translate all our line rectangles
    for line of @lines
      @lines[line].point = @lines[line].point.add vector

    # Bounds too
    for line of @bounds
      @bounds[line].point = @bounds[line].point.add vector
    
    # Delegate.
    for child in @children
      child.translate vector

class SocketPaper extends IcePaper
  constructor: (@block) ->
    @empty = false

  _recopy: ->
    contentPaper = @block.content().paper
    for line of contentPaper.lines
      @lines[line] = contentPaper.lines[line]
    @group = contentPaper.group

  compute: (state) ->
    # If the Socket contains a Block, copy all the Block's properties. Otherwise, make ourselves a 20x20 square on a single line.
    @lines = {}
    if (content = @block.content())?
      content.paper.compute state
      @_recopy()
    else
      @lines[state.line] = new paper.Rectangle 0, 0, 20, 20
      @_line = state.line
      @group = new paper.Group []

    @empty = @block.content?

    return this
  
  draw: ->
    # Delegate to the block if possible, otherwise draw the 20x20 square
    if @_container? then @_container.remove()
    if @block.content()?
      @block.content().paper.draw()
      @group = @block.group
    else
      @_container = new paper.Path.Rectangle @lines[@_line]
      @_container.strokeColor = 'black'

      @_dropArea = @_container.clone()
      @_dropArea.strokeColor = null

      @group.addChild @_container
      @group.addChild @_dropArea

  erase: ->
    # Erase the 20x20 square
    if @_container? then @_container.remove()
  
  setLeftCenter: (line, point) ->
    # Delegate to the Block if possible, otherwise set our 20x20 square center
    if @block.content()?
      @block.content().paper.setLeftCenter line, point
      @lines[line] = @block.content().paper.lines[line] # Re-copy
    else
      @lines[line].point = point.subtract 0, @lines[line].height / 2

  translate: (vector) ->
    # Delegate to the Block if possible, then re-copy all the block's properties. Otherwise translate the 20x20 square.
    if @block.content()?
      @block.content().paper.translate vector
      @_recopy()
    else
      @lines[@_line].point = @lines[@_line].point.add vector

class TextTokenPaper extends IcePaper
  constructor: (@block) ->

  compute: (state) ->
    # Form the text
    if @text? then @text.remove()
    @text = new paper.PointText new paper.Point 0, 0
    @text.content = @block.value
    @text.fillColor = 'black'
    @text.font = 'Courier New'
    @text.fontSize = 18

    # Form the "group"
    @group = new paper.Group [@text]

    # Record the "lines"
    @lines = {}
    @lines[state.line] = @text.bounds

    @line = state.line

    return this

  draw: ->
  erase: -> if @text? then @text.remove()

  setLeftCenter: (line, point) ->
    if line of @lines
      @text.position = new paper.Point (point.x + @text.bounds.width / 2), point.y
    @lines[@line] = @text.bounds

  translate: (vector) ->
    @text.translate vector
    @lines[@line].point = @lines[@line].point.add vector

###
# Tests
###

window.onload = ->
  # Browser flag
  if not window.RUN_PAPER_TESTS then return

  # Setup paper.js
  paper.setup document.getElementById 'canvas'

  # Run a test
  a = ICE.indentParse '''
(defun turing (lambda (tuples left right state)
  ((lambda (tuple)
      (if (= (car tuple) -1)
        (turing tuples (cons (car (cdr tuple) left) (cdr right) (car (cdr (cdr tuple)))))
        (if (= (car tuple 1))
          (turing tuples (cdr left) (cons (car (cdr tuple)) right) (car (cdr (cdr tuple))))
          (turing tuples left right (car (cdr tuple))))))
    (lookup tuples (car right) state)))
  '''
  ###
  a = ICE.indentParse '''
  (lambda
    (lambda
      (x)
      (y)
      (z)))
  '''
  ###
  
  console.log a

  a.block.paper.compute
    line: 0
  a.block.paper.draw()
  
  paper.view.draw()

  tool = new paper.Tool()
  selection = null
  highlight = null
  offset = new paper.Point 0, 0
  event.point = new paper.Point 0, 0

  roots = []

  tool.onMouseDown = (event) ->
    block = a.block.findBlock (block) -> (block.paper._container.hitTest event.point)?
    parent_root = null

    for root in roots
      if (root.paper._container.hitTest event.point)?
        block = root
      found = root.findBlock (block) -> (block.paper._container.hitTest event.point)?
      if found isnt root
        block = found
        parent_root = root

    if block is a.block
      selection = null
      return
    
    if block.start.prev? and block.start.prev.type is 'newline' then block.start.prev.remove()
    block._moveTo null

    selection = block.paper
    
    offset = selection.group.position.subtract event.point
    
    a.block.paper.erase()
    a.block.paper.compute {line: 0}
    a.block.paper.draw()

    if parent_root?
      pos = parent_root.paper.group.position
      parent_root.paper.erase()
      parent_root.paper.compute {line: 0}
      parent_root.paper.draw()
      parent_root.paper.group.position = pos

    out.innerText = a.block.toString {indent: ''}

    # Draw the block we're moving
    selection.erase()
    selection.compute {line:0}
    selection.draw()
    selection.group.position = event.point.add offset
  
  out = document.getElementById 'out'
  
  tool.minDistance = 10 # TODO This is a performance hack. See how low you can take this number!
                        # Try pure svg.

  tool.onMouseUp = (event) ->
    if highlight? and selection?
      if highlight.type is 'block'
        selection.block._moveTo highlight.end.insert new NewlineToken()
      else if highlight.type is 'indent'
        selection.block._moveTo highlight.start.insert new NewlineToken()
      else if highlight.type is 'socket'
        selection.block._moveTo highlight.start

      highlight.paper._dropArea.remove()

      # Redraw
      a.block.paper.erase()
      a.block.paper.compute {line: 0}
      a.block.paper.draw()

      out.innerText = a.block.toString {indent: ''}
    if selection? and not highlight?
      roots.push selection.block

    highlight = selection = null
  
  #paper.view.onFrame = (event) ->
  tool.onMouseMove = (event) ->
    if selection?
      selection.group.position = event.point.add offset
      if highlight? then highlight.paper._dropArea.fillColor = null
      
      # Find the hovered drop area
      highlight = a.block.find (block) ->
        block.paper._dropArea? and block.paper._dropArea.bounds.contains(selection.group.bounds.point) and block.start.prev.type isnt 'socketStart'
      
      if highlight is a.block
        highlight = null
      else
        if highlight.paper.group?
          highlight.paper.group.bringToFront()
        highlight.paper._dropArea.bringToFront()
        selection.group.bringToFront()
        if highlight isnt a.block then highlight.paper._dropArea.fillColor = 'red'
