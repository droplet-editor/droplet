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
GRAY_BLOCK_COLOR = 'rgba(256, 256, 256, 0.5)'
GRAY_BLOCK_BORDER = '#AAA'

userAgent = ''
if typeof(window) isnt 'undefined' and window.navigator?.userAgent
  userAgent = window.navigator.userAgent
isOSX = /OS X/.test(userAgent)
command_modifiers = if isOSX then META_KEYS else CONTROL_KEYS
command_pressed = (e) -> if isOSX then e.metaKey else e.ctrlKey

class PairDict
  constructor: (@pairs) ->

  get: (index) ->
    for el, i in @pairs
      if el[0] is index
        return el[1]

  contains: (index) ->
    @pairs.some (x) -> x[0] is index

  set: (index, value) ->
    for el, i in @pairs
      if el[0] is index
        el[1] = index
        return true
    @pairs.push [index, value]
    return false

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

SVG_STANDARD = helper.SVG_STANDARD

EMBOSS_FILTER_SVG =  """
<svg xlmns="#{SVG_STANDARD}">
  <filter id="dropShadow" x="0" y="0" width="200%" height="200%">
    <feOffset result="offOut" in="SourceAlpha" dx="5" dy="5" />
    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="1" />
    <feBlend in="SourceGraphic" in2="blurOut" out="blendOut" mode="normal" />
    <feComposite in="blendOut" in2="SourceGraphic" k2="0.5" k3="0.5" operator="arithmetic" />
  </filter>
</svg>
"""

# This hook function is for convenience,
# for features to add events that will occur at
# various times in the editor lifecycle.
hook = (event, priority, fn) ->
  unsortedEditorBindings[event].push {
    priority: priority
    fn: fn
  }

class Session
  constructor: (@options, standardViewSettings) ->
    # Option flags
    @readOnly = false
    @paletteGroups = @options.palette
    @showPaletteInTextMode = @options.showPaletteInTextMode ? false
    @paletteEnabled = @options.enablePaletteAtStart ? true
    @dropIntoAceAtLineStart = @options.dropIntoAceAtLineStart ? false
    @allowFloatingBlocks = @options.allowFloatingBlocks ? true

    # By default, attempt to preserve empty sockets when round-tripping
    @options.preserveEmpty ?= true

    # Mode
    @options.mode = @options.mode.replace /$\/ace\/mode\//, ''

    if @options.mode of modes
      @mode = new modes[@options.mode] @options.modeOptions
    else
      @mode = null

    # Instantiate an Droplet editor view
    @view = new view.View helper.extend standardViewSettings, @options.viewSettings ? {}
    @paletteView = new view.View helper.extend {}, standardViewSettings, @options.viewSettings ? {}, {
      showDropdowns: @options.showDropdownInPalette ? false
    }
    @dragView = new view.View helper.extend {}, standardViewSettings, @options.viewSettings ? {}

    # ## Document initialization
    # We start of with an empty document
    @tree = new model.Document()

    # Line markings
    @markedLines = {}
    @markedBlocks = {}; @nextMarkedBlockId = 0
    @extraMarks = {}

    # Undo/redo stack
    @undoStack = []
    @redoStack = []
    @changeEventVersion = 0

    # Floating blocks
    @floatingBlocks = []

    # Cursor
    @cursor = new CrossDocumentLocation(0, new model.Location(0, 'documentStart'))

    # Scrolling
    @scrollOffsets = {
      main: new draw.Point 0, 0
      palette: new draw.Point 0, 0
    }

    # Block toggle
    @currentlyUsingBlocks = true

    # Fonts
    @fontSize = 15
    @fontFamily = 'Courier New'

    metrics = helper.fontMetrics(@fontFamily, @fontSize)
    @fontAscent = metrics.prettytop
    @fontDescent = metrics.descent

    # Remembered sockets
    @rememberedSockets = []

# ## The Editor Class
exports.Editor = class Editor
  constructor: (@aceEditor, @options) ->
    # ## DOM Population
    # This stage of ICE Editor construction populates the given wrapper
    # element with all the necessary ICE editor components.
    @debugging = true

    @options = helper.deepCopy @options

    # ### Wrapper
    # Create the div that will contain all the ICE Editor graphics

    @dropletElement = document.createElement 'div'
    @dropletElement.className = 'droplet-wrapper-div'

    @dropletElement.innerHTML = EMBOSS_FILTER_SVG

    # We give our element a tabIndex so that it can be focused and capture keypresses.
    @dropletElement.tabIndex = 0

    # ### Canvases
    # Create the palette and main canvases

    # A measuring canvas for measuring text
    @measureCanvas = document.createElement 'canvas'
    @measureCtx = @measureCanvas.getContext '2d'

    # Main canvas first
    @mainCanvas = document.createElementNS SVG_STANDARD, 'svg'
    @mainCtxWrapper = document.createElementNS SVG_STANDARD, 'g'
    @mainCtx = document.createElementNS SVG_STANDARD, 'g'
    @mainCanvas.appendChild @mainCtxWrapper
    @mainCtxWrapper.appendChild @mainCtx
    @mainCanvas.setAttribute 'class',  'droplet-main-canvas'
    @mainCanvas.setAttribute 'shape-rendering', 'optimizeSpeed'

    @paletteWrapper = document.createElement 'div'
    @paletteWrapper.className = 'droplet-palette-wrapper'

    @paletteElement = document.createElement 'div'
    @paletteElement.className = 'droplet-palette-element'
    @paletteWrapper.appendChild @paletteElement

    # Then palette canvas
    @paletteCanvas = @paletteCtx = document.createElementNS SVG_STANDARD, 'svg'
    @paletteCanvas.setAttribute 'class',  'droplet-palette-canvas'

    @paletteWrapper.style.position = 'absolute'
    @paletteWrapper.style.left = '0px'
    @paletteWrapper.style.top = '0px'
    @paletteWrapper.style.bottom = '0px'
    @paletteWrapper.style.width = '270px'

    # We will also have to initialize the
    # drag canvas.
    @dragCanvas = @dragCtx = document.createElementNS SVG_STANDARD, 'svg'
    @dragCanvas.setAttribute 'class',  'droplet-drag-canvas'

    @dragCanvas.style.left = '0px'
    @dragCanvas.style.top = '0px'
    @dragCanvas.style.transform = 'translate(-9999px,-9999px)'

    # Instantiate the Droplet views
    @view = new view.View @mainCtx, @standardViewSettings
    @paletteView = new view.View @paletteCtx, helper.extend {}, @standardViewSettings, {
      showDropdowns: @options.showDropdownInPalette ? false
    }
    @dragView = new view.View @dragCtx, @standardViewSettings
    @draw = new draw.Draw(@mainCtx)

    @dropletElement.style.left = @paletteWrapper.clientWidth + 'px'

    @draw = new draw.Draw()

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
      ctx: @measureCtx
      draw: @draw

    # We can be passed a div
    if @aceEditor instanceof Node
      @wrapperElement = @aceEditor

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

    else
      @wrapperElement = document.createElement 'div'
      @wrapperElement.style.position = 'absolute'
      @wrapperElement.style.right = @wrapperElement.style.left = @wrapperElement.style.top = @wrapperElement.style.bottom = '0px'
      @wrapperElement.style.overflow = 'hidden'

      @aceElement = @aceEditor.container
      @aceElement.className += ' droplet-ace'

      @aceEditor.container.parentElement.appendChild @wrapperElement
      @wrapperElement.appendChild @aceEditor.container

    # Append populated divs
    @wrapperElement.appendChild @dropletElement
    @wrapperElement.appendChild @paletteWrapper

    @wrapperElement.style.backgroundColor = '#FFF'

    @currentlyAnimating = false

    @transitionContainer = document.createElement 'div'
    @transitionContainer.className = 'droplet-transition-container'

    @dropletElement.appendChild @transitionContainer

    if @options?
      @session = new Session @options, @standardViewSettings
      @sessions = new PairDict([
        [@aceEditor.getSession(), @session]
      ])
    else
      @session = null
      @sessions = new PairDict []

      @options = {
        extraBottomHeight: 10
      }

    # Sessions are bound to other ace sessions;
    # on ace session change Droplet will also change sessions.
    @aceEditor.on 'changeSession', (e) =>
      if @sessions.contains(e.session)
        @session = @sessions.get(e.session)
        @updateNewSession()
      else if e.session._dropletSession?
        @session = e.session._dropletSession
        @sessions.set(e.session, e.session._dropletSession)
      else
        @session = null
        @setEditorState false

    # Set up event bindings before creating a view
    @bindings = {}

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
      # Ignore mouse clicks that are not the left-button
      if event.type isnt 'mousemove' and event.which isnt 1 then return

      # Ignore mouse clicks whose target is the scrollbar
      if event.target is @mainScroller then return

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

    @resizeBlockMode()

    # Now that we've populated everything, immediately redraw.
    @redrawMain()
    @rebuildPalette()

    # If we were given an unrecognized mode or asked to start in text mode,
    # flip into text mode here
    useBlockMode = @session?.mode? && !@options.textModeAtStart
    # Always call @setEditorState to ensure palette is positioned properly
    @setEditorState useBlockMode

    return this

  setMode: (mode, modeOptions) ->
    modeClass = modes[mode]
    if modeClass
      @options.mode = mode
      @session.mode = new modeClass modeOptions
    else
      @options.mode = null
      @session.mode = null
    @setValue @getValue()

  getMode: ->
    @options.mode

  setReadOnly: (readOnly) ->
    @session.readOnly = readOnly
    @aceEditor.setReadOnly readOnly

  getReadOnly: ->
    @session.readOnly

  # ## Foundational Resize
  # At the editor core, we will need to resize
  # all of the natively-added canvases, as well
  # as the wrapper element, whenever a resize
  # occurs.
  resizeTextMode: ->
    @resizeAceElement()
    @aceEditor.resize true

    if @session?
      @resizePalette()

    return

  resizeBlockMode: ->
    return unless @session?

    @resizeTextMode()

    @dropletElement.style.height = "#{@wrapperElement.offsetHeight}px"
    if @session.paletteEnabled
      @dropletElement.style.left = "#{@paletteWrapper.offsetWidth}px"
      @dropletElement.style.width = "#{@wrapperElement.offsetWidth - @paletteWrapper.offsetWidth}px"
    else
      @dropletElement.style.left = "0px"
      @dropletElement.style.width = "#{@wrapperElement.offsetWidth}px"

    #@resizeGutter()

    @viewports.main.height = @dropletElement.clientHeight
    @viewports.main.width = @dropletElement.clientWidth - @gutter.clientWidth

    @mainCanvas.setAttribute 'width', @dropletElement.clientWidth - @gutter.clientWidth

    @mainCanvas.style.left = "#{@gutter.clientWidth}px"
    @transitionContainer.style.left = "#{@gutter.clientWidth}px"

    @resizePalette()
    @resizePaletteHighlight()
    @resizeNubby()
    @resizeMainScroller()
    @resizeDragCanvas()

    # Re-scroll and redraw main
    @viewports.main.y = @mainScroller.scrollTop
    @viewports.main.x = @mainScroller.scrollLeft

  resizePalette: ->
    for binding in editorBindings.resize_palette
      binding.call this

    unless @session?.currentlyUsingBlocks or @session?.showPaletteInTextMode and @session?.paletteEnabled
     @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

    @rebuildPalette()

  resize: ->
    if @session?.currentlyUsingBlocks #TODO session
      @resizeBlockMode()
    else
      @resizeTextMode()

  updateNewSession: ->
    return unless @session?

    # Force scroll into our position
    offsetY =@session.scrollOffsets.main.y
    offsetX = @session.scrollOffsets.main.x

    @setEditorState @session.currentlyUsingBlocks

    @redrawMain()

    @mainScroller.scrollTop = offsetY
    @mainScroller.scrollLeft = offsetX

    @setPalette @session.paletteGroups

  hasSessionFor: (aceSession) -> @sessions.contains(aceSession)

  bindNewSession: (opts) ->
    if @sessions.contains(@aceEditor.getSession())
      throw new ArgumentError 'Cannot bind a new session where one already exists.'
    else
      session = new Session opts, @standardViewSettings
      @sessions.set(@aceEditor.getSession(), session)
      @session = session
      @aceEditor.getSession()._dropletSession = @session
      @session.currentlyUsingBlocks = false
      @setValue_raw @getAceValue()
      @setPalette @session.paletteGroups
      return session

Editor::clearCanvas = (canvas) -> # TODO remove and remove all references to

# RENDERING CAPABILITIES
# ================================

# ## Redraw
# There are two different redraw events, redraw_main and rebuild_palette,
# for redrawing the main canvas and palette canvas, respectively.
#
# Redrawing simply involves issuing a call to the View.

Editor::clearMain = (opts) -> # TODO remove and remove all references to

Editor::setTopNubbyStyle = (height = 10, color = '#EBEBEB') ->
  @nubbyHeight = Math.max(0, height); @nubbyColor = color

  @topNubbyPath ?= new @draw.Path([], true)
  @topNubbyPath.activate()
  @topNubbyPath.setParent @mainCtx

  points = []

  points.push new @draw.Point @mainCanvas.clientWidth, -5
  points.push new @draw.Point @mainCanvas.clientWidth, height

  points.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth, height
  points.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth * (1 - @view.opts.tabSideWidth),
      @view.opts.tabHeight + height
  points.push new @draw.Point @view.opts.tabOffset + @view.opts.tabWidth * @view.opts.tabSideWidth,
      @view.opts.tabHeight + height
  points.push new @draw.Point @view.opts.tabOffset, height

  points.push new @draw.Point -5, height
  points.push new @draw.Point -5, -5

  @topNubbyPath.setPoints points

  @topNubbyPath.style.fillColor = color

  @redrawMain()

Editor::resizeNubby = ->
  @setTopNubbyStyle @nubbyHeight, @nubbyColor

Editor::initializeFloatingBlock = (record, i) ->
  record.renderGroup = new @view.draw.Group()

  record.grayBox = new @view.draw.NoRectangle()
  record.grayBoxPath = new @view.draw.Path(
    [], false, {
      fillColor: GRAY_BLOCK_COLOR
      strokeColor: GRAY_BLOCK_BORDER
      lineWidth: 4
      dotted: '8 5'
      cssClass: 'droplet-floating-container'
    }
  )
  record.startText = new @view.draw.Text(
    (new @view.draw.Point(0, 0)), @mode.startComment
  )
  record.endText = new @view.draw.Text(
    (new @view.draw.Point(0, 0)), @mode.endComment
  )

  for element in [record.grayBoxPath, record.startText, record.endText]
    element.setParent record.renderGroup

  @view.getViewNodeFor(record.block).group.setParent record.renderGroup

  # TODO maybe refactor into qualifiedFocus
  if i < @floatingBlocks.length
    @mainCtx.insertBefore record.renderGroup.element, @floatingBlocks[i].renderGroup.element
  else
    @mainCtx.appendChild record.renderGroup

Editor::drawFloatingBlock = (record, startWidth, endWidth, rect, opts) ->
  blockView = @session.view.getViewNodeFor record.block
  blockView.layout record.position.x, record.position.y

  rectangle = new @session.view.draw.Rectangle(); rectangle.copy(blockView.totalBounds)
  rectangle.x -= GRAY_BLOCK_MARGIN; rectangle.y -= GRAY_BLOCK_MARGIN
  rectangle.width += 2 * GRAY_BLOCK_MARGIN; rectangle.height += 2 * GRAY_BLOCK_MARGIN

  bottomTextPosition = blockView.totalBounds.bottom() - blockView.distanceToBase[blockView.lineLength - 1].below - @session.fontSize

  if (blockView.totalBounds.width - blockView.bounds[blockView.bounds.length - 1].width) < endWidth
    if blockView.lineLength > 1
      rectangle.height += @session.fontSize
      bottomTextPosition = rectangle.bottom() - @session.fontSize - 5
    else
      rectangle.width += endWidth

  unless rectangle.equals(record.grayBox)
    record.grayBox = rectangle

    oldBounds = record.grayBoxPath?.bounds?() ? new @session.view.draw.NoRectangle()

    startHeight = blockView.bounds[0].height + 10

    points = []

    # Make the path surrounding the gray box (with rounded corners)
    points.push new @session.view.draw.Point rectangle.right() - 5, rectangle.y
    points.push new @session.view.draw.Point rectangle.right(), rectangle.y + 5
    points.push new @session.view.draw.Point rectangle.right(), rectangle.bottom() - 5
    points.push new @session.view.draw.Point rectangle.right() - 5, rectangle.bottom()

    if blockView.lineLength > 1
      points.push new @session.view.draw.Point rectangle.x + 5, rectangle.bottom()
      points.push new @session.view.draw.Point rectangle.x, rectangle.bottom() - 5
    else
      points.push new @session.view.draw.Point rectangle.x, rectangle.bottom()

    # Handle
    points.push new @session.view.draw.Point rectangle.x, rectangle.y + startHeight
    points.push new @session.view.draw.Point rectangle.x - startWidth + 5, rectangle.y + startHeight
    points.push new @session.view.draw.Point rectangle.x - startWidth, rectangle.y + startHeight - 5
    points.push new @session.view.draw.Point rectangle.x - startWidth, rectangle.y + 5
    points.push new @session.view.draw.Point rectangle.x - startWidth + 5, rectangle.y

    points.push new @view.draw.Point rectangle.x, rectangle.y

    record.grayBoxPath.setPoints points

    if opts.boundingRectangle?
      opts.boundingRectangle.unite path.bounds()
      opts.boundingRectangle.unite(oldBounds)
      return @redrawMain opts

  record.grayBoxPath.update()

  record.startText.point.x = blockView.totalBounds.x - startWidth
  record.startText.point.y = blockView.totalBounds.y + blockView.distanceToBase[0].above - @fontSize
  record.startText.update()

  record.endText.point.x = record.grayBox.right() - endWidth - 5
  record.endText.point.y = bottomTextPosition
  record.endText.update()

  blockView.draw rect, {
    grayscale: false
    selected: false
    noText: false
  }

hook 'populate', 0, ->
  @currentlyDrawnFloatingBlocks = []

Editor::redrawMain = (opts = {}) ->
  return unless @session?
  unless @currentlyAnimating_suprressRedraw

    @session.view.beginDraw()

    # Clear the main canvas
    @clearMain(opts)

    @topNubbyPath.update()

    rect = @viewports.main

    options = {
      grayscale: false
      selected: false
      noText: (opts.noText ? false)
    }

    # Draw the new tree on the main context
    layoutResult = @session.view.getViewNodeFor(@session.tree).layout 0, @nubbyHeight
    @session.view.getViewNodeFor(@session.tree).draw rect, options
    @session.view.getViewNodeFor(@session.tree).root()

    for el, i in @currentlyDrawnFloatingBlocks
      unless el.record in @session.floatingBlocks
        el.record.grayBoxPath.destroy()
        el.record.startText.destroy()
        el.record.endText.destroy()

    @currentlyDrawnFloatingBlocks = []

    # Draw floating blocks
    startWidth = @mode.startComment.length * @fontWidth
    endWidth = @mode.endComment.length * @fontWidth
    for record in @session.floatingBlocks
      element = @drawFloatingBlock(record, startWidth, endWidth, rect, opts)
      @currentlyDrawnFloatingBlocks.push {
        record: record
      }

    # Draw the cursor (if exists, and is inserted)
    @redrawCursors(); @redrawHighlights()
    @resizeGutter()

    for binding in editorBindings.redraw_main
      binding.call this, layoutResult

    if @session.changeEventVersion isnt @session.tree.version
      @session.changeEventVersion = @session.tree.version

      @fireEvent 'change', []

    @view.cleanupDraw()

    unless @alreadyScheduledCleanup
      @alreadyScheduledCleanup = true
      setTimeout (=>
        @alreadyScheduledCleanup = false
        @view.garbageCollect()
      ), 0

    return null

Editor::redrawHighlights = ->
  @redrawCursors()
  @redrawLassoHighlight()

  # If there is an block that is being dragged,
  # draw it in gray
  if @draggingBlock? and @inDisplay @draggingBlock
    @session.view.getViewNodeFor(@draggingBlock).draw new @draw.Rectangle(
      @session.viewports.main.x,
      @session.viewports.main.y,
      @session.viewports.main.width,
      @session.viewports.main.height
    ), {grayscale: true}

Editor::clearCursorCanvas = ->
  @textCursorPath.deactivate()
  @cursorPath.deactivate()

Editor::redrawCursors = ->
  return unless @session?
  @clearCursorCanvas()

  if @cursorAtSocket()
    @redrawTextHighlights()
  else unless @lassoSelection?
    @drawCursor()

Editor::drawCursor = -> @strokeCursor @determineCursorPosition()

Editor::clearPalette = -> # TODO remove and remove all references to

Editor::clearPaletteHighlightCanvas = -> # TODO remove and remove all references to

Editor::redrawPalette = ->
  return unless @session?.currentPaletteBlocks?

  @clearPalette()

  @paletteView.beginDraw()

  # We will construct a vertical layout
  # with padding for the palette blocks.
  # To do this, we will need to keep track
  # of the last bottom edge of a palette block.
  lastBottomEdge = PALETTE_TOP_MARGIN

  for entry in @session.currentPaletteBlocks
    # Layout this block
    paletteBlockView = @session.paletteView.getViewNodeFor entry.block
    paletteBlockView.layout PALETTE_LEFT_MARGIN, lastBottomEdge

    # Render the block
    paletteBlockView.draw()
    paletteBlockView.group.setParent @paletteCtx

    element = document.createElementNS SVG_STANDARD, 'title'
    element.innerHTML = entry.title ? entry.block.stringify()
    paletteBlockView.group.element.appendChild element

    paletteBlockView.group.element.setAttribute 'data-id', entry.id

    # Update lastBottomEdge
    lastBottomEdge = paletteBlockView.getBounds().bottom() + PALETTE_MARGIN

  for binding in editorBindings.redraw_palette
    binding.call this

  @paletteCanvas.style.height = lastBottomEdge + 'px'

  @paletteView.garbageCollect()

Editor::rebuildPalette = ->
  return unless @session?.currentPaletteBlocks?
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
  new @draw.Point(point.x - gbr.left + @session.scrollOffsets.main.x,
                  point.y - gbr.top + @session.scrollOffsets.main.y)

Editor::trackerPointToPalette = (point) ->
  if not @paletteCanvas.offsetParent?
    return new @draw.Point(NaN, NaN)
  gbr = @paletteCanvas.getBoundingClientRect()
  new @draw.Point(point.x - gbr.left + @session.scrollOffsets.palette.x,
                  point.y - gbr.top + @session.scrollOffsets.palette.y)

Editor::trackerPointIsInElement = (point, element) ->
  if not @session? or @session.readOnly
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
Editor::hitTest = (point, block, view = @session.view) ->
  if @session.readOnly
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
  head = tail = @session.tree.end.prev
  while head?.type is 'newline'
    head = head.prev

  if head.type is 'newline'
    @spliceOut new model.List head, tail

# UNDO STACK SUPPORT
# ================================

# We must declare a few
# fields a populate time

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
  return new EditorState @session.tree.stringify(), @session.floatingBlocks.map (x) -> {
    position: x.position
    string: x.block.stringify()
  }

Editor::clearUndoStack = ->
  return unless @session?

  @session.undoStack.length = 0
  @session.redoStack.length = 0

Editor::undo = ->
  return unless @session?

  # Don't allow a socket to be highlighted during
  # an undo operation
  @setCursor @session.cursor, ((x) -> x.type isnt 'socketStart')

  currentValue = @getSerializedEditorState()

  until @session.undoStack.length is 0 or
      (@session.undoStack[@session.undoStack.length - 1] instanceof CapturePoint and
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
  if @session.undoStack[@session.undoStack.length - 1] instanceof CapturePoint
    @session.rememberedSockets = @session.undoStack[@session.undoStack.length - 1].rememberedSockets.map (x) -> x.clone()

  @popUndo()
  @correctCursor()
  @redrawMain()
  return

Editor::pushUndo = (operation) ->
  @session.redoStack.length = 0
  @session.undoStack.push operation

Editor::popUndo = ->
  operation = @session.undoStack.pop()
  @session.redoStack.push(operation) if operation?
  return operation

Editor::popRedo = ->
  operation = @session.redoStack.pop()
  @session.undoStack.push(operation) if operation?
  return operation

Editor::redo = ->
  currentValue = @getSerializedEditorState()

  until @session.redoStack.length is 0 or
      (@session.redoStack[@session.redoStack.length - 1] instanceof CapturePoint and
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
  if @session.undoStack[@session.undoStack.length - 1] instanceof CapturePoint
    @session.rememberedSockets = @session.undoStack[@session.undoStack.length - 1].rememberedSockets.map (x) -> x.clone()

  @popRedo()
  @redrawMain()
  return

# ## undoCapture and CapturePoint ##
# A CapturePoint is a sentinel indicating that the undo stack
# should stop when the user presses Ctrl+Z or Ctrl+Y. Each CapturePoint
# also remembers the @rememberedSocket state at the time it was placed,
# to preserved remembered socket contents across undo and redo.
Editor::undoCapture = ->
  @pushUndo new CapturePoint(@session.rememberedSockets)

class CapturePoint
  constructor: (rememberedSockets) ->
    @rememberedSockets = rememberedSockets.map (x) -> x.clone()

# BASIC BLOCK MOVE SUPPORT
# ================================

Editor::getPreserves = (dropletDocument) ->
  if dropletDocument instanceof model.Document
    dropletDocument = @documentIndex dropletDocument

  array = [@session.cursor]

  array = array.concat @session.rememberedSockets.map(
    (x) -> x.socket
  )

  return array.filter((location) ->
    location.document is dropletDocument
  ).map((location) -> location.location)

Editor::spliceOut = (node, container = null) ->
  # Make an empty list if we haven't been
  # passed one
  unless node instanceof model.List
    node = new model.List node, node

  operation = null

  dropletDocument = node.getDocument()

  parent = node.parent

  if dropletDocument?
    operation = node.getDocument().remove node, @getPreserves(dropletDocument)
    @pushUndo {operation, document: @getDocuments().indexOf(dropletDocument)}

    # If we are removing a block from a socket, and the socket is in our
    # dictionary of remembered socket contents, repopulate the socket with
    # its old contents.
    if parent?.type is 'socket' and node.start.type is 'blockStart'
      for socket, i in @session.rememberedSockets
        if @fromCrossDocumentLocation(socket.socket) is parent
          @session.rememberedSockets.splice i, 0
          @populateSocket parent, socket.text
          break

    # Remove the floating dropletDocument if it is now
    # empty
    if dropletDocument.start.next is dropletDocument.end
      for record, i in @session.floatingBlocks
        if record.block is dropletDocument
          @pushUndo new FloatingOperation i, record.block, record.position, 'delete'

          # If the cursor's document is about to vanish,
          # put it back in the main tree.
          if @session.cursor.document is i + 1
            @setCursor @session.tree.start

          if @session.cursor.document > i + 1
            @session.cursor.document -= 1

          @session.floatingBlocks.splice i, 1
          break
  else if container?
    # No document, so try to remove from container if it was supplied
    container.remove node

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
    if @documentIndex(container) != -1
      # If we're splicing into a socket found in a document and it already has
      # something in it, remove it. Additionally, remember the old
      # contents in @session.rememberedSockets for later repopulation if they take
      # the block back out.
      @session.rememberedSockets.push new RememberedSocketRecord(
        @toCrossDocumentLocation(container),
        container.textContent()
      )
    @spliceOut (new model.List container.start.next, container.end.prev), container

  dropletDocument = location.getDocument()

  @prepareNode node, container

  if dropletDocument?
    operation = dropletDocument.insert location, node, @getPreserves(dropletDocument)
    @pushUndo {operation, document: @getDocuments().indexOf(dropletDocument)}
    @correctCursor()
    return operation
  else
    # No document, so just insert into container
    container.insert location, node
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

Editor::adjustPosToLineStart = (pos) ->
  line = @aceEditor.session.getLine pos.row
  if pos.row == @aceEditor.session.getLength() - 1
    pos.column = if (pos.column >= line.length / 2) then line.length else 0
  else
    pos.column = 0
  pos

Editor::correctCursor = ->
  cursor = @fromCrossDocumentLocation @session.cursor
  unless @validCursorPosition cursor
    until not cursor? or (@validCursorPosition(cursor) and cursor.type isnt 'socketStart')
      cursor = cursor.next
    unless cursor? then cursor = @fromCrossDocumentLocation @session.cursor
    until not cursor? or (@validCursorPosition(cursor) and cursor.type isnt 'socketStart')
      cursor = cursor.prev
    @session.cursor = @toCrossDocumentLocation cursor

Editor::prepareNode = (node, context) ->
  if node instanceof model.Container
    leading = node.getLeadingText()
    if node.start.next is node.end.prev
      trailing = null
    else
      trailing = node.getTrailingText()

    [leading, trailing, classes] = @session.mode.parens leading, trailing, node.getReader(),
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

  @lastHighlight = @lastHighlightPath = null

  # And the canvas for drawing highlights
  @highlightCanvas = @highlightCtx = document.createElementNS SVG_STANDARD, 'g'

  # We append it to the tracker element,
  # so that it can appear in front of the scrollers.
  #@dropletElement.appendChild @dragCanvas
  #document.body.appendChild @dragCanvas
  @wrapperElement.appendChild @dragCanvas
  @mainCanvas.appendChild @highlightCanvas

Editor::clearHighlightCanvas = ->
  for path in [@textCursorPath]
    path.deactivate()

# Utility function for clearing the drag canvas,
# an operation we will be doing a lot.
Editor::clearDrag = ->
  @clearHighlightCanvas()

# On resize, we will want to size the drag canvas correctly.
Editor::resizeDragCanvas = ->
  @dragCanvas.style.width = "#{0}px"
  @dragCanvas.style.height = "#{0}px"

  @highlightCanvas.style.width = "#{@dropletElement.clientWidth - @gutter.clientWidth}px"

  @highlightCanvas.style.height = "#{@dropletElement.clientHeight}px"

  @highlightCanvas.style.left = "#{@mainCanvas.offsetLeft}px"


Editor::getDocuments = ->
  documents = [@session.tree]
  for el, i in @session.floatingBlocks
    documents.push el.block
  return documents

Editor::getDocument = (n) ->
  if n is 0 then @session.tree
  else @session.floatingBlocks[n - 1].block

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
    else if @session.cursor.document is i and @cursorAtSocket()
      @setCursor @session.cursor, ((token) -> token.type isnt 'socketStart')

    hitTestResult = @hitTest mainPoint, dropletDocument

    # Produce debugging output
    if @debugging and event.shiftKey
      line = null
      node = @session.view.getViewNodeFor(hitTestResult)
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
      record = @session.floatingBlocks[i - 1]
      if record.grayBoxPath? and record.grayBoxPath.contains @trackerPointToMain point
        @clickedBlock = new model.List record.block.start.next, record.block.end.prev
        @clickedPoint = point

        @session.view.getViewNodeFor(@clickedBlock).absorbCache() # TODO MERGE inspection

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

  hitTestResult = @hitTest mainPoint, @session.tree

  if hitTestResult?
    hitTestBlock = @session.view.getViewNodeFor hitTestResult
    str = hitTestResult.stringifyInPlace()

    if hitTestBlock.addButtonRect? and hitTestBlock.addButtonRect.contains mainPoint
      line = @session.mode.handleButton str, 'add-button', hitTestResult.getReader()
      if line?.length >= 0
        @populateBlock hitTestResult, line
        @redrawMain()
      state.consumedHitTest = true
    ### TODO
    else if hitTestBlock.subtractButtonRect? and hitTestBlock.subtractButtonRect.contains mainPoint
      line = @session.mode.handleButton str, 'subtract-button', hitTestResult.getReader()
      if line?.length >= 0
        @populateBlock hitTestResult, line
        @redrawMain()
      state.consumedHitTest = true
    ###

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

Editor::drawDraggingBlock = ->
  # Draw the new dragging block on the drag canvas.
  #
  # When we are dragging things, we draw the shadow.
  # Also, we translate the block 1x1 to the right,
  # so that we can see its borders.
  @session.dragView.clearCache()
  draggingBlockView = @session.dragView.getViewNodeFor @draggingBlock
  draggingBlockView.layout 1, 1

  @dragCanvas.width = Math.min draggingBlockView.totalBounds.width + 10, window.screen.width
  @dragCanvas.height = Math.min draggingBlockView.totalBounds.height + 10, window.screen.height

  draggingBlockView.drawShadow @dragCtx, 5, 5
  draggingBlockView.draw @dragCtx, new @draw.Rectangle 0, 0, @dragCanvas.width, @dragCanvas.height

Editor::wouldDelete = (position) ->

  mainPoint = @trackerPointToMain position
  palettePoint = @trackerPointToPalette position

  return not @lastHighlight and not @session.viewports.main.contains(mainPoint)

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
      @draggingOffset = @session.paletteView.getViewNodeFor(@draggingBlock).bounds[0].upperLeftCorner().from(
        @trackerPointToPalette(@clickedPoint))

      # Substitute in expansion for this palette entry, if supplied.
      expansion = @clickedBlockPaletteEntry.expansion

      # Call expansion() function with no parameter to get the initial value.
      if 'function' is typeof expansion then expansion = expansion()
      if (expansion) then expansion = parseBlock(@session.mode, expansion, @clickedBlockPaletteEntry.context)
      @draggingBlock = (expansion or @draggingBlock).clone()

      # Special @draggingBlock setup for expansion function blocks.
      if 'function' is typeof @clickedBlockPaletteEntry.expansion
        # Any block generated from an expansion function should be treated as
        # any-drop because it can change with subsequent expansion() calls.
        if 'mostly-value' in @draggingBlock.classes
          @draggingBlock.classes.push 'any-drop'

        # Attach expansion() function and lastExpansionText to @draggingBlock.
        @draggingBlock.lastExpansionText = expansion
        @draggingBlock.expansion = @clickedBlockPaletteEntry.expansion

    else
      # Find the line on the block that we have
      # actually clicked, and attempt to translate the block
      # so that if it re-shapes, we're still touching it.
      #
      # To do this, we will assume that the left edge of a free
      # block are all aligned.
      mainPoint = @trackerPointToMain @clickedPoint
      viewNode = @session.view.getViewNodeFor @draggingBlock

      if @draggingBlock instanceof model.List and not
          (@draggingBlock instanceof model.Container)
        viewNode.absorbCache()

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
    @dragView.beginDraw()
    draggingBlockView = @dragView.getViewNodeFor @draggingBlock
    draggingBlockView.layout 1, 1
    draggingBlockView.root()
    draggingBlockView.draw()
    @dragView.garbageCollect()

    @dragCanvas.style.width = "#{Math.min draggingBlockView.totalBounds.width + 10, window.screen.width}px"
    @dragCanvas.style.height = "#{Math.min draggingBlockView.totalBounds.height + 10, window.screen.height}px"

    # Translate it immediately into position
    position = new @draw.Point(
      point.x + @draggingOffset.x,
      point.y + @draggingOffset.y
    )

    # Construct a quadtree of drop areas
    # for faster dragging
    @dropPointQuadTree = QUAD.init
      x: @session.viewports.main.x
      y: @session.viewports.main.y
      w: @session.viewports.main.width
      h: @session.viewports.main.height

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
            dropPoint = @session.view.getViewNodeFor(head.container).dropPoint

            if dropPoint?
              allowed = true
              for record, i in @session.floatingBlocks by -1
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

    @dragCanvas.style.transform = "translate(#{position.x + getOffsetLeft(@dropletElement)}px,#{position.y + getOffsetTop(@dropletElement)}px)"

    # Now we are done with the "clickedX" suite of stuff.
    @clickedPoint = @clickedBlock = null
    @clickedBlockPaletteEntry = null

    @begunTrash = @wouldDelete position

    # Redraw the main canvas
    @redrawMain()

Editor::getClosestDroppableBlock = (mainPoint, isDebugMode) ->
  best = null; min = Infinity

  if not (@dropPointQuadTree)
    return null

  testPoints = @dropPointQuadTree.retrieve {
    x: mainPoint.x - MAX_DROP_DISTANCE
    y: mainPoint.y - MAX_DROP_DISTANCE
    w: MAX_DROP_DISTANCE * 2
    h: MAX_DROP_DISTANCE * 2
  }, (point) =>
    unless (point.acceptLevel is helper.DISCOURAGE) and not isDebugMode
      # Find a modified "distance" to the point
      # that weights horizontal distance more
      distance = mainPoint.from(point)
      distance.y *= 2; distance = distance.magnitude()

      # Select the node that is closest by said "distance"
      if distance < min and mainPoint.from(point).magnitude() < MAX_DROP_DISTANCE and
         @session.view.getViewNodeFor(point._droplet_node).highlightArea?
        best = point._droplet_node
        min = distance
  best

Editor::getClosestDroppableBlockFromPosition = (position, isDebugMode) ->
  if not @session.currentlyUsingBlocks
    return null

  mainPoint = @trackerPointToMain(position)
  @getClosestDroppableBlock(mainPoint, isDebugMode)

Editor::getAcceptLevel = (drag, drop) ->
  if drop.type is 'socket'
    if drag.type is 'list'
      return helper.FORBID
    else
      return @session.mode.drop drag.getReader(), drop.getReader(), null, null

  # If it's a list/selection, try all of its children
  else if drag.type is 'list'
    minimum = helper.ENCOURAGE
    drag.traverseOneLevel (child) =>
      if child instanceof model.Container
        minimum = Math.min minimum, @getAcceptLevel child, drop
    return minimum

  else if drop.type is 'block'
    if drop.parent.type is 'socket'
      return helper.FORBID
    else
      next = drop.nextSibling()
      return @session.mode.drop drag.getReader(), drop.parent.getReader(), drop.getReader(), next?.getReader?()
  else
    next = drop.firstChild()
    return @session.mode.drop drag.getReader(), drop.getReader(), drop.getReader(), next?.getReader?()

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

    # If there is an expansion function, call it again here.
    if (@draggingBlock.expansion)
      # Call expansion() with the closest droppable block for all drag moves.
      expansionText = @draggingBlock.expansion(@getClosestDroppableBlockFromPosition(position, event.shiftKey))

      # Create replacement @draggingBlock if the returned text is new.
      if expansionText isnt @draggingBlock.lastExpansionText
        newBlock = parseBlock(@session.mode, expansionText)
        newBlock.lastExpansionText = expansionText
        newBlock.expansion = @draggingBlock.expansion
        if 'any-drop' in @draggingBlock.classes
          newBlock.classes.push 'any-drop'
        @draggingBlock = newBlock
        @drawDraggingBlock()

    if not @session.currentlyUsingBlocks
      if @trackerPointIsInAce position
        pos = @aceEditor.renderer.screenToTextCoordinates position.x, position.y

        if @session.dropIntoAceAtLineStart
          pos = @adjustPosToLineStart pos

        @aceEditor.focus()
        @aceEditor.session.selection.moveToPosition pos
      else
        @aceEditor.blur()

    rect = @wrapperElement.getBoundingClientRect()

    @dragCanvas.style.transform =  "translate(#{position.x - rect.left}px,#{position.y - rect.top}px)"

    mainPoint = @trackerPointToMain(position)

    # Check to see if the tree is empty;
    # if it is, drop on the tree always
    head = @session.tree.start.next
    while head.type in ['newline', 'cursor'] or head.type is 'text' and head.value is ''
      head = head.next

    if head is @tree.end and @floatingBlocks.length is 0 and
        @session.viewports.main.right() > mainPoint.x > @session.viewports.main.x - @gutter.offsetWidth and
        @session.viewports.main.bottom() > mainPoint.y > @session.viewports.main.y
      @view.getViewNodeFor(@tree).highlightArea.update()
      @lastHighlight = @tree

    else
      # If the user is touching the original location,
      # assume they want to replace the block where they found it.
      if @hitTest mainPoint, @draggingBlock
        dropBlock = null
        @dragReplacing = true

      # Otherwise, find the closest droppable block
      else
        @dragReplacing = false
        dropBlock = @getClosestDroppableBlock(mainPoint, event.shiftKey)

      # Update highlight if necessary.
      if dropBlock isnt @lastHighlight
        # TODO if this becomes a performance issue,
        # pull the drop highlights out into a new canvas.
        @redrawHighlights()

        @lastHighlightPath?.deactivate?()

        if best?
          @lastHighlightPath = @session.view.getViewNodeFor(best).highlightArea
          @lastHighlightPath.update()
          @qualifiedFocus best, @lastHighlightPath

        @lastHighlight = dropBlock

    palettePoint = @trackerPointToPalette position

    if @wouldDelete(position)
      if @begunTrash
        @dragCanvas.style.opacity = 0.85
      else
        @dragCanvas.style.opacity = 0.3
    else
      @dragCanvas.style.opacity = 0.85
      @begunTrash = false

Editor::qualifiedFocus = (node, path) ->
  documentIndex = @documentIndex node
  if documentIndex < @floatingBlocks.length
    path.activate()
    @mainCtx.insertBefore path.element, @floatingBlocks[documentIndex].renderGroup.element
  else
    path.focus()

hook 'mouseup', 0, ->
  clearTimeout @discourageDropTimeout; @discourageDropTimeout = null

hook 'mouseup', 1, (point, event, state) ->
  if @dragReplacing
    @endDrag()

  # We will consume this event iff we dropped it successfully
  # in the root tree.
  if @draggingBlock?
    if not @session.currentlyUsingBlocks
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
        indentation = leadingWhitespaceRegex.exec(line)[0]

        skipInitialIndent = true
        prefix = ''
        suffix = ''

        if @session.dropIntoAceAtLineStart
          # First, adjust indentation if we're dropping into the start of a
          # line that ends an indentation block
          firstNonWhitespaceRegex = /\S/
          firstChar = firstNonWhitespaceRegex.exec(line)
          if firstChar and firstChar[0] == '}'
            # If this line starts with a closing bracket, use the previous line's indentation
            # TODO: generalize for language indentation semantics besides C/JavaScript
            prevLine = @aceEditor.session.getLine(pos.row - 1)
            indentation = leadingWhitespaceRegex.exec(prevLine)[0]
          # Adjust pos to start of the line (as we did during mousemove)
          pos = @adjustPosToLineStart pos
          skipInitialIndent = false
          if pos.column == 0
            suffix = '\n'
          else
            # Handle the case where we're dropping a block at the end of the last line
            prefix = '\n'
        else if indentation.length == line.length or indentation.length == pos.column
          # line is whitespace only or we're inserting at the beginning of a line
          # Append with a newline
          suffix = '\n' + indentation
        else if pos.column == line.length
          # We're at the end of a non-empty line.
          # Insert a new line, and base our indentation off of the next line
          prefix = '\n'
          skipInitialIndent = false
          nextLine = @aceEditor.session.getLine(pos.row + 1)
          indentation = leadingWhitespaceRegex.exec(nextLine)[0]

        # Call prepareNode, which may append with a semicolon
        @prepareNode @draggingBlock, null
        text = @draggingBlock.stringify @session.mode

        # Indent each line, unless it's the first line and wasn't placed on
        # a newline
        text = text.split('\n').map((line, index) =>
          return (if index == 0 and skipInitialIndent then '' else indentation) + line
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
        @session.rememberedSockets.push new RememberedSocketRecord(
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
    for el, i in @session.rememberedSockets
      if block.contains @fromCrossDocumentLocation(el.socket)
        offsets.push {
          offset: el.socket.location.count - blockBegin
          text: el.text
        }
      else
        newRememberedSockets.push el
    @session.rememberedSockets = newRememberedSockets
    return offsets
  else
    []

# FLOATING BLOCK SUPPORT
# ================================

class FloatingBlockRecord
  constructor: (@block, @position) ->

Editor::inTree = (block) -> (block.container ? block).getDocument() is @session.tree
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

    removeBlock = true
    addBlockAsFloatingBlock = true

    # If we dropped it off in the palette, abort (so as to delete the block).
    unless @session.viewports.main.right() > renderPoint.x > @session.viewports.main.x - @gutter.clientWidth and
        @session.viewports.main.bottom() > renderPoint.y > @session.viewports.main.y
      if @draggingBlock is @lassoSelection
        @lassoSelection = null

      addBlockAsFloatingBlock = false
    else
      if renderPoint.x - @session.scrollOffsets.main.x < 0
        renderPoint.x = @session.scrollOffsets.main.x

      # If @session.allowFloatingBlocks is false, we end the drag without deleting the block.
      if not @session.allowFloatingBlocks
        addBlockAsFloatingBlock = false
        removeBlock = false

    if removeBlock
      # Remove the block from the tree.
      @undoCapture()
      rememberedSocketOffsets = @spliceRememberedSocketOffsets(@draggingBlock)
      @spliceOut @draggingBlock

    if not addBlockAsFloatingBlock
      @endDrag()
      return

    else if renderPoint.x - @session.viewports.main.x < 0
      renderPoint.x = @session.viewports.main.x

    # Add the undo operation associated
    # with creating this floating block
    newDocument = new model.Document({roundedSingletons: true})
    newDocument.insert newDocument.start, @draggingBlock
    @pushUndo new FloatingOperation @session.floatingBlocks.length, newDocument, renderPoint, 'create'

    # Add this block to our list of floating blocks
    @session.floatingBlocks.push record = new FloatingBlockRecord(
      newDocument
      renderPoint
    )

    @initializeFloatingBlock record, @floatingBlocks.length - 1

    @setCursor @draggingBlock.start

    # TODO write a test for this logic
    for el, i in rememberedSocketOffsets
      @session.rememberedSockets.push new RememberedSocketRecord(
        new CrossDocumentLocation(
          @session.floatingBlocks.length,
          new model.Location(el.offset + 1, 'socket')
        ),
        el.text
      )

    # Now that we've done that, we can annul stuff.
    @clearDrag()
    @draggingBlock = null
    @draggingOffset = null
    @lastHighlightPath?.destroy?()
    @lastHighlight = @lastHighlightPath = null

    @redrawMain()

Editor::performFloatingOperation = (op, direction) ->
  if (op.type is 'create') is (direction is 'forward')
    if @session.cursor.document > op.index
      @session.cursor.document += 1

    @session.floatingBlocks.splice op.index, 0, record = new FloatingBlockRecord(
      op.block.clone()
      op.position
    )

    @initializeFloatingBlock record, op.index
  else
    # If the cursor's document is about to vanish,
    # put it back in the main tree.
    if @session.cursor.document is op.index + 1
      @setCursor @session.tree.start

    @session.floatingBlocks.splice op.index, 1

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

  if @session?
    @setPalette @session.paletteGroups

parseBlock = (mode, code, context = null) =>
  block = mode.parse(code, {context}).start.next.container
  block.start.prev = block.end.next = null
  block.setParent null
  return block

Editor::setPalette = (paletteGroups) ->
  @paletteHeader.innerHTML = ''
  @session.paletteGroups = paletteGroups

  @session.currentPaletteBlocks = []
  @session.currentPaletteMetadata = []

  paletteHeaderRow = null

  for paletteGroup, i in @session.paletteGroups then do (paletteGroup, i) =>
    # Start a new row, if we're at that point
    # in our appending cycle
    if i % 2 is 0
      paletteHeaderRow = document.createElement 'div'
      paletteHeaderRow.className = 'droplet-palette-header-row'
      @paletteHeader.appendChild paletteHeaderRow
      # hide the header if there is only one group, and it has no name.
      if @session.paletteGroups.length is 1 and !paletteGroup.name
        paletteHeaderRow.style.height = 0

    # Create the element itself
    paletteGroupHeader = paletteGroup.header = document.createElement 'div'
    paletteGroupHeader.className = 'droplet-palette-group-header'
    if paletteGroup.id
      paletteGroupHeader.id = 'droplet-palette-group-header-' + paletteGroup.id
    paletteGroupHeader.innerText = paletteGroupHeader.textContent = paletteGroupHeader.textContent = paletteGroup.name # innerText and textContent for FF compatability
    if paletteGroup.color
      paletteGroupHeader.className += ' ' + paletteGroup.color

    paletteHeaderRow.appendChild paletteGroupHeader

    newPaletteBlocks = []

    # Parse all the blocks in this palette and clone them
    for data in paletteGroup.blocks
      newBlock = parseBlock(@session.mode, data.block, data.context)
      expansion = data.expansion or null
      newPaletteBlocks.push
        block: newBlock
        expansion: expansion
        context: data.context
        title: data.title
        id: data.id

    paletteGroup.parsedBlocks = newPaletteBlocks

    # When we click this element,
    # we should switch to it in the palette.
    updatePalette = =>
      @changePaletteGroup paletteGroup

    clickHandler = =>
      do updatePalette

    paletteGroupHeader.addEventListener 'click', clickHandler
    paletteGroupHeader.addEventListener 'touchstart', clickHandler

    # If we are the first element, make us the selected palette group.
    if i is 0
      do updatePalette

  @resizePalette()
  @resizePaletteHighlight()

# Change which palette group is selected.
# group argument can be object, id (string), or name (string)
#
Editor::changePaletteGroup = (group) ->
  for curGroup, i in @session.paletteGroups
    if group is curGroup or group is curGroup.id or group is curGroup.name
      paletteGroup = curGroup
      break

  if not paletteGroup
    return

  # Record that we are the selected group now
  @session.currentPaletteGroup = paletteGroup.name
  @session.currentPaletteBlocks = paletteGroup.parsedBlocks
  @session.currentPaletteMetadata = paletteGroup.parsedBlocks

  # Unapply the "selected" style to the current palette group header
  @session.currentPaletteGroupHeader?.className =
      @session.currentPaletteGroupHeader.className.replace(
          /\s[-\w]*-selected\b/, '')

  # Now we are the current palette group header
  @session.currentPaletteGroupHeader = paletteGroup.header
  @currentPaletteIndex = i

  # Apply the "selected" style to us
  @session.currentPaletteGroupHeader.className +=
      ' droplet-palette-group-header-selected'

  # Redraw the palette.
  @rebuildPalette()
  @fireEvent 'selectpalette', [paletteGroup.name]

# The next thing we need to do with the palette
# is let people pick things up from it.
hook 'mousedown', 6, (point, event, state) ->
  # If someone else has already taken this click, pass.
  if state.consumedHitTest then return

  # If it's not in the palette pane, pass.
  if not @trackerPointIsInPalette(point) then return

  palettePoint = @trackerPointToPalette point
  if @session.viewports.palette.contains(palettePoint)
    if @handleTextInputClickInPalette palettePoint
      state.consumedHitTest = true
      return

    for entry in @session.currentPaletteBlocks
      hitTestResult = @hitTest palettePoint, entry.block, @session.paletteView

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
  @paletteHighlightCanvas = @paletteHighlightCtx = document.createElementNS SVG_STANDARD, 'svg'
  @paletteHighlightCanvas.setAttribute 'class',  'droplet-palette-highlight-canvas'

  @paletteHighlightPath = null
  @currentHighlightedPaletteBlock = null

  @paletteElement.appendChild @paletteHighlightCanvas

Editor::resizePaletteHighlight = ->
  @paletteHighlightCanvas.style.top = @paletteHeader.offsetHeight + 'px'
  @paletteHighlightCanvas.style.width = "#{@paletteCanvas.clientWidth}px"
  @paletteHighlightCanvas.style.height = "#{@paletteCanvas.clientHeight}px"

hook 'redraw_palette', 0, ->
  @clearPaletteHighlightCanvas()
  if @currentHighlightedPaletteBlock?
    @paletteHighlightPath.update()

hook 'rebuild_palette', 1, ->
  # Remove the existent blocks
  @paletteScrollerStuffing.innerHTML = ''

  @currentHighlightedPaletteBlock = null

  # Add new blocks
  for data in @session.currentPaletteMetadata
    block = data.block

    hoverDiv = document.createElement 'div'
    hoverDiv.className = 'droplet-hover-div'

    hoverDiv.title = data.title ? block.stringify()

    if data.id?
      hoverDiv.setAttribute 'data-id', data.id

    bounds = @session.paletteView.getViewNodeFor(block).totalBounds

    hoverDiv.style.top = "#{bounds.y}px"
    hoverDiv.style.left = "#{bounds.x}px"

    # Clip boxes to the width of the palette to prevent x-scrolling. TODO: fix x-scrolling behaviour.
    hoverDiv.style.width = "#{Math.min(bounds.width, Infinity)}px"
    hoverDiv.style.height = "#{bounds.height}px"

    do (block) =>
      hoverDiv.addEventListener 'mousemove', (event) =>
        palettePoint = @trackerPointToPalette new @draw.Point(
            event.clientX, event.clientY)
        if @viewOrChildrenContains block, palettePoint, @session.paletteView
            @clearPaletteHighlightCanvas()
            @paletteHighlightPath = @getHighlightPath block, {color: '#FF0'}, @session.paletteView
            @paletteHighlightPath.draw @paletteHighlightCtx
            @currentHighlightedPaletteBlock = block
        else if block is @currentHighlightedPaletteBlock
          @currentHighlightedPaletteBlock = null
          @clearPaletteHighlightCanvas()

      hoverDiv.addEventListener 'mouseout', (event) =>
        if block is @currentHighlightedPaletteBlock
          @currentHighlightedPaletteBlock = null
          @paletteHighlightCtx.clearRect @session.scrollOffsets.palette.x, @session.scrollOffsets.palette.y,
            @paletteHighlightCanvas.width + @session.scrollOffsets.palette.x, @paletteHighlightCanvas.height + @session.scrollOffsets.palette.y

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

      bounds = @session.view.getViewNodeFor(@getCursor()).bounds[0]
      ###
      inputLeft = bounds.x + @mainCanvas.offsetLeft - @viewports.main.x
      inputLeft = Math.min inputLeft, @dropletElement.clientWidth - 10
      inputLeft = Math.max @mainCanvas.offsetLeft, inputLeft
      @hiddenInput.style.left = inputLeft + 'px'
      inputTop = bounds.y - @viewports.main.y
      inputTop = Math.min inputTop, @dropletElement.clientHeight - 10
      inputTop = Math.max 0, inputTop
      @hiddenInput.style.top = inputTop + 'px'
      ###

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
  if @session?.showPaletteInTextMode and @session?.paletteEnabled
    width -= @paletteWrapper.offsetWidth

  @aceElement.style.width = "#{width}px"
  @aceElement.style.height = "#{@wrapperElement.clientHeight}px"

last_ = (array) -> array[array.length - 1]

# Redraw function for text input
Editor::redrawTextInput = ->
  return unless @session?

  sameLength = @getCursor().stringify().split('\n').length is @hiddenInput.value.split('\n').length
  dropletDocument = @getCursor().getDocument()

  # Set the value in the model to fit
  # the hidden input value.
  @populateSocket @getCursor(), @hiddenInput.value

  textFocusView = @session.view.getViewNodeFor @getCursor()

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

    treeView = @session.view.getViewNodeFor dropletDocument

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
    @redrawMain()
    ###
    if helper.deepEquals newp, oldp
      rect = new @draw.NoRectangle()

      rect.unite treeView.bounds[line - 1] if line > 0
      rect.unite treeView.bounds[line]
      rect.unite treeView.bounds[line + 1] if line + 1 < treeView.bounds.length

      rect.width = Math.max rect.width, @mainCanvas.clientWidth

      @redrawMain
        boundingRectangle: rect

    else @redrawMain()
    ###

  # Otherwise, redraw the whole thing
  else
    @redrawMain()

Editor::redrawTextHighlights = (scrollIntoView = false) ->
  @clearHighlightCanvas()

  return unless @session?
  return unless @cursorAtSocket()

  textFocusView = @session.view.getViewNodeFor @getCursor()

  # Determine the coordinate positions
  # of the typing cursor
  startRow = @getCursor().stringify()[...@hiddenInput.selectionStart].split('\n').length - 1
  endRow = @getCursor().stringify()[...@hiddenInput.selectionEnd].split('\n').length - 1

  lines = @getCursor().stringify().split '\n'

  startPosition = textFocusView.bounds[startRow].x + @session.view.opts.textPadding +
    @fontWidth * last_(@getCursor().stringify()[...@hiddenInput.selectionStart].split('\n')).length +
    (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)

  endPosition = textFocusView.bounds[endRow].x + @session.view.opts.textPadding +
    @fontWidth * last_(@getCursor().stringify()[...@hiddenInput.selectionEnd].split('\n')).length +
    (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)

  # Now draw the highlight/typing cursor
  #
  # Draw a line if it is just a cursor
  if @hiddenInput.selectionStart is @hiddenInput.selectionEnd
    @qualifiedFocus @getCursor(), @textCursorPath
    points = [
      new @session.view.draw.Point(startPosition, textFocusView.bounds[startRow].y),
      new @session.view.draw.Point(startPosition, textFocusView.bounds[startRow].y + @session.view.opts.textHeight)
    ]

    @textCursorPath.setPoints points
    @textCursorPath.style.strokeColor = '#000'
    @textCursorPath.update()
    @qualifiedFocus @getCursor(), @textCursorPath
    @textInputHighlighted = false

  # Draw a translucent rectangle if there is a selection.
  else
    @textInputHighlighted = true

    # TODO maybe put this in the view?
    rectangles = []

    if startRow is endRow
      rectangles.push new @session.view.draw.Rectangle startPosition,
        textFocusView.bounds[startRow].y + @session.view.opts.textPadding
        endPosition - startPosition, @session.view.opts.textHeight

    else
      rectangles.push new @session.view.draw.Rectangle startPosition, textFocusView.bounds[startRow].y + @session.view.opts.textPadding,
        textFocusView.bounds[startRow].right() - @session.view.opts.textPadding - startPosition, @session.view.opts.textHeight

      for i in [startRow + 1...endRow]
        rectangles.push new @session.view.draw.Rectangle textFocusView.bounds[i].x,
          textFocusView.bounds[i].y + @session.view.opts.textPadding,
          textFocusView.bounds[i].width,
          @session.view.opts.textHeight

      rectangles.push new @session.view.draw.Rectangle textFocusView.bounds[endRow].x,
        textFocusView.bounds[endRow].y + @session.view.opts.textPadding,
        endPosition - textFocusView.bounds[endRow].x,
        @session.view.opts.textHeight

    left = []; right = []
    for el, i in rectangles
      left.push new @session.view.draw.Point el.x, el.y
      left.push new @session.view.draw.Point el.x, el.bottom()
      right.push new @session.view.draw.Point el.right(), el.y
      right.push new @session.view.draw.Point el.right(), el.bottom()

    @textCursorPath.setPoints left.concat right.reverse()
    @textCursorPath.style.strokeColor = 'none'
    @textCursorPath.update()
    @qualifiedFocus @getCursor(), @textCursorPath

  if scrollIntoView and endPosition > @session.viewports.main.x + @mainCanvas.clientWidth
    @mainScroller.scrollLeft = endPosition - @mainCanvas.clientWidth + @session.view.opts.padding

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
    originalUpdates = updates.map (location) ->
      count: location.count, type: location.type

    if @session.mode.stringFixer?
      @populateSocket list, @session.mode.stringFixer list.textContent()

    # Try reparsing the parent after beforetextfocus. If it fails,
    # repopulate with the original text and try again.
    unless @reparse list.parent, recovery, updates, originalTrigger
      @populateSocket list, originalText
      originalUpdates.forEach (location, i) ->
        updates[i].count = location.count
        updates[i].type = location.type
      @reparse list.parent, recovery, updates, originalTrigger
    return

  parent = list.start.parent

  if parent?.type is 'indent' and not list.start.container?.parseContext?
    context = parent.parseContext
  else
    context = (list.start.container ? list.start.parent).parseContext

  try
    newList = @session.mode.parse list.stringifyInPlace(),{
      wrapAtRoot: parent.type isnt 'socket'
      context: context
    }
  catch e
    try
      newList = @session.mode.parse recovery(list.stringifyInPlace()), {
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
        @view.getViewNodeFor(originalTrigger).mark {color: '#F00'}
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
  newBlock = @session.mode.parse(string, wrapAtRoot: false).start.next.container
  if newBlock
    # Find the first token before the block
    # that will still be around after the
    # block has been removed
    position = block.start.prev
    while position?.type is 'newline' and not (
          position.prev?.type is 'indentStart' and
          position.prev.container.end is block.end.next)
      position = position.prev
    @spliceOut block
    @spliceIn newBlock, position
    return true
  return false

# Convenience hit-testing function
Editor::hitTestTextInput = (point, block) ->
  head = block.start
  while head?
    if head.type is 'socketStart' and head.container.isDroppable() and
        @session.view.getViewNodeFor(head.container).path.contains point
      return head.container
    head = head.next

  return null

# Convenience functions for setting
# the text input selection, given
# points on the main canvas.
Editor::getTextPosition = (point) ->
  textFocusView = @session.view.getViewNodeFor @getCursor()

  row = Math.floor((point.y - textFocusView.bounds[0].y) / (@session.fontSize + 2 * @session.view.opts.padding))

  row = Math.max row, 0
  row = Math.min row, textFocusView.lineLength - 1

  column = Math.max 0, Math.round((point.x - textFocusView.bounds[row].x - @session.view.opts.textPadding - (if @getCursor().hasDropdown() then helper.DROPDOWN_ARROW_WIDTH else 0)) / @fontWidth)

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
          mainPoint.x - @session.view.getViewNodeFor(hitTestResult).bounds[0].x < helper.DROPDOWN_ARROW_WIDTH)
        @showDropdown hitTestResult

      @textInputSelecting = false

    else
      if @getCursor().hasDropdown() and
          mainPoint.x - @session.view.getViewNodeFor(hitTestResult).bounds[0].x < helper.DROPDOWN_ARROW_WIDTH
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

# Convenience hit-testing function
Editor::hitTestTextInputInPalette = (point, block) ->
  head = block.start
  while head?
    if head.type is 'socketStart' and head.container.isDroppable() and
        @session.paletteView.getViewNodeFor(head.container).path.contains point
      return head.container
    head = head.next

  return null

Editor::handleTextInputClickInPalette = (palettePoint) ->
  for entry in @session.currentPaletteBlocks
    hitTestResult = @hitTestTextInputInPalette palettePoint, entry.block

    # If they have clicked a socket, check to see if it is a dropdown
    if hitTestResult?
      if hitTestResult.hasDropdown()
        @showDropdown hitTestResult, true
        return true

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
Editor::formatDropdown = (socket = @getCursor(), view = @session.view) ->
  @dropdownElement.style.fontFamily = @session.fontFamily
  @dropdownElement.style.fontSize = @session.fontSize
  @dropdownElement.style.minWidth = view.getViewNodeFor(socket).bounds[0].width

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
  newresult = {}
  for key, val of result
    newresult = if 'string' is typeof val then { text: val, display: val } else val
  return newresult

Editor::showDropdown = (socket = @getCursor(), inPalette = false) ->
  @dropdownVisible = true

  dropdownItems = []

  @dropdownElement.innerHTML = ''
  @dropdownElement.style.display = 'inline-block'

  @formatDropdown socket, if inPalette then @session.paletteView else @session.view

  for el, i in @getDropdownList(socket) then do (el) =>
    div = document.createElement 'div'
    div.innerHTML = el.display
    div.className = 'droplet-dropdown-item'

    dropdownItems.push div

    div.style.paddingLeft = helper.DROPDOWN_ARROW_WIDTH

    setText = (text) =>
      @undoCapture()

      # Attempting to populate the socket after the dropdown has closed should no-op
      if @dropdownElement.style.display == 'none'
        return

      if inPalette
        @populateSocket socket, text
        @redrawPalette()
      else if not socket.editable()
        @populateSocket socket, text
        @redrawMain()
      else
        if not @cursorAtSocket()
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
    if @dropdownElement.clientHeight < @dropdownElement.scrollHeight
      for el in dropdownItems
        el.style.paddingRight = DROPDOWN_SCROLLBAR_PADDING

    if inPalette
      location = @session.paletteView.getViewNodeFor(socket).bounds[0]
      @dropdownElement.style.left = location.x - @session.scrollOffsets.palette.x + @paletteCanvas.offsetLeft + 'px'
      @dropdownElement.style.minWidth = location.width + 'px'

    @dropdownElement.style.top = location.y + @fontSize - @session.viewports.main.y + 'px'
    @dropdownElement.style.left = location.x - @session.viewports.main.x + @dropletElement.offsetLeft + @mainCanvas.offsetLeft + 'px'
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
    hitTestResult = @hitTestTextInput mainPoint, @session.tree

    # If they have clicked a socket,
    # focus it, and
    unless hitTestResult is @getCursor()
      if hitTestResult? and hitTestResult.editable()
        @redrawMain()
        hitTestResult = @hitTestTextInput mainPoint, @session.tree

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
  @lassoSelectRect = document.createElementNS SVG_STANDARD, 'rect'
  @lassoSelectRect.setAttribute 'stroke', '#00f'
  @lassoSelectRect.setAttribute 'fill', 'none'

  @lassoSelectAnchor = null
  @lassoSelection = null

  @mainCanvas.appendChild @lassoSelectRect

Editor::clearLassoSelection = ->
  @lassoSelection = null
  @redrawHighlights()

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
  mainPoint = @trackerPointToMain(point).from @session.viewports.main
  palettePoint = @trackerPointToPalette(point).from @session.viewports.palette

  @lassoSelectAnchor = @trackerPointToMain point

# On mousemove, if we are in the middle of a
# lasso select, continue with it.
hook 'mousemove', 0, (point, event, state) ->
  if @lassoSelectAnchor?
    mainPoint = @trackerPointToMain point

    lassoRectangle = new @draw.Rectangle(
      Math.min(@lassoSelectAnchor.x, mainPoint.x),
      Math.min(@lassoSelectAnchor.y, mainPoint.y),
      Math.abs(@lassoSelectAnchor.x - mainPoint.x),
      Math.abs(@lassoSelectAnchor.y - mainPoint.y)
    )

    findLassoSelect = (dropletDocument) =>
      first = dropletDocument.start
      until (not first?) or first.type is 'blockStart' and @session.view.getViewNodeFor(first.container).path.intersects lassoRectangle
        first = first.next

      last = dropletDocument.end
      until (not last?) or last.type is 'blockEnd' and @session.view.getViewNodeFor(last.container).path.intersects lassoRectangle
        last = last.prev

      @clearHighlightCanvas()
      @mainCanvas.appendChild @lassoSelectRect
      @lassoSelectRect.style.display = 'block'
      @lassoSelectRect.setAttribute 'x', lassoRectangle.x
      @lassoSelectRect.setAttribute 'y', lassoRectangle.y
      @lassoSelectRect.setAttribute 'width', lassoRectangle.width
      @lassoSelectRect.setAttribute 'height', lassoRectangle.height

      if first and last?
        [first, last] = validateLassoSelection dropletDocument, first, last
        @lassoSelection = new model.List first, last
        @redrawLassoHighlight()
        return true
      else
        @lassoSelection = null
        @redrawLassoHighlight()
        return false

    unless @lassoSelectionDocument? and findLassoSelect @lassoSelectionDocument
      for dropletDocument in @getDocuments()
        if findLassoSelect dropletDocument
          @lassoSelectionDocument = dropletDocument
          break

Editor::redrawLassoHighlight = ->
  return unless @session?

  # Remove any existing selections
  for dropletDocument in @getDocuments()
    dropletDocumentView = @session.view.getViewNodeFor dropletDocument
    dropletDocumentView.draw @session.viewports.main, {
      selected: false
      noText: @currentlyAnimating # TODO add some modularized way of having global view options
    }

  if @lassoSelection?
    # Add any new selections
    lassoView = @session.view.getViewNodeFor(@lassoSelection)
    lassoView.absorbCache()
    lassoView.draw @session.viewports.main, {selected: true}

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
    @lassoSelectRect.style.display = 'none'

    @redrawHighlights()
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
  if @cursorAtSocket() and not @session.cursor.is(destination)
    socket = @getCursor()
    if '__comment__' not in socket.classes
      @reparse socket, null, (if destination.document is @session.cursor.document then [destination.location] else [])
      @hiddenInput.blur()
      @dropletElement.focus()

  @session.cursor = destination

  # If we have messed up (usually because
  # of a reparse), scramble to find a nearby
  # okay place for the cursor
  @correctCursor()

  @redrawMain()
  @highlightFlashShow()

  # If we are now at a text input, populate the hidden input
  if @cursorAtSocket()
    if @getCursor()?.id of @session.extraMarks
      delete @session.extraMarks[focus?.id]
    @undoCapture()
    @hiddenInput.value = @getCursor().textContent()
    @hiddenInput.focus()
    {start, end} = @session.mode.getDefaultSelectionRange @hiddenInput.value
    @setTextSelectionRange start, end

Editor::determineCursorPosition = ->
  # Do enough of the redraw to get the bounds
  @session.view.getViewNodeFor(@session.tree).layout 0, @nubbyHeight

  # Get a cursor that is in the model
  cursor = @getCursor()

  if cursor.type is 'documentStart'
    bound = @session.view.getViewNodeFor(cursor.container).bounds[0]
    return new @draw.Point bound.x, bound.y

  else if cursor.type is 'indentStart'
    line = if cursor.next.type is 'newline' then 1 else 0
    bound = @session.view.getViewNodeFor(cursor.container).bounds[line]
    return new @draw.Point bound.x, bound.y

  else
    line = @getCursor().getTextLocation().row - cursor.parent.getTextLocation().row
    bound = @session.view.getViewNodeFor(cursor.parent).bounds[line]
    return new @draw.Point bound.x, bound.bottom()

Editor::getCursor = ->
  cursor = @fromCrossDocumentLocation @session.cursor

  if cursor.type is 'socketStart'
    return cursor.container
  else
    return cursor

Editor::scrollCursorIntoPosition = ->
  axis = @determineCursorPosition().y

  if axis < @viewports.main.y
    @mainScroller.scrollTop = axis
  else if axis > @viewports.main.bottom()
    @mainScroller.scrollTop = axis - @viewports.main.height

  @mainScroller.scrollLeft = 0

# Moves the cursor to the end of the document and scrolls it into position
# (in block and text mode)
Editor::scrollCursorToEndOfDocument = ->
  if @session.currentlyUsingBlocks
    pos = @session.tree.end
    while pos && !@validCursorPosition(pos)
      pos = pos.prev
    @setCursor(pos)
    @scrollCursorIntoPosition()
  else
    @aceEditor.scrollToLine @aceEditor.session.getLength()


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
  if not @session? or @session.readOnly
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

hook 'keydown', 0, (event, state) ->
  if not @session? or @session.readOnly
    return
  if event.which is ENTER_KEY
    if not @cursorAtSocket() and not event.shiftKey and not event.ctrlKey and not event.metaKey
      # Construct the block; flag the socket as handwritten
      newBlock = new model.Block(); newSocket = new model.Socket @session.mode.empty, Infinity, true
      newSocket.setParent newBlock
      helper.connect newBlock.start, newSocket.start
      helper.connect newSocket.end, newBlock.end

      # Seek a place near the cursor we can actually
      # put a block.
      head = @getCursor()
      while head.type is 'newline'
        head = head.prev

      newSocket.parseContext = head.parent.parseContext

      @spliceIn newBlock, head #MUTATION

      @redrawMain()

      @newHandwrittenSocket = newSocket

    else if @cursorAtSocket() and not event.shiftKey
      socket = @getCursor()
      @hiddenInput.blur()
      @dropletElement.focus()
      @setCursor @session.cursor, (token) -> token.type isnt 'socketStart'
      @redrawMain()
      if '__comment__' in socket.classes and @session.mode.startSingleLineComment
        # Create another single line comment block just below
        newBlock = new model.Block 0, 'blank', helper.ANY_DROP
        newBlock.classes = ['__comment__', 'block-only']
        newBlock.socketLevel = helper.BLOCK_ONLY
        newTextMarker = new model.TextToken @session.mode.startSingleLineComment
        newTextMarker.setParent newBlock
        newSocket = new model.Socket '', 0, true
        newSocket.classes = ['__comment__']
        newSocket.setParent newBlock

        helper.connect newBlock.start, newTextMarker
        helper.connect newTextMarker, newSocket.start
        helper.connect newSocket.end, newBlock.end

        # Seek a place near the cursor we can actually
        # put a block.
        head = @getCursor()
        while head.type is 'newline'
          head = head.prev

        @spliceIn newBlock, head #MUTATION

        @redrawMain()

        @newHandwrittenSocket = newSocket

hook 'keyup', 0, (event, state) ->
  if not @session? or @session.readOnly
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

  head = @session.tree.start

  aceSession = @aceEditor.session
  state = {
    # Initial cursor positions are
    # determined by ACE editor configuration.
    x: (@aceEditor.container.getBoundingClientRect().left -
        @aceElement.getBoundingClientRect().left +
        @aceEditor.renderer.$gutterLayer.gutterWidth) -
        @gutter.clientWidth + 5 # TODO find out where this 5 comes from
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
        @gutter.clientWidth + 5 # TODO see above
  }

  @measureCtx.font = @aceFontSize() + ' ' + @session.fontFamily
  fontWidth = @measureCtx.measureText(' ').width

  rownum = 0
  until head is @session.tree.end
    switch head.type
      when 'text'
        corner = @session.view.getViewNodeFor(head).bounds[0].upperLeftCorner()

        corner.x -= @session.viewports.main.x
        corner.y -= @session.viewports.main.y

        translationVectors.push (new @draw.Point(state.x, state.y)).from(corner)
        textElements.push @session.view.getViewNodeFor head

        state.x += fontWidth * head.value.length

      when 'socketStart'
        if head.next is head.container.end or
            head.next.type is 'text' and head.next.value is ''
          state.x += fontWidth * head.container.emptyString.length

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
          state.x = state.leftEdge + fontWidth * head.specialIndent.length
        else
          state.x = state.leftEdge + state.indent * fontWidth

      when 'indentStart'
        state.indent += head.container.depth

      when 'indentEnd'
        state.indent -= head.container.depth

    head = head.next

  return {
    textElements: textElements
    translationVectors: translationVectors
  }

Editor::checkAndHighlightEmptySockets = ->
  head = @session.tree.start
  ok = true
  until head is @session.tree.end
    if (head.type is 'socketStart' and head.next is head.container.end or
       head.type is 'socketStart' and head.next.type is 'text' and head.next.value is '') and
       head.container.emptyString isnt ''
      @markBlock head.container, {color: '#F00'}
      ok = false
    head = head.next
  return ok

Editor::performMeltAnimation = (fadeTime = 500, translateTime = 1000, cb = ->) ->
  if @session.currentlyUsingBlocks and not @currentlyAnimating

    # Forbid melting if there is an empty socket. If there is,
    # highlight it in red.
    if not @session.options.preserveEmpty and not @checkAndHighlightEmptySockets()
      @redrawMain()
      return

    @hideDropdown()

    @fireEvent 'statechange', [false]

    @setAceValue @getValue()

    top = @findLineNumberAtCoordinate @session.viewports.main.y

    @aceEditor.scrollToLine top

    @aceEditor.resize true

    @redrawMain noText: true

    # Hide scrollbars and increase width
    if @mainScroller.scrollWidth > @mainScroller.clientWidth
      @mainScroller.style.overflowX = 'scroll'
    else
      @mainScroller.style.overflowX = 'hidden'
    @mainScroller.style.overflowY = 'hidden'
    @dropletElement.style.width = @wrapperElement.clientWidth + 'px'

    @session.currentlyUsingBlocks = false; @currentlyAnimating = @currentlyAnimating_suppressRedraw = true

    # Compute where the text will end up
    # in the ace editor
    {textElements, translationVectors} = @computePlaintextTranslationVectors()

    translatingElements = []

    for textElement, i in textElements

      # Skip anything that's
      # off the screen the whole time.
      unless 0 < textElement.bounds[0].bottom() - @session.viewports.main.y + translationVectors[i].y and
                 textElement.bounds[0].y - @session.viewports.main.y + translationVectors[i].y < @session.viewports.main.height
        continue

      div = document.createElement 'div'
      div.style.whiteSpace = 'pre'

      div.innerText = div.textContent = textElement.model.value

      div.style.font = @session.fontSize + 'px ' + @session.fontFamily

      div.style.left = "#{textElement.bounds[0].x - @session.viewports.main.x}px"
      div.style.top = "#{textElement.bounds[0].y - @session.viewports.main.y - @fontAscent}px"

      div.className = 'droplet-transitioning-element'
      div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
      translatingElements.push div

      @transitionContainer.appendChild div

      do (div, textElement, translationVectors, i) =>
        setTimeout (=>
          div.style.left = (textElement.bounds[0].x - @session.viewports.main.x + translationVectors[i].x) + 'px'
          div.style.top = (textElement.bounds[0].y - @session.viewports.main.y + translationVectors[i].y) + 'px'
          div.style.fontSize = @aceFontSize()
        ), fadeTime

    top = Math.max @aceEditor.getFirstVisibleRow(), 0
    bottom = Math.min @aceEditor.getLastVisibleRow(), @session.view.getViewNodeFor(@session.tree).lineLength - 1
    aceScrollTop = @aceEditor.session.getScrollTop()

    treeView = @session.view.getViewNodeFor @session.tree
    lineHeight = @aceEditor.renderer.layerConfig.lineHeight

    for line in [top..bottom]
      div = document.createElement 'div'
      div.style.whiteSpace = 'pre'

      div.innerText = div.textContent = line + 1

      div.style.left = 0
      div.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @session.view.opts.textHeight - @fontAscent - @session.viewports.main.y}px"

      div.style.font = @fontSize + 'px ' + @fontFamily
      div.style.width = "#{@gutter.clientWidth}px"

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
      @cursorCanvas.style.transition = "opacity #{fadeTime}ms linear"

    @mainCanvas.style.opacity = 0

    paletteDisappearingWithMelt = @session.paletteEnabled and not @session.showPaletteInTextMode

    if paletteDisappearingWithMelt
      # Move the palette header into the background
      @paletteHeader.style.zIndex = 0

      setTimeout (=>
        @dropletElement.style.transition =
          @paletteWrapper.style.transition = "left #{translateTime}ms"

        @dropletElement.style.left = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.clientWidth}px"
      ), fadeTime

    setTimeout (=>
      # Translate the ICE editor div out of frame.
      @dropletElement.style.transition =
        @paletteWrapper.style.transition = ''

      # Translate the ACE editor div into frame.
      @aceElement.style.top = '0px'
      if @showPaletteInTextMode and @session.paletteEnabled
        @aceElement.style.left = "#{@paletteWrapper.clientWidth}px"
      else
        @aceElement.style.left = '0px'

      #if paletteDisappearingWithMelt
      #  @paletteWrapper.style.top = '-9999px'
      #  @paletteWrapper.style.left = '-9999px'

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

      @fireEvent 'toggledone', [@session.currentlyUsingBlocks]

      if cb? then do cb
    ), fadeTime + translateTime

    return success: true

Editor::aceFontSize = ->
  parseFloat(@aceEditor.getFontSize()) + 'px'

Editor::performFreezeAnimation = (fadeTime = 500, translateTime = 500, cb = ->)->
  return unless @session?
  if not @session.currentlyUsingBlocks and not @currentlyAnimating
    beforeTime = +(new Date())
    setValueResult = @copyAceEditor()
    afterTime = +(new Date())
    console.log 'elapsed:', afterTime - beforeTime

    unless setValueResult.success
      if setValueResult.error
        @fireEvent 'parseerror', [setValueResult.error]
      return setValueResult

    if @aceEditor.getFirstVisibleRow() is 0
      @mainScroller.scrollTop = 0
    else
      @mainScroller.scrollTop = @session.view.getViewNodeFor(@session.tree).bounds[@aceEditor.getFirstVisibleRow()].y

    @session.currentlyUsingBlocks = true
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

      paletteAppearingWithFreeze = @session.paletteEnabled and not @session.showPaletteInTextMode

      if paletteAppearingWithFreeze
        @paletteWrapper.style.top = '0px'
        @paletteWrapper.style.left = "#{-@paletteWrapper.clientWidth}px"
        @paletteHeader.style.zIndex = 0

      @dropletElement.style.top = "0px"
      if @session.paletteEnabled and not paletteAppearingWithFreeze
        @dropletElement.style.left = "#{@paletteWrapper.clientWidth}px"
      else
        @dropletElement.style.left = "0px"

      {textElements, translationVectors} = @computePlaintextTranslationVectors()

      translatingElements = []

      for textElement, i in textElements

        # Skip anything that's
        # off the screen the whole time.
        unless 0 < textElement.bounds[0].bottom() - @session.viewports.main.y + translationVectors[i].y and
                 textElement.bounds[0].y - @session.viewports.main.y + translationVectors[i].y < @session.viewports.main.height
          continue

        div = document.createElement 'div'
        div.style.whiteSpace = 'pre'

        div.innerText = div.textContent = textElement.model.value

        div.style.font = @aceFontSize() + ' ' + @session.fontFamily
        div.style.position = 'absolute'

        div.style.left = "#{textElement.bounds[0].x - @session.viewports.main.x + translationVectors[i].x}px"
        div.style.top = "#{textElement.bounds[0].y - @session.viewports.main.y + translationVectors[i].y}px"

        div.className = 'droplet-transitioning-element'
        div.style.transition = "left #{translateTime}ms, top #{translateTime}ms, font-size #{translateTime}ms"
        translatingElements.push div

        @transitionContainer.appendChild div

        do (div, textElement) =>
          setTimeout (=>
            div.style.left = "#{textElement.bounds[0].x - @session.viewports.main.x}px"
            div.style.top = "#{textElement.bounds[0].y - @session.viewports.main.y - @fontAscent}px"
            div.style.fontSize = @fontSize + 'px'
          ), 0

      top = Math.max @aceEditor.getFirstVisibleRow(), 0
      bottom = Math.min @aceEditor.getLastVisibleRow(), @session.view.getViewNodeFor(@session.tree).lineLength - 1

      treeView = @session.view.getViewNodeFor @session.tree
      lineHeight = @aceEditor.renderer.layerConfig.lineHeight

      aceScrollTop = @aceEditor.session.getScrollTop()

      for line in [top..bottom]
        div = document.createElement 'div'
        div.style.whiteSpace = 'pre'

        div.innerText = div.textContent = line + 1

        div.style.font = @aceFontSize() + ' ' + @session.fontFamily
        div.style.width = "#{@aceEditor.renderer.$gutter.clientWidth}px"

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
            div.style.top = "#{treeView.bounds[line].y + treeView.distanceToBase[line].above - @view.opts.textHeight - @session.fontAscent - @session.viewports.main.y}px"
            div.style.fontSize = @session.fontSize + 'px'
          ), 0

      @mainCanvas.style.opacity = 0

      setTimeout (=>
        @mainCanvas.style.transition = "opacity #{fadeTime}ms linear"
        @mainCanvas.style.opacity = 1
      ), translateTime

      @dropletElement.style.transition = "left #{fadeTime}ms"

      if paletteAppearingWithFreeze
        @paletteWrapper.style.transition = @dropletElement.style.transition
        @dropletElement.style.left = "#{@paletteWrapper.clientWidth}px"
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

        @fireEvent 'toggledone', [@session.currentlyUsingBlocks]

        if cb? then do cb
      ), translateTime + fadeTime

    ), 0

    return success: true

Editor::enablePalette = (enabled) ->
  if not @currentlyAnimating and @session.paletteEnabled != enabled
    @session.paletteEnabled = enabled
    @currentlyAnimating = true

    if @session.currentlyUsingBlocks
      activeElement = @dropletElement
    else
      activeElement = @aceElement

    if not @session.paletteEnabled
      activeElement.style.transition =
        @paletteWrapper.style.transition = "left 500ms"

      activeElement.style.left = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.clientWidth}px"

      @paletteHeader.style.zIndex = 0

      @resize()

      setTimeout (=>
        activeElement.style.transition =
          @paletteWrapper.style.transition = ''

        #@paletteWrapper.style.top = '-9999px'
        #@paletteWrapper.style.left = '-9999px'

        @currentlyAnimating = false

        @fireEvent 'palettetoggledone', [@session.paletteEnabled]
      ), 500

    else
      @paletteWrapper.style.top = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.clientWidth}px"
      @paletteHeader.style.zIndex = 257

      setTimeout (=>
        activeElement.style.transition =
          @paletteWrapper.style.transition = "left 500ms"

        activeElement.style.left = "#{@paletteWrapper.clientWidth}px"
        @paletteWrapper.style.left = '0px'

        setTimeout (=>
          activeElement.style.transition =
            @paletteWrapper.style.transition = ''

          @resize()

          @currentlyAnimating = false

          @fireEvent 'palettetoggledone', [@session.paletteEnabled]
        ), 500
      ), 0


Editor::toggleBlocks = (cb) ->
  if @session.currentlyUsingBlocks
    return @performMeltAnimation 500, 1000, cb
  else
    return @performFreezeAnimation 500, 500, cb

# SCROLLING SUPPORT
# ================================

hook 'populate', 2, ->
  @mainScroller = document.createElement 'div'
  @mainScroller.className = 'droplet-main-scroller'

  # @mainScrollerIntermediary -- this is so that we can be certain that
  # any event directly on @mainScroller is in fact on the @mainScroller scrollbar,
  # so should not be captured by editor mouse event handlers.
  @mainScrollerIntermediary = document.createElement 'div'
  @mainScrollerIntermediary.className = 'droplet-main-scroller-intermediary'

  @mainScrollerStuffing = document.createElement 'div'
  @mainScrollerStuffing.className = 'droplet-main-scroller-stuffing'

  @mainScroller.appendChild @mainCanvas
  @dropletElement.appendChild @mainScroller

  # Prevent scrolling on wrapper element
  @wrapperElement.addEventListener 'scroll', =>
    @wrapperElement.scrollTop = @wrapperElement.scrollLeft = 0

  @mainScroller.addEventListener 'scroll', =>
    @session.viewports.main.y = @mainScroller.scrollTop
    @session.viewports.main.x = @mainScroller.scrollLeft

    @redrawMain()

  @paletteScroller = document.createElement 'div'
  @paletteScroller.className = 'droplet-palette-scroller'
  @paletteScroller.appendChild @paletteCanvas

  @paletteScrollerStuffing = document.createElement 'div'
  @paletteScrollerStuffing.className = 'droplet-palette-scroller-stuffing'

  @paletteScroller.appendChild @paletteScrollerStuffing
  @paletteElement.appendChild @paletteScroller

  @paletteScroller.addEventListener 'scroll', =>
    @session.viewports.palette.y = @paletteScroller.scrollTop
    @session.viewports.palette.x = @paletteScroller.scrollLeft

Editor::resizeMainScroller = ->
  @mainScroller.style.width = "#{@dropletElement.clientWidth}px"
  @mainScroller.style.height = "#{@dropletElement.clientHeight}px"

hook 'resize_palette', 0, ->
  @paletteScroller.style.top = "#{@paletteHeader.offsetHeight}px"

  @viewports.palette.height = @paletteScroller.clientHeight
  @viewports.palette.width = @paletteScroller.clientWidth

hook 'redraw_main', 1, ->
  bounds = @session.view.getViewNodeFor(@session.tree).getBounds()
  for record in @session.floatingBlocks
    bounds.unite @session.view.getViewNodeFor(record.block).getBounds()

  # We add some extra height to the bottom
  # of the document so that the last block isn't
  # jammed up against the edge of the screen.
  #
  # Default this extra space to fontSize (approx. 1 line).
  height = Math.max(
    bounds.bottom() + (@options.extraBottomHeight ? @session.fontSize),
    @dropletElement.clientHeight
  )

  if height isnt @lastHeight
    @lastHeight = height
    @mainCanvas.setAttribute 'height', height
    @mainCanvas.style.height = "#{height}px"

hook 'redraw_palette', 0, ->
  bounds = new @draw.NoRectangle()
  for entry in @session.currentPaletteBlocks
    bounds.unite @session.paletteView.getViewNodeFor(entry.block).getBounds()

  # For now, we will comment out this line
  # due to bugs
  #@paletteScrollerStuffing.style.width = "#{bounds.right()}px"
  @paletteScrollerStuffing.style.height = "#{bounds.bottom()}px"

# MULTIPLE FONT SIZE SUPPORT
# ================================
hook 'populate', 0, ->
  @fontSize = 15
  @fontFamily = 'Courier New'
  @measureCtx.font = '15px Courier New'
  @fontWidth = @measureCtx.measureText(' ').width

  metrics = helper.fontMetrics(@fontFamily, @fontSize)
  @fontAscent = metrics.prettytop
  @fontDescent = metrics.descent

Editor::setFontSize_raw = (fontSize) ->
  unless @fontSize is fontSize
    @measureCtx.font = fontSize + ' px ' + @fontFamily
    @fontWidth = @measureCtx.measureText(' ').width
    @fontSize = fontSize

    @paletteHeader.style.fontSize = "#{fontSize}px"
    @gutter.style.fontSize = "#{fontSize}px"
    @tooltipElement.style.fontSize = "#{fontSize}px"

    @session.view.opts.textHeight =
      @session.paletteView.opts.textHeight =
      @session.dragView.opts.textHeight = helper.getFontHeight @session.fontFamily, @session.fontSize

    metrics = helper.fontMetrics(@session.fontFamily, @session.fontSize)
    @session.fontAscent = metrics.prettytop
    @session.fontDescent = metrics.descent

    @session.view.clearCache()
    @session.paletteView.clearCache()
    @session.dragView.clearCache()

    @view.draw.setGlobalFontSize @fontSize
    @paletteView.draw.setGlobalFontSize @fontSize
    @dragView.draw.setGlobalFontSize @fontSize

    @gutter.style.width = @aceEditor.renderer.$gutterLayer.gutterWidth + 'px'

    @redrawMain()
    @rebuildPalette()

Editor::setFontFamily = (fontFamily) ->
  @measureCtx.font = @fontSize + 'px ' + fontFamily
  @draw.setGlobalFontFamily fontFamily

  @session.fontFamily = fontFamily

  @session.view.opts.textHeight = helper.getFontHeight @session.fontFamily, @session.fontSize
  @session.fontAscent = helper.fontMetrics(@session.fontFamily, @session.fontSize).prettytop

  @session.view.clearCache(); @session.dragView.clearCache()
  @gutter.style.fontFamily = fontFamily
  @tooltipElement.style.fontFamily = fontFamily

  @redrawMain()
  @rebuildPalette()

Editor::setFontSize = (fontSize) ->
  @setFontSize_raw fontSize
  @resizeBlockMode()

# LINE MARKING SUPPORT
# ================================
Editor::getHighlightPath = (model, style, view = @session.view) ->
  path = view.getViewNodeFor(model).path.clone()

  path.style.fillColor = null
  path.style.strokeColor = style.color
  path.style.lineWidth = 3
  path.noclip = true; path.bevel = false

  return path

Editor::markLine = (line, style) ->
  return unless @session?

  block = @session.tree.getBlockOnLine line

  @view.getViewNodeFor(block).mark style

Editor::markBlock = (block, style) ->
  return unless @session?

  @view.getViewNodeFor(block).mark style

# ## Mark
# `mark(line, col, style)` will mark the first block after the given (line, col) coordinate
# with the given style.
Editor::mark = (location, style) ->
  return unless @session?

  block = @session.tree.getFromTextLocation location
  block = block.container ? block

  @view.getViewNodeFor(block).mark style

  @redrawHighlights() # TODO MERGE investigate

Editor::clearLineMarks = ->
  @session.view.clearMarks()

  @redrawHighlights()

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

    treeView = @session.view.getViewNodeFor @session.tree

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

    newParse = @session.mode.parse value, {
      wrapAtRoot: true
      preserveEmpty: @session.options.preserveEmpty
    }

    unless @session.tree.start.next is @session.tree.end
      removal = new model.List @session.tree.start.next, @session.tree.end.prev
      @spliceOut removal

    unless newParse.start.next is newParse.end
      @spliceIn new model.List(newParse.start.next, newParse.end.prev), @session.tree.start

    @removeBlankLines()
    @redrawMain()

    return success: true

  catch e
    return success: false, error: e

Editor::setValue = (value) ->
  if not @session?
    return @aceEditor.setValue value

  oldScrollTop = @aceEditor.session.getScrollTop()

  @setAceValue value
  @resizeTextMode()

  @aceEditor.session.setScrollTop oldScrollTop

  if @session.currentlyUsingBlocks
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
  if @session?.currentlyUsingBlocks
    return @addEmptyLine @session.tree.stringify({
      preserveEmpty: @session.options.preserveEmpty
    })
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
  @mainCanvas.style.transition = @paletteWrapper.style.transition =
    @highlightCanvas.style.transition = ''

  if useBlocks
    if not @session?
      throw new ArgumentError 'cannot switch to blocks if a session has not been set up.'

    unless @session.currentlyUsingBlocks
      @setValue_raw @getAceValue()

    @dropletElement.style.top = '0px'
    if @session.paletteEnabled
      @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'
      @dropletElement.style.left = "#{@paletteWrapper.clientWidth}px"
    else
      @paletteWrapper.style.top = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"
      @dropletElement.style.left = '0px'

    @aceElement.style.top = @aceElement.style.left = '-9999px'
    @session.currentlyUsingBlocks = true

    @lineNumberWrapper.style.display = 'block'

    @mainCanvas.style.opacity =
      @highlightCanvas.style.opacity = 1

    @resizeBlockMode(); @redrawMain()

  else
    # Forbid melting if there is an empty socket. If there is,
    # highlight it in red.
    if @session? and not @session.options.preserveEmpty and not @checkAndHighlightEmptySockets()
      @redrawMain()
      return

    @hideDropdown()

    paletteVisibleInNewState = @session?.paletteEnabled and @session.showPaletteInTextMode

    oldScrollTop = @aceEditor.session.getScrollTop()

    if @session?.currentlyUsingBlocks
      @setAceValue @getValue()

    @aceEditor.resize true

    @aceEditor.session.setScrollTop oldScrollTop

    @dropletElement.style.top = @dropletElement.style.left = '-9999px'
    if paletteVisibleInNewState
      @paletteWrapper.style.top = @paletteWrapper.style.left = '0px'
    else
      @paletteWrapper.style.top = '0px'
      @paletteWrapper.style.left = "#{-@paletteWrapper.offsetWidth}px"

    @aceElement.style.top = '0px'
    if paletteVisibleInNewState
      @aceElement.style.left = "#{@paletteWrapper.clientWidth}px"
    else
      @aceElement.style.left = '0px'

    @session?.currentlyUsingBlocks = false

    @lineNumberWrapper.style.display = 'none'

    @mainCanvas.style.opacity =
      @highlightCanvas.style.opacity = 0

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
  @dragCanvas.style.transform = "translate(-9999px, -9999px)"

  @dragCover.style.display = 'none'

# FAILSAFE END DRAG HACK
# ================================

hook 'mousedown', 10, ->
  if @draggingBlock?
    @endDrag()

Editor::endDrag = ->
  # Ensure that the cursor is not in a socket.
  if @cursorAtSocket()
    @setCursor @session.cursor, (x) -> x.type isnt 'socketStart'

  @clearDrag()
  @draggingBlock = null
  @draggingOffset = null
  @lastHighlightPath?.deactivate?()
  @lastHighlight = @lastHighlightPath = null

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
  @cursorCtx = document.createElementNS SVG_STANDARD, 'g'
  @textCursorPath = new @view.draw.Path([], false, {
    'strokeColor': '#000'
    'lineWidth': '2'
    'fillColor': 'rgba(0, 0, 256, 0.3)'
    'cssClass': 'droplet-cursor-path'
  })
  @textCursorPath.setParent @mainCtx

  cursorElement = document.createElementNS SVG_STANDARD, 'path'
  cursorElement.setAttribute 'fill', 'none'
  cursorElement.setAttribute 'stroke', '#000'
  cursorElement.setAttribute 'stroke-width', '3'
  cursorElement.setAttribute 'stroke-linecap', 'round'
  cursorElement.setAttribute 'd', "M#{@view.opts.tabOffset + CURSOR_WIDTH_DECREASE / 2} 0 " +
      "Q#{@view.opts.tabOffset + @view.opts.tabWidth / 2} #{@view.opts.tabHeight}" +
      " #{@view.opts.tabOffset + @view.opts.tabWidth - CURSOR_WIDTH_DECREASE / 2} 0"

  @cursorPath = new @view.draw.ElementWrapper(cursorElement)
  @cursorPath.setParent @mainCtx

  @mainCanvas.appendChild @cursorCtx

Editor::strokeCursor = (point) ->
  return unless point?
  @cursorPath.element.setAttribute 'transform', "translate(#{point.x}, #{point.y})"
  @qualifiedFocus @getCursor(), @cursorPath

Editor::highlightFlashShow = ->
  if @flashTimeout? then clearTimeout @flashTimeout
  if @cursorAtSocket()
    @textCursorPath.activate()
  else
    @cursorPath.activate()
  @highlightsCurrentlyShown = true
  @flashTimeout = setTimeout (=> @flash()), 500

Editor::highlightFlashHide = ->
  if @flashTimeout? then clearTimeout @flashTimeout
  if @cursorAtSocket()
    @textCursorPath.deactivate()
  else
    @cursorPath.deactivate()
  @highlightsCurrentlyShown = false
  @flashTimeout = setTimeout (=> @flash()), 500

Editor::editorHasFocus = ->
  document.activeElement in [@dropletElement, @hiddenInput, @copyPasteInput] and
  document.hasFocus()

Editor::flash = ->
  return unless @session?

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
    @cursorCtx.style.opacity = CURSOR_UNFOCUSED_OPACITY

  @dropletElement.addEventListener 'blur', blurCursors
  @hiddenInput.addEventListener 'blur', blurCursors
  @copyPasteInput.addEventListener 'blur', blurCursors

  focusCursors = =>
    @highlightFlashShow()
    @cursorCtx.style.transition = ''
    @cursorCtx.style.opacity = 1

  @dropletElement.addEventListener 'focus', focusCursors
  @hiddenInput.addEventListener 'focus', focusCursors
  @copyPasteInput.addEventListener 'focus', focusCursors

  @flashTimeout = setTimeout (=> @flash()), 0

# ONE MORE DROP CASE
# ================================

# TODO possibly move this next utility function to view?
Editor::viewOrChildrenContains = (model, point, view = @session.view) ->
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
  treeView = @session.view.getViewNodeFor @session.tree
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

  unless @lastGutterHeight is Math.max(@dropletElement.clientHeight, @mainCanvas.clientHeight)
    @lastGutterHeight = Math.max(@dropletElement.clientHeight, @mainCanvas.clientHeight)
    @gutter.style.height = @lastGutterHeight + 'px'

Editor::addLineNumberForLine = (line) ->
  treeView = @session.view.getViewNodeFor @session.tree

  if line of @lineNumberTags
    lineDiv = @lineNumberTags[line].tag

  else
    lineDiv = document.createElement 'div'
    lineDiv.innerText = lineDiv.textContent = line + 1
    @lineNumberTags[line] = {
      tag: lineDiv
      lastPosition: null
    }

  if treeView.bounds[line].y isnt @lineNumberTags[line].lastPosition
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

    lineDiv.style.paddingTop = "#{treeView.distanceToBase[line].above - @view.opts.textHeight - @session.fontAscent}px"
    lineDiv.style.paddingBottom = "#{treeView.distanceToBase[line].below - @session.fontDescent}"

    lineDiv.style.height =  treeView.bounds[line].height + 'px'
    lineDiv.style.fontSize = @session.fontSize + 'px'

    @lineNumberWrapper.appendChild lineDiv
    @lineNumberTags[line].lastPosition = treeView.bounds[line].y

TYPE_SEVERITY = {
  'error': 2
  'warning': 1
  'info': 0
}
TYPE_FROM_SEVERITY = ['info', 'warning', 'error']
getMostSevereAnnotationType = (arr) ->
  TYPE_FROM_SEVERITY[Math.max.apply(this, arr.map((x) -> TYPE_SEVERITY[x.type]))]

Editor::findLineNumberAtCoordinate = (coord) ->
  treeView = @session.view.getViewNodeFor @session.tree
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
  return unless @session?
  treeView = @session.view.getViewNodeFor @session.tree

  top = @findLineNumberAtCoordinate @session.viewports.main.y
  bottom = @findLineNumberAtCoordinate @session.viewports.main.bottom()

  for line in [top..bottom]
    @addLineNumberForLine line

  for line, tag of @lineNumberTags
    if line < top or line > bottom
      @lineNumberTags[line].tag.parentNode.removeChild @lineNumberTags[line].tag
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
    pressedVKey = pressedXKey = false
    if event.keyCode is 86
      pressedVKey = true
    else if event.keyCode is 88
      pressedXKey = true

  @copyPasteInput.addEventListener 'input', =>
    if not @session? or @session.readOnly
      return
    if pressedVKey and not @cursorAtSocket()
      str = @copyPasteInput.value; lines = str.split '\n'

      # Strip any common leading indent
      # from all the lines of the pasted tet
      minIndent = lines.map((line) -> line.length - line.trimLeft().length).reduce((a, b) -> Math.min(a, b))
      str = lines.map((line) -> line[minIndent...]).join('\n')
      str = str.replace /^\n*|\n*$/g, ''

      try
        blocks = @session.mode.parse str, {context: @getCursor().parent.parseContext}
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
  bounds = @session.view.getViewNodeFor(@session.tree).totalBounds
  return {
    width: bounds.width
    height: bounds.height
  }

Editor::viewportDimensions = ->
  return @viewports.main

# LINE LOCATION API
# =================
Editor::getLineMetrics = (row) ->
  viewNode = @session.view.getViewNodeFor @session.tree
  bounds = (new @session.view.draw.Rectangle()).copy(viewNode.bounds[row])
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
  console.log(@session.view.getViewNodeFor(hitTestResult).serialize(line))

# CLOSING FOUNDATIONAL STUFF
# ================================

# Order the arrays correctly.
for key of unsortedEditorBindings
  unsortedEditorBindings[key].sort (a, b) -> if a.priority > b.priority then -1 else 1

  editorBindings[key] = []

  for binding in unsortedEditorBindings[key]
    editorBindings[key].push binding.fn
