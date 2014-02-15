# A rudimentary CoffeeScript parser for ICE Editor.
# 
# Created 2014 by Anthony Bau.
# This software is public domain.

colors =
  COMMAND: '#268bd2'
  CONTROL: '#daa520'
  VALUE: '#26cf3c'
  RETURN: '#dc322f'

exports = {}

exports.mark = (nodes, text) ->

  id = 1
  rootSegment = new ICE.Segment []

  text = text.split('\n')

  markup = [
    {
      token: rootSegment.start
      position: [0, 0]
      id: 0
      start: true
    }
    {
      token: rootSegment.end
      position: [text.length - 1, text[text.length - 1].length+1]
      id: 0
      start: false
    }
  ]

  addMarkup = (block, node) ->
    bounds = getBounds node

    markup.push
      token: block.start
      position: bounds.start
      id: id
      start: true

    markup.push
      token: block.end
      position: bounds.end
      id: id
      start: false

    id += 1

  getBounds = (node) ->
    switch node.constructor.name
      when 'Block'
        start = node.locationData
        end = getBounds(node.expressions[node.expressions.length - 1]).end

        return {
          start: [start.first_line - 1, text[start.first_line - 1].length]
          end: end
        }

      when 'If'
        if node.elseBody?
          end = getBounds(node.elseBody).end
        else
          end = [node.locationData.last_line, node.locationData.last_column + 1]
      
        if text[end[0]][...end[1]].trimLeft().length is 0
          end[0] -= 1; end[1] = text[end[0]].length

        return {
          start: [node.locationData.first_line, node.locationData.first_column]
          end: end
        }

      else
        end = [node.locationData.last_line, node.locationData.last_column + 1]

        if text[end[0]][...end[1]].trimLeft().length is 0
          end[0] -= 1; end[1] = text[end[0]].length

        return {
          start: [node.locationData.first_line, node.locationData.first_column]
          end: end
        }

  mark = (node) ->
    switch node.constructor.name
      when 'Block'
        indent = new ICE.Indent [], 2
        addMarkup indent, node

        for expr in node.expressions
          mark expr

      when 'Op'
        block = new ICE.Block []
        block.color=colors.VALUE
        addMarkup block, node

        mark node.first
        if node.second? then mark node.second
      
      when 'Value'
        mark node.base
      
      when 'Literal'
        socket = new ICE.Socket()
        addMarkup socket, node
      
      when 'Call'
        block = new ICE.Block []
        block.color=colors.COMMAND
        addMarkup block, node

        for arg in node.args
          mark arg

      when 'Code'
        block = new ICE.Block []
        block.color = colors.VALUE
        addMarkup block, node

        for param in node.params
          mark param

        mark node.body.unwrap()

      when 'Param'
        mark node.name

      when 'Assign'
        block = new ICE.Block []
        block.color = colors.COMMAND
        addMarkup block, node

        mark node.variable
        mark node.value

      when 'For'
        block = new ICE.Block []
        block.color = colors.CONTROL
        addMarkup block, node

        if node.index? then mark node.index
        if node.source? then mark node.source
        if node.name? then mark node.name
        if node.from? then mark node.from

        mark node.body

      when 'Range'
        block = new ICE.Block []
        block.color = colors.VALUE
        addMarkup block, node
        
        mark node.from
        mark node.to

      when 'If'
        block = new ICE.Block []
        block.color = colors.CONTROL
        addMarkup block, node

        mark node.condition
        mark node.body
        if node.elseBody? then mark node.elseBody

      when 'Arr'
        block = new ICE.Block []
        block.color = colors.VALUE
        addMarkup block, node
        
        for object in node.objects
          mark object

      when 'Return'
        block = new ICE.Block []
        block.color = colors.RETURN
        addMarkup block, node

        if node.expression? then mark node.expression

      when 'Parens'
        block = new ICE.Block []
        block.color = colors.VALUE
        addMarkup block, node

        if node.body? then mark node.body.unwrap()

      when 'Obj'
        block = new ICE.Block []
        block.color = colors.VALUE
        addMarkup block, node

        start = getBounds node.properties[0]
        end = getBounds node.properties[node.properties.length - 1]

        indent = new ICE.Indent []

        markup.push
          token: indent.start
          position: start.start
          id: id
          start: true

        markup.push
          token: indent.end
          position: end.end
          id: id
          start: false

        id += 1

        for property in node.properties then mark property


  for node in nodes
    mark node
  
  return markup

exports.execute = execute = (text, markup) ->
  id = 0

  # Sort markup by position in the text
  marks = {}

  for _mark in markup
    # Record the markup on each line
    unless marks[_mark.position[0]]? then marks[_mark.position[0]] = []
    marks[_mark.position[0]].push _mark

  # Run through each line and construct the linked list
  text = text.split '\n'
  first = head = new ICE.TextToken ''
  
  stack = []

  for line, i in text
    # Append the newline token
    head = head.append new ICE.NewlineToken()

    if line.trimLeft().length is 0
      newBlock = new ICE.Block []; newSocket = new ICE.Socket []
      newSocket.handwritten = true

      newBlock.start.insert newSocket.start
      newBlock.end.insertBefore newSocket.end

      head.append newBlock.start
      head = newBlock.end
      continue
    
    # Insert necessary markup on this line
    lastMark = 0
    if marks[i]?

      marks[i].sort (a, b) ->
        unless a.position[1] is b.position[1]
          if a.position[1] > b.position[1] then 1 else -1
        else if a.start and b.start
          if a.id > b.id then 1 else -1
        else if (not a.start) and (not b.start)
          if b.id > a.id then 1 else -1
        else
          if a.start and (not b.start) then 1
          else -1

      for _mark in marks[i]
        str = line[lastMark..._mark.position[1]]
        if lastMark is 0 then str = str.trimLeft()

        unless str.length is 0
          head = head.append new ICE.TextToken str
        
        if stack.length > 0 and stack[stack.length-1].block.type is 'block' and _mark.token.type is 'blockStart'
          stack.push block: (_socket = new ICE.Socket()), implied: true
          head = head.append _socket.start

        switch _mark.token.type
          when 'blockStart' then stack.push block: _mark.token.block
          when 'socketStart' then stack.push block: _mark.token.socket
          when 'indentStart' then stack.push block: _mark.token.indent
          when 'blockEnd', 'socketEnd', 'indentEnd' then stack.pop()

        head = head.append _mark.token

        if stack.length > 0 and stack[stack.length - 1].implied?
          head = head.append stack.pop().block.end

        lastMark = _mark.position[1]

    # Insert the last string on this line.
    unless lastMark > line.length - 1
      head = head.append new ICE.TextToken line[lastMark..-1]

  first = first.next.next
  first.prev = null
  return first

exports.parse = parse = (text) ->
  markup = exports.mark CoffeeScript.nodes(text).expressions, text
  return execute text, markup

window.coffee = exports
