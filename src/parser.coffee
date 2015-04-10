# # Parser.coffee
# Utility functions for defining ICE editor parsers.
#
# Copyright (c) 2014 Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model'], (helper, model) ->
  exports = {}
  _extend = (opts, defaults) ->
    unless opts? then return defaults
    for key, val of defaults
      unless key of opts
        opts[key] = val
    return opts

  YES = -> true

  exports.ParserFactory = class ParserFactory
    constructor: (@opts = {}) ->

    createParser: (text) -> new Parser text, @opts

  # ## Parser ##
  # The Parser class is a simple
  # wrapper on the above functions
  # and a given parser function.
  exports.Parser = class Parser
    constructor: (@text, opts) ->
      @opts = helper.extend({}, opts)
      convertFunction = (x) ->
        if (typeof x is 'string') or x instanceof String
          return {text: x, display: x}
        else
          return x
      for key, val of @opts.functions
        for index, options of val.dropdown then do (options) =>
          @opts.functions[key].dropdown[index] = ->
            if (typeof options is 'function')
              return options().map convertFunction
            else
              return options.map convertFunction
      # Text can sometimes be subject to change
      # when doing error recovery, so keep a record of
      # the original text.
      @originalText = @text
      @markup = []

    # ## parse ##
    _parse: (opts) ->
      opts = _extend opts, {
        wrapAtRoot: true
      }
      # Generate the list of tokens
      do @markRoot

      # Sort by position and depth
      do @sortMarkup

      # Generate a segment from the markup
      segment = @applyMarkup opts

      @detectParenWrap segment

      # Strip away blocks flagged to be removed
      # (for `` hack and error recovery)
      stripFlaggedBlocks segment

      # Correct parent tree and return.
      segment.correctParentTree()
      segment.isRoot = true
      return segment

    markRoot: ->

    isParenWrapped: (block) ->
      (block.start.next.type is 'text' and
        block.start.next.value[0] is '(' and
        block.end.prev.type is 'text' and
        block.end.prev.value[block.end.prev.value.length - 1] is ')')

    detectParenWrap: (segment) ->
      head = segment.start
      until head is segment.end
        head = head.next
        if head.type is 'blockStart' and
            @isParenWrapped head.container
          head.container.currentlyParenWrapped = true
      return segment

    # ## addBlock ##
    # addBlock takes {
    #   bounds: {
    #     start: {line, column}
    #     end: {line, column}
    #   }
    #   depth: Number
    #   precedence: Number
    #   color: String
    #   classes: []
    #   socketLevel: Number
    #   parenWrapped: Boolean
    # }
    addBlock: (opts) ->
      #opts.bounds.end.column += 4
      block = new model.Block opts.precedence,
        opts.color,
        opts.socketLevel,
        opts.classes,
        false

      @addMarkup block, opts.bounds, opts.depth
      ###
      newopts = JSON.parse(JSON.stringify(opts))
      newopts.bounds.end.column -= 2
      newopts.bounds.start.column = newopts.bounds.end.column - 2
      socket = new model.Socket newopts.precedence, false, newopts.classes

      newopts2 = JSON.parse(JSON.stringify(opts))
      newopts2.bounds.start.column = newopts2.bounds.end.column - 2
      socket2 = new model.Socket newopts2.precedence, false, newopts2.classes

      @addMarkup socket, newopts.bounds, newopts.depth + 1
      @addMarkup socket2, newopts2.bounds, newopts2.depth + 1
      ###

    # ## addSocket ##
    # addSocket takes {
    #   bounds: {
    #     start: {line, column}
    #     end: {line, column}
    #   }
    #   depth: Number
    #   precedence: Number
    #   accepts: shallow_dict
    # }
    addSocket: (opts) ->
      socket = new model.Socket opts.precedence,
        false,
        opts.classes,
        opts.dropdown

      @addMarkup socket, opts.bounds, opts.depth

    # ## addIndent ##
    # addIndent takes {
    #   bounds: {
    #     start: {line, column}
    #     end: {line, column}
    #   }
    #   depth: Number
    #   prefix: String
    # }
    addIndent: (opts) ->
      indent = new model.Indent opts.prefix, opts.classes

      @addMarkup indent, opts.bounds, opts.depth

    # ## addMarkup ##
    # Add a container around some bounds
    addMarkup: (container, bounds, depth) ->
      @markup.push
        token: container.start
        location: bounds.start
        depth: depth
        start: true

      @markup.push
        token: container.end
        location: bounds.end
        depth: depth
        start: false

      return container

    # ## sortMarkup ##
    # Sort the markup by the order
    # in which it will appear in the text.
    sortMarkup: ->
      @markup.sort (a, b) ->
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
        isDifferent = 1
        if a.token.container is b.token.container
          isDifferent = -1

        if a.start and not b.start
          return isDifferent

        if b.start and not a.start
          return -isDifferent

        # If two pieces of markup are in the same position,
        # and are both start or end,
        # the markup placed earlier gets to go on the outside
        if a.start and b.start
          if a.depth > b.depth
            return 1
          else return -1

        if (not a.start) and (not b.start)
          if a.depth > b.depth
            return -1
          else return 1

    # ## constructHandwrittenBlock
    # Construct a handwritten block with the given
    # text inside
    constructHandwrittenBlock: (text) ->
      block = new model.Block 0, 'blank', helper.ANY_DROP
      socket = new model.Socket 0, true
      textToken = new model.TextToken text

      block.start.append socket.start
      socket.start.append textToken
      textToken.append socket.end
      socket.end.append block.end

      if @isComment text
        block.socketLevel = helper.BLOCK_ONLY
        socket.end.append block.end

      return block

    applyMarkup: (opts) ->
      # For convenience, will we
      # separate the markup by the line on which it is placed.
      markupOnLines = {}

      for mark in @markup
        markupOnLines[mark.location.line] ?= []
        markupOnLines[mark.location.line].push mark

      # Now, we will interact with the text
      # by line-column coordinates. So we first want
      # to split the text into lines.
      lines = @text.split '\n'

      indentDepth = 0
      stack = []
      document = new model.Segment(); head = document.start

      for line, i in lines
        # If there is no markup on this line,
        # simply append the text of this line to the document
        # (stripping things as needed for indent)
        if not (i of markupOnLines)
          # If this line is not properly indented,
          # flag it in the model.
          if indentDepth >= line.length or line[...indentDepth].trim().length > 0
            head.specialIndent = (' ' for [0...line.length - line.trimLeft().length]).join ''
            line = line.trimLeft()
          else
            line = line[indentDepth...]

          # If we have some text here that
          # is floating (not surrounded by a block),
          # wrap it in a generic block automatically.
          if line.length > 0
            if (opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent'
              block = @constructHandwrittenBlock line

              head.append block.start
              head = block.end

            else
              head = head.append new model.TextToken line

          else if stack[stack.length - 1]?.type in ['indent', 'segment', undefined] and
              hasSomeTextAfter(lines, i)
            block = new model.Block 0, 'yellow', helper.BLOCK_ONLY

            head = head.append block.start
            head = head.append block.end

          head = head.append new model.NewlineToken()

        # If there is markup on this line, insert it.
        else
          # Flag if this line is not properly indented.
          if indentDepth >= line.length or line[...indentDepth].trim().length > 0
            lastIndex = line.length - line.trimLeft().length
            head.specialIndent = line[0...lastIndex]
          else
            lastIndex = indentDepth

          for mark in markupOnLines[i]
            # Insert a text token for all the text up until this markup
            # (unless there is no such text
            unless lastIndex >= mark.location.column or lastIndex >= line.length
              if (opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent'
                block = @constructHandwrittenBlock line[lastIndex...mark.location.column]

                head.append block.start
                head = block.end

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
                indentDepth += mark.token.container.prefix.length

              when 'blockStart'
                # If the a block is embedded
                # directly in another block, throw.
                if stack[stack.length - 1]?.type is 'block'
                  throw new Error 'Improper parser: block cannot nest immediately inside another block.'

              when 'socketStart'
                # A socket is only allowed to be directly inside a block.
                unless stack[stack.length - 1]?.type is 'block'
                  throw new Error 'Improper parser: socket must be immediately inside a block.'

              when 'indentEnd'
                indentDepth -= mark.token.container.prefix.length

            # Update the stack
            if mark.token instanceof model.StartToken
              stack.push mark.token.container
            else if mark.token instanceof model.EndToken
              unless mark.token.container is stack[stack.length - 1]
                throw new Error "Improper parser: #{head.container.type} ended too early."
              stack.pop()

            # Append the token
            head = head.append mark.token

            lastIndex = mark.location.column

          # Append the rest of the string
          # (after the last piece of markup)
          unless lastIndex >= line.length
            head = head.append new model.TextToken(line[lastIndex...line.length])

          #head = head.append new model.AddButtonToken()
          #head = head.append new model.SubtractButtonToken()

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

  exports.parseXML = (xml) ->
    root = new model.Segment(); head = root.start
    stack = []
    parser = sax.parser true

    parser.ontext = (text) ->
      tokens = text.split '\n'
      for token, i in tokens
        unless token.length is 0
          head = head.append new model.TextToken token
        unless i is tokens.length - 1
          head = head.append new model.NewlineToken()

    parser.onopentag = (node) ->
      attributes = node.attributes
      switch node.name
        when 'block'
          container = new model.Block attributes.precedence, attributes.color,
            attributes.socketLevel, attributes.classes?.split?(' ')
        when 'socket'
          container = new model.Socket attributes.precedence, attributes.handritten,
            attributes.classes?.split?(' ')
        when 'indent'
          container = new model.Indent attributes.prefix, attributes.classe?.split?(' ')
        when 'segment'
          # Root segment is optional
          unless stack.length is 0
            container = new model.Segment()
        when 'br'
          head = head.append new model.NewlineToken()
          return null

      if container?
        stack.push {
          node: node
          container: container
        }

        head = head.append container.start

    parser.onclosetag = (nodeName) ->
      if stack.length > 0 and nodeName is stack[stack.length - 1].node.name
        container = stack[stack.length - 1].container
        head = head.append container.end
        stack.pop()

    parser.onerror = (e) ->
      throw e

    parser.write(xml).close()

    head = head.append root.end

    return root

  hasSomeTextAfter = (lines, i) ->
    until i is lines.length
      if lines[i].length > 0 then return true
      i += 1
    return false

  # ## applyMarkup ##
  # Given some text and (sorted) markup,
  # produce an ICE editor document
  # with the markup inserted into the text.
  #
  # Automatically insert sockets around blocks along the way.
  stripFlaggedBlocks = (segment) ->
    head = segment.start
    until head is segment.end
      if (head instanceof model.StartToken and
          head.container.flagToRemove)

        container = head.container
        head = container.end.next

        container.spliceOut()
      else if (head instanceof model.StartToken and
          head.container.flagToStrip)
        head.container.parent?.color = 'error'
        text = head.next
        text.value =
          text.value.substring(
            head.container.flagToStrip.left,
            text.value.length - head.container.flagToStrip.right)
        head = text.next
      else
        head = head.next

  Parser.parens = (leading, trailing, node, context) ->
    if context is null or context.type isnt 'socket' or
        context?.precedence < node.precedence
      while true
        if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
          leading leading().replace(/^\s*\(\s*/, '')
          trailing trailing().replace(/^\s*\)\s*/, '')
        else
          break
    else
      leading '(' + leading()
      trailing trailing() + ')'

  Parser.drop = (block, context, pred) ->
    if block.type is 'segment' and context.type is 'socket'
      return helper.FORBID
    else
      return helper.ENCOURAGE

  Parser.escapeString = (str) ->
    str = str.trim()
    try
      newParse = @parse(unparsedValue = str, wrapAtRoot: false)
    catch
      if str[0] is str[str.length - 1] and str[0] in ['"', '\'']
        try
          str = str[0] + str[1...-1].replace(/(\'|\"|\n)/g, '\\$1') + str[str.length - 1]
    return str

  Parser.handleButton = (text, lineNumber, classes) ->
    return text

  Parser.empty = ''

  exports.wrapParser = (CustomParser) ->
    class CustomParserFactory extends ParserFactory
      constructor: (@opts = {}) ->
        @empty = CustomParser.empty

      createParser: (text) -> new CustomParser text, @opts

      parse: (text, opts) ->
        opts ?= wrapAtRoot: true
        return @createParser(text)._parse opts

      parens: (leading, trailing, node, context) ->
        # leadingFn is always a getter/setter for leading
        leadingFn = (value) ->
          if value?
            leading = value
          return leading

        # trailingFn may either get/set leading or trailing;
        # will point to leading if leading is the only token,
        # but will point to trailing otherwise.
        if trailing?
          trailingFn = (value) ->
            if value?
              trailing = value
            return trailing
        else
          trailingFn = leadingFn

        CustomParser.parens leadingFn, trailingFn, node, context

        return [leading, trailing]

      drop: (block, context, pred) -> CustomParser.drop block, context, pred

      escapeString: (str) -> CustomParser.escapeString str

      handleButton: (text, lineNumber, classes) -> CustomParser.handleButton text, lineNumber, classes

  return exports
