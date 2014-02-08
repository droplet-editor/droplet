class IceView

  constructor: (@block) ->
    @children = [new IcePaper()] # All child blocks, for event delegation.
    
    # Start and end lines
    @lineStart = @lineEnd = null

    @lineChildren =
      'lineno': new IcePaper() # Children on each line, computed in FIRST PASS

    @dimensions =
      'lineno': new draw.Size 0, 0 # Bounding box on each line, computed in SECOND PASS

    @bounds =
      'lineno': new draw.NoRectangle() # Bounding boxes on each line, computed in THIRD PASS

  # FIRST PASS: generate @lineChildren and @children
  computeChildren: (line) -> # (line) is the starting line

    # Record the starting line
    @lineStart = line

    # Linked-list loop through inner tokens
    head = @block.start
    while head isnt @block.end
      switch head.type
        when 'blockStart'
          # Ask this child to compute its children (thus determining its ending line, as well)
          line = head.indent.view.computeChildren line

          # Append to children array
          @children.push head.block.view

          # Append to line children array
          for occupiedLine in [head.indent.view.lineStart..head.indent.view.lineEnd] # (iterate over all lines which this indent occupies)
            # (initialize empty array if it doesn't already exist
            @lineChildren[occupiedLine] ?= []

            # Push to the children on this line
            @lineChildren[occupiedLine].push head.indent.view

          # Skip to the end of this indent
          head = head.block.end

        when 'indentStart'
          # Act analagously for indents
          line = head.indent.view.computeChildren line

          # Append to children array
          @children.push head.block.view

          # Append to line children array
          for occupiedLine in [head.indent.view.lineStart..head.indent.view.lineEnd] # (iterate over all lines which this indent occupies)
            # (initialize empty array if it doesn't already exist
            @lineChildren[occupiedLine] ?= []

            # Push to the children on this line
            @lineChildren[occupiedLine].push head.indent.view

          # Skip to the end of this indent
          head = head.block.end

        when 'text', 'cursor'
          # Act analagously for text and cursor
          head.view.computeChildren line
          
          # (For text and cursor the token itself is also the manifested thing)
          @children.push head.view
          
          @lineChildren[line] ?= []; @lineChildren[line].push head.view

        when 'newline'
          line += 1
      
      # Advance our head token (linked-loop list)
      head = head.next
    
    # Record the last line
    @lineEnd = line

    return line
  
  # SECOND PASS: compute dimensions on each line
  computeDimensions: -> # A block's dimensions on each line is strictly a function of its children, so this function has no arguments.
    # Event propagate
    for child in @children then child.computeDimensions()

    return @dimensions
  
  # THIRD PASS: compute bounding boxes on each line
  computeBoundingBox: (line, state) -> # (line) and (state) are given by the calling parent and signify restrictions on the position of the line (e.g. padding, etc).
    # Event propagate
    for child in @lineChildren[line] then child.computeBoundingBox line, state # In an instance of this function, you will want to change (state) as you move along @lineChildren[line], to adjust for padding and such.

    return @bounds[line] = new draw.NoRectangle() # Should actually equal something

  # Convenience function: computeBoundingBoxes. Normally only called on root or floating block.
  computeBoundingBoxes: ->
    for line in [@lineStart..@lineEnd]
      computeBoundingBox line, new BoundingBoxState()

    return @bounds


  # FOURTH PASS: join "path bits" into a path
  computePath: ->
    # Event propagate
    for child in @children then child.computePath()

    return @bounds

  # FIFTH PASS: draw
  draw: (ctx) ->
    # Event propagate
    for child in @children then child.draw ctx

  # Convenience function: compute
  compute: (line = 0) ->
    @computeChildren line
    @computeDimensions(); @computeBoundingBoxes(); @computePath()
