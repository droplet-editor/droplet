define ['ice-coffee', 'ice-draw', 'ice-model'], (coffee, draw, model) ->
  # # Magic constants
  PALETTE_TOP_MARGIN = 5
  MIN_DRAG_DISTANCE = 5
  PALETTE_LEFT_MARGIN = 5
  PALETTE_WIDTH = 300

  exports = {}

  ###########################################
  # FOUNDATION
  ###########################################

  # # Editor event bindings
  #
  # These are different events associated with the Editor
  # that features will want to bind to.
  editorBindings = {
    'populate': []

    'resize': []
    'redraw_main': []
    'redraw_palette': []

    'mousedown': []
    'mousemove': []
    'mouseup': []

    'keydown': []
    'keyup': []
  }
  
  # # The Editor Class
  exports.Editor = class Editor
    constructor: (@wrapperElement, @paletteGroups) ->
      # # DOM Population
      # This stage of ICE Editor construction populates the given wrapper
      # element with all the necessary ICE editor components.
      
      # ## Wrapper
      # Create the div that will contain all the ICE Editor graphics

      @iceElement = document.createElement 'div'
      @iceElement.className = 'ice-wrapper-div'

      # We give our element a tabIndex so that it can be focused and capture keypresses.
      @iceElement.tabIndex = 0
      
      # Append that div.
      @wrapperElement.appendChild @iceElement

      # ## Tracker
      # Create the div that will track all the ICE editor mouse movement

      @tracker = document.createElement 'div'
      @tracker.className = 'ice-track-area'
      
      # Append that div.
      @wrapperElement.appendChild @tracker
      
      # ## Canvases
      # Create the palette and main canvases

      # Main canvas first
      @mainCanvas = document.createElement 'canvas'
      @mainCanvas.className = 'ice-main-canvas'

      @mainCtx = @mainCanvas.getContext '2d'
      
      @wrapperElement.appendChild @mainCanvas
      
      # Then palette canvas
      @paletteCanvas = document.createElement 'canvas'
      @paletteCanvas.className = 'ice-palette-canvas'

      @paletteCtx = @paletteCanvas.getContext '2d'

      @wrapperElement.appendChild @paletteCanvas
      
      # Call all the feature bindings that are supposed
      # to happen now.
      for binding in editorBindings.populate
        binding.call this
      
      # # Resize
      # This stage of ICE editor construction, which is repeated
      # whenever the editor is resized, should adjust the sizes
      # of all the ICE editor componenents to fit the wrapper.
      window.addEventListener 'resize', @resize

      @resize()

      # # Tracker Events
      # We allow binding to the tracker element.
      for eventName in ['mousedown', 'mouseup', 'mousemove'] then do (eventName) =>
        @tracker.addEventListener eventName, (event) =>
          trackPoint = @getPointRelativeToTracker event
          
          # We keep a state object so that handlers
          # can know about each other.
          state = {}
          
          # Call all the handlers.
          for handler in editorBindings[eventName]
            handler.call this, trackPoint, event, state
      
      # # Document initialization
      # We start of with an empty document
      @tree = new model.Segment()

      # Now that we've populated everything, immediately redraw.
      @redrawMain(); @redrawPalette()

    resize: ->
      @mainCanvas.height = @iceElement.offsetHeight
      @mainCanvas.width = @iceElement.offsetWidth - PALETTE_WIDTH

      @mainCanvas.style.height = "#{@mainCanvas.height}px"
      @mainCanvas.style.width = "#{@mainCanvas.width}px"

      @paletteCanvas.height = @iceElement.height - @paletteHeaderHeight
      @paletteCanvas.width = PALETTE_WIDTH

      @paletteCanvas.style.height = "#{@paletteCanvas.height}px"
      @paletteCanvas.style.width = "#{@paletteCanvas.width}px"

      for binding in editorBindings.resize
        binding.call this, event

    # # Redraw
    # There are two different redraw events, redraw_main and redraw_palette,
    # for redrawing the main canvas and palette canvas, respectively.
    # 
    # Redrawing simply involves issuing a call to the View. We need to
    # do a little bit of dirty work rendering floating blocks.
    
    clearMain: ->
      @mainCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @mainCanvas.width, @mainCanvas.height

    redrawMain: ->
      unless @currentlyAnimating
        # Set our draw tool's font size
        # to the font size we want
        draw._setGlobalFontSize @fontSize

        # Supply our main canvas for measuring
        draw._setCTX @mainCtx
        
        # Clear the main canvas
        @clearMain()

        # Draw the new tree on the main context
        @tree.view.compute(); @tree.view.draw @mainCtx

        for binding in editorBindings.redraw_main
          binding.call this
    
    clearPalette: ->
      @paletteCtx.clearRect @scrollOffsets.palette.x, @scrollOffsets.palette.y, @paletteCanvas.width, @paletteCanvas.height

    redrawPalette: ->
      @clearPalette()

      # Supply our palette canvas for text measuring
      draw._setCTX @paletteCtx

      draw._setGlobalFontSize @fontSize
      
      # We will construct a vertical layout
      # with padding for the palette blocks.
      # To do this, we will need to keep track
      # of the last bottom edge of a palette block.
      lastBottomEdge = PALETTE_TOP_MARGIN

      for paletteBlock in @currentPaletteBlocks
        # Layout this block
        paletteBlock.view.compute()
        paletteBlock.view.translate new draw.Point PALETTE_LEFT_MARGIN, lastBottomEdge

        # Render the block
        paletteBlock.view.draw @paletteCtx
        
        # Update lastBottomEdge
        lastBottomEdge = paletteBlock.view.getBounds().bottom() + PALETTE_MARGIN

    # # Mouse Interaction Utility Functions
    # These are some common operations we need to do with
    # the mouse that will be convenient later.

    # ## getPointRelativeToTracker
    # Given a mousedown/touchstart event,
    # get its coordinates relative to the tracker element.

    getPointRelativeToTracker: (event) ->
      # There are two cases we have to deal
      # with here for browser compatability.

      # The first is Chrome and Safari.
      if event.offsetX?
        # We want this point relative to the tracker element.
        point = new draw.Point event.offsetX, event.offsetY
      
      # The second is Firefox.
      else
        point = new draw.Point event.layerX, event.layerY
      
      # Now, we want to get this point relative to the tracker element,
      # so we need to bubble up its parents until we reach it.
      target = event.target

      until target is @tracker
        point.x += target.offsetLeft
        point.y += target.offsetTop

        target = target.offsetParent

      # Now we're done.
      return point
    
    # ## Conversion functions
    # Convert a point relative to the tracker into
    # a point relative to one of the two canvases.
    trackerPointToMain: (point) ->
      new draw.Point(
        point.x - @mainCanvas.offsetLeft + @scrollOffsets.main.x
        point.y - @mainCanvas.offsetTop + @scrollOffsets.main.y
      )

    trackerPointToPalette: (point) ->
      new draw.Point(
        point.x - @paletteCanvas.offsetLeft + @scrollOffsets.palette.x,
        point.y - @paletteCanvas.offsetTop + @scrollOffsets.palette.y
      )
    
  # ## hitTest
  # Simple function for going through a linked-list block
  # and seeing what the innermost child is that we hit.
  hitTest = (point, block) ->
    head = block.start; seek = block.end
    
    until head is seek
      if head.type is 'blockStart' and head.block.view.path.contains point
        seek = head.block.end
      head = head.next
    
    # If we had a child hit, return it.
    if head isnt block.end
      return head.block
    
    # If we didn't have a child hit, it's possible
    # that _we_ are the innermost child that hit. See if that's
    # the case.
    else if block.type is 'block' and block.view.path.contains point
      return block
    
    # Nope, it's not. Answer is null.
    else return null

  ###########################################
  # BASIC BLOCK MOVE SUPPORT
  ###########################################
  
  # At population-time, we will
  # want to set up a few fields.
  editorBindings.populate.push ->
    @clickedPoint = null
    @clickedBlock = null

    @draggingBlock = null
    @draggingOffset = null
    
    @lastHighlight = null

    # We will also have to initialize the
    # drag canvas.
    @dragCanvas = document.createElement 'canvas'
    @dragCanvas.className = 'ice-drag-canvas'

    @dragCtx = @dragCanvas.getContext '2d'
    
    # We append it to the tracker element,
    # so that it can appear in front of the scrollers.
    @tracker.appendChild @dragCanvas
  
  # Utility function for clearing the drag canvas,
  # an operation we will be doing a lot.
  Editor::clearDrag = ->
    @dragCtx.clearRect 0, 0, @dragCanvas.width, @dragCanvas.height

  # On resize, we will want to size the drag canvas correctly.
  editorBindings.resize.push ->
    @dragCanvas.width = @iceElement.offsetWidth - PALETTE_WIDTH
    @dragCanvas.height = @iceElement.offsetHeight
  
  # On mousedown, we will want to
  # hit test blocks in the root tree to
  # see if we want to move them.
  #
  # We do not do anything until the user
  # drags their mouse five pixels
  editorBindings.mousedown.push (point, event, state) ->
    # Hit test against the tree.
    hitTestResult = hitTest @trackerPointToMain(point), @tree
    
    # If it came back positive,
    # deal with the click.
    if hitTestResult?
      # Record the hit test result (the block we want to pick up)
      @clickedBlock = hitTestResult

      # Record the point at which is was clicked (for clickedBlock->draggingBlock)
      @clickedPoint = point
    
      # Signify to any other hit testing
      # handlers that we have already consumed
      # the hit test opportunity for this event.
      state.consumedHitTest = true
  
  # If the user lifts the mouse
  # before they have dragged five pixels,
  # abort stuff.
  editorBindings.mouseup.push (point, event, state) ->
    # @clickedBlock and @clickedPoint should will exist iff
    # we have dragged not yet more than 5 pixels.
    #
    # To abort, all we need to do is null.
    if @clickedBlock?
      @clickedBlock = null
      @clickedPoint = null
  
  # On mousemove, if there is a clicked block but no drag block,
  # we might want to transition to a dragging the block if the user
  # moved their mouse far enough.
  editorBindings.mousemove.push (point, event, state) ->
    if @clickedBlock? and point.from(@clickedPoint).magnitude() > MIN_DRAG_DISTANCE
      # Signify that we are now dragging a block.
      @draggingBlock = @clickedBlock
      @draggingOffset = @draggingBlock.view.bounds[@draggingBlock.view.lineStart].upperLeftCorner().from(
        @trackerPointToMain(@clickedPoint))

      # Take the block out of the tree
      @moveBlockTo @draggingBlock, null

      # Draw the new dragging block on the drag canvas.
      # 
      # When we are dragging things, we draw the shadow.
      # Also, we translate the block 1x1 to the right,
      # so that we can see its borders.
      @draggingBlock.view.compute(); @draggingBlock.view.translate new draw.Point 1, 1
      @draggingBlock.view.drawShadow @dragCtx
      @draggingBlock.view.draw @dragCtx

      # Now we are done with the "clickedX" suite of stuff.
      @clickedPoint = @clickedBlock = null

  # On mousemove, if there is a dragged block, we want to
  # translate the drag canvas into place,
  # as well as highlighting any focused drop areas.
  editorBindings.mousemove.push (point, event, state) ->
    if @draggingBlock?
      # Translate the drag canvas into position.
      position = new draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )
      
      @dragCanvas.style.top = "#{position.y}px"
      @dragCanvas.style.left = "#{position.x}px"
      
      mainPoint = @trackerPointToMain(position)
      
      # If we are dragging a block,
      # we can drop on any Block not in a socket,
      # any Indent, or any Socket that does
      # not contain a block.
      if @draggingBlock.type is 'block'
        highlight = @tree.find (block) ->
          (not (block.inSocket?() ? false)) and
            block.view.dropArea? and
            block.view.dropArea.contains mainPoint
      
      # If we are dragging a segment,
      # we also cannot drop ourselves
      # into a socket.
      else if @draggingBlock.type is 'segment'
        highlight = @tree.find (block) ->
          (block.type isnt 'socket') and
            (not (block.inSocket?() ? false)) and
            block.view.dropArea? and
            block.view.dropArea.contains mainPoint

      # For performance reasons,
      # we will only redraw the main canvas
      # (and highlight the reigon) if we need
      # to to change the highlighted block.
      #
      # i.e. if nothing has changed, don't
      # redraw.
      if highlight isnt @lastHighlight
        @redrawMain()

        if highlight?
          highlight.view.dropHighlightRegion.fill @mainCtx, '#fff'

        @lastHighlight = highlight

  editorBindings.mouseup.push (point, event, state) ->
    # We will consume this event iff we dropped it successfully
    # in the root tree.
    if @draggingBlock? and @lastHighlight?
      # Depending on what the highlighted element is,
      # we might want to drop the block at its
      # beginning or at its end.
      switch @lastHighlight.type
        when 'indent', 'socket'
          @moveBlockTo @draggingBlock, @lastHighlight.start
        when 'block'
          @moveBlockTo @draggingBlock, @lastHighlight.end
        else
          if @lastHighlight is @tree
            @moveBlockTo @selection, @tree.start
    
      # Now that we've done that, we can annul stuff.
      @draggingBlock = null
      @draggingOffset = null
      @lastHighlight = null
      
      @clearDrag()
      @redrawMain()

  ###########################################
  # FLOATING BLOCK SUPPORT
  ###########################################
  
  class FloatingBlockRecord
    constructor: (@block, @position) ->

  editorBindings.populate.push ->
    @floatingBlocks = []

  # We can create floating blocks by dropping
  # blocks without a highlight.
  editorBindings.mouseup.push (point, event, state) ->
    if @draggingBlock? and not @lastHighlight? and point.x > 0
      # Before we put this block into our list of floating blocks,
      # we need to figure out where on the main canvas
      # we are going to render it.
      mainCanvasPoint = @trackerPointToMain point
      renderPoint = new draw.Point(
        mainCanvasPoint.x + @draggingOffset.x,
        mainCanvasPoint.y + @draggingOffset.y
      )

      # Add this block to our list of floating blocks
      @floatingBlocks.push new FloatingBlockRecord(
        @draggingBlock,
        renderPoint
      )
      
      # Now that we've done that, we can annul stuff.
      @draggingBlock = null
      @draggingOffset = null
      @lastHighlight = null
      
      @clearDrag()
      @redrawMain()
  
  # On mousedown, we can hit test for floating blocks.
  editorBindings.mousedown.push (point, event, state) ->
    # Hit test against floating blocks
    for record, i in @floatingBlocks
      hitTestResult = hitTest @trackerPointToMain(point), record.block

      if hitTestResult?
        @clickedBlock = record.block
        @clickedPoint = point

        @floatingBlocks.splice i, 1
        
        @redrawMain()
  
  # On redraw, we draw all the floating blocks
  # in their proper positions.
  editorBindings.redraw_main.push ->
    for record in @floatingBlocks
      record.block.view.compute()
      record.block.view.translate record.position

      record.block.view.draw @mainCtx
  
  ###########################################
  # SCROLLING SUPPORT: TODO
  ###########################################

  editorBindings.populate.push ->
    @scrollOffsets = {
      main: new draw.Point 0, 0
      palette: new draw.Point 0, 0
    }

  ###########################################
  # PALETTE SUPPORT: TODO
  ###########################################
  
  editorBindings.populate.push ->
    @currentPaletteBlocks = []

  ###########################################
  # MULTIPLE FONT SIZE SUPPORT: TODO
  ###########################################
  editorBindings.populate.push ->
    @fontSize = 15

  ###########################################
  # UNDO SUPPORT: TODO
  ###########################################
  Editor::moveBlockTo = (block, dest) ->
    block.moveTo dest

  Editor::clearUndoStack = ->

  # # GET/SET VALUE
  # Simple getters and setters for editor value.

  Editor::setValue = (value) ->
    @tree = coffee.parse value
    @redrawMain()

  Editor::getValue = -> @tree.stringify()

  return exports
