# A rudimentary CoffeeScript parser for model Editor.
# 
# Created 2014 by Anthony Bau.
# This software is public domain.

define ['ice-model', 'ice-parser'], (model, parser) ->
  colors =
    COMMAND: '#268bd2'
    CONTROL: '#daa520'
    VALUE: '#26cf3c'
    RETURN: '#dc322f'

  exports = {}

  exports.mark = (nodes, text) ->

    id = 1
    rootSegment = new model.Segment()

    text = text.split('\n')

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

    markup = []

    addMarkup = (block, node, wrappingParen) ->
      if wrappingParen
        bounds = getBounds wrappingParen
      else
        bounds = getBounds node

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

      id += 1

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
    
    addBlock = (node, precedence, color, wrappingParen) ->
      block = new model.Block precedence
      block.color = color
      addMarkup block, node, wrappingParen

    mark = (node, precedence = 0, wrappingParen = null) ->
      switch node.constructor.name
        when 'Block'
          indent = new model.Indent 2
          addMarkup indent, node, wrappingParen
          
          # Delegate to children with zero precedence and no paren wrapping
          for expr in node.expressions
            mark expr

        when 'Op'
          addBlock node, operatorPrecedences[node.operator], colors.VALUE, wrappingParen

          mark node.first, operatorPrecedences[node.operator]
          if node.second? then mark node.second, operatorPrecedences[node.operator]

        when 'Existence'
          addBlock node, 7, colors.CONTROL, wrappingParen
          mark node.expression, 7
        
        when 'Value'
          mark node.base, precedence
        
        when 'Literal'
          socket = new model.Socket null, precedence
          addMarkup socket, node, wrappingParen
        
        when 'Call'
          addBlock node, precedence, colors.COMMAND, wrappingParen
          for arg in node.args then mark arg

        when 'Code'
          addBlock node, precedence, colors.VALUE, wrappingParen
          for param in node.params then mark param
          
          # If it is a one-line function,
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            mark node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body

        when 'Param'
          mark node.name

        when 'Assign'
          addBlock node, precedence, colors.COMMAND, wrappingParen
          mark node.variable; mark node.value

        when 'For'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          if node.index? then mark node.index
          if node.source? then mark node.source
          if node.name? then mark node.name
          if node.from? then mark node.from

          # If it is a one-line "for",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            mark node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body

        when 'Range'
          addBlock node, precedence, colors.VALUE, wrappingParen
          mark node.from; mark node.to

        when 'If'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          mark node.condition

          # If it is a one-line "if",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            mark node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body
          
          if node.elseBody?
            # If it is a one-line "else",
            # unwrap the body.
            if getBounds(node.elseBody).end.line is getBounds(node).start.line
              mark node.elseBody.unwrap()

            # Otherwise, do not.
            else
              mark node.elseBody

        when 'Arr'
          addBlock node, precedence, colors.VALUE, wrappingParen
          for object in node.objects then mark object

        when 'Return'
          addBlock node, precedence, colors.RETURN, wrappingParen
          if node.expression? then mark node.expression

        when 'While'
          addBlock node, precedence, colors.CONTROL, wrappingParen
          mark node.condition

          # If it is a one-line "while",
          # unwrap the body.
          if getBounds(node.body).end.line is getBounds(node).start.line
            mark node.body.unwrap()

          # Otherwise, do not.
          else
            mark node.body

        when 'Parens'
          if node.body? then mark node.body.unwrap(), 0, true

        when 'Obj'
          addBlock node, precedence, colors.VALUE, wrappingParen
          
          # We must insert the indent for an object by hand
          start = getBounds node.properties[0]
          end = getBounds node.properties[node.properties.length - 1]
          
          unless end.end.line is start.start.line
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

      if block? and wrappingParen?
        block.currentlyParenWrapped = true

    for node in nodes
      mark node
    
    return markup
  
  parser = new parser.Parser (text) -> exports.mark CoffeeScript.nodes(text).expressions, text

  exports.parse = (text) ->
    return parser.parse text

  return exports
