INDENT_SPACES = 2
INPUT_LINE_HEIGHT = 15
PALETTE_MARGIN = 10

exports.Editor = class Editor
  constructor: (el, @paletteBlocks) ->

    ###
    # Field declaration
    # (useful to have all in one place)
    ###
    
    # If we did not recieve palette blocks in the constructor, we have no palette.
    @paletteBlocks ?= []
    
    # We discard the blocks we are fed, preferring to clone them
    # To be as unintrusive as possible (also to get blocks unattached to any
    # token stream
    @paletteBlocks = (paletteBlock.clone() for paletteBlock in @paletteBlocks)

    ###
    # MODEL instances (program state)
    ###
    @tree = null # The root tree
    @floatingBlocks = [] # The other root blocks that are not attached to the root tree
    
    ###
    # TEXT INPUT interactive fields
    ###
    @focus = null # The focused empty socket, if such thing exists.
    @editedText = null # The focused textToken, if such thing exists (associated with @focus).
    @handwritten = false # Are we editing a handwritten line?
    @hiddenInput = null

    @isEditingText = => @hiddenInput is document.activeElement

    textInputAnchor = textInputHead = null # The selection anchor and head in the input

    textInputSelecting = false

    _editedInputLine = -1

    ###
    # NORMAL DRAG interactive fields
    ###
    @selection = null # The currently-dragged set of blocks

    ###
    # LASSO SELECT interactive fields
    ###
    @lassoSegment = null
    @_lassoBounds = null

    ###
    # CURSOR interactive fields
    ###
    @cursor = new CursorToken()

    # Scroll offset
    @scrollOffset = new draw.Point 0, 0

    offset = null
    highlight = null
    
    ###
    # DOM SETUP
    ###

    # The main canvas
    main = document.createElement 'canvas'; main.className = 'canvas'
    main.height = el.offsetHeight
    main.width = el.offsetWidth - PALETTE_WIDTH

    # The palette canvas
    palette = document.createElement 'canvas'; palette.className = 'palette'
    palette.height = el.offsetHeight
    palette.width = PALETTE_WIDTH

    # The drag canvas
    drag = document.createElement 'canvas'; drag.className = 'drag'
    drag.height = el.offsetHeight
    drag.width = el.offsetWidth - PALETTE_WIDTH

    # The hidden input
    @hiddenInput = document.createElement 'input'; @hiddenInput.className = 'hidden_input'

    # The mouse tracking div
    track = document.createElement 'div'; track.className = 'trackArea'

    # Append the children
    for child in [main, palette, drag, track, @hiddenInput]
      el.appendChild child

    # Get the contexts from each canvas
    mainCtx = main.getContext '2d'
    dragCtx = drag.getContext '2d'
    paletteCtx = palette.getContext '2d'

    # The main context will be used for draw.js's text measurements (this is a bit of a hack)
    draw._setCTX mainCtx

    ###
    # General-purpose methods that call the view.
    ###
    
    @clear = =>
      mainCtx.clearRect @scrollOffset.x, @scrollOffset.y, main.width, main.height

    @redraw = =>
      # Clear the main canvas
      @clear()

      # Compute the root tree
      @tree.paper.compute line: 0

      # Draw it on the main context
      @tree.paper.finish()
      @tree.paper.draw mainCtx
      
      # Alert the lasso segment, if it exists, to recompute its bounds
      if @lassoSegment?
        # Ask the lasso segment to recompute its bounds
        @lassoSegment.paper.prepBounds()
        
        # Unless we're already drawing it on the drag canvas, draw the lasso segment borders on the main canvas
        unless @lassoSegment is @selection
          (@_lassoBounds = @lassoSegment.paper.getBounds()).stroke mainCtx, '#000'
          @_lassoBounds.fill mainCtx, 'rgba(0, 0, 256, 0.3)'

      for float in @floatingBlocks
        paper = float.block.paper
        
        # Recompute this floating block's coordinates
        paper.compute line: 0
        paper.translate float.position

        # Draw it on the main context
        paper.finish()
        paper.draw mainCtx

    @attemptReparse = =>
      try
        @tree = (coffee.parse @getValue()).segment
        @redraw()
    
    ###
    # The redrawPalette function ought to be called only once in the current code structure.
    # If we want to scroll the palette later on, then this will be called to do so.
    ###
    @redrawPalette = =>
      # We need to keep track of the bottom edge of the last element,
      # so we know where to put the top of the next one (there will be a margin of PALETTE_MARGIN between them)
      lastBottomEdge = 0

      for paletteBlock in @paletteBlocks
        # Compute the coordinates
        paletteBlock.paper.compute line: 0

        # Translate it into position
        paletteBlock.paper.translate new draw.Point 0, lastBottomEdge

        # Increment the running height count
        lastBottomEdge = paletteBlock.paper.bounds[paletteBlock.paper.lineEnd].bottom() + PALETTE_MARGIN # Add margin

        # Finish and draw the palette block
        paletteBlock.paper.finish()
        paletteBlock.paper.draw paletteCtx
    
    # (call it right away)
    @redrawPalette()
    
    ###
    # Cursor operations
    ###
    insertHandwrittenBlock = =>
      # Create the new block and socket for a new handwritten line
      newBlock = new Block []; newSocket = new Socket []
      newSocket.handwritten = true

      # Put the new socket into the new block
      newBlock.start.insert newSocket.start; newBlock.end.prev.insert newSocket.end
      
      # Move it to where the cursor should be
      if @cursor.next.type is 'newline' or @cursor.next.type is 'indentEnd' or @cursor.next.type is 'segmentEnd'
        newBlock._moveTo @cursor.prev.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

      else if @cursor.prev.type is 'newline'
        newBlock._moveTo @cursor.prev
        newBlock.end.insert new NewlineToken()

        @redraw()
        setTextInputFocus newSocket

    moveCursorTo = (token) =>
      # Splice out
      @cursor.remove()

      # Splice in
      token.insert @cursor

    
    moveCursorBefore = (token) =>
      # Splice out
      @cursor.remove()
      
      # Splice in
      token.insertBefore @cursor

    deleteFromCursor = =>
      # Seek the block that we want to delete (i.e. the block that ends first before the cursor, if such thing exists)
      head = @cursor.prev
      console.log head, head.toString indent:''
      while head isnt null and head.type isnt 'indentStart' and head.type isnt 'blockEnd'
        console.log head, head.block?.toString?()
        head = head.prev; console.log head.toString indent:''

      console.log head.toString indent:''

      # Delete that block and redraw
      if head.type is 'blockEnd' then head.block._moveTo null; @redraw()
    
    ###
    # TODO the following are known not to be able to navigate to the end of an indent.
    ###
    moveCursorUp = =>
      # Seek newline
      head = @cursor.prev.prev
      while head isnt null and not (head.type in ['newline', 'indentEnd', 'segmentStart'])
        head = head.prev
      
      # If head is null, we are at the beginning of the file.
      # So, give up.
      if head is null then return

      if head.type is 'indentEnd'
        moveCursorBefore head
      else
        moveCursorTo head

    moveCursorDown = =>
      # Seek newline or newline-like character.
      head = @cursor.next.next
      while head isnt null and not (head.type in ['newline', 'indentEnd', 'segmentEnd'])
        head = head.next

      # If head is null, we are at the end of the file.
      # So, give up.
      if head is null then return

      if head.type is 'indentEnd' or head.type is 'segmentEnd'
        moveCursorBefore head
      else
        moveCursorTo head
    
    ###
    # Bind events to the hidden input
    ###
    
    # For normal text input, we use the "input", "keydownhtml event
    for eventName in ['input', 'keydown', 'keyup', 'keypress']
      @hiddenInput.addEventListener eventName, (event) =>
        # If we haven't focused anything, this input does nothing.
        unless @isEditingText() then return true

        redrawTextInput()

    # For keyboard shortcuts, we use the "keydown" html event
    @hiddenInput.addEventListener 'keydown', (event) =>
      # If we're not on a handwritten line, return immediately
      unless @isEditingText() then return true

      # Otherwise, see if we want to make a keyboard shortcut.
      switch event.keyCode
        when 13
          if @handwritten then insertHandwrittenBlock()
          else setTextInputFocus null; @hiddenInput.blur(); @redraw()
        when 8 then if @handwritten and @hiddenInput.value.length is 0
          deleteFromCursor(); setTextInputFocus null; @hiddenInput.blur()
        when 9 then if @handwritten
          # Seek the block right before this handwritten block
          head = @focus.start.prev.prev
          head = head.prev while head isnt null and head.type isnt 'blockEnd' and head.type isnt 'blockStart'
          
          # If we have found a wrapping (parent) block, then we can't do an indent, so give up.
          if head.type is 'blockStart' then return

          # Otherwise, see if the last child of this block is an indent
          else if head.prev.type is 'indentEnd'
            # Note that it is guaranteed that a handwritten block satisfies @focus.start.prev.block is (the wrapping block)
            @focus.start.prev.block._moveTo head.prev.prev.insert new NewlineToken() # Move the block we're editing into the indent

            # Move the cursor into its proper position (after this block)
            moveCursorTo @focus.start.prev.block.end

            @redraw()
            event.preventDefault(); return false
          
          # We have found a block we want to move into, but there's no indent here, so create one.
          else
            # Create and insert a new indent
            newIndent = new Indent [], INDENT_SPACES
            head.prev.insert newIndent.start; head.prev.insert newIndent.end

            # Move the block we're editing into this new indent
            @focus.start.prev.block._moveTo newIndent.start.insert new NewlineToken()

            # Move the cursor into its proper position (after this block)
            moveCursorTo @focus.start.prev.block.end

            @redraw()
            event.preventDefault(); return false
        when 38 then setTextInputFocus null; @hiddenInput.blur(); moveCursorUp(); @redraw()
        when 40 then setTextInputFocus null; @hiddenInput.blur(); moveCursorDown(); @redraw()
    
    # When we blur the hidden input, also blur the canvas text focus
    ###
    @hiddenInput.addEventListener 'blur', (event) =>
      console.log 'blurred'
      # If we have actually blurred (as opposed to simply unfocused the browser window)
      if event.target isnt document.activeElement then setTextInputFocus null
    ###
    
    ###
    # Bind keyboard shortcut events to the document
    ###

    document.body.addEventListener 'keydown', (event) =>
      # Keyboard shortcuts don't apply if they were executed in a text input area
      if event.target.tagName in ['INPUT', 'TEXTAREA'] then return
      
      switch event.keyCode
        when 13 then unless @isEditingText() then insertHandwrittenBlock()
        when 38 then if @cursor? then moveCursorUp()
        when 40 then if @cursor? then moveCursorDown()
        when 8 then if @cursor? then deleteFromCursor()
        when 37 then if @cursor?
          head = @cursor
          while head.type isnt 'socketEnd' then head = head.prev
          setTextInputFocus head.socket
      
      # If we manipulated the root tree, redraw.
      if event.keyCode in [13, 38, 40, 8] then @redraw()

    ###
    # Hit-testing functions
    ###

    hitTest = (point, root) =>
      head = root; seek = null
      while head isnt seek
        if head.type is 'blockStart' and head.block.paper._container.contains point
          seek = head.block.end
        head = head.next
      
      if seek? then seek.block else null

    hitTestRoot = (point) => hitTest point, @tree.start
    
    hitTestFloating = (point) =>
      for float in @floatingBlocks
        if hitTest(point, float.block.start) isnt null then return float.block
      return null
    
    hitTestFocus = (point) =>
      head = @tree.start
      while head isnt null
        if head.type is 'socketStart' and
            (head.next.type is 'text' or head.next.type is 'socketEnd') and
            head.socket.paper.bounds[head.socket.paper._line].contains point
          return head.socket
        head = head.next

      return null
    
    hitTestLasso = (point) => if @lassoSegment? and @_lassoBounds.contains point then @lassoSegment else null

    hitTestPalette = (point) =>
      point = new draw.Point point.x + PALETTE_WIDTH, point.y
      for block in @paletteBlocks
        if hitTest(point, block.start)? then return block
      return null

    ###
    # Mouse events
    ###

    getPointFromEvent = (event) =>
      switch
        when event.offsetX? then new draw.Point event.offsetX - PALETTE_WIDTH, event.offsetY + @scrollOffset.y
        when event.layerX then new draw.Point event.layerX - PALETTE_WIDTH, event.layerY + @scrollOffset.y

    ###
    # The mousedown event, which sets fields according to what we have just selected.
    ###
    
    track.addEventListener 'mousedown', (event) =>
      point = getPointFromEvent event

      # See what we picked up
      @selection = hitTestFloating(point) ?
        hitTestLasso(point) ?
        hitTestFocus(point) ?
        hitTestRoot(point) ?
        hitTestPalette(point)
      
      if not @selection?
        ###
        # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
        ###
        
        # If there is already a selection, remove it.
        if @lassoSegment?
          @lassoSegment.remove()

          @lassoSegment = null
          @redraw()

        # Set the lasso anchor
        @lassoAnchor = point

      else if @selection.type is 'socket'
        ###
        # If we have clicked on a socket, then TEXT INPUT, indicated by (@isEditingText())
        ###
        
        # Set the text input up for editing
        setTextInputFocus @selection

        # We must set a timeout for the following, because until
        # A render has passed, the hidden input is not actually focused.
        setTimeout (=>
          console.log 'setting anchor', @focus

          setTextInputAnchor point
          redrawTextInput()
          
          # While the mouse is down, we are trying to select text in the input
          textInputSelecting = true

          @selection = null), 0

      else
        ###
        # If we have clicked on a block or segment, then NORMAL DRAG, indicated by (@selection?)
        ###

        # A flag as to whether we are selecting something in the palette
        selectionInPalette = false
        
        # If we clicked something in the palette, we need to compute offset etc. with a point that has been computed
        # with offset to the palette.
        if @selection in @paletteBlocks then point.add PALETTE_WIDTH, 0; selectionInPalette = true

        # Compute the offset of the selection position from the mouse
        rect = @selection.paper.bounds[@selection.paper.lineStart]
        offset = point.from new draw.Point rect.x, rect.y

        # If we have clicked something in the palette, the clone first.
        if selectionInPalette then @selection = @selection.clone()

        # If we have clicked something floating, then delete it from the list of floating blocks
        for float, i in @floatingBlocks
          if float.block is @selection then @floatingBlocks.splice i, 1; break

        # Move it to nowhere
        @selection._moveTo null

        # Draw it in the drag canvas
        @selection.paper.compute line: 0
        @selection.paper.finish()
        @selection.paper.draw dragCtx

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

    ###
    # Track mouse events for NORMAL DRAG (only)
    ###

    track.addEventListener 'mousemove', (event) =>
      if @selection?
        # Determine the position of the mouse
        point = getPointFromEvent event

        point.add -@scrollOffset.x, -@scrollOffset.y

        # First we find the highlighted area
        fixedDest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things exactly in relation to the canvas?

        point.translate @scrollOffset
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y # Where do we position things as related to the way we draw the root tree?

        old_highlight = highlight

        highlight = @tree.find (block) ->
          (not (block.inSocket?() ? false)) and block.paper.dropArea? and block.paper.dropArea.contains dest

        # If highlight changed, redraw
        if old_highlight isnt highlight then @redraw()

        # Highlight the highlight
        if highlight? then highlight.paper.dropArea.fill mainCtx, '#fff'

        # CSS-transform the drag canvas to where it ought to be
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(#{fixedDest.x}px, #{fixedDest.y}px)"
    
    track.addEventListener 'mouseup', (event) =>
      if @selection?
        # Determine the position of the mouse and the place we want to render the block
        point = getPointFromEvent event
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y

        if highlight?
          ###
          # Drop areas signify different things depending on the block that they belong to
          ###
          switch highlight.type
            when 'indent'
              # An insert drop signifies that we want to drop the block at the start of the indent
              @selection._moveTo highlight.start.insert new NewlineToken()

            when 'block'
              # A block drop signifies that we want to drop the block after (the end of) the block.
              @selection._moveTo highlight.end.insert new NewlineToken()

            when 'socket'
              # Remove any previously occupying block or text
              if highlight.content()? then highlight.content().remove()

              # Insert
              @selection._moveTo highlight.start
            
            else
              if highlight is @tree
                # We can also drop on the root tree (insert at the start of the program)
                @selection._moveTo @tree.start
                @selection.end.insert new NewlineToken()

        else
          if point.x > 0
            # If we have dropped the block in nowhere, append it (and it's floating position) to @floatingBlocks.
            @floatingBlocks.push
              position: dest
              block: @selection
          
          # (If we have dropped the block on the palette, delete it. This requires no operations).

        
        # CSS-transform the drag canvas back to the origin
        drag.style.webkitTransform =
          drag.style.mozTransform =
          drag.style.transform = "translate(0px, 0px)"
        
        # Clear the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted into root, move the cursor to the end of the selection.
        if highlight?
          # Seek the next newline after the end of this block,
          # which is where we'll want to move the cursor
          # (so that it looks like we put it directly after the block).
          head = @selection.end
          while head isnt @tree.end and head.type isnt 'newline' then head = head.next
          if head is @tree.end then moveCursorBefore head
          else moveCursorTo head

        # Signify that we are no longer in a NORMAL DRAG
        @selection = null
        
        # Redraw after the selection has been set to null, since @redraw is sensitive to what things are being dragged.
        @redraw()

    ###
    # Track mouse events for LASSO SELECT
    ###

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
        point.translate @scrollOffset # (position fixed, as in relation to the drag canvas, on which we will draw it)

        # Get the rectangle we want to draw
        rect = getRectFromPoints @lassoAnchor, point

        # Clear and redraw the lasso on the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height
        dragCtx.strokeStyle = '#00f'
        dragCtx.strokeRect rect.x, rect.y, rect.width, rect.height

    track.addEventListener 'mouseup', (event) =>
      if @lassoAnchor?
        # Determine the position of the mouse
        point = getPointFromEvent event
        point.translate @scrollOffset

        # Get the rectangle we want to test
        rect = getRectFromPoints @lassoAnchor, point

        ###
        # First pass for lasso segment detection: get intersecting blocks.
        ###
        
        # Find the first matching block
        head = @tree.start
        firstLassoed = null
        while head isnt @tree.end
          # A block matches if it intersects the lasso rectangle
          if head.type is 'blockStart' and head.block.paper._container.intersects rect
            firstLassoed = head
            break
          head = head.next
        
        # Find the last matching block analagously
        head = @tree.end
        lastLassoed = null
        while head isnt @tree.start
          if head.type is 'blockEnd' and head.block.paper._container.intersects rect
            lastLassoed = head
            break
          head = head.prev

        # Unless we have selected anything, give up.
        if firstLassoed? and lastLassoed?
          ###
          # Second pass for lasso segment detection: validate the selection and record wrapping blocks as necessary.
          ###
          
          tokensToInclude = []

          head = firstLassoed
          while head isnt lastLassoed
            ###
            # For each bit of markup, make sure to include both its start token and end token
            ###
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

          ###
          # Third pass for lasso segment detection: include all necessary tokens demanded by validation
          ###

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

          ###
          # Fourth pass for lasso segment detection: make sure that we have selected the wrapping block for any indents
          #
          # Note that this will only occur when we have inserted the indentStart at the beginning or indentEnd at the end
          # in the second and third pass. This in turn will occur ONLY when the user has selected multiple blocks belonging to the
          # same wrapping block, and nothing outside it (i.e. the wrapping block of the indent wraps the entire selection).
          #
          # So it suffices to select that entire wrapping block.
          ###

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
          @lassoSegment = new Segment []

          firstLassoed.insertBefore @lassoSegment.start
          lastLassoed.insert @lassoSegment.end

          @redraw()
        
        # Clear the drag canvas
        dragCtx.clearRect 0, 0, drag.width, drag.height

        # If we inserted a lasso segment, move the cursor appropriately
        if @lassoSegment? then moveCursorTo @lassoSegment.end
        
        # Flag that we are no longer in a LASSO SELECT.
        @lassoAnchor = null

        @redraw()


    ###
    # Utility functions for TEXT INPUT
    ###

    redrawTextInput = =>
      # Change the edited text
      @editedText.value = @hiddenInput.value

      # Redraw the background (main canvas)
      @redraw()
      
      # Determine the position (coordinate-wise) of the typing cursor
      start = @editedText.paper.bounds[_editedInputLine].x +
        mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionStart]).width

      end = @editedText.paper.bounds[_editedInputLine].x +
        mainCtx.measureText(@hiddenInput.value[...@hiddenInput.selectionEnd]).width
      
      # Draw the typing cursor itself
      if start is end
        # This is just a line
        mainCtx.strokeRect start, @editedText.paper.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT
      else
        # This is the translucent rectangle
        mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3'
        mainCtx.fillRect start, @editedText.paper.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT

    setTextInputFocus = (focus) =>
      # Literally set the focus
      @focus = focus
      
      # If we just removed the focus, then we are done.
      if @focus is null then return
      
      # Record the line that the focus is on
      _editedInputLine = @focus.paper._line

      # Flag whether we are editing handwritten
      @handwritten = @focus.handwritten
      
      if not @focus.content()
        # If the socket is empty, put a text thing in, setting that to the edited text
        @editedText = new TextToken ''
        @focus.start.insert @editedText
      
      else if @focus.content().type is 'text'
        # If the socket is not empty but contains only text, edit that text
        @editedText = @focus.content()

      else
        # Otherwise, we have an error condition.
        throw 'Cannot edit occupied socket.'


      # Find the wrapping block and move the cursor to
      head = @focus.end; depth = 0
      while head.type isnt 'newline' and head.type isnt 'indentEnd' and head.type isnt 'segmentEnd' then head = head.next
      
      if head.type is 'newline' then moveCursorTo head
      else moveCursorBefore head
      
      # Set the contents of the hidden input
      @hiddenInput.value = @editedText.value

      # Focus the hidden input
      setTimeout (=> @hiddenInput.focus()), 0

    setTextInputHead = (point) =>
      textInputHead = Math.round (point.x - @focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width

      @hiddenInput.setSelectionRange Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead)

    setTextInputAnchor = (point) =>
      textInputAnchor = textInputHead = Math.round (point.x - @focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width
      @hiddenInput.setSelectionRange textInputAnchor, textInputHead

    ###
    # Track mouse events for TEXT INPUT
    ###

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

    ###
    # Track events for SCROLLING
    ###
    track.addEventListener 'mousewheel', (event) =>
      @clear()

      if event.wheelDelta > 0
        if @scrollOffset.y >= 100
          @scrollOffset.add 0, -100
          mainCtx.translate 0, 100
      else
        @scrollOffset.add 0, 100
        mainCtx.translate 0, -100

      @redraw()

  setValue: (value) ->
    @tree = coffee.parse(value).segment
    @redraw()

  getValue: -> @tree.toString()

window.onload = ->
  # Tests
  window.editor = new Editor document.getElementById('editor'), (coffee.parse(paletteElement).next.block for paletteElement in [
    '''
    for i in [1..10]
      alert 'hello'
    '''
    '''
    alert 'hello'
    '''
    '''
    if a is b
      alert 'hi'
    else
      alert 'bye'
    '''
    '''
    a = b
    '''
  ])
  editor.setValue '''
  for i in [1..10]
    if i % 2 is 0
      alert i
      alert 'bye'
    else
      alert 'fizz'
    alert 'buzz'
  '''
