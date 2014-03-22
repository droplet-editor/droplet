define ['ice-model'], (model) ->
  exports = {}

  sortMarkup = (unsortedMarkup) ->
    # Sort the markup by the order
    # in which it appears in the text.

    unsortedMarkup.sort (a, b) ->
      # First by line
      if a.location.line > b.location.line
        return 1
      
      if b.location.line > a.location.line
        return -1
      
      # Then by column
      if a.location.column > b.location.column
        return 1
      
      if b.location.column > a.location.column
        return -1
      
      # If two pieces of markup are in the same position, end markup
      # comes before start markup
      if a.start and not b.start
        return 1

      if b.start and not a.start
        return -1
      
      # If two pieces of markup are in the same position, and are both start or end,
      # the markup placed earlier gets to go on the outside
      if a.start and b.start
        if a.id > b.id
          return 1
        else return -1

      if (not a.start) and (not b.start)
        if a.id > b.id
          return -1
        else return 1
    
    # Return the sorted array
    # (although the sorting was done
    # in-place at a pointer, so this
    # is usually unecessary)
    return unsortedMarkup
  
  applyMarkup = (text, sortedVerifiedMarkup) ->
    # For convenience, will we
    # separate the markup by the line on which it is placed.
    markupOnLines = {}

    for mark in sortedVerifiedMarkup
      markupOnLines[mark.location.line] ?= []
      markupOnLines[mark.location.line].push mark
    
    # Now, we will interact with the text
    # by line-column coordinates. So we first want
    # to split the text into lines.
    lines = text.split '\n'
    
    # Now iterate through the lines and apply the necessary markup.
    #
    # We need to keep track of indent depth in order to know
    # how many spaces to discard at the beginning of the line.
    indentDepth = 0

    # We will also need to keep track of the element stack,
    # so we know whether or not to autoinsert a socket around
    # a block. We will also report errors this way.
    stack = []

    # The autoinsert stack contains all the blocks
    # around which we autoinserted a socket. A block will know
    # to append the SocketEnd token after its BlockEndToken
    # if it is the last element of this stack.
    autoinsertStack = []

    # Begin our linked list
    document = new model.Segment()
    head = document.start

    for line, i in lines
      # If there is no markup on this line,
      # simply append the text of this line to the document
      # (stripping things as needed for indent)
      if not i of markupOnLines
        unless indentDepth >= line.length
          head = head.append new model.TextToken(line[indentDepth...])
        head = head.append new model.NewlineToken()
      
      # If there is markup on this line, insert it.
      else
        lastIndex = indentDepth
        for mark in markupOnLines[i]
          # Insert a text token for all the text up until this markup
          # (unless there is no such text
          unless lastIndex >= mark.location.column or lastIndex >= line.length
            head = head.append new model.TextToken(line[lastIndex...mark.location.column])

          # Note, if we have inserted something,
          # the new indent depth and the new stack.
          switch mark.token.type
            when 'indentStart'
              unless stack?[stack.length - 1]?.type is 'block'
                throw new Error 'Improper parser: indent must be inside block, but is inside ' + stack?[stack.length - 1]?.type
              
              stack.push mark.token.indent
              indentDepth += mark.token.indent.depth

              head = head.append mark.token

            when 'blockStart'
              if stack?[stack.length - 1]?.type is 'block'
                autoinsertStack.push mark.token.block
                autoinsertedSocket = new model.Socket()

                head = head.append autoinsertedSocket.start

                stack.push autoinsertedSocket
              
              stack.push mark.token.block
              
              head = head.append mark.token

            when 'socketStart'
              stack.push mark.token.socket

              head = head.append mark.token

            when 'indentEnd'
              unless mark.token.indent is stack?[stack.length - 1]
                throw new Error 'Improper parser: indent ended too early.'
              
              stack.pop()
              indentDepth -= mark.token.indent.depth

              head = head.append mark.token

            when 'blockEnd'
              unless mark.token.block is stack?[stack.length - 1]
                throw new Error 'Improper parser: block ended too early.'
              
              stack.pop()

              head = head.append mark.token

              if mark.token.block is autoinsertStack?[autoinsertStack.length - 1]
                autoinsertStack.pop()
                head = head.append stack.pop().end

            when 'socketEnd'
              unless mark.token.socket is stack[stack.length - 1]
                throw new Error 'Improper parser: socket ended too early.'
              
              stack.pop()

              head = head.append mark.token

          lastIndex = mark.location.column
      
        # Append the rest of the string
        # (after the last piece of markup)
        unless lastIndex >= line.length
          head = head.append new model.TextToken(line[lastIndex...line.length])

        # Append the needed newline token
        head = head.append new model.NewlineToken()
    
    # Pop off the last newline token, which is not necessary
    head = head.prev
    head.next.remove()

    # Reinsert the end token of the document,
    # which we previously threw away by using "append"
    head = head.append document.end

    # Return the document
    return document
  
  stringifyMarkup = (markup) ->
    str = '0: '
    lastLine = 0
    for mark in markup
      if mark.location.line isnt lastLine
        str += '\n' + mark.location.line + ': '
        lastLine = mark.location.line
      str += '<' + mark.token.type + '_' + mark.id + '>'
    return str
  
  # The Parser class is a simple
  # wrapper on the above functions
  # and a given parser function.
  exports.Parser = class Parser
    constructor: (@parseFn) ->
    
    parse: (text, verify = true) ->
      markup = @parseFn text
      sortMarkup markup
      return applyMarkup text, markup

  return exports
