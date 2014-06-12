define ['ice-model', 'ice-parser', 'coffee-script'], (model, parser, CoffeeScript) ->
  exports = {}

  COLORS =
    COMMAND: '#268bd2'
    CONTROL: '#daa520'
    VALUE: '#26cf3c'
    RETURN: '#dc322f'

  OPERATOR_PRECEDENCES =
    '||': 1
    '&&': 2
    'instanceof': 3
    '===': 3
    '!==': 3
    '>': 3
    '<': 3
    '>=': 3
    '<=': 3
    '+': 4
    '-': 4
    '*': 5
    '/': 5
    '%': 6
    '**': 7
    '%%': 7

  class CoffeeScriptTranspiler
    constructor: (@text) ->
      @markup = []

      @lines = @text.split '\n'

      # Preprocess comment lines:
      tokens = CoffeeScript.tokens @text,
        rewrite: false
        preserveComments: true
      
      # In the @lines record, replace all
      # comments with spaces, so that blocks
      # avoid them whenever possible.
      for token in tokens
        if token[0] is 'COMMENT'

          if token[2].first_line is token[2].last_line
            line = @lines[token[2].first_line]
            @lines[token[2].first_line] =
              line[...token[2].first_column] +
              (' ' for [token[2].first_column..token[2].last_column]).join('') +
              line[token[2].last_column...]

          else
            line = @lines[token[2].first_line]
            @lines[token[2].first_line] = line[...token[2].first_column] +
              (' ' for [token[2].first_column..line.length]).join ''

            @lines[token[2].last_line] = (' ' for [1..@lines[token[2].last_line].length]).join ''

            for i in [(token[2].first_line + 1)...token[2].last_line]
              @lines[i] = @lines[i].replace /./g, ' '

      @hasLineBeenMarked = {}

      for line, i in @lines
        @hasLineBeenMarked[i] = false

    locationsAreIdentical: (a, b) ->
      return a.line is b.line and a.column is b.column
    
    boundMin: (a, b) ->
      if a.line < b.line then a
      else if b.line < a.line then b
      else if a.column < b.column then a
      else b

    boundMax: (a, b) ->
      if a.line < b.line then b
      else if b.line < a.line then a
      else if a.column < b.column then b
      else a
    
    # ## getBounds ##
    # Get the boundary locations of a CoffeeScript node,
    # using CoffeeScript location data and
    # adjust to deal with some quirks.
    getBounds: (node) ->
      # Most of the time, we can just
      # take CoffeeScript locationData.
      bounds =
        start:
          line: node.locationData.first_line
          column: node.locationData.first_column
        end:
          line: node.locationData.last_line
          column: node.locationData.last_column + 1
      
      # There are four cases where CoffeeScript
      # actually gets location data wrong.

      # The first is CoffeeScript 'Block's,
      # which give us only the first line.
      # So we need to adjust.
      if node.nodeType() is 'Block'
        # If we have any child expressions,
        # set the end boundary to be the end
        # of the last one
        if node.expressions.length > 0
          bounds.end = @getBounds(node.expressions[node.expressions.length - 1]).end

        #If we have no child expressions, make the bounds actually empty.
        else
          bounds.start = bounds.end
      
      # The second is 'If' statements,
      # which do not surround the elseBody
      # when it exists.
      if node.nodeType() is 'If'
        bounds.start = @boundMin bounds.start, @getBounds(node.body).start
        bounds.end = @boundMax bounds.end, @getBounds(node.body).end

        if node.elseBody?
          bounds.end = @boundMax bounds.end, @getBounds(node.elseBody).end
      
      # The third is 'While', which
      # fails to surround the loop body,
      # or sometimes the loop guard.
      if node.nodeType() is 'While'
        bounds.start = @boundMin bounds.start, @getBounds(node.body).start
        bounds.end = @boundMax bounds.end, @getBounds(node.body).end

        if node.guard?
          bounds.end = @boundMax bounds.end, @getBounds(node.guard).end
      
      # The fourth is general. Sometimes we get
      # spaces at the start of the next line.
      # We don't want those spaces; discard them.
      while @lines[bounds.end.line][...bounds.end.column].trim().length is 0
        bounds.end.line -= 1
        bounds.end.column = @lines[bounds.end.line].length + 1
      
      # When we have a 'Value' object,
      # its base may have some exceptions in it,
      # in which case we want to pass on to
      # those.
      if node.nodeType() is 'Value'
        return @getBounds node.base
      
      return bounds
    
    # ## addMarkupAtLocation ##
    # Add a Model container into the markup that we will
    # ultimately return at a given location.
    addMarkupAtLocation: (container, bounds, depth) ->

      @hasLineBeenMarked[bounds.start.line] = true

      @markup.push
        container: container
        bounds: bounds
        depth: depth
    
    # ## addMarkup ##
    # A general utility function for adding markup around
    # a given node.
    addMarkup: (container, node, wrappingParen, depth) ->

      # If we are surrounded by parentheses,
      # we may actually want to enclose the parenthesis
      # by the new block and not the node itself.
      bounds = @getBounds (wrappingParen ? node)
      
      # Add the markup.
      @addMarkupAtLocation container, bounds, depth
    
    # ## addBlock ##
    # A general utility function for adding an ICE editor
    # block around a given node.
    addBlock: (node, depth, precedence, color, wrappingParen) ->
      # Create the block.
      block = new model.Block precedence, color, (color is COLORS.VALUE)
      
      # Add it
      @addMarkup block, node, wrappingParen, depth
      
      # If necessary, flag it as paren-wrapped.
      block.currentlyParenWrapped = wrappingParen?
    
    # ## addSocket ##
    # A similar utility function for adding sockets.
    addSocket: (node, depth, precedence) ->
      socket = new model.Socket null, precedence

      @addMarkup socket, node, null, depth

    # ## addSocketAndMark ##
    # Adds a socket around a block, and @marks it.
    addSocketAndMark: (node, depth, precedence, indentDepth) ->
      @addSocket node, depth, precedence

      @mark node, depth + 1, precedence, null, indentDepth
    
    # ## wrapSemicolonLine ##
    # Wrap a single line in a block
    # for semicolons.
    wrapSemicolonLine: (firstBounds, lastBounds, expressions, depth) ->
      # Make the wrapper
      block = new model.Block 0, COLORS.COMMAND, false

      # Put together a boundary that contains all things
      surroundingBounds =
        start: firstBounds.start
        end: lastBounds.end

      # Add the markup itself
      @addMarkupAtLocation block, surroundingBounds, depth + 1

      # Add sockets for each expression
      for child in expressions
        @addSocket child, depth + 2, 0

    # ## wrapSemicolons ##
    # If there are mutliple expressions we have on the same line,
    # add a semicolon block around them.
    wrapSemicolons: (expressions, depth) ->
      
      # We will keep track of the first and last
      # nodes on the current line, and their bounds.
      firstNode = lastNode =
        firstBounds = lastBounds = null
      
      # We will also keep track of the nodes
      # that are on this line, so that
      # we can surround them in sockets
      # in the future.
      nodesOnCurrentLine = []

      for expr in expressions
        # Get the bounds for this expression
        bounds = @getBounds expr
        
        # If we are on the same line as the last expression, update
        # lastNode to reflect.
        if bounds.start.line is firstBounds?.end.line
          lastNode = expr; lastBounds = bounds
          nodesOnCurrentLine.push expr

        # Otherwise, we are on a new line.
        # See if the previous line needed a semicolon wrapper

        # If there were at least two blocks on the previous line,
        # they do need a semicolon wrapper.
        else
          if lastNode? then @wrapSemicolonLine firstBounds, lastBounds, nodesOnCurrentLine, depth
          
          # Regardless of whether or not we added semicolons on the last line,
          # clear the records to make way for the new line.
          firstNode = expr; lastNode = null
          firstBounds = @getBounds expr; lastBounds = null
          nodesOnCurrentLine = [expr]
      
      # Wrap up the last line if necessary.
      if lastNode? then @wrapSemicolonLine firstBounds, lastBounds, nodesOnCurrentLine, depth
    
    # ## mark ##
    # Mark a single node.
    mark: (node, depth, precedence, wrappingParen, indentDepth) ->
      switch node.nodeType()

        # ### Block ###
        # A Block is a group of expressions,
        # which is represented by either an indent or a socket.
        when 'Block'
          # Abort if empty
          if node.expressions.length is 0 then return
          
          # Otherwise, get the bounds to determine
          # whether we want to do it on one line or multiple lines.
          bounds = @getBounds node
          
          # See if we want to wrap in a socket
          # rather than an indent.
          shouldBeOneLine = false
          
          # Check to see if any parent node is occupying a line
          # we are on. If so, we probably want to wrap in
          # a socket rather than an indent.
          for line in [bounds.start.line..bounds.end.line]
            shouldBeOneLine or= @hasLineBeenMarked[line]
          
          if shouldBeOneLine
            @addSocket node, depth, 0
          
          # Otherwise, wrap in an indent.
          else
            # Determine the new indent depth by literal text inspection
            textLine = @lines[bounds.start.line]
            trueIndentDepth = textLine.length - textLine.trimLeft().length

            # Create the indent with the proper
            # depth delta
            indent = new model.Indent trueIndentDepth - indentDepth
            
            # Then update indent depth data to reflect.
            indentDepth = trueIndentDepth
            
            # Move the boundaries back by one line,
            # as per the standard way to add an Indent.
            bounds.start.line -= 1
            bounds.start.column = @lines[bounds.start.line].length + 1
            
            # Add the indent per se.
            @addMarkupAtLocation indent, bounds, depth


          # Mark children. We do this at depth + 3 to
          # make room for semicolon wrappers where necessary.
          for expr in node.expressions
            @mark expr, depth + 3, 0, null, indentDepth
          
          # Wrap semicolons.
          @wrapSemicolons node.expressions, depth

        # ### Parens ###
        # Parens are special; they get no marks
        # but pass to the next node with themselves
        # as the wrapping parens.
        #
        # If we are ourselves wrapped by a parenthesis,
        # then keep that parenthesis when we pass on.
        when 'Parens'
          if node.body?
            @mark node.body.unwrap(), depth + 1, 0, (wrappingParen ? node), indentDepth

        # ### Op ###
        # Color VALUE, sockets @first and (sometimes) @second
        when 'Op'
          # An addition operator might be
          # a string interpolation, in which case
          # we want to ignore it.
          if node.first? and node.second? and node.operator is '+'
            # We will search for a literal "+" symbol
            # between the two operands. If there is none,
            # we assume string interpolation.
            firstBounds = @getBounds node.first
            secondBounds = @getBounds node.second

            lines = @lines[firstBounds.end.line..secondBounds.start.line].join('\n')
            
            infix = lines[firstBounds.end.column...-(@lines[secondBounds.start.line].length - secondBounds.start.column)]

            if infix.indexOf('+') is -1
              return

          @addBlock node, depth, OPERATOR_PRECEDENCES[node.operator], COLORS.VALUE, wrappingParen
          
          @addSocketAndMark node.first, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth

          if node.second?
            @addSocketAndMark node.second, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth
        
        # ### Existence ###
        # Color VALUE, socket @expression, precedence 100
        when 'Existence'
          @addBlock node, depth, 100, COLORS.VALUE, wrappingParen
          @addSocketAndMark node.expression, depth + 1, 101, indentDepth

        # ### In ###
        # Color VALUE, sockets @object and @array, precedence 100
        when 'In'
          @addBlock node, depth, 0, COLORS.VALUE, wrappingParen
          @addSocketAndMark node.object, depth + 1, 0, indentDepth
          @addSocketAndMark node.array, depth + 1, 0, indentDepth
      
        # ### Value ###
        # Completely pass through to @base; we do not care
        # about this node.
        when 'Value'
          @mark node.base, depth + 1, precedence, wrappingParen, indentDepth

        # ### Literal ###
        # No-op. Translate directly to text
        when 'Literal', 'Bool', 'Undefined', 'Null' then 0
        
        # ### Call ###
        # Color COMMAND, sockets @variable and @args.
        # We will not add a socket around @variable when it
        # is only some text
        when 'Call'
          @addBlock node, depth, precedence, COLORS.COMMAND, wrappingParen
        
          if node.variable? and node.variable.base?.nodeType() isnt 'Literal'
            @addSocketAndMark node.variable, depth + 1, 0, indentDepth
          
          for arg in node.args
            @addSocketAndMark arg, depth + 1, 0, indentDepth
        
        # ### Code ###
        # Function definition. Color VALUE, sockets @params,
        # and indent @body.
        when 'Code'
          @addBlock node, depth, precedence, COLORS.VALUE, wrappingParen
          
          for param in node.params
            @addSocketAndMark param, depth + 1, 0, indentDepth
          
          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Assign ###
        # Color COMMAND, sockets @variable and @value.
        when 'Assign'
          @addBlock node, depth, precedence, COLORS.COMMAND, wrappingParen
          @addSocketAndMark node.variable, depth + 1, 0, indentDepth
          @addSocketAndMark node.value, depth + 1, 0, indentDepth
        
        # ### For ###
        # Color CONTROL, options sockets @index, @source, @name, @from.
        # Indent/socket @body.
        when 'For'
          @addBlock node, depth, precedence, COLORS.CONTROL, wrappingParen
          
          for childName in ['index', 'source', 'name', 'from']
            if node[childName]? then @addSocketAndMark node[childName], depth + 1, 0, indentDepth

          @mark node.body, depth + 1, 0, null, indentDepth
        
        # ### Range ###
        # Color VALUE, sockets @from and @to.
        when 'Range'
          @addBlock node, depth, 100, COLORS.VALUE, wrappingParen
          @addSocketAndMark node.from, depth, 0, indentDepth
          @addSocketAndMark node.to, depth, 0, indentDepth

        # ### If ###
        # Color CONTROL, socket @condition.
        # indent/socket body, optional indent/socket node.elseBody.
        #
        # Special case: "unless" keyword; in this case
        # we want to skip the Op that wraps the condition.
        when 'If'
          @addBlock node, depth, precedence, COLORS.CONTROL, wrappingParen
          
          # Check to see if we are an "unless".
          # We will deem that we are an unless if:
          #   - Our starting line contains "unless" and
          #   - Our condition starts at the same location as
          #     ourselves.

          # Note: for now, we have hacked CoffeeScript
          # to give us the raw condition location data.
          #
          # Perhaps in the future we should do this at
          # wrapper level.

          ###
          bounds = @getBounds node
          if @lines[bounds.start.line].indexOf('unless') >= 0 and
              @locationsAreIdentical(bounds.start, @getBounds(node.condition).start) and
              node.condition.nodeType() is 'Op'

            @addSocketAndMark node.condition.first, depth + 1, 0, indentDepth
          else
          ###

          @addSocketAndMark node.rawCondition, depth + 1, 0, indentDepth
          
          @mark node.body, depth + 1, 0, null, indentDepth

          if node.elseBody?
            # Artificially "mark" the line containing the "else"
            # token, so that the following body can be single-line
            # if necessary.
            @hasLineBeenMarked[node.elseToken.first_line] = true

            @mark node.elseBody, depth + 1, 0, null, indentDepth

        # ### Arr ###
        # Color VALUE, sockets @objects.
        when 'Arr'
          @addBlock node, depth, 100, COLORS.VALUE, wrappingParen
          for object in node.objects
            @addSocketAndMark object, depth + 1, 0, indentDepth

        # ### Return ###
        # Color RETURN, optional socket @expression.
        when 'Return'
          @addBlock node, depth, precedence, COLORS.RETURN, wrappingParen
          if node.expression?
            @addSocketAndMark node.expression, depth + 1, 0, indentDepth

        # ### While ###
        # Color CONTROL. Socket @condition, socket/indent @body.
        when 'While'
          @addBlock node, depth, precedence, COLORS.CONTROL, wrappingParen
          @addSocketAndMark node.rawCondition, depth + 1, 0, indentDepth
          if node.guard? then @addSocketAndMark node.guard, depth + 1, 0, indentDepth
          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Switch ###
        # Color CONTROL. Socket @subject, optional sockets @cases[x][0],
        # indent/socket @cases[x][1]. indent/socket @otherwise.
        when 'Switch'
          @addBlock node, depth, 0, COLORS.CONTROL, wrappingParen
          
          @addSocketAndMark node.subject, depth + 1, 0, indentDepth
          
          for switchCase in node.cases
            @addSocketAndMark switchCase[0], depth + 1, 0, indentDepth # (condition)
            @mark switchCase[1], depth + 1, 0, null, indentDepth # (body)

          if node.otherwise?
            @mark node.otherwise, depth + 1, 0, null, indentDepth
        
        # ### Class ###
        # Color CONTROL. Optional sockets @variable, @parent. Optional indent/socket
        # @obdy.
        when 'Class'
          @addBlock node, depth, 0, COLORS.CONTROL, wrappingParen

          if node.variable? then @addSocketAndMark node.variable, depth + 1, 0, indentDepth
          if node.parent? then @addSocketAndMark node.parent, depth + 1, 0, indentDepth

          if node.body? then @mark node.body, depth + 1, 0, null, indentDepth

        # ### Obj ###
        # Color VALUE. Optional sockets @property[x].variable, @property[x].value.
        # TODO: This doesn't quite line up with what we want it to be visually;
        # maybe our View architecture is wrong.
        when 'Obj'
          @addBlock node, depth, 0, COLORS.VALUE, wrappingParen

          for property in node.properties
            if property.nodeType() is 'Assign'
              @addSocketAndMark property.variable, depth + 1, 0, indentDepth
              @addSocketAndMark property.value, depth + 1, 0, indentDepth
            else
              @addSocketAndMark property

    transpile: ->
      # Get the CoffeeScript AST from the text
      nodes = CoffeeScript.nodes(@text).expressions
      
      # Mark all the nodes
      # in the block.
      for node in nodes
        @mark node, 3, 0, null, 0
      
      # Deal with semicoloned lines
      # at the root level
      @wrapSemicolons nodes, 0
      
      # Return the markup.
      return @markup
  
  # Wrap up the things we need to do
  # to package ourselves as an ICE editor parser
  # and export to require.js.
  coffeeScriptParser = new parser.Parser (text) ->
    transpiler = new CoffeeScriptTranspiler text
    return transpiler.transpile()
  
  exports.parse = (text) ->
    return coffeeScriptParser.parse text
  
  return exports
