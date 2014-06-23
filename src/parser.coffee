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
        if a.depth > b.depth
          return 1
        else return -1

      if (not a.start) and (not b.start)
        if a.depth > b.depth
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

  applyMarkup = (text, sortedMarkup, opts) ->
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
    # to report errors.
    stack = []

    # Begin our linked list
    document = new model.Segment()
    head = document.start

    for line, i in lines
      # If there is no markup on this line,
      # simply append the text of this line to the document
      # (stripping things as needed for indent)
      if not (i of markupOnLines)
        # If this line is not properly indented,
        # flag it in the model.
        if indentDepth >= line.length or line[..indentDepth].trim().length > 0
          head.specialIndent = (' ' for [0...line.length - line.trimLeft().length]).join ''
          line = line.trimLeft()
        else
          line = line[indentDepth...]
        
        # If we have some text here that
        # is floating (not surrounded by a block),
        # wrap it in a generic block automatically.
        if line.length > 0
          if (opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent'
            block = new model.Block 0, '#ffffff', false

            head = head.append block.start
            head = head.append new model.TextToken line
            head = head.append block.end

          else
            head = head.append new model.TextToken line

        head = head.append new model.NewlineToken()
      
      # If there is markup on this line, insert it.
      else
        lastIndex = indentDepth
        for mark in markupOnLines[i]
          # Insert a text token for all the text up until this markup
          # (unless there is no such text
          unless lastIndex >= mark.location.column or lastIndex >= line.length
            if (opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent'
              block = new model.Block 0, '#ffffff', false

              head = head.append block.start
              head = head.append new model.TextToken(line[lastIndex...mark.location.column])
              head = head.append block.end

            else
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
              # directly in another block, throw.
              if stack[stack.length - 1]?.type is 'block'
                throw new Error 'Improper parser: block cannot nest immediately inside another block.'
              
              # Update the stack
              stack.push mark.token.block
              
              # Push the token itself.
              head = head.append mark.token

            when 'socketStart'
              # A socket is only allowed to be directly inside a block.
              unless stack[stack.length - 1]?.type is 'block'
                throw new Error 'Improper parser: socket must be immediately insode a block.'

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

            when 'socketEnd'
              unless mark.token.socket is stack[stack.length - 1]
                throw new Error 'Improper parser: socket ended too early.'

              # Update stack
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
  
  # ## regenerateMarkup ##
  # Turn a list of containers into
  # a list of tags.
  regenerateMarkup = (markup) ->
    tags = []
    
    for mark in markup
      tags.push
        token: mark.container.start
        location: mark.bounds.start
        depth: mark.depth
        start: true

      tags.push
        token: mark.container.end
        location: mark.bounds.end
        depth: mark.depth
        start: false

    return tags
  
  # ## Parser ##
  # The Parser class is a simple
  # wrapper on the above functions
  # and a given parser function.
  exports.Parser = class Parser
    constructor: (@parseFn) ->
    
    parse: (text, opts) ->
      markup = regenerateMarkup @parseFn text
      sortMarkup markup
      return applyMarkup text, markup, opts

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
              subBlock = new model.MutationButtonToken segment
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
