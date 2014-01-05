# Constants
PADDING = 2
INDENT = 7
window.RUN_PAPER_TESTS = false

class IcePaper
  constructor: (@block) ->

  compute: (state) ->

  draw: ->

  netLeftCenter: (line, point) ->

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
    head = @block.start.next.next
    while head isnt @block.end # (vanilla linked-list loop)
      switch head.type
        when 'text'
          element = head.paper.compute state
          elements.push element
          @children.push element
          head = head.next
        when 'blockStart'
          element = head.block.paper.compute state
          elements.push element
          @children.push element
          head = head.block.end.next
        when 'newline'
          state.line += 1
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
  
  draw: -> child.draw() for child in @children

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
          head = head.next
        when 'blockStart'
          element = head.block.paper.compute state
          elements.push element
          @children.push element
          head = head.block.end.next
        when 'indentStart'
          indent = head.indent.paper.compute state
          indents.push indent
          @children.push indent
          head = head.indent.end.next
        when 'newline'
          state.line += 1
          head = head.next
    
    @lineEnd = state.line

    @lineGroups = {}
    axis = 0 # The middle of the written line
    bottom =0 # The bottom of the written line
    for line in [lineStart..state.line]
      @lineGroups[line] = (lineGroup = [])
      
      for indent in indents
        if line of indent.lines
          # Skip a bunch of lines
          if line is indent.lineStart
            indent.setPosition new paper.Point INDENT, bottom
          
          @indentedLines[line] = indent

          @lines[line] = new paper.Rectangle indent.lines[line].point.subtract(INDENT, 0), new paper.Size INDENT, indent.lines[line].height
          @group.addChild element.group
          bottom += indent.lines[line].height
          cont = true
      if cont then continue

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

      line += 1
    
    return this
  
  draw: ->
    # Draw the container
    @_container = new paper.Path()
    @_container.strokeColor = 'black'

    for line in [@lineStart..@lineEnd]
      # Right side
      @_container.add @lines[line].topRight
      @_container.add @lines[line].bottomRight

      # Left side
      @_container.insert 0, @lines[line].topLeft
      @_container.insert 0, @lines[line].bottomLeft

    @_container.closed = true

    # Fill it up
    for child in @children
      child.draw()

  setLeftCenter: (line, point) ->
    if line of @indentedLines
      @indentedLines[line].setLeftCenter line, point.add INDENT, 0
      @lines[line].point = point.subtract(0, @lines[line].height / 2)
      return

    # Recreate the rectangle for this line
    @lines[line] = new paper.Rectangle point, new paper.Size PADDING, 0
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

    for element in @lineGroups[line]
      # Move this element into position
      element.setLeftCenter line, new paper.Point @lines[line].right, point.y
      
      # Update the line
      @lines[line] = @lines[line].unite element.lines[line]

    # Add padding
    leftCenter = @lines[line].leftCenter
    @lines[line].width += PADDING
    @lines[line].height += PADDING * 2
    @lines[line].point = point.subtract(0, @lines[line].height / 2)

  translate: (vector) ->
    # Translate the physical outline
    if @_container? then @_container.translate vector
    
    # Translate all our line rectangles
    for line of @lines
      @lines[line].point = @lines[line].point.add vector
    
    # Delegate.
    for child in @children
      child.translate vector

class TextTokenPaper extends IcePaper
  constructor: (@block) ->

  compute: (state) ->
    # Form the text
    @text = new paper.PointText new paper.Point 0, 0
    @text.content = @block.value
    @text.fillColor = 'black'
    @text.font = 'Courier New'

    # Form the "group"
    @group = new paper.Group [@text]

    # Record the "lines"
    @lines = {}
    @lines[state.line] = @text.bounds

    @line = state.line

    return this

  draw: ->

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
  window.onload = ->
    paper.setup document.getElementById 'canvas'
    for i in [1..4]
      square = paper.Path new paper.Rectangle
        point: new paper.Point i, i
        size: new paper.Size i, i
      paper.view.draw()
      if i % 2 is 0
        alert 'even'
        if i is nested
          nesting
            nesting
              nesting
      else
        alert 'bad'
    if done_drawing()
      alert 'done drawing'
  '''

  a.block.paper.compute
    line: 0
  a.block.paper.draw()
  
  paper.view.draw()
