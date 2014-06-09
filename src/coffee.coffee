# A rudimentary CoffeeScript parser for model Editor.
# 
# Copyright (c) 2014 Anthony Bau.
# MIT License.

define ['ice-model', 'ice-parser', 'coffee-script'], (model, parser, CoffeeScript) ->
  # Sample colour scheme.
  colors =
    COMMAND: '#268bd2'
    CONTROL: '#daa520'
    VALUE: '#26cf3c'
    RETURN: '#dc322f'

  exports = {}

  # Keep a static list of
  # operator precedence for later use.
  #
  # Lower-numbered operations occur last
  # in order of operations.
  operatorPrecedences =
    '||': 1
    '&&': 2
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
  
  # # exports.mark #, indentDepth
  # Take some text and the CoffeeScript AST of it and
  # return an array of markup.
  exports.mark = (nodes, text) ->, indentDepth
    id = 1

    markup = []
    
    # We will work with line-column coordinates,
    # so we want to deal with text lines and not
    # a bunch of characters.
    text = text.split('\n')

    # In order to detect whether a CoffeeScript AST 'Block' node
    # is a single- or double- line block, we must know whether
    # other markup has ben placed on lines. So:
    hasLineBeenMarked = {}

    for line, i in text
      hasLineBeenMarked[i] = false
    
    # ## addMarkup ##
    # A utility function for adding markup to our markup array
    # (with location data, id, and start/end flag).
    addMarkup = (block, node, wrappingParen, depth) ->

      # If the node is wrapped by a parenthesis,
      # we actually want to enclose the parenthesis by the
      # new block and not the node itself.
      if wrappingParen?
        bounds = getBounds wrappingParen
      else
        bounds = getBounds node

      hasLineBeenMarked[bounds.start.line] = true
      
      # Push the start and end tokens to the markup array.
      markup.push
        token: block.start
        location: bounds.start
        depth: depth
        start: true

      markup.push
        token: block.end
        location: bounds.end
        depth: depth
        start: false
    
    # ## getBounds ##
    # Get the wanted visual bounds
    # for a piece of syntax.
    #
    # CoffeeScript locationData is often
    # not exactly what we want, so we have to
    # adjust it here.
    getBounds = (node) ->
      # Defaults simply take
      # CoffeeScript locationData.
      start = {
        line: node.locationData.first_line
        column: node.locationData.first_column
      }

      end = {
        line: node.locationData.last_line
        column: node.locationData.last_column + 1
      }

      # There are a bunch of special cases where
      # CoffeeScript gets location data wrong.
      #
      # The first of these is indents, where CoffeeScript
      # usually only gives one line. We will instead take
      # the last expression inside the block as the ending bound.
      if node.nodeType() is 'Block'
        unless start.line is 0
          start.line -= 1; start.column = text[start.line].length
        end = getBounds(node.expressions[node.expressions.length - 1]).end

      # When CoffeeScript gives an if statement,
      # it only encloses the "if", and not the "else"
      # if it exists. If there is an "else", enclose it too.
      if node.nodeType() is 'If' and node.elseBody?
        end = getBounds(node.elseBody).end

      # CoffeeScript's "while" node location data
      # only encloses the line containing "while".
      # Enclose the body too.
      if node.nodeType() is 'While'
        end = getBounds(node.body).end
      
      # Sometimes CoffeeScript can grant blocks
      # extra spaces at the start of the next line.
      # We don't want those spaces; discard them.
      if text[end.line][...end.column].trim().length is 0
        end.line -= 1; end.column = text[end.line].length

      return {
        start: start
        end: end
      }
    
    # ## addBlock ##
    # A simple utility function for adding a block of a given
    # precedence and color. We do a lot of this in (mark).
    addBlock = (node, depth, precedence, color, wrappingParen) ->
      block = new model.Block precedence, color, (color is colors.VALUE)
      addMarkup block, node, wrappingParen, depth

      if wrappingParen?
        block.currentlyParenWrapped = true
    
    # ## addSocket ##
    # A similar utility function for adding sockets.
    addSocket = (node, depth, precedence) ->
      socket = new model.Socket null, precedence
      addMarkup socket, node, null, depth
    
    # ## markSocket ##
    # Adds a socket and marks its children.
    markSocket = (node, depth, precedence) ->
      addSocket node, depth, precedence

      mark node, depth + 1, precedence, null, indentDepth
    
    # ## dealWithSemicolons ##
    # Go through a list of expressions. If any of them
    # are on the same line, surround them with a semicolon block.
    dealWithSemicolons = (expressions, depth) ->
      start = end = null
      startBounds = endBounds = null

      blocksOnThisLine = []

      for expr in expressions
        if start? and (bounds = getBounds(expr)).start.line is startBounds.end.line
          end = expr
          endBounds = bounds

          blocksOnThisLine.push expr

        else
          # If the line had two or more statements on it, add the semicolon
          # block per se.
          if start? and end?
            block = new model.Block 0, colors.COMMAND, false
            
            markup.push
              token: block.start
              location: startBounds.start
              depth: depth + 1
              start: true
            
            markup.push
              token: block.end
              location: endBounds.end
              depth: depth + 1
              start: false
        
            for block in blocksOnThisLine
              addSocket block, depth + 2, 0
          
          # Start the new line.
          blocksOnThisLine = [start = expr]; startBounds = getBounds expr
          end = endBounds = null

      if start? and end?
        block = new model.Block 0, colors.COMMAND, false

        markup.push
          token: block.start
          location: startBounds.start
          depth: depth + 1
          start: true

        markup.push
          token: block.end
          location: endBounds.end
          depth: depth + 1
          start: false
        
        for block in blocksOnThisLine
          addSocket block, depth + 2, 0
    
    # ## mark ##, indentDepth
    # The core recursive function for adding the markup associated
    # with a parse tree.
    mark = (node, depth, precedence, wrappingParen, indentDepth) ->, indentDepth
      switch node.nodeType()

        # ### Block ###
        # A Block is a group of expressions,
        # which might be surrounded by an indent.
        when 'Block'
          # First check to see if we want to surround with an indent.
          # We will surround with an indent iff if it spans multiple lines.
          bounds = getBounds node
          
          # If it is only one line, add a socket.
          if bounds.start.line is bounds.end.line and hasLineBeenMarked[bounds.start.line]
            addSocket node, depth, 0
          
          # Otherwise, add an indent.
          else
            indent = new model.Indent 2
            addMarkup indent, node, wrappingParen, depth
          
          # Mark all children.
          for expr in node.expressions
            mark expr, depth + 3, 0, null, indentDepth

          # Mark a semicolons if necessary around lines that run together.
          dealWithSemicolons node.expressions, depth
        
        # ### Op ###
        # An Operator is represented
        # by a VALUE color block and has
        # children @first and @second
        when 'Op'
          addBlock node, depth, operatorPrecedences[node.operator], colors.VALUE, wrappingParen

          markSocket node.first, depth + 1, operatorPrecedences[node.operator]
          if node.second? then markSocket node.second, depth + 1, operatorPrecedences[node.operator]
      
        # ### Existence ###
        # The Existence operator works
        # basically like any other operator;
        # it has highest precedence.
        when 'Existence'
          addBlock node, depth, 100, colors.VALUE, wrappingParen
          markSocket node.expression, depth + 1, 101
        
        # ### In ###
        # The In operator has precedence
        # equivalent to a function call.
        when 'In'
          addBlock node, depth, 0, colors.VALUE, wrappingParen

          markSocket node.object, depth + 1, 0
          markSocket node.array, depth + 1, 0
        
        # ### Value ####
        # A Value is not of much use to the ICE
        # Editor; it signifies nothing visual.
        # We pass along to its children
        when 'Value'
          mark node.base, depth + 1, precedence, wrappingParen, indentDepth
        
        # ### Literal ###
        # Pass for literals.
        when 'Literal', 'Bool', 'Undefined', 'Null'
          0
        
        # ### Call ###
        # Call blocks are blue and
        # have lowest precedence.
        when 'Call'
          addBlock node, depth, precedence, colors.COMMAND, wrappingParen
          
          # If the variable name is parseable beyond
          # just some text, parse it. Otherwise, 
          # don't even put a text socket in.
          unless node.variable.base?.nodeType() is 'Literal'
            markSocket node.variable, depth + 1, 0

          for arg in node.args then markSocket arg, depth + 1, 0
        
        # ### Code ###
        # Code is a function definition.
        # There are two cases here, because
        # functions can be one-line or indented.
        when 'Code'
          addBlock node, depth, precedence, colors.VALUE, wrappingParen
          for param in node.params then markSocket param, depth + 1, 0
          
          # If it is a one-line function,
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            markSocket node.body.unwrap(), depth + 1, 0

          # Otherwise, do not.
          else
            mark node.body, depth + 1, 0, null, indentDepth
        
        # ### Param ###
        # A part of Code; it will
        # consist of 'Literal',
        # which is what we want.
        when 'Param'
          mark node.name, depth + 1, 0, null, indentDepth
        
        # ### Assign ###
        # Assign blocks actually cover two cases --
        # object literal a:b and variable a=b.
        # This is probably because in CoffeeScript
        # a:b could be in a class definition and be translated
        # to a=b.
        #
        # In the future we may want to render these two cases differently,
        # but for now both are blue and have equal precedence.
        when 'Assign'
          addBlock node, depth, precedence, colors.COMMAND, wrappingParen
          markSocket node.variable, depth + 1, 0; markSocket node.value, depth + 1, 0
        
        # ### For ###
        # A for block has a lot of optional arguments.
        when 'For'
          addBlock node, depth, precedence, colors.CONTROL, wrappingParen
          if node.index? then markSocket node.index, depth + 1, 0
          if node.source? then markSocket node.source, depth + 1, 0
          if node.name? then markSocket node.name, depth + 1, 0
          if node.from? then markSocket node.from, depth + 1, 0

          # If it is a one-line "for",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            markSocket node.body.unwrap(), depth + 1, 0

          # Otherwise, do not.
          else
            mark node.body, depth + 1, 0, null, indentDepth
        
        # ### Range ###
        # A Range has two children and is rendered VALUE.
        # Nothing particularly interesting.
        when 'Range'
          addBlock node, depth, 100, colors.VALUE, wrappingParen
          markSocket node.from, depth, 0; markSocket node.to, depth + 1, 0
        
        # ### If ###
        # An If consists of two separate
        # Blocks (possibly), each of which might either be
        # an indent or a one-line.
        when 'If'
          addBlock node, depth, precedence, colors.CONTROL, wrappingParen
          markSocket node.condition, depth + 1, 0

          mark node.body, depth + 1, 0, null, indentDepth
          
          if node.elseBody?
            mark node.elseBody, depth + 1, 0, null, indentDepth
        
        # ### Arr ###
        # An Array has a bunch of elements. Mark all of them and
        # render the block VALUE.
        #
        # In the future, we may want to put a mutation button here
        # for adding more elements.
        when 'Arr'
          addBlock node, depth, 100, colors.VALUE, wrappingParen
          for object in node.objects then mark object, depth + 1, 0, null, indentDepth
        
        # ### Return ###
        # A return is the only block other than 'break' rendered RETURN.
        when 'Return'
          addBlock node, depth, precedence, colors.RETURN, wrappingParen
          if node.expression? then markSocket node.expression, depth + 1, 0
        
        # ### While ###
        when 'While'
          addBlock node, depth, precedence, colors.CONTROL, wrappingParen
          markSocket node.condition, depth + 1, 0

          # If it is a one-line "while",
          # unwrap the body.
          mark node.body, depth + 1, 0, null, indentDepth
        
        # ### Parens ###
        # Parens are special because they are delegated to the
        # expression they contain. They have no block rendering;
        # we will simply signify to the child node that it must wrap
        # itself in these parentheses.
        when 'Parens'
          if node.body? then mark node.body.unwrap(), depth + 1, 0, node, indentDepth
        
        # ### Obj ###
        # Objects can be one-line or multiline,
        # and can be surrounded in braces or not.
        # They are rendered VALUE and contain Assign blocks;
        # we may want to change this behaviour in the future.
        #
        # TODO: This is unfinished.
        when 'Obj'
          addBlock node, depth, 0, colors.VALUE, wrappingParen
          
          # We must insert the indent for an object by hand.
          # Get the needed bounds for this indent.
          if node.properties.length is 0
            end = start = getBounds node
          else
            start = getBounds node.properties[0]
            end = getBounds node.properties[node.properties.length - 1]
          
          # If the indent is actually on the same line
          # as the object literal's beginning,
          # we do not want to render it as an indent,
          # but rather as a one-line object.
          unless end.end.line is start.start.line
            # If we do want to render it as an indent,
            # insert the indent.
            #
            # We have to do some messy work here by hand,
            # since this is the only place we do this
            # and we have no utility function.
            indent = new model.Indent 2

            markup.push
              token: indent.start
              location: {
                line: start.start.line - 1
                column: text[start.start.line - 1].length
              }
              depth: depth
              start: true

            markup.push
              token: indent.end
              location: end.end
              depth: depth
              start: false

            for property in node.properties then mark property, depth + 1, 0, null, indentDepth
          else
            for property in node.properties then markSocket property, depth + 1, 0

        when 'Switch'
          addBlock node, depth, 0, colors.CONTROL, wrappingParen

          markSocket node.subject, depth + 1, 0

          for switchCase in node.cases
            markSocket switchCase[0], depth + 1, 0
            mark switchCase[1], depth + 1, 0, indentDepth
    
          if node.otherwise? then mark node.otherwise, depth + 1, 0, indentDepth

    # We do not mark the root expression,, indentDepth
    # but rather every child of it.
    for node in nodes
      mark node, 3, 0, null, 0
    
    dealWithSemicolons nodes, 0
    
    return markup
  
  # Package ourself as an ICE editor parser.
  parser = new parser.Parser (text) -> exports.mark CoffeeScript.nodes(text).expressions, text
  
  # Export to requirejs.
  exports.parse = (text) ->
    return parser.parse text

  return exports
