# Droplet controller.
#
# Copyright (c) 2014 Anthony Bau (dab1998@gmail.com)
# MIT License.

helper = require './helper.coffee'
draw = require './draw.coffee'
model = require './model.coffee'
view = require './view.coffee'

QUAD = require '../vendor/quadtree.js'
modes = require './modes.coffee'

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
DROPDOWN_SCROLLBAR_PADDING = 17

BACKSPACE_KEY = 8
TAB_KEY = 9
ENTER_KEY = 13
LEFT_ARROW_KEY = 37
UP_ARROW_KEY = 38
RIGHT_ARROW_KEY = 39
DOWN_ARROW_KEY = 40
Z_KEY = 90
Y_KEY = 89

META_KEYS = [91, 92, 93, 223, 224]
CONTROL_KEYS = [17, 162, 163]
GRAY_BLOCK_MARGIN = 5
GRAY_BLOCK_HANDLE_WIDTH = 15
GRAY_BLOCK_HANDLE_HEIGHT = 30
GRAY_BLOCK_COLOR = '#FFF'
GRAY_BLOCK_BORDER = '#AAA'

userAgent = ''
if typeof(window) isnt 'undefined' and window.navigator?.userAgent
  userAgent = window.navigator.userAgent
isOSX = /OS X/.test(userAgent)
command_modifiers = if isOSX then META_KEYS else CONTROL_KEYS
command_pressed = (e) -> if isOSX then e.metaKey else e.ctrlKey

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
  'redraw_palette': []    # repaint the graphics of the palette
  'rebuild_palette': []   # redraw the paltte, both graphics and elements

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
    @readOnly = false
    @paletteGroups = @options.palette
    @showPaletteInTextMode = @options.showPaletteInTextMode ? false
    @paletteEnabled = @options.enablePaletteAtStart ? true

    @options.mode = @options.mode.replace /$\/ace\/mode\//, ''

    if @options.mode of modes
      @mode = new modes[@options.mode] @options.modeOptions
    else
      @mode = new coffee @options.modeOptions

    @draw = new draw.Draw()

    # No gutter decorations to start
    @gutterDecorations = {}

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

    @mainCanvas.width = @mainCanvas.height = 0

    @mainCtx = @mainCanvas.getContext '2d'

    @dropletElement.appendChild @mainCanvas

    @paletteWrapper = document.createElement 'div'
    @paletteWrapper.className = 'droplet-palette-wrapper'

    @paletteElement = document.createElement 'div'
    @paletteElement.className = 'droplet-palette-element'
    @paletteWrapper.appendChild @paletteElement

    # Then palette canvas
    @paletteCanvas = document.createElement 'canvas'
    @paletteCanvas.className = 'droplet-palette-canvas'
    @paletteCanvas.height = @paletteCanvas.width = 0

    @paletteCtx = @paletteCanvas.getContext '2d'

    @paletteElement.appendChild @paletteCanvas

    @paletteWrapper.style.position = 'absolute'
    @paletteWrapper.style.left = '0px'
    @paletteWrapper.style.top = '0px'
    @paletteWrapper.style.bottom = '0px'
    @paletteWrapper.style.width = '270px'

    @dropletElement.style.left = @paletteWrapper.offsetWidth + 'px'

    @wrapperElement.appendChild @paletteWrapper

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

    # Set up event bindings before creating a view
    @bindings = {}

    # Instantiate an ICE editor view
    @view = new view.View @standardViewSettings
    @paletteView = new view.View helper.extend {}, @standardViewSettings, {
      showDropdowns: @options.showDropdownInPalette ? false
    }
    @dragView = new view.View @standardViewSettings

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

      trackPoint = new @draw.Point(event.clientX, event.clientY)

      # We keep a state object so that handlers
      # can know about each other.
      state = {}

      # Call all the handlers.
      for handler in editorBindings[event.type]
        handler.call this, trackPoint, event, state

      # Stop mousedown event default behavior so that
      # we don't get bad selections
      if event.type is 'mousedown'
        event.preventDefault?()
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
    @tree = new model.Document()

    @resizeBlockMode()

    # Now that we've populated everything, immediately redraw.
    @redrawMain()
    @rebuildPalette()

    # If we were given an unrecognized mode or asked to start in text mode,
    # flip into text mode here
    useBlockMode = @mode? && !@options.textModeAtStart
    # Always call @setEditorState to ensure palette is positioned properly
    @setEditorState useBlockMode

    return this

  setMode: (mode, modeOptions) ->
    modeClass = modes[mode]
    if modeClass
      @options.mode = mode
      @mode = new modeClass modeOptions
    else
      @options.mode = null
      @mode = null
    @setValue @getValue()

  getMode: ->
    @options.mode

  setReadOnly: (readOnly) ->
    @readOnly = readOnly
    @aceEditor.setReadOnly readOnly

  getReadOnly: ->
    @readOnly

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

    @dropletElement.style.height = "#{@wrapperElement.clientHeight}px"
    if @paletteEnabled
      @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"
      @dropletElement.style.width = "#{@wrapperElement.clientWidth - @paletteWrapper.offsetWidth}px"
    else
      @dropletElement.style.left = "0px"
      @dropletElement.style.width = "#{@wrapperElement.clientWidth}px"

    @resizeGutter()

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
    @paletteCanvas.style.top = "#{@paletteHeader.offsetHeight}px"
    @paletteCanvas.height = @paletteWrapper.offsetHeight - @paletteHeader.offsetHeight
    @paletteCanvas.width = @paletteWrapper.offsetWidth

    @paletteCanvas.style.height = "#{@paletteCanvas.height}px"
    @paletteCanvas.style.width = "#{@paletteCanvas.width}px"

    for binding in editorBindings.resize_palette
      binding.call this

    @paletteCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y
    @paletteHighlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y

    @rebuildPalette()

  resize: ->
    if @currentlyUsingBlocks
      @resizeBlockMode()
    else
      @resizeTextMode()


# RENDERING CAPABILITIES
# ================================

# ## Redraw
# There are two different redraw events, redraw_main and rebuild_palette,
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

Editor::drawFloatingBlock = (record, startWidth, endWidth, rect, opts) ->
  blockView = @view.getViewNodeFor record.block
  blockView.layout record.position.x, record.position.y

  rectangle = new @view.draw.Rectangle(); rectangle.copy(blockView.totalBounds)
  rectangle.x -= GRAY_BLOCK_MARGIN; rectangle.y -= GRAY_BLOCK_MARGIN
  rectangle.width += 2 * GRAY_BLOCK_MARGIN; rectangle.height += 2 * GRAY_BLOCK_MARGIN

  bottomTextPosition = blockView.totalBounds.bottom() - blockView.distanceToBase[blockView.lineLength - 1].below - @fontSize

  if (blockView.totalBounds.width - blockView.bounds[blockView.bounds.length - 1].width) < endWidth
    if blockView.lineLength > 1
      rectangle.height += @fontSize
      bottomTextPosition = rectangle.bottom() - @fontSize - 5
    else
      rectangle.width += endWidth

  unless rectangle.equals(record.grayBox)
    record.grayBox = rectangle

    oldBounds = record.grayBoxPath?.bounds?() ? new @view.draw.NoRectangle()

    startHeight = blockView.bounds[0].height + 10

    # Make the path surrounding the gray box (with rounded corners)
    record.grayBoxPath = path = new @view.draw.Path()
    path.push new @view.draw.Point rectangle.right() - 5, rectangle.y
    path.push new @view.draw.Point rectangle.right(), rectangle.y + 5
    path.push new @view.draw.Point rectangle.right(), rectangle.bottom() - 5
    path.push new @view.draw.Point rectangle.right() - 5, rectangle.bottom()

    if blockView.lineLength > 1
      path.push new @view.draw.Point rectangle.x + 5, rectangle.bottom()
      path.push new @view.draw.Point rectangle.x, rectangle.bottom() - 5
    else
      path.push new @view.draw.Point rectangle.x, rectangle.bottom()

    # Handle
    path.push new @view.draw.Point rectangle.x, rectangle.y + startHeight
    path.push new @view.draw.Point rectangle.x - startWidth + 5, rectangle.y + startHeight
    path.push new @view.draw.Point rectangle.x - startWidth, rectangle.y + startHeight - 5
    path.push new @view.draw.Point rectangle.x - startWidth, rectangle.y + 5
    path.push new @view.draw.Point rectangle.x - startWidth + 5, rectangle.y

    path.push new @view.draw.Point rectangle.x, rectangle.y


    path.bevel = false
    path.noclip = true
    path.dotted = true
    path.style = {
      fillColor: GRAY_BLOCK_COLOR
      strokeColor: GRAY_BLOCK_BORDER
      lineWidth: 4
    }

    if opts.boundingRectangle?
      opts.boundingRectangle.unite path.bounds()
      opts.boundingRectangle.unite(oldBounds)
      @mainCtx.restore()
      return @redrawMain opts

  # TODO this will need to become configurable by the @mode
  @mainCtx.globalAlpha *= 0.8
  record.grayBoxPath.draw @mainCtx
  @mainCtx.fillStyle = '#000'
  @mainCtx.fillText(@mode.startComment, blockView.totalBounds.x - startWidth,
    blockView.totalBounds.y + blockView.distanceToBase[0].above - @fontSize)
  @mainCtx.fillText(@mode.endComment, record.grayBox.right() - endWidth - 5, bottomTextPosition)
  @mainCtx.globalAlpha /= 0.8

  blockView.draw @mainCtx, rect, {
    grayscale: false
    selected: false
    noText: false
  }

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

    rect = opts.boundingRectangle ? new @draw.Rectangle(
      @scrollOffsets.main.x,
      @scrollOffsets.main.y,
      @mainCanvas.width,
      @mainCanvas.height
    )
    options = {
      grayscale: false
      selected: false
      noText: (opts.noText ? false)
    }

    # Draw the new tree on the main context
    layoutResult = @view.getViewNodeFor(@tree).layout 0, @nubbyHeight
    @view.getViewNodeFor(@tree).draw @mainCtx, rect, options

    # Draw floating blocks
    startWidth = @mainCtx.measureText(@mode.startComment).width
    endWidth = @mainCtx.measureText(@mode.endComment).width
    for record in @floatingBlocks
      @drawFloatingBlock(record, startWidth, endWidth, rect, opts)

    if opts.boundingRectangle?
      @mainCtx.restore()

    # Draw the cursor (if exists, and is inserted)
    @redrawCursors(); @redrawHighlights()
    @resizeGutter()

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
    if @inDisplay info.model
      path = @getHighlightPath info.model, info.style
      path.draw @highlightCtx
    else
      delete @markedLines[line]

  for id, info of @markedBlocks
    if @inDisplay info.model
      path = @getHighlightPath info.model, info.style
      path.draw @highlightCtx
    else
      delete @markedLines[id]

  for id, info of @extraMarks
    if @inDisplay info.model
      path = @getHighlightPath info.model, info.style
      path.draw @highlightCtx
    else
      delete @extraMarks[id]

  # If there is an block that is being dragged,
  # draw it in gray
  if @draggingBlock? and @inDisplay @draggingBlock
    @view.getViewNodeFor(@draggingBlock).draw @highlightCtx, new @draw.Rectangle(
      @scrollOffsets.main.x,
      @scrollOffsets.main.y,
      @mainCanvas.width,
      @mainCanvas.height
    ), {grayscale: true}
    @maskFloatingPaths(@draggingBlock.getDocument())

  @redrawCursors()
  @redrawLassoHighlight()

Editor::clearCursorCanvas = ->
  @cursorCtx.clearRect @scrollOffsets.main.x, @scrollOffsets.main.y, @cursorCanvas.width, @cursorCanvas.height

Editor::redrawCursors = ->
  @clearCursorCanvas()

  if @cursorAtSocket()
    @redrawTextHighlights()

  else unless @lassoSelection?
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

  for entry in @currentPaletteBlocks
    # Layout this block
    paletteBlockView = @paletteView.getViewNodeFor entry.block
    paletteBlockView.layout PALETTE_LEFT_MARGIN, lastBottomEdge

    # Render the block
    paletteBlockView.draw @paletteCtx, boundingRect

    # Update lastBottomEdge
    lastBottomEdge = paletteBlockView.getBounds().bottom() + PALETTE_MARGIN

  for binding in editorBindings.redraw_palette
    binding.call this

Editor::rebuildPalette = ->
  @redrawPalette()
  for binding in editorBindings.rebuild_palette
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

Editor::trackerPointIsInElement = (point, element) ->
  if @readOnly
    return false
  if not element.offsetParent?
    return false
  gbr = element.getBoundingClientRect()
  return point.x >= gbr.left and point.x < gbr.right and
         point.y >= gbr.top and point.y < gbr.bottom

Editor::trackerPointIsInMain = (point) ->
  return this.trackerPointIsInElement point, @mainCanvas

Editor::trackerPointIsInMainScroller = (point) ->
  return this.trackerPointIsInElement point, @mainScroller

Editor::trackerPointIsInGutter = (point) ->
  return this.trackerPointIsInElement point, @gutter

Editor::trackerPointIsInPalette = (point) ->
  return this.trackerPointIsInElement point, @paletteCanvas

Editor::trackerPointIsInAce = (point) ->
  return this.trackerPointIsInElement point, @aceElement


# ### hitTest
# Simple function for going through a linked-list block
# and seeing what the innermost child is that we hit.
Editor::hitTest = (point, block, view = @view) ->
  if @readOnly
    return null

  head = block.start
  seek = block.end
  result = null

  until head is seek
    if head.type is 'blockStart' and view.getViewNodeFor(head.container).path.contains point
      result = head.container
      seek = head.container.end
    head = head.next

  # If we had a child hit, return it.
  return result

hook 'mousedown', 10, ->
  x = document.body.scrollLeft
  y = document.body.scrollTop
  @dropletElement.focus()
  window.scrollTo(x, y)

Editor::removeBlankLines = ->
  # If we have blank lines at the end,
  # get rid of them
  head = tail = @tree.end.prev
  while head?.type is 'newline'
    head = head.prev

  if head.type is 'newline'
    @spliceOut new model.List head, tail

# UNDO STACK SUPPORT
# ================================

# We must declare a few
# fields a populate time
hook 'populate', 0, ->
  @undoStack = []
  @redoStack = []
  @changeEventVersion = 0

# Now we hook to ctrl-z to undo.
hook 'keydown', 0, (event, state) ->
  if event.which is Z_KEY and event.shiftKey and command_pressed(event)
    @redo()
  else if event.which is Z_KEY and command_pressed(event)
    @undo()
  else if event.which is Y_KEY and command_pressed(event)
    @redo()

class EditorState
  constructor: (@root, @floats) ->

  equals: (other) ->
    return false unless @root is other.root and @floats.length is other.floats.length
    for el, i in @floats
      return false unless el.position.equals(other.floats[i].position) and el.string is other.floats[i].string
    return true

  toString: -> JSON.stringify {
    @root, @floats
  }

Editor::getSerializedEditorState = ->
  return new EditorState @tree.stringify(), @floatingBlocks.map (x) -> {
    position: x.position
    string: x.block.stringify()
  }

Editor::clearUndoStack = ->
  @undoStack.length = 0
  @redoStack.length = 0

Editor::undo = ->
  # Don't allow a socket to be highlighted during
  # an undo operation
  @setCursor @cursor, ((x) -> x.type isnt 'socketStart')

  currentValue = @getSerializedEditorState()

  until @undoStack.length is 0 or
      (@undoStack[@undoStack.length - 1] instanceof CapturePoint and
      not @getSerializedEditorState().equals(currentValue))
    operation = @popUndo()
    if operation instanceof FloatingOperation
      @performFloatingOperation(operation, 'backward')
    else
      @getDocument(operation.document).perform(
        operation.operation, 'backward', @getPreserves(operation.document)
      ) unless operation instanceof CapturePoint

  # Set the the remembered socket contents to the state it was in
  # at this point in the undo stack.
  if @undoStack[@undoStack.length - 1] instanceof CapturePoint
    @rememberedSockets = @undoStack[@undoStack.length - 1].rememberedSockets.map (x) -> x.clone()

  @popUndo()
  @correctCursor()
  @redrawMain()
  return

Editor::pushUndo = (operation) ->
  @redoStack.length = 0
  @undoStack.push operation

Editor::popUndo = ->
  operation = @undoStack.pop()
  @redoStack.push(operation) if operation?
  return operation

Editor::popRedo = ->
  operation = @redoStack.pop()
  @undoStack.push(operation) if operation?
  return operation

Editor::redo = ->
  currentValue = @getSerializedEditorState()

  until @redoStack.length is 0 or
      (@redoStack[@redoStack.length - 1] instanceof CapturePoint and
      not @getSerializedEditorState().equals(currentValue))
    operation = @popRedo()
    if operation instanceof FloatingOperation
      @performFloatingOperation(operation, 'forward')
    else
      @getDocument(operation.document).perform(
        operation.operation, 'forward', @getPreserves(operation.document)
      ) unless operation instanceof CapturePoint

  # Set the the remembered socket contents to the state it was in
  # at this point in the undo stack.
  if @undoStack[@undoStack.length - 1] instanceof CapturePoint
    @rememberedSockets = @undoStack[@undoStack.length - 1].rememberedSockets.map (x) -> x.clone()

  @popRedo()
  @redrawMain()
  return

# ## undoCapture and CapturePoint ##
# A CapturePoint is a sentinel indicating that the undo stack
# should stop when the user presses Ctrl+Z or Ctrl+Y. Each CapturePoint
# also remembers the @rememberedSocket state at the time it was placed,
# to preserved remembered socket contents across undo and redo.
Editor::undoCapture = ->
  @pushUndo new CapturePoint(@rememberedSockets)

class CapturePoint
  constructor: (rememberedSockets) ->
    @rememberedSockets = rememberedSockets.map (x) -> x.clone()

Editor::setFocusedText = (value) ->
  if @getCursor().type is 'socket'
    @populateSocket @getCursor(), value
    @hiddenInput.value = value
    @redrawMain()

# BASIC BLOCK MOVE SUPPORT
# ================================

hook 'populate', 7, ->
  # ## rememberedSockets ##
  # This is an array with pair elements mapping locations of sockets
  # to old text values, for when users drop a block into a socket and then pull
  # it back out again. All the mutation operations (spliceIn, spliceOut, replace)
  # update these locations to attempt to make sure the locations point to the same sockets,
  # and the Controller will also attempt to bring the locations with a dragged block
  # if they are inside it.
  #
  # A snapshot of this array is taken every CapturePoint in the undo stack and restored
  # when the undo stack reaches this point, to persist this effect across undo and redo.
  @rememberedSockets = []

Editor::getPreserves = (dropletDocument) ->
  if dropletDocument instanceof model.Document
    dropletDocument = @documentIndex dropletDocument

  array = [@cursor]

  array = array.concat @rememberedSockets.map(
    (x) -> x.socket
  )

  return array.filter((location) ->
    location.document is dropletDocument
  ).map((location) -> location.location)

Editor::spliceOut = (node) ->
  # Make an empty list if we haven't been
  # passed one
  unless node instanceof model.List
    node = new model.List node, node

  operation = null

  dropletDocument = node.getDocument()

  if dropletDocument?
    parent = node.parent

    operation = node.getDocument().remove node, @getPreserves(dropletDocument)
    @pushUndo {operation, document: @getDocuments().indexOf(dropletDocument)}

    # If we are removing a block from a socket, and the socket is in our
    # dictionary of remembered socket contents, repopulate the socket with
    # its old contents.
    if parent?.type is 'socket' and node.start.type is 'blockStart'
      for socket, i in @rememberedSockets
        if @fromCrossDocumentLocation(socket.socket) is parent
          @rememberedSockets.splice i, 0
          @populateSocket parent, socket.text
          break

    # Remove the floating dropletDocument if it is now
    # empty
    if dropletDocument.start.next is dropletDocument.end
      for record, i in @floatingBlocks
        if record.block is dropletDocument
          @pushUndo new FloatingOperation i, record.block, record.position, 'delete'

          # If the cursor's document is about to vanish,
          # put it back in the main tree.
          if @cursor.document is i + 1
            @setCursor @tree.start

          if @cursor.document > i + 1
            @cursor.document -= 1

          @floatingBlocks.splice i, 1
          break

  @prepareNode node, null
  @correctCursor()
  return operation

Editor::spliceIn = (node, location) ->
  # Track changes in the cursor by temporarily
  # using a pointer to it
  container = location.container ? location.parent
  if container.type is 'block'
    container = container.parent
  else if container.type is 'socket' and
      container.start.next isnt container.end
    # If we're splicing into a socket and it already has
    # something in it, remove it. Additionally, remember the old
    # contents in @rememberedSockets for later repopulation if they take
    # the block back out.
    @rememberedSockets.push new RememberedSocketRecord(
      @toCrossDocumentLocation(container),
      container.textContent()
    )
    @spliceOut new model.List container.start.next, container.end.prev

  dropletDocument = location.getDocument()

  if dropletDocument?
    @prepareNode node, container
    operation = dropletDocument.insert location, node, @getPreserves(dropletDocument)
    @pushUndo {operation, document: @getDocuments().indexOf(dropletDocument)}
    @correctCursor()
    return operation
  else
    return null

class RememberedSocketRecord
  constructor: (@socket, @text) ->

  clone: ->
    new RememberedSocketRecord(
      @socket.clone(),
      @text
    )

Editor::replace = (before, after, updates = []) ->
  dropletDocument = before.start.getDocument()
  if dropletDocument?
    operation = dropletDocument.replace before, after, updates.concat(@getPreserves(dropletDocument))
    @pushUndo {operation, document: @documentIndex(dropletDocument)}
    @correctCursor()
    return operation
  else
    return null

Editor::correctCursor = ->
  cursor = @fromCrossDocumentLocation @cursor
  unless @validCursorPosition cursor
    until not cursor? or (@validCursorPosition(cursor) and cursor.type isnt 'socketStart')
      cursor = cursor.next
    unless cursor? then cursor = @fromCrossDocumentLocation @cursor
    until not cursor? or (@validCursorPosition(cursor) and cursor.type isnt 'socketStart')
      cursor = cursor.prev
    @cursor = @toCrossDocumentLocation cursor

Editor::prepareNode = (node, context) ->
  if node instanceof model.Container
    leading = node.getLeadingText()
    if node.start.next is node.end.prev
      trailing = null
    else
      trailing = node.getTrailingText()

    [leading, trailing] = @mode.parens leading, trailing, node.getReader(),
      context?.getReader?() ? null

    node.setLeadingText leading; node.setTrailingText trailing


# At population-time, we will
# want to set up a few fields.
hook 'populate', 0, ->
  @clickedPoint = null
  @clickedBlock = null
  @clickedBlockPaletteEntry = null

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
  #document.body.appendChild @dragCanvas
  @wrapperElement.appendChild @dragCanvas
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

  @highlightCanvas.width = @dropletElement.offsetWidth - @gutter.offsetWidth
  @highlightCanvas.style.width = "#{@highlightCanvas.width}px"

  @highlightCanvas.height = @dropletElement.offsetHeight
  @highlightCanvas.style.height = "#{@highlightCanvas.height}px"

  @highlightCanvas.style.left = "#{@mainCanvas.offsetLeft}px"


Editor::getDocuments = ->
  documents = [@tree]
  for el, i in @floatingBlocks
    documents.push el.block
  return documents

Editor::getDocument = (n) ->
  if n is 0 then @tree
  else @floatingBlocks[n - 1].block

Editor::documentIndex = (block) ->
  @getDocuments().indexOf block.getDocument()

Editor::fromCrossDocumentLocation = (location) ->
  @getDocument(location.document).getFromLocation location.location

Editor::toCrossDocumentLocation = (block) ->
  new CrossDocumentLocation @documentIndex(block), block.getLocation()

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

  for dropletDocument, i in @getDocuments() by -1
    # First attempt handling text input
    if @handleTextInputClick mainPoint, dropletDocument
      state.consumedHitTest = true
      return
    else if @cursor.document is i and @cursorAtSocket()
      @setCursor @cursor, ((token) -> token.type isnt 'socketStart')

    hitTestResult = @hitTest mainPoint, dropletDocument

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
      @clickedBlockPaletteEntry = null

      # Move the cursor somewhere nearby
      @setCursor @clickedBlock.start.next

      # Record the point at which is was clicked (for clickedBlock->draggingBlock)
      @clickedPoint = point

      # Signify to any other hit testing
      # handlers that we have already consumed
      # the hit test opportunity for this event.
      state.consumedHitTest = true
      return

    else if i > 0
      record = @floatingBlocks[i - 1]
      if record.grayBoxPath? and record.grayBoxPath.contains @trackerPointToMain point
        @clickedBlock = new model.List record.block.start.next, record.block.end.prev
        @clickedPoint = point

        @view.getViewNodeFor(@clickedBlock).absorbCache()

        state.consumedHitTest = true

        @redrawMain()
        return

# If the user clicks inside a block
# and the block contains a button
# which is either add or subtract button
# call the handleButton callback
hook 'mousedown', 4, (point, event, state) ->
  if state.consumedHitTest then return
  if not @trackerPointIsInMain(point) then return

  mainPoint = @trackerPointToMain point

  #Buttons aren't clickable in a selection
  if @lassoSelection? and @hitTest(mainPoint, @lassoSelection)? then return

  hitTestResult = @hitTest mainPoint, @tree

  if hitTestResult?
    hitTestBlock = @view.getViewNodeFor hitTestResult
    str = hitTestResult.stringifyInPlace()

    if hitTestBlock.addButtonRect? and hitTestBlock.addButtonRect.contains mainPoint
      line = @mode.handleButton str, 'add-button', hitTestResult.getReader()
      @populateBlock hitTestResult, line
      state.consumedHitTest = true
    else if hitTestBlock.subtractButtonRect? and hitTestBlock.subtractButtonRect.contains mainPoint
      line = @mode.handleButton str, 'subtract-button', hitTestResult.getReader()
      @populateBlock hitTestResult, line
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
    @dragReplacing = false

    # Our dragging offset must be computed using the canvas on which this block
    # is rendered.
    #
    # NOTE: this really falls under "PALETTE SUPPORT", but must
    # go here. Try to organise this better.
    if @clickedBlockPaletteEntry
      @draggingOffset = @paletteView.getViewNodeFor(@draggingBlock).bounds[0].upperLeftCorner().from(
        @trackerPointToPalette(@clickedPoint))

      # Substitute in expansion for this palette entry, if supplied.
      expansion = @clickedBlockPaletteEntry.expansion
      if 'function' is typeof expansion then expansion = expansion()
      if (expansion) then expansion = parseBlock(@mode, expansion)
      @draggingBlock = (expansion or @draggingBlock).clone()

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

    # TODO figure out what to do with lists here

    # Draw the new dragging block on the drag canvas.
    #
    # When we are dragging things, we draw the shadow.
    # Also, we translate the block 1x1 to the right,
    # so that we can see its borders.
    @dragView.clearCache()
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
      x: @scrollOffsets.main.x
      y: @scrollOffsets.main.y
      w: @mainCanvas.width
      h: @mainCanvas.height

    for dropletDocument in @getDocuments()
      head = dropletDocument.start

      # Don't allow dropping at the start of the document
      # if we are already dragging a block that is at
      # the start of the document.
      if @draggingBlock.start.prev is head
        head = head.next

      until head is dropletDocument.end
        if head is @draggingBlock.start
          head = @draggingBlock.end

        if head instanceof model.StartToken
          acceptLevel = @getAcceptLevel @draggingBlock, head.container
          unless acceptLevel is helper.FORBID
            dropPoint = @view.getViewNodeFor(head.container).dropPoint

            if dropPoint?
              allowed = true
              for record, i in @floatingBlocks by -1
                if record.block is dropletDocument
                  break
                else if record.grayBoxPath.contains dropPoint
                  allowed = false
                  break
              if allowed
                @dropPointQuadTree.insert
                  x: dropPoint.x
                  y: dropPoint.y
                  w: 0
                  h: 0
                  acceptLevel: acceptLevel
                  _droplet_node: head.container

        head = head.next

    @dragCanvas.style.top = "#{position.y + getOffsetTop(@dropletElement)}px"
    @dragCanvas.style.left = "#{position.x + getOffsetLeft(@dropletElement)}px"

    # Now we are done with the "clickedX" suite of stuff.
    @clickedPoint = @clickedBlock = null
    @clickedBlockPaletteEntry = null

    @begunTrash = @wouldDelete position

    # Redraw the main canvas
    @redrawMain()

Editor::getAcceptLevel = (drag, drop) ->
  if drop.type is 'socket'
    if drag.type is 'list'
      return helper.FORBID
    else
      return @mode.drop drag.getReader(), drop.getReader(), null, null
  else if drop.type is 'block'
    if drop.parent.type is 'socket'
      return helper.FORBID
    else
      next = drop.nextSibling()
      return @mode.drop drag.getReader(), drop.parent.getReader(), drop.getReader(), next?.getReader?()
  else
    next = drop.firstChild()
    return @mode.drop drag.getReader(), drop.getReader(), drop.getReader(), next?.getReader?()

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

    if not @currentlyUsingBlocks
      if @trackerPointIsInAce position
        pos = @aceEditor.renderer.screenToTextCoordinates position.x, position.y
        @aceEditor.focus()
        @aceEditor.session.selection.moveToPosition pos
      else
        @aceEditor.blur()

    rect = @wrapperElement.getBoundingClientRect()

    @dragCanvas.style.top = "#{position.y - rect.top}px"
    @dragCanvas.style.left = "#{position.x - rect.left}px"

    mainPoint = @trackerPointToMain(position)

    best = null; min = Infinity

    # Check to see if the tree is empty;
    # if it is, drop on the tree always
    head = @tree.start.next
    while head.type in ['newline', 'cursor'] or head.type is 'text' and head.value is ''
      head = head.next

    if head is @tree.end and @floatingBlocks.length is 0 and
        @mainCanvas.width + @scrollOffsets.main.x > mainPoint.x > @scrollOffsets.main.x - @gutter.offsetWidth and
        @mainCanvas.height + @scrollOffsets.main.y > mainPoint.y > @scrollOffsets.main.y
      @view.getViewNodeFor(@tree).highlightArea.draw @highlightCtx
      @lastHighlight = @tree

    else
      # If the user is touching the original location,
      # assume they want to replace the block where they found it.
      if @hitTest mainPoint, @draggingBlock
        best = null
        @dragReplacing = true

      # Otherwise, find the closest droppable block
      else
        @dragReplacing = false
        testPoints = @dropPointQuadTree.retrieve {
          x: mainPoint.x - MAX_DROP_DISTANCE
          y: mainPoint.y - MAX_DROP_DISTANCE
          w: MAX_DROP_DISTANCE * 2
          h: MAX_DROP_DISTANCE * 2
        }, (point) =>
          unless (point.acceptLevel is helper.DISCOURAGE) and not event.shiftKey
            # Find a modified "distance" to the point
            # that weights horizontal distance more
            distance = mainPoint.from(point)
            distance.y *= 2; distance = distance.magnitude()

            # Select the node that is closest by said "distance"
            if distance < min and mainPoint.from(point).magnitude() < MAX_DROP_DISTANCE and
               @view.getViewNodeFor(point._droplet_node).highlightArea?
              best = point._droplet_node
              min = distance

      # Update highlight if necessary.
      if best isnt @lastHighlight
        # TODO if this becomes a performance issue,
        # pull the drop highlights out into a new canvas.
        @redrawHighlights()

        if best?
          @view.getViewNodeFor(best).highlightArea.draw @highlightCtx
          @maskFloatingPaths(best.getDocument())

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

hook 'mouseup', 1, (point, event, state) ->
  if @dragReplacing
    @endDrag()

  # We will consume this event iff we dropped it successfully
  # in the root tree.
  if @draggingBlock?
    if not @currentlyUsingBlocks
      # See if we can drop the block's text in ace mode.
      position = new @draw.Point(
        point.x + @draggingOffset.x,
        point.y + @draggingOffset.y
      )

      if @trackerPointIsInAce position
        leadingWhitespaceRegex = /^(\s*)/
        # Get the line of text we're dropping into
        pos = @aceEditor.renderer.screenToTextCoordinates position.x, position.y
        line = @aceEditor.session.getLine pos.row
        currentIndentation = leadingWhitespaceRegex.exec(line)[0]

        prefix = ''
        indentation = currentIndentation
        suffix = ''

        if currentIndentation.length == line.length or currentIndentation.length == pos.column
          # line is whitespace only or we're inserting at the beginning of a line
          # Append with a newline
          suffix = '\n' + indentation
        else if pos.column == line.length
          # We're at the end of a non-empty line.
          # Insert a new line, and base our indentation off of the next line
          prefix = '\n'
          nextLine = @aceEditor.session.getLine(pos.row + 1)
          indentation = leadingWhitespaceRegex.exec(nextLine)[0]
        else

        # Call prepareNode, which may append with a semicolon
        @prepareNode @draggingBlock, null
        text = @draggingBlock.stringify @mode

        # Indent each line, unless it's the first line and wasn't placed on
        # a newline
        text = text.split('\n').map((line, index) =>
          return (if index == 0 and prefix == '' then '' else indentation) + line
        ).join('\n')

        text = prefix + text + suffix

        @aceEditor.onTextInput text
    else if @lastHighlight?
      @undoCapture()

      # Remove the block from the tree.
      rememberedSocketOffsets = @spliceRememberedSocketOffsets(@draggingBlock)

      # TODO this is a hacky way of preserving locations
      # across parenthesis insertion
      hadTextToken = @draggingBlock.start.next.type is 'text'

      @spliceOut @draggingBlock

      @clearHighlightCanvas()

      # Fire an event for a sound
      @fireEvent 'sound', [@lastHighlight.type]

      # Depending on what the highlighted element is,
      # we might want to drop the block at its
      # beginning or at its end.
      #
      # We will need to log undo operations here too.
      switch @lastHighlight.type
        when 'indent', 'socket'
          @spliceIn @draggingBlock, @lastHighlight.start
        when 'block'
          @spliceIn @draggingBlock, @lastHighlight.end
        else
          if @lastHighlight.type is 'document'
            @spliceIn @draggingBlock, @lastHighlight.start

      # TODO as above
      hasTextToken = @draggingBlock.start.next.type is 'text'
      if hadTextToken and not hasTextToken
        rememberedSocketOffsets.forEach (x) ->
          x.offset -= 1
      else if hasTextToken and not hadTextToken
        rememberedSocketOffsets.forEach (x) ->
          x.offset += 1

      futureCursorLocation = @toCrossDocumentLocation @draggingBlock.start

      # Reparse the parent if we are
      # in a socket
      #
      # TODO "reparseable" property (or absent contexts), bubble up
      # TODO performance on large programs
      if @lastHighlight.type is 'socket'
        @reparse @draggingBlock.parent.parent

      # Now that we've done that, we can annul stuff.
      @endDrag()

      @setCursor(futureCursorLocation) if futureCursorLocation?

      newBeginning = futureCursorLocation.location.count
      newIndex = futureCursorLocation.document

      for el, i in rememberedSocketOffsets
        @rememberedSockets.push new RememberedSocketRecord(
          new CrossDocumentLocation(
            newIndex
            new model.Location(el.offset + newBeginning, 'socket')
          ),
          el.text
        )

      # Fire the event for sound
      @fireEvent 'block-click'

Editor::spliceRememberedSocketOffsets = (block) ->
  if block.getDocument()?
    blockBegin = block.start.getLocation().count
    offsets = []
    newRememberedSockets = []
    for el, i in @rememberedSockets
      if block.contains @fromCrossDocumentLocation(el.socket)
        offsets.push {
          offset: el.socket.location.count - blockBegin
          text: el.text
        }
      else
        newRememberedSockets.push el
    @rememberedSockets = newRememberedSockets
    return offsets
  else
    []

# FLOATING BLOCK SUPPORT
# ================================

# We need to initialize the @floatingBlocks
# array at populate-time.
hook 'populate', 0, ->
  @floatingBlocks = []

class FloatingBlockRecord
  constructor: (@block, @position) ->

Editor::inTree = (block) -> (block.container ? block).getDocument() is @tree
Editor::inDisplay = (block) -> (block.container ? block).getDocument() in @getDocuments()

# We can create floating blocks by dropping
# blocks without a highlight.
hook 'mouseup', 0, (point, event, state) ->
  if @draggingBlock? and not @lastHighlight? and not @dragReplacing
    # Before we put this block into our list of floating blocks,
    # we need to figure out where on the main canvas
    # we are going to render it.
    trackPoint = new @draw.Point(
      point.x + @draggingOffset.x,
      point.y + @draggingOffset.y
    )
    renderPoint = @trackerPointToMain trackPoint
    palettePoint = @trackerPointToPalette trackPoint

    # Remove the block from the tree.
    @undoCapture()
    rememberedSocketOffsets = @spliceRememberedSocketOffsets(@draggingBlock)
    @spliceOut @draggingBlock

    # If we dropped it off in the palette, abort (so as to delete the block).
    palettePoint = @trackerPointToPalette point
    if 0 < palettePoint.x - @scrollOffsets.palette.x < @paletteCanvas.width and
       0 < palettePoint.y - @scrollOffsets.palette.y < @paletteCanvas.height or not
       (-@gutter.offsetWidth < renderPoint.x - @scrollOffsets.main.x < @mainCanvas.width and
       0 < renderPoint.y - @scrollOffsets.main.y< @mainCanvas.height)
      if @draggingBlock is @lassoSelection
        @lassoSelection = null

      @endDrag()
      return

    else if renderPoint.x - @scrollOffsets.main.x < 0
      renderPoint.x = @scrollOffsets.main.x

    # Add the undo operation associated
    # with creating this floating block
    newDocument = new model.Document({roundedSingletons: true})
    newDocument.insert newDocument.start, @draggingBlock
    @pushUndo new FloatingOperation @floatingBlocks.length, newDocument, renderPoint, 'create'

    # Add this block to our list of floating blocks
    @floatingBlocks.push new FloatingBlockRecord(
      newDocument
      renderPoint
    )

    @setCursor @draggingBlock.start

    # TODO write a test for this logic
    for el, i in rememberedSocketOffsets
      @rememberedSockets.push new RememberedSocketRecord(
        new CrossDocumentLocation(
          @floatingBlocks.length,
          new model.Location(el.offset + 1, 'socket')
        ),
        el.text
      )

    # Now that we've done that, we can annul stuff.
    @draggingBlock = null
    @draggingOffset = null
    @lastHighlight = null

    @clearDrag()
    @redrawMain()
    @redrawHighlights()

Editor::performFloatingOperation = (op, direction) ->
  if (op.type is 'create') is (direction is 'forward')
    if @cursor.document > op.index
      @cursor.document += 1

    @floatingBlocks.splice op.index, 0, new FloatingBlockRecord(
      op.block.clone()
      op.position
    )
  else
    # If the cursor's document is about to vanish,
    # put it back in the main tree.
    if @cursor.document is op.index + 1
      @setCursor @tree.start

    @floatingBlocks.splice op.index, 1

class FloatingOperation
  constructor: (@index, @block, @position, @type) ->
    @block = @block.clone()

  toString: -> JSON.stringify({
    index: @index
    block: @block.stringify()
    position: @position.toString()
    type: @type
  })

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
  @paletteElement.appendChild @paletteHeader

  @setPalette @paletteGroups

parseBlock = (mode, code) =>
  block = mode.parse(code).start.next.container
  block.start.prev = block.end.next = null
  block.setParent null
  return block

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
      # hide the header if there is only one group, and it has no name.
      if @paletteGroups.length is 1 and !paletteGroup.name
        paletteHeaderRow.style.height = 0

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
      newBlock = parseBlock(@mode, data.block)
      expansion = data.expansion or null
      newPaletteBlocks.push
        block: newBlock
        expansion: expansion
        title: data.title
        id: data.id

    paletteGroupBlocks = newPaletteBlocks

    # When we click this element,
    # we should switch to it in the palette.
    updatePalette = =>
      # Record that we are the selected group now
      @currentPaletteGroup = paletteGroup.name
      @currentPaletteBlocks = paletteGroupBlocks
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
      @rebuildPalette()
      @fireEvent 'selectpalette', [paletteGroup.name]

    clickHandler = =>
      do updatePalette

    paletteGroupHeader.addEventListener 'click', clickHandler
    paletteGroupHeader.addEventListener 'touchstart', clickHandler

    # If we are the first element, make us the selected palette group.
    if i is 0
      do updatePalette

  @resizePalette()
  @resizePaletteHighlight()

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

    for entry in @currentPaletteBlocks
      hitTestResult = @hitTest palettePoint, entry.block, @paletteView

      if hitTestResult?
        @clickedBlock = entry.block
        @clickedPoint = point
        @clickedBlockPaletteEntry = entry
        state.consumedHitTest = true
        @fireEvent 'pickblock', [entry.id]
        return

  @clickedBlockPaletteEntry = null

# PALETTE HIGHLIGHT CODE
# ================================
hook 'populate', 1, ->
  @paletteHighlightCanvas = document.createElement 'canvas'
  @paletteHighlightCanvas.className = 'droplet-palette-highlight-canvas'
  @paletteHighlightCtx = @paletteHighlightCanvas.getContext '2d'

  @paletteHighlightPath = null
  @currentHighlightedPaletteBlock = null

  @paletteElement.appendChild @paletteHighlightCanvas

Editor::resizePaletteHighlight = ->
  @paletteHighlightCanvas.style.top = @paletteHeader.offsetHeight + 'px'
  @paletteHighlightCanvas.width = @paletteCanvas.width
  @paletteHighlightCanvas.height = @paletteCanvas.height

hook 'redraw_palette', 0, ->
  @clearPaletteHighlightCanvas()
  if @currentHighlightedPaletteBlock?
    @paletteHighlightPath.draw @paletteHighlightCtx

hook 'rebuild_palette', 1, ->
  # Remove the existent blocks
  @paletteScrollerStuffing.innerHTML = ''

  @currentHighlightedPaletteBlock = null

  # Add new blocks
  for data in @currentPaletteMetadata
    block = data.block

    hoverDiv = document.createElement 'div'
    hoverDiv.className = 'droplet-hover-div'

    hoverDiv.title = data.title ? block.stringify()

    if data.id?
      hoverDiv.setAttribute 'data-id', data.id

    bounds = @paletteView.getViewNodeFor(block).totalBounds

    hoverDiv.style.top = "#{bounds.y}px"
    hoverDiv.style.left = "#{bounds.x}px"

    # Clip boxes to the width of the palette to prevent x-scrolling. TODO: fix x-scrolling behaviour.
    hoverDiv.style.width = "#{Math.min(bounds.width, Infinity)}px"
    hoverDiv.style.height = "#{bounds.height}px"

    do (block) =>
      hoverDiv.addEventListener 'mousemove', (event) =>
        palettePoint = @trackerPointToPalette new @draw.Point(
            event.clientX, event.clientY)
        if @viewOrChildrenContains block, palettePoint, @paletteView
            @clearPaletteHighlightCanvas()
            @paletteHighlightPath = @getHighlightPath block, {color: '#FF0'}, @paletteView
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

# At populate-time, we need
# to create and append the hidden input
# we will use for text input.
hook 'populate', 1, ->
  @hiddenInput = document.createElement 'textarea'
  @hiddenInput.className = 'droplet-hidden-input'

  @hiddenInput.addEventListener 'focus', =>
    if @cursorAtSocket()
      # Must ensure that @hiddenInput is within the client area
      # or else the other divs under @dropletElement will scroll out of
      # position when @hiddenInput receives keystrokes with focus
      # (left and top should not be closer than 10 pixels from the edge)

      bounds = @view.getViewNodeFor(@getCursor()).bounds[0]
      inputLeft = bounds.x + @mainCanvas.offsetLeft - @scrollOffsets.main.x
      inputLeft = Math.min inputLeft, @dropletElement.clientWidth - 10
      inputLeft = Math.max @mainCanvas.offsetLeft, inputLeft
      @hiddenInput.style.left = inputLeft + 'px'
      inputTop = bounds.y - @scrollOffsets.main.y
      inputTop = Math.min inputTop, @dropletElement.clientHeight - 10
      inputTop = Math.max 0, inputTop
      @hiddenInput.style.top = inputTop + 'px'

  @dropletElement.appendChild @hiddenInput

  # We also need to initialise some fields
  # for knowing what is focused
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
      if @cursorAtSocket()
        @redrawTextInput()

        # Update the dropdown size to match
        # the new length, if it is visible.
        if @dropdownVisible
          @formatDropdown()

Editor::resizeAceElement = ->
  width = @wrapperElement.clientWidth
  if @showPaletteInTextMode and @paletteEnabled
    width -= @paletteWrapper.offsetWidth

  @aceElement.style.width = "#{width}px"
  @aceElement.style.height = "#{@wrapperElement.clientHeight}px"

last_ = (array) -> array[array.length - 1]

# Redraw function for text input
Editor::redrawTextInput = ->
  sameLength = @getCursor().stringify().split('\n').length is @hiddenInput.value.split('\n').length
  dropletDocument = @getCursor().getDocument()

  # Set the value in the model to fit
  # the hidden input value.
  @populateSocket @getCursor(), @hiddenInput.value

  textFocusView = @view.getViewNodeFor @getCursor()

  # Determine the coordinate positions
  # of the typing cursor
  startRow = @getCursor().stringify()[...@hiddenInput.selectionStart].split('\n').length - 1
  endRow = @getCursor().stringify()[...@hiddenInput.selectionEnd].split('\n').length - 1

  # Redraw the main canvas, on top of
  # which we will draw the cursor and
  # highlights.
  if sameLength and startRow is endRow
    line = endRow
    head = @getCursor().start

    until head is dropletDocument.start
      head = head.prev
      if head.type is 'newline' then line++

    treeView = @view.getViewNodeFor dropletDocument

    oldp = helper.deepCopy [
      treeView.glue[line - 1],
      treeView.glue[line],
      treeView.bounds[line].height
    ]

    treeView.layout()

    newp = helper.deepCopy [
      treeView.glue[line - 1],
      treeView.glue[line],
      treeView.bounds[line].height
    ]

    # If the layout has not changed enough to affect
    # anything non-local, only redraw locally.
    if helper.deepEquals newp, oldp
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
  return unless @cursorAtSocket()

  textFocusView = @view.getViewNodeFor @getCursor()

  # Determine the coordinate positions
  # of the typing cursor
  startRow = @getCursor().stringify()[...@hiddenInput.selectionStart].split('\n').length - 1
  endRow = @getCursor().stringify()[...@hiddenInput.selectionEnd].split('\n').length - 1

  lines = @getCursor().stringify().split '\n'

  startPosition = textFocusView.bounds[startRow].x + @view.opts.textPadding +
    @mainCtx.measureText(last_(@getCursor().stringify()[...@hiddenInput.selectionStart].split('\n'))).width +
    (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)

  endPosition = textFocusView.bounds[endRow].x + @view.opts.textPadding +
    @mainCtx.measureText(last_(@getCursor().stringify()[...@hiddenInput.selectionEnd].split('\n'))).width +
    (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)

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
      @cursorCtx.fillRect startPosition,
        textFocusView.bounds[startRow].y + @view.opts.textPadding
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

hook 'mousedown', 7, ->
  @hideDropdown()


# If we can, try to reparse the focus
# value.
#
# When reparsing occurs, we first try to treat the socket
# as a separate block (inserting parentheses, etc), then fall
# back on reparsing it with original text before giving up.
#
# For instance:
#
# (a * b)
#   -> edits [b] to [b + c]
#   -> reparse to b + c
#   -> inserts with parens to (a * (b + c))
#   -> finished.
#
# OR
#
# function (a) {}
#   -> edits [a] to [a, b]
#   -> reparse to a, b
#   -> inserts with parens to function((a, b)) {}
#   -> FAILS.
#   -> Fall back to raw reparsing the parent with unparenthesized text
#   -> Reparses function(a, b) {} with two paremeters.
#   -> Finsihed.
Editor::reparse = (list, recovery, updates = [], originalTrigger = list) ->
  # Don't reparse sockets. When we reparse sockets,
  # reparse them first, then try reparsing their parent and
  # make sure everything checks out.
  if list.start.type is 'socketStart'
    return if list.start.next is list.end

    originalText = list.textContent()
    @reparse new model.List(list.start.next, list.end.prev), recovery, updates, originalTrigger

    # Try reparsing the parent again after the reparse. If it fails,
    # repopulate with the original text and try again.
    unless @reparse list.parent, recovery, updates, originalTrigger
      @populateSocket list, originalText
      @reparse list.parent, recovery, updates, originalTrigger
    return

  parent = list.start.parent
  context = (list.start.container ? list.start.parent).parseContext

  try
    newList = @mode.parse list.stringifyInPlace(),{
      wrapAtRoot: parent.type isnt 'socket'
      context: context
    }
  catch e
    try
      newList = @mode.parse recovery(list.stringifyInPlace()), {
        wrapAtRoot: parent.type isnt 'socket'
        context: context
      }
    catch e
      # Seek a parent that is not a socket
      # (since we should never reparse just a socket)
      while parent? and parent.type is 'socket'
        parent = parent.parent

      # Attempt to bubble up to the parent
      if parent?
        return @reparse parent, recovery, updates, originalTrigger
      else
        @markBlock originalTrigger, {color: '#F00'}
        return false

  return if newList.start.next is newList.end

  # Exclude the document start and end tags
  newList = new model.List newList.start.next, newList.end.prev

  # Prepare the new node for insertion
  newList.traverseOneLevel (head) =>
    @prepareNode head, parent

  @replace list, newList, updates

  @redrawMain()
  return true

Editor::setTextSelectionRange = (selectionStart, selectionEnd) ->
  if selectionStart? and not selectionEnd?
    selectionEnd = selectionStart

  # Focus the hidden input.
  if @cursorAtSocket()
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

Editor::cursorAtSocket = -> @getCursor().type is 'socket'

Editor::populateSocket = (socket, string) ->
  unless socket.textContent() is string
    lines = string.split '\n'

    unless socket.start.next is socket.end
      @spliceOut new model.List socket.start.next, socket.end.prev

    first = last = new model.TextToken lines[0]
    for line, i in lines when i > 0
      last = helper.connect last, new model.NewlineToken()
      last = helper.connect last, new model.TextToken line

    @spliceIn (new model.List(first, last)), socket.start

Editor::populateBlock = (block, string) ->
  newBlock = @mode.parse(string, wrapAtRoot: false).start.next.container
  if newBlock
    # Find the first token before the block
    # that will still be around after the
    # block has been removed
    location = block.start.prev
    while location?.type is 'newline' and not (
          location.prev?.type is 'indentStart' and
          location.prev.container.end is block.end.next)
      location = location.prev
    @spliceOut block
    @spliceIn newBlock, location
    return true
  return false

# Convenience hit-testing function
Editor::hitTestTextInput = (point, block) ->
  head = block.start
  while head?
    if head.type is 'socketStart' and head.container.isDroppable() and
        @view.getViewNodeFor(head.container).path.contains point
      return head.container
    head = head.next

  return null

# Convenience functions for setting
# the text input selection, given
# points on the main canvas.
Editor::getTextPosition = (point) ->
  textFocusView = @view.getViewNodeFor @getCursor()

  row = Math.floor((point.y - textFocusView.bounds[0].y) / (@fontSize + 2 * @view.opts.padding))

  row = Math.max row, 0
  row = Math.min row, textFocusView.lineLength - 1

  column = Math.max 0, Math.round((point.x - textFocusView.bounds[row].x - @view.opts.textPadding - (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)) / @mainCtx.measureText(' ').width)

  lines = @getCursor().stringify().split('\n')[..row]
  lines[lines.length - 1] = lines[lines.length - 1][...column]

  return lines.join('\n').length

Editor::setTextInputAnchor = (point) ->
  @textInputAnchor = @textInputHead = @getTextPosition point
  @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

Editor::selectDoubleClick = (point) ->
  position = @getTextPosition point

  before = @getCursor().stringify()[...position].match(/\w*$/)[0]?.length ? 0
  after = @getCursor().stringify()[position..].match(/^\w*/)[0]?.length ? 0

  @textInputAnchor = position - before
  @textInputHead = position + after

  @hiddenInput.setSelectionRange @textInputAnchor, @textInputHead

Editor::setTextInputHead = (point) ->
  @textInputHead = @getTextPosition point
  @hiddenInput.setSelectionRange Math.min(@textInputAnchor, @textInputHead), Math.max(@textInputAnchor, @textInputHead)

# On mousedown, we will want to start
# selections and focus text inputs
# if we apply.

Editor::handleTextInputClick = (mainPoint, dropletDocument) ->
  hitTestResult = @hitTestTextInput mainPoint, dropletDocument

  # If they have clicked a socket,
  # focus it.
  if hitTestResult?
    unless hitTestResult is @getCursor()
      if hitTestResult.editable()
        @undoCapture()
        @setCursor hitTestResult
        @redrawMain()

      if hitTestResult.hasDropdown() and ((not hitTestResult.editable()) or
          mainPoint.x - @view.getViewNodeFor(hitTestResult).bounds[0].x < helper.DROPDOWN_ARROW_WIDTH)
        @showDropdown hitTestResult

      @textInputSelecting = false

    else
      if @getCursor().hasDropdown() and
          mainPoint.x - @view.getViewNodeFor(hitTestResult).bounds[0].x < helper.DROPDOWN_ARROW_WIDTH
        @showDropdown()

      @setTextInputAnchor mainPoint
      @redrawTextInput()

      @textInputSelecting = true

    # Now that we have focused the text element
    # in the Droplet model, focus the hidden input.
    #
    # It is important that this be done after the Droplet model
    # has focused its text element, because
    # the hidden input moves on the focus() event to
    # the currently-focused Droplet element to make
    # mobile screen scroll properly.
    @hiddenInput.focus()

    return true
  else
    return false

# Create the dropdown DOM element at populate time.
hook 'populate', 0, ->
  @dropdownElement = document.createElement 'div'
  @dropdownElement.className = 'droplet-dropdown'
  @wrapperElement.appendChild @dropdownElement

  @dropdownElement.innerHTML = ''
  @dropdownElement.style.display = 'inline-block'
  @dropdownVisible = false

# Update the dropdown to match
# the current text focus font and size.
Editor::formatDropdown = (socket = @getCursor()) ->
  @dropdownElement.style.fontFamily = @fontFamily
  @dropdownElement.style.fontSize = @fontSize
  @dropdownElement.style.minWidth = @view.getViewNodeFor(socket).bounds[0].width

Editor::getDropdownList = (socket) ->
  result = socket.dropdown
  if result.generate
    result = result.generate
  if 'function' is typeof result
    result = socket.dropdown()
  else
    result = socket.dropdown
  if result.options
    result = result.options
  return result.map (x) ->
    if 'string' is typeof x then { text: x, display: x } else x

Editor::showDropdown = (socket = @getCursor()) ->
  @dropdownVisible = true

  dropdownItems = []

  @dropdownElement.innerHTML = ''
  @dropdownElement.style.display = 'inline-block'

  @formatDropdown socket

  for el, i in @getDropdownList(socket) then do (el) =>
    div = document.createElement 'div'
    div.innerHTML = el.display
    div.className = 'droplet-dropdown-item'

    dropdownItems.push div

    div.style.paddingLeft = helper.DROPDOWN_ARROW_WIDTH

    setText = (text) =>
      @undoCapture()

      # Attempting to populate the socket after the dropdown has closed should no-op
      if (not @cursorAtSocket()) or @dropdownElement.style.display == 'none'
        return

      @populateSocket @getCursor(), text
      @hiddenInput.value = text

      @redrawMain()
      @hideDropdown()

    div.addEventListener 'mouseup', ->
      if el.click
        el.click(setText)
      else
        setText(el.text)

    @dropdownElement.appendChild div

  @dropdownElement.style.top = '-9999px'
  @dropdownElement.style.left = '-9999px'

  # Wait for a render. Then,
  # if the div is scrolled vertically, add
  # some padding on the right. After checking for this,
  # move the dropdown element into position
  setTimeout (=>
    if @dropdownElement.offsetHeight < @dropdownElement.scrollHeight
      for el in dropdownItems
        el.style.paddingRight = DROPDOWN_SCROLLBAR_PADDING

    location = @view.getViewNodeFor(socket).bounds[0]

    @dropdownElement.style.top = location.y + @fontSize - @scrollOffsets.main.y + 'px'
    @dropdownElement.style.left = location.x - @scrollOffsets.main.x + @dropletElement.offsetLeft + @mainCanvas.offsetLeft + 'px'
    @dropdownElement.style.minWidth = location.width + 'px'
  ), 0

Editor::hideDropdown = ->
  @dropdownVisible = false
  @dropdownElement.style.display = 'none'
  @dropletElement.focus()

hook 'dblclick', 0, (point, event, state) ->
  # If someone else already took this click, return.
  if state.consumedHitTest then return

  for dropletDocument in @getDocuments()
    # Otherwise, look for a socket that
    # the user has clicked
    mainPoint = @trackerPointToMain point
    hitTestResult = @hitTestTextInput mainPoint, @tree

    # If they have clicked a socket,
    # focus it, and
    unless hitTestResult is @getCursor()
      if hitTestResult? and hitTestResult.editable()
        @redrawMain()
        hitTestResult = @hitTestTextInput mainPoint, @tree

    if hitTestResult? and hitTestResult.editable()
      @setCursor hitTestResult
      @redrawMain()

      setTimeout (=>
        @selectDoubleClick mainPoint
        @redrawTextInput()

        @textInputSelecting = false
      ), 0

      state.consumedHitTest = true
      return

# On mousemove, if we are selecting,
# we want to update the selection
# to match the mouse.
hook 'mousemove', 0, (point, event, state) ->
  if @textInputSelecting
    unless @cursorAtSocket()
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
  @lassoSelection = null

  @dropletElement.appendChild @lassoSelectCanvas

# Conveneince function for clearing
# the lasso select canvas
Editor::clearLassoSelectCanvas = ->
  @lassoSelectCtx.clearRect 0, 0, @lassoSelectCanvas.width, @lassoSelectCanvas.height

# Deal with resize for the lasso
# select canvas
Editor::resizeLassoCanvas = ->
  @lassoSelectCanvas.width = @dropletElement.offsetWidth - @gutter.offsetWidth
  @lassoSelectCanvas.style.width = "#{@lassoSelectCanvas.width}px"

  @lassoSelectCanvas.height = @dropletElement.offsetHeight
  @lassoSelectCanvas.style.height = "#{@lassoSelectCanvas.height}px"

  @lassoSelectCanvas.style.left = "#{@mainCanvas.offsetLeft}px"

Editor::clearLassoSelection = ->
  @lassoSelection = null
  @redrawMain()

# On mousedown, if nobody has taken
# a hit test yet, start a lasso select.
hook 'mousedown', 0, (point, event, state) ->
  # Even if someone has taken it, we
  # should remove the lasso segment that is
  # already there.
  unless state.clickedLassoSelection then @clearLassoSelection()

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

    findLassoSelect = (dropletDocument) =>
      first = dropletDocument.start
      until (not first?) or first.type is 'blockStart' and @view.getViewNodeFor(first.container).path.intersects lassoRectangle
        first = first.next

      last = dropletDocument.end
      until (not last?) or last.type is 'blockEnd' and @view.getViewNodeFor(last.container).path.intersects lassoRectangle
        last = last.prev

      @clearLassoSelectCanvas(); @clearHighlightCanvas()

      @lassoSelectCtx.strokeStyle = '#00f'
      @lassoSelectCtx.strokeRect lassoRectangle.x - @scrollOffsets.main.x,
        lassoRectangle.y - @scrollOffsets.main.y,
        lassoRectangle.width,
        lassoRectangle.height

      if first and last?
        [first, last] = validateLassoSelection dropletDocument, first, last
        @lassoSelection = new model.List first, last
        @redrawLassoHighlight()
        return true
      else
        @lassoSelection = null
        return false

    unless @lassoSelectionDocument? and findLassoSelect @lassoSelectionDocument
      for dropletDocument in @getDocuments()
        if findLassoSelect dropletDocument
          @lassoSelectionDocument = dropletDocument
          break

Editor::redrawLassoHighlight = ->
  if @lassoSelection?
    mainCanvasRectangle = new @draw.Rectangle(
      @scrollOffsets.main.x,
      @scrollOffsets.main.y,
      @mainCanvas.width,
      @mainCanvas.height
    )
    lassoView = @view.getViewNodeFor(@lassoSelection)
    lassoView.absorbCache()
    lassoView.draw @highlightCtx, mainCanvasRectangle, {selected: true}
    @maskFloatingPaths(@lassoSelection.start.getDocument())

Editor::maskFloatingPaths = (dropletDocument) ->
  for record, i in @floatingBlocks by -1
    if record.block is dropletDocument
      break
    else
      @highlightCtx.save()
      record.grayBoxPath.clip(@highlightCtx)
      record.grayBoxPath.bounds().clearRect(@highlightCtx)
      @highlightCtx.restore()

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
    if @lassoSelection?
      # Move the cursor to the selection
      @setCursor @lassoSelection.end

    @lassoSelectAnchor = null
    @clearLassoSelectCanvas()

    @redrawMain()
  @lassoSelectionDocument = null

# On mousedown, we might want to
# pick a selected segment up; check.
hook 'mousedown', 3, (point, event, state) ->
  if state.consumedHitTest then return

  if @lassoSelection? and @hitTest(@trackerPointToMain(point), @lassoSelection)?
    @clickedBlock = @lassoSelection
    @clickedBlockPaletteEntry = null
    @clickedPoint = point

    state.consumedHitTest = true
    state.clickedLassoSelection = true

# CURSOR OPERATION SUPPORT
# ================================
hook 'populate', 0, ->
  @cursor = new CrossDocumentLocation(0, new model.Location(0, 'documentStart'))

class CrossDocumentLocation
  constructor: (@document, @location) ->

  is: (other) -> @location.is(other.location) and @document is other.document

  clone: ->
    new CrossDocumentLocation(
      @document,
      @location.clone()
    )

Editor::validCursorPosition = (destination) ->
  return destination.type in ['documentStart', 'indentStart'] or
         destination.type is 'blockEnd' and destination.parent.type in ['document', 'indent'] or
         destination.type is 'socketStart' and destination.container.editable()

# A cursor is only allowed to be on a line.
Editor::setCursor = (destination, validate = (-> true), direction = 'after') ->
  if destination? and destination instanceof CrossDocumentLocation
    destination = @fromCrossDocumentLocation(destination)

  # Abort if there is no destination (usually means
  # someone wants to travel outside the document)
  return unless destination? and @inDisplay destination

  # Now set the new cursor
  if destination instanceof model.Container
    destination = destination.start

  until @validCursorPosition(destination) and validate(destination)
    destination = (if direction is 'after' then destination.next else destination.prev)
    return unless destination?

  destination = @toCrossDocumentLocation destination

  # If the cursor was at a text input, reparse the old one
  if @cursorAtSocket() and not @cursor.is(destination)
    @reparse @getCursor(), null, (if destination.document is @cursor.document then [destination.location] else [])
    @hiddenInput.blur()
    @dropletElement.focus()

  @cursor = destination

  # If we have messed up (usually because
  # of a reparse), scramble to find a nearby
  # okay place for the cursor
  @correctCursor()

  @redrawMain()
  @highlightFlashShow()
  @redrawHighlights()

  # If we are now at a text input, populate the hidden input
  if @cursorAtSocket()
    if @getCursor()?.id of @extraMarks
      delete @extraMarks[focus?.id]
    @undoCapture()
    @hiddenInput.value = @getCursor().textContent()
    @hiddenInput.focus()
    {start, end} = @mode.getDefaultSelectionRange @hiddenInput.value
    @setTextSelectionRange start, end

Editor::determineCursorPosition = ->
  # Do enough of the redraw to get the bounds
  @view.getViewNodeFor(@tree).layout 0, @nubbyHeight

  # Get a cursor that is in the model
  cursor = @getCursor()

  if cursor.type is 'documentStart'
    bound = @view.getViewNodeFor(cursor.container).bounds[0]
    return new @draw.Point bound.x, bound.y

  else if cursor.type is 'indentStart'
    line = if cursor.next.type is 'newline' then 1 else 0
    bound = @view.getViewNodeFor(cursor.container).bounds[line]
    return new @draw.Point bound.x, bound.y

  else
    line = @getCursor().getTextLocation().row - cursor.parent.getTextLocation().row
    bound = @view.getViewNodeFor(cursor.parent).bounds[line]
    return new @draw.Point bound.x, bound.bottom()

Editor::getCursor = ->
  cursor = @fromCrossDocumentLocation @cursor

  if cursor.type is 'socketStart'
    return cursor.container
  else
    return cursor

Editor::scrollCursorIntoPosition = ->
  axis = @determineCursorPosition().y

  if axis - @scrollOffsets.main.y < 0
    @mainScroller.scrollTop = axis
  else if axis - @scrollOffsets.main.y > @mainCanvas.height
    @mainScroller.scrollTop = axis - @mainCanvas.height

  @mainScroller.scrollLeft = 0

# Pressing the up-arrow moves the cursor up.
hook 'keydown', 0, (event, state) ->
  if event.which is UP_ARROW_KEY
    @clearLassoSelection()
    prev = @getCursor().prev ? @getCursor().start?.prev
    @setCursor prev, ((token) -> token.type isnt 'socketStart'), 'before'
    @scrollCursorIntoPosition()
  else if event.which is DOWN_ARROW_KEY
    @clearLassoSelection()
    next = @getCursor().next ? @getCursor().end?.next
    @setCursor next, ((token) -> token.type isnt 'socketStart'), 'after'
    @scrollCursorIntoPosition()
  else if event.which is RIGHT_ARROW_KEY and
      (not @cursorAtSocket() or
      @hiddenInput.selectionStart is @hiddenInput.value.length)
    @clearLassoSelection()
    next = @getCursor().next ? @getCursor().end?.next
    @setCursor next, null, 'after'
    @scrollCursorIntoPosition()
    event.preventDefault()
  else if event.which is LEFT_ARROW_KEY and
      (not @cursorAtSocket() or
      @hiddenInput.selectionEnd is 0)
    @clearLassoSelection()
    prev = @getCursor().prev ? @getCursor().start?.prev
    @setCursor prev, null, 'before'
    @scrollCursorIntoPosition()
    event.preventDefault()

hook 'keydown', 0, (event, state) ->
  if event.which isnt TAB_KEY then return

  if event.shiftKey
    prev = @getCursor().prev ? @getCursor().start?.prev
    @setCursor prev, ((token) -> token.type is 'socketStart'), 'before'
  else
    next = @getCursor().next ? @getCursor().end?.next
    @setCursor next, ((token) -> token.type is 'socketStart'), 'after'
  event.preventDefault()

Editor::deleteAtCursor = ->
  if @getCursor().type is 'blockEnd'
    block = @getCursor().container
  else if @getCursor().type is 'indentStart'
    block = @getCursor().parent
  else
    return

  @setCursor block.start, null, 'before'
  @undoCapture()
  @spliceOut block
  @redrawMain()

hook 'keydown', 0, (event, state) ->
  if @readOnly
    return
  if event.which isnt BACKSPACE_KEY
    return
  if state.capturedBackspace
    return

  # We don't want to interrupt any text input editing
  # sessions. We will, however, delete a handwritten
  # block if it is currently empty.
  if @lassoSelection?
    @deleteLassoSelection()
    event.preventDefault()
    return false

  else if not @cursorAtSocket() or
      (@hiddenInput.value.length is 0 and @getCursor().handwritten)
    @deleteAtCursor()
    state.capturedBackspace = true
    event.preventDefault()
    return false

  return true

Editor::deleteLassoSelection = ->
  unless @lassoSelection?
    if DEBUG_FLAG
      throw new Error 'Cannot delete nonexistent lasso segment'
    return null

  cursorTarget = @lassoSelection.start.prev

  @spliceOut @lassoSelection
  @lassoSelection = null

  @setCursor cursorTarget

  @redrawMain()

# HANDWRITTEN BLOCK SUPPORT
# ================================

hook 'populate', 0, ->
  @handwrittenBlocks = []

hook 'keydown', 0, (event, state) ->
  if @readOnly
    return
  if event.which is ENTER_KEY
    if not @cursorAtSocket() and not event.shiftKey and not event.ctrlKey and not event.metaKey
      # Construct the block; flag the socket as handwritten
      newBlock = new model.Block(); newSocket = new model.Socket @mode.empty, Infinity
      newSocket.handwritten = true; newSocket.setParent newBlock
      helper.connect newBlock.start, newSocket.start
      helper.connect newSocket.end, newBlock.end

      # Seek a place near the cursor we can actually
      # put a block.
      head = @getCursor()
      while head.type is 'newline'
        head = head.prev

      @spliceIn newBlock, head #MUTATION

      @redrawMain()

      @newHandwrittenSocket = newSocket

    else if @cursorAtSocket() and not event.shiftKey
      @hiddenInput.blur()
      @dropletElement.focus()
      @setCursor @cursor, (token) -> token.type isnt 'socketStart'
      @redrawMain()

hook 'keyup', 0, (event, state) ->
  if @readOnly
    return
  # prevents routing the initial enter keypress to a new handwritten
  # block by focusing the block only after the enter key is released.
  if event.which is ENTER_KEY
    if @newHandwrittenSocket?
      @setCursor @newHandwrittenSocket
      @newHandwrittenSocket = null

containsCursor = (block) ->
  head = block.start
  until head is block.end
    if head.type is 'cursor' then return true
    head = head.next

  return false

# ANIMATION AND ACE EDITOR SUPPORT
# ================================

Editor::copyAceEditor = ->
  @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'
  @resizeBlockMode()
  return @setValue_raw @getAceValue()

hook 'populate', 1, ->
  @aceElement = document.createElement 'div'
  @aceElement.className = 'droplet-ace'

  @wrapperElement.appendChild @aceElement

  @aceEditor = ace.edit @aceElement

  @aceEditor.setTheme 'ace/theme/chrome'
  @aceEditor.setFontSize 15
  acemode = @options.mode
  if acemode is 'coffeescript' then acemode = 'coffee'
  @aceEditor.getSession().setMode 'ace/mode/' + acemode
  @aceEditor.getSession().setTabSize 2

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
        @aceElement.getBoundingClientRect().left +
        @aceEditor.renderer.$gutterLayer.gutterWidth) -
        @gutter.offsetWidth + 5 # TODO find out where this 5 comes from
    y: (@aceEditor.container.getBoundingClientRect().top -
        @aceElement.getBoundingClientRect().top) -
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

Editor::performMeltAnimation = (fadeTime = 500, translateTime = 1000, cb = ->) ->
  if @currentlyUsingBlocks and not @currentlyAnimating
    @hideDropdown()

    @fireEvent 'statechange', [false]

    @setAceValue @getValue()

    top = @findLineNumberAtCoordinate @scrollOffsets.main.y
    @aceEditor.scrollToLine top

    @aceEditor.resize true

    @redrawMain noText: true

    # Hide scrollbars and increase width
    if @mainScroller.scrollWidth > @mainScroller.offsetWidth
      @mainScroller.style.overflowX = 'scroll'
    else
      @mainScroller.style.overflowX = 'hidden'
    @mainScroller.style.overflowY = 'hidden'
    @dropletElement.style.width = @wrapperElement.clientWidth + 'px'

    @currentlyUsingBlocks = false; @currentlyAnimating = @currentlyAnimating_suppressRedraw = true

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

      div.className = 'droplet-transitioning-element droplet-transitioning-gutter droplet-gutter-line'
      # Add annotation
      if @annotations[line]?
        div.className += ' droplet_' + getMostSevereAnnotationType(@annotations[line])
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

    paletteDisappearingWithMelt = @paletteEnabled and not @showPaletteInTextMode

    if paletteDisappearingWithMelt
      # Move the palette header into the background
      @paletteHeader.style.zIndex = 0

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

      # Translate the ACE editor div into frame.
      @aceElement.style.top = '0px'
      if @showPaletteInTextMode and @paletteEnabled
        @aceElement.style.left = "#{@paletteWrapper.offsetWidth}px"
      else
        @aceElement.style.left = '0px'

      if paletteDisappearingWithMelt
        @paletteWrapper.style.top = '-9999px'
        @paletteWrapper.style.left = '-9999px'

      @dropletElement.style.top = '-9999px'
      @dropletElement.style.left = '-9999px'

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
      if setValueResult.error
        @fireEvent 'parseerror', [setValueResult.error]
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
      @dropletElement.style.width = @wrapperElement.clientWidth + 'px'

      @redrawMain noText: true

      @currentlyAnimating_suppressRedraw = true

      @aceElement.style.top = "-9999px"
      @aceElement.style.left = "-9999px"

      paletteAppearingWithFreeze = @paletteEnabled and not @showPaletteInTextMode

      if paletteAppearingWithFreeze
        @paletteWrapper.style.top = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"
        @paletteHeader.style.zIndex = 0

      @dropletElement.style.top = "0px"
      if @paletteEnabled and not paletteAppearingWithFreeze
        @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"
      else
        @dropletElement.style.left = "0px"

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

        div.className = 'droplet-transitioning-element droplet-transitioning-gutter droplet-gutter-line'
        # Add annotation
        if @annotations[line]?
          div.className += ' droplet_' + getMostSevereAnnotationType(@annotations[line])
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

      @dropletElement.style.transition = "left #{fadeTime}ms"

      if paletteAppearingWithFreeze
        @paletteWrapper.style.transition = @dropletElement.style.transition
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

Editor::enablePalette = (enabled) ->
  if not @currentlyAnimating and @paletteEnabled != enabled
    @paletteEnabled = enabled
    @currentlyAnimating = true

    if @currentlyUsingBlocks
      activeElement = @dropletElement
    else
      activeElement = @aceElement

    if not @paletteEnabled
      activeElement.style.transition =
        @paletteWrapper.style.transition = "left 500ms"

      activeElement.style.left = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

      @paletteHeader.style.zIndex = 0

      @resize()

      setTimeout (=>
        activeElement.style.transition =
          @paletteWrapper.style.transition = ''

        @paletteWrapper.style.top = '-9999px'
        @paletteWrapper.style.left = '-9999px'

        @currentlyAnimating = false
      ), 500

    else
      @paletteWrapper.style.top = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"
      @paletteHeader.style.zIndex = 257

      setTimeout (=>
        activeElement.style.transition =
          @paletteWrapper.style.transition = "left 500ms"

        activeElement.style.left = "#{@paletteWrapper.offsetWidth}px"
        @paletteWrapper.style.left = '0px'

        setTimeout (=>
          activeElement.style.transition =
            @paletteWrapper.style.transition = ''

          @resize()

          @currentlyAnimating = false
        ), 500
      ), 0


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

  # Prevent scrolling on wrapper element
  @wrapperElement.addEventListener 'scroll', =>
    @wrapperElement.scrollTop = @wrapperElement.scrollLeft = 0

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
  @paletteElement.appendChild @paletteScroller

  @paletteScroller.addEventListener 'scroll', =>
    @scrollOffsets.palette.y = @paletteScroller.scrollTop

    # Temporarily ignoring x-scroll to fix bad x-scrolling behaviour
    # when dragging blocks out of the palette. TODO: fix x-scrolling behaviour.
    # @scrollOffsets.palette.x = @paletteScroller.scrollLeft

    @paletteCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y
    @paletteHighlightCtx.setTransform 1, 0, 0, 1, -@scrollOffsets.palette.x, -@scrollOffsets.palette.y

    # redraw the bits of the palette
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

  # We add some extra height to the bottom
  # of the document so that the last block isn't
  # jammed up against the edge of the screen.
  #
  # Default this extra space to fontSize (approx. 1 line).
  @mainScrollerStuffing.style.height = "#{bounds.bottom() +
    (@options.extraBottomHeight ? @fontSize)}px"

hook 'redraw_palette', 0, ->
  bounds = new @draw.NoRectangle()
  for entry in @currentPaletteBlocks
    bounds.unite @paletteView.getViewNodeFor(entry.block).getBounds()

  # For now, we will comment out this line
  # due to bugs
  #@paletteScrollerStuffing.style.width = "#{bounds.right()}px"
  @paletteScrollerStuffing.style.height = "#{bounds.bottom()}px"

# MULTIPLE FONT SIZE SUPPORT
# ================================
hook 'populate', 0, ->
  @fontSize = 15
  @fontFamily = 'Courier New'

  metrics = helper.fontMetrics(@fontFamily, @fontSize)
  @fontAscent = metrics.prettytop
  @fontDescent = metrics.descent

Editor::setFontSize_raw = (fontSize) ->
  unless @fontSize is fontSize
    @fontSize = fontSize

    @paletteHeader.style.fontSize = "#{fontSize}px"
    @gutter.style.fontSize = "#{fontSize}px"
    @tooltipElement.style.fontSize = "#{fontSize}px"

    @view.opts.textHeight =
      @dragView.opts.textHeight = helper.getFontHeight @fontFamily, @fontSize

    metrics = helper.fontMetrics(@fontFamily, @fontSize)
    @fontAscent = metrics.prettytop
    @fontDescent = metrics.descent

    @view.clearCache()

    @dragView.clearCache()

    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'

    @redrawMain()
    @rebuildPalette()

Editor::setFontFamily = (fontFamily) ->
  @draw.setGlobalFontFamily fontFamily

  @fontFamily = fontFamily

  @view.opts.textHeight = helper.getFontHeight @fontFamily, @fontSize
  @fontAscent = helper.fontMetrics(@fontFamily, @fontSize).prettytop

  @view.clearCache(); @dragView.clearCache()
  @gutter.style.fontFamily = fontFamily
  @tooltipElement.style.fontFamily = fontFamily

  @redrawMain()
  @rebuildPalette()

Editor::setFontSize = (fontSize) ->
  @setFontSize_raw fontSize
  @resizeBlockMode()

# LINE MARKING SUPPORT
# ================================

hook 'populate', 0, ->
  @markedLines = {}
  @markedBlocks = {}; @nextMarkedBlockId = 0
  @extraMarks = {}

Editor::getHighlightPath = (model, style, view = @view) ->
  path = view.getViewNodeFor(model).path.clone()

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

  @redrawHighlights()

Editor::markBlock = (block, style) ->
  key = @nextMarkedBlockId++

  @markedBlocks[key] = {
    model: block
    style: style
  }

  return key

# ## Mark
# `mark(line, col, style)` will mark the first block after the given (line, col) coordinate
# with the given style.
Editor::mark = (location, style) ->
  block = @tree.getFromTextLocation location
  block = block.container ? block

  # `key` is a unique identifier for this
  # mark, to be used later for removal
  key = @nextMarkedBlockId++

  @markedBlocks[key] = {
    model: block
    style: style
  }

  @redrawHighlights()

  # Return `key`, so that the caller can
  # remove the line mark later with unmark(key)
  return key

Editor::unmark = (key) ->
  delete @markedBlocks[key]
  return true

Editor::unmarkLine = (line) ->
  delete @markedLines[line]

  @redrawMain()

Editor::clearLineMarks = ->
  @markedLines = @markedBlocks = {}

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

# Whitespace trimming hack enable/disable
# setter
hook 'populate', 0, ->
  @trimWhitespace = false

Editor::setTrimWhitespace = (trimWhitespace) ->
  @trimWhitespace = trimWhitespace

Editor::setValue_raw = (value) ->
  try
    if @trimWhitespace then value = value.trim()

    newParse = @mode.parse value, wrapAtRoot: true

    unless @tree.start.next is @tree.end
      removal = new model.List @tree.start.next, @tree.end.prev
      @spliceOut removal

    unless newParse.start.next is newParse.end
      @spliceIn new model.List(newParse.start.next, newParse.end.prev), @tree.start

    @removeBlankLines()
    @redrawMain()

    return success: true

  catch e
    return success: false, error: e

Editor::setValue = (value) ->

  oldScrollTop = @aceEditor.session.getScrollTop()

  @setAceValue value
  @resizeTextMode()

  @aceEditor.session.setScrollTop oldScrollTop

  if @currentlyUsingBlocks
    result = @setValue_raw value
    if result.success is false
      @setEditorState false
      @aceEditor.setValue value
      if result.error
        @fireEvent 'parseerror', [result.error]

Editor::addEmptyLine = (str) ->
  if str.length is 0 or str[str.length - 1] is '\n'
    return str
  else
    return str + '\n'

Editor::getValue = ->
  if @currentlyUsingBlocks
    return @addEmptyLine @tree.stringify()
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
    unless @currentlyUsingBlocks
      @setValue @getAceValue()

    @dropletElement.style.top = '0px'
    if @paletteEnabled
      @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'
      @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"
    else
      @paletteWrapper.style.top = @paletteWrapper.style.left = '-9999px'
      @dropletElement.style.left = '0px'

    @aceElement.style.top = @aceElement.style.left = '-9999px'
    @currentlyUsingBlocks = true

    @lineNumberWrapper.style.display = 'block'

    @mainCanvas.opacity = @paletteWrapper.opacity =
      @highlightCanvas.opacity = 1

    @resizeBlockMode(); @redrawMain()

  else
    @hideDropdown()

    paletteVisibleInNewState = @paletteEnabled and @showPaletteInTextMode

    oldScrollTop = @aceEditor.session.getScrollTop()

    if @currentlyUsingBlocks
      @setAceValue @getValue()

    @aceEditor.resize true

    @aceEditor.session.setScrollTop oldScrollTop

    @dropletElement.style.top = @dropletElement.style.left = '-9999px'
    if paletteVisibleInNewState
      @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'
    else
      @paletteWrapper.style.top = @paletteWrapper.style.left = '-9999px'

    @aceElement.style.top = '0px'
    if paletteVisibleInNewState
      @aceElement.style.left = "#{@paletteWrapper.offsetWidth}px"
    else
      @aceElement.style.left = '0px'

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
  # Ensure that the cursor is not in a socket.
  if @cursorAtSocket()
    @setCursor @cursor, (x) -> x.type isnt 'socketStart'

  @draggingBlock = null
  @draggingOffset = null
  @lastHighlight = null

  @clearDrag()
  @redrawMain()
  return

# PALETTE EVENT
# =================================
hook 'rebuild_palette', 0, ->
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
    event.changedTouches[index].clientX,
    event.changedTouches[index].clientY
  )

  return absolutePoint

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
  @cursorCanvas.width = @dropletElement.offsetWidth - @gutter.offsetWidth
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
  if @lassoSelection? or @draggingBlock? or
      (@cursorAtSocket() and @textInputHighlighted) or
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

# TODO possibly move this next utility function to view?
Editor::viewOrChildrenContains = (model, point, view = @view) ->
  modelView = view.getViewNodeFor model

  if modelView.path.contains point
    return true

  for childObj in modelView.children
    if @viewOrChildrenContains childObj.child, point, view
      return true

  return false

# LINE NUMBER GUTTER CODE
# ================================
hook 'populate', 0, ->
  @gutter = document.createElement 'div'
  @gutter.className = 'droplet-gutter'

  @lineNumberWrapper = document.createElement 'div'
  @gutter.appendChild @lineNumberWrapper

  @gutterVersion = -1
  @lastGutterWidth = null

  @lineNumberTags = {}

  @mainScroller.appendChild @gutter

  # Record of embedder-set annotations
  # and breakpoints used in rendering.
  # Should mirror ace all the time.
  @annotations = {}
  @breakpoints = {}

  @tooltipElement = document.createElement 'div'
  @tooltipElement.className = 'droplet-tooltip'

  @dropletElement.appendChild @tooltipElement

  @aceEditor.on 'guttermousedown', (e) =>
    # Ensure that the click actually happened
    # on a line and not just in gutter space.
    target = e.domEvent.target
    if target.className.indexOf('ace_gutter-cell') is -1
      return

    # Otherwise, get the row and fire a Droplet gutter
    # mousedown event.
    row = e.getDocumentPosition().row
    e.stop()
    @fireEvent 'guttermousedown', [{line: row, event: e.domEvent}]

hook 'mousedown', 11, (point, event, state) ->
  # Check if mousedown within the gutter
  if not @trackerPointIsInGutter(point) then return

  # Find the line that was clicked
  mainPoint = @trackerPointToMain point
  treeView = @view.getViewNodeFor @tree
  clickedLine = @findLineNumberAtCoordinate mainPoint.y
  @fireEvent 'guttermousedown', [{line: clickedLine, event: event}]

  # Prevent other hooks from taking this event
  return true

Editor::setBreakpoint = (row) ->
  # Delegate
  @aceEditor.session.setBreakpoint(row)

  # Add to our own records
  @breakpoints[row] = true

  # Redraw gutter.
  # TODO: if this ends up being a performance issue,
  # selectively apply classes
  @redrawGutter false

Editor::clearBreakpoint = (row) ->
  @aceEditor.session.clearBreakpoint(row)
  @breakpoints[row] = false
  @redrawGutter false

Editor::clearBreakpoints = (row) ->
  @aceEditor.session.clearBreakpoints()
  @breakpoints = {}
  @redrawGutter false

Editor::getBreakpoints = (row) ->
  @aceEditor.session.getBreakpoints()

Editor::setAnnotations = (annotations) ->
  @aceEditor.session.setAnnotations annotations

  @annotations = {}
  for el, i in annotations
    @annotations[el.row] ?= []
    @annotations[el.row].push el

  @redrawGutter false

Editor::resizeGutter = ->
  unless @lastGutterWidth is @aceEditor.renderer.$gutterLayer.gutterWidth
    @lastGutterWidth = @aceEditor.renderer.$gutterLayer.gutterWidth
    @gutter.style.width = @lastGutterWidth + 'px'
    return @resize()
  @gutter.style.height = "#{Math.max(@dropletElement.offsetHeight,
    @mainScrollerStuffing.offsetHeight)}px"

Editor::addLineNumberForLine = (line) ->
  treeView = @view.getViewNodeFor @tree

  if line of @lineNumberTags
    lineDiv = @lineNumberTags[line]

  else
    lineDiv = document.createElement 'div'
    lineDiv.innerText = lineDiv.textContent = line + 1
    @lineNumberTags[line] = lineDiv

  lineDiv.className = 'droplet-gutter-line'

  # Add annotation mouseover text
  # and graphics
  if @annotations[line]?
    lineDiv.className += ' droplet_' + getMostSevereAnnotationType(@annotations[line])

    title = @annotations[line].map((x) -> x.text).join('\n')

    lineDiv.addEventListener 'mouseover', =>
      @tooltipElement.innerText =
        @tooltipElement.textContent = title
      @tooltipElement.style.display = 'block'
    lineDiv.addEventListener 'mousemove', (event) =>
      @tooltipElement.style.left = event.pageX + 'px'
      @tooltipElement.style.top = event.pageY + 'px'
    lineDiv.addEventListener 'mouseout', =>
      @tooltipElement.style.display = 'none'

  # Add breakpoint graphics
  if @breakpoints[line]
    lineDiv.className += ' droplet_breakpoint'

  lineDiv.style.top = "#{treeView.bounds[line].y}px"

  lineDiv.style.paddingTop = "#{treeView.distanceToBase[line].above - @view.opts.textHeight - @fontAscent}px"
  lineDiv.style.paddingBottom = "#{treeView.distanceToBase[line].below - @fontDescent}"

  lineDiv.style.height =  treeView.bounds[line].height + 'px'
  lineDiv.style.fontSize = @fontSize + 'px'

  @lineNumberWrapper.appendChild lineDiv

TYPE_SEVERITY = {
  'error': 2
  'warning': 1
  'info': 0
}
TYPE_FROM_SEVERITY = ['info', 'warning', 'error']
getMostSevereAnnotationType = (arr) ->
  TYPE_FROM_SEVERITY[Math.max.apply(this, arr.map((x) -> TYPE_SEVERITY[x.type]))]

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
  @redrawGutter(changedBox)

Editor::redrawGutter = (changedBox = true) ->
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
    @resizeGutter()

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
    if @readOnly
      return
    if pressedVKey and not @cursorAtSocket()
      str = @copyPasteInput.value; lines = str.split '\n'

      # Strip any common leading indent
      # from all the lines of the pasted tet
      minIndent = lines.map((line) -> line.length - line.trimLeft().length).reduce((a, b) -> Math.min(a, b))
      str = lines.map((line) -> line[minIndent...]).join('\n')
      str = str.replace /^\n*|\n*$/g, ''

      try
        blocks = @mode.parse str
        blocks = new model.List blocks.start.next, blocks.end.prev
      catch e
        blocks = null

      return unless blocks?

      @undoCapture()
      @spliceIn blocks, @getCursor()
      @setCursor blocks.end

      @redrawMain()

      @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length
    else if pressedXKey and @lassoSelection?
      @spliceOut @lassoSelection; @lassoSelection = null
      @redrawMain()

hook 'keydown', 0, (event, state) ->
  if event.which in command_modifiers
    unless @cursorAtSocket()
      x = document.body.scrollLeft
      y = document.body.scrollTop
      @copyPasteInput.focus()
      window.scrollTo(x, y)

      if @lassoSelection?
        @copyPasteInput.value = @lassoSelection.stringifyInPlace()
      @copyPasteInput.setSelectionRange 0, @copyPasteInput.value.length

hook 'keyup', 0, (point, event, state) ->
  if event.which in command_modifiers
    if @cursorAtSocket()
      @hiddenInput.focus()
    else
      @dropletElement.focus()

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

# LINE LOCATION API
# =================
Editor::getLineMetrics = (row) ->
  viewNode = @view.getViewNodeFor @tree
  bounds = (new @view.draw.Rectangle()).copy(viewNode.bounds[row])
  bounds.x += @mainCanvas.offsetLeft + @mainCanvas.offsetParent.offsetLeft
  return {
    bounds: bounds
    distanceToBase: {
      above: viewNode.distanceToBase[row].above
      below: viewNode.distanceToBase[row].below
    }
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
