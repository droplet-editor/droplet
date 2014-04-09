# # Parser.coffee
#
# Utility functions for defining ICE editor parsers.
#
# Copyright (c) 2014 Anthony Bau
# MIT License.

define ['ice-model'], (model) ->
  exports = {}
  
  # ## sortMarkup ##
  # Sort the markup by the order
  # in which it will appear in the text.
  sortMarkup = (unsortedMarkup) ->

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
  
  # ## applyMarkup ##
  # Given some text and (sorted) markup,
  # produce an ICE editor document
  # with the markup inserted into the text.
  #
  # Automatically insert sockets around blocks along the way.

  applyMarkup = (text, sortedMarkup) ->
    # For convenience, will we
    # separate the markup by the line on which it is placed.
    markupOnLines = {}

    for mark in sortedMarkup
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
      if not (i of markupOnLines)
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
              # An Indent is only allowed to be
              # directly inside a block; if not, then throw.
              unless stack?[stack.length - 1]?.type is 'block'
                throw new Error 'Improper parser: indent must be inside block, but is inside ' + stack?[stack.length - 1]?.type
              
              # Update stack and indent depth
              stack.push mark.token.indent
              indentDepth += mark.token.indent.depth
              
              # Append the token itself.
              head = head.append mark.token
            
            when 'blockStart'
              # If the a block is embedded
              # directly in another block, we should
              # insert a socket around it automatically.
              if stack[stack.length - 1]?.type is 'block'
                # Push the socket to the autoinsertedStack,
                # so that we know to close it later.
                autoinsertStack.push mark.token.block
                autoinsertedSocket = new model.Socket()
                
                # Append the socket start.
                head = head.append autoinsertedSocket.start
                
                # Push it to the stack,
                # so that we can close it later.
                stack.push autoinsertedSocket
              
              # Update the stack
              stack.push mark.token.block
              
              # Push the token itself.
              head = head.append mark.token

            when 'socketStart'
              # A socket is only allowed to be directly inside a block.
              # Currently, our behaviour will be to auto-repair it in
              # some cases, but this
              # might need to be changed in the future.
              #
              # We will auto-repair if it is inside an indent,
              # otherwise we will throw
              unless stack[stack.length - 1]?.type is 'block'
                if stack.length is 0
                  throw new Error 'Improper parser: document root cannot be a socket.'
                else if stack[stack.length - 1].type is 'indent'
                  autoinsertStack.push mark.token.socket

                  autoinsertedBlock = new model.Block()

                  head = head.append autoinsertedBlock.start

                  stack.push autoinsertedBlock

              # Update the stack and append the token.
              stack.push mark.token.socket

              head = head.append mark.token
            
            # For each End token,
            # we make sure that it is properly closing
            # its corresponding Start token; if it is not,
            # we throw.
            when 'indentEnd'
              unless mark.token.indent is stack[stack.length - 1]
                throw new Error 'Improper parser: indent ended too early.'
              
              # Update stack and indent depth
              stack.pop()
              indentDepth -= mark.token.indent.depth

              head = head.append mark.token

            when 'blockEnd'
              unless mark.token.block is stack[stack.length - 1]
                throw new Error 'Improper parser: block ended too early.'
              
              # Update stack
              stack.pop()

              head = head.append mark.token
              
              # If we need to close an autoinserted socket,
              # close it.
              if mark.token.block is autoinsertStack[autoinsertStack.length - 1]
                autoinsertStack.pop()
                head = head.append stack.pop().end

            when 'socketEnd'
              unless mark.token.socket is stack[stack.length - 1]
                throw new Error 'Improper parser: socket ended too early.'

              # Update stack
              stack.pop()

              head = head.append mark.token

              if mark.token.socket is autoinsertStack[autoinsertStack.length - 1]
                autoinsertStack.pop()
                head = head.append stack.pop().end

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
  
  # ## stringifyMarkup ##
  # A utility function for printing out produced markup.
  # Used for debugging only.
  stringifyMarkup = (markup) ->
    str = '0: '
    lastLine = 0
    for mark in markup
      if mark.location.line isnt lastLine
        str += '\n' + mark.location.line + ': '
        lastLine = mark.location.line
      str += '<' + mark.token.type + '_' + mark.id + '>'
    return str
  
  # ## Parser ##
  # The Parser class is a simple
  # wrapper on the above functions
  # and a given parser function.
  exports.Parser = class Parser
    constructor: (@parseFn) ->
    
    parse: (text, verify = true) ->
      markup = @parseFn text
      sortMarkup markup
      return applyMarkup text, markup

  exports.parseObj = parseObj = (object) ->
    unless object?
      return null
    
    if typeof object is 'string' or object instanceof String
      if object is '\n'
        return new model.NewlineToken()
      else
        return new model.TextToken object
    
    else
      switch object.type
        when 'block'
          block = new model.Block object.precedence, object.color, object.valueByDefault
          head = block.start
          for child in object.children
            subBlock = parseObj child
            if subBlock.type in ['text', 'newline', 'mutationButton']
              head = head.append subBlock
            else
              head.append subBlock.start
              head = subBlock.end

          head.append block.end

          return block

        when 'socket'
          return new model.Socket parseObj(object.contents), object.precedence
        
        when 'indent'
          block = new model.Indent object.depth

          head = block.start

          for child in object.children
            subBlock = parseObj child
            if subBlock.type in ['text', 'newline']
              head = head.append subBlock
            else
              head.append subBlock.start
              head = subBlock.end

          head.append block.end

          return block
        
        when 'mutationButton'
          segment = new model.Segment()

          button = new model.MutationButtonToken segment

          head = segment.start
          for child in object.expand
            if child is 0
              subBlock = button
            else
              subBlock = parseObj child

            if subBlock.type in ['text', 'newline', 'mutationButton']
              head = head.append subBlock
            else
              head.append subBlock.start
              head = subBlock.end

          head.append segment.end

          return button


  return exports
