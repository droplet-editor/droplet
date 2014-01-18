# Theme: Primaria
colors =
  COMMAND: '#37f'
  CONTROL: '#fb5'
  VALUE: '#3f7'
  RETURN: '#f03'

###
# Theme: Exoniana
colors =
  COMMAND: '#c33'
  CONTROL: '#DAA520'
  VALUE: '#f00'
  RETURN: '#fff'
###

exports = {}

exports.mark = (node, text) ->

  id = 0
  markup = []

  text = text.split('\n')

  addMarkup = (block, node) ->
    #console.log block.type, id

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
    #console.log node.constructor.name
    switch node.constructor.name
      when 'Block'
        start = node.locationData
        end = getBounds(node.expressions[node.expressions.length - 1]).end

        return {
          start: [start.first_line - 1, -1]
          end: end
        }

      when 'If'
        if node.elseBody?
          end = getBounds(node.elseBody).end
        else
          end = [node.locationData.last_line, node.locationData.last_column + 1]
      
        if text[end[0]][...end[1]].trimLeft().length is 0
          end[1] = -1; end[0]-= 1

        return {
          start: [node.locationData.first_line, node.locationData.first_column]
          end: end
        }

      else
        end = [node.locationData.last_line, node.locationData.last_column + 1]

        if text[end[0]][...end[1]].trimLeft().length is 0
          end[1] = -1; end[0]-= 1

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

        mark node.body

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
    #debugString = '' #DEBUG

    # Append the newline token
    head = head.append new ICE.NewlineToken()
    
    # Insert necessary markup on this line
    lastMark = 0
    if marks[i]?

      marks[i].sort (a, b) ->
        if a.position[1] < 0 then 1
        else if b.position[1] < 0 then -1
        else unless a.position[1] is b.position[1] then a.position[1] - b.position[1]
        else if a.start and b.start then a.id - b.id
        else if (not a.start) and (not b.start) then b.id - a.id
        else if a.start then 1
        else -1

      for _mark in marks[i]
        if _mark.position[1] < 0 then _mark.position[1] = line.length

        str = line[lastMark..._mark.position[1]]
        if lastMark is 0 then str = str.trimLeft()

        unless str.length is 0
          head = head.append new ICE.TextToken str
          #debugString += str #DEBUG
        
        if stack.length > 0 and stack[stack.length-1].block.type is 'block' and _mark.token.type is 'blockStart'
          #debugString += "<socketStart (implied)>" #DEBUG
          stack.push block: (_socket = new ICE.Socket()), implied: true
          head = head.append _socket.start

        switch _mark.token.type
          when 'blockStart' then stack.push block: _mark.token.block
          when 'socketStart' then stack.push block: _mark.token.socket
          when 'indentStart' then stack.push block: _mark.token.indent
          when 'blockEnd', 'socketEnd', 'indentEnd' then stack.pop()

        head = head.append _mark.token
        #debugString += '<' + _mark.token.type + ' ' + _mark.id + '>' #DEBUG

        if stack.length > 0 and stack[stack.length - 1].implied?
          head = head.append stack.pop().block.end
          #debugString += '<socketEnd (implied)>' #DEBUG

        lastMark = _mark.position[1]

    # Insert the last string on this line.
    unless lastMark > line.length - 1
      head = head.append new ICE.TextToken line[lastMark..-1]
      #debugString += line[lastMark..-1] #DEBUG

    #console.log #debugString #DEBUG

  return first.next.next

exports.parse = parse = (text) ->
  markup = exports.mark CoffeeScript.nodes(text).expressions[0], text
  return execute text, markup

window.coffee = exports
