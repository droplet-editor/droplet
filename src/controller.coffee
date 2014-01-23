out = null

exports.Editor = class Editor
  constructor: (el) ->
    # Create all the necessary canvases
    canvas = document.createElement 'canvas'; canvas.className = 'canvas'
    canvas.height = el.offsetHeight
    canvas.width = el.offsetWidth - PALETTE_WIDTH

    paletteCanvas = document.createElement 'canvas'; paletteCanvas.className = 'palette'
    paletteCanvas.height = el.offsetHeight
    paletteCanvas.width = PALETTE_WIDTH
    
    dragCanvas = document.createElement 'canvas'; dragCanvas.className = 'drag'
    dragCanvas.height = el.offsetHeight
    dragCanvas.width = el.offsetWidth - PALETTE_WIDTH

    # Create the tracking div
    div = document.createElement 'div'; div.className = 'trackArea'
    
    # Append them all
    el.appendChild canvas
    el.appendChild dragCanvas
    el.appendChild paletteCanvas
    el.appendChild div
    
    # Get contexts
    ctx = canvas.getContext '2d'
    dragCtx = dragCanvas.getContext '2d'
    paletteCtx = paletteCanvas.getContext '2d'
    
    # Do a hack for text measurement
    draw._setCTX ctx

    tree = coffee.parse '''
      window.onload = ->
        if document.getElementsByClassName('test').length > 0
          for [1..10]
            document.body.appendChild document.createElement 'script'
          alert 'found a test element'
        document.getElementsByTagName('button').onclick = ->
          alert 'somebody clicked a button'
    '''

    ###
    # Dragging
    ###
    scrollOffset = new draw.Point 0, 0 # How far have we scrolled down?
    highlight = null # Highlighted drop area
    selection = null # Selected (dragged) text
    offset = null # Dragging offset

    ###
    # Hidden input hack
    ###
    input = null # Hidden html input for text input
    focus = null # Focused segment that we are modifying
    anchor = head = null # Selected text
    
    ###
    # Lasso select
    ####
    lassoAnchor = null # These will be draw.Points.
    lassoHead = null
    lassoSegment = null # This will be an ICE.Segment
    lassoBounds = null

    # "Root" blocks, floating in space
    floating_blocks = []
    
    # Clear the main canvas
    clear = ->
      ctx.clearRect scrollOffset.x, scrollOffset.y, canvas.width, canvas.height

    # Recompute and redraw. Benchmarked to around 1.142 mils.
    redraw = ->
      clear()
      tree.segment.paper.compute {line: 0}
      tree.segment.paper.finish()
      tree.segment.paper.draw ctx
      out.value = tree.segment.toString {indent: ''}

      if lassoSegment? then lassoSegment.paper.prepBounds()

      for block in floating_blocks
        block.block.paper.compute line: 0
        block.block.paper.translate block.position
        block.block.paper.finish()
        block.block.paper.draw ctx
      
      if lassoSegment?
        unless lassoSegment is selection
          (lassoBounds = lassoSegment.paper.getBounds()).stroke ctx, '#000'
          lassoBounds.fill ctx, 'rgba(0, 0, 256, 0.3)'
    
    # Just redraw (no recompute)
    fastDraw = ->
      clear()
      tree.segment.paper.draw ctx

      for block in floating_blocks
        block.block.paper.draw ctx

      if lassoSegment?
        unless lassoSegment is selection
          lassoBounds.stroke ctx, '#000'
          lassoBounds.fill ctx, 'rgba(0, 0, 256, 0.3)'
    
    redraw()

    ###
    # Here to below will eventually become part of the IceEditor() class
    ###
    
    div.addEventListener 'touchstart', div.onmousedown = (event) ->
      if event.offsetX?
        point = new draw.Point event.offsetX, event.offsetY
      else
        point = new draw.Point event.layerX, event.layerY
      point.add -PALETTE_WIDTH, 0
      point.translate scrollOffset

      # First, see if we are trying to focus an empty socket
      focus = tree.segment.findSocket (block) ->
        block.paper._empty and block.paper.bounds[block.paper._line].contains point

      if focus?
        # Insert the text token we're editing
        if focus.content()? then text = focus.content()
        else focus.start.insert text = new TextToken ''

        if input? then input.parentNode.removeChild input

        # Append the hidden input
        document.body.appendChild input = document.createElement 'input'
        input.className = 'hidden_input'
        line = focus.paper._line
        
        input.value = focus.content().value

        # Here we have to abuse the fact that we use a monospace font (we could do this in linear time otherwise, but this is neat)
        anchor = head = Math.round((start = point.x - focus.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width)
        
        # Do an immediate redraw
        redraw()

        # Bind the update to the input's key handlers
        input.addEventListener 'input',  input.onkeydown = input.onkeyup = input.onkeypress = ->
          text.value = this.value
          
          # Recompute the socket itself
          text.paper.compute line: line
          focus.paper.compute line: line
          
          # Ask the root to recompute the line that we're on (automatically shift everything to the right of us)
          # This is for performance reasons; we don't need to redraw the whole tree.
          old_bounds = tree.segment.paper.bounds[line].y
          tree.segment.paper.setLeftCenter line, new draw.Point 0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2
          if tree.segment.paper.bounds[line].y isnt old_bounds
            # This is totally hacky patch for a bug whose source I don't know.
            tree.segment.paper.setLeftCenter line, new draw.Point 0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2 - 1
          tree.segment.paper.finish()
          
          # Do the fast draw operation and toString() operation.
          fastDraw()
          out.value = tree.segment.toString {indent: ''}

          # Draw the typing cursor
          start = text.paper.bounds[line].x + ctx.measureText(this.value[...this.selectionStart]).width
          end = text.paper.bounds[line].x + ctx.measureText(this.value[...this.selectionEnd]).width

          if start is end
            ctx.strokeRect start, text.paper.bounds[line].y, 0, 15
          else
            ctx.fillStyle = 'rgba(0, 0, 256, 0.3)'
            ctx.fillRect start, text.paper.bounds[line].y, end - start, 15

        setTimeout (->
          input.focus()
          input.setSelectionRange anchor, anchor
          input.dispatchEvent(new CustomEvent('input'))
        ), 0

      else
        # See if we picked up the lasso
        if lassoSegment? and lassoBounds.contains point
          selection = lassoSegment
        else
          # Immediately unlasso
          if lassoSegment?
            if lassoSegment.start.prev? # This will mean that lassoSegment is not a root segment
              lassoSegment.remove()
            lassoSegment = null
          # Find the block that was just clicked
          selection = tree.segment.findBlock (block) ->
            block.paper._container.contains point
          
        # We aren't copying from the palette
        cloneLater = false

        unless selection?
          selection = null
          for block, i in floating_blocks
            if block.block.findBlock((x) -> x.paper._container.contains point)?
              floating_blocks.splice i, 1
              selection = block.block
              break
            else selection = null

          unless selection?
            # See if we matched any palette blocks
            shiftedPoint = new draw.Point point.x + PALETTE_WIDTH, point.y
            shiftedPoint.add -scrollOffset.x, -scrollOffset.y

            for block in palette_blocks
              if block.findBlock((x) -> x.paper._container.contains shiftedPoint)?
                # We're grabbing this block
                selection = block

                # Actually, we are copying from the palette
                cloneLater = true
                break
              else selection = null

        if selection?
          ### 
          # We've now found the selected text, move it as necessary.
          ###

          # Remove the newline before, if necessary
          if selection.start.prev? and selection.start.prev.type is 'newline'
            selection.start.prev.remove()

          # Compute the offset of our cursor from the selection position (for drag-and-drop)
          bounds = selection.paper.bounds[selection.paper.lineStart]

          if cloneLater then offset = shiftedPoint.from new draw.Point bounds.x, bounds.y
          else offset = point.from new draw.Point bounds.x, bounds.y

          # Remove it from its tree
          if cloneLater then selection = selection.clone()
          else selection._moveTo null

          # Redraw the root tree (now that selection has been removed)
          redraw()
          
          # Redraw the selection on the drag canvas
          selection.paper.compute {line: 0}
          selection.paper.finish()
          selection.paper.draw dragCtx

          if selection is lassoSegment
            lassoSegment.paper.prepBounds()
            (lassoBounds = lassoSegment.paper.getBounds()).stroke dragCtx, '#000'
            lassoBounds.fill dragCtx, 'rgba(0, 0, 256, 0.3)'
          
          # Immediately transform the drag canvas
          div.onmousemove event
        else
          # We haven't clicked on anything. So do a lasso select.
          lassoAnchor = lassoHead = point
          
          # Move the drag canvas into position 0, 0
          dragCanvas.style.webkitTransform = "translate(0px, 0px)"
          dragCanvas.style.mozTransform = "translate(0px, 0px)"
          dragCanvas.style.transform = "translate(0px, 0px)"

      # Immediate redraw
      redraw()
      
    div.addEventListener 'touchmove', div.onmousemove = (event) ->
      # Determine where the point is on the canvas
      if event.offsetX?
        point = new draw.Point event.offsetX, event.offsetY
      else
        point = new draw.Point event.layerX, event.layerY
      point.add -PALETTE_WIDTH, 0

      if selection?
        # Figure out where we want the selection to go
        scrollDest = new draw.Point -offset.x + point.x, -offset.y + point.y
        point.translate scrollOffset
        dest = new draw.Point -offset.x + point.x, -offset.y + point.y

        old_highlight = highlight

        # Find the highlighted area
        highlight = tree.segment.find (block) ->
          (not (block.inSocket?() ? false)) and block.paper.dropArea? and block.paper.dropArea.contains dest
        
        # Redraw if we must
        if highlight isnt old_highlight or window.PERFORMANCE_TEST
          fastDraw()
          
          if highlight?
            # Highlight the highlighted area
            highlight.paper.dropArea.fill(ctx, '#fff')
        
        # css-transform the drag canvas to that area
        dragCanvas.style.webkitTransform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"
        dragCanvas.style.mozTransform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"
        dragCanvas.style.transform = "translate(#{scrollDest.x}px, #{scrollDest.y}px)"

        event.preventDefault()

      else if focus? and anchor?
        # Compute the points
        text = focus.content(); line = text.paper._line

        head = Math.round((point.x - text.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width)

        # Clear the current selection
        bounds = text.paper.bounds[line]
        ctx.clearRect bounds.x, bounds.y, bounds.width, bounds.height

        # Redraw the text
        text.paper.draw ctx

        # Draw the rectangle
        start = text.paper.bounds[line].x + ctx.measureText(text.value[...head]).width
        end = text.paper.bounds[line].x + ctx.measureText(text.value[...anchor]).width

        # Either draw the selection or the cursor
        if start is end
          ctx.strokeRect start, text.paper.bounds[line].y, 0, 15
        else
          ctx.fillStyle = 'rgba(0, 0, 256, 0.3)'
          ctx.fillRect start, text.paper.bounds[line].y, end - start, 15
      else if lassoAnchor?
        dragCtx.clearRect 0 ,0, dragCanvas.width, dragCanvas.height
        dragCtx.strokeStyle = '#00f'
        
        # Remember the lassoHead
        lassoHead = point

        corner =
          x: Math.min lassoAnchor.x, point.x
          y: Math.min lassoAnchor.y, point.y
        size =
          width: Math.abs lassoAnchor.x - point.x
          height: Math.abs lassoAnchor.y - point.y
        dragCtx.strokeRect corner.x, corner.y, size.width, size.height

    div.addEventListener 'touchend', div.onmouseup = (event) ->
      if selection?
        if highlight?
          switch highlight.type
            when 'indent'
              selection._moveTo highlight.start.insert new NewlineToken()
            when 'block'
              selection._moveTo highlight.end.insert new NewlineToken()
            when 'socket'
              if highlight.content()? then highlight.content().remove()
              selection._moveTo highlight.start

          if highlight is tree.segment # We inserted it in the root.
            selection._moveTo highlight.start

          # Redraw the root tree
          redraw()
        else
          # Determine the place we want to draw the thing
          if event.offsetX?
            point = new draw.Point event.offsetX, event.offsetY
          else
            point = new draw.Point event.layerX, event.layerY
          point.add -PALETTE_WIDTH, 0
          point.translate scrollOffset

          dest = new draw.Point -offset.x + point.x, -offset.y + point.y

          if dest.x > 0 # If we drop in the palette we delete the element
            # Draw the selection on the back canvas
            selection.paper.compute line: 0
            selection.paper.translate dest
            selection.paper.finish()
            selection.paper.draw ctx

            # Push this to the set of floating blocks
            floating_blocks.push block: selection, position: dest
          else lassoSegment = null # Unlasso if we just deleted the lasso.

      else if focus?
        # Make the selection
        input.setSelectionRange Math.min(anchor, head), Math.max(anchor, head)

        # Stop selecting
        anchor = head = null

      else if lassoAnchor?
        corner =
          x: Math.min lassoAnchor.x, lassoHead.x
          y: Math.min lassoAnchor.y, lassoHead.y
        size =
          width: Math.abs lassoAnchor.x - lassoHead.x
          height: Math.abs lassoAnchor.y - lassoHead.y

        lassoRect = new draw.Rectangle corner.x, corner.y, size.width, size.height

        # Find the first lassoed element
        # Code structure -- does this belong in ice.coffee? TODO
        
        # Find first
        firstLassoed = null
        head = tree.segment.start
        while head isnt tree.segment.end
          if head.type is 'blockStart' and head.block.paper._container.intersects lassoRect
            firstLassoed = head.block
            break
          head = head.next
        
        # Find last
        lastLassoed = null
        head = tree.segment.end
        while head isnt tree.segment.start
          if head.type is 'blockEnd' and head.block.paper._container.intersects lassoRect
            lastLassoed = head.block
            break
          head = head.prev

        if firstLassoed? and lastLassoed?
          # First, validate the selection
          stack = [firstLassoed]
          head = firstLassoed.start.next
          while head isnt lastLassoed.end
            switch head.type
              when 'blockStart'
                stack.push head.block
              when 'segmentStart'
                stack.push head.segment
              when 'indentStart'
                stack.push head.indent
              when 'blockEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.block
              when 'segmentEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.segment
              when 'indentEnd'
                if stack.length > 0
                  stack.pop()
                else
                  # We have an end-tag without its start tag, so append that
                  firstLassoed = head.indent

                  # We can't just drag an indent, so find the surrounding block
                  #
                  # TODO the following is untested
                  _head = head.indent.start
                  _stack = []
                  while _head isnt null
                    if _head.type is 'blockEnd' then _stack.push _head.block
                    else if _head.type is 'blockStart'
                      if _stack.length > 0
                        _stack.pop()
                      else
                        stack.unshift _head.block
                        firstLassoed = _head.block
                        break
                    _head = _head.prev

            head = head.next
        
          # We have a start-tag without its end-tag, so append that as well
          if stack[0].type is 'indent'
            # We can't just drag an indent, so find the surrounding block
            head = stack[0].end
            _stack = []
            while head isnt null
              if head.type is 'blockStart' then console.log 'discards', head.block.toString(); _stack.push head.block
              else if head.type is 'blockEnd'
                console.log head.block.toString(), stack
                if _stack.length > 0
                  _stack.pop()
                else
                  unless head.block in stack
                    firstLassoed = head.block
                  stack[0] = head.block
                  break
              head = head.next

          lastLassoed = stack[0]

          lassoSegment = new Segment []

          firstLassoed.start.prev.insert lassoSegment.start
          lastLassoed.end.insert lassoSegment.end

      # Clear the drag canvas
      dragCtx.clearRect 0, 0, canvas.width, canvas.height

      # Unselect
      selection = null

      # Unlasso
      lassoAnchor = null

      # Full redraw for cleanliness
      redraw()

    div.addEventListener 'mousewheel', (event) ->
      if scrollOffset.y > 0 or event.deltaY > 0
        ctx.translate 0, -event.deltaY
        scrollOffset.add 0, event.deltaY
        fastDraw()

        event.preventDefault()

        return false
      return true
    
    out.onkeyup = ->
      try
        tree = coffee.parse out.value#ICE.indentParse out.value
        redraw()
      catch e
        ctx.fillStyle = "#f00"
        ctx.fillText e.message, 0, 0
    
    # This palette for testing only
    palette_blocks = [
      (coffee.parse '''
        a = b
      ''').segment
      
      (coffee.parse '''
        alert 'hi'
      ''').segment

      (coffee.parse '''
        for i in [1..10]
          alert 'good'
      ''').segment

      (coffee.parse '''
        return 0
      ''').segment
    ]
    
    running_height = 0
    for block in palette_blocks
      block.paper.compute line: 0

      # Translate into position
      block.paper.translate new draw.Point 0, running_height

      block.paper.finish()
      running_height = block.paper.bounds[block.paper.lineEnd].bottom() + PALETTE_WHITESPACE

      block.paper.draw paletteCtx

window.onload = ->
  unless window.RUN_PAPER_TESTS then return
  
  out = document.getElementById 'out'
  new Editor document.getElementById 'editor'
