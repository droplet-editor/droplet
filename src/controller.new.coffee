define ['ice-coffee', 'ice-draw', 'ice-model'], (coffee, draw, model) ->
  # # Magic constants
  PALETTE_TOP_MARGIN = 5
  PALETTE_MARGIN = 5
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
  unsortedEditorBindings = {
    'populate': []

    'resize': []
    'redraw_main': []
    'redraw_palette': []

    'mousedown': []
    'mousemove': []
    'mouseup': []

    'mutation': []

    'key': []
  }

  editorBindings = {}
  
  # This hook function is for convenience,
  # for features to add events that will occur at
  # various times in the editor lifecycle.
  hook = (event, priority, fn) ->
    if event.indexOf('.') > 0
      console.log event[...event.indexOf('.')]
      unsortedEditorBindings[event[...event.indexOf('.')]].push {
        priority: priority
        fn: {
          combo: event[event.indexOf('.') + 1..]
          fn: fn
        }
      }
    else
      unsortedEditorBindings[event].push {
        priority: priority
        fn: fn
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
      @iceElement.appendChild @tracker
      
      # ## Canvases
      # Create the palette and main canvases

      # Main canvas first
      @mainCanvas = document.createElement 'canvas'
      @mainCanvas.className = 'ice-main-canvas'

      @mainCtx = @mainCanvas.getContext '2d'
      
      @iceElement.appendChild @mainCanvas
      
      # Then palette canvas
      @paletteCanvas = document.createElement 'canvas'
      @paletteCanvas.className = 'ice-palette-canvas'

      @paletteCtx = @paletteCanvas.getContext '2d'

      @iceElement.appendChild @paletteCanvas
      
      # Call all the feature bindings that are supposed
      # to happen now.
      for binding in editorBindings.populate
        binding.call this
      
      # # Resize
      # This stage of ICE editor construction, which is repeated
      # whenever the editor is resized, should adjust the sizes
      # of all the ICE editor componenents to fit the wrapper.
      window.addEventListener 'resize', =>
        @resize()
        @redrawMain(); @redrawPalette()

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

      # We also allow binding to keypresses in the element.
      # We will use dmauro's Keypress library for keyboard-shortcut
      # input.
      @keyListener = new window.keypress.Listener @iceElement
      for listener in editorBindings.key then do (listener) =>
        @keyListener.simple_combo listener.combo, =>
          listener.fn.call this
      
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
      
      @paletteCanvas.style.top = @paletteHeaderHeight
      @paletteCanvas.height = @iceElement.offsetHeight - @paletteHeaderHeight
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
  # UNDO STACK SUPPORT
  ###########################################

  # We must declare a few
  # fields a populate time
  hook 'populate', 0, ->
    @undoStack = []
  
  # The UndoOperation class is the base
  # class for all undo operations.
  class UndoOperation
    constructor: ->

    # Undo and redo should return
    # the desired new cursor position.
    undo: (editor) -> editor.tree.start
    redo: (editor) -> editor.tree.start
  
  # addMicroUndoOperation pushes
  # the given operation to the undo stack,
  # and might possibly do some bureaucracy in the future.
  Editor::addMicroUndoOperation = (operation) ->
    @undoStack.push operation
    
    # We allow binding to mutation;
    # all mutation must call addMicroUndoOperation.
    for binding in editorBindings.mutation
      binding.call this
  
  # The undo function pops and undoes
  # operations from the undo stack until
  # we reach a capture point.
  Editor::undo = ->
    # If the undo stack is empty, give up
    if @undoStack.length is 0 then return

    # Otherwise, try to undo the operation
    operation = @undoStack.pop()
    
    # If the operation is a capture point, stop.
    #
    # NOTE: Right now capture points are signified by the
    # string 'CAPTURE_POINT'; this may need to be changed
    # in the future.
    if operation is 'CAPTURE_POINT' then return
    else
      # Otherwise, apply the undo operation and
      # recurse.
      @moveCursorTo operation.undo this
      @undo()

    @redrawMain()
  
  # We'll also allow users to clear
  # the undo stack.
  Editor::clearUndoStack = ->
    @undoStack.length = 0

  # Now we hook to ctrl-z to undo.
  hook 'key.ctrl z', 0, ->
    @undo()

  ###########################################
  # BASIC BLOCK MOVE SUPPORT
  ###########################################
  
  # Set up the undo operation for
  # block moving.
  class PickUpOperation extends UndoOperation
    constructor: (block) ->
      @block = block.clone()
      beforeToken = block.start.prev
      
      # For the "before" location, we don't actually want
      # the thing before; we want the place at which we can
      # place the block to get it back to what it used to be.
      while beforeToken?.prev? and beforeToken.type in ['newline', 'segmentStart', 'cursor']
        beforeToken = beforeToken.prev

      @before = beforeToken?.getSerializedLocation() ? null

    undo: (editor) ->
      # If the block used to be at null, we don't need to do anything.
      unless @before? then return

      console.log editor.tree.getTokenAtLocation @before

      # Move a clone into position.
      (clone = @block.clone()).moveTo editor.tree.getTokenAtLocation @before
      
      # Move the cursor to the end of it.
      return clone.end

    redo: (editor) ->
      # If the operation was a no-op, redo is a no-op.
      unless @before? then return

      # Find the block we want to remove
      blockStart = editor.tree.getTokenAtLocation @before
      until blockStart.type is @block.start.type then blockStart = blockStart.next
      
      # Move it to null.
      if @block.start.type is 'segment'
        blockStart.segment.moveTo null

      else
        blockStart.block.moveTo null
      
      # Move the cursor somewhere close to what we
      # just deleted.
      return editor.tree.getTokenAtLocation @before

  class DropOperation extends UndoOperation
    constructor: (block, dest) ->
      @block = block.clone()
      @dest = dest?.getSerializedLocation() ? null
      
      if dest?.type is 'socketStart'
        @displacedSocketText = dest.socket.content()?.clone() ? null
      else @displacedSocketText = null

    undo: (editor) ->
      # If the operation was a no-op, undo is a no-op.
      unless @dest? then return

      # Find the block we want to remove
      blockStart = editor.tree.getTokenAtLocation @dest
      until blockStart.type is @block.start.type then blockStart = blockStart.next
      
      # Move it to null.
      if @block.start.type is 'segment'
        blockStart.segment.moveTo null

      else
        blockStart.block.moveTo null
      
      # We may need to replace some of displaced
      # socket text from dropping a block
      # into a socket. If so, do so.
      if @displacedSocketText?
        editor.tree.getTokenAtLocation(@dest).insert @displacedSocketText.clone()
      
      # Move the cursor somewhere close to what we
      # just deleted.
      return editor.tree.getTokenAtLocation @dest
    
    redo: (editor) ->
      # If the operation was a no-op, redo is a no-op.
      unless @dest? then return

      # Move a clone into position.
      (clone = @block.clone()).moveTo editor.tree.getTokenAtLocation @dest
      
      # Move the cursor to the end of it.
      return clone.end
  
  # At population-time, we will
  # want to set up a few fields.
  hook 'populate', 0, ->
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
  hook 'resize', 0, ->
    @dragCanvas.width = @iceElement.offsetWidth - PALETTE_WIDTH
    @dragCanvas.height = @iceElement.offsetHeight
  
  # On mousedown, we will want to
  # hit test blocks in the root tree to
  # see if we want to move them.
  #
  # We do not do anything until the user
  # drags their mouse five pixels
  hook 'mousedown', 3, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return
    
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
  hook 'mouseup', 0, (point, event, state) ->
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
  hook 'mousemove', 1, (point, event, state) ->
    if @clickedBlock? and point.from(@clickedPoint).magnitude() > MIN_DRAG_DISTANCE
      # Signify that we are now dragging a block.
      @draggingBlock = @clickedBlock

      # Our dragging offset must be computed using the canvas on which this block
      # is rendered.
      #
      # TODO this really falls under "PALETTE SUPPORT", but must
      # go here. Try to organise this better.
      if @clickedBlockIsPaletteBlock
        @draggingOffset = @draggingBlock.view.bounds[@draggingBlock.view.lineStart].upperLeftCorner().from(
          @trackerPointToPalette(@clickedPoint))

        @draggingBlock = @draggingBlock.clone()
        
        # Notice that since this block effectively
        # came from nowhere, no undo operation
        # is needed to destroy it.

      else
        @draggingOffset = @draggingBlock.view.bounds[@draggingBlock.view.lineStart].upperLeftCorner().from(
          @trackerPointToMain(@clickedPoint))
        
        # Since we removed this from the tree,
        # we will need to log an undo operation
        # to put it back in.
        @addMicroUndoOperation new PickUpOperation @draggingBlock
      
      # Remove the block from the tree.
      @draggingBlock.moveTo null # MUTATION

      # Draw the new dragging block on the drag canvas.
      # 
      # When we are dragging things, we draw the shadow.
      # Also, we translate the block 1x1 to the right,
      # so that we can see its borders.
      @draggingBlock.view.compute(); @draggingBlock.view.translate new draw.Point 1, 1
      @draggingBlock.view.drawShadow @dragCtx, 5, 5
      @draggingBlock.view.draw @dragCtx
      
      # Translate it immediately into position
      position = new draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )

      @dragCanvas.style.top = "#{position.y}px"
      @dragCanvas.style.left = "#{position.x}px"

      # Now we are done with the "clickedX" suite of stuff.
      @clickedPoint = @clickedBlock = null

      # Redraw the main canvas
      @redrawMain()

  # On mousemove, if there is a dragged block, we want to
  # translate the drag canvas into place,
  # as well as highlighting any focused drop areas.
  hook 'mousemove', 0, (point, event, state) ->
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

  hook 'mouseup', 0, (point, event, state) ->
    # We will consume this event iff we dropped it successfully
    # in the root tree.
    if @draggingBlock? and @lastHighlight?
      # Depending on what the highlighted element is,
      # we might want to drop the block at its
      # beginning or at its end.
      #
      # We will need to log undo operations here too.
      switch @lastHighlight.type
        when 'indent', 'socket'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.start
          @draggingBlock.moveTo @lastHighlight.start #MUTATION
        when 'block'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.end
          @draggingBlock.moveTo @lastHighlight.end #MUTATION
        else
          if @lastHighlight is @tree
            @addMicroUndoOperation new DropOperation @draggingBlock, @tree.start
            @selection.moveTo @tree.start #MUTATION
    
      # Now that we've done that, we can annul stuff.
      @draggingBlock = null
      @draggingOffset = null
      @lastHighlight = null
      
      @clearDrag()
      @redrawMain()

  ###########################################
  # FLOATING BLOCK SUPPORT
  ###########################################
  
  # We need to initialize the @floatingBlocks
  # array at populate-time.
  hook 'populate', 0, ->
    @floatingBlocks = []

  class FloatingBlockRecord
    constructor: (@block, @position) ->
  
  # # Undo operations
  # We have two: FromFloating and ToFloating.
  # They mimick block move pick/drop operations
  # except that they also interact with the @floatingBlocks array.
  class ToFloatingOperation extends DropOperation
    constructor: (block, position) ->
      # Copy the position we got
      @position = new draw.Point position.x, position.y
      
      # Do all the normal blockMove stuff.
      super block, null

    undo: (editor) ->
      editor.floatingBlocks.pop()

      super

    redo: (editor) ->
      editor.floatingBlocks.push new FloatingBlockRecord @block.clone(), @position

      super

  class FromFloatingOperation extends PickUpOperation
    constructor: (record) ->
      @position = new draw.Point record.position.x, record.position.y

      super record.block, null

    undo: (editor) ->
      editor.floatingBlocks.push new FloatingBlockRecord @block.clone(), @position

      super

    redo: (editor) ->
      editor.floatingBlocks.pop()

      super

  # We can create floating blocks by dropping
  # blocks without a highlight.
  hook 'mouseup', 0, (point, event, state) ->
    if @draggingBlock? and not @lastHighlight? and point.x > 0
      # Before we put this block into our list of floating blocks,
      # we need to figure out where on the main canvas
      # we are going to render it.
      mainCanvasPoint = @trackerPointToMain point
      renderPoint = new draw.Point(
        mainCanvasPoint.x + @draggingOffset.x,
        mainCanvasPoint.y + @draggingOffset.y
      )
      
      # Add the undo operation associated
      # with creating this floating block
      @addMicroUndoOperation new ToFloatingOperation @draggingBlock, renderPoint

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
  hook 'mousedown', 7, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    # Hit test against floating blocks
    for record, i in @floatingBlocks
      hitTestResult = hitTest @trackerPointToMain(point), record.block

      if hitTestResult?
        @clickedBlock = record.block
        @clickedPoint = point

        state.consumedHitTest = true
        
        @redrawMain()
  
  hook 'mousemove', 7, (point, event, state) ->
    if @clickedBlock? and point.from(@clickedPoint).magnitude() > MIN_DRAG_DISTANCE
      for record, i in @floatingBlocks
        if record.block is @clickedBlock
          # Add the undo operation associated
          # with picking up this floating block
          @addMicroUndoOperation new FromFloatingOperation record

          @floatingBlocks.splice i, 1

          @redrawMain()

          return

  # On redraw, we draw all the floating blocks
  # in their proper positions.
  hook 'redraw_main', 0, ->
    for record in @floatingBlocks
      record.block.view.compute()
      record.block.view.translate record.position

      record.block.view.draw @mainCtx

  ###########################################
  # PALETTE SUPPORT
  ###########################################

  # The first thing we will have to do with
  # the palette is install the hierarchical menu.
  #
  # This happens at population time.
  hook 'populate', 0, ->
    @currentPaletteBlocks = []
    @clickedBlockIsPaletteBlock = false
    
    # Create the hierarchical menu element.
    @paletteHeader = document.createElement 'div'
    @paletteHeader.className = 'ice-palette-header'
    
    # Record its height, which is deterministic.
    @paletteHeaderHeight = Math.ceil(@paletteGroups.length / 2) * 30

    # Append the element.
    @iceElement.appendChild @paletteHeader

    for paletteGroup, i in @paletteGroups then do (paletteGroup) =>
      # Clone all the blocks so as not to
      # intrude on outside stuff
      paletteGroup.blocks = (block.clone() for block in paletteGroup.blocks)

      # Create the element itself
      paletteGroupHeader = document.createElement 'div'
      paletteGroupHeader.className = 'ice-palette-group-header'
      paletteGroupHeader.innerText = paletteGroup.name

      @paletteHeader.appendChild paletteGroupHeader
      
      # When we click this element,
      # we should switch to it in the palette.
      paletteGroupHeader.addEventListener 'click', =>
        # Record that we are the selected group now
        @currentPaletteGroup = paletteGroup.name
        @currentPaletteBlocks = paletteGroup.blocks
        
        # Unapply the "selected" style to the current palette group header
        @currentPaletteGroupHeader.className = 'ice-palette-group-header'

        # Now we are the current palette group header
        @currentPaletteGroupHeader = paletteGroupHeader

        # Apply the "selected" style to us
        @currentPaletteGroupHeader.className = 'ice-palette-group-header ice-palette-group-header-selected'
        
        # Redraw the palette.
        @redrawPalette()
      
      # If we are the first element, make us the selected palette group.
      if i is 0
        @currentPaletteGroup = paletteGroup.name
        @currentPaletteBlocks = paletteGroup.blocks

        @currentPaletteGroupHeader = paletteGroupHeader

        # Apply the "selected" style to us
        @currentPaletteGroupHeader.className = 'ice-palette-group-header ice-palette-group-header-selected'

  # The palette hierarchical menu is on top of the track div
  # so that we can click it. However, we do not want this to happen
  # when we are dragging something. So:
  hook 'mousedown', 0, ->
    @paletteHeader.style.zIndex = 0

  hook 'mouseup', 0, ->
    @paletteHeader.style.zIndex = 257
  
  # The next thing we need to do with the palette
  # is let people pick things up from it.
  hook 'mousedown', 7, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    palettePoint = @trackerPointToPalette point
    for block in @currentPaletteBlocks
      hitTestResult = hitTest palettePoint, block

      if hitTestResult?
        @clickedBlock = block
        @clickedPoint = point
        @clickedBlockIsPaletteBlock = true
        return

    @clickedBlockIsPaletteBlock = false

  ###########################################
  # TEXT INPUT SUPPORT
  ###########################################

  # Text input has two undo events: text change
  # and text reparse.
  class TextChangeOperation extends UndoOperation
    constructor: (socket, @before) ->
      @after = socket.stringify()
      @socket = socket.start.getSerializedLocation()

    undo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).socket
      socket.content()?.remove()
      socket.start.insert new model.TextToken @before

    redo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).socket
      socket.content()?.remove()
      socket.start.insert new model.TextToken @after

  class TextReparseOperation extends UndoOperation
    constructor: (socket, @before) ->
      @after = socket.content().clone()
      @socket = socket.start.getSerializedLocation()

    undo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).socket
      socket.content().moveTo null
      socket.start.insert new model.TextToken @before

    redo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).socket
      socket.content()?.remove()
      @after.clone().moveTo socket
  
  # At populate-time, we need
  # to create and append the hidden input
  # we will use for text input.
  hook 'populate', 1, ->
    @hiddenInput = document.createElement 'input'
    @hiddenInput.className = 'hidden-input'

    @iceElement.appendChild @hiddenInput

    # We also need to initialise some fields
    # for knowing what is focused
    @socketFocus = null
    @textFocus = null
    @textInputAnchor = null

    @textInputSelecting = false

    @oldFocusValue = null
    
    # The hidden input should be set up
    # to mirror the text to which it is associated.
    for event in ['input', 'keyup', 'keydown']
      @hiddenInput.addEventListener event, =>
        if @textFocus?
          @textFocus.value = @hiddenInput.value

          @redrawTextInput()

  # Redraw function for text input
  Editor::redrawTextInput = ->
    # Set the value in the model to fit
    # the hidden input value.
    @textFocus.value = @hiddenInput.value
    
    # Redraw the main canvas, on top of
    # which we will draw the cursor and
    # highlights.
    @redrawMain()

    # Determine the coordinate positions
    # of the typic cursor
    startPosition = @textFocus.view.bounds[@textFocus.view.lineStart].x +
      @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionStart]).width
    endPosition = @textFocus.view.bounds[@textFocus.view.lineStart].x +
      @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionEnd]).width

    # Now draw the highlight/typing cursor
    #
    # Draw a line if it is just a cursor
    if startPosition is endPosition
      @mainCtx.strokeRect startPosition, @textFocus.view.bounds[@textFocus.view.lineStart].y, 0, @fontSize

    # Draw a translucent rectangle if there is a selection.
    else
      @mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3)'
      @mainCtx.fillRect startPosition, @textFocus.view.bounds[@textFocus.view.lineStart].y, endPosition - startPosition, @fontSize

  # Convenince function for setting the text input
  Editor::setTextInputFocus = (focus) ->
    # If there is already a focus, we
    # need to wrap some things up with it.
    if @textFocus?

      # The first of these is an undo operation;
      # we need to add this text change to the undo stack.
      @addMicroUndoOperation new TextChangeOperation @socketFocus, @oldFocusValue
      @oldFocusValue = null

      # The second of these is a reparse attempt.
      # If we can, try to reparse the focus
      # value.
      try
        newParse = coffee.parse(unparsedValue = @socketFocus.stringify()).start.next

        if newParse.type is 'blockStart'
          newParse.block.moveTo @socketFocus.start

          @addMicroUndoOperation new TextReparseOperation @socketFocus, unparsedValue

    # Now we're done with the old focus,
    # we can start over.
    #
    # Literally set the focus.
    @socketFocus = focus

    # Record old focus value
    @oldFocusValue = focus.stringify()

    # Now create a text token
    # with the appropriate text to put in it.
    @textFocus = new model.TextToken focus.stringify()
    focus.content()?.remove()
    focus.start.insert @textFocus

    # TODO move the cursor to the focus.
    
    # Set the hidden input up to mirror the text.
    @hiddenInput.value = @textFocus.value
    
    # Focus the hidden input.
    setTimeout (=> @hiddenInput.focus()), 0

    # Redraw.
    @redrawMain()

  # Convenience hit-testing function
  hitTestTextInput = (point, block) ->
    head = block.start
    while head?
      if head.type is 'socketStart' and head.next.type in ['text', 'socketEnd'] and
          head.socket.view.bounds[head.socket.view.lineStart].contains point
        return head.socket
      head = head.next

    return null
  
  # Convenience functions for setting
  # the text input selection, given
  # points on the main canvas.
  Editor::setTextInputAnchor = (point) ->
    @textInputAnchor = @textInputHead = Math.round(
      (point.x - @textFocus.view.bounds[@textFocus.view.lineStart].x) / @mainCtx.measureText(' ').width
    )

    @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

  Editor::setTextInputHead = (point) ->
    @textInputHead = Math.round(
      (point.x - @textFocus.view.bounds[@textFocus.view.lineStart].x) / @mainCtx.measureText(' ').width
    )

    @hiddenInput.setSelectionRange Math.min(@textInputAnchor, @textInputHead), Math.max(@textInputAnchor, @textInputHead)
  
  # On mousedown, we will want to start
  # selections and focus text inputs
  # if we apply.
  hook 'mousedown', 6, (point, event, state) ->
    # If someone else already took this click, return.
    if state.consumedHitTest then return
    
    # Otherwise, look for a socket that
    # the user has clicked
    mainPoint = @trackerPointToMain point
    hitTestResult = hitTestTextInput mainPoint, @tree
    
    # If they have clicked a socket,
    # focus it, and 
    if hitTestResult?
      @setTextInputFocus hitTestResult

      setTimeout (=>
        @setTextInputAnchor mainPoint
        @redrawTextInput()

        @textInputSelecting = true
      ), 0

      state.consumedHitTest = true
  
  # On mousemove, if we are selecting,
  # we want to update the selection
  # to match the mouse.
  hook 'mousemove', 0, (point, event, state) ->
    if @textInputSelecting
      mainPoint = @trackerPointToMain point

      @setTextInputHead mainPoint

      @redrawTextInput()
  
  # On mouseup, we want to stop selecting.
  hook 'mouseup', 0, (point, event, state) ->
    @textInputSelecting = false

  ###########################################
  # LASSO SELECT SUPPORT: TODO
  ###########################################

  ###########################################
  # CURSOR OPERATION SUPPORT: TODO
  ###########################################
  Editor::moveCursorTo = ->

  ###########################################
  # HANDWRITTEN LINE SUPPORT: TODO
  ###########################################

  ###########################################
  # ANIMATION SUPPORT: TODO
  ###########################################
  
  ###########################################
  # SCROLLING SUPPORT: TODO
  ###########################################

  hook 'populate', 0, ->
    @scrollOffsets = {
      main: new draw.Point 0, 0
      palette: new draw.Point 0, 0
    }

  ###########################################
  # MULTIPLE FONT SIZE SUPPORT: TODO
  ###########################################
  hook 'populate', 0, ->
    @fontSize = 15

  ###########################################
  # MUTATION BUTTON SUPPORT: TODO
  ###########################################

  ###########################################
  # LINE MARKING SUPPORT: TODO
  ###########################################

  ###########################################
  # LINE HOVER SUPPORT: TODO
  ###########################################

  ###########################################
  # GET/SET VALUE SUPPORT: TODO
  ###########################################

  Editor::setValue = (value) ->
    @tree = coffee.parse value
    @redrawMain()

  Editor::getValue = -> @tree.stringify()
  
  ###########################################
  # CLOSING FOUNDATIONAL STUFF
  ###########################################

  # Order the arrays correctly.
  for key of unsortedEditorBindings
    unsortedEditorBindings[key].sort (a, b) -> if a.priority > b.priority then -1 else 1
    
    editorBindings[key] = []

    for binding in unsortedEditorBindings[key]
      editorBindings[key].push binding.fn
    
  return exports
