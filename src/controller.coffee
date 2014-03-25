# ICE Editor Controller
#
# Copyright (c) 2014 Anthony Bau.
#
# MIT License

define ['ice-coffee', 'ice-draw', 'ice-model'], (coffee, draw, model) ->
  
  PADDING = 5
  INDENT_SPACES = 2
  PALETTE_MARGIN = 10
  PALETTE_LEFT_MARGIN = 0
  PALETTE_TOP_MARGIN = 0
  PALETTE_WIDTH = 300
  MIN_DRAG_DISTANCE = 5
  FONT_SIZE = 15
  ANIMATION_FRAME_RATE = 50 # FPS
  SCROLL_INTERVAL = 50

  exports = {}

  # Convenience functions for interacting with the DOM,
  # used in the freeze/melt animations to find destination positions
  # of text elements. Hidden.
  findPosTop = (obj) ->
    top = 0
    while true
      top += obj.offsetTop
      unless (obj = obj.offsetParent)? then break

    return top

  findPosLeft = (obj) ->
    left = 0
    while true
      left += obj.offsetLeft
      unless (obj = obj.offsetParent)? then break

    return left

  # ## AnimatedColor ##
  # Later on, we will need this simple class for color interpolation during freeze/melt animation
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

  # ## FloatingBlockDescriptor ##
  # A struct representing a block and position for floating blocks
  class FloatingBlockDescriptor
    constructor: ({position: @position, block: @block}) ->

    clone: -> new FloatingBlockDescriptor
      position: new draw.Point @position.x, @position.y
      block: @block.clone()
  
  # ## iceEditorChangeEvent ##
  # Simple struct that serves as the argument type to
  # @onChange()
  exports.IceEditorChangeEvent = class IceEditorChangeEvent
    constructor: (@block, @target) ->

  # #The Editor class
  # This class contains all the controller functions for ICE Editor.
  # Call:
  #   new Editor(DOMElement, palette)
  # to initialize an ICE editor in an element.

  exports.Editor = class Editor
    constructor: (wrapper, @paletteBlocks) ->
      # Default font size
      @fontSize = FONT_SIZE

      @aceEl = document.createElement 'div'; @aceEl.className = 'ice_ace'
      wrapper.appendChild @aceEl
      
      # Defaults for ace editor
      @ace = ace.edit @aceEl
      @ace.setTheme 'ace/theme/chrome'
      @ace.getSession().setMode 'ace/mode/coffee'
      @ace.getSession().setTabSize 2
      @ace.setShowPrintMargin false
      @ace.setFontSize 15
      
      # We want to bind the font size of ICE editor to the font
      # size of ACE editor, so that animations always remains smooth.
      #
      # To this end, we listen to ACE editor "change" and reset.
      #
      # The application layer should trigger setFontSize() any
      # time the font size changes without ACE editor text changing.
      @ace.on 'change', =>
        @setFontSize @ace.getFontSize()

      @el = document.createElement 'div'; @el.className = 'ice_editor'
      wrapper.appendChild @el
      
      # Give our element a tabindex so we can keep track of its focus.
      @el.tabIndex = 0

      # ## Field declaration ##
      # (useful to have all in one place)
      
      # If we did not recieve palette blocks in the constructor, we have no palette.
      @paletteBlocks ?= []
      
      # We discard the blocks we are fed, preferring to clone them
      # to be as unintrusive as possible (also to get blocks unattached to any
      # token stream)
      @paletteBlocks = (paletteBlock.clone() for paletteBlock in @paletteBlocks)

      # MODEL instances (program state)
      @tree = new model.Segment() # The root tree
      @floatingBlocks = [] # The other root blocks that are not attached to the root tree
      
      # TEXT INPUT interactive fields
      @focus = null # The focused empty socket, if such thing exists.
      @editedText = null # The focused textToken, if such thing exists (associated with @focus).
      @handwritten = false # Are we editing a handwritten line?
      @hiddenInput = null
      @ephemeralOldFocusValue = null

      @isEditingText = => @focus? and @hiddenInput is document.activeElement

      textInputAnchor = textInputHead = null # The selection anchor and head in the input

      textInputSelecting = false

      _editedInputLine = -1

      # NORMAL DRAG interactive fields
      @selection = null # The currently-dragged set of blocks

      # LASSO SELECT interactive fields
      @lassoSegment = null
      @_lassoBounds = null

      # CURSOR interactive fields
      @cursor = new model.CursorToken()

      @tree.start.insert @cursor

      # UNDO STACK
      @undoStack = []

      # Scroll offset
      @scrollOffset = new draw.Point 0, 0
      @paletteScrollOffset = new draw.Point 0, 0

      # Touchscreen scrolling fields
      @scrollingPalette = false

      offset = null
      highlight = null
      
      @currentlyAnimating = false

      # Remember the current editor state, so
      # that we can refuse animations that do not apply.
      @currentlyUsingBlocks = true

      # ## DOM SETUP ##

      # The main canvas
      @main = document.createElement 'canvas'; @main.className = 'canvas'

      # The palette canvas
      @palette = document.createElement 'canvas'; @palette.className = 'palette'

      # The drag canvas
      drag = document.createElement 'canvas'; drag.className = 'drag'

      computeCanvasDimensions = =>
        @main.height = @el.offsetHeight
        @main.width = @el.offsetWidth * 2 - PALETTE_WIDTH
        
        @palette.height = @el.offsetHeight
        @palette.width = PALETTE_WIDTH

        drag.height = @el.offsetHeight
        drag.width = @el.offsetWidth * 2 - PALETTE_WIDTH
      
      # We need to resize the canvases any time the editor resizes.
      # We will bind this to the document resize function, but this function
      # should be called at any other time the editor is resized.
      window.addEventListener 'resize', @resize = =>
        computeCanvasDimensions()

        @redraw(); @redrawPalette()

      computeCanvasDimensions()

      # The hidden input
      @hiddenInput = document.createElement 'input'; @hiddenInput.className = 'hidden_input'

      # The mouse tracking div
      track = document.createElement 'div'; track.className = 'trackArea'

      # Invisible-scrollers hack.
      paletteScroller = document.createElement 'div'; paletteScroller.className = 'ice_palette_scroller'
      paletteScrollerStuffing = document.createElement 'div'; paletteScrollerStuffing.className = 'ice_palette_scroller_stuffing'

      mainScroller = document.createElement 'div'; mainScroller.className = 'ice_main_scroller'
      mainScrollerStuffing = document.createElement 'div'; mainScrollerStuffing.className = 'ice_main_scroller_stuffing'
      
      track.appendChild paletteScroller
      paletteScroller.appendChild paletteScrollerStuffing

      track.appendChild mainScroller
      mainScroller.appendChild mainScrollerStuffing
      
      # Append the children
      for child in [@main, @palette, drag, track, @hiddenInput]
        @el.appendChild child

      # Get the contexts from each canvas
      @mainCtx = @main.getContext '2d'
      @dragCtx = drag.getContext '2d'
      @paletteCtx = @palette.getContext '2d'
      
      # Transform to allow border.
      # In the css, we also put in a pixel margin,
      # so that the image actually ends up in the same spot.
      @dragCtx.setTransform 1, 0, 0, 1, 1, 1

      # The main context will be used for draw.js's text measurements (this is a bit of a hack)
      draw._setCTX @mainCtx

      # ## Convenience Functions ##
      # General-purpose methods that call the view (rendering functions)
      
      @clear = =>
        @mainCtx.clearRect @scrollOffset.x, @scrollOffset.y, @main.width, @main.height

      @clearPalette = =>
        @paletteCtx.clearRect @paletteScrollOffset.x, @paletteScrollOffset.y, @palette.width, @palette.height
      
      # ## Redraw ##
      # redraw does three main things: redraws the root tree (@tree)
      # redraws any floating blocks (@floatingBlocks), and draws the bounding rectangle
      # of any lassoed segments.
      @redraw = =>
        if @currentlyAnimating then return

        draw._setGlobalFontSize @fontSize

        # Clear the main canvas
        @clear()

        # Compute the root tree
        @tree.view.compute()

        # Draw it on the main context
        @tree.view.draw @mainCtx
        
        # Update the main scroller dimensions
        # to fit the document dimensions
        bounds = @tree.view.getBounds()
        mainScrollerStuffing.style.height = bounds.bottom()
        mainScrollerStuffing.style.width = bounds.right()
        
        # Alert the lasso segment, if it exists, to recompute its bounds
        if @lassoSegment?
          # Get those compute bounds
          @_lassoBounds = @lassoSegment.view.getBounds()

          for float in @floatingBlocks
            if @lassoSegment is float.block
              @_lassoBounds.translate float.position
          
          # Unless we're already drawing it on the drag canvas, draw the lasso segment borders on the main canvas
          unless @lassoSegment is @selection
            @_lassoBounds.stroke @mainCtx, '#000'
            @_lassoBounds.fill @mainCtx, 'rgba(0, 0, 256, 0.3)'

        for float in @floatingBlocks
          view = float.block.view
          
          # Recompute this floating block's coordinates
          view.compute()
          view.translate float.position

          # Draw it on the main context
          view.draw @mainCtx
      
      # ## attemptReparse ##
      # This will be triggered by most cursor operations. It finds all handwritten blocks that do not contain the cursor,
      # and attempts to replace them with the true-blockified representation of them.
      @attemptReparse = =>
        # Set up our linked-list parsing state
        head = @tree.start; stack = []

        # This will ultimately contain a list of blocks not to parse.
        excludes = []
        
        # This will ultimately contain all non-reparsed handwritten lines.
        reparseQueue = []

        while head isnt @tree.end
          switch head.type
            when 'blockStart' then stack.push head.block
            when 'indentStart' then stack.push head.indent
            when 'socketStart'
              # If we have just encountered the socket associated with a 
              # handwritten block, push that handwritten block to the list of things that we may need
              # to reparse.
              if head.socket.handwritten and stack[stack.length - 1].type is 'block' and head.socket isnt @focus
                reparseQueue.push stack[stack.length - 1]

              stack.push head.socket
            when 'cursor'
              excludes.push element for element in stack
            when 'blockEnd', 'socketEnd', 'indentEnd' then stack.pop()

          head = head.next

        # We have now assembled all the blocks that contain the cursor (at some level),
        # and also all the handwritten blocks. We will reparse all the handwritten blocks
        # that do not contain the cursor.

        for handwrittenBlock in reparseQueue
          unless handwrittenBlock in excludes
            # To replace a block, we record its parent,
            # splice it out, and splice the replacement in.
            try
              testHead = parent = handwrittenBlock.start.prev

              # Make sure that this block is actually in the tree
              # (as we don't want to log an undo event for a no-op)
              until testHead is null or testHead is @tree.start
                testHead = testHead.prev
              
              if testHead is null
                continue
              
              newBlock = (coffee.parse handwrittenBlock.stringify()).start.next

              if newBlock.type isnt 'blockStart' then continue
              else newBlock = newBlock.block

              # Add an undo operation
              @addMicroUndoOperation
                type: 'handwrittenReparse'
                location: handwrittenBlock.start.getSerializedLocation()
                before: handwrittenBlock.clone()
                after: newBlock.clone()

              # Unfortunately moveTo handles whitepsace for us,
              # which we do not want to do, so we must splice the block out ourselves,
              # and move the new block in verbatim.
              handwrittenBlock.start.prev.append newBlock.start
              newBlock.end.append handwrittenBlock.end.next

              # Fully unlink the handwritten block
              handwrittenBlock.start.prev = null; handwrittenBlock.end.next = null
        
        # We have done some modifications, so we must redraw.
        @redraw()
      
      # ## @addMicroUndoOperation ##
      # Bureaucracy wrapper for pushing to the undo stack.
      @addMicroUndoOperation = (operation) =>
        # For clarity, we ensure that the operation
        # is of one of the known types.
        unless operation?.type in [
          'socketTextChange'

          'socketReparse'
          'handwrittenReparse'
          
          'blockMove'
          'blockMoveToFloat'
          'blockMoveFromFloat'
          
          'createIndent'
          'destroyIndent'

          'createSegment'
          'destroySegment'
          'setValue'
        ] then return
        @undoStack.push operation

      @captureUndoEvent = =>
        unless @undoStack[@undoStack.length - 1]?.type is 'operationMarker'
          @undoStack.push
            type: 'operationMarker'

      # ## undo ##
      # Actually reverse some operations in the undo stack.
      @undo = =>
        @lassoSegment = null

        if @undoStack.length is 0 then return

        operation = @undoStack.pop()

        # If last logged mutationwas to capture an undo operation,
        # skip over it (undo should actually do at least one mutation action).
        if operation.type is 'operationMarker' then operation = @undoStack.pop()
        
        until (not operation?) or operation.type is 'operationMarker'
          if @focus? then setTextInputFocusRaw null

          # Get the cursor out of the way
          oldCursorLocation = @cursor.getSerializedLocation()
          @cursor.remove()

          switch operation.type
            # ### socketTextChange ###
            # Represents a change in socket text;
            # to undo simply change the text back.
            #
            # When we do this we will also
            # put the cursor into the input that changed.
            when 'socketTextChange'
              socketStart = @tree.getTokenAtLocation operation.location
              socketStart.socket.content()?.remove()
              socketStart.insert new model.TextToken operation.before
              
              setTextInputFocusRaw socketStart.socket
              textInputSelectAll()

            # ### socketReparse ###
            # Represents an automatic reparse of
            # the text in a socket.
            #
            # To undo replace the parsed blocks with the unparsed
            # text. When we do this we will put the cursor near
            # the block.
            when 'socketReparse'
              socketStart = @tree.getTokenAtLocation operation.location
              socketStart.append socketStart.socket.end
              socketStart.insert operation.before

              moveCursorToRaw socketStart

            # ### handwrittenReparse ###
            # Represents an automatic reparse of
            # a handwritten block.
            #
            # To undo replace the parsed blocks with the unparsed
            # handwritten block. When we do this we will put the cursor near
            # the block.
            when 'handwrittenReparse'
              # Get the block we want to replace
              attachBefore = @tree.getTokenAtLocation(operation.location).prev
              attachAfter = attachBefore.next.block.end.next
              
              # Splice it out and splice
              # the new block in.
              attachBefore.append operation.before.start
              operation.before.end.append attachAfter

              moveCursorToRaw attachAfter

            # ### blockMove ###
            # Represents the vanilla block or segment move.
            #
            # To undo, delete the block at the ending location
            # and insert an idenitcal block at the starting location.
            # When we do this we will put the cursor at the inserted block.
            when 'blockMove'
              # If the block was not moved to (null) (i.e. is still in the tree),
              # splice it out.
              if operation.after?
                pos = @tree.getTokenAtLocation operation.after
                
                # If moving the block here removed
                # some text from a socket (text in an
                # input is deleted when you drag a block over it),
                # put that text back in.
                if operation.displaced?
                  pos.insert operation.displaced
                
                # We might be in front of some segments or cursors,
                # so keep going to seek the beginning of the block.
                until pos.type is operation.block.start.type then pos = pos.next
                
                # Splice out.
                if operation.block.type is 'segment'
                  pos.segment.moveTo null
                else
                  pos.block.moveTo null
                
                unless operation.before? then moveCursorToRaw @tree.getTokenAtLocation operation.after
              
              # If the block was not moved from (null) (i.e. was formerly in the tree),
              # splice it in.
              if operation.before?
                target = @tree.getTokenAtLocation operation.before

                operation.block.moveTo target

                moveCursorToRaw operation.block.end
            
            # ### blockMoveToFloat ###
            # Represents moving a block from the tree (or palette)
            # to a floating position.
            #
            # To undo, remove the block from the list of floating blocks,
            # and splice it back into the 
            when 'blockMoveToFloat'
              # Remove the block from the list of floating blocks
              @floatingBlocks.splice operation.floatingBlockIndex
              
              # If the block used to be in the tree, splice it back in.
              if operation.before?
                target = @tree.getTokenAtLocation operation.before

                operation.block.moveTo target

                moveCursorToRaw operation.block.end
            
            # ### blockMoveFromFloat ###
            # Represents a block from floating into the tree (or palette).
            #
            # To undo, push an identical record of a floating block into
            # the list of floating blocks, and delete the thing in the tree
            # at the ending position.
            when 'blockMoveFromFloat'
              if operation.after?
                if operation.block.type is 'segment'
                  @tree.getTokenAtLocation(operation.after).block.moveTo null
                else
                  @tree.getTokenAtLocation(operation.after).segment.moveTo null
                
                # As with blockMove, we may have displaced some
                # text, so reinsert it.
                if operation.displaced?
                  @tree.getTokenAtLocation(operation.after).insert operation.displaced

              @floatingBlocks.push operation.before
            
            # ### createIndent ###
            # Represents creating an indent with the 'tab' key.
            #
            # To undo, destroy the given indent.
            when 'createIndent'
              attachBefore = @tree.getTokenAtLocation(operation.location)
              attachBefore.prev.append attachBefore.indent.end.next

              moveCursorToRaw attachBefore
            
            # ### destroyIndent ###
            # Represents destroying an indent with the 'delete key'
            #
            # To undo, reinsert an empty indent at the given location.
            when 'destroyIndent'
              head = @tree.getTokenAtLocation operation.location
              
              # Create and insert a new indent (default 2 spaces)
              newIndent = new model.Indent INDENT_SPACES
              head.prev.insert newIndent.start; head.prev.insert newIndent.end
              
              # Fill the indent with two newlines (as any empty indent must be)
              # This is done mainly to satisfy the undo stack's need to know exactly
              # what an indent looked like before a block move operation happened.
              newIndent.start.insert new model.NewlineToken()

              moveCursorToRaw newIndent.start
            
            # ### createSegment ###
            # Represents creating a segment in the tree,
            # usually by user lasso select.
            #
            # To undo, simply remove the given segment.
            when 'createSegment'
              segmentStart = @tree.getTokenAtLocation operation.start

              moveCursorToRaw segmentStart

              segmentStart.segment.remove()
            
            # ### destroySegment ###
            # Represents destroying a segment in the tree,
            # usually done automatically after a lasso select operation
            # is over.
            #
            # To undo, insert a segment at the given start/end positions.
            when 'destroySegment'
              segment = new model.Segment()

              @tree.getTokenAtLocation(operation.start).insertBefore segment.start
              @tree.getTokenAtLocation(operation.end).insert segment.end

              moveCursorToRaw segment.end
            
            # ### setValue ###
            # Represents changing the entire content of the editor
            # with setValue().
            #
            # To undo, simply set the value to what it was before.
            when 'setValue'
              @tree = operation.before

          operation = @undoStack.pop()

        # If we have failed to reinsert the cursor, put it
        # wherever it was before
        if @cursor.prev is null and @cursor.next is null
          moveCursorTo @tree.getTokenAtLocation oldCursorLocation
        
        scrollCursorIntoView()
        @redraw()

        unless @focus? then setTimeout (=> @el.focus()), 0

        return @undoStack.length
      
      # ## triggerOnChangeEvent ##
      # A wrapper function which fires every time
      # the editor content might have changed.
      # We allow bindings to this function with the @onChange property,
      # and do some bureaucracy here as well.
      @triggerOnChangeEvent = (event) =>
        # Set the ACE editor content simultaneously
        #@ace.setValue @getValue()
        if @onChange? then try @onChange event

      
      # ## moveBlockTo ##
      # We want to have some bottleneck for most block moves;
      # this is it. It manages things like the undo stack.
      moveBlockTo = (block, target) =>
        # Find the parent of this block,
        # the parent being the token for which we can call block.moveTo(parent)
        # and result in the current location.
        parent = block.start.prev
        while parent? and (parent.type is 'newline' or (parent.type is 'segmentStart' and parent.segment isnt @tree) or parent.type is 'cursor') then parent = parent.prev
        
        # Check to see if this is a floating block.
        # Note that if it is a floating block, it could only have gotten that way
        # by being picked up first, so (before) is null.
        for float in @floatingBlocks
          if block is float.block
            @addMicroUndoOperation
              type: 'blockMoveFromFloat'
              before: float.clone()
              after: if target? then target.getSerializedLocation() else null
              block: block.clone()
              displaced: if target?.type is 'socketStart' then (target.socket.content()?.clone() ? null) else null
          
          block.moveTo target
          @triggerOnChangeEvent new IceEditorChangeEvent block, target

          return
        
        # Log the undo operation
        @addMicroUndoOperation
          type: 'blockMove'
          before: if parent? then parent.getSerializedLocation() else null
          after: if target? then target.getSerializedLocation() else null
          displaced: if target?.type is 'socketStart' then (target.socket.content()?.clone() ? null) else null
          block: block.clone()

        block.moveTo target

        @triggerOnChangeEvent new IceEditorChangeEvent block, target

      # The redrawPalette function ought to be called only once in the current code structure.
      # If we want to scroll the palette later on, then this will be called to do so.
      @redrawPalette = =>
        @clearPalette()

        draw._setGlobalFontSize @fontSize

        # We need to keep track of the bottom edge of the last element,
        # so we know where to put the top of the next one (there will be a margin of PALETTE_MARGIN between them)
        lastBottomEdge = PALETTE_TOP_MARGIN
        bounds = new draw.NoRectangle()

        for paletteBlock in @paletteBlocks
          # Compute the coordinates
          paletteBlock.view.compute()

          # Translate it into position
          paletteBlock.view.translate new draw.Point PALETTE_LEFT_MARGIN, lastBottomEdge

          # Increment the running height count
          lastBottomEdge = paletteBlock.view.bounds[paletteBlock.view.lineEnd].bottom() + PALETTE_MARGIN # Add margin

          # Finish and draw the palette block
          paletteBlock.view.draw @paletteCtx

          bounds.unite paletteBlock.view.getBounds()

        # Set the size of palette scroller stuffing
        # to match palette size
        paletteScrollerStuffing.style.height = lastBottomEdge
        paletteScrollerStuffing.style.width = bounds.width
      
      # (call it right away)
      @redrawPalette()
      
      # ## Cursor operations ##
      # Functions that manipulate the cursor. The cursor is a normal ICE editor model token
      # that is rendered specially in the View.

      insertHandwrittenBlock = =>
        setTextInputFocus null
        @captureUndoEvent()

        # Create the new block and socket for a new handwritten line
        newBlock = new model.Block(); newSocket = new model.Socket null
        newSocket.handwritten = true

        # Put the new socket into the new block
        newBlock.start.insert newSocket.start; newBlock.end.prev.insert newSocket.end
        
        head = @cursor.prev
        while head.type in ['newline', 'cursor', 'segmentStart', 'segmentEnd'] and head isnt @tree.start
          head = head.prev
        
        # Move it to where the cursor should be
        moveBlockTo newBlock, head

        @redraw()
        setTextInputFocus newSocket

        scrollCursorIntoView()

      scrollCursorIntoView = =>
        @redraw()
        
        # If the cursor has scrolled out of view, scroll it back into view.
        if @cursor.view.point.y < @scrollOffset.y
          @scrollOffset.y = @cursor.view.point.y
          mainScroller.scrollTop = @scrollOffset.y
          @mainCtx.setTransform 1, 0, 0, 1, -@scrollOffset.x, -@scrollOffset.y

          @redraw()
        else if @cursor.view.point.y > (@scrollOffset.y + @main.height)
          @scrollOffset.y = @cursor.view.point.y - @main.height
          mainScroller.scrollTop = @scrollOffset.y
          @mainCtx.setTransform 1, 0, 0, 1, -@scrollOffset.x, -@scrollOffset.y

          @redraw()

      moveCursorToRaw = (token) =>
        # Make sure that we are actually inside the tree
        head = token
        until head is null or head is @tree.end
          head = head.next

        # If we are not, then give up.
        if head is null then return

        # Otherwise, splice out
        @cursor.remove()

        # Find the newline or end markup after the given token.
        # Special case: we can also focus the very start of the tree.
        head = token
        unless head is @tree.start
          until (not head?) or head.type in ['newline', 'indentEnd', 'segmentEnd'] then head = head.next

        # If there is no place to put the cursor, give up.
        unless head? then return

        # Splice in
        if head.type is 'newline' or head is @tree.start
          head.insert @cursor
        else
          head.insertBefore @cursor
    
      moveCursorTo = (token) =>
        moveCursorToRaw token

        # We have moved the cursor, so it might now be possible
        # to reparse some handwritten blocks. Try it.
        @attemptReparse()

        scrollCursorIntoView()
      
      moveCursorBeforeRaw = (token) =>
        # Splice out
        @cursor.remove()
        
        # Splice in
        token.insertBefore @cursor
      
      moveCursorBefore = (token) =>
        moveCursorBeforeRaw token

        # We have moved the cursor, so it might now be possible
        # to reparse some handwritten blocks. Try it.
        @attemptReparse()

        scrollCursorIntoView()

      deleteFromCursor = =>
        # Seek the block that we want to delete (i.e. the block that ends first before the cursor, if such thing exists)
        head = @cursor.prev
        while head isnt null and head.type isnt 'indentStart' and head.type isnt 'blockEnd'
          head = head.prev
        
        # If there is no block before the cursor, give up.
        if head is null then return
        
        # If there is a block before us, delete it and redraw.
        if head.type is 'blockEnd'
          moveBlockTo head.block, null; @redraw()

        # If there is an indent before us and the indent is empty, delete it and redraw.
        if head.type is 'indentStart'
          # First, we must check to make sure that the indent is actually empty.
          nextVisibleElement = head.next
          while nextVisibleElement.type in ['newline', 'cursor', 'segmentStart', 'segmentEnd']
            nextVisibleElement = nextVisibleElement.next

          # If the indent is indeed empty, delete it.
          # Remember, though, that the cursor is currently inside this indent, so we need to move it out first.
          if nextVisibleElement is head.indent.end
            moveCursorDown()
            @captureUndoEvent()

            @addMicroUndoOperation
              type: 'destroyIndent'
              location: head.getSerializedLocation()

            head.prev.append head.indent.end.next
            @redraw()

        scrollCursorIntoView()
      
      moveCursorUp = =>
        # Seek newline
        head = @cursor.prev.prev
        while head isnt null and not (head.type in ['newline', 'indentEnd'] or head is @tree.start)
          head = head.prev
        
        # If head is null, we are at the beginning of the file.
        # So, give up.
        if head is null then return

        if head.type is 'indentEnd'
          moveCursorBefore head
        else
          moveCursorTo head

        # Make sure that we're not inside a block only.
        # This requires finding the immediate parent of the cursor
        head = @cursor; depth = 0
        until (head.type in ['blockEnd', 'indentEnd'] or head is @tree.end) and depth is 0
          switch head.type
            when 'blockStart', 'indentStart', 'socketStart' then depth += 1
            when 'blockEnd', 'indentEnd', 'socketEnd' then depth -= 1
          head = head.next
        
        # If we're in a bad place, then move us further.
        if head.type is 'blockEnd' then moveCursorUp()

      moveCursorDown = =>
        # Seek newline or newline-like character.
        head = @cursor.next.next
        while head isnt null and not (head.type in ['newline', 'indentEnd'] or head is @tree.end)
          head = head.next

        # If head is null, we are at the end of the file.
        # So, give up.
        if head is null then return

        if head.type is 'indentEnd' or head.type is 'segmentEnd'
          moveCursorBefore head
        else
          moveCursorTo head

        # Make sure that we're not inside a block only.
        # This requires finding the immediate parent of the cursor
        head = @cursor; depth = 0
        until (head.type in ['blockEnd', 'indentEnd'] or head is @tree.end) and depth is 0
          switch head.type
            when 'blockStart', 'indentStart', 'socketStart' then depth += 1
            when 'blockEnd', 'indentEnd', 'socketEnd' then depth -= 1
          head = head.next
        
        # If we're in a bad place, then move us further.
        if head.type is 'blockEnd' then moveCursorDown()
      
      # ## Hidden Input events ##

      # For normal text input, we use the "input", "keydownhtml event
      for eventName in ['input', 'keydown', 'keyup', 'keypress']
        @hiddenInput.addEventListener eventName, (event) =>
          # If we haven't focused anything, this input does nothing.
          unless @isEditingText() then return true

          redrawTextInput()

      # For keyboard shortcuts, we use the "keydown" html event
      @hiddenInput.addEventListener 'keydown', (event) =>
        # If we're not actually editing an input, this isn't our responsibility,
        # so return immediately.
        unless @isEditingText() then return true

        # Otherwise, see if we want to make a keyboard shortcut.
        switch event.keyCode
          when 13
            if @handwritten then insertHandwrittenBlock()
            else setTextInputFocus null; @hiddenInput.blur(); @redraw()
          when 8 then if @handwritten and @hiddenInput.value.length is 0
            deleteFromCursor(); setTextInputFocus null; @el.focus(); @hiddenInput.blur()
          when 9 then if @handwritten
            # Seek the block right before this handwritten block
            head = @focus.start.prev.prev
            head = head.prev while head isnt null and head.type isnt 'blockEnd' and head.type isnt 'blockStart'
            
            # If we have found a wrapping (parent) block, then we can't do an indent, so give up.
            if head.type is 'blockStart' then return

            # Otherwise, see if the last child of this block is an indent
            else if head.prev.type is 'indentEnd'
              # Note that it is guaranteed that a handwritten block satisfies @focus.start.prev.block is (the wrapping block)
              moveBlockTo @focus.start.prev.block, head.prev.prev

              # Move the cursor into its proper position (after this block)
              moveCursorTo @focus.start.prev.block.end

              @redraw()
              event.preventDefault(); return false
            
            # We have found a block we want to move into, but there's no indent here, so create one.
            else
              @addMicroUndoOperation
                type: 'createIndent'
                location: head.getSerializedLocation()

              # Create and insert a new indent (default 2 spaces)
              newIndent = new model.Indent INDENT_SPACES
              head.prev.insert newIndent.start; head.prev.insert newIndent.end
            
              # Fill the indent with two newlines (as any empty indent must be)
              # This is done mainly to satisfy the undo stack's need to know exactly
              # what an indent looked like before a block move operation happened.
              newIndent.start.insert new model.NewlineToken()

              # Move the block we're editing into this new indent
              moveBlockTo @focus.start.prev.block, newIndent.start

              # Move the cursor into its proper position (after this block)
              moveCursorTo @focus.start.prev.block.end

              @redraw()
              event.preventDefault(); return false
          when 38 then setTextInputFocus null; @hiddenInput.blur(); moveCursorUp(); @el.focus(); @redraw()
          when 40 then setTextInputFocus null; @hiddenInput.blur(); moveCursorDown(); @el.focus(); @redraw()
          when 37 then if @hiddenInput.selectionStart is @hiddenInput.selectionEnd and @hiddenInput.selectionStart is 0
            # Pressing the left-arrow at the leftmost end of a socket brings us to the previous socket
            head = @focus.start
            until not head? or head.type is 'socketEnd' and not (head.socket.content()?.type in ['block', 'socket'])
              head = head.prev
              
            # If we have reached the beginning of the file, give up.
            unless head? then return

            setTextInputFocus head.socket
            setTimeout (=>
              setRawTextInputCursor head.socket.stringify().length
              redrawTextInput()), 0

          when 39 then if @hiddenInput.selectionStart is @hiddenInput.selectionEnd and @hiddenInput.selectionStart is @hiddenInput.value.length
            # Pressing right left-arrow at the rightmost end of a socket brings us to the next socket
            head = @focus.end
            until not head? or head.type is 'socketStart' and not (head.socket.content()?.type in ['block', 'socket'])
              head = head.next
              
            # If we have reached the end of the file, give up.
            unless head? then return

            setTextInputFocus head.socket

            setTimeout (=>
              setRawTextInputCursor 0
              redrawTextInput()), 0

      # When we blur the hidden input, also blur the canvas text focus
      @hiddenInput.addEventListener 'blur', (event) =>
        # If we have actually blurred (as opposed to simply unfocused the browser window)
        if event.target isnt document.activeElement then setTextInputFocus null
        
        # Focus the editor to capture keypresses
        @el.focus()
      
      # Bind keyboard shortcut events to the document
      
      ctrlKeyPressed = false

      @el.addEventListener 'keydown', (event) =>
        # Keyboard shortcuts don't apply if they were executed in a text input area (except for UNDO)
        if event.target.tagName in ['INPUT', 'TEXTAREA'] and not (event.keyCode in [17, 90]) then return
        
        switch event.keyCode
          when 13 then unless @isEditingText() then insertHandwrittenBlock()
          when 38 then if @cursor? then moveCursorUp()
          when 40 then if @cursor? then moveCursorDown()
          when 8 then if @cursor? then deleteFromCursor()
          when 37 then if @cursor?
            head = @cursor
            
            until not head? or head.type is 'socketEnd' and not (head.socket.content()?.type in ['block', 'socket'])
              head = head.prev
            
            unless head? then return

            setTextInputFocus head.socket
            setTimeout (=>
              setRawTextInputCursor head.socket.stringify().length
              redrawTextInput()), 0

          when 39 then if @cursor?
            # Pressing the left-arrow at the rightmost end of a socket brings us to the next socket
            head = @cursor
            until not head? or head.type is 'socketStart' and not (head.socket.content()?.type in ['block', 'socket'])
              head = head.next
              
            # If we have reached the beginning of the file, give up.
            unless head? then return

            setTextInputFocus head.socket
            setTimeout (=>
              setRawTextInputCursor 0
              redrawTextInput()), 0

          when 17 then ctrlKeyPressed = true

          when 90 then if ctrlKeyPressed
            @undo()
            event.preventDefault()
        
        # If we manipulated the root tree, redraw.
        if event.keyCode in [13, 38, 40, 8] then @redraw()
        
        # If we caught the keypress, prevent default.
        if event.keyCode in [13, 38, 40, 8, 37] then event.preventDefault()

      @el.addEventListener 'keyup', (event) =>
        switch event.keyCode
          when 17 then ctrlKeyPressed = false

      # Hit-testing functions

      hitTest = (point, root) =>
        head = root; seek = null
        while head isnt seek
          if head.type is 'blockStart' and head.block.view.path.contains point
            seek = head.block.end
          head = head.next
        
        if seek? then seek.block else null

      hitTestRoot = (point) => hitTest point, @tree.start
      
      hitTestFloating = (point) =>
        for float in @floatingBlocks by -1
          if hitTest(point, float.block.start) isnt null then return float.block
        return null
      
      hitTestFocus = (point) =>
        head = @tree.start
        while head isnt null
          if head.type is 'socketStart' and
              (head.next.type is 'text' or head.next.type is 'socketEnd') and
              head.socket.view.bounds[head.socket.view.lineStart].contains point
            return head.socket
          head = head.next

        return null
      
      hitTestLasso = (point) => if @lassoSegment? and @_lassoBounds.contains point then @lassoSegment else null

      hitTestPalette = (point) =>
        # The point was given in relation to the main canvas,
        # but we want it in relation to the palette canvas;
        # translate it.
        point = new draw.Point point.x + PALETTE_WIDTH, point.y - @scrollOffset.y + @paletteScrollOffset.y

        # Hit test as per normal.
        for block in @paletteBlocks
          if hitTest(point, block.start)? then return block
        return null

      # ## The mousedown event ##
      
      # ### getPointFromEvent ###
      # This is a conveneince function, which will contain compatability layers for getting
      # the offset coordinates of a mouse click point. This is returned in relation to the origin
      # of the main canvas; things in relation to other canvases must translate from here.

      getPointFromEvent = (event) =>
        switch
          when event.offsetX?
            return new draw.Point(
              event.pageX - findPosLeft(track) - PALETTE_WIDTH,
              event.pageY - findPosTop(track) + @scrollOffset.y
            )
          when event.layerX?
            return new draw.Point(
              event.pageX - findPosLeft(track) - PALETTE_WIDTH,
              event.pageY - findPosTop(track) + @scrollOffset.y
            )
      
      performNormalMouseDown = (point) =>

        # See what we picked up
        @ephemeralSelection = hitTestFloating(point) ?
          hitTestLasso(point) ?
          hitTestFocus(point) ?
          hitTestRoot(point) ?
          hitTestPalette(point)
        
        if not @ephemeralSelection?
          # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
          
          # If there is already a selection, remove it.
          if @lassoSegment?

            # First, check to see if the block is floating
            flag = false
            for float in @floatingBlocks
              if float.block is @lassoSegment
                flag = true
                break

            # Don't remove the segment if it's floating, because it still needs to hold those blocks together
            unless flag
              @addMicroUndoOperation
                type: 'destroySegment'
                start: @lassoSegment.start.getSerializedLocation()
                end: @lassoSegment.end.getSerializedLocation()

              @lassoSegment.remove()

            @lassoSegment = null
            @redraw()

          # Set the lasso anchor
          @lassoAnchor = point

        else if @ephemeralSelection.type is 'socket'
          # If we have clicked on a socket, then TEXT INPUT, indicated by (@isEditingText())
          
          # Set the text input up for editing
          setTextInputFocus @ephemeralSelection
          
          # Don't actually drag anything
          @ephemeralSelection = null

          # We must set a timeout for the following, because until
          # A render has passed, the hidden input is not actually focused.
          setTimeout (=>
            setTextInputAnchor point
            redrawTextInput()
            
            # While the mouse is down, we are trying to select text in the input
            textInputSelecting = true), 0

        else
          # If we have clicked on a block or segment, then NORMAL DRAG, indicated by (@ephemeralSelection?)
          
          if @ephemeralSelection in @paletteBlocks

            # It's in the palette, so we need to translate it.
            @ephemeralPoint = new draw.Point point.x - @scrollOffset.x + @paletteScrollOffset.x, point.y - @scrollOffset.y + @paletteScrollOffset.y
          else
            @ephemeralPoint = new draw.Point point.x, point.y
          
          # Move the cursor to the place we just clicked
          moveCursorTo @ephemeralSelection.end
    
      track.addEventListener 'mousedown', (event) =>
        # Only capture left-click
        unless event.button is 0 then return
        
        # Forcefully blur the hidden input if it is focused, removing
        # the focus from any sockets
        @hiddenInput.blur()

        performNormalMouseDown getPointFromEvent(event), false
      
      track.addEventListener 'touchstart', (event) =>
        @hiddenInput.blur()
        
        # Track events do not contain offsetX/layerX properties,
        # so we must set them manually.

        event.changedTouches[0].offsetX = event.changedTouches[0].pageX - findPosLeft(track)
        event.changedTouches[0].offsetY = event.changedTouches[0].pageY - findPosTop(track)

        performNormalMouseDown getPointFromEvent(event.changedTouches[0]), true

      # ## Mouse events for NORMAL DRAG ##
      
      performNormalMouseMove = (event) =>
        if @ephemeralSelection?
          point = getPointFromEvent event
          
          if point.from(@ephemeralPoint).magnitude() > MIN_DRAG_DISTANCE

            # Move the ephemeral selection into the selection position
            @selection = @ephemeralSelection
            @ephemeralSelection = null

            # Check to make sure that the selection doesn't contain a cursor
            head = @selection.start
            while head isnt @selection.end
              next_head = head.next
              if head.type is 'cursor' then head.remove() # If there is, remove it
              head = next_head
            
            # If we clicked something in the palette, we need to compute offset etc. with a point that has been computed
            # with offset to the palette.
            if @selection in @paletteBlocks then @ephemeralPoint.add PALETTE_WIDTH, 0; selectionInPalette = true

            # Compute the offset of the selection position from the mouse
            rect = @selection.view.bounds[@selection.view.lineStart]
            offset = @ephemeralPoint.from new draw.Point rect.x, rect.y

            # If we have clicked something in the palette, the clone first.
            if selectionInPalette then @selection = @selection.clone()

            # Move it to nowhere
            moveBlockTo @selection, null

            # If we have clicked something floating, then delete it from the list of floating blocks
            for float, i in @floatingBlocks
              if float.block is @selection then @floatingBlocks.splice i, 1; break

            # Unhighlight all the blocks in @selection
            head = @selection.start
            until head is @selection.end
              if head.type is 'blockStart' then head.block.lineMarked.length = 0
              head = head.next

            # Draw it in the drag canvas
            @selection.view.compute()
            @selection.view.draw @dragCtx

            # CSS-transform the drag canvas to where it ought to be
            if selectionInPalette
              # If we picked up from the palette, then rect.x is actually relative to the palette
              fixedDest = new draw.Point rect.x - PALETTE_WIDTH, rect.y
            else
              # Otherwise, do as we would with mousemove
              fixedDest = new draw.Point rect.x - @scrollOffset.x, rect.y - @scrollOffset.y

            drag.style.webkitTransform =
              drag.style.mozTransform =
              drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
            
            # Redraw the main canvas
            @redraw()

        if @selection?
          # Determine the position of the mouse
          point = getPointFromEvent event

          point.add -@scrollOffset.x, -@scrollOffset.y

          # First we find the highlighted area
          fixedDest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things exactly in relation to the canvas?

          point.translate @scrollOffset
          dest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things as related to the way we draw the root tree?

          old_highlight = highlight
          
          if @selection.type is 'block'
            highlight = @tree.find (block) ->
              (not (block.inSocket?() ? false)) and block.view.dropArea? and block.view.dropArea.contains dest
          else if @selection.type is 'segment'
            highlight = @tree.find (block) ->
              (block.type isnt 'socket') and (not (block.inSocket?() ? false)) and block.view.dropArea? and block.view.dropArea.contains dest

          # If highlight changed, redraw
          if old_highlight isnt highlight then @redraw()

          # Highlight the highlight
          if highlight? then highlight.view.dropHighlightReigon.fill @mainCtx, '#fff'

          # CSS-transform the drag canvas to where it ought to be
          drag.style.webkitTransform =
            drag.style.mozTransform =
            drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
      
      # Bind this mousemove function to mousemove. We need to add some
      # wrapper functions for touchmove, since multitouch works slightly differently
      # from mouse.
      track.addEventListener 'mousemove', (event) ->
        performNormalMouseMove event

      track.addEventListener 'touchmove', (event) ->
        unless event.changedTouches.length > 0 then return

        event.changedTouches[0].offsetX = event.changedTouches[0].pageX - findPosLeft(track)
        event.changedTouches[0].offsetY = event.changedTouches[0].pageY - findPosTop(track)

        performNormalMouseMove event.changedTouches[0]

      
      performNormalMouseUp = (event) =>
        if @ephemeralSelection?
          @ephemeralSelection = null
          @ephemeralPoint = null

        if @selection?
          # Determine the position of the mouse and the place we want to render the block
          point = getPointFromEvent event
          dest = new draw.Point -offset.x + point.x, -offset.y + point.y

          if highlight?
            # Drop areas signify different things depending on the block that they belong to
            switch highlight.type
              when 'indent'
                moveBlockTo @selection, highlight.start

              when 'block'
                # A block drop signifies that we want to drop the block after (the end of) the block.
                moveBlockTo @selection, highlight.end

              when 'socket'
                # Insert
                moveBlockTo @selection, highlight.start
              
              else
                if highlight is @tree
                  # We can also drop on the root tree (insert at the start of the program)
                  moveBlockTo @selection, @tree.start
            
            # In the special case that we have selected a single block
            # and dropped it into a socket, we need to check for parenthesis
            # wrapping.
            if @selection is @lassoSegment and @lassoSegment.start.next.type is 'blockStart'
              @lassoSegment.start.next.block.checkParenWrap()

          else
            # If we have dropped the block in nowhere, append it (and it's floating position) to @floatingBlocks.
            if dest.x > 0
              descriptor = new FloatingBlockDescriptor
                position: dest
                block: @selection

              @addMicroUndoOperation
                type: 'blockMoveToFloat'
                before: null
                after: descriptor.clone()
                floatingBlockIndex: @floatingBlocks.length
                block: @selection.clone()

              @floatingBlocks.push descriptor
            
            # If we have dropped the block on the palette, then delete it.
            # This normally requires no operations, but if we have selected it as the lassoSegment,
            # we want to stop drawing its bounding box.
            else if @selection is @lassoSegment
              @lassoSegment = null

          
          # CSS-transform the drag canvas back to the origin
          drag.style.webkitTransform =
            drag.style.mozTransform =
            drag.style.transform = "translate(0px, 0px)"
          
          # Clear the drag canvas
          # Note that we clear from -1, -1 because of our pixel-shift hack
          # to allow the border in.
          @dragCtx.clearRect -1, -1, drag.width, drag.height

          # If we inserted into root, move the cursor to the end of the selection.
          if highlight?
            # Seek the next newline after the end of this block,
            # which is where we'll want to move the cursor
            # (so that it looks like we put it directly after the block).
            moveCursorTo @selection.end

          # Signify that we are no longer in a NORMAL DRAG
          @selection = null
          
          # Redraw after the selection has been set to null, since @redraw is sensitive to what things are being dragged.
          @redraw()

      track.addEventListener 'mouseup', (event) =>
        performNormalMouseUp event

        @captureUndoEvent()

      track.addEventListener 'touchend', (event) =>
        event.changedTouches[0].offsetX = event.changedTouches[0].pageX - findPosLeft(track)
        event.changedTouches[0].offsetY = event.changedTouches[0].pageY - findPosTop(track)

        performNormalMouseUp event.changedTouches[0]

      # ## Mouse events for LASSO SELECT ##

      getRectFromPoints = (a, b) ->
        return new draw.Rectangle(
          # Take the minimum coordinates for the top-left corner
          Math.min(a.x, b.x), #x
          Math.min(a.y, b.y), #y
          
          # Distances are always positive
          Math.abs(a.x - b.x), #width
          Math.abs(a.y - b.y)) #height

      track.addEventListener 'mousemove', (event) =>
        if @lassoAnchor?
          # Determine the position of the mouse
          point = getPointFromEvent event
          point.add -@scrollOffset.x, -@scrollOffset.y # (position fixed, as in relation to the drag canvas, on which we will draw it)

          # Get the rectangle we want to draw
          rect = getRectFromPoints (new draw.Point @lassoAnchor.x - @scrollOffset.x, @lassoAnchor.y - @scrollOffset.y), point

          # Clear and redraw the lasso on the drag canvas
          @dragCtx.clearRect 0, 0, drag.width, drag.height
          @dragCtx.strokeStyle = '#00f'
          @dragCtx.strokeRect rect.x, rect.y, rect.width, rect.height

      track.addEventListener 'mouseup', (event) =>
        if @lassoAnchor?
          # Determine the position of the mouse
          point = getPointFromEvent event

          # Get the rectangle we want to test
          rect = getRectFromPoints @lassoAnchor, point

          # First pass for lasso segment detection: get intersecting blocks.
          
          # Find the first matching block
          head = @tree.start
          firstLassoed = null
          while head isnt @tree.end
            # A block matches if it intersects the lasso rectangle
            if head.type is 'blockStart' and head.block.view.path.intersects rect
              firstLassoed = head
              break
            head = head.next
          
          # Find the last matching block analagously
          head = @tree.end
          lastLassoed = null
          while head isnt @tree.start
            if head.type is 'blockEnd' and head.block.view.path.intersects rect
              lastLassoed = head
              break
            head = head.prev

          # Unless we have selected anything, give up.
          if firstLassoed? and lastLassoed?
            # Second pass for lasso segment detection: validate the selection and record wrapping blocks as necessary.
            
            tokensToInclude = []

            head = firstLassoed
            while head isnt lastLassoed
              # For each bit of markup, make sure to include both its start token and end token
              switch head.type
                when 'blockStart', 'blockEnd'
                  tokensToInclude.push head.block.start
                  tokensToInclude.push head.block.end
                when 'indentStart', 'indentEnd'
                  tokensToInclude.push head.indent.start
                  tokensToInclude.push head.indent.end
                when 'segmentStart', 'segmentEnd'
                  tokensToInclude.push head.segment.start
                  tokensToInclude.push head.segment.end
              head = head.next

            # Third pass for lasso segment detection: include all necessary tokens demanded by validation

            # Find the first block in tokensToInclude
            head = @tree.start
            while head isnt @tree.end
              if head in tokensToInclude
                firstLassoed = head; break
              head = head.next
            
            # Find the last matching block analagously
            head = @tree.end
            lastLassoed = null
            while head isnt @tree.start
              if head in tokensToInclude
                lastLassoed = head; break
              head = head.prev

            # Fourth pass for lasso segment detection: make sure that we have selected the wrapping block for any indents
            #
            # Note that this will only occur when we have inserted the indentStart at the beginning or indentEnd at the end
            # in the second and third pass. This in turn will occur ONLY when the user has selected multiple blocks belonging to the
            # same wrapping block, and nothing outside it (i.e. the wrapping block of the indent wraps the entire selection).
            #
            # So it suffices to select that entire wrapping block.

            if firstLassoed.type is 'indentStart'
              # Seek the wrapping block for this indent
              depth = 0
              while depth > 0 or head.type isnt 'blockStart' # We need to find the wrapping block, so we keep track of block depth
                # Increment block depth
                if firstLassoed.type is 'blockStart' then depth -= 1
                else if firstLassoed.type is 'blockEnd' then depth += 1

                firstLassoed = firstLassoed.prev
              
              # Set lastLassoed in accordance.
              lastLassoed = firstLassoed.block.end

            if firstLassoed.type is 'indentStart'
              # Seek the wrapping block for this indent
              depth = 0
              while depth > 0 or head.type isnt 'blockEnd' # We need to find the wrapping block, so we keep track of block depth
                # Increment block depth
                if lastLassoed.type is 'blockEnd' then depth -= 1
                else if lastLassoed.type is 'blockStart' then depth += 1
              
              # Set firstLassoed in accordance
              firstLassoed = lastLassoed.block.start

            # Now, insert the actual lasso segment.
            @lassoSegment = new model.Segment()

            firstLassoed.insertBefore @lassoSegment.start
            lastLassoed.insert @lassoSegment.end

            @addMicroUndoOperation
              type: 'createSegment'
              start: @lassoSegment.start.getSerializedLocation()
              end: @lassoSegment.end.getSerializedLocation()

            @redraw()
          
          # Clear the drag canvas
          @dragCtx.clearRect 0, 0, drag.width, drag.height

          # If we inserted a lasso segment, move the cursor appropriately
          if @lassoSegment? then moveCursorTo @lassoSegment.end
          
          # Flag that we are no longer in a LASSO SELECT.
          @lassoAnchor = null

          @redraw()


      # ## Utility functions for TEXT INPUT ##

      redrawTextInput = =>
        # Change the edited text
        @editedText.value = @hiddenInput.value

        # Redraw the background (main canvas)
        @redraw()
        
        # Determine the position (coordinate-wise) of the typing cursor
        start = @editedText.view.bounds[_editedInputLine].x +
          @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionStart]).width

        end = @editedText.view.bounds[_editedInputLine].x +
          @mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionEnd]).width
        
        # Draw the typing cursor itself
        if start is end
          # This is just a line
          @mainCtx.strokeRect start, @editedText.view.bounds[_editedInputLine].y, 0, @fontSize
        else
          # This is the translucent rectangle
          @mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3'
          @mainCtx.fillRect start, @editedText.view.bounds[_editedInputLine].y, end - start, @fontSize

      setTextInputFocus = (focus) =>
        # Deal with the previous focus
        if @focus?
          # Log in the undo stack that the text input value changed
          if @ephemeralOldFocusValue isnt @focus.stringify()
            unless @focus.handwritten then @captureUndoEvent()

            @addMicroUndoOperation
              type: 'socketTextChange'
              location: @focus.start.getSerializedLocation()
              before: @ephemeralOldFocusValue
              after: @focus.stringify()
          
          try
            if @focus.handwritten
              # If we are in a handwritten block, we actually want to reparse
              # the entire block we're in
              newParse = coffee.parse(@focus.start.prev.block.stringify()).start.next

              # If what has been parsed ends up creating a new block,
              # subsitute this new block for the old (unstable) text
              if newParse.type is 'blockStart'
                # Log in the undo stack the operation
                # we're about to do
                @addMicroUndoOperation
                  type: 'handwrittenReparse'
                  location: @focus.start.prev.getSerializedLocation()
                  before: @focus.start.prev.block.clone()
                  after: newParse.block.clone()
                
                newParse.block.moveTo @focus.start.prev.prev
                @focus.start.prev.block.moveTo null
              
            else
              # If we are not a handwritten block, attempt to reparse
              # just what's in the socket
              newParse = coffee.parse(@focus.stringify()).start.next
              
              # If what has been parsed ends up creating a new block,
              # subsitute this new block for the old (unstable) text
              if newParse.type is 'blockStart'
                # Log in the undo stack the operation
                # we're about to do
                @addMicroUndoOperation
                  type: 'socketReparse'
                  location: @focus.start.getSerializedLocation()
                  before: @focus.content().clone()
                  after: newParse.block.clone()
                
                if @focus.content()?.type is 'text' then @focus.content().remove()
                else if @focus.content()?.type is 'block' then @focus.content().moveTo null
                
                newParse.block.moveTo @focus.start

          # Fire the onchange handler
          @triggerOnChangeEvent new IceEditorChangeEvent @focus, focus
        
        # Literally set the focus
        @focus = focus
        
        if @focus? then @ephemeralOldFocusValue = @focus.stringify()
        else @ephemeralOldFocusValue = null
        
        # If we just removed the focus, then we are done.
        if @focus is null then return
        
        # Record the line that the focus is on
        _editedInputLine = @focus.view.lineStart

        # Flag whether we are editing handwritten
        @handwritten = @focus.handwritten
        
        if not @focus.content()
          # If the socket is empty, put a text thing in, setting that to the edited text
          @editedText = new model.TextToken ''
          @focus.start.insert @editedText
        
        else if @focus.content().type is 'text'
          # If the socket is not empty but contains only text, edit that text
          @editedText = @focus.content()

        else
          # Otherwise, we have an error condition.
          throw new Error 'Cannot edit occupied socket.'

        # Find the wrapping block and move the cursor to
        head = @focus.end; depth = 0
        while head.type isnt 'newline' and head.type isnt 'indentEnd' and head.type isnt 'segmentEnd' then head = head.next
        
        if head.type is 'newline' then moveCursorTo head
        else moveCursorBefore head
        
        # Set the contents of the hidden input
        @hiddenInput.value = @editedText.value

        # Focus the hidden input
        setTimeout (=> @hiddenInput.focus()), 0

      setTextInputFocusRaw = (focus) =>
        # Literally set the focus
        @focus = focus
        
        if @focus? then @ephemeralOldFocusValue = @focus.stringify()
        else @ephemeralOldFocusValue = null
        
        # If we just removed the focus, then we are done.
        if @focus is null then return
        
        # Record the line that the focus is on
        _editedInputLine = @focus.view.lineStart

        # Flag whether we are editing handwritten
        @handwritten = @focus.handwritten
        
        if not @focus.content()
          # If the socket is empty, put a text thing in, setting that to the edited text
          @editedText = new model.TextToken ''
          @focus.start.insert @editedText
        
        else if @focus.content().type is 'text'
          # If the socket is not empty but contains only text, edit that text
          @editedText = @focus.content()

        else
          # Otherwise, we have an error condition.
          throw new Error 'Cannot edit occupied socket.'

        # Find the wrapping block and move the cursor to
        head = @focus.end; depth = 0
        while head.type isnt 'newline' and head.type isnt 'indentEnd' and head.type isnt 'segmentEnd' then head = head.next
        
        if head.type is 'newline' then moveCursorToRaw head
        else moveCursorBeforeRaw head
        
        # Set the contents of the hidden input
        @hiddenInput.value = @editedText.value

        # Focus the hidden input
        setTimeout (=> @hiddenInput.focus()), 0

      textInputSelectAll = =>
        textInputAnchor = 0; textInputHead = @focus.stringify().length
        @hiddenInput.setSelectionRange textInputAnchor, textInputHead

      setTextInputHead = (point) =>
        textInputHead = Math.round (point.x - @focus.view.bounds[_editedInputLine].x) / @mainCtx.measureText(' ').width

        @hiddenInput.setSelectionRange Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead)

      setTextInputAnchor = (point) =>
        textInputAnchor = textInputHead = Math.round (point.x - @focus.view.bounds[_editedInputLine].x - PADDING) / @mainCtx.measureText(' ').width
        @hiddenInput.setSelectionRange textInputAnchor, textInputHead

      setRawTextInputCursor = (offset) =>
        textInputAnchor = textInputHead = offset
        @hiddenInput.setSelectionRange textInputAnchor, textInputHead

      # ## Mouse events for TEXT INPUT ##

      track.addEventListener 'mousemove', (event) =>
        if @isEditingText() and textInputSelecting
          # See where the mouse is
          point = getPointFromEvent event
          
          # Set the input head
          setTextInputHead point

          # Redraw
          redrawTextInput()

      track.addEventListener 'mouseup', (event) =>
        if @isEditingText()
          textInputSelecting = false
      
      # ## Scrolling ##
      # We handle scrolling through some invisible scroller elements in the track div.
      # We bind to their scroll events and translate the canvases based on their
      # scroll positions.

      paletteScroller.addEventListener 'scroll', =>
        @paletteScrollOffset.x = paletteScroller.scrollLeft
        @paletteScrollOffset.y = paletteScroller.scrollTop
        @paletteCtx.setTransform 1, 0, 0, 1, -@paletteScrollOffset.x, -@paletteScrollOffset.y
        @redrawPalette()

      mainScroller.addEventListener 'scroll', =>
        @scrollOffset.x = mainScroller.scrollLeft
        @scrollOffset.y = mainScroller.scrollTop
        @mainCtx.setTransform 1, 0, 0, 1, -@scrollOffset.x, -@scrollOffset.y
        @redraw()
      
      # ## lineHover ##
      # We allow binding to hovering
      # over blocks on lines, pasing the line
      # hovered as an event.
      #
      # For performance reasons, if there is no binding,
      # we do not keep track of what line the mouse is over.
      # 
      # The event only fires when the hovered line changes,
      # and fires on line: null when the mouse goes out of the document.
      lastHoveredLine = null
      track.addEventListener 'mousemove', (event) =>
        if @onLineHover?
          line = @getHoveredLine getPointFromEvent event
          if line isnt lastHoveredLine
            lastHoveredLine = line
            @onLineHover {
              line: line
            }
  
    # ## clearUndoStack ##
    # Clears the undo stack; pretty self-explanatory.
    clearUndoStack: ->
      @undoStack.length = 0
    
    # ## setValue ##
    # Set the value of the editor to some text.
    # Performs a reparse and *adds an undo event*.
    #
    # If the application layer is doing this they may
    # want to clear the undo stack afterwards.
    #
    # If parsing fails, returns the parse error in an object
    # {success: false, error: parseError}.
    #
    # Ideally, this will be the syntax error that trigger the failure to parse.
    setValue: (value) ->
      try
        @ace.setValue value, -1
        
        newTree = coffee.parse value
      
        @addMicroUndoOperation
          type: 'setValue'
          before: @tree.clone()
          after: newTree.clone()
        
        @tree = newTree
        @tree.start.insert @cursor
        @redraw()

      catch e
        return {
          success: false
          error: e
        }
      
      return {
        success: true
      }

    
    # ## getValue ##
    # Get the textual value of the editor (stringified).
    getValue: -> @tree.stringify()
    
    # ## performMeltAnimation ##
    # This will animate all the text elements from their current position to a position
    # that imitates plaintext.
    _performMeltAnimation: ->
      if @currentlyAnimating or not @currentlyUsingBlocks then return

      @redraw()
      
      @currentlyAnimating = true; @currentlyUsingBlocks = false

      # We need to find out some properties of dimensions
      # in the ace editor. So we will need to display the ace editor momentarily off-screen.

      @ace.setValue @getValue(), -1
      @aceEl.style.top = '-9999px'
      @aceEl.style.left = '-9999px'
      @aceEl.style.display = 'block'
      
      # We must wait for the Ace editor to render before we continue.
      # Ace actually takes some time with webworkers to determine some things like line height,
      # which we need, so we will poll ace until it is done.
      acePollingInterval = setInterval (=>
        unless @ace.renderer.layerConfig.lineHeight > 0
          # In this case, the ace editor has not yet rendered, so we continue to poll
          return
        
        # In this case, the ace editor has rendered, so we stop polling and begin the animation.
        clearInterval acePollingInterval

        # First, we will need to get all the text elements which we will be animating.
        # Simultaneously, we can ask text elements to compute their position as if they were plaintext. This will be the
        # animation destination. Along the way we will move the cursor around due to newlines and indents.
        textElements = []
        translationVectors = []
        head = @tree.start
        # Set up the state which we will pass to 
        state =
          x: @ace.container.getBoundingClientRect().left - findPosLeft(@aceEl) + @ace.renderer.$gutterLayer.gutterWidth
          y: @ace.container.getBoundingClientRect().top - findPosTop(@aceEl)
          indent: 0
          lineHeight: @ace.renderer.layerConfig.lineHeight
          leftEdge: @ace.container.getBoundingClientRect().left - findPosLeft(@aceEl) + @ace.renderer.$gutterLayer.gutterWidth

        while head isnt @tree.end
          if head.type is 'text'
            translationVectors.push head.view.computePlaintextTranslationVector state, @mainCtx
            textElements.push head
          else if head.type is 'newline'
            state.y += state.lineHeight
            state.x = state.indent * @mainCtx.measureText(' ').width + state.leftEdge
          else if head.type is 'indentStart'
            state.indent += head.indent.depth
          else if head.type is 'indentEnd'
            state.indent -= head.indent.depth

          head = head.next

        # We have now obtained the destination position for the animation; now we animate.
        count = 0

        animatedColor = new AnimatedColor('#EEEEEE', '#FFFFFF', ANIMATION_FRAME_RATE)
        originalOffset = @scrollOffset.y

        tick = =>
          count += 1
          
          if count < ANIMATION_FRAME_RATE
            setTimeout tick, 1000 / ANIMATION_FRAME_RATE

          @main.style.left = PALETTE_WIDTH * (1 - count / ANIMATION_FRAME_RATE) + 'px'
          @el.style.backgroundColor = @main.style.backgroundColor = animatedColor.advance()
          @palette.style.opacity = Math.max 0, 1 - 2 * (count / ANIMATION_FRAME_RATE)

          @clear()
          
          @mainCtx.globalAlpha = Math.max 0, 1 - 2 * count / ANIMATION_FRAME_RATE
          @mainCtx.translate 0, originalOffset / ANIMATION_FRAME_RATE
          @scrollOffset.y -= originalOffset / ANIMATION_FRAME_RATE

          @tree.view.draw @mainCtx

          @mainCtx.globalAlpha = 1
          
          for element, i in textElements
            element.view.textElement.draw @mainCtx
            element.view.translate new draw.Point translationVectors[i].x / ANIMATION_FRAME_RATE, translationVectors[i].y / ANIMATION_FRAME_RATE

          if count >= ANIMATION_FRAME_RATE
            @el.style.display = 'none'
            
            @aceEl.style.top = 0
            @aceEl.style.left = 0
            @aceEl.style.display = 'block'
            
            # We need to trigger an ace resize event by hand,
            # because ace still thinks that it is hidden (0x0).
            @ace.resize()

            @currentlyAnimating = false
            @scrollOffset.y = 0
            @mainCtx.setTransform 1, 0, 0, 1, 0, 0

        tick()
      ), 1

      return true
    
    _performFreezeAnimation: ->
      if @currentlyAnimating or @currentlyUsingBlocks then return

      @redraw()
      
      # In the case that we do not successfully set our value
      # (i.e. we failed to parse the text), give up immediately.
      parseResult = @setValue @ace.getValue(), -1
      unless parseResult.success
        @currentlyAnimating = false; @currentlyUsingBlocks = false
        return parseResult
      
      @currentlyAnimating = true; @currentlyUsingBlocks = true

      # First, we will need to get all the text elements which we will be animating.
      # Simultaneously, we can ask text elements to compute their position as if they were plaintext. This will be the
      # animation destination. Along the way we will move the cursor around due to newlines and indents.
      textElements = []
      translationVectors = []
      head = @tree.start
      
      # Set up the state which we will pass to 
      state =
        x: @ace.container.getBoundingClientRect().left - findPosLeft(@aceEl) + @ace.renderer.$gutterLayer.gutterWidth
        y: @ace.container.getBoundingClientRect().top - findPosTop(@aceEl)
        indent: 0
        lineHeight: @ace.renderer.layerConfig.lineHeight
        leftEdge: @ace.container.getBoundingClientRect().left - findPosLeft(@aceEl) + @ace.renderer.$gutterLayer.gutterWidth
      while head isnt @tree.end
        if head.type is 'text'
          translationVectors.push head.view.computePlaintextTranslationVector state, @mainCtx
          head.view.translate translationVectors[translationVectors.length - 1]
          textElements.push head
        else if head.type is 'newline'
          state.y += state.lineHeight
          state.x = state.indent * @mainCtx.measureText(' ').width + state.leftEdge
        else if head.type is 'indentStart'
          state.indent += head.indent.depth
        else if head.type is 'indentEnd'
          state.indent -= head.indent.depth

        head = head.next

      @aceEl.style.display = 'none'
      @el.style.display = 'block'

      # We have now obtained the destination position for the animation; now we animate.
      count = 0

      animatedColor = new AnimatedColor '#FFFFFF', '#EEEEEE', ANIMATION_FRAME_RATE

      tick = =>
        count += 1
        
        if count < ANIMATION_FRAME_RATE
          setTimeout tick, 1000 / ANIMATION_FRAME_RATE

        @main.style.left = PALETTE_WIDTH * (count / ANIMATION_FRAME_RATE) + 'px'
        @el.style.backgroundColor = @main.style.backgroundColor = animatedColor.advance()
        @palette.style.opacity = Math.max 0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE)

        @clear()
        
        @mainCtx.globalAlpha = Math.max 0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE)

        @tree.view.draw @mainCtx

        @mainCtx.globalAlpha = 1
        
        for element, i in textElements
          element.view.textElement.draw @mainCtx
          element.view.translate new draw.Point -translationVectors[i].x / ANIMATION_FRAME_RATE, -translationVectors[i].y / ANIMATION_FRAME_RATE

        if count is ANIMATION_FRAME_RATE
          @currentlyAnimating = false
          @redraw()

      tick()
      
      return {
        success: true
      }
    
    # ## toggleBlocks ##
    # If we are using blocks, melt to text.
    # If we are using text, freeze to blocks.
    #
    # This should be the function used by the application layer,
    # *not* _performMeltAnimation() or _performFreezeAnimation().
    toggleBlocks: ->
      if @currentlyUsingBlocks then @_performMeltAnimation()
      else @_performFreezeAnimation()

    # ## setFontSize ##
    # Set the font size of the editor.
    #
    # Note that the font size is bound to the ACE editor font size.
    # Changing the ICE editor font size will probably be inconsequential
    # unless you simultaneously change the ACE editor font size.
    #
    # This is mainly here as a utility function for ICE editor to use
    # internally.
    setFontSize: (size) ->
      unless @fontSize is size
        @fontSize = size

        @redraw()
        @redrawPalette()
    
    # ## markLine ##
    # Add a style to a line. Currently,
    # styles take the form {tag:string, color:string},
    # and outlines the block in that color.
    #
    # Tags are for later removal.
    markLine: (line, style) ->
      # Note: we fail silently when the line given
      # is not in the document
      @tree.getBlockOnLine(line)?.lineMarked.push style
      
      @redraw()
    
    # ## unmarkLine ##
    # Remove all styles with the given tag
    # from a line.
    unmarkLine: (line, tag) ->
      unless (blockOnLine = @tree.getBlockOnLine(line))? then return

      for style, i in blockOnLine.lineMarked
        if style.tag is tag
          blockOnLine.lineMarked.splice i, 1
          break
      
      @redraw()
    
    # ## clearLineMarks ##
    # Remove all styles with the given tag from
    # a document.
    clearLineMarks: (tag) ->
      head = @tree.start
      until head is @tree.end
        if head.type is 'blockStart'
          unless tag?
            head.block.lineMarked.length = 0
          else
            for style, i in head.block.lineMarked
              if style.tag is tag
                head.block.lineMarked.splice i, 1
                break
        head = head.next
      
      @redraw()
    
    # ## getHoveredLine ##
    # A utility function for internal use;
    # get the line in which the given point resides
    # in the document.
    getHoveredLine: (point) ->
      # For performance reasons, and also for
      # clarity, we treat each line as its bounding rectangle,
      # rather than the block on that line.
      #
      # This way we can hover to the left of the block on a line
      # and still get the event.
      for line in [@tree.view.lineStart..@tree.view.lineEnd]
        if @tree.view.bounds[line].contains point
          return line

      return null
    
  return exports
