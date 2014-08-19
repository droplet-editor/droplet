# # ICE Editor controller
#
# Copyright (c) 2014 Anthony Bau
# MIT License.

define ['ice-helper', 'ice-coffee', 'ice-draw', 'ice-model', 'ice-view'], (helper, coffee, draw, model, view) ->
  # ## Magic constants
  PALETTE_TOP_MARGIN = 5
  PALETTE_MARGIN = 5
  MIN_DRAG_DISTANCE = 1
  PALETTE_LEFT_MARGIN = 5
  DEFAULT_INDENT_DEPTH = '  '
  ANIMATION_FRAME_RATE = 60
  DISCOURAGE_DROP_TIMEOUT = 1000
  MAX_DROP_DISTANCE = 100
  CURSOR_WIDTH_DECREASE = 3
  CURSOR_HEIGHT_DECREASE = 2

  ANY_DROP = helper.ANY_DROP
  BLOCK_ONLY = helper.BLOCK_ONLY
  MOSTLY_BLOCK = helper.MOSTLY_BLOCK
  MOSTLY_VALUE = helper.MOSTLY_VALUE
  VALUE_ONLY = helper.VALUE_ONLY

  exports = {}

  extend_ = (a, b) ->
    obj = {}

    for key, value of a
      obj[key] = value

    for key, value of b
      obj[key] = value

    return obj

  deepCopy = (a) ->
    if a instanceof Object
      newObject = {}

      for key, val of a
        newObject[key] = deepCopy val

      return newObject

    else
      return a

  deepEquals = (a, b) ->
    if a instanceof Object
      for own key, val of a
        unless deepEquals b[key], val
          return false

      for own key, val of b when not key of a
        unless deepEquals a[key], val
          return false

      return true
    else
      return a is b

  # FOUNDATION
  # ================================

  # ## Editor event bindings
  #
  # These are different events associated with the Editor
  # that features will want to bind to.
  unsortedEditorBindings = {
    'populate': []          # after an empty editor is created

    'resize': []            # after the window is resized
    'resize_palette': []    # after the palette is resized

    'redraw_main': []       # whenever we need to redraw the main canvas
    'redraw_palette': []    # whenever we need to redraw the palette
    'set_palette': []       # whenever we switch palette categories

    'mousedown': []
    'mousemove': []
    'mouseup': []
    'dblclick': []
  }

  unsortedEditorKeyBindings = {}

  editorBindings = {}

  # This hook function is for convenience,
  # for features to add events that will occur at
  # various times in the editor lifecycle.
  hook = (event, priority, fn) ->
    if event[..3] is 'key.'
      unsortedEditorKeyBindings[event[4..]] ?= []
      unsortedEditorKeyBindings[event[4..]].push {
        priority: priority
        fn: fn
      }
    else
      unsortedEditorBindings[event].push {
        priority: priority
        fn: fn
      }

  # ## The Editor Class
  exports.Editor = class Editor
    constructor: (@wrapperElement, @paletteGroups) ->
      @draw = new draw.Draw()

      # ## DOM Population
      # This stage of ICE Editor construction populates the given wrapper
      # element with all the necessary ICE editor components.
      @debugging = true

      # ### Wrapper
      # Create the div that will contain all the ICE Editor graphics

      @iceElement = document.createElement 'div'
      @iceElement.className = 'ice-wrapper-div'

      # We give our element a tabIndex so that it can be focused and capture keypresses.
      @iceElement.tabIndex = 0

      # Append that div.
      @wrapperElement.appendChild @iceElement

      @wrapperElement.style.backgroundColor = '#FFF'

      # ### Canvases
      # Create the palette and main canvases

      # Main canvas first
      @mainCanvas = document.createElement 'canvas'
      @mainCanvas.className = 'ice-main-canvas'

      @mainCtx = @mainCanvas.getContext '2d'

      @iceElement.appendChild @mainCanvas

      @paletteWrapper = @paletteElement = document.createElement 'div'
      @paletteWrapper.className = 'ice-palette-wrapper'

      # Then palette canvas
      @paletteCanvas = document.createElement 'canvas'
      @paletteCanvas.className = 'ice-palette-canvas'

      @paletteCtx = @paletteCanvas.getContext '2d'

      @paletteWrapper.appendChild @paletteCanvas

      @paletteElement.style.position = 'absolute'
      @paletteElement.style.left = '0px'
      @paletteElement.style.top = '0px'
      @paletteElement.style.bottom = '0px'
      @paletteElement.style.width = '270px'

      @iceElement.style.left = @paletteElement.offsetWidth + 'px'

      @wrapperElement.appendChild @paletteElement

      do @draw.refreshFontCapital

      @standardViewSettings =
        padding: 5
        indentWidth: 20
        textHeight: helper.getFontHeight 'Courier New', 15
        indentTongueHeight: 20
        tabOffset: 10
        tabWidth: 15
        tabHeight: 4
        tabSideWidth: 1 / 4
        dropAreaHeight: 20
        indentDropAreaMinWidth: 50
        emptySocketWidth: 20
        emptyLineHeight: 25
        highlightAreaHeight: 10
        shadowBlur: 5
        ctx: @mainCtx
        draw: @draw

      # Instantiate an ICE editor view
      @view = new view.View extend_ @standardViewSettings, respectEphemeral: true
      @dragView = new view.View extend_ @standardViewSettings, respectEphemeral: false

      # We also allow binding to keypresses in the element.
      # We will use dmauro's Keypress library for keyboard-shortcut
      # input.
      @keyListener = new window.keypress.Listener @iceElement

      boundListeners = []

      # For each combo to which binding(s) are attached,
      # listen for that combo and execute each binding
      # attached to it.
      #
      # We will preventDefault (!executeDefault) if anyone
      # wants to preventDefault.
      for combo, fns of editorBindings.key then do (fns) =>
        @keyListener.simple_combo combo, (event, count) =>
          state = {}

          executeDefault = true

          for fn in fns
            result = fn.call(this, state, event, count) ? true
            executeDefault and= result

          return executeDefault

      # Call all the feature bindings that are supposed
      # to happen now.
      for binding in editorBindings.populate
        binding.call this

      # ## Resize
      # This stage of ICE editor construction, which is repeated
      # whenever the editor is resized, should adjust the sizes
      # of all the ICE editor componenents to fit the wrapper.
      window.addEventListener 'resize', => @resize()

      # ## Tracker Events
      # We allow binding to the tracker element.
      for eventName, elements of {
          mousedown: [@iceElement, @paletteElement, @dragCover]
          dblclick: [@iceElement, @paletteElement, @dragCover]
          mouseup: [window]
          mousemove: [window] } then do (eventName, elements) =>

        for element in elements
          element.addEventListener eventName, (event) =>
            trackPoint = @getPointRelativeToTracker event

            # We keep a state object so that handlers
            # can know about each other.
            state = {}

            # Call all the handlers.
            for handler in editorBindings[eventName]
              handler.call this, trackPoint, event, state

            # Stop event propagation so that
            # we don't get bad selections
            event.stopPropagation?()
            event.preventDefault?()

            event.cancelBubble = true
            event.returnValue = false

            return false

      # ## Document initialization
      # We start of with an empty document
      @tree = new model.Segment()
      @tree.start.insert @cursor

      @resize()

      # Now that we've populated everything, immediately re@draw.
      @redrawMain(); @redrawPalette()

    # ## Foundational Resize
    # At the editor core, we will need to resize
    # all of the natively-added canvases, as well
    # as the wrapper element, whenever a resize
    # occurs.
    resize: ->
      @iceElement.style.left = "#{@paletteElement.offsetWidth}px"
      @iceElement.style.height = "#{@wrapperElement.offsetHeight}px"
      @iceElement.style.width ="#{@wrapperElement.offsetWidth - @paletteWrapper.offsetWidth}px"

      @mainCanvas.height = @iceElement.offsetHeight
      @mainCanvas.width = @iceElement.offsetWidth - @gutter.offsetWidth

      @mainCanvas.style.height = "#{@mainCanvas.height}px"
      @mainCanvas.style.width = "#{@mainCanvas.width}px"
      @mainCanvas.style.left = "#{@gutter.offsetWidth}px"
      @transitionContainer.style.left = "#{@gutter.offsetWidth}px"

      @resizePalette()

      for binding in editorBindings.resize
        binding.call this

      # Re-scroll and redraw main
      @scrollOffsets.main.y = @mainScroller.scrollTop
      @scrollOffsets.main.x = @mainScroller.scrollLeft

      @mainCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y

      # Also update scroll for the highlight ctx, so that
      # they can match the blocks' positions
      @highlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y
      @cursorCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y

      @redrawMain()

    resizePalette: ->
      ###
      @paletteWrapper.style.height = "#{@paletteElement.offsetHeight}px"
      @paletteWrapper.style.width = "#{@paletteElement.offsetWidth}px"
      ###

      @paletteCanvas.style.top = "#{@paletteHeader.offsetHeight}px"
      @paletteCanvas.height = @paletteWrapper.offsetHeight - @paletteHeader.offsetHeight
      @paletteCanvas.width = @paletteWrapper.offsetWidth

      @paletteCanvas.style.height = "#{@paletteCanvas.height}px"
      @paletteCanvas.style.width = "#{@paletteCanvas.width}px"

      for binding in editorBindings.resize_palette
        binding.call this

      @paletteCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y
      @paletteHighlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y

      @redrawPalette()


  # RENDERING CAPABILITIES
  # ================================

  # ## Redraw
  # There are two different redraw events, redraw_main and redraw_palette,
  # for redrawing the main canvas and palette canvas, respectively.
  #
  # Redrawing simply involves issuing a call to the View.

  Editor::clearMain = (opts) ->
    if opts.boundingRectangle?
      @mainCtx.clearRect opts.boundingRectangle.x, opts.boundingRectangle.y,
        opts.boundingRectangle.width, opts.boundingRectangle.height
    else
      @mainCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @mainCanvas.width, @mainCanvas.height

  Editor::setTopNubbyStyle = (height = 10, color = '#EBEBEB') ->
    @nubbyHeight = Math.max(0, height); @nubbyColor = color

    @topNubbyPath = new @draw.Path()
    if height >= 0
      @topNubbyPath.bevel = true

      @topNubbyPath.push new @draw.Point @mainCanvas.width, -5
      @topNubbyPath.push new @draw.Point @mainCanvas.width, height

      @topNubbyPath.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth, height
      @topNubbyPath.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth * (1 - @view.opts.tabSideWidth),
          @view.opts.tabHeight + height
      @topNubbyPath.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth * @view.opts.tabSideWidth,
          @view.opts.tabHeight + height
      @topNubbyPath.push new @draw.Point @view.opts.tabOffset, height

      @topNubbyPath.push new @draw.Point -5, height
      @topNubbyPath.push new @draw.Point -5, -5

      @topNubbyPath.style.fillColor = color

    @redrawMain()

  hook 'resize', 0, -> @setTopNubbyStyle @nubbyHeight, @nubbyColor

  Editor::redrawMain = (opts = {}) ->
    unless @currentlyAnimating_suprressRedraw

      # Set our draw tool's font size
      # to the font size we want
      @draw.setGlobalFontSize @fontSize

      # Supply our main canvas for measuring
      @draw.setCtx @mainCtx

      # Clear the main canvas
      @clearMain(opts)

      @topNubbyPath.draw @mainCtx

      if opts.boundingRectangle?
        @mainCtx.save()
        opts.boundingRectangle.clip @mainCtx

      # Draw the new tree on the main context
      layoutResult = @view.getViewNodeFor(@tree).layout 0, @nubbyHeight
      @view.getViewNodeFor(@tree).draw @mainCtx, opts.boundingRectangle ? new @draw.Rectangle(
        @scrollOffsets.main.x,
        @scrollOffsets.main.y,
        @mainCanvas.width,
        @mainCanvas.height
      ), {
        grayscale: 0
        selected: 0
        noText: (opts.noText ? false)
      }

      # Draw the cursor (if exists, and is inserted)
      @redrawCursors(); @redrawHighlights()

      if opts.boundingRectangle?
        @mainCtx.restore()

      for binding in editorBindings.redraw_main
        binding.call this, layoutResult

      if @changeEventVersion isnt @tree.version
        @changeEventVersion = @tree.version

        # Update the ace editor value to match,
        # but don't trigger a resize event.
        @suppressAceChangeEvent = true; oldScroll = @aceEditor.session.getScrollTop()
        @aceEditor.setValue @getValue(), -1
        @suppressAceChangeEvent = false; @aceEditor.session.setScrollTop oldScroll

        @fireEvent 'change', []

      return null

  Editor::redrawHighlights = ->
    # Draw highlights around marked lines
    @clearHighlightCanvas()

    for line, info of @markedLines
      if @inTree info.model
        path = @getHighlightPath info.model, info.style
        path.draw @highlightCtx
      else
        delete @markedLines[line]

    for id, info of @extraMarks
      if @inTree info.model
        path = @getHighlightPath info.model, info.style
        path.draw @highlightCtx
      else
        delete @extraMarks[id]

    @redrawCursors()

  Editor::clearCursorCanvas = ->
    @cursorCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @cursorCanvas.width, @cursorCanvas.height

  Editor::redrawCursors = ->
    @clearCursorCanvas()

    if @textFocus?
      @redrawTextHighlights()

    else unless @lassoSegment?
      @drawCursor()

  Editor::drawCursor = -> @strokeCursor @determineCursorPosition()

  Editor::clearPalette = ->
      @paletteCtx.clearRect @scrollOffsets.palette.x, @scrollOffsets.palette.y,
        @paletteCanvas.width, @paletteCanvas.height

  Editor::clearPaletteHighlightCanvas = ->
      @paletteHighlightCtx.clearRect @scrollOffsets.palette.x, @scrollOffsets.palette.y,
        @paletteHighlightCanvas.width, @paletteHighlightCanvas.height

  Editor::redrawPalette = ->
      @clearPalette()

      # We will construct a vertical layout
      # with padding for the palette blocks.
      # To do this, we will need to keep track
      # of the last bottom edge of a palette block.
      lastBottomEdge = PALETTE_TOP_MARGIN

      boundingRect = new @draw.Rectangle(
        @scrollOffsets.palette.x,
        @scrollOffsets.palette.y,
        @paletteCanvas.width,
        @paletteCanvas.height
      )

      for paletteBlock in @currentPaletteBlocks
        # Layout this block
        paletteBlockView = @view.getViewNodeFor paletteBlock
        paletteBlockView.layout PALETTE_LEFT_MARGIN, lastBottomEdge

        # Render the block
        paletteBlockView.draw @paletteCtx, boundingRect

        # Update lastBottomEdge
        lastBottomEdge = paletteBlockView.getBounds().bottom() + PALETTE_MARGIN

      for binding in editorBindings.redraw_palette
        binding.call this

  # MOUSE INTERACTION WRAPPERS
  # ================================

  # These are some common operations we need to do with
  # the mouse that will be convenient later.

  # ### getPointRelativeToTracker
  # Given a mousedown/touchstart event,
  # get its coordinates relative to the tracker element.

  Editor::getPointRelativeToTracker = (event) ->
    # There are two cases we have to deal
    # with here for browser compatability.

    # The first is Chrome and Safari.
    if event.offsetX?
      # We want this point relative to the tracker element.
      point = new @draw.Point event.offsetX, event.offsetY

    # The second is Firefox.
    else
      point = new @draw.Point event.layerX, event.layerY

    # Now, we want to get this point relative to the tracker element,
    # so we need to bubble up its parents until we reach it.
    offsetPoint = @trackerOffset event.target

    # Now we're done.
    return new @draw.Point(
      point.x + offsetPoint.x,
      point.y + offsetPoint.y
    )

  Editor::absoluteOffset = (el) ->
    point = new @draw.Point el.offsetLeft, el.offsetTop
    el = el.offsetParent

    until el is document.body or not el?
      point.x += el.offsetLeft - el.scrollLeft
      point.y += el.offsetTop - el.scrollTop

      el = el.offsetParent

    return point

  Editor::trackerOffset = (el) ->
    x = el.offsetLeft
    y = el.offsetTop
    el = el.offsetParent

    subtractIceElementOffset = =>
      el = @iceElement.offsetParent

      x -= @iceElement.offsetLeft
      y -= @iceElement.offsetTop

      while el?
        x -= el.offsetLeft - el.scrollLeft
        y -= el.offsetTop - el.scrollTop
        el = el.offsetParent

    until el is @iceElement
      unless el?
        # if outside iceElement, then subtract iceElement's offset.
        do subtractIceElementOffset
        break
      x += el.offsetLeft - el.scrollLeft
      y += el.offsetTop - el.scrollTop

      el = el.offsetParent

    return new @draw.Point x, y

  # ### Conversion functions
  # Convert a point relative to the tracker into
  # a point relative to one of the two canvases.
  Editor::trackerPointToMain = (point) ->
    new @draw.Point(
      point.x - @trackerOffset(@mainCanvas).x + @scrollOffsets.main.x
      point.y - @trackerOffset(@mainCanvas).y + @scrollOffsets.main.y
    )

  Editor::trackerPointToPalette = (point) ->
    if not @paletteCanvas.offsetParent?
      return new @draw.Point(
        NaN,
        NaN
      )

    new @draw.Point(
      point.x - @trackerOffset(@paletteCanvas).x + @scrollOffsets.palette.x,
      point.y - @trackerOffset(@paletteCanvas).y + @scrollOffsets.palette.y
    )

  # ### hitTest
  # Simple function for going through a linked-list block
  # and seeing what the innermost child is that we hit.
  Editor::hitTest = (point, block) ->
    head = block.start; seek = block.end

    until head is seek
      if head.type is 'blockStart' and @view.getViewNodeFor(head.container).path.contains point
        seek = head.container.end
      head = head.next

    # If we had a child hit, return it.
    if head isnt block.end
      return head.container

    # If we didn't have a child hit, it's possible
    # that _we_ are the innermost child that hit. See if that's
    # the case.
    else if block.type is 'block' and @view.getViewNodeFor(block).path.contains point
      return block

    # Nope, it's not. Answer is null.
    else return null

  hook 'mousedown', 10, ->
    @iceElement.focus()

  # UNDO STACK SUPPORT
  # ================================

  # We must declare a few
  # fields a populate time
  hook 'populate', 0, ->
    @undoStack = []
    @changeEventVersion = 0

  # The UndoOperation class is the base
  # class for all undo operations.
  class UndoOperation
    constructor: ->

    # Undo and redo should return
    # the desired new cursor position.
    undo: (editor) -> editor.tree.start
    redo: (editor) -> editor.tree.start

  Editor::removeBlankLines = ->
    # If we have blank lines at the end,
    # get rid of them
    head = @tree.end.previousVisibleToken()
    while head?.type is 'newline'
      next = head.previousVisibleToken()
      head.remove()
      head = next

  # addMicroUndoOperation pushes
  # the given operation to the undo stack,
  # and might possibly do some bureaucracy in the future.
  Editor::addMicroUndoOperation = (operation) ->
    @undoStack.push operation
    @removeBlankLines()

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
  hook 'key.meta z', 0, ->
    @undo()

  # BASIC BLOCK MOVE SUPPORT
  # ================================

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

      # Move a clone into position.
      (clone = @block.clone()).moveTo editor.tree.getTokenAtLocation @before

      # If the block was the lasso select, register it
      # as such.
      if @block.type is 'segment' and @block.isLassoSegment
        editor.lassoSegment = @block

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
        blockStart.container.moveTo null

      else
        blockStart.container.moveTo null

      # Move the cursor somewhere close to what we
      # just deleted.
      return editor.tree.getTokenAtLocation @before

  class DropOperation extends UndoOperation
    constructor: (block, dest) ->
      @block = block.clone()
      @dest = dest?.getSerializedLocation() ? null

      if dest?.type is 'socketStart'
        @displacedSocketText = dest.container.contents()
      else @displacedSocketText = null

    undo: (editor) ->
      # If the operation was a no-op, undo is a no-op.
      unless @dest? then return

      # Find the block we want to remove
      blockStart = editor.tree.getTokenAtLocation @dest
      until blockStart.type is @block.start.type then blockStart = blockStart.next

      # Move it to null.
      blockStart.container.spliceOut()

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

    @dragCanvas.style.left = '-9999px'
    @dragCanvas.style.top = '-9999px'

    @dragCtx = @dragCanvas.getContext '2d'

    # And the canvas for drawing highlights
    @highlightCanvas = document.createElement 'canvas'
    @highlightCanvas.className = 'ice-highlight-canvas'

    @highlightCtx = @highlightCanvas.getContext '2d'

    # We append it to the tracker element,
    # so that it can appear in front of the scrollers.
    #@iceElement.appendChild @dragCanvas
    document.body.appendChild @dragCanvas
    @iceElement.appendChild @highlightCanvas

  Editor::clearHighlightCanvas = ->
    @highlightCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @highlightCanvas.width, @highlightCanvas.height

  # Utility function for clearing the drag canvas,
  # an operation we will be doing a lot.
  Editor::clearDrag = ->
    @dragCtx.clearRect 0, 0, @dragCanvas.width, @dragCanvas.height

  # On resize, we will want to size the drag canvas correctly.
  hook 'resize', 0, ->
    @dragCanvas.width = screen.width * 2
    @dragCanvas.height = screen.height * 2

    @highlightCanvas.width = @iceElement.offsetWidth
    @highlightCanvas.style.width = "#{@highlightCanvas.width}px"

    @highlightCanvas.height = @iceElement.offsetHeight
    @highlightCanvas.style.height = "#{@highlightCanvas.height}px"

    @highlightCanvas.style.left = "#{@mainCanvas.offsetLeft}px"

  # On mousedown, we will want to
  # hit test blocks in the root tree to
  # see if we want to move them.
  #
  # We do not do anything until the user
  # drags their mouse five pixels
  hook 'mousedown', 1, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    # Hit test against the tree.
    mainPoint = @trackerPointToMain(point)
    hitTestResult = @hitTest mainPoint, @tree

    # Produce debugging output
    if @debugging and event.shiftKey
      line = null
      node = @view.getViewNodeFor(hitTestResult)
      for box, i in node.bounds
        if box.contains(mainPoint)
          line = i
          break
      @dumpNodeForDebug(hitTestResult, line)

    # If it came back positive,
    # deal with the click.
    if hitTestResult? and event.which is 1
      # Record the hit test result (the block we want to pick up)
      @clickedBlock = hitTestResult

      # Move the cursor somewhere nearby
      @moveCursorTo @clickedBlock.start.next

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

  Editor::wouldDelete = (position) ->

    mainPoint = @trackerPointToMain position
    palettePoint = @trackerPointToPalette position

    return not @lastHighlight and not
        (@mainCanvas.width + @scrollOffsets.main.x > mainPoint.x > @scrollOffsets.main.x and
         @mainCanvas.height + @scrollOffsets.main.y > mainPoint.y > @scrollOffsets.main.y) or
        (@paletteCanvas.width + @scrollOffsets.palette.x > palettePoint.x > @scrollOffsets.palette.x and
        @paletteCanvas.height + @scrollOffsets.palette.y > palettePoint.y > @scrollOffsets.palette.y)

  # On mousemove, if there is a clicked block but no drag block,
  # we might want to transition to a dragging the block if the user
  # moved their mouse far enough.
  hook 'mousemove', 1, (point, event, state) ->
    if not state.capturedPickup and @clickedBlock? and point.from(@clickedPoint).magnitude() > MIN_DRAG_DISTANCE

      # Signify that we are now dragging a block.
      @draggingBlock = @clickedBlock

      # Our dragging offset must be computed using the canvas on which this block
      # is rendered.
      #
      # NOTE: this really falls under "PALETTE SUPPORT", but must
      # go here. Try to organise this better.
      if @clickedBlockIsPaletteBlock
        @draggingOffset = @view.getViewNodeFor(@draggingBlock).bounds[0].upperLeftCorner().from(
          @trackerPointToPalette(@clickedPoint))

        @draggingBlock = @draggingBlock.clone()

        # Notice that since this block effectively
        # came from nowhere, no undo operation
        # is needed to destroy it.

      else
        @draggingOffset = @view.getViewNodeFor(@draggingBlock).bounds[0].upperLeftCorner().from(
          @trackerPointToMain(@clickedPoint))

      @draggingBlock.ephemeral = true
      @draggingBlock.clearLineMarks()

      # Draw the new dragging block on the drag canvas.
      #
      # When we are dragging things, we draw the shadow.
      # Also, we translate the block 1x1 to the right,
      # so that we can see its borders.
      draggingBlockView = @dragView.getViewNodeFor @draggingBlock
      draggingBlockView.layout 1, 1
      draggingBlockView.drawShadow @dragCtx, 5, 5
      draggingBlockView.draw @dragCtx, new @draw.Rectangle 0, 0, @dragCanvas.width, @dragCanvas.height

      # Translate it immediately into position
      position = new @draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )

      # Construct a quadtree of drop areas
      # for faster dragging
      @dropPointQuadTree = QUAD.init
        x: @scrollOffsets.main.xA
        y: @scrollOffsets.main.y
        w: @mainCanvas.width
        h: @mainCanvas.height

      head = @tree.start
      until head is @tree.end

        if head is @draggingBlock.start
          head = @draggingBlock.end

        if head instanceof model.StartToken
          acceptLevel = @getAcceptLevel @draggingBlock, head.container
          unless acceptLevel is helper.FORBIDDEN
            dropPoint = @view.getViewNodeFor(head.container).dropPoint

            if dropPoint?
              @dropPointQuadTree.insert
                x: dropPoint.x
                y: dropPoint.y
                w: 0
                h: 0
                acceptLevel: acceptLevel
                _ice_node: head.container

        head = head.next

      @dragCanvas.style.top = "#{position.y + getOffsetTop(@iceElement)}px"
      @dragCanvas.style.left = "#{position.x + getOffsetLeft(@iceElement)}px"

      # Now we are done with the "clickedX" suite of stuff.
      @clickedPoint = @clickedBlock = null

      @begunTrash = @wouldDelete position

      # Redraw the main canvas
      @redrawMain()

  # On mousemove, if there is a dragged block, we want to
  # translate the drag canvas into place,
  # as well as highlighting any focused drop areas.
  hook 'mousemove', 0, (point, event, state) ->
    if @draggingBlock?
      # Translate the drag canvas into position.
      position = new @draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )

      @dragCanvas.style.top = "#{position.y + getOffsetTop(@iceElement)}px"
      @dragCanvas.style.left = "#{position.x + getOffsetLeft(@iceElement)}px"

      mainPoint = @trackerPointToMain(position)

      best = null; min = Infinity

      # Check to see if the tree is empty;
      # if it is, drop on the tree always
      head = @tree.start.next
      while head.type in ['newline', 'cursor'] or head.type is 'text' and head.value is ''
        head = head.next

      if head is @tree.end and
          @mainCanvas.width + @scrollOffsets.main.x > mainPoint.x > @scrollOffsets.main.x and
          @mainCanvas.height + @scrollOffsets.main.y > mainPoint.y > @scrollOffsets.main.y
        @view.getViewNodeFor(@tree).highlightArea.draw @highlightCtx
        @lastHighlight = @tree

      else
        # Find the closest droppable block
        testPoints = @dropPointQuadTree.retrieve {
          x: mainPoint.x - MAX_DROP_DISTANCE
          y: mainPoint.y - MAX_DROP_DISTANCE
          w: MAX_DROP_DISTANCE * 2
          h: MAX_DROP_DISTANCE * 2
        }, (point) =>
          unless (point.acceptLevel is helper.DISCOURAGED) and not @shiftKeyPressed
            distance = mainPoint.from(point)
            distance.y *= 2; distance = distance.magnitude()
            if distance < min and mainPoint.from(point).magnitude() < MAX_DROP_DISTANCE and
               @view.getViewNodeFor(point._ice_node).highlightArea?
              best = point._ice_node
              min = distance

        if best isnt @lastHighlight
          @clearHighlightCanvas()

          if best? then @view.getViewNodeFor(best).highlightArea.draw @highlightCtx

          @lastHighlight = best

      palettePoint = @trackerPointToPalette position

      if @wouldDelete(position)
        if @begunTrash
          @dragCanvas.style.opacity = 0.85
        else
          @dragCanvas.style.opacity = 0.3
      else
        @dragCanvas.style.opacity = 0.85
        @begunTrash = false

  hook 'mouseup', 0, ->
    clearTimeout @discourageDropTimeout; @discourageDropTimeout = null

  Editor::getAcceptLevel = (drag, drop) ->
    unless drop? then return helper.FORBIDDEN
    unless @view.getViewNodeFor(drop).dropPoint? then return helper.FORBIDDEN
    if drop.parent?.type is 'socket' then return helper.FORBIDDEN

    if drag?.type is 'segment' and
        drop.type in ['block', 'segment', 'indent']
      return helper.ENCOURAGED

    if drop?.type is 'socket'
      acceptance = drop.accepts drag

      if acceptance is helper.ENCOURAGE_ALL
        return helper.ENCOURAGED

      if acceptance is helper.NORMAL and
          drag.socketLevel in [ANY_DROP, MOSTLY_VALUE, VALUE_ONLY]
        return helper.ENCOURAGED

      else if acceptance is helper.NORMAL and
          drag.socketLevel in [MOSTLY_BLOCK]
        return helper.DISCOURAGED

      else if acceptance is helper.DISCOURAGE and
          drag.socketLevel isnt BLOCK_ONLY
        return helper.DISCOURAGED

      else
        return helper.FORBIDDEN


    else if drag.socketLevel in [ANY_DROP, MOSTLY_BLOCK, BLOCK_ONLY]
      return helper.ENCOURAGED

    else if drag.socketLevel is MOSTLY_VALUE
      return helper.DISCOURAGED

    else
      return helper.FORBIDDEN

  hook 'mouseup', 1, (point, event, state) ->
    # We will consume this event iff we dropped it successfully
    # in the root tree.
    if @draggingBlock? and @lastHighlight?

      if @inTree @draggingBlock
        # Since we removed this from the tree,
        # we will need to log an undo operation
        # to put it back in.
        @addMicroUndoOperation 'CAPTURE_POINT'

        @addMicroUndoOperation new PickUpOperation @draggingBlock

        # Remove the block from the tree.
        @draggingBlock.spliceOut() # MUTATION

      @clearHighlightCanvas()

      # Depending on what the highlighted element is,
      # we might want to drop the block at its
      # beginning or at its end.
      #
      # We will need to log undo operations here too.
      switch @lastHighlight.type
        when 'indent', 'socket'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.start
          @draggingBlock.spliceIn @lastHighlight.start #MUTATION
        when 'block'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.end
          @draggingBlock.spliceIn @lastHighlight.end #MUTATION
        else
          if @lastHighlight is @tree
            @addMicroUndoOperation new DropOperation @draggingBlock, @tree.start
            @draggingBlock.spliceIn @tree.start #MUTATION

      if @lastHighlight.type is 'socket'
        # Reparse the parent
        try
          parent = @draggingBlock.parent.parent
          newBlock = coffee.parse(parent.stringify(), wrapAtRoot: true).start.next.container
          if newBlock?.type is 'block'
            parent.start.prev.append newBlock.start
            newBlock.end.append parent.end.next

            newBlock.parent = newBlock.start.parent = newBlock.end.parent =
              parent.parent

            @addMicroUndoOperation new ReparseOperation parent, newBlock

      @redrawMain()

      # Move the cursor to the position we just
      # dropped the block
      @moveCursorTo @draggingBlock.end, true

      # Now that we've done that, we can annul stuff.
      @draggingBlock = null
      @draggingOffset = null
      @lastHighlight = null

      @clearDrag()

  # FLOATING BLOCK SUPPORT
  # ================================

  # We need to initialize the @floatingBlocks
  # array at populate-time.
  hook 'populate', 0, ->
    @floatingBlocks = []

  class FloatingBlockRecord
    constructor: (@block, @position) ->

  # ## Undo operations
  # We have two: FromFloating and ToFloating.
  # They mimick block move pick/drop operations
  # except that they also interact with the @floatingBlocks array.
  class ToFloatingOperation extends DropOperation
    constructor: (block, position, editor) ->
      # Copy the position we got
      @position = new editor.draw.Point position.x, position.y

      # Do all the normal blockMove stuff.
      super block, null

    undo: (editor) ->
      editor.floatingBlocks.pop()

      super

    redo: (editor) ->
      editor.floatingBlocks.push new FloatingBlockRecord @block.clone(), @position

      super

  class FromFloatingOperation
    constructor: (record, editor) ->
      @position = new editor.draw.Point record.position.x, record.position.y
      @block = record.block.clone()

    undo: (editor) ->
      editor.floatingBlocks.push new FloatingBlockRecord @block.clone(), @position

      return null

    redo: (editor) ->
      editor.floatingBlocks.pop()

      return null

  Editor::inTree = (block) ->
    until block is @tree or not block?
      block = block.parent

    return block is @tree

  # We can create floating blocks by dropping
  # blocks without a highlight.
  hook 'mouseup', 0, (point, event, state) ->
    if @draggingBlock? and not @lastHighlight?
      # Before we put this block into our list of floating blocks,
      # we need to figure out where on the main canvas
      # we are going to render it.
      trackPoint = new @draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )
      renderPoint = @trackerPointToMain trackPoint
      palettePoint = @trackerPointToPalette trackPoint

      # Move the cursor out of the block first
      if @inTree @draggingBlock
        @moveCursorTo @draggingBlock.end

        @addMicroUndoOperation 'CAPTURE_POINT'

        @addMicroUndoOperation new PickUpOperation @draggingBlock

        # Remove the block from the tree.
        @draggingBlock.spliceOut() # MUTATION

      # If we dropped it off in the palette, abort (so as to delete the block).
      palettePoint = @trackerPointToPalette point
      if 0 < palettePoint.x - @scrollOffsets.palette.x < @paletteCanvas.width and
         0 < palettePoint.y - @scrollOffsets.palette.y < @paletteCanvas.height or not
         (-@gutter.offsetWidth < renderPoint.x - @scrollOffsets.main.x < @mainCanvas.width and
         0 < renderPoint.y - @scrollOffsets.main.y< @mainCanvas.height)
        if @draggingBlock is @lassoSegment
          @lassoSegment = null

        @draggingBlock = null
        @draggingOffset = null
        @lastHighlight = null

        @clearDrag()
        @redrawMain()
        return

      else if renderPoint.x - @scrollOffsets.main.x < 0
        renderPoint.x = @scrollOffsets.main.x

      # Add the undo operation associated
      # with creating this floating block
      @addMicroUndoOperation new ToFloatingOperation @draggingBlock, renderPoint, this

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
      @redrawHighlights()

  # On mousedown, we can hit test for floating blocks.
  hook 'mousedown', 5, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    # Hit test against floating blocks
    for record, i in @floatingBlocks
      hitTestResult = @hitTest @trackerPointToMain(point), record.block

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
          unless state.addedCapturePoint
            @addMicroUndoOperation 'CAPTURE_POINT'
            state.addedCapturePoint = true
          @addMicroUndoOperation new FromFloatingOperation record, this

          @floatingBlocks.splice i, 1

          @redrawMain()

          return

  # On redraw, we draw all the floating blocks
  # in their proper positions.
  hook 'redraw_main', 7, ->
    boundingRect = new @draw.Rectangle(
      @scrollOffsets.main.x,
      @scrollOffsets.main.y,
      @mainCanvas.width,
      @mainCanvas.height
    )
    for record in @floatingBlocks
      blockView = @view.getViewNodeFor record.block
      blockView.layout record.position.x, record.position.y
      blockView.draw @mainCtx, boundingRect

  # PALETTE SUPPORT
  # ================================

  # The first thing we will have to do with
  # the palette is install the hierarchical menu.
  #
  # This happens at population time.
  hook 'populate', 0, ->
    @currentPaletteBlocks = []
    @currentPaletteMetadata = []

    @clickedBlockIsPaletteBlock = false

    # Create the hierarchical menu element.
    @paletteHeader = document.createElement 'div'
    @paletteHeader.className = 'ice-palette-header'

    # Append the element.
    @paletteWrapper.appendChild @paletteHeader

    paletteHeaderRow = null
    for paletteGroup, i in @paletteGroups then do (paletteGroup) =>
      # Start a new row, if we're at that point
      # in our appending cycle
      if i % 2 is 0
        paletteHeaderRow = document.createElement 'div'
        paletteHeaderRow.className = 'ice-palette-header-row'
        @paletteHeader.appendChild paletteHeaderRow

      # Create the element itself
      paletteGroupHeader = document.createElement 'div'
      paletteGroupHeader.className = 'ice-palette-group-header'
      paletteGroupHeader.innerText = paletteGroupHeader.textContent = paletteGroup.name # innerText and textContent for FF compatability
      if paletteGroup.color
        paletteGroupHeader.className += ' ' + paletteGroup.color

      paletteHeaderRow.appendChild paletteGroupHeader

      newPaletteGroup = []

      # Parse all the blocks in this palette and clone them
      for data in paletteGroup.blocks
        newBlock = coffee.parse(data.block).start.next.container
        newBlock.spliceOut(); newBlock.parent = null
        newPalette.group.push {
          block: newBlock
          title: data.title
        }

      # When we click this element,
      # we should switch to it in the palette.
      clickHandler = =>
        # Record that we are the selected group now
        @currentPaletteGroup = paletteGroup.name
        @currentPaletteBlocks = paletteGroup.blocks.map (x) -> x.block
        @currentPaletteMetadata = paletteGroup.blocks

        # Unapply the "selected" style to the current palette group header
        @currentPaletteGroupHeader.className =
            @currentPaletteGroupHeader.className.replace(
                /\s[-\w]*-selected\b/, '')

        # Now we are the current palette group header
        @currentPaletteGroupHeader = paletteGroupHeader

        # Apply the "selected" style to us
        @currentPaletteGroupHeader.className +=
            ' ice-palette-group-header-selected'

        # Redraw the palette.
        @redrawPalette()

        for event in editorBindings.set_palette
          event.call this

      paletteGroupHeader.addEventListener 'click', clickHandler
      paletteGroupHeader.addEventListener 'touchstart', clickHandler

      # If we are the first element, make us the selected palette group.
      if i is 0
        @currentPaletteGroup = paletteGroup.name
        @currentPaletteBlocks = paletteGroup.blocks.map (x) -> x.block
        @currentPaletteMetadata = paletteGroup.blocks
        @currentPaletteGroupHeader = paletteGroupHeader

        # Apply the "selected" style to us
        @currentPaletteGroupHeader.className +=
            ' ice-palette-group-header-selected'

        @redrawPalette()
        for event in editorBindings.set_palette
          event.call this


  # The palette hierarchical menu is on top of the track div
  # so that we can click it. However, we do not want this to happen
  # when we are dragging something. So:
  hook 'mousedown', 0, ->
    @paletteHeader.style.zIndex = 0

  hook 'mouseup', 0, ->
    @paletteHeader.style.zIndex = 257

  # The next thing we need to do with the palette
  # is let people pick things up from it.
  hook 'mousedown', 6, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    palettePoint = @trackerPointToPalette point
    if @scrollOffsets.palette.y < palettePoint.y < @scrollOffsets.palette.y + @paletteCanvas.height and
       @scrollOffsets.palette.x < palettePoint.x < @scrollOffsets.palette.x + @paletteCanvas.width

      for block in @currentPaletteBlocks
        hitTestResult = @hitTest palettePoint, block

        if hitTestResult?
          @clickedBlock = block
          @clickedPoint = point
          @clickedBlockIsPaletteBlock = true
          state.consumedHitTest = true
          return

    @clickedBlockIsPaletteBlock = false

  # PALETTE HIGHLIGHT CODE
  # ================================
  hook 'populate', 1, ->
    @paletteHighlightCanvas = document.createElement 'canvas'
    @paletteHighlightCanvas.className = 'ice-palette-highlight-canvas'
    @paletteHighlightCtx = @paletteHighlightCanvas.getContext '2d'

    @paletteHighlightPath = null
    @currentHighlightedPaletteBlock = null

    @paletteWrapper.appendChild @paletteHighlightCanvas

  hook 'resize', 0, ->
    @paletteHighlightCanvas.style.top = @paletteHeader.offsetHeight + 'px'
    @paletteHighlightCanvas.width = @paletteCanvas.width
    @paletteHighlightCanvas.height = @paletteCanvas.height

  hook 'redraw_palette', 0, ->
    @clearPaletteHighlightCanvas()
    if @currentHighlightedPaletteBlock?
      @paletteHighlightPath.draw @paletteHighlightCtx

  hook 'redraw_palette', 0, ->
    # Remove the existent blocks
    @paletteScrollerStuffing.innerHTML = ''

    @currentHighlightedPaletteBlock = null

    # Add new blocks
    for data in @currentPaletteMetadata
      block = data.block

      hoverDiv = document.createElement 'div'
      hoverDiv.className = 'ice-hover-div'

      hoverDiv.title = data.title ? block.stringify()

      bounds = @view.getViewNodeFor(block).totalBounds

      hoverDiv.style.top = "#{bounds.y}px"
      hoverDiv.style.left = "#{bounds.x}px"

      # Clip boxes to the width of the palette to prevent x-scrolling. TODO: fix x-scrolling behaviour.
      hoverDiv.style.width = "#{Math.min(bounds.width, Infinity)}px"
      hoverDiv.style.height = "#{bounds.height}px"

      do (block) =>
        hoverDiv.addEventListener 'mousemove', (event) =>
          palettePoint = @trackerPointToPalette @getPointRelativeToTracker event
          if @mainViewOrChildrenContains block, palettePoint
            unless block is @currentHighlightedPaletteBlock
              @clearPaletteHighlightCanvas()
              @paletteHighlightPath = @getHighlightPath block, {color: '#FF0'}
              @paletteHighlightPath.draw @paletteHighlightCtx
              @currentHighlightedPaletteBlock = block
          else if block is @currentHighlightedPaletteBlock
            @currentHighlightedPaletteBlock = null
            @clearPaletteHighlightCanvas()

        hoverDiv.addEventListener 'mouseout', (event) =>
          if block is @currentHighlightedPaletteBlock
            @currentHighlightedPaletteBlock = null
            @paletteHighlightCtx.clearRect @scrollOffsets.palette.x, @scrollOffsets.palette.y,
              @paletteHighlightCanvas.width + @scrollOffsets.palette.x, @paletteHighlightCanvas.height + @scrollOffsets.palette.y

      @paletteScrollerStuffing.appendChild hoverDiv

  # TEXT INPUT SUPPORT
  # ================================

  # Text input has two undo events: text change
  # and text reparse.
  class TextChangeOperation extends UndoOperation
    constructor: (socket, @before) ->
      @after = socket.stringify()
      @socket = socket.start.getSerializedLocation()

    undo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).container
      editor.populateSocket socket, @before

    redo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).container
      editor.populateSocket @socket, @after

  class TextReparseOperation extends UndoOperation
    constructor: (socket, @before) ->
      @after = socket.start.next.container
      @socket = socket.start.getSerializedLocation()

    undo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).container
      socket.start.next.container.moveTo null
      socket.start.insert new model.TextToken @before

    redo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).container
      socket.start.append socket.end; socket.notifyChange()
      @after.clone().moveTo socket

  # At populate-time, we need
  # to create and append the hidden input
  # we will use for text input.
  hook 'populate', 1, ->
    @hiddenInput = document.createElement 'textarea'
    @hiddenInput.className = 'ice-hidden-input'

    @iceElement.appendChild @hiddenInput

    # We also need to initialise some fields
    # for knowing what is focused
    @textFocus = null
    @textFocus = null
    @textInputAnchor = null

    @textInputSelecting = false

    @oldFocusValue = null

    # Prevent kids from deleting a necessary quote accidentally
    @hiddenInput.addEventListener 'keydown', (event) =>
      if event.keyCode is 8 and @hiddenInput.value.length > 1 and
          @hiddenInput.value[0] is @hiddenInput.value[@hiddenInput.value.length - 1] and
          @hiddenInput.value[0] in ['\'', '\"'] and @hiddenInput.selectionEnd is 1
        event.preventDefault()

    # The hidden input should be set up
    # to mirror the text to which it is associated.
    for event in ['input', 'keyup', 'keydown', 'select']
      @hiddenInput.addEventListener event, =>
        @highlightFlashShow()
        if @textFocus?
          @populateSocket @textFocus, @hiddenInput.value

          @redrawTextInput()

  hook 'resize', 0, ->
    @aceElement.style.width = "#{@wrapperElement.offsetWidth}px"
    @aceElement.style.height = "#{@wrapperElement.offsetHeight}px"

  last_ = (array) -> array[array.length - 1]

  # Redraw function for text input
  Editor::redrawTextInput = ->
    sameLength = @textFocus.stringify().split('\n').length is @hiddenInput.value.split('\n').length

    # Set the value in the model to fit
    # the hidden input value.
    @populateSocket @textFocus, @hiddenInput.value

    textFocusView = @view.getViewNodeFor @textFocus

    # Determine the coordinate positions
    # of the typing cursor
    startRow = @textFocus.stringify()[...@hiddenInput.selectionStart].split('\n').length - 1
    endRow = @textFocus.stringify()[...@hiddenInput.selectionEnd].split('\n').length - 1

    # Redraw the main canvas, on top of
    # which we will draw the cursor and
    # highlights.
    if sameLength and startRow is endRow
      line = endRow
      head = @textFocus.start

      until head is @tree.start
        head = head.prev
        if head.type is 'newline' then line++

      treeView = @view.getViewNodeFor @tree

      oldp = deepCopy [
        treeView.glue[line - 1],
        treeView.glue[line],
        treeView.bounds[line].height
      ]

      treeView.layout 0, @nubbyHeight

      newp = deepCopy [
        treeView.glue[line - 1],
        treeView.glue[line],
        treeView.bounds[line].height
      ]

      # If the layout has not changed enough to affect
      # anything non-local, only redraw locally.
      if deepEquals newp, oldp
        rect = new @draw.NoRectangle()

        rect.unite treeView.bounds[line - 1] if line > 0
        rect.unite treeView.bounds[line]
        rect.unite treeView.bounds[line + 1] if line + 1 < treeView.bounds.length

        rect.width = Math.max rect.width, @mainCanvas.width


        @redrawMain
          boundingRectangle: rect

      else @redrawMain()

    # Otherwise, redraw the whole thing
    else
      @redrawMain()

  Editor::redrawTextHighlights = (scrollIntoView = false) ->
    textFocusView = @view.getViewNodeFor @textFocus

    # Determine the coordinate positions
    # of the typing cursor
    startRow = @textFocus.stringify()[...@hiddenInput.selectionStart].split('\n').length - 1
    endRow = @textFocus.stringify()[...@hiddenInput.selectionEnd].split('\n').length - 1

    lines = @textFocus.stringify().split '\n'

    startPosition = textFocusView.bounds[startRow].x + @view.opts.textPadding +
      @mainCtx.measureText(last_(@textFocus.stringify()[...@hiddenInput.selectionStart].split('\n'))).width

    endPosition = textFocusView.bounds[endRow].x + @view.opts.textPadding +
      @mainCtx.measureText(last_(@textFocus.stringify()[...@hiddenInput.selectionEnd].split('\n'))).width

    # Now draw the highlight/typing cursor
    #
    # Draw a line if it is just a cursor
    if @hiddenInput.selectionStart is @hiddenInput.selectionEnd
      @cursorCtx.lineWidth = 1
      @cursorCtx.strokeStyle = '#000'
      @cursorCtx.strokeRect startPosition, textFocusView.bounds[startRow].y,
        0, @view.opts.textHeight
      @textInputHighlighted = false

    # Draw a translucent rectangle if there is a selection.
    else
      @textInputHighlighted = true
      @cursorCtx.fillStyle = 'rgba(0, 0, 256, 0.3)'

      if startRow is endRow
        @cursorCtx.fillRect startPosition, textFocusView.bounds[startRow].y + @view.opts.textPadding,
          endPosition - startPosition, @view.opts.textHeight

      else
        @cursorCtx.fillRect startPosition, textFocusView.bounds[startRow].y + @view.opts.textPadding,
          textFocusView.bounds[startRow].right() - @view.opts.textPadding - startPosition, @view.opts.textHeight

        for i in [startRow + 1...endRow]
          @cursorCtx.fillRect textFocusView.bounds[i].x,
            textFocusView.bounds[i].y + @view.opts.textPadding,
            textFocusView.bounds[i].width,
            @view.opts.textHeight

        @cursorCtx.fillRect textFocusView.bounds[endRow].x,
          textFocusView.bounds[endRow].y + @view.opts.textPadding,
          endPosition - textFocusView.bounds[endRow].x,
          @view.opts.textHeight

    if scrollIntoView and endPosition > @scrollOffsets.main.x + @mainCanvas.width
      @mainScroller.scrollLeft = endPosition - @mainCanvas.width + @view.opts.padding

  escapeString = (str) ->
    str[0] + str[1...-1].replace(/(\'|\"|\n)/g, '\\$1') + str[str.length - 1]

  # Convenince function for setting the text input
  Editor::setTextInputFocus = (focus, selectionStart = 0, selectionEnd = 0) ->
    if focus?.id of @extraMarks
      delete @extraMarks[focus?.id]

    # If there is already a focus, we
    # need to wrap some things up with it.
    if @textFocus? and @textFocus isnt focus

      # The first of these is an undo operation;
      # we need to add this text change to the undo stack.
      @addMicroUndoOperation 'CAPTURE_POINT'
      @addMicroUndoOperation new TextChangeOperation @textFocus, @oldFocusValue
      @oldFocusValue = null

      originalText = @textFocus.stringify()
      shouldPop = false

      # The second of these is a reparse attempt.
      # If we can, try to reparse the focus
      # value.
      unless @textFocus.handwritten
        newParse = null
        string = @textFocus.stringify().trim()
        try
          newParse = coffee.parse(unparsedValue = string, wrapAtRoot: false)
        catch
          if string[0] is string[string.length - 1] and string[0] in ['"', '\'']
            try
              string = escapeString string
              newParse = coffee.parse(unparsedValue = string, wrapAtRoot: false)
              @populateSocket @textFocus, string

        if newParse? and newParse.start.next.type is 'blockStart' and
            newParse.start.next.container.end.next is newParse.end
          # Empty the socket
          @textFocus.start.append @textFocus.end

          # Splice the other in
          newParse.start.next.container.spliceIn @textFocus.start

          @addMicroUndoOperation new TextReparseOperation @textFocus, unparsedValue
          shouldPop = true

      try
        # TODO make 'reparsable' property, bubble up until then
        parseParent = @textFocus.parent

        newParse = coffee.parse parseParent.stringify(), wrapAtRoot: true

        if newParse.start.next?.container?.end is newParse.end.prev
          if focus is null
            newParse = newParse.start.next

            if newParse.type is 'blockStart'
              parseParent.start.prev.append newParse
              newParse.container.end.append parseParent.end.next

              newParse.container.parent = newParse.parent = newParse.container.end.parent =
                parseParent.parent

              newParse.container.notifyChange()

              @addMicroUndoOperation new ReparseOperation parseParent, newParse.container

              parseParent.parent = null

        else
          throw new Error 'Socket is split.'

      catch
        # If we can't reparse the parent, abort all reparses
        @populateSocket @textFocus, originalText

        if shouldPop then @undoStack.pop()

        #@extraMarks[@textFocus.id] =
        #  model: @textFocus
        #  style: {color: '#F00'}

        @redrawMain()

    # Now we're done with the old focus,
    # we can start over.

    # If we're _unfocusing_, just do so.
    if not focus?
      @textFocus = null
      @redrawMain(); @hiddenInput.blur(); @iceElement.focus()
      return

    # Record old focus value
    @oldFocusValue = focus.stringify()

    # Now create a text token
    # with the appropriate text to put in it.
    @textFocus = focus

    # Immediately rerender.
    @populateSocket focus, focus.stringify()

    @textFocus.notifyChange()

    # Move the cursor near this
    @moveCursorTo focus.end

    # Set the hidden input up to mirror the text.
    @hiddenInput.value = @textFocus.stringify()

    if selectionStart < 0 then selectionStart = @textFocus.stringify().length - selectionStart
    if selectionEnd < 0 then selectionEnd = @textFocus.stringify().length - selectionEnd

    # Focus the hidden input.
    if @textFocus?
      @hiddenInput.focus()
      if @hiddenInput.value[0] is @hiddenInput.value[@hiddenInput.value.length - 1] and
         @hiddenInput.value[0] in ['\'', '"']
        @hiddenInput.setSelectionRange 1, @hiddenInput.value.length - 1
      else
        @hiddenInput.setSelectionRange 0, @hiddenInput.value.length
      @redrawTextInput()

    # Redraw.
    @redrawMain(); @redrawTextInput()

  Editor::populateSocket = (socket, string) ->
    lines = string.split '\n'
    socket.start.append socket.end
    head = socket.start

    for line, i in lines
      head = head.insert new model.TextToken line
      unless i + 1 is lines.length
        head = head.insert new model.NewlineToken()

    socket.notifyChange()

  # Convenience hit-testing function
  Editor::hitTestTextInput = (point, block) ->
    head = block.start
    while head?
      if head.type is 'socketStart' and head.next.type in ['text', 'socketEnd'] and
          @view.getViewNodeFor(head.container).path.contains point
        return head.container
      head = head.next

    return null

  # Convenience functions for setting
  # the text input selection, given
  # points on the main canvas.
  Editor::getTextPosition = (point) ->
    textFocusView = @view.getViewNodeFor @textFocus

    row = Math.floor((point.y - textFocusView.bounds[0].y) / (@fontSize + 2 * @view.opts.padding))

    row = Math.max row, 0
    row = Math.min row, textFocusView.lineLength - 1

    column = Math.max 0, Math.round((point.x - textFocusView.bounds[row].x - @view.opts.textPadding) / @mainCtx.measureText(' ').width)

    lines = @textFocus.stringify().split('\n')[..row]
    lines[lines.length - 1] = lines[lines.length - 1][...column]

    return lines.join('\n').length

  Editor::setTextInputAnchor = (point) ->
    @textInputAnchor = @textInputHead = @getTextPosition point
    @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

  Editor::selectDoubleClick = (point) ->
    position = @getTextPosition point

    before = @textFocus.stringify()[...position].match(/\w*$/)[0]?.length ? 0
    after = @textFocus.stringify()[position..].match(/^\w*/)[0]?.length ? 0

    @textInputAnchor = position - before
    @textInputHead = position + after

    @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

  Editor::setTextInputHead = (point) ->
    @textInputHead = @getTextPosition point
    @hiddenInput.setSelectionRange Math.min(@textInputAnchor, @textInputHead), Math.max(@textInputAnchor, @textInputHead)

  # On mousedown, we will want to start
  # selections and focus text inputs
  # if we apply.

  hook 'mousedown', 2, (point, event, state) ->
    # If someone else already took this click, return.
    if state.consumedHitTest then return

    # Otherwise, look for a socket that
    # the user has clicked
    mainPoint = @trackerPointToMain point
    hitTestResult = @hitTestTextInput mainPoint, @tree

    # If they have clicked a socket,
    # focus it, and
    unless hitTestResult is @textFocus
      @setTextInputFocus null
      @redrawMain()
      hitTestResult = @hitTestTextInput mainPoint, @tree

    if hitTestResult?
      unless hitTestResult is @textFocus
        @setTextInputFocus hitTestResult
        @redrawMain()

        @textInputSelecting = false

      else
        @setTextInputAnchor mainPoint
        @redrawTextInput()

        @textInputSelecting = true

      state.consumedHitTest = true

  hook 'dblclick', 0, (point, event, state) ->
    # If someone else already took this click, return.
    if state.consumedHitTest then return

    # Otherwise, look for a socket that
    # the user has clicked
    mainPoint = @trackerPointToMain point
    hitTestResult = @hitTestTextInput mainPoint, @tree

    # If they have clicked a socket,
    # focus it, and
    unless hitTestResult is @textFocus
      @setTextInputFocus null
      @redrawMain()
      hitTestResult = @hitTestTextInput mainPoint, @tree

    if hitTestResult?
      @setTextInputFocus hitTestResult
      @redrawMain()

      setTimeout (=>
        @selectDoubleClick mainPoint
        @redrawTextInput()

        @textInputSelecting = false
      ), 0

      state.consumedHitTest = true


  # On mousemove, if we are selecting,
  # we want to update the selection
  # to match the mouse.
  hook 'mousemove', 0, (point, event, state) ->
    if @textInputSelecting
      unless @textFocus?
        @textInputSelecting = false; return

      mainPoint = @trackerPointToMain point

      @setTextInputHead mainPoint

      @redrawTextInput()

  # On mouseup, we want to stop selecting.
  hook 'mouseup', 0, (point, event, state) ->
    if @textInputSelecting
      mainPoint = @trackerPointToMain point

      @setTextInputHead mainPoint

      @redrawTextInput()

      @textInputSelecting = false

  # LASSO SELECT SUPPORT
  # ===============================

  # We need undo operations for create/destroy segment
  # so that other undo operations work properly in
  # the tree -- for instance, DropOperation needs
  # to have the segment in the tree that is being
  # dropped in order to work.
  class CreateSegmentOperation extends UndoOperation
    constructor: (segment) ->
      @first = segment.start.getSerializedLocation()
      @last = segment.end.getSerializedLocation() - 2
      @lassoSelect = segment.isLassoSegment

    undo: (editor) ->
      editor.tree.getTokenAtLocation(@first).container.unwrap()

      return editor.tree.getTokenAtLocation @first

    redo: (editor) ->
      segment = new model.Segment()
      segment.isLassoSegment = @lassoSelect
      segment.wrap editor.tree.getTokenAtLocation(@first),
        editor.tree.getTokenAtLocation(@last)

      return segment.end

  class DestroySegmentOperation extends UndoOperation
    constructor: (segment) ->
      @first = segment.start.getSerializedLocation()
      @last = segment.end.getSerializedLocation() - 2
      @lassoSelect = segment.isLassoSegment

    undo: (editor) ->
      segment = new model.Segment()
      segment.isLassoSegment = @lassoSelect
      segment.wrap editor.tree.getTokenAtLocation(@first),
        editor.tree.getTokenAtLocation(@last)

      if @lassoSelect
        editor.lassoSegment = segment

      return segment.end

    redo: (editor) ->
      editor.tree.getTokenAtLocation(@first).container.unwrap()

      return editor.tree.getTokenAtLocation @first

  # The lasso select
  # will have its own canvas
  # for drawing the lasso. This needs
  # to be added at populate-time, along
  # with some fields.
  hook 'populate', 0, ->
    @lassoSelectCanvas = document.createElement 'canvas'
    @lassoSelectCanvas.className = 'ice-lasso-select-canvas'

    @lassoSelectCtx = @lassoSelectCanvas.getContext '2d'

    @lassoSelectAnchor = null
    @lassoSegment = null

    @iceElement.appendChild @lassoSelectCanvas

  # Conveneince function for clearing
  # the lasso select canvas
  Editor::clearLassoSelectCanvas = ->
    @lassoSelectCtx.clearRect 0, 0, @lassoSelectCanvas.width, @lassoSelectCanvas.height

  # Deal with resize for the lasso
  # select canvas
  hook 'resize', 0, ->
    @lassoSelectCanvas.width = @iceElement.offsetWidth
    @lassoSelectCanvas.style.width = "#{@lassoSelectCanvas.width}px"

    @lassoSelectCanvas.height = @iceElement.offsetHeight
    @lassoSelectCanvas.style.height = "#{@lassoSelectCanvas.height}px"

    @lassoSelectCanvas.style.left = "#{@mainCanvas.offsetLeft}px"

  Editor::clearLassoSelection = ->
    @lassoSegment = null

    head = @tree.start
    needToRedraw = false
    until head is @tree.end
      if head.type is 'segmentStart' and head.container.isLassoSegment
        next = head.next

        @addMicroUndoOperation new DestroySegmentOperation head.container
        head.container.unwrap() #MUTATION
        needToRedraw = true

        head = next

      else
        head = head.next

    if needToRedraw then @redrawMain()

  # On mousedown, if nobody has taken
  # a hit test yet, start a lasso select.
  hook 'mousedown', 0, (point, event, state) ->
    # Even if someone has taken it, we
    # should remove the lasso segment that is
    # already there.
    unless state.clickedLassoSegment then @clearLassoSelection()

    if state.consumedHitTest or state.suppressLassoSelect then return

    # If the point was actually in the main canvas,
    # start a lasso select.
    mainPoint = @trackerPointToMain(point).from @scrollOffsets.main
    palettePoint = @trackerPointToPalette(point).from @scrollOffsets.palette

    if 0 < mainPoint.x < @mainCanvas.width and 0 < mainPoint.y < @mainCanvas.height and not
       (0 < palettePoint.x < @paletteCanvas.width and 0 < palettePoint.x < @paletteCanvas.height)
      @lassoSelectAnchor = @trackerPointToMain point

  # On mousemove, if we are in the middle of a
  # lasso select, continue with it.
  hook 'mousemove', 0, (point, event, state) ->
    if @lassoSelectAnchor?
      mainPoint = @trackerPointToMain point

      @clearLassoSelectCanvas()

      # (draw the lasso rectangle)
      topLeftCorner = new @draw.Point(
        Math.min(@lassoSelectAnchor.x, mainPoint.x) - @scrollOffsets.main.x,
        Math.min(@lassoSelectAnchor.y, mainPoint.y) - @scrollOffsets.main.y
      )

      size = new @draw.Size(
        Math.abs(@lassoSelectAnchor.x - mainPoint.x),
        Math.abs(@lassoSelectAnchor.y - mainPoint.y)
      )

      @lassoSelectCtx.strokeStyle = '#00f'
      @lassoSelectCtx.strokeRect topLeftCorner.x, topLeftCorner.y, size.width, size.height

  # Convnience function for validating
  # a lasso selection. A lasso selection
  # cannot contain start tokens without
  # their corresponding end tokens, or vice
  # versa, and also must start and end
  # with blocks (not Indents).
  validateLassoSelection = (tree, first, last) ->
    tokensToInclude = []
    head = first
    until head is last.next
      if head instanceof model.StartToken or
         head instanceof model.EndToken
        tokensToInclude.push head.container.start
        tokensToInclude.push head.container.end
      head = head.next

    first = tree.start
    until first in tokensToInclude then first = first.next

    last = tree.end
    until last in tokensToInclude then last = last.prev

    until first.type is 'blockStart'
      first = first.prev
      if first.type is 'blockEnd' then first = first.container.start.prev

    until last.type is 'blockEnd'
      last = last.next
      if last.type is 'blockStart' then last = last.container.end.next

    return [first, last]

  # On mouseup, if we were
  # doing a lasso select, insert a lasso
  # select segment.
  hook 'mouseup', 0, (point, event, state) ->
    if @lassoSelectAnchor?
      mainPoint = @trackerPointToMain point
      lassoRectangle = new @draw.Rectangle(
          Math.min(@lassoSelectAnchor.x, mainPoint.x),
          Math.min(@lassoSelectAnchor.y, mainPoint.y),
          Math.abs(@lassoSelectAnchor.x - mainPoint.x),
          Math.abs(@lassoSelectAnchor.y - mainPoint.y)
      )

      @lassoSelectAnchor = null
      @clearLassoSelectCanvas()

      first = @tree.start
      until (not first?) or first.type is 'blockStart' and @view.getViewNodeFor(first.container).path.intersects lassoRectangle
        first = first.next

      last = @tree.end
      until (not last?) or last.type is 'blockEnd' and @view.getViewNodeFor(last.container).path.intersects lassoRectangle
        last = last.prev

      unless first? and last? then return

      [first, last] = validateLassoSelection @tree, first, last

      @lassoSegment = new model.Segment()
      @lassoSegment.isLassoSegment = true

      @lassoSegment.wrap first, last

      @addMicroUndoOperation new CreateSegmentOperation @lassoSegment

      # Move the cursor to the segment we just created
      @moveCursorTo @lassoSegment.end, true

      @redrawMain()

  # On mousedown, we might want to
  # pick a selected segment up; check.
  hook 'mousedown', 3, (point, event, state) ->
    if state.consumedHitTest then return

    if @lassoSegment? and @hitTest(@trackerPointToMain(point), @lassoSegment)?
      @clickedBlock = @lassoSegment
      @clickedPoint = point

      state.consumedHitTest = true
      state.clickedLassoSegment = true

  # CURSOR OPERATION SUPPORT
  # ================================

  hook 'populate', 0, ->
    @cursor = new model.CursorToken()

  # A cursor cannot be inside only a block.
  # Convenience function for this validation:
  isValidCursorPosition = (pos) ->
    return pos.parent.type in ['indent', 'segment']

  # A cursor is only allowed to be on a line.
  Editor::moveCursorTo = (destination, attemptReparse = false) ->
    # If the destination is not inside the tree,
    # abort.
    unless destination? then return
    unless @inTree(destination) then return

    @highlightFlashShow()

    # Otherwise, splice the cursor out.
    @cursor.remove()

    # If the destination is in the tree,
    # figure out where we want to place the cursor.

    # We can place the cursor
    # at the start of the tree
    if destination is @tree.start
      destination.insert @cursor

    # If we got some other token,
    # scan forward until we find
    # a viable spot for the cursor.
    else
      head = destination
      until head.type in ['newline', 'indentEnd'] or head is @tree.end
        head = head.next

      if head.type is 'newline' then head.insert @cursor
      else head.insertBefore @cursor

    # Keep scanning forward if this is an improper location.
    unless isValidCursorPosition @cursor then @moveCursorTo @cursor.next

    if attemptReparse
      @reparseHandwrittenBlocks()

    @redrawHighlights()

  Editor::moveCursorUp = ->
    # Seek the place we want to move the cursor
    head = @cursor.prev?.prev

    @highlightFlashShow()

    # If we're at the beginning, abort.
    unless head? then return

    until head.type in ['newline', 'indentEnd'] or head is @tree.start
      head = head.prev

    # Splice out
    @cursor.remove()

    # Splice in
    if head.type is 'newline' or head is @tree.start then head.insert @cursor
    else head.insertBefore @cursor

    # Keep sacnning backwards if this is an improper location.
    unless isValidCursorPosition @cursor then @moveCursorUp()

    @reparseHandwrittenBlocks()
    @redrawHighlights()
    @scrollCursorIntoPosition()

  Editor::determineCursorPosition = ->
    if @cursor? and @cursor.parent?
      @view.getViewNodeFor(@tree).layout 0, @nubbyHeight

      head = @cursor; line = 0
      until head is @cursor.parent.start
        head = head.prev
        line++ if head.type is 'newline'

      bound = @view.getViewNodeFor(@cursor.parent).bounds[line]
      if @cursor.nextVisibleToken()?.type is 'indentEnd' and
         @cursor.prev?.prev.type isnt 'indentStart' or
         (@cursor.next is @tree.end and @cursor.prev isnt @tree.start)
        return new @draw.Point bound.x, bound.bottom()
      else
        return new @draw.Point bound.x, bound.y

  Editor::scrollCursorIntoPosition = ->
    axis = @determineCursorPosition().y

    if axis - @scrollOffsets.main.y < 0
      @mainScroller.scrollTop = axis
    else if axis - @scrollOffsets.main.y > @mainCanvas.height
      @mainScroller.scrollTop = axis - @mainCanvas.height

    @mainScroller.scrollLeft = 0

  # Pressing the up-arrow moves the cursor up.
  hook 'key.up', 0, ->
    @clearLassoSelection()
    @setTextInputFocus null
    @moveCursorUp()

  # Pressing the down-arrow moves the cursor down.
  hook 'key.down', 0, ->
    @clearLassoSelection()
    @setTextInputFocus null
    @reparseHandwrittenBlocks()
    @moveCursorTo @cursor.next.next
    @scrollCursorIntoPosition()

  getCharactersTo = (parent, token) ->
    head = token
    chars = 0

    until head is parent.start
      if head.type is 'text' then chars += head.value.length
      head = head.prev

    return chars

  getSocketAtChar = (parent, chars) ->
    head = parent.start
    charsCounted = 0

    until charsCounted >= chars and head.type is 'socketStart' and
        (head.next.type is 'text' or head.next is head.container.end)
      if head.type is 'text' then charsCounted += head.value.length

      head = head.next

    return head.container

  hook 'key.tab', 0, ->
    if @shiftKeyPressed
      if @textFocus? then head = @textFocus.start
      else head = @cursor

      until (not head?) or head.type is 'socketEnd' and
          (head.container.start.next.type is 'text' or head.container.start.next is head.container.end)
        head = head.prev

      if head?
        if @textFocus? and head.container.hasParent @textFocus.parent
          persistentParent = @textFocus.parent.parent

          chars = getCharactersTo persistentParent, head.container.start
          @setTextInputFocus null
          socket = getSocketAtChar persistentParent, chars
        else
          socket = head.container
          @setTextInputFocus null

        @setTextInputFocus socket
      return false

    else
      if @textFocus? then head = @textFocus.end
      else head = @cursor

      until (not head?) or head.type is 'socketStart' and
          (head.container.start.next.type is 'text' or head.container.start.next is head.container.end)
        head = head.next
      if head?
        if @textFocus? and head.container.hasParent @textFocus.parent
          persistentParent = @textFocus.parent.parent

          chars = getCharactersTo persistentParent, head.container.start
          @setTextInputFocus null
          socket = getSocketAtChar persistentParent, chars
        else
          socket = head.container
          @setTextInputFocus null

        @setTextInputFocus socket
      return false

  Editor::deleteAtCursor = ->
    # Unfocus any inputs, which could get in the way.
    @setTextInputFocus null

    blockEnd = @cursor.prev

    until blockEnd?.type in ['blockEnd', 'indentStart', undefined]
      blockEnd = blockEnd.prev

    unless blockEnd? then return

    if blockEnd.type is 'blockEnd'
      @addMicroUndoOperation new PickUpOperation blockEnd.container

      blockEnd.container.spliceOut() #MUTATION

      @redrawMain()

  hook 'key.backspace', 0, (state, event) ->
    if state.capturedBackspace
      return

    # We don't want to interrupt any text input editing
    # sessions. We will, however, delete a handwritten
    # block if it is currently empty.
    if @lassoSegment?
      @addMicroUndoOperation 'CAPTURE_POINT'
      @deleteLassoSegment()
      return false

    else if not @textFocus? or
        (@hiddenInput.value.length is 0 and @textFocus.handwritten)
      @addMicroUndoOperation 'CAPTURE_POINT'
      @deleteAtCursor()
      state.capturedBackspace = true
      return false

    return true

  Editor::deleteLassoSegment = ->
    unless @lassoSegment?
      throw new Error 'Cannot delete nonexistent lasso segment'

    @addMicroUndoOperation new PickUpOperation @lassoSegment

    @lassoSegment.spliceOut()
    @lassoSegment = null

    @redrawMain()

  # HANDWRITTEN BLOCK SUPPORT
  # ================================

  hook 'populate', 0, ->
    @handwrittenBlocks = []

    @shiftKeyPressed = false

    # Keep track of whether the shift
    # key is pressed; it will
    # suppress the normal "enter"
    # handler.
    @keyListener.register_combo
      keys: 'shift'
      on_keydown: => @shiftKeyPressed = true
      on_keyup: => @shiftKeyPressed = false

    @keyListener.register_combo
      keys: 'enter'
      on_keydown: =>
        unless @textFocus? or @shiftKeyPressed
          @setTextInputFocus null

          # Construct the block; flag the socket as handwritten
          newBlock = new model.Block(); newSocket = new model.Socket -Infinity
          newSocket.spliceIn newBlock.start
          newSocket.handwritten = true

          # Add it io our list of handwritten blocks
          @handwrittenBlocks.push newBlock

          # Seek a place near the cursor we can actually
          # put a block.
          head = @cursor.prev
          while head.type in ['newline', 'cursor', 'segmentStart', 'segmentEnd'] and head isnt @tree.start
            head = head.prev

          # Log the undo operation for this
          @addMicroUndoOperation 'CAPTURE_POINT'
          @addMicroUndoOperation new DropOperation newBlock, head

          newBlock.moveTo head #MUTATION

          @redrawMain()
          @reparseHandwrittenBlocks()

          @newHandwrittenSocket = newSocket

        else if @textFocus? and not @shiftKeyPressed
          @setTextInputFocus null; @redrawMain()
        else
          return true

      on_keyup: =>
        if @newHandwrittenSocket?
          @setTextInputFocus @newHandwrittenSocket
          @newHandwrittenSocket = null

  containsCursor = (block) ->
    head = block.start
    until head is block.end
      if head.type is 'cursor' then return true
      head = head.next

    return false

  # The Reparse undo operation.
  class ReparseOperation extends UndoOperation
    constructor: (block, parse) ->
      @before = block.clone()
      @location = block.start.getSerializedLocation()
      @after = parse.clone()

    undo: (editor) ->
      block = editor.tree.getTokenAtLocation(@location).container
      newBlock = @before.clone()
      block.start.prev.append newBlock.start
      newBlock.end.append block.end.next

      newBlock.notifyChange()

    redo: (editor) ->
      block = editor.tree.getTokenAtLocation(@location).container
      newBlock = @after.clone()
      block.prev.append newBlock.start
      newBlock.end.append block.end.next

      newBlock.notifyChange()

  Editor::reparseHandwrittenBlocks = ->
    @setTextInputFocus null

    # Scan through the document to find handwritten
    # blocks
    head = @tree.start
    until head is @tree.end
      # If this is the start of a handwritten block,
      # we may want to reparse it.
      if  head.type is 'blockStart' and
          head.next.type is 'socketStart' and
          head.next.container.handwritten and
          not containsCursor head.container
        try
          # Reparse the block.
          newBlock = coffee.parse(head.container.stringify(), wrapAtRoot: true).start.next

          # (we only reparse if it is actually
          # a better parse than a handwritten block).
          if newBlock.type is 'blockStart'
            # Log the undo operation
            @addMicroUndoOperation new ReparseOperation head.container, newBlock.container

            # Splice it in perfectly.
            head.prev.append newBlock
            newBlock.container.end.append head.container.end.next

            newBlock.parent = head.container.parent
            head.container.parent = null

            newBlock.notifyChange()

            head = newBlock.container.end

      head = head.next

    @redrawMain()

    return null

  # INDENT CREATE/DESTROY SUPPORT
  # ================================

  ###
  # CreateIndent undo operation
  class CreateIndentOperation extends UndoOperation
    constructor: (pos, @depth) ->
      @location = pos.getSerializedLocation()

    undo: (editor) ->
      indent = editor.tree.getTokenAtLocation(@location).indent
      indent.start.prev.append indent.end.next; indent.notifyChange()

    redo: (editor) ->
      head = editor.tree.getTokenAtLocation(@location)

      newIndent = new model.Indent DEFAULT_INDENT_DEPTH
      head.prev.append(newIndent.start)
               .append(new model.NewlineToken())
               .append(newIndent.end)
               .append(head)

  # DestroyIndent undo operation
  class DestroyIndentOperation extends UndoOperation
    constructor: (indent) ->
      @location = indent.start.getSerializedLocation()
      @indent = indent.clone()

    undo: (editor) ->
      head = editor.tree.getTokenAtLocation(@location)

      newIndent = @indent.clone()
      head.prev.append newIndent.start
      newIndent.end.append head

      newIndent.notifyChange()

    redo: (editor) ->
      indent = editor.tree.getTokenAtLocation(@location).indent
      indent.start.prev.append indent.end.next; indent.notifyChange()

  # If we press tab while we are editing
  # a handwritten block, we create and indent.
  hook 'key.tab', 0, ->
    if @textFocus? and @textFocus.handwritten
      @addMicroUndoOperation 'CAPTURE_POINT'

      # Seek the block directly before this
      head = @textFocus.start
      until head.type is 'blockEnd'
        head = head.prev

      # If it ends in an indent,
      # move this block to that indent.
      if head.prev.type is 'indentEnd'
        until head.type in ['blockEnd', 'indentStart']
          head = head.prev

      # Otherwise, create an indent right before this.
      else
        @addMicroUndoOperation new CreateIndentOperation head, DEFAULT_INDENT_DEPTH

        newIndent = new model.Indent DEFAULT_INDENT_DEPTH
        newIndent.start.append(new model.NewlineToken()).append newIndent.end
        newIndent.spliceIn head.prev
        newIndent.notifyChange()

        head = newIndent.start

      # Go through the motions of moving this block into
      # the indent we have just found.
      @addMicroUndoOperation new PickUpOperation @textFocus.start.prev.container
      @textFocus.start.prev.container.spliceOut() #MUTATION

      @addMicroUndoOperation new DropOperation @textFocus.start.prev.container, head
      @textFocus.start.prev.container.spliceIn head #MUTATION

      # Move the cursor up to where the block now is.
      @moveCursorTo @textFocus.start.prev.container.end

      @redrawMain()

  # If we press backspace at the start of an empty
  # indent (an indent containing only whitespace),
  # delete that indent.
  hook 'key.backspace', 0, (state) ->
    if state.capturedBackspace then return

    if  not @textFocus? and
        @cursor.prev?.prev?.type is 'indentStart' and
        (indent = @cursor.prev.prev.indent).stringify().trim().length is 0

      @addMicroUndoOperation new DestroyIndentOperation indent
      indent.notifyChange()

      indent.start.prev.append indent.end.next #MUTATION

      @moveCursorTo indent.end.next

      state.capturedBackspace = true

      @redrawMain()
  ###

  # ANIMATION AND ACE EDITOR SUPPORT
  # ================================

  Editor::copyAceEditor = ->
    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'
    @resize()

  hook 'populate', 0, ->
    @aceElement = document.createElement 'div'
    @aceElement.className = 'ice-ace'

    @wrapperElement.appendChild @aceElement

    @aceEditor = ace.edit @aceElement

    @aceEditor.setTheme 'ace/theme/chrome'
    @aceEditor.setFontSize 15
    @aceEditor.getSession().setMode 'ace/mode/coffee'
    @aceEditor.getSession().setTabSize 2

    @aceEditor.on 'change', =>
      if @currentlyUsingBlocks and not @suppressAceChangeEvent
        @copyAceEditor()

    @currentlyUsingBlocks = true
    @currentlyAnimating = false

    @transitionContainer = document.createElement 'div'
    @transitionContainer.className = 'ice-transition-container'

    @iceElement.appendChild @transitionContainer

  # For animation and ace editor,
  # we will need a couple convenience functions
  # for getting the "absolute"-esque position
  # of layouted elements (a la jQuery, without jQuery).
  getOffsetTop = (element) ->
    top = element.offsetTop

    while (element = element.offsetParent)?
      top += element.offsetTop

    return top

  getOffsetLeft = (element) ->
    left = element.offsetLeft

    while (element = element.offsetParent)?
      left += element.offsetLeft

    return left

  Editor::computePlaintextTranslationVectors = ->
    # Now we need to figure out where all the text elements are going
    # to end up.
    textElements = []; translationVectors = []

    head = @tree.start

    aceSession = @aceEditor.session
    state = {
      # Initial cursor positions are
      # determined by ACE editor configuration.
      x: (@aceEditor.container.getBoundingClientRect().left -
          getOffsetLeft(@aceElement) +
          @aceEditor.renderer.$gutterLayer.gutterWidth) -
          @gutter.offsetWidth + 5 # TODO find out where this 5 comes from
      y: (@aceEditor.container.getBoundingClientRect().top -
          getOffsetTop(@aceElement)) -
          aceSession.getScrollTop()

      # Initial indent depth is 0
      indent: 0

      # Line height and left edge are
      # determined by ACE editor configuration.
      lineHeight: @aceEditor.renderer.layerConfig.lineHeight
      leftEdge: (@aceEditor.container.getBoundingClientRect().left -
          getOffsetLeft(@aceElement) +
          @aceEditor.renderer.$gutterLayer.gutterWidth) -
          @gutter.offsetWidth + 5 # TODO see above
    }

    @mainCtx.font = @aceFontSize() + ' ' + @fontFamily

    rownum = 0
    until head is @tree.end
      switch head.type
        when 'text'
          corner = @view.getViewNodeFor(head).bounds[0].upperLeftCorner()

          corner.x -= @scrollOffsets.main.x
          corner.y -= @scrollOffsets.main.y

          translationVectors.push (new @draw.Point(state.x, state.y)).from(corner)
          textElements.push @view.getViewNodeFor head

          state.x += @mainCtx.measureText(head.value).width

        # Newline moves the cursor to the next line,
        # plus some indent.
        when 'newline'
          # Be aware of wrapped ace editor lines.
          wrappedlines = Math.max(1,
              aceSession.documentToScreenRow(rownum + 1, 0) -
              aceSession.documentToScreenRow(rownum, 0))
          rownum += 1
          state.y += state.lineHeight * wrappedlines
          if head.specialIndent?
            state.x = state.leftEdge + @mainCtx.measureText(head.specialIndent).width
          else
            state.x = state.leftEdge + state.indent * @mainCtx.measureText(' ').width

        when 'indentStart'
          state.indent += head.container.depth

        when 'indentEnd'
          state.indent -= head.container.depth

      head = head.next

    return {
      textElements: textElements
      translationVectors: translationVectors
    }

  class AnimatedColor
    constructor: (@start, @end, @time) ->
      @currentRGB = [
        parseInt(@start[1...3], 16)
        parseInt(@start[3...5], 16)
        parseInt(@start[5...7], 16)
      ]

      @step = [
        (parseInt(@end[1...3], 16) - @currentRGB[0]) / @time
        (parseInt(@end[3...5], 16) - @currentRGB[1]) / @time
        (parseInt(@end[5...7], 16) - @currentRGB[2]) / @time
      ]

    advance: ->
      for item, i in @currentRGB
        @currentRGB[i] += @step[i]

      return "rgb(#{Math.round(@currentRGB[0])},#{Math.round(@currentRGB[1])},#{Math.round(@currentRGB[2])})"

  Editor::performMeltAnimation = (fadeTime = 500, translateTime = 1000, cb = ->) ->
    if @currentlyUsingBlocks and not @currentlyAnimating
      @fireEvent 'statechange', [false]

      @aceEditor.setValue @getValue(), -1

      top = @findLineNumberAtCoordinate @scrollOffsets.main.y
      @aceEditor.scrollToLine top

      @aceEditor.resize true

      @redrawMain noText: true
      @textFocus = @lassoAnchor = null

      # Hide scrollbars and increase width
      if @mainScroller.scrollWidth > @mainScroller.offsetWidth
        @mainScroller.style.overflowX = 'scroll'
      else
        @mainScroller.style.overflowX = 'hidden'
      @mainScroller.style.overflowY = 'hidden'
      @iceElement.style.width = @wrapperElement.offsetWidth + 'px'

      @currentlyUsingBlocks = false; @currentlyAnimating = @currentlyAnimating_suppressRedraw = true

      # Move the palette header into the background
      @paletteHeader.style.zIndex = 0

      # Compute where the text will end up
      # in the ace editor
      {textElements, translationVectors} = @computePlaintextTranslationVectors()

      translatingElements = []

      for textElement, i in textElements

        # Skip anything that's
        # off the screen the whole time.
        unless 0 < textElement.bounds[0].bottom() - @scrollOffsets.main.y + translationVectors[i].y and
                   textElement.bounds[0].y - @scrollOffsets.main.y + translationVectors[i].y < @mainCanvas.height
          continue

        div = document.createElement 'div'
        div.style.whiteSpace = 'pre'

        div.innerText = textElement.model.value

        div.style.font = @fontSize + 'px ' + @fontFamily

        div.style.left = "#{textElement.bounds[0].x - @scrollOffsets.main.x}px"
        div.style.top = "#{textElement.bounds[0].y - @scrollOffsets.main.y - @fontAscent}px"

        div.className = 'ice-transitioning-element'
        div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
        translatingElements.push div

        @transitionContainer.appendChild div

        do (div, textElement, translationVectors, i) =>
          setTimeout (=>
            div.style.left = (textElement.bounds[0].x - @scrollOffsets.main.x + translationVectors[i].x) + 'px'
            div.style.top = (textElement.bounds[0].y - @scrollOffsets.main.y + translationVectors[i].y) + 'px'
            div.style.fontSize = @aceFontSize()
          ), fadeTime

      top = Math.max @aceEditor.getFirstVisibleRow(), 0
      bottom = Math.min @aceEditor.getLastVisibleRow(), @view.getViewNodeFor(@tree).lineLength - 1
      aceScrollTop = @aceEditor.session.getScrollTop()

      treeView = @view.getViewNodeFor @tree
      lineHeight = @aceEditor.renderer.layerConfig.lineHeight

      for line in [top..bottom]
        div = document.createElement 'div'
        div.style.whiteSpace = 'pre'

        div.innerText = line + 1

        div.style.left = 0
        div.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @view.opts.textHeight - @fontAscent - @scrollOffsets.main.y}px"

        div.style.font = @fontSize + 'px ' + @fontFamily
        div.style.width = "#{@gutter.offsetWidth}px"
        translatingElements.push div

        div.className = 'ice-transitioning-element ice-transitioning-gutter'
        div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"

        @iceElement.appendChild div

        do (div, line) =>
          # Set off the css transition
          setTimeout (=>
            div.style.left = '0px'
            div.style.top = (@aceEditor.session.documentToScreenRow(line, 0) *
                lineHeight - aceScrollTop) + 'px'
            div.style.fontSize = @aceFontSize()
          ), fadeTime

      @lineNumberWrapper.style.display = 'none'

      # Kick off fade-out transition

      @mainCanvas.style.transition =
        @highlightCanvas.style.transition =
        @cursorCanvas.style.opacity = "opacity #{fadeTime}ms linear"

      @mainCanvas.style.opacity =
        @highlightCanvas.style.opacity =
        @cursorCanvas.style.opacity = 0

      @iceElement.style.transition =
        @paletteWrapper.style.transition = "left #{fadeTime}ms"

      @iceElement.style.left = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

      setTimeout (=>
        # Translate the ICE editor div out of frame.
        @iceElement.style.transition =
          @paletteWrapper.style.transition = ''

        @iceElement.style.top = '-9999px'
        @iceElement.style.left = '-9999px'

        @paletteWrapper.style.top = '-9999px'
        @paletteWrapper.style.left = '-9999px'

        # Translate the ACE editor div into frame.
        @aceElement.style.top = "0px"
        @aceElement.style.left = "0px"

        # Finalize a bunch of animations
        # that should be complete by now,
        # but might not actually be due to
        # floating point stuff.
        @currentlyAnimating = false

        # Show scrollbars again
        @mainScroller.style.overflow = 'auto'

        for div in translatingElements
          div.parentNode.removeChild div

        @fireEvent 'toggledone', [@currentlyUsingBlocks]

        if cb? then do cb
      ), fadeTime + translateTime

      return success: true

  Editor::aceFontSize = ->
    parseFloat(@aceEditor.getFontSize()) + 'px'

  Editor::performFreezeAnimation = (fadeTime = 500, translateTime = 500, cb = ->)->
    if not @currentlyUsingBlocks and not @currentlyAnimating
      @copyAceEditor()

      @fireEvent 'statechange', [true]

      setValueResult = @setValue_raw @aceEditor.getValue()

      unless setValueResult.success
        return setValueResult

      if @aceEditor.getFirstVisibleRow() is 0
        @mainScroller.scrollTop = 0
      else
        @mainScroller.scrollTop = @view.getViewNodeFor(@tree).bounds[@aceEditor.getFirstVisibleRow()].y

      @currentlyUsingBlocks = true
      @currentlyAnimating = true

      setTimeout (=>
        # Hide scrollbars and increase width
        @mainScroller.style.overflow = 'hidden'
        @iceElement.style.width = @wrapperElement.offsetWidth + 'px'

        @redrawMain noText: true

        @currentlyAnimating_suppressRedraw = true

        @aceElement.style.top = "-9999px"
        @aceElement.style.left = "-9999px"

        @paletteWrapper.style.top = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

        @iceElement.style.top = "0px"
        @iceElement.style.left = "0px"

        @paletteHeader.style.zIndex = 0

        {textElements, translationVectors} = @computePlaintextTranslationVectors()

        translatingElements = []

        for textElement, i in textElements

          # Skip anything that's
          # off the screen the whole time.
          unless 0 < textElement.bounds[0].bottom() - @scrollOffsets.main.y + translationVectors[i].y and
                   textElement.bounds[0].y - @scrollOffsets.main.y + translationVectors[i].y < @mainCanvas.height
            continue

          div = document.createElement 'div'
          div.style.whiteSpace = 'pre'

          div.innerText = textElement.model.value

          div.style.font = @aceFontSize() + ' ' + @fontFamily
          div.style.position = 'absolute'

          div.style.left = "#{textElement.bounds[0].x - @scrollOffsets.main.x + translationVectors[i].x}px"
          div.style.top = "#{textElement.bounds[0].y - @scrollOffsets.main.y + translationVectors[i].y}px"

          div.className = 'ice-transitioning-element'
          div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
          translatingElements.push div

          @transitionContainer.appendChild div

          do (div, textElement) =>
            setTimeout (=>
              div.style.left = "#{textElement.bounds[0].x - @scrollOffsets.main.x}px"
              div.style.top = "#{textElement.bounds[0].y - @scrollOffsets.main.y - @fontAscent}px"
              div.style.fontSize = @fontSize + 'px'
            ), 0

        top = Math.max @aceEditor.getFirstVisibleRow(), 0
        bottom = Math.min @aceEditor.getLastVisibleRow(), @view.getViewNodeFor(@tree).lineLength - 1

        treeView = @view.getViewNodeFor @tree
        lineHeight = @aceEditor.renderer.layerConfig.lineHeight

        aceScrollTop = @aceEditor.session.getScrollTop()

        for line in [top..bottom]
          div = document.createElement 'div'
          div.style.whiteSpace = 'pre'

          div.innerText = line + 1

          div.style.font = @aceFontSize() + ' ' + @fontFamily
          div.style.width = "#{@aceEditor.renderer.$gutter.offsetWidth}px"

          div.style.left = 0
          div.style.top = "#{@aceEditor.session.documentToScreenRow(line, 0) *
              lineHeight - aceScrollTop}px"

          div.className = 'ice-transitioning-element ice-transitioning-gutter'
          div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
          translatingElements.push div

          @iceElement.appendChild div

          do (div, line) =>
            setTimeout (=>
              div.style.left = 0
              div.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @view.opts.textHeight - @fontAscent- @scrollOffsets.main.y}px"
              div.style.fontSize = @fontSize + 'px'
            ), 0

        for el in [@mainCanvas, @highlightCanvas, @cursorCanvas]
          el.style.opacity = 0

        setTimeout (=>
          for el in [@mainCanvas, @highlightCanvas, @cursorCanvas]
            el.style.transition = "opacity #{fadeTime}ms linear"
            el.style.opacity = 1
        ), translateTime

        @iceElement.style.transition =
          @paletteWrapper.style.transition = "left #{fadeTime}ms"

        @iceElement.style.left = "#{@paletteWrapper.offsetWidth}px"
        @paletteWrapper.style.left = '0px'

        setTimeout (=>
          @iceElement.style.transition =
            @paletteWrapper.style.transition = ''

          # Show scrollbars again
          @mainScroller.style.overflow = 'auto'

          @currentlyAnimating = false
          @lineNumberWrapper.style.display = 'block'
          @redrawMain()
          @paletteHeader.style.zIndex = 257

          for div in translatingElements
            div.parentNode.removeChild div

          @resize()

          @fireEvent 'toggledone', [@currentlyUsingBlocks]

          if cb? then do cb
        ), translateTime + fadeTime

      ), 0

      return success: true

  Editor::toggleBlocks = (cb) ->
    if @currentlyUsingBlocks
      return @performMeltAnimation 700, 500, cb
    else
      return @performFreezeAnimation 500, 500, cb

  # SCROLLING SUPPORT
  # ================================

  hook 'populate', 2, ->
    @scrollOffsets = {
      main: new @draw.Point 0, 0
      palette: new @draw.Point 0, 0
    }

    @mainScroller = document.createElement 'div'
    @mainScroller.className = 'ice-main-scroller'

    @mainScrollerStuffing = document.createElement 'div'
    @mainScrollerStuffing.className = 'ice-main-scroller-stuffing'

    @mainScroller.appendChild @mainScrollerStuffing
    @iceElement.appendChild @mainScroller

    @mainScroller.addEventListener 'scroll', =>
      @scrollOffsets.main.y = @mainScroller.scrollTop
      @scrollOffsets.main.x = @mainScroller.scrollLeft

      @mainCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y

      # Also update scroll for the highlight ctx, so that
      # they can match the blocks' positions
      @highlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y
      @cursorCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.main.x, -@scrollOffsets.main.y

      @redrawMain()

    @paletteScroller = document.createElement 'div'
    @paletteScroller.className = 'ice-palette-scroller'

    @paletteScrollerStuffing = document.createElement 'div'
    @paletteScrollerStuffing.className = 'ice-palette-scroller-stuffing'

    @paletteScroller.appendChild @paletteScrollerStuffing
    @paletteWrapper.appendChild @paletteScroller

    @paletteScroller.addEventListener 'scroll', =>
      @scrollOffsets.palette.y = @paletteScroller.scrollTop

      # Temporarily ignoring x-scroll to fix bad x-scrolling behaviour
      # when dragging blocks out of the palette. TODO: fix x-scrolling behaviour.
      # @scrollOffsets.palette.x = @paletteScroller.scrollLeft

      @paletteCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y
      @paletteHighlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y

      @redrawPalette()

  hook 'resize', 0, ->
    @mainScroller.style.width = "#{@iceElement.offsetWidth}px"
    @mainScroller.style.height = "#{@iceElement.offsetHeight}px"

  hook 'resize_palette', 0, ->
    @paletteScroller.style.top = "#{@paletteHeader.offsetHeight}px"
    @paletteScroller.style.width = "#{@paletteCanvas.offsetWidth}px"
    @paletteScroller.style.height = "#{@paletteCanvas.offsetHeight}px"

  hook 'redraw_main', 1, ->
    bounds = @view.getViewNodeFor(@tree).getBounds()
    for record in @floatingBlocks
      bounds.unite @view.getViewNodeFor(record.block).getBounds()

    @mainScrollerStuffing.style.width = "#{bounds.right()}px"
    @mainScrollerStuffing.style.height = "#{bounds.bottom()}px"

  hook 'redraw_palette', 0, ->
    bounds = new @draw.NoRectangle()
    for block in @currentPaletteBlocks
      bounds.unite @view.getViewNodeFor(block).getBounds()

    # For now, we will comment out this line
    # due to bugs
    #@paletteScrollerStuffing.style.width = "#{bounds.right()}px"
    @paletteScrollerStuffing.style.height = "#{bounds.bottom()}px"

  # MULTIPLE FONT SIZE SUPPORT
  # ================================
  hook 'populate', 0, ->
    @fontSize = 15
    @fontFamily = 'Courier New'
    @fontAscent = helper.fontMetrics(@fontFamily, @fontSize).prettytop

  Editor::setFontSize_raw = (fontSize) ->
    unless @fontSize is fontSize
      @fontSize = fontSize

      @paletteHeader.style.fontSize = "#{fontSize}px"
      @gutter.style.fontSize = "#{fontSize}px"

      @view.opts.textHeight =
        @dragView.opts.textHeight = helper.getFontHeight @fontFamily, @fontSize

      @fontAscent = helper.fontMetrics(@fontFamily, @fontSize).prettytop

      @view.clearCache()

      @dragView.clearCache()

      @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'

      @redrawMain(); @redrawPalette()

  Editor::setFontFamily = (fontFamily) ->
    @draw.setGlobalFontFamily fontFamily

    @fontFamily = fontFamily

    @view.opts.textHeight = helper.getFontHeight @fontFamily, @fontSize
    @fontAscent = helper.fontMetrics(@fontFamily, @fontSize).prettytop

    @view.clearCache(); @dragView.clearCache()
    @gutter.style.fontFamily = fontFamily

    @redrawMain(); @redrawPalette()

  Editor::setFontSize = (fontSize) ->
    @setFontSize_raw fontSize
    @resize()

  # MUTATION BUTTON SUPPORT
  # ================================

  class MutationButtonOperation extends UndoOperation
    constructor: (button) ->
      @button = button.clone()
      @location = button.getSerializedLocation()

    undo: (editor) ->
      end = start = editor.tree.getTokenAtLocation(@location)

      # We want to scan (n) tokens forward, where
      # (n) is the length of the expanded value
      # of this token.
      head = @button.expandValue.start.next
      until head is @button.expandValue.end
        head = head.next; end = end.next

      # Splice the original button in.
      start.prev.append(button = @button.clone()).append end

      return button

    redo: (editor) ->
      editor.tree.getTokenAtLocation(@location).expand()

  hook 'mousedown', 4, (point, event, state) ->
    if state.consumedHitTest then return

    mainPoint = @trackerPointToMain point

    head = @tree.start
    until head is @tree.end
      if head.type is 'mutationButton' and @view.getViewNodeFor(head).bounds[0].contains mainPoint
        @addMicroUndoOperation new MutationButtonOperation head
        head.expand() #MUTATION

        @redrawMain()
        state.consumedHitTest = true

        return

      head = head.next

  # LINE MARKING SUPPORT
  # ================================

  hook 'populate', 0, ->
    @markedLines = {}
    @extraMarks = {}

  Editor::getHighlightPath = (model, style) ->
    path = @view.getViewNodeFor(model).path.clone()

    path.style.fillColor = null
    path.style.strokeColor = style.color
    path.style.lineWidth = 3
    path.noclip = true; path.bevel = false

    return path

  Editor::markLine = (line, style) ->
    block = @tree.getBlockOnLine line

    if block?
      @markedLines[line] =
        model: block
        style: style

    @redrawMain()

  Editor::unmarkLine = (line) ->
    delete @markedLines[line]

    @redrawMain()

  Editor::clearLineMarks = (tag) ->
    @markedLines = {}

    @redrawMain()

  # LINE HOVER SUPPORT
  # ================================

  hook 'populate', 0, ->
    @lastHoveredLine = null

  hook 'mousemove', 0, (point, event, state) ->
    # Do not attempt to detect this if we are currently dragging something,
    # or no event handlers are bound.
    if not @draggingBlock? and not @clickedBlock? and @hasEvent 'linehover'
      mainPoint = @trackerPointToMain point

      treeView = @view.getViewNodeFor @tree

      if @lastHoveredLine? and treeView.bounds[@lastHoveredLine]? and
          treeView.bounds[@lastHoveredLine].contains mainPoint
        return

      hoveredLine = @findLineNumberAtCoordinate point.y

      unless treeView.bounds[hoveredLine].contains mainPoint
        hoveredLine = null

      if hoveredLine isnt @lastHoveredLine
        @fireEvent 'linehover', [line: @lastHoveredLine = hoveredLine]

  # GET/SET VALUE SUPPORT
  # ================================

  class SetValueOperation extends UndoOperation
    constructor: (@oldValue, @newValue) ->
      @oldValue = @oldValue.clone()
      @newValue = @newValue.clone()

    undo: (editor) ->
      editor.tree = @oldValue.clone()

      return editor.tree.start

    redo: (editor) ->
      editor.tree = @newValue.clone()

      return editor.tree.start

  # Whitespace trimming hack enable/disable
  # setter
  hook 'populate', 0, ->
    @trimWhitespace = false

  Editor::setTrimWhitespace = (trimWhitespace) ->
    @trimWhitespace = trimWhitespace

  Editor::setValue_raw = (value) ->
    if @trimWhitespace then value = value.trim()

    newParse = coffee.parse value, wrapAtRoot: true

    if value isnt @tree.stringify()
      @addMicroUndoOperation 'CAPTURE_POINT'
    @addMicroUndoOperation new SetValueOperation @tree, newParse

    @tree = newParse; @gutterVersion = -1
    @tree.start.insert @cursor
    @removeBlankLines()
    @redrawMain()

    return success: true

  Editor::setValue = (value) ->

    oldScrollTop = @aceEditor.session.getScrollTop()

    @aceEditor.setValue value, -1
    @aceEditor.resize true

    @aceEditor.session.setScrollTop oldScrollTop

    if @currentlyUsingBlocks
      @setValue_raw value

  Editor::addEmptyLine = (str) ->
    if str.length is 0 or str[str.length - 1] is '\n'
      return str
    else
      return str + '\n'

  Editor::getValue = ->
    if @currentlyUsingBlocks
      return @addEmptyLine @tree.stringify()
    else
      @aceEditor.getValue()

  # PUBLIC EVENT BINDING HOOKS
  # ===============================

  hook 'populate', 0, ->
    @bindings = {}

  Editor::on = (event, handler) ->
    @bindings[event] = handler

  Editor::once = (event, handler) ->
    @bindings[event] = ->
      handler.apply this, arguments
      @bindings[event] = null

  Editor::fireEvent = (event, args) ->
    if event of @bindings
      @bindings[event].apply this, args

  Editor::hasEvent = (event) -> event of @bindings and @bindings[event]?

  # SYNCHRONOUS TOGGLE SUPPORT
  # ================================

  Editor::setEditorState = (useBlocks) ->
    if useBlocks
      @setValue @aceEditor.getValue()

      @iceElement.style.top =
        @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'

      @iceElement.style.left = "#{@paletteWrapper.offsetWidth}px"

      @aceElement.style.top = @aceElement.style.left = '-9999px'
      @currentlyUsingBlocks = true

      @lineNumberWrapper.style.display = 'block'

      @mainCanvas.opacity = @paletteWrapper.opacity =
        @highlightCanvas.opacity = 1

      @resize(); @redrawMain()

    else
      oldScrollTop = @aceEditor.session.getScrollTop()

      @aceEditor.setValue @getValue(), -1
      @aceEditor.resize true

      @aceEditor.session.setScrollTop oldScrollTop

      @iceElement.style.top = @iceElement.style.left =
        @paletteWrapper.style.top = @paletteWrapper.style.left = '-9999px'
      @aceElement.style.top = @aceElement.style.left = '0px'
      @currentlyUsingBlocks = false

      @lineNumberWrapper.style.display = 'none'

      @mainCanvas.opacity =
        @highlightCanvas.opacity = 0

      @resize()

  # DRAG CANVAS SHOW/HIDE HACK
  # ================================

  hook 'populate', 0, ->
    @dragCover = document.createElement 'div'
    @dragCover.className = 'ice-drag-cover'
    @dragCover.style.display = 'none'

    document.body.appendChild @dragCover

  # On mousedown, bring the drag
  # canvas to the front so that it
  # appears to "float" over all other elements
  hook 'mousedown', -1, ->
    if @clickedBlock?
      @dragCover.style.display = 'block'
      @dragCanvas.style.zIndex = 300

  # On mouseup, throw the drag canvas away completely.
  hook 'mouseup', 0, ->
    @dragCanvas.style.top =
      @dragCanvas.style.left = '-9999px'

    @dragCanvas.style.zIndex = 0
    @dragCover.style.display = 'none'

  # TOUCHSCREEN SUPPORT
  # =================================

  # We will attempt to emulate
  # mouse events using touchstart/end
  # data.
  touchEvents =
    'touchstart': 'mousedown'
    'touchmove': 'mousemove'
    'touchend': 'mouseup'

  # A timeout for selection
  TOUCH_SELECTION_TIMEOUT = 1000

  Editor::touchEventToPoint = (event, index) ->
    absolutePoint = new @draw.Point(
      event.changedTouches[index].pageX,
      event.changedTouches[index].pageY
    )

    return absolutePoint.from(@absoluteOffset(@iceElement))

  Editor::queueLassoMousedown = (trackPoint, event) ->
    @lassoSelectStartTimeout = setTimeout (=>
      state = {}

      for handler in editorBindings.mousedown
        handler.call this, trackPoint, event, state), TOUCH_SELECTION_TIMEOUT

  # We will bind the same way as mouse events do,
  # wrapping to be compatible with a mouse event interface.
  #
  # When users drag with multiple fingers, we emulate scrolling.
  # Otherwise, we emulate mousedown/mouseup
  hook 'populate', 0, ->
    @touchScrollAnchor = new @draw.Point 0, 0
    @lassoSelectStartTimeout = null

    @wrapperElement.addEventListener 'touchstart', (event) =>
      clearTimeout @lassoSelectStartTimeout

      trackPoint = @touchEventToPoint event, 0

      # We keep a state object so that handlers
      # can know about each other.
      #
      # We will suppress lasso select to
      # allow scrolling.
      state = {
        suppressLassoSelect: true
      }

      # Call all the handlers.
      for handler in editorBindings.mousedown
        handler.call this, trackPoint, event, state

      # If we did not hit anything,
      # we may want to start a lasso select
      # in a little bit.
      if state.consumedHitTest
        event.preventDefault()
      else
        @queueLassoMousedown trackPoint, event

    @wrapperElement.addEventListener 'touchmove', (event) =>
      clearTimeout @lassoSelectStartTimeout

      trackPoint = @touchEventToPoint event, 0

      unless @clickedBlock? or @draggingBlock?
        @queueLassoMousedown trackPoint, event

      # We keep a state object so that handlers
      # can know about each other.
      state = {}

      # Call all the handlers.
      for handler in editorBindings.mousemove
        handler.call this, trackPoint, event, state

      # If we are in the middle of some action,
      # prevent scrolling.
      if @clickedBlock? or @draggingBlock? or @lassoSelectAnchor? or @textInputSelecting
        event.preventDefault()

    @wrapperElement.addEventListener 'touchend', (event) =>
      clearTimeout @lassoSelectStartTimeout

      trackPoint = @touchEventToPoint event, 0

      # We keep a state object so that handlers
      # can know about each other.
      state = {}

      # Call all the handlers.
      for handler in editorBindings.mouseup
        handler.call this, trackPoint, event, state

      event.preventDefault()

  # CURSOR DRAW SUPPORRT
  # ================================
  hook 'populate', 0, ->
    @cursorCanvas = document.createElement 'canvas'
    @cursorCanvas.className = 'ice-highlight-canvas'

    @cursorCtx = @cursorCanvas.getContext '2d'

    @iceElement.appendChild @cursorCanvas

  hook 'resize', 0, ->
    @cursorCanvas.width = @iceElement.offsetWidth
    @cursorCanvas.style.width = "#{@cursorCanvas.width}px"

    @cursorCanvas.height = @iceElement.offsetHeight
    @cursorCanvas.style.height = "#{@cursorCanvas.height}px"

    @cursorCanvas.style.left = "#{@mainCanvas.offsetLeft}px"

  Editor::strokeCursor = (point) ->
    return unless point?
    @cursorCtx.beginPath()

    @cursorCtx.fillStyle =
      @cursorCtx.strokeStyle = '#000'

    @cursorCtx.lineCap = 'round'

    @cursorCtx.lineWidth = 3

    w = @view.opts.tabWidth / 2 - CURSOR_WIDTH_DECREASE
    h = @view.opts.tabHeight - CURSOR_HEIGHT_DECREASE

    arcCenter = new @draw.Point point.x + @view.opts.tabOffset + w + CURSOR_WIDTH_DECREASE,
      point.y - (w*w + h*h) / (2 * h) + h + CURSOR_HEIGHT_DECREASE / 2
    arcAngle = Math.atan2 w, (w*w + h*h) / (2 * h) - h
    startAngle = 0.5 * Math.PI - arcAngle
    endAngle = 0.5 * Math.PI + arcAngle

    @cursorCtx.arc arcCenter.x, arcCenter.y, (w*w + h*h) / (2 * h), startAngle, endAngle

    @cursorCtx.stroke()

  Editor::highlightFlashShow = ->
    if @flashTimeout? then clearTimeout @flashTimeout
    @cursorCanvas.style.display = 'block'
    @highlightsCurrentlyShown = true
    @flashTimeout = setTimeout (=> @flash()), 500

  Editor::highlightFlashHide = ->
    if @flashTimeout? then clearTimeout @flashTimeout
    @cursorCanvas.style.display = 'none'
    @highlightsCurrentlyShown = false
    @flashTimeout = setTimeout (=> @flash()), 500

  Editor::flash = ->
    if @lassoSegment? or @draggingBlock? or
        (@textFocus? and @textInputHighlighted) or
        not @highlightsCurrentlyShown
      @highlightFlashShow()
    else
      @highlightFlashHide()

  hook 'populate', 0, ->
    @highlightsCurrentlyShown = false

    @flashTimeout = setTimeout (=> @flash()), 0

  # ONE MORE DROP CASE
  # ================================

  # If we drop a block right back onto
  # its grayed-out spot, cancel the drag.

  # TODO possibly move this next utility function to view?
  Editor::mainViewOrChildrenContains = (model, point) ->
    modelView = @view.getViewNodeFor model

    if modelView.path.contains point
      return true

    for childObj in modelView.children
      if @mainViewOrChildrenContains childObj.child, point
        return true

    return false

  hook 'mouseup', 0.5, (point, event) ->
    if @draggingBlock?
      trackPoint = new @draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )
      renderPoint = @trackerPointToMain trackPoint

      if @inTree(@draggingBlock) and @mainViewOrChildrenContains @draggingBlock, renderPoint
        @draggingBlock.ephemeral = false

        @draggingBlock = null
        @draggingOffset = null
        @lastHighlight = null

        @clearDrag()
        @redrawMain()

  # LINE NUMBER GUTTER CODE
  # ================================
  hook 'populate', 0, ->
    @gutter = document.createElement 'div'
    @gutter.className = 'ice-gutter'

    @lineNumberWrapper = document.createElement 'div'
    @gutter.appendChild @lineNumberWrapper

    @gutterVersion = -1

    @lineNumberTags = {}

    @iceElement.appendChild @gutter

  hook 'resize', 0, ->
    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'

  Editor::addLineNumberForLine = (line) ->
    treeView = @view.getViewNodeFor @tree

    if line of @lineNumberTags
      lineDiv = @lineNumberTags[line]

    else
      lineDiv = document.createElement 'div'
      lineDiv.className = 'ice-gutter-line'
      lineDiv.innerText = line + 1

      @lineNumberTags[line] = lineDiv

    lineDiv.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @view.opts.textHeight - @fontAscent - @scrollOffsets.main.y}px"
    lineDiv.style.height =  treeView.bounds[line].height + 'px'
    lineDiv.style.fontSize = @fontSize + 'px'

    @lineNumberWrapper.appendChild lineDiv

  Editor::findLineNumberAtCoordinate = (coord) ->
    treeView = @view.getViewNodeFor @tree
    start = 0; end = treeView.bounds.length
    pivot = Math.floor (start + end) / 2

    while treeView.bounds[pivot].y isnt coord and start < end
      if start is pivot or end is pivot
        return pivot

      end = pivot if treeView.bounds[pivot].y > coord
      start = pivot if treeView.bounds[pivot].y < coord

      if end < 0 then return 0
      if start >= treeView.bounds.length then return treeView.bounds.length - 1

      pivot = Math.floor (start + end) / 2

    return pivot

  hook 'redraw_main', 0, (changedBox) ->
    treeView = @view.getViewNodeFor @tree

    top = @findLineNumberAtCoordinate @scrollOffsets.main.y
    bottom = @findLineNumberAtCoordinate @scrollOffsets.main.y + @mainCanvas.height

    for line in [top..bottom]
      @addLineNumberForLine line

    for line, tag of @lineNumberTags
      if line < top or line > bottom
        @lineNumberTags[line].parentNode.removeChild @lineNumberTags[line]
        delete @lineNumberTags[line]

    if changedBox
      @gutter.style.height = "#{Math.max @mainScroller.offsetHeight, treeView.totalBounds.height}px"

  hook 'resize', 0, ->
    @gutter.style.height = "#{Math.max @iceElement.offsetHeight, @view.getViewNodeFor(@tree).totalBounds?.height ? 0}px"

  Editor::setPaletteWidth = (width) ->
    @paletteWrapper.style.width = width + 'px'
    @resize()

  # COPY AND PASTE
  # ================================
  hook 'populate', 0, ->
    @copyPasteInput = document.createElement 'textarea'
    @copyPasteInput.style.position = 'absolute'
    @copyPasteInput.style.left = @copyPasteInput.style.top = '-9999px'

    @iceElement.appendChild @copyPasteInput

    @keyListener.register_combo
      keys: 'meta'
      on_keydown: =>
        unless @textFocus?
          @copyPasteInput.focus()
          if @lassoSegment?
            @copyPasteInput.value = @lassoSegment.stringify()
          @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length
      on_keyup: =>
        if @textFocus?
          @hiddenInput.focus()
        else
          @iceElement.focus()

    pressedVKey = false
    pressedXKey = false

    @copyPasteInput.addEventListener 'keydown', (event) ->
      if event.keyCode is 86
        pressedVKey = true
      else if event.keyCode is 88
        pressedXKey = true

    @copyPasteInput.addEventListener 'keyup', (event) ->
      if event.keyCode is 86
        pressedVKey = false
      else if event.keyCode is 88
        pressedXKey = false

    @copyPasteInput.addEventListener 'input', =>
      if pressedVKey
        try
          str = @copyPasteInput.value; minIndent = Infinity

          for line in str.split '\n'
            minIndent = Math.min minIndent, str.length - str.trimLeft().length

          str = (for line in str.split '\n'
            line[minIndent...]
          ).join '\n'

          str = str.replace /^\n*|\n*$/g, ''

          blocks = coffee.parse str

          @addMicroUndoOperation 'CAPTURE_POINT'
          if @lassoSegment?
            @addMicroUndoOperation new PickUpOperation @lassoSegment
            @lassoSegment.spliceOut(); @lassoSegment = null

          @addMicroUndoOperation new DropOperation blocks, @cursor.previousVisibleToken()

          blocks.spliceIn @cursor
          unless blocks.end.nextVisibleToken().type in ['newline', 'indentEnd']
            blocks.end.insert new model.NewlineToken()

          @addMicroUndoOperation new DestroySegmentOperation blocks

          blocks.unwrap()

          @redrawMain()

        @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length
      else if pressedXKey and @lassoSegment?
        @addMicroUndoOperation 'CAPTURE_POINT'
        @addMicroUndoOperation new PickUpOperation @lassoSegment
        @lassoSegment.spliceOut(); @lassoSegment = null
        @redrawMain()

  hook 'populate', 0, ->
    setTimeout (=>
      @cursor.parent = @tree
    ), 0

  # OVRFLOW BIT
  # ================================

  Editor::overflowsX = ->
    @documentDimensions().width > @viewportDimensions().width

  Editor::overflowsY = ->
    @documentDimensions().height > @viewportDimensions().height

  Editor::documentDimensions = ->
    bounds = @view.getViewNodeFor(@tree).totalBounds
    return {
      width: bounds.width
      height: bounds.height
    }

  Editor::viewportDimensions = ->
    return {
      width: @mainCanvas.width
      height: @mainCanvas.height
    }

  # DEBUG CODE
  # ================================
  Editor::dumpNodeForDebug = (hitTestResult, line) ->
    console.log('Model node:')
    console.log(hitTestResult.serialize())
    console.log('View node:')
    console.log(@view.getViewNodeFor(hitTestResult).serialize(line))

  # CLOSING FOUNDATIONAL STUFF
  # ================================

  # Order the arrays correctly.
  for key of unsortedEditorBindings
    unsortedEditorBindings[key].sort (a, b) -> if a.priority > b.priority then -1 else 1

    editorBindings[key] = []

    for binding in unsortedEditorBindings[key]
      editorBindings[key].push binding.fn

  editorBindings.key = {}

  for key of unsortedEditorKeyBindings
    unsortedEditorKeyBindings[key].sort (a, b) -> if a.priority > b.priority then -1 else 1

    editorBindings.key[key] = []

    for binding in unsortedEditorKeyBindings[key]
      editorBindings.key[key].push binding.fn

  return exports
