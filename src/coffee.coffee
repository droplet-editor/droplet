# A rudimentary CoffeeScript parser for model Editor.
# 
# Copyright (c) 2014 Anthony Bau.
# MIT License.

define ['ice-model', 'ice-parser'], (model, parser) ->
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
  
  # # exports.mark #
  # Take some text and the CoffeeScript AST of it and
  # return an array of markup.
  exports.mark = (nodes, text) ->
    id = 1

    markup = []
    
    # We will work with line-column coordinates,
    # so we want to deal with text lines and not
    # a bunch of characters.
    text = text.split('\n')
    
    # ## addMarkup ##
    # A utility function for adding markup to our markup array
    # (with location data, id, and start/end flag).
    addMarkup = (block, node, wrappingParen) ->

      # If the node is wrapped by a parenthesis,
      # we actually want to enclose the parenthesis by the
      # new block and not the node itself.
      if wrappingParen?
        bounds = getBounds wrappingParen
      else
        bounds = getBounds node
      
      # Push the start and end tokens to the markup array.
      markup.push
        token: block.start
        location: bounds.start
        id: id
        start: true

      markup.push
        token: block.end
        location: bounds.end
        id: id
        start: false
      
      # Increment the ID.
      id += 1
    
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
      if node.constructor.name is 'Block'
        unless start.line is 0
          start.line -= 1; start.column = text[start.line].length
        end = getBounds(node.expressions[node.expressions.length - 1]).end

      # When CoffeeScript gives an if statement,
      # it only encloses the "if", and not the "else"
      # if it exists. If there is an "else", enclose it too.
      if node.constructor.name is 'If' and node.elseBody?
        end = getBounds(node.elseBody).end

      # CoffeeScript's "while" node location data
      # only encloses the line containing "while".
      # Enclose the body too.
      if node.constructor.name is 'While'
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
    addBlock = (node, precedence, color, wrappingParen) ->
      block = new model.Block precedence, color, (color is colors.VALUE)
      addMarkup block, node, wrappingParen

      if wrappingParen?
        block.currentlyParenWrapped = true

    addSocket = (node, precedence = 0, wrappingParen = null) ->
      socket = new model.Socket null, precedence
      addMarkup socket, node, wrappingParen

      mark node
    
    # ## mark ##
    # The core recursive function for adding the markup associated
    # with a parse tree.
    mark = (node, precedence = 0, wrappingParen = null) ->
      switch node.constructor.name

        # ### Block ###
        # A Block is an indented bit of code,
        # so we will surround it with an Indent.
        when 'Block'
          indent = new model.Indent 2
          addMarkup indent, node, wrappingParen

          for expr in node.expressions
            mark expr
        
        # ### Op ###
        # An Operator is represented
        # by a VALUE color block and has
        # children @first and @second
        when 'Op'
          addBlock node, operatorPrecedences[node.operator], colors.VALUE, wrappingParen

          addSocket node.first, operatorPrecedences[node.operator]
          if node.second? then addSocket node.second, operatorPrecedences[node.operator]
      
        # ### Existence ###
        # The Existence operator works
        # basically like any other operator;
        # it has highest precedence.
        when 'Existence'
          addBlock node, 7, colors.VALUE, wrappingParen
          addSocket node.expression, 7
        
        # ### In ###
        # The In operator has precedence
        # equivalent to a function call.
        when 'In'
          addBlock node, 0, colors.VALUE, wrappingParen

          addSocket node.object, 0
          addSocket node.array, 0
        
        # ### Value ####
        # A Value is not of much use to the ICE
        # Editor; it signifies nothing visual.
        # We pass along to its children
        when 'Value'
          mark node.base, precedence
        
        # ### Literal ###
        # Pass for literals.
        when 'Literal', 'Bool', 'Undefined', 'Null'
          0
        
        # ### Call ###
        # Call blocks are blue and
        # have lowest precedence.
        when 'Call'
          addBlock node, precedence, colors.COMMAND, wrappingParen
          
          # If the variable name is parseable beyond
          # just some text, parse it. Otherwise, 
          # don't even put a text socket in.
          unless node.variable.base?.constructor.name is 'Literal'
            addSocket node.variable

          for arg in node.args then addSocket arg
        
        # ### Code ###
        # Code is a function definition.
        # There are two cases here, because
        # functions can be one-line or indented.
        when 'Code'
          addBlock node, precedence, colors.VALUE, wrappingParen
          for param in node.params then addSocket param
          
          # If it is a one-line function,
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            addSocket node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body
        
        # ### Param ###
        # A part of Code; it will
        # consist of 'Literal',
        # which is what we want.
        when 'Param'
          mark node.name
        
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
          addBlock node, precedence, colors.COMMAND, wrappingParen
          addSocket node.variable; addSocket node.value
        
        # ### For ###
        # A for block has a lot of optional arguments.
        when 'For'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          if node.index? then addSocket node.index
          if node.source? then addSocket node.source
          if node.name? then addSocket node.name
          if node.from? then addSocket node.from

          # If it is a one-line "for",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            addSocket node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body
        
        # ### Range ###
        # A Range has two children and is rendered VALUE.
        # Nothing particularly interesting.
        when 'Range'
          addBlock node, precedence, colors.VALUE, wrappingParen
          addSocket node.from; addSocket node.to
        
        # ### If ###
        # An If consists of two separate
        # Blocks (possibly), each of which might either be
        # an indent or a one-line.
        when 'If'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          addSocket node.condition

          # If it is a one-line "if",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            addSocket node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body
          
          if node.elseBody?
            # If it is a one-line "else",
            # unwrap the body.
            if getBounds(node.elseBody).end.line is getBounds(node).start.line
              addSocket node.elseBody.unwrap()

            # Otherwise, do not.
            else
              mark node.elseBody
        
        # ### Arr ###
        # An Array has a bunch of elements. Mark all of them and
        # render the block VALUE.
        #
        # In the future, we may want to put a mutation button here
        # for adding more elements.
        when 'Arr'
          addBlock node, precedence, colors.VALUE, wrappingParen
          for object in node.objects then mark object
        
        # ### Return ###
        # A return is the only block other than 'break' rendered RETURN.
        when 'Return'
          addBlock node, precedence, colors.RETURN, wrappingParen
          if node.expression? then addSocket node.expression
        
        # ### While ###
        when 'While'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          addSocket node.condition

          # If it is a one-line "while",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            mark node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body
        
        # ### Parens ###
        # Parens are special because they are delegated to the
        # expression they contain. They have no block rendering;
        # we will simply signify to the child node that it must wrap
        # itself in these parentheses.
        when 'Parens'
          if node.body? then addSocket node.body.unwrap(), 0, node
        
        # ### Obj ###
        # Objects can be one-line or multiline,
        # and can be surrounded in braces or not.
        # They are rendered VALUE and contain Assign blocks;
        # we may want to change this behaviour in the future.
        when 'Obj'
          addBlock node, precedence, colors.VALUE, wrappingParen
          
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
                line: start.start.line-1
                column: text[start.start.line-1].length
              }
              id: id
              start: true

            markup.push
              token: indent.end
              location: end.end
              id: id
              start: false

            id += 1
          
            for property in node.properties then mark property
          else
            for property in node.properties then addSocket property
    
    # We do not mark the root expression,
    # but rather every child of it.
    for node in nodes
      mark node
    
    return markup
  
  # Package ourself as an ICE editor parser.
  parser = new parser.Parser (text) -> exports.mark CoffeeScript.nodes(text).expressions, text
  
  # Export to requirejs.
  exports.parse = (text) ->
    return parser.parse text

  return exports
