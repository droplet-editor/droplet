# Droplet parser wrapper.
# Utility functions for defining Droplet parsers.
#
# Copyright (c) 2015 Anthony Bau (dab1998@gmail.com)
# MIT License

helper = require './helper.coffee'
model = require './model.coffee'

exports.PreNodeContext = class PreNodeContext
  constructor: (@type, @preParenLength, @postParenLength) ->

  apply: (node) ->
    trailingText = node.getTrailingText()
    trailingText = trailingText[0...trailingText.length - @postParenLength]

    leadingText = node.getLeadingText()
    leadingText = leadingText[@preParenLength...leadingText.length]

    return new model.NodeContext @type, leadingText, trailingText

sax = require 'sax'

_extend = (opts, defaults) ->
  unless opts? then return defaults
  for key, val of defaults
    unless key of opts
      opts[key] = val
  return opts

YES = -> true

isPrefix = (a, b) -> a[...b.length] is b

exports.ParserFactory = class ParserFactory
  constructor: (@opts = {}) ->

  createParser: (text) -> new Parser text, @opts

# ## Parser ##
# The Parser class is a simple
# wrapper on the above functions
# and a given parser function.
exports.Parser = class Parser
  constructor: (@text, @opts = {}) ->
    # Text can sometimes be subject to change
    # when doing error recovery, so keep a record of
    # the original text.
    @originalText = @text
    @markup = []

  # ## parse ##
  _parse: (opts, cachedParse) ->
    opts = _extend opts, {
      wrapAtRoot: true
      preserveEmpty: true
    }
    # Generate the list of tokens
    @markRoot opts.context, cachedParse

    # Sort by position and depth
    do @sortMarkup

    # Generate a document from the markup
    document = @applyMarkup opts

    # Correct parent tree
    document.correctParentTree()

    # Add node context annotations from PreNodeContext
    # annotations
    head = document.start
    until head is document.end
      if head.type is 'blockStart' and head.container._preNodeContext?
        head.container.nodeContext = head.container._preNodeContext.apply head.container
      head = head.next

    # Strip away blocks flagged to be removed
    # (for `` hack and error recovery)
    if opts.preserveEmpty
      stripFlaggedBlocks document

    return document

  markRoot: ->

  # ## addBlock ##
  # addBlock takes {
  #   bounds: {
  #     start: {line, column}
  #     end: {line, column}
  #   }
  #   depth: Number
  #   precedence: Number
  #   color: String
  #   socketLevel: Number
  #   parenWrapped: Boolean
  # }
  addBlock: (opts) ->
    block = new model.Block opts.color,
      opts.shape,
      opts.parseContext,
      null,
      opts.buttons,
      opts.data

    block._preNodeContext = opts.nodeContext

    @addMarkup block, opts.bounds, opts.depth

  addButtonContainer: (opts) ->
    container = new model.ButtonContainer opts.parseContext,
      opts.buttons,
      opts.data

    @addMarkup container, opts.bounds, opts.depth

  addLockedSocket: (opts) ->
    container = new model.LockedSocket opts.parseContext,
      opts.dropdown,
      opts.data

    @addMarkup container, opts.bounds, opts.depth

  # flagToRemove, used for removing the placeholders that
  # are placed when round-tripping empty sockets, so that, e.g. in CoffeeScript mode
  # a + (empty socket) -> a + `` -> a + (empty socket).
  #
  # These are done by placing blocks around that text and then removing that block from the tree.
  flagToRemove: (bounds, depth) ->
    block = new model.Block()

    block.flagToRemove = true

    @addMarkup block, bounds, depth

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
    socket = new model.Socket opts.empty ? @empty,
      false,
      opts.dropdown,
      opts.parseContext

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
    indent = new model.Indent @emptyIndent, opts.prefix, opts.indentContext

    @addMarkup indent, opts.bounds, opts.depth

  checkBounds: (bounds) ->
    if not (bounds?.start?.line? and bounds?.start?.column? and
            bounds?.end?.line? and bounds?.end?.column?)
      throw new IllegalArgumentException 'bad bounds object'

  # ## addMarkup ##
  # Add a container around some bounds
  addMarkup: (container, bounds, depth) ->
    @checkBounds bounds
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
    block = new model.Block 'comment', helper.ANY_DROP, '__comment__'
    if @isComment text
      head = block.start

      {sockets, color} = @parseComment(text)

      if color?
        block.color = color

      lastPosition = 0

      if sockets?
        for socketPosition in sockets
          socket = new model.Socket '', false, null, '__comment__'
          socket.setParent block

          padText = text[lastPosition...socketPosition[0]]

          if padText.length > 0
            padTextToken = new model.TextToken padText
            padTextToken.setParent block

            helper.connect head, padTextToken

            head = padTextToken

          textToken = new model.TextToken text[socketPosition[0]...socketPosition[1]]
          textToken.setParent block

          helper.connect head, socket.start
          helper.connect socket.start, textToken
          helper.connect textToken, socket.end

          head = socket.end

          lastPosition = socketPosition[1]

      finalPadText = text[lastPosition...text.length]

      if finalPadText.length > 0
        finalPadTextToken = new model.TextToken finalPadText
        finalPadTextToken.setParent block

        helper.connect head, finalPadTextToken

        head = finalPadTextToken

      helper.connect head, block.end

    else
      socket = new model.Socket '', true
      textToken = new model.TextToken text
      textToken.setParent socket

      block.shape = helper.BLOCK_ONLY
      helper.connect block.start, socket.start

      helper.connect socket.start, textToken
      helper.connect textToken, socket.end
      helper.connect socket.end, block.end


    return block

  handleButton: (text, command, oldblock) ->
    return text

  # applyMarkup
  # -----------
  #
  # The parser adapter will throw out markup in arbitrary orders. `applyMarkup`'s job is to assemble
  # a parse tree from this markup. `applyMarkup` also cleans up any leftover text that lies outside blocks or
  # sockets by passing them through a comment-handling procedure.
  #
  # `applyMarkup` applies the generated markup by sorting it, then walking from the beginning to the end of the
  # document, creating `TextToken`s and inserting the markup between them. It also keeps a stack
  # of which containers it is currently in, for error detection and comment handling.
  #
  # Whenever the container is currently an `Indent` or a `Document` and we get some text, we handle it as a comment.
  # If it contains block-comment tokens, like /* or */, we immediately make comment blocks around them, amalgamating multiline comments
  # into single blocks. We do this by scanning forward and just toggling on or off a bit that says whether we're inside
  # a block comment, refusing to put any markup while we're inside one.
  #
  # When outside a block-comment, we pass free text to the mode's comment parser. This comment parser
  # will return a set of text ranges to put in sockets, usually the place where freeform text can be put in the comment.
  # For instance, `//hello` in JavaScript should return (2, 6) to put a socket around 'hello'. In C, this is used
  # to handle preprocessor directives.

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
    document = new model.Document(opts.context ? @rootContext); head = document.start

    currentlyCommented = false

    for line, i in lines
      # If there is no markup on this line,
      # helper.connect simply, the text of this line to the document
      # (stripping things as needed for indent)
      if not (i of markupOnLines)
        # If this line is not properly indented,
        # flag it in the model.
        if indentDepth > line.length or line[...indentDepth].trim().length > 0
          head.specialIndent = (' ' for [0...line.length - line.trimLeft().length]).join ''
          line = line.trimLeft()
        else
          line = line[indentDepth...]

        # If we have some text here that
        # is floating (not surrounded by a block),
        # wrap it in a generic block automatically.
        #
        # We will also send it through a pass through a comment parser here,
        # for special handling of different forms of comments (or, e.g. in C mode, directives),
        # and amalgamate multiline comments.
        placedSomething = false
        while line.length > 0
          if currentlyCommented
            placedSomething = true
            if line.indexOf(@endComment) > -1
              head = helper.connect head,
                new model.TextToken line[...line.indexOf(@endComment) + @endComment.length]
              line = line[line.indexOf(@endComment) + @endComment.length...]

              head = helper.connect head, stack.pop().end
              currentlyCommented = false

          if not currentlyCommented and
              ((opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent') and
              line.length > 0
            placedSomething = true
            if isPrefix(line.trimLeft(), @startComment)
              currentlyCommented = true
              block = new model.Block 'comment', helper.ANY_DROP, '__comment__'
              stack.push block

              helper.connect head, block.start
              head = block.start

            else
              block = @constructHandwrittenBlock line

              helper.connect head, block.start
              head = block.end

              line = ''

          else if line.length > 0
            placedSomething = true
            head = helper.connect head, new model.TextToken line

            line = ''

        if line.length is 0 and not placedSomething and stack[stack.length - 1]?.type in ['indent', 'document', undefined] and
            hasSomeTextAfter(lines, i)
          block = new model.Block @opts.emptyLineColor, helper.BLOCK_ONLY, '__comment__'

          head = helper.connect head, block.start
          head = helper.connect head, block.end

        head = helper.connect head, new model.NewlineToken()

      # If there is markup on this line, insert it.
      else
        # Flag if this line is not properly indented.
        if indentDepth > line.length or line[...indentDepth].trim().length > 0
          lastIndex = line.length - line.trimLeft().length
          head.specialIndent = line[0...lastIndex]
        else
          lastIndex = indentDepth

        for mark in markupOnLines[i]
          # If flagToRemove is turned off, ignore markup
          # that was generated by the flagToRemove mechanism. This will simply
          # create text tokens instead of creating a block slated to be removed.
          continue if mark.token.container? and mark.token.container.flagToRemove and not opts.preserveEmpty

          # Insert a text token for all the text up until this markup
          # (unless there is no such text
          unless lastIndex >= mark.location.column or lastIndex >= line.length
            if (not currentlyCommented) and
                (opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent'
              block = @constructHandwrittenBlock line[lastIndex...mark.location.column]

              helper.connect head, block.start
              head = block.end
            else
              head = helper.connect head, new model.TextToken(line[lastIndex...mark.location.column])

            if currentlyCommented
              head = helper.connect head, stack.pop().end
              currentlyCommented = false

          # Note, if we have inserted something,
          # the new indent depth and the new stack.
          switch mark.token.type
            when 'indentStart'
              # An Indent is only allowed to be
              # directly inside a block; if not, then throw.
              unless stack?[stack.length - 1]?.type in ['block', 'buttonContainer']
                throw new Error 'Improper parser: indent must be inside block, but is inside ' + stack?[stack.length - 1]?.type
              indentDepth += mark.token.container.prefix.length

            when 'blockStart'
              # If the a block is embedded
              # directly in another block, throw.
              if stack[stack.length - 1]?.type in ['block', 'buttonContainer']
                throw new Error 'Improper parser: block cannot nest immediately inside another block.'

            when 'socketStart'
              # A socket is only allowed to be directly inside a block.
              unless stack[stack.length - 1]?.type in ['block', 'buttonContainer']
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
          head = helper.connect head, mark.token

          lastIndex = mark.location.column

        # Append the rest of the string
        # (after the last piece of markup)
        until lastIndex >= line.length
          if currentlyCommented
            if line[lastIndex...].indexOf(@endComment) > -1
              head = helper.connect head,
                new model.TextToken line[lastIndex...lastIndex + line[lastIndex...].indexOf(@endComment) + @endComment.length]

              lastIndex += line[lastIndex...].indexOf(@endComment) + @endComment.length

              head = helper.connect head, stack.pop().end
              currentlyCommented = false

          if not currentlyCommented and
              ((opts.wrapAtRoot and stack.length is 0) or stack[stack.length - 1]?.type is 'indent') and
              line.length > 0
            if isPrefix(line[lastIndex...].trimLeft(), @startComment)
              currentlyCommented = true
              block = new model.Block 'comment', helper.ANY_DROP, '__comment__'
              stack.push block

              helper.connect head, block.start
              head = block.start

            else
              block = @constructHandwrittenBlock line[lastIndex...]

              helper.connect head, block.start
              head = block.end

              lastIndex = line.length

          else if lastIndex < line.length
            head = helper.connect head, new model.TextToken line[lastIndex...]

            lastIndex = line.length

        head = helper.connect head, new model.NewlineToken()

    # Pop off the last newline token, which is not necessary
    head = head.prev
    head.next.remove()

    # Reinsert the end token of the document,
    # which we previously threw away by using "connect"
    head = helper.connect head, document.end

    # Return the document
    return document

exports.parseXML = (xml) ->
  root = new model.Document(); head = root.start
  stack = []
  parser = sax.parser true

  parser.ontext = (text) ->
    tokens = text.split '\n'
    for token, i in tokens
      unless token.length is 0
        head = helper.connect head, new model.TextToken token
      unless i is tokens.length - 1
        head = helper.connect head, new model.NewlineToken()

  # TODO Improve serialization format
  # for test updates. Currently no longer unity
  # because @empty is not preserved.
  parser.onopentag = (node) ->
    attributes = node.attributes
    switch node.name
      when 'block'
        container = new model.Block attributes.color,
          attributes.shape, attributes.parseContext
      when 'socket'
        container = new model.Socket '', attributes.handritten, attributes.parseContext
      when 'indent'
        container = new model.Indent '', attributes.prefix, attributes.indentContext
      when 'document'
        # Root is optional
        unless stack.length is 0
          container = new model.Document()
      when 'br'
        head = helper.connect head, new model.NewlineToken()
        return null

    if container?
      stack.push {
        node: node
        container: container
      }

      head = helper.connect head, container.start

  parser.onclosetag = (nodeName) ->
    if stack.length > 0 and nodeName is stack[stack.length - 1].node.name
      head = helper.connect head, stack[stack.length - 1].container.end
      stack.pop()

  parser.onerror = (e) ->
    throw e

  parser.write(xml).close()

  head = helper.connect head, root.end
  root.correctParentTree()

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
stripFlaggedBlocks = (document) ->
  head = document.start
  until head is document.end
    if (head instanceof model.StartToken and
        head.container.flagToRemove)

      container = head.container
      head = container.end.next

      document.remove container
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

Parser.drop = (block, context, pred, next) ->
  if block.type is 'document' and context.type is 'socket'
    return helper.FORBID
  else
    return helper.ENCOURAGE

Parser.empty = ''
Parser.emptyIndent = ''

getDefaultSelectionRange = (string) -> {start: 0, end: string.length}

exports.wrapParser = (CustomParser) ->
  class CustomParserFactory extends ParserFactory
    constructor: (@opts = {}) ->
      @empty = CustomParser.empty
      @emptyIndent = CustomParser.emptyIndent
      @startComment = CustomParser.startComment ? '/*'
      @endComment = CustomParser.endComment ? '*/'
      @rootContext = CustomParser.rootContext
      @startSingleLineComment = CustomParser.startSingleLineComment ? '//'
      @getDefaultSelectionRange = CustomParser.getDefaultSelectionRange ? getDefaultSelectionRange
      @getParenCandidates = CustomParser.getParenCandidates

    lockedSocketCallback: (socketText, blockText, parseContext) ->
      if CustomParser.lockedSocketCallback?
        return CustomParser.lockedSocketCallback @opts, socketText, blockText, parseContext
      else
        return blockText

    # TODO kind of hacky assignation of @empty,
    # maybe change the api?
    createParser: (text) ->
      parser = new CustomParser text, @opts
      parser.startComment = @startComment
      parser.endComment = @endComment
      parser.empty = @empty
      parser.emptyIndent = @emptyIndent
      parser.rootContext = @rootContext
      return parser

    stringFixer: (string) ->
      if CustomParser.stringFixer?
        CustomParser.stringFixer.apply @, arguments
      else
        return string

    preparse: (text, context) ->
      return @createParser(text).preparse context

    parse: (text, opts, cachedParse = null) ->
      @opts.parseOptions = opts
      opts ?= wrapAtRoot: true
      return @createParser(text)._parse opts, cachedParse

    parens: (leading, trailing, node, context) ->
      # We do this function thing so that if leading and trailing are the same
      # (i.e. there is only one text token), parser adapter functions can still treat
      # it as if they are two different things.

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

      context = CustomParser.parens leadingFn, trailingFn, node, context

      return [leading, trailing, context]


    drop: (block, context, pred, next) -> CustomParser.drop block, context, pred, next

    handleButton: (text, command, oldblock) ->
      parser = @createParser(text)
      parser.handleButton text, command, oldblock
