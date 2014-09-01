# # ICE Editor controller
#
# Copyright (c) 2014 Anthony Bau
# MIT License.

define ['droplet-helper',
    'droplet-coffee',
    'droplet-javascript',
    'droplet-draw',
    'droplet-model',
    'droplet-view'], (helper,
    coffee,
    javascript,
    draw,
    model,
    view) ->
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
  CURSOR_UNFOCUSED_OPACITY = 0.5
  DEBUG_FLAG = false

  ANY_DROP = helper.ANY_DROP
  BLOCK_ONLY = helper.BLOCK_ONLY
  MOSTLY_BLOCK = helper.MOSTLY_BLOCK
  MOSTLY_VALUE = helper.MOSTLY_VALUE
  VALUE_ONLY = helper.VALUE_ONLY

  BACKSPACE_KEY = 8
  TAB_KEY = 9
  ENTER_KEY = 13
  LEFT_ARROW_KEY = 37
  UP_ARROW_KEY = 38
  RIGHT_ARROW_KEY = 39
  DOWN_ARROW_KEY = 40
  Z_KEY = 90

  META_KEYS = [91, 92, 93, 223, 224]
  CONTROL_KEYS = [17, 162, 163]

  userAgent = ''
  if typeof(window) isnt 'undefined' and window.navigator?.userAgent
    userAgent = window.navigator.userAgent
  isOSX = /OS X/.test(userAgent)
  command_modifiers = if isOSX then META_KEYS else CONTROL_KEYS
  command_pressed = (e) -> if isOSX then e.metaKey else e.ctrlKey

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

    'keydown': []
    'keyup': []
  }

  editorBindings = {}

  # This hook function is for convenience,
  # for features to add events that will occur at
  # various times in the editor lifecycle.
  hook = (event, priority, fn) ->
    unsortedEditorBindings[event].push {
      priority: priority
      fn: fn
    }

  # ## The Editor Class
  exports.Editor = class Editor
    constructor: (@wrapperElement, @options) ->
      @paletteGroups = @options.palette

      if @options.mode is 'coffeescript'
        @mode = coffee
      else if @options.mode is 'javascript'
        @mode = javascript

      @draw = new draw.Draw()

      # ## DOM Population
      # This stage of ICE Editor construction populates the given wrapper
      # element with all the necessary ICE editor components.
      @debugging = true

      # ### Wrapper
      # Create the div that will contain all the ICE Editor graphics

      @dropletElement = document.createElement 'div'
      @dropletElement.className = 'droplet-wrapper-div'

      # We give our element a tabIndex so that it can be focused and capture keypresses.
      @dropletElement.tabIndex = 0

      # Append that div.
      @wrapperElement.appendChild @dropletElement

      @wrapperElement.style.backgroundColor = '#FFF'

      # ### Canvases
      # Create the palette and main canvases

      # Main canvas first
      @mainCanvas = document.createElement 'canvas'
      @mainCanvas.className = 'droplet-main-canvas'

      @mainCtx = @mainCanvas.getContext '2d'

      @dropletElement.appendChild @mainCanvas

      @paletteWrapper = @paletteElement = document.createElement 'div'
      @paletteWrapper.className = 'droplet-palette-wrapper'

      # Then palette canvas
      @paletteCanvas = document.createElement 'canvas'
      @paletteCanvas.className = 'droplet-palette-canvas'

      @paletteCtx = @paletteCanvas.getContext '2d'

      @paletteWrapper.appendChild @paletteCanvas

      @paletteElement.style.position = 'absolute'
      @paletteElement.style.left = '0px'
      @paletteElement.style.top = '0px'
      @paletteElement.style.bottom = '0px'
      @paletteElement.style.width = '270px'

      @dropletElement.style.left = @paletteElement.offsetWidth + 'px'

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

      boundListeners = []

      # Call all the feature bindings that are supposed
      # to happen now.
      for binding in editorBindings.populate
        binding.call this

      # ## Resize
      # This stage of ICE editor construction, which is repeated
      # whenever the editor is resized, should adjust the sizes
      # of all the ICE editor componenents to fit the wrapper.
      window.addEventListener 'resize', => @resizeBlockMode()

      # ## Tracker Events
      # We allow binding to the tracker element.
      dispatchMouseEvent = (event) =>
        # ignore mouse clicks that are not the left-button
        if event.type isnt 'mousemove' and event.which isnt 1 then return

        trackPoint = new @draw.Point(event.pageX, event.pageY)

        # We keep a state object so that handlers
        # can know about each other.
        state = {}

        # Call all the handlers.
        for handler in editorBindings[event.type]
          handler.call this, trackPoint, event, state

        # Stop event propagation so that
        # we don't get bad selections
        event.stopPropagation?()
        event.preventDefault?()

        event.cancelBubble = true
        event.returnValue = false

        return false

      dispatchKeyEvent = (event) =>
        # We keep a state object so that handlers
        # can know about each other.
        state = {}

        # Call all the handlers.
        for handler in editorBindings[event.type]
          handler.call this, event, state

      for eventName, elements of {
          keydown: [@dropletElement, @paletteElement]
          keyup: [@dropletElement, @paletteElement]
          mousedown: [@dropletElement, @paletteElement, @dragCover]
          dblclick: [@dropletElement, @paletteElement, @dragCover]
          mouseup: [window]
          mousemove: [window] } then do (eventName, elements) =>
        for element in elements
          if /^key/.test eventName
            element.addEventListener eventName, dispatchKeyEvent
          else
            element.addEventListener eventName, dispatchMouseEvent

      # ## Document initialization
      # We start of with an empty document
      @tree = new model.Segment()
      @tree.start.insert @cursor

      @resizeBlockMode()

      # Now that we've populated everything, immediately re@draw.
      @redrawMain(); @redrawPalette()

      return this

    # ## Foundational Resize
    # At the editor core, we will need to resize
    # all of the natively-added canvases, as well
    # as the wrapper element, whenever a resize
    # occurs.
    resizeTextMode: ->
      @resizeAceElement()
      @aceEditor.resize true

    resizeBlockMode: ->
      @resizeTextMode()
      @resizeGutter()

      @dropletElement.style.left = "#{@paletteElement.offsetWidth}px"
      @dropletElement.style.height = "#{@wrapperElement.offsetHeight}px"
      @dropletElement.style.width ="#{@wrapperElement.offsetWidth - @paletteWrapper.offsetWidth}px"

      @mainCanvas.height = @dropletElement.offsetHeight
      @mainCanvas.width = @dropletElement.offsetWidth - @gutter.offsetWidth

      @mainCanvas.style.height = "#{@mainCanvas.height}px"
      @mainCanvas.style.width = "#{@mainCanvas.width}px"
      @mainCanvas.style.left = "#{@gutter.offsetWidth}px"
      @transitionContainer.style.left = "#{@gutter.offsetWidth}px"

      @resizePalette()
      @resizePaletteHighlight()
      @resizeNubby()
      @resizeMainScroller()
      @resizeLassoCanvas()
      @resizeCursorCanvas()
      @resizeDragCanvas()

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

  Editor::resize = ->
    if @currentlyUsingBlocks
      @resizeBlockMode()
    else
      @resizeTextMode()


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

  Editor::resizeNubby = ->
    @setTopNubbyStyle @nubbyHeight, @nubbyColor

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
        @suppressAceChangeEvent = true
        oldScroll = @aceEditor.session.getScrollTop()
        @setAceValue @getValue()
        @suppressAceChangeEvent = false
        @aceEditor.session.setScrollTop oldScroll

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

  Editor::absoluteOffset = (el) ->
    point = new @draw.Point el.offsetLeft, el.offsetTop
    el = el.offsetParent

    until el is document.body or not el?
      point.x += el.offsetLeft - el.scrollLeft
      point.y += el.offsetTop - el.scrollTop

      el = el.offsetParent

    return point

  # ### Conversion functions
  # Convert a point relative to the page into
  # a point relative to one of the two canvases.
  Editor::trackerPointToMain = (point) ->
    if not @mainCanvas.offsetParent?
      return new @draw.Point(NaN, NaN)
    gbr = @mainCanvas.getBoundingClientRect()
    new @draw.Point(point.x - gbr.left + @scrollOffsets.main.x,
                    point.y - gbr.top + @scrollOffsets.main.y)

  Editor::trackerPointToPalette = (point) ->
    if not @paletteCanvas.offsetParent?
      return new @draw.Point(NaN, NaN)
    gbr = @paletteCanvas.getBoundingClientRect()
    new @draw.Point(point.x - gbr.left + @scrollOffsets.palette.x,
                    point.y - gbr.top + @scrollOffsets.palette.y)

  Editor::trackerPointIsInMain = (point) ->
    if not @mainCanvas.offsetParent?
      return false
    gbr = @mainCanvas.getBoundingClientRect()
    return point.x >= gbr.left and point.x < gbr.right and
           point.y >= gbr.top and point.y < gbr.bottom

  Editor::trackerPointIsInMainScroller = (point) ->
    if not @mainScroller.offsetParent?
      return false
    gbr = @mainScroller.getBoundingClientRect()
    return point.x >= gbr.left and point.x < gbr.right and
           point.y >= gbr.top and point.y < gbr.bottom

  Editor::trackerPointIsInPalette = (point) ->
    if not @paletteCanvas.offsetParent?
      return false
    gbr = @paletteCanvas.getBoundingClientRect()
    return point.x >= gbr.left and point.x < gbr.right and
           point.y >= gbr.top and point.y < gbr.bottom

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
    @dropletElement.focus()

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
  hook 'keydown', 0, (event, state) ->
    if event.which is Z_KEY and command_pressed(event)
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
      @spliceIn (clone = @block.clone()), editor.tree.getTokenAtLocation @before

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
        @spliceOut blockStart.container

      else
        @spliceOut blockStart.container

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
      @spliceOut blockStart.container

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
      editor.spliceIn (clone = @block.clone()), editor.tree.getTokenAtLocation @dest

      # Move the cursor to the end of it.
      return clone.end

  Editor::spliceOut = (node) ->
    leading = node.getLeadingText()
    trailing = node.getTrailingText()

    [leading, trailing] = @mode.parens leading, trailing, node, null

    node.setLeadingText leading; node.setTrailingText trailing

    node.spliceOut()

  Editor::spliceIn = (node, location) ->
    leading = node.getLeadingText()
    trailing = node.getTrailingText()

    [leading, trailing] = @mode.parens leading, trailing, node, (location.container ? location.parent)

    node.setLeadingText leading; node.setTrailingText trailing

    node.spliceIn location

  # At population-time, we will
  # want to set up a few fields.
  hook 'populate', 0, ->
    @clickedPoint = null
    @clickedBlock = null
    @clickedBlockIsPaletteBlock = false

    @draggingBlock = null
    @draggingOffset = null

    @lastHighlight = null

    # We will also have to initialize the
    # drag canvas.
    @dragCanvas = document.createElement 'canvas'
    @dragCanvas.className = 'droplet-drag-canvas'

    @dragCanvas.style.left = '-9999px'
    @dragCanvas.style.top = '-9999px'

    @dragCtx = @dragCanvas.getContext '2d'

    # And the canvas for drawing highlights
    @highlightCanvas = document.createElement 'canvas'
    @highlightCanvas.className = 'droplet-highlight-canvas'

    @highlightCtx = @highlightCanvas.getContext '2d'

    # We append it to the tracker element,
    # so that it can appear in front of the scrollers.
    #@dropletElement.appendChild @dragCanvas
    document.body.appendChild @dragCanvas
    @dropletElement.appendChild @highlightCanvas

  Editor::clearHighlightCanvas = ->
    @highlightCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @highlightCanvas.width, @highlightCanvas.height

  # Utility function for clearing the drag canvas,
  # an operation we will be doing a lot.
  Editor::clearDrag = ->
    @dragCtx.clearRect 0, 0, @dragCanvas.width, @dragCanvas.height

  # On resize, we will want to size the drag canvas correctly.
  Editor::resizeDragCanvas = ->
    @dragCanvas.width = 0
    @dragCanvas.height = 0

    @highlightCanvas.width = @dropletElement.offsetWidth
    @highlightCanvas.style.width = "#{@highlightCanvas.width}px"

    @highlightCanvas.height = @dropletElement.offsetHeight
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

    # If it's not in the main pane, pass.
    if not @trackerPointIsInMain(point) then return

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
    if hitTestResult?
      # Record the hit test result (the block we want to pick up)
      @clickedBlock = hitTestResult
      @clickedBlockIsPaletteBlock = false

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

      else
        # Find the line on the block that we have
        # actually clicked, and attempt to translate the block
        # so that if it re-shapes, we're still touching it.
        #
        # To do this, we will assume that the left edge of a free
        # block are all aligned.
        mainPoint = @trackerPointToMain @clickedPoint
        viewNode = @view.getViewNodeFor @draggingBlock

        @draggingOffset = null

        for bound, line in viewNode.bounds
          if bound.contains mainPoint
            @draggingOffset = bound.upperLeftCorner().from mainPoint
            @draggingOffset.y += viewNode.bounds[0].y - bound.y
            break

        unless @draggingOffset?
          @draggingOffset = viewNode.bounds[0].upperLeftCorner().from mainPoint

      @draggingBlock.ephemeral = true
      @draggingBlock.clearLineMarks()

      # Draw the new dragging block on the drag canvas.
      #
      # When we are dragging things, we draw the shadow.
      # Also, we translate the block 1x1 to the right,
      # so that we can see its borders.
      draggingBlockView = @dragView.getViewNodeFor @draggingBlock
      draggingBlockView.layout 1, 1

      @dragCanvas.width = Math.min draggingBlockView.totalBounds.width + 10, window.screen.width
      @dragCanvas.height = Math.min draggingBlockView.totalBounds.height + 10, window.screen.height

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

      @dragCanvas.style.top = "#{position.y + getOffsetTop(@dropletElement)}px"
      @dragCanvas.style.left = "#{position.x + getOffsetLeft(@dropletElement)}px"

      # Now we are done with the "clickedX" suite of stuff.
      @clickedPoint = @clickedBlock = null
      @clickedBlockIsPaletteBlock = false

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

      @dragCanvas.style.top = "#{position.y}px"
      @dragCanvas.style.left = "#{position.x}px"

      mainPoint = @trackerPointToMain(position)

      best = null; min = Infinity

      # Check to see if the tree is empty;
      # if it is, drop on the tree always
      head = @tree.start.next
      while head.type in ['newline', 'cursor'] or head.type is 'text' and head.value is ''
        head = head.next

      if head is @tree.end and
          @mainCanvas.width + @scrollOffsets.main.x > mainPoint.x > @scrollOffsets.main.x - @gutter.offsetWidth and
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
          unless (point.acceptLevel is helper.DISCOURAGED) and not event.shiftKey
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
        @spliceOut @draggingBlock

      @clearHighlightCanvas()

      # Depending on what the highlighted element is,
      # we might want to drop the block at its
      # beginning or at its end.
      #
      # We will need to log undo operations here too.
      switch @lastHighlight.type
        when 'indent', 'socket'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.start
          @spliceIn @draggingBlock, @lastHighlight.start #MUTATION
        when 'block'
          @addMicroUndoOperation new DropOperation @draggingBlock, @lastHighlight.end
          @spliceIn @draggingBlock, @lastHighlight.end #MUTATION
        else
          if @lastHighlight is @tree
            @addMicroUndoOperation new DropOperation @draggingBlock, @tree.start
            @spliceIn @draggingBlock, @tree.start #MUTATION

      # Move the cursor to the position we just
      # dropped the block
      @moveCursorTo @draggingBlock.end, true

      # Reparse the parent if we are
      # in a socket
      #
      # TODO "reparseable" property, bubble up
      # TODO performance on large programs
      if @lastHighlight.type is 'socket'
        @reparseRawReplace @draggingBlock.parent.parent

      # Now that we've done that, we can annul stuff.
      @endDrag()

  Editor::reparseRawReplace = (oldBlock) ->
    try
      newParse = @mode.parse(oldBlock.stringify(@mode.empty), wrapAtRoot: true)
      newBlock = newParse.start.next.container
      if newParse.start.next.container.end is newParse.end.prev and
          newBlock?.type is 'block'
        @addMicroUndoOperation new ReparseOperation oldBlock, newBlock

        if @cursor.hasParent oldBlock
          pos = @getRecoverableCursorPosition()
          newBlock.rawReplace oldBlock
          @recoverCursorPosition pos
        else
          newBlock.rawReplace oldBlock

    catch e
      throw e
      return false

  Editor::findForReal = (token) ->
    head = @tree.start; i = 0
    until head is token or head is @tree.end or not head?
      head = head.next; i++
    if head is token
      return i
    else
      return null

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
    if block.container? then block = block.container

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
        @spliceOut @draggingBlock

      # If we dropped it off in the palette, abort (so as to delete the block).
      palettePoint = @trackerPointToPalette point
      if 0 < palettePoint.x - @scrollOffsets.palette.x < @paletteCanvas.width and
         0 < palettePoint.y - @scrollOffsets.palette.y < @paletteCanvas.height or not
         (-@gutter.offsetWidth < renderPoint.x - @scrollOffsets.main.x < @mainCanvas.width and
         0 < renderPoint.y - @scrollOffsets.main.y< @mainCanvas.height)
        if @draggingBlock is @lassoSegment
          @lassoSegment = null

        @endDrag()
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

    # If it's not in the main pane, pass.
    if not @trackerPointIsInMain(point) then return

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
    # Create the hierarchical menu element.
    @paletteHeader = document.createElement 'div'
    @paletteHeader.className = 'droplet-palette-header'

    # Append the element.
    @paletteWrapper.appendChild @paletteHeader

    @setPalette @paletteGroups

  Editor::setPalette = (paletteGroups) ->
    @paletteHeader.innerHTML = ''
    @paletteGroups = paletteGroups

    @currentPaletteBlocks = []
    @currentPaletteMetadata = []

    paletteHeaderRow = null

    for paletteGroup, i in @paletteGroups then do (paletteGroup, i) =>
      # Start a new row, if we're at that point
      # in our appending cycle
      if i % 2 is 0
        paletteHeaderRow = document.createElement 'div'
        paletteHeaderRow.className = 'droplet-palette-header-row'
        @paletteHeader.appendChild paletteHeaderRow

      # Create the element itself
      paletteGroupHeader = document.createElement 'div'
      paletteGroupHeader.className = 'droplet-palette-group-header'
      paletteGroupHeader.innerText = paletteGroupHeader.textContent = paletteGroupHeader.textContent = paletteGroup.name # innerText and textContent for FF compatability
      if paletteGroup.color
        paletteGroupHeader.className += ' ' + paletteGroup.color

      paletteHeaderRow.appendChild paletteGroupHeader

      newPaletteBlocks = []

      # Parse all the blocks in this palette and clone them
      for data in paletteGroup.blocks
        newBlock = @mode.parse(data.block).start.next.container
        newBlock.spliceOut(); newBlock.parent = null
        newPaletteBlocks.push {
          block: newBlock
          title: data.title
        }

      paletteGroupBlocks = newPaletteBlocks

      # When we click this element,
      # we should switch to it in the palette.
      updatePalette = =>
        # Record that we are the selected group now
        @currentPaletteGroup = paletteGroup.name
        @currentPaletteBlocks = paletteGroupBlocks.map (x) -> x.block
        @currentPaletteMetadata = paletteGroupBlocks

        # Unapply the "selected" style to the current palette group header
        @currentPaletteGroupHeader?.className =
            @currentPaletteGroupHeader.className.replace(
                /\s[-\w]*-selected\b/, '')

        # Now we are the current palette group header
        @currentPaletteGroupHeader = paletteGroupHeader
        @currentPaletteIndex = i

        # Apply the "selected" style to us
        @currentPaletteGroupHeader.className +=
            ' droplet-palette-group-header-selected'

        # Redraw the palette.
        @redrawPalette()

      clickHandler = =>
        do updatePalette
        for event in editorBindings.set_palette
          event.call this

      paletteGroupHeader.addEventListener 'click', clickHandler
      paletteGroupHeader.addEventListener 'touchstart', clickHandler

      # If we are the first element, make us the selected palette group.
      if i is 0
        do updatePalette

    @resizePalette()

  # The next thing we need to do with the palette
  # is let people pick things up from it.
  hook 'mousedown', 6, (point, event, state) ->
    # If someone else has already taken this click, pass.
    if state.consumedHitTest then return

    # If it's not in the palette pane, pass.
    if not @trackerPointIsInPalette(point) then return

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
    @paletteHighlightCanvas.className = 'droplet-palette-highlight-canvas'
    @paletteHighlightCtx = @paletteHighlightCanvas.getContext '2d'

    @paletteHighlightPath = null
    @currentHighlightedPaletteBlock = null

    @paletteWrapper.appendChild @paletteHighlightCanvas

  Editor::resizePaletteHighlight = ->
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
      hoverDiv.className = 'droplet-hover-div'

      hoverDiv.title = data.title ? block.stringify(@mode.empty)

      bounds = @view.getViewNodeFor(block).totalBounds

      hoverDiv.style.top = "#{bounds.y}px"
      hoverDiv.style.left = "#{bounds.x}px"

      # Clip boxes to the width of the palette to prevent x-scrolling. TODO: fix x-scrolling behaviour.
      hoverDiv.style.width = "#{Math.min(bounds.width, Infinity)}px"
      hoverDiv.style.height = "#{bounds.height}px"

      do (block) =>
        hoverDiv.addEventListener 'mousemove', (event) =>
          palettePoint = @trackerPointToPalette new @draw.Point(
              event.pageX, event.pageY)
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
    constructor: (socket, @before, editor) ->
      @after = socket.stringify(editor.mode.empty)
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
      editor.spliceOut socket.start.next.container
      socket.start.insert new model.TextToken @before

    redo: (editor) ->
      socket = editor.tree.getTokenAtLocation(@socket).container
      socket.start.append socket.end; socket.notifyChange()
      editor.spliceIn @after.clone(), socket

  # At populate-time, we need
  # to create and append the hidden input
  # we will use for text input.
  hook 'populate', 1, ->
    @hiddenInput = document.createElement 'textarea'
    @hiddenInput.className = 'droplet-hidden-input'

    @dropletElement.appendChild @hiddenInput

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

  Editor::resizeAceElement = ->
    @aceElement.style.width = "#{@wrapperElement.offsetWidth}px"
    @aceElement.style.height = "#{@wrapperElement.offsetHeight}px"

  last_ = (array) -> array[array.length - 1]

  # Redraw function for text input
  Editor::redrawTextInput = ->
    sameLength = @textFocus.stringify(@mode.empty).split('\n').length is @hiddenInput.value.split('\n').length

    # Set the value in the model to fit
    # the hidden input value.
    @populateSocket @textFocus, @hiddenInput.value

    textFocusView = @view.getViewNodeFor @textFocus

    # Determine the coordinate positions
    # of the typing cursor
    startRow = @textFocus.stringify(@mode.empty)[...@hiddenInput.selectionStart].split('\n').length - 1
    endRow = @textFocus.stringify(@mode.empty)[...@hiddenInput.selectionEnd].split('\n').length - 1

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
    startRow = @textFocus.stringify(@mode.empty)[...@hiddenInput.selectionStart].split('\n').length - 1
    endRow = @textFocus.stringify(@mode.empty)[...@hiddenInput.selectionEnd].split('\n').length - 1

    lines = @textFocus.stringify(@mode.empty).split '\n'

    startPosition = textFocusView.bounds[startRow].x + @view.opts.textPadding +
      @mainCtx.measureText(last_(@textFocus.stringify(@mode.empty)[...@hiddenInput.selectionStart].split('\n'))).width

    endPosition = textFocusView.bounds[endRow].x + @view.opts.textPadding +
      @mainCtx.measureText(last_(@textFocus.stringify(@mode.empty)[...@hiddenInput.selectionEnd].split('\n'))).width

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
  Editor::setTextInputFocus = (focus, selectionStart = null, selectionEnd = null) ->
    if focus?.id of @extraMarks
      delete @extraMarks[focus?.id]

    # If there is already a focus, we
    # need to wrap some things up with it.
    if @textFocus? and @textFocus isnt focus

      # The first of these is an undo operation;
      # we need to add this text change to the undo stack.
      @addMicroUndoOperation 'CAPTURE_POINT'
      @addMicroUndoOperation new TextChangeOperation @textFocus, @oldFocusValue, @
      @oldFocusValue = null

      originalText = @textFocus.stringify(@mode.empty)
      shouldPop = false
      shouldRecoverCursor = false
      cursorPosition = cursorParent = null

      if @cursor.hasParent @textFocus.parent
        shouldRecoverCursor = true
        cursorPosition = @getRecoverableCursorPosition()

      # The second of these is a reparse attempt.
      # If we can, try to reparse the focus
      # value.
      unless @textFocus.handwritten
        newParse = null
        string = @textFocus.stringify(@mode.empty).trim()
        try
          newParse = @mode.parse(unparsedValue = string, wrapAtRoot: false)
        catch
          if string[0] is string[string.length - 1] and string[0] in ['"', '\'']
            try
              string = escapeString string
              newParse = @mode.parse(unparsedValue = string, wrapAtRoot: false)
              @populateSocket @textFocus, string

        if newParse? and newParse.start.next.type is 'blockStart' and
            newParse.start.next.container.end.next is newParse.end
          # Empty the socket
          @textFocus.start.append @textFocus.end

          # Splice the other in
          @spliceIn newParse.start.next.container, @textFocus.start

          @addMicroUndoOperation new TextReparseOperation @textFocus, unparsedValue
          shouldPop = true

      # TODO make 'reparsable' property, bubble up until then
      unless @reparseRawReplace @textFocus.parent
        # If we can't reparse the parent, abort all reparses
        @populateSocket @textFocus, originalText

        if shouldPop then @undoStack.pop()

        #@extraMarks[@textFocus.id] =
        #  model: @textFocus
        #  style: {color: '#F00'}

        @redrawMain()

    if shouldRecoverCursor
      @recoverCursorPosition cursorPosition

    # Now we're done with the old focus,
    # we can start over.
    # If we're _unfocusing_, just do so.
    if not focus?
      @textFocus = null
      @redrawMain()
      @hiddenInput.blur()
      @dropletElement.focus()
      return

    # Record old focus value
    @oldFocusValue = focus.stringify(@mode.empty)

    # Now create a text token
    # with the appropriate text to put in it.
    @textFocus = focus

    # Immediately rerender.
    @populateSocket focus, focus.stringify(@mode.empty)

    @textFocus.notifyChange()

    # Move the cursor near this
    @moveCursorTo focus.end

    # Set the hidden input up to mirror the text.
    @hiddenInput.value = @textFocus.stringify(@mode.empty)

    if selectionStart? and not selectionEnd?
      selectionEnd = selectionStart

    # Focus the hidden input.
    if @textFocus?
      @hiddenInput.focus()
      if selectionStart? and selectionEnd?
        @hiddenInput.setSelectionRange selectionStart, selectionEnd
      else if @hiddenInput.value[0] is @hiddenInput.value[@hiddenInput.value.length - 1] and
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

    lines = @textFocus.stringify(@mode.empty).split('\n')[..row]
    lines[lines.length - 1] = lines[lines.length - 1][...column]

    return lines.join('\n').length

  Editor::setTextInputAnchor = (point) ->
    @textInputAnchor = @textInputHead = @getTextPosition point
    @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

  Editor::selectDoubleClick = (point) ->
    position = @getTextPosition point

    before = @textFocus.stringify(@mode.empty)[...position].match(/\w*$/)[0]?.length ? 0
    after = @textFocus.stringify(@mode.empty)[position..].match(/^\w*/)[0]?.length ? 0

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
      @hiddenInput.focus()

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
    @lassoSelectCanvas.className = 'droplet-lasso-select-canvas'

    @lassoSelectCtx = @lassoSelectCanvas.getContext '2d'

    @lassoSelectAnchor = null
    @lassoSegment = null

    @dropletElement.appendChild @lassoSelectCanvas

  # Conveneince function for clearing
  # the lasso select canvas
  Editor::clearLassoSelectCanvas = ->
    @lassoSelectCtx.clearRect 0, 0, @lassoSelectCanvas.width, @lassoSelectCanvas.height

  # Deal with resize for the lasso
  # select canvas
  Editor::resizeLassoCanvas = ->
    @lassoSelectCanvas.width = @dropletElement.offsetWidth
    @lassoSelectCanvas.style.width = "#{@lassoSelectCanvas.width}px"

    @lassoSelectCanvas.height = @dropletElement.offsetHeight
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

    # If it's not in the main pane, pass.
    if not @trackerPointIsInMain(point) then return
    if @trackerPointIsInPalette(point) then return

    # If the point was actually in the main canvas,
    # start a lasso select.
    mainPoint = @trackerPointToMain(point).from @scrollOffsets.main
    palettePoint = @trackerPointToPalette(point).from @scrollOffsets.palette

    @lassoSelectAnchor = @trackerPointToMain point

  # On mousemove, if we are in the middle of a
  # lasso select, continue with it.
  hook 'mousemove', 0, (point, event, state) ->
    if @lassoSelectAnchor?
      mainPoint = @trackerPointToMain point

      @clearLassoSelectCanvas()

      lassoRectangle = new @draw.Rectangle(
        Math.min(@lassoSelectAnchor.x, mainPoint.x),
        Math.min(@lassoSelectAnchor.y, mainPoint.y),
        Math.abs(@lassoSelectAnchor.x - mainPoint.x),
        Math.abs(@lassoSelectAnchor.y - mainPoint.y)
      )

      first = @tree.start
      until (not first?) or first.type is 'blockStart' and @view.getViewNodeFor(first.container).path.intersects lassoRectangle
        first = first.next

      last = @tree.end
      until (not last?) or last.type is 'blockEnd' and @view.getViewNodeFor(last.container).path.intersects lassoRectangle
        last = last.prev

      @clearLassoSelectCanvas(); @clearHighlightCanvas()

      @lassoSelectCtx.strokeStyle = '#00f'
      @lassoSelectCtx.strokeRect lassoRectangle.x - @scrollOffsets.main.x,
        lassoRectangle.y - @scrollOffsets.main.y,
        lassoRectangle.width,
        lassoRectangle.height

      if first and last?
        [first, last] = validateLassoSelection @tree, first, last
        @drawTemporaryLasso first, last


  Editor::drawTemporaryLasso = (first, last) ->
    mainCanvasRectangle = new @draw.Rectangle(
      @scrollOffsets.main.x,
      @scrollOffsets.main.y,
      @mainCanvas.width,
      @mainCanvas.height
    )
    head = first
    until head is last
      if head instanceof model.StartToken
        @view.getViewNodeFor(head.container).draw @highlightCtx, mainCanvasRectangle, {selected: Infinity}
        head = head.container.end
      else
        head = head.next

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
      @moveCursorTo @lassoSegment.end.nextVisibleToken(), true

      @redrawMain()

  # On mousedown, we might want to
  # pick a selected segment up; check.
  hook 'mousedown', 3, (point, event, state) ->
    if state.consumedHitTest then return

    if @lassoSegment? and @hitTest(@trackerPointToMain(point), @lassoSegment)?
      @clickedBlock = @lassoSegment
      @clickedBlockIsPaletteBlock = false
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
    @redrawMain()

    # If the destination is not inside the tree,
    # abort.
    unless destination?
      if DEBUG_FLAG
        throw new Error 'Cannot move cursor to null'
      return null
    unless @inTree(destination)
      if DEBUG_FLAG
        throw new Error 'Cannot move cursor to a place not in the main tree'
      return null

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

    @redrawHighlights()

  Editor::moveCursorUp = ->
    unless @cursor.prev? then return
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

    @redrawHighlights()
    @scrollCursorIntoPosition()

  Editor::getRecoverableCursorPosition = ->
    pos = {
      lines: 0
      indents: 0
    }
    head = @cursor
    until head.type is 'newline' or head is @tree.start
      if head.type is 'indentEnd' then pos.indents++
      head = head.prev
    until head is @tree.start
      if head.type is 'newline' then pos.lines++
      head = head.prev

    return pos

  getAtChar = (parent, chars) ->
    head = parent.start
    charsCounted = 0

    until charsCounted >= chars
      if head.type is 'text' then charsCounted += head.value.length

      head = head.next

    return head

  Editor::recoverCursorPosition = (pos) ->
    head = @tree.start
    testPos = {
      lines: 0
      indents: 0
    }
    until head is @tree.end or testPos.lines is pos.lines
      head = head.next
      if head.type is 'newline' then testPos.lines++

    until head is @tree.end or testPos.indents is pos.indents
      head = head.next
      if head.type is 'indentEnd' then testPos.indents++

    @cursor.remove()
    if head.type is 'newline' then head.insert @cursor
    else head.insertBefore @cursor

  Editor::moveCursorHorizontally = (direction) ->
    if @textFocus?
      if direction is 'right'
        head = @textFocus.end.next
      else
        head = @textFocus.start.prev
    else unless (@cursor.prev is @tree.start and direction is 'left' or
        @cursor.next is @tree.end and direction is 'right')
      if direction is 'right'
        head = @cursor.next.next
      else
        head = @cursor.prev.prev
    else
      return

    while true
      if head.type in ['newline', 'indentEnd'] or head.container is @tree
        @cursor.remove()
        if head is @tree.start or head.type is 'newline' then head.insert @cursor
        else head.insertBefore @cursor
        @setTextInputFocus null
        unless @inTree(@cursor) then debugger
        if isValidCursorPosition @cursor
          break

      if head.type is 'socketStart' and
          (head.next.type is 'text' or head.next is head.container.end)
        # Avoid problems with reparses
        if @textFocus? and head.container.hasParent @textFocus.parent
          persistentParent = @textFocus.getCommonParent(head.container).parent

          chars = getCharactersTo persistentParent, head.container.start
          @setTextInputFocus null
          socket = getSocketAtChar persistentParent, chars
        else
          socket = head.container
          @setTextInputFocus null

        position = (if direction is 'right' then 0 else -1)
        @setTextInputFocus socket, position, position
        break

      if direction is 'right' then head = head.next
      else head = head.prev

    @redrawMain()

  hook 'keydown', 0, (event, state) ->
    if event.which isnt RIGHT_ARROW_KEY then return
    if not @textFocus? or
        @hiddenInput.selectionStart is @hiddenInput.value.length
      @moveCursorHorizontally 'right'
      event.preventDefault()

  hook 'keydown', 0, (event, state) ->
    if event.which isnt LEFT_ARROW_KEY then return
    if not @textFocus? or
        @hiddenInput.selectionEnd is 0
      @moveCursorHorizontally 'left'
      event.preventDefault()

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
  hook 'keydown', 0, (event, state) ->
    if event.which isnt UP_ARROW_KEY then return
    @clearLassoSelection()
    @setTextInputFocus null
    @moveCursorUp()

  # Pressing the down-arrow moves the cursor down.
  hook 'keydown', 0, (event, state) ->
    if event.which isnt DOWN_ARROW_KEY then return
    unless @textFocus?
      @moveCursorTo @cursor.next.next
    @clearLassoSelection()
    @setTextInputFocus null
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

  hook 'keydown', 0, (event, state) ->
    if event.which isnt TAB_KEY then return
    if event.shiftKey
      if @textFocus? then head = @textFocus.start
      else head = @cursor

      until (not head?) or head.type is 'socketEnd' and
          (head.container.start.next.type is 'text' or head.container.start.next is head.container.end)
        head = head.prev

      if head?
        if @textFocus? and head.container.hasParent @textFocus.parent
          persistentParent = @textFocus.getCommonParent(head.container).parent

          chars = getCharactersTo persistentParent, head.container.start
          @setTextInputFocus null
          socket = getSocketAtChar persistentParent, chars
        else
          socket = head.container
          @setTextInputFocus null

        @setTextInputFocus socket
      event.preventDefault()

    else
      if @textFocus? then head = @textFocus.end
      else head = @cursor

      until (not head?) or head.type is 'socketStart' and
          (head.container.start.next.type is 'text' or head.container.start.next is head.container.end)
        head = head.next
      if head?
        if @textFocus? and head.container.hasParent @textFocus.parent
          persistentParent = @textFocus.getCommonParent(head.container).parent

          chars = getCharactersTo persistentParent, head.container.start
          @setTextInputFocus null
          socket = getSocketAtChar persistentParent, chars
        else
          socket = head.container
          @setTextInputFocus null

        @setTextInputFocus socket
      event.preventDefault()

  Editor::deleteAtCursor = ->
    # Unfocus any inputs, which could get in the way.
    @setTextInputFocus null

    blockEnd = @cursor.prev

    until blockEnd?.type in ['blockEnd', 'indentStart', undefined]
      blockEnd = blockEnd.prev

    unless blockEnd? then return

    if blockEnd.type is 'blockEnd'
      @addMicroUndoOperation new PickUpOperation blockEnd.container

      @spliceOut blockEnd.container

      @redrawMain()

  hook 'keydown', 0, (event, state) ->
    if event.which isnt BACKSPACE_KEY
      return
    if state.capturedBackspace
      return

    # We don't want to interrupt any text input editing
    # sessions. We will, however, delete a handwritten
    # block if it is currently empty.
    if @lassoSegment?
      @addMicroUndoOperation 'CAPTURE_POINT'
      @deleteLassoSegment()
      event.preventDefault()
      return false

    else if not @textFocus? or
        (@hiddenInput.value.length is 0 and @textFocus.handwritten)
      @addMicroUndoOperation 'CAPTURE_POINT'
      @deleteAtCursor()
      state.capturedBackspace = true
      event.preventDefault()
      return false

    return true

  Editor::deleteLassoSegment = ->
    unless @lassoSegment?
      if DEBUG_FLAG
        throw new Error 'Cannot delete nonexistent lasso segment'
      return null

    @addMicroUndoOperation new PickUpOperation @lassoSegment

    @spliceOut @lassoSegment
    @lassoSegment = null

    @redrawMain()

  # HANDWRITTEN BLOCK SUPPORT
  # ================================

  hook 'populate', 0, ->
    @handwrittenBlocks = []

  hook 'keydown', 0, (event, state) ->
    if event.which is ENTER_KEY
      if not @textFocus? and not event.shiftKey
        @setTextInputFocus null

        # Construct the block; flag the socket as handwritten
        newBlock = new model.Block(); newSocket = new model.Socket -Infinity
        @spliceIn newSocket, newBlock.start
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

        @spliceIn newBlock, head #MUTATION

        @redrawMain()

        @newHandwrittenSocket = newSocket

      else if @textFocus? and not event.shiftKey
        @setTextInputFocus null; @redrawMain()

  hook 'keyup', 0, (point, event, state) ->
    # prevents routing the initial enter keypress to a new handwritten
    # block by focusing the block only after the enter key is released.
    if event.which is ENTER_KEY
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
      newBlock.rawReplace block

    redo: (editor) ->
      block = editor.tree.getTokenAtLocation(@location).container
      newBlock = @after.clone()
      newBlock.rawReplace block

      newBlock.notifyChange()

  # ANIMATION AND ACE EDITOR SUPPORT
  # ================================

  Editor::copyAceEditor = ->
    clearTimeout @changeFromAceTimer
    @changeFromAceTimer = null
    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'
    @resizeBlockMode()
    return @setValue_raw @getAceValue()

  Editor::changeFromAceEditor = ->
    if @changeFromAceTimer then return
    @changeFromAceTimer = setTimeout (=>
      @copyAceEditor()
    ), 0

  hook 'populate', 0, ->
    @aceElement = document.createElement 'div'
    @aceElement.className = 'droplet-ace'

    @wrapperElement.appendChild @aceElement

    @aceEditor = ace.edit @aceElement

    @aceEditor.setTheme 'ace/theme/chrome'
    @aceEditor.setFontSize 15
    @aceEditor.getSession().setMode 'ace/mode/coffee'
    @aceEditor.getSession().setTabSize 2

    @aceEditor.on 'change', =>
      if @suppressAceChangeEvent then return
      if @currentlyUsingBlocks
        @changeFromAceEditor()
      else
        @fireEvent 'change', []

    @currentlyUsingBlocks = true
    @currentlyAnimating = false

    @transitionContainer = document.createElement 'div'
    @transitionContainer.className = 'droplet-transition-container'

    @dropletElement.appendChild @transitionContainer

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

      @setAceValue @getValue()

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
      @dropletElement.style.width = @wrapperElement.offsetWidth + 'px'

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

        div.innerText = div.textContent = textElement.model.value

        div.style.font = @fontSize + 'px ' + @fontFamily

        div.style.left = "#{textElement.bounds[0].x - @scrollOffsets.main.x}px"
        div.style.top = "#{textElement.bounds[0].y - @scrollOffsets.main.y - @fontAscent}px"

        div.className = 'droplet-transitioning-element'
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

        div.innerText = div.textContent = line + 1

        div.style.left = 0
        div.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @view.opts.textHeight - @fontAscent - @scrollOffsets.main.y}px"

        div.style.font = @fontSize + 'px ' + @fontFamily
        div.style.width = "#{@gutter.offsetWidth}px"
        translatingElements.push div

        div.className = 'droplet-transitioning-element droplet-transitioning-gutter'
        div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"

        @dropletElement.appendChild div

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

      setTimeout (=>
        @dropletElement.style.transition =
          @paletteWrapper.style.transition = "left #{translateTime}ms"

        @dropletElement.style.left = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"
      ), fadeTime

      setTimeout (=>
        # Translate the ICE editor div out of frame.
        @dropletElement.style.transition =
          @paletteWrapper.style.transition = ''

        @dropletElement.style.top = '-9999px'
        @dropletElement.style.left = '-9999px'

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
      setValueResult = @copyAceEditor()

      unless setValueResult.success
        return setValueResult

      if @aceEditor.getFirstVisibleRow() is 0
        @mainScroller.scrollTop = 0
      else
        @mainScroller.scrollTop = @view.getViewNodeFor(@tree).bounds[@aceEditor.getFirstVisibleRow()].y

      @currentlyUsingBlocks = true
      @currentlyAnimating = true
      @fireEvent 'statechange', [true]

      setTimeout (=>
        # Hide scrollbars and increase width
        @mainScroller.style.overflow = 'hidden'
        @dropletElement.style.width = @wrapperElement.offsetWidth + 'px'

        @redrawMain noText: true

        @currentlyAnimating_suppressRedraw = true

        @aceElement.style.top = "-9999px"
        @aceElement.style.left = "-9999px"

        @paletteWrapper.style.top = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

        @dropletElement.style.top = "0px"
        @dropletElement.style.left = "0px"

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

          div.innerText = div.textContent = textElement.model.value

          div.style.font = @aceFontSize() + ' ' + @fontFamily
          div.style.position = 'absolute'

          div.style.left = "#{textElement.bounds[0].x - @scrollOffsets.main.x + translationVectors[i].x}px"
          div.style.top = "#{textElement.bounds[0].y - @scrollOffsets.main.y + translationVectors[i].y}px"

          div.className = 'droplet-transitioning-element'
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

          div.innerText = div.textContent = line + 1

          div.style.font = @aceFontSize() + ' ' + @fontFamily
          div.style.width = "#{@aceEditor.renderer.$gutter.offsetWidth}px"

          div.style.left = 0
          div.style.top = "#{@aceEditor.session.documentToScreenRow(line, 0) *
              lineHeight - aceScrollTop}px"

          div.className = 'droplet-transitioning-element droplet-transitioning-gutter'
          div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
          translatingElements.push div

          @dropletElement.appendChild div

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
          @mainCanvas.style.opacity = 1
          @highlightCanvas.style.opacity = 1

          if @editorHasFocus()
            @cursorCanvas.style.opacity = 1
          else
            @cursorCanvas.style.opacity = CURSOR_UNFOCUSED_OPACITY

        ), translateTime

        @dropletElement.style.transition =
          @paletteWrapper.style.transition = "left #{fadeTime}ms"

        @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"
        @paletteWrapper.style.left = '0px'

        setTimeout (=>
          @dropletElement.style.transition =
            @paletteWrapper.style.transition = ''

          # Show scrollbars again
          @mainScroller.style.overflow = 'auto'

          @currentlyAnimating = false
          @lineNumberWrapper.style.display = 'block'
          @redrawMain()
          @paletteHeader.style.zIndex = 257

          for div in translatingElements
            div.parentNode.removeChild div

          @resizeBlockMode()

          @fireEvent 'toggledone', [@currentlyUsingBlocks]

          if cb? then do cb
        ), translateTime + fadeTime

      ), 0

      return success: true

  Editor::toggleBlocks = (cb) ->
    if @currentlyUsingBlocks
      return @performMeltAnimation 500, 1000, cb
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
    @mainScroller.className = 'droplet-main-scroller'

    @mainScrollerStuffing = document.createElement 'div'
    @mainScrollerStuffing.className = 'droplet-main-scroller-stuffing'

    @mainScroller.appendChild @mainScrollerStuffing
    @dropletElement.appendChild @mainScroller

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
    @paletteScroller.className = 'droplet-palette-scroller'

    @paletteScrollerStuffing = document.createElement 'div'
    @paletteScrollerStuffing.className = 'droplet-palette-scroller-stuffing'

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

  Editor::resizeMainScroller = ->
    @mainScroller.style.width = "#{@dropletElement.offsetWidth}px"
    @mainScroller.style.height = "#{@dropletElement.offsetHeight}px"

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
    @resizeBlockMode()

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
      if not @trackerPointIsInMainScroller point then return

      mainPoint = @trackerPointToMain point

      treeView = @view.getViewNodeFor @tree

      if @lastHoveredLine? and treeView.bounds[@lastHoveredLine]? and
          treeView.bounds[@lastHoveredLine].contains mainPoint
        return

      hoveredLine = @findLineNumberAtCoordinate mainPoint.y

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

    newParse = @mode.parse value, wrapAtRoot: true

    if value isnt @tree.stringify(@mode.empty)
      @addMicroUndoOperation 'CAPTURE_POINT'
    @addMicroUndoOperation new SetValueOperation @tree, newParse

    @tree = newParse; @gutterVersion = -1
    @tree.start.insert @cursor
    @removeBlankLines()
    @redrawMain()

    return success: true

  Editor::setValue = (value) ->

    oldScrollTop = @aceEditor.session.getScrollTop()

    @setAceValue value
    @resizeTextMode()

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
      return @addEmptyLine @tree.stringify(@mode.empty)
    else
      @getAceValue()

  Editor::getAceValue = ->
    value = @aceEditor.getValue()
    @lastAceSeenValue = value

  Editor::setAceValue = (value) ->
    if value isnt @lastAceSeenValue
      @aceEditor.setValue value, 1
      # TODO: move ace cursor to location matching droplet cursor.
      @lastAceSeenValue = value


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
      @setValue @getAceValue()

      @dropletElement.style.top =
        @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'

      @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"

      @aceElement.style.top = @aceElement.style.left = '-9999px'
      @currentlyUsingBlocks = true

      @lineNumberWrapper.style.display = 'block'

      @mainCanvas.opacity = @paletteWrapper.opacity =
        @highlightCanvas.opacity = 1

      @resizeBlockMode(); @redrawMain()

    else
      oldScrollTop = @aceEditor.session.getScrollTop()

      @setAceValue @getValue()
      @aceEditor.resize true

      @aceEditor.session.setScrollTop oldScrollTop

      @dropletElement.style.top = @dropletElement.style.left =
        @paletteWrapper.style.top = @paletteWrapper.style.left = '-9999px'
      @aceElement.style.top = @aceElement.style.left = '0px'
      @currentlyUsingBlocks = false

      @lineNumberWrapper.style.display = 'none'

      @mainCanvas.opacity =
        @highlightCanvas.opacity = 0

      @resizeBlockMode()

  # DRAG CANVAS SHOW/HIDE HACK
  # ================================

  hook 'populate', 0, ->
    @dragCover = document.createElement 'div'
    @dragCover.className = 'droplet-drag-cover'
    @dragCover.style.display = 'none'

    document.body.appendChild @dragCover

  # On mousedown, bring the drag
  # canvas to the front so that it
  # appears to "float" over all other elements
  hook 'mousedown', -1, ->
    if @clickedBlock?
      @dragCover.style.display = 'block'

  # On mouseup, throw the drag canvas away completely.
  hook 'mouseup', 0, ->
    @dragCanvas.style.top =
      @dragCanvas.style.left = '-9999px'

    @dragCover.style.display = 'none'

  # FAILSAFE END DRAG HACK
  # ================================

  hook 'mousedown', 10, ->
    if @draggingBlock?
      @endDrag()

  Editor::endDrag = ->
    @draggingBlock = null
    @draggingOffset = null
    @lastHighlight = null

    @clearDrag()
    @redrawMain()
    return

  # PALETTE EVENT
  # =================================
  hook 'set_palette', 0, ->
    @fireEvent 'changepalette', []

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

    return absolutePoint.from(@absoluteOffset(@dropletElement))

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
    @cursorCanvas.className = 'droplet-highlight-canvas droplet-cursor-canvas'

    @cursorCtx = @cursorCanvas.getContext '2d'

    @dropletElement.appendChild @cursorCanvas

  Editor::resizeCursorCanvas = ->
    @cursorCanvas.width = @dropletElement.offsetWidth
    @cursorCanvas.style.width = "#{@cursorCanvas.width}px"

    @cursorCanvas.height = @dropletElement.offsetHeight
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

  Editor::editorHasFocus = ->
    document.activeElement in [@dropletElement, @hiddenInput, @copyPasteInput] and
    document.hasFocus()

  Editor::flash = ->
    if @lassoSegment? or @draggingBlock? or
        (@textFocus? and @textInputHighlighted) or
        not @highlightsCurrentlyShown or
        not @editorHasFocus()
      @highlightFlashShow()
    else
      @highlightFlashHide()

  hook 'populate', 0, ->
    @highlightsCurrentlyShown = false

    blurCursors = =>
      @highlightFlashShow()
      @cursorCanvas.style.transition = ''
      @cursorCanvas.style.opacity = CURSOR_UNFOCUSED_OPACITY

    @dropletElement.addEventListener 'blur', blurCursors
    @hiddenInput.addEventListener 'blur', blurCursors
    @copyPasteInput.addEventListener 'blur', blurCursors

    focusCursors = =>
      @highlightFlashShow()
      @cursorCanvas.style.transition = ''
      @cursorCanvas.style.opacity = 1

    @dropletElement.addEventListener 'focus', focusCursors
    @hiddenInput.addEventListener 'focus', focusCursors
    @copyPasteInput.addEventListener 'focus', focusCursors

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
        @endDrag()

  # LINE NUMBER GUTTER CODE
  # ================================
  hook 'populate', 0, ->
    @gutter = document.createElement 'div'
    @gutter.className = 'droplet-gutter'

    @lineNumberWrapper = document.createElement 'div'
    @gutter.appendChild @lineNumberWrapper

    @gutterVersion = -1

    @lineNumberTags = {}

    @dropletElement.appendChild @gutter

  Editor::resizeGutter = ->
    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'
    @gutter.style.height = "#{Math.max @dropletElement.offsetHeight, @view.getViewNodeFor(@tree).totalBounds?.height ? 0}px"


  Editor::addLineNumberForLine = (line) ->
    treeView = @view.getViewNodeFor @tree

    if line of @lineNumberTags
      lineDiv = @lineNumberTags[line]

    else
      lineDiv = document.createElement 'div'
      lineDiv.className = 'droplet-gutter-line'
      lineDiv.innerText = lineDiv.textContent = line + 1

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

      if treeView.bounds[pivot].y > coord
        end = pivot
      else
        start = pivot

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

  Editor::setPaletteWidth = (width) ->
    @paletteWrapper.style.width = width + 'px'
    @resizeBlockMode()

  # COPY AND PASTE
  # ================================
  hook 'populate', 1, ->
    @copyPasteInput = document.createElement 'textarea'
    @copyPasteInput.style.position = 'absolute'
    @copyPasteInput.style.left = @copyPasteInput.style.top = '-9999px'

    @dropletElement.appendChild @copyPasteInput

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

          blocks = @mode.parse str

          @addMicroUndoOperation 'CAPTURE_POINT'
          if @lassoSegment?
            @addMicroUndoOperation new PickUpOperation @lassoSegment
            @spliceOut @lassoSegment; @lassoSegment = null

          @addMicroUndoOperation new DropOperation blocks, @cursor.previousVisibleToken()

          @spliceIn blocks, @cursor
          unless blocks.end.nextVisibleToken().type in ['newline', 'indentEnd']
            blocks.end.insert new model.NewlineToken()

          @addMicroUndoOperation new DestroySegmentOperation blocks

          blocks.unwrap()

          @redrawMain()

        @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length
      else if pressedXKey and @lassoSegment?
        @addMicroUndoOperation 'CAPTURE_POINT'
        @addMicroUndoOperation new PickUpOperation @lassoSegment
        @spliceOut @lassoSegment; @lassoSegment = null
        @redrawMain()

  hook 'keydown', 0, (event, state) ->
    if event.which in command_modifiers
      console.log 'FOCUSING'
      unless @textFocus?
        @copyPasteInput.focus()
        if @lassoSegment?
          @copyPasteInput.value = @lassoSegment.stringify(@mode.empty)
        @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length

  hook 'keyup', 0, (point, event, state) ->
    if event.which in command_modifiers
      if @textFocus?
        @hiddenInput.focus()
      else
        @dropletElement.focus()

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

  return exports
