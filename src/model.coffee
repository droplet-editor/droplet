# # ICE Editor model
#
# Copyright (c) 2014 Anthony Bau
# MIT License

define ['droplet-helper'], (helper) ->
  exports = {}

  YES = -> yes
  NO = -> no

  NORMAL = default: helper.NORMAL
  FORBID = default: helper.FORBID

  _id = 0

  # Getter/setter utility function
  Function::trigger = (prop, get, set) ->
    Object.defineProperty @prototype, prop,
      get: get
      set: set

  exports.isTreeValid = (tree) ->
    tortise = hare = tree.start.next

    stack =  []

    while true
      tortise = tortise.next

      lastHare = hare
      hare = hare.next
      unless hare?
        window._ice_debug_lastHare = lastHare
        throw new Error 'Ran off the end of the document before EOF'
      if lastHare isnt hare.prev
        throw new Error 'Linked list is not properly bidirectional'
      if hare is tree.end
        if stack.length > 0
          throw new Error 'Document ended before: ' + (k.type for k in stack).join(',')
        break
      if hare instanceof StartToken
        stack.push hare.container
      else if hare instanceof EndToken
        unless stack[stack.length - 1] is hare.container
          throw new Error "Stack does not align #{stack[stack.length - 1]?.type} != #{hare.container?.type}"
        else
          stack.pop()


      lastHare = hare
      hare = hare.next
      unless hare?
        window._ice_debug_lastHare = lastHare
        throw new Error 'Ran off the end of the document before EOF'
      if lastHare isnt hare.prev
        throw new Error 'Linked list is not properly bidirectional'
      if hare is tree.end
        if stack.length > 0
          throw new Error 'Document ended before: ' + (k.type for k in stack).join(',')
        break
      if hare instanceof StartToken
        stack.push hare.container
      else if hare instanceof EndToken
        unless stack[stack.length - 1] is hare.container
          throw new Error "Stack does not align #{stack[stack.length - 1]?.type} != #{hare.container?.type}"
        else
          stack.pop()

      if tortise is hare
        throw new Error 'Linked list loops'

    return true

  # Container
  # ==================
  # A generic XML-style container from which
  # all other containers (Block, Indent, Socket) will extend.
  exports.Container = class Container
    constructor: ->
      unless @start? or @end?
        @start = new StartToken this
        @end = new EndToken this

        @type = 'container'

      @id = ++_id
      @parent = null
      @version = 0
      @start.append @end

      @ephemeral = false

      # Line mark colours
      @lineMarkStyles = []

    # _cloneEmpty should simply instantiate
    # a new instance of this Container
    # with the same metadata.
    _cloneEmpty: -> new Container()

    getReader: ->
      {
        id: @id
        type: @type
        precedence: @precedence
        classes: @classes
      }

    hasParent: (parent) ->
      head = @
      until head in [parent, null]
        head = head.parent

      return head is parent

    getCommonParent: (other) ->
      head = @
      until other.hasParent head
        head = head.parent

      return head

    getLinesToParent: ->
      head = @start; lines = 0
      until head is @parent.start
        lines++ if head.type is 'newline'
        head = head.prev
      return lines

    hasCommonParent: (other) ->
      head = @
      until other.hasParent head
        head = head.parent

      return head?

    rawReplace: (other) ->
      if other.start.prev?
        other.start.prev.append @start

      if other.end.next?
        @end.append other.end.next

      @start.parent = @end.parent = @parent = other.parent

      other.parent = other.start.parent = other.end.parent = null
      other.start.prev = other.end.next = null

      @notifyChange()

    # Get the newline preceding the nth line
    # in this container (or the start or end of the container) by scanning
    # forward through the whole document. Start of document is 0.
    getNewlineBefore: (n) ->
      head = @start; lines = 0
      until lines is n or head is @end
        head = head.next
        lines++ if head.type is 'newline'
      return head

    # Get the true nth newline token
    getNewlineAfter: (n) ->
      head = @getNewlineBefore(n).next
      head = head.next until start.type is 'newline' or head is @end
      return head

    # Getters and setters for
    # leading and trailing text, for use
    # by modes to do paren-wrapping and
    # semicolon insertion
    getLeadingText: ->
      if @start.next.type is 'text'
        @start.next.value
      else
        ''

    getTrailingText: ->
      if @end.prev.type is 'text'
        @end.prev.value
      else
        ''

    setLeadingText: (value) ->
      if value?
        if @start.next.type is 'text'
          if value.length is 0
            @start.next.remove()
          else
            @start.next.value = value
        else unless value.length is 0
          @start.insert new TextToken value

    setTrailingText: (value) ->
      if value?
        if @end.prev.type is 'text'
          if value.length is 0
            @end.prev.remove()
          else
            @end.prev.value = value
        else unless value.length is 0
          @end.insertBefore new TextToken value

    # ## clone ##
    # Clone this container, with all the token inside,
    # but with no linked-list pointers in common.
    clone: ->
      # Clone ourselves empty first;
      # we will fill with appropriate
      # tokens.
      selfClone = @_cloneEmpty()

      assembler = selfClone.start

      @traverseOneLevel (head, isContainer) =>
        # If we have hit a container,
        # ask it to clone, so that
        # we copy over appropriate metadata.
        if isContainer
          clone = head.clone()
          assembler.append clone.start
          assembler = clone.end

        # Otherwise, just append a cloned
        # version of this token.
        else unless head.type is 'cursor'
          assembler = assembler.append head.clone()

      assembler.append selfClone.end

      selfClone.correctParentTree()

      return selfClone

    # ## stringify ##
    # Get a string representation of us,
    # using the `stringify()` method on all of
    # the tokens that we contain.
    stringify: (emptyToken = '') ->
      str = ''

      head = @start.next
      state =
        indent: ''
        emptyToken: emptyToken

      until head is @end
        str += head.stringify state
        head = head.next

      return str

    # ## serialize ##
    # Simple debugging output representation
    # of the tokens in this Container. Like XML.
    serialize: ->
      str = @_serialize_header()
      @traverseOneLevel (child) ->
        str += child.serialize()
      str += @_serialize_footer()

    _serialize_header: "<container>"
    _serialize_header: "</container>"

    # ## contents ##
    # Get a cloned version of a
    # linked list with our contents.
    contents: ->
      clone = @clone()

      if clone.start.next is clone.end
        return null

      else
        clone.start.next.prev = null
        clone.end.prev.next = null

        return clone.start.next

    # ## spliceOut ##
    # Remove ourselves from the linked
    # list that we are in.
    spliceOut: ->
      # Do not leave empty lines behind.

      # First,
      # let's determine what the previous and next
      # visible tokens are, to see if they are
      # two consecutive newlines, or similar.
      first = @start.previousVisibleToken(); last = @end.nextVisibleToken()

      # If the previous visible token is a newline,
      # and the next visible token is a newline, indentEnd,
      # or end of document, remove the first one, as it will
      # cause an empty line.
      #
      # Exception: do not do this if it would collapse
      # and indent to 0 length.
      while first?.type is 'newline' and
         last?.type in [undefined, 'newline', 'indentEnd', 'segmentEnd'] and
         not (first.previousVisibleToken()?.type is 'indentStart' and
         first.previousVisibleToken().container.end is last)
        first = first.previousVisibleToken()
        first.nextVisibleToken().remove()

      # If the next visible token is a newline,
      # and the previous visible token is the beginning
      # of the document, remove it.
      while last?.type is 'newline' and
          (last?.nextVisibleToken()?.type is 'newline' or
          first?.type in [undefined, 'segmentStart'])
        last = last.nextVisibleToken()
        last.previousVisibleToken().remove()

      @notifyChange()

      # Literally unsplice
      if @start.prev? then @start.prev.append @end.next
      else if @end.next? then @end.next.prev = null

      @start.prev = @end.next = null

      @start.parent = @end.parent = @parent = null

    # ## spliceIn ##
    # Insert ourselves into a linked
    # list somewhere else.
    spliceIn: (token) ->
      # Find the previous bit of significant markup
      token = token.prev while token.type is 'cursor'

      # As soon as we move around, reset our "ephemeral" flag.
      @ephemeral = false

      # Append newlines, etc. to the parent
      # if necessary.
      switch token.type
        when 'indentStart'
          head = token.container.end.prev
          while head.type in ['cursor', 'segmentEnd', 'segmentStart'] then head = head.prev

          if head.type is 'newline'
            token = token.next
          else
            token = token.insert new NewlineToken()

        when 'blockEnd'
          token = token.insert new NewlineToken()

        when 'segmentStart'
          unless token.nextVisibleToken() is token.container.end
            token.insert new NewlineToken()

        # Remove socket content when necessary
        when 'socketStart'
          token.append token.container.end

      # Literally splice in
      last = token.next

      token.append @start
      @start.parent = @end.parent = @parent
      @end.append last

      @notifyChange()

    # ## moveTo ##
    # Convenience function for testing;
    # splice out then splice in.
    #
    # USED FOR TESTING ONLY
    moveTo: (token, mode) ->
      if @start.prev? or @end.next?
        leading = @getLeadingText()
        trailing = @getTrailingText()

        [leading, trailing] = mode.parens leading, trailing, @, null

        @setLeadingText leading; @setTrailingText trailing

        @spliceOut()

      if token?
        leading = @getLeadingText()
        trailing = @getTrailingText()

        [leading, trailing] = mode.parens leading, trailing, @, (token.container ? token.parent)

        @setLeadingText leading; @setTrailingText trailing

        @spliceIn token

    # ## notifyChange ##
    # Increase version number (for caching purposes)
    notifyChange: ->
      head = this
      while head?
        head.version++
        head = head.parent

    # ## wrap ##
    # Insert ourselves _around_ some other
    # tokens.
    wrap: (first, last) ->
      @parent = @start.parent = @end.parent = first.parent
      first.prev.append @start
      @start.append first

      @end.append last.next
      last.append @end

      traverseOneLevel first, (head, isContainer) =>
        head.parent = this

      @notifyChange()

    # ## correctParentTree ##
    # Generally called immediately after assembling
    # a token stream by hand; corrects the entire
    # parent tree for the linked list.
    correctParentTree: ->
      @traverseOneLevel (head, isContainer) =>
        head.parent = this
        if isContainer
          head.start.parent = head.end.parent = this
          head.correctParentTree()

    # ## find ##
    # A utility function for finding the innermost
    # token fitting (fn), assuming there is only
    # one such token.
    find: (fn, excludes = []) ->
      head = @start

      until head is @end
        examined = if head instanceof StartToken then head.container else head

        # Skip over things in the excludes array
        if examined in excludes
          head = examined.end

        unless head instanceof EndToken or head.type in ['newline', 'cursor']
          if fn(examined) then return examined

        head = head.next

      if fn(this) then return this

    # ## getTokenAtLocation ##
    # Get the `loc`th token from the start.
    getTokenAtLocation: (loc) ->
      # A location of "null" means token "null"
      if not loc? then null
      else if loc is 0 then @start
      else
        head = @start; count = 1

        until count is loc or head is @end
          unless head?.type is 'cursor' then count++
          head = head.next

        head = head.next while head?.type is 'cursor'

        return head

    # ## getBlockOnLine ##
    # Get the innermost block that contains
    # the given line.
    getBlockOnLine: (line) ->
      head = @start; lineCount = 0
      stack = []

      until lineCount is line or not head?
        switch head.type
          when 'newline' then lineCount++
          when 'blockStart' then stack.push head.container
          when 'blockEnd' then stack.pop()
        head = head.next

      while head?.type in ['newline', 'cursor', 'segmentStart', 'segmentEnd'] then head = head.next
      if head?.type is 'blockStart' then stack.push head.container

      return stack[stack.length - 1]

    # ## traverseOneLevel ##
    # Identical to the utility function below;
    # traverse one tree level between our
    # start and end tokens.
    traverseOneLevel: (fn) ->
      traverseOneLevel @start.next, fn

    isFirstOnLine: ->
      return @start.previousVisibleToken() in [@parent?.start, @parent?.parent?.start, null] or
        @start.previousVisibleToken()?.type is 'newline'

    isLastOnLine: ->
      return @end.nextVisibleToken() in [@parent?.end, @parent?.parent?.end, null] or
        @end.nextVisibleToken()?.type in ['newline', 'indentStart', 'indentEnd']

    visParent: ->
      head = @parent
      while head?.type is 'segment' and head.isLassoSegment
        head = head.parent
      return head

    # Line mark mutators
    addLineMark: (mark) ->
      @lineMarkStyles.push mark

    removeLineMark: (tag) ->
      @lineMarkStyles = (mark for mark in @lineMarkStyles when mark.tag isnt tag)

    clearLineMarks: ->
      @lineMarkStyles = []

  # Token
  # ==================
  # Base class from which all other
  # tokens extend; knows some basic
  # linked list operations.
  exports.Token = class Token
    constructor: ->
      @id = ++_id

      @prev = @next = @parent = null

      @version = 0

    hasParent: (parent) ->
      head = @
      until head in [parent, null]
        head = head.parent

      return head is parent

    visParent: ->
      head = @parent
      while head?.type is 'segment' and head.isLassoSegment
        head = head.parent
      return head

    getCommonParent: (other) ->
      head = @
      until other.hasParent head
        head = head.parent

      return head

    hasCommonParent: (other) ->
      head = @
      until other.hasParent head
        head = head.parent

      return head?

    # ## append ##
    # Link this token to another
    # in the linked list.
    append: (token) ->
      @next = token; unless token then return
      token.prev = this

      # Correct parents if necessary,
      # which it usually ought not to be.
      unless token.parent is @parent
        traverseOneLevel token, (head) =>
          head.parent = @parent

      return token

    # ## insert ##
    insert: (token) ->
      if token instanceof StartToken or
         token instanceof EndToken
        console.warn '"insert"-ing a container can cause problems'

      token.next = @next; token.prev = this
      @next.prev = token; @next = token

      token.parent = @parent

      return token

    insertBefore: (token) ->
      if @prev? then @prev.insert token
      else
        @prev = token
        token.next = this
        token.parent = @parent

    # ## remove ##
    # Splice this token out of the
    # linked list.
    remove: ->
      if @prev? then @prev.append @next
      else if @next? then @next.prev = null

      @prev = @next = @parent = null

    # ## isVisible ##
    isVisible: YES
    isAffect: YES

    previousVisibleToken: ->
      head = @prev
      until not head? or head.isVisible()
        head = head.prev
      return head

    nextVisibleToken: ->
      head = @next
      until not head? or head.isVisible()
        head = head.next
      return head

    previousAffectToken: ->
      head = @prev
      until not head? or head.isAffect()
        head = head.prev
      return head

    nextAffectToken: ->
      head = @next
      until not head? or head.isAffect()
        head = head.next
      return head

    notifyChange: ->
      head = this
      while head?
        head.version++
        head = head.parent

      return null

    isFirstOnLine: ->
      return @previousVisibleToken() is @parent?.start or
        @previousVisibleToken()?.type is 'newline'

    isLastOnLine: ->
      return @nextVisibleToken() is @parent?.end or
        @nextVisibleToken()?.type in ['newline', 'indentEnd']

    getSerializedLocation: ->
      head = this; count = 0
      until head is null
        count++ unless head.type is 'cursor'
        head = head.prev
      return count

    stringify: -> ''
    serialize: -> ''

  exports.StartToken = class StartToken extends Token
    constructor: (@container) ->
      super; @markup = 'begin'

    append: (token) ->
      @next = token; unless token? then return
      token.prev = this

      traverseOneLevel token, (head) =>
        head.parent = @container

      return token

    insert: (token) ->
      if token instanceof StartToken or
         token instanceof EndToken
       console.warn '"insert"-ing a container can cause problems'

      token.next = @next; token.prev = this
      @next.prev = token; @next = token

      token.parent = @container

      return token

    serialize: -> '<container>'

  exports.EndToken = class EndToken extends Token
    constructor: (@container) ->
      super; @markup = 'end'

    append: (token) ->
      @next = token; unless token? then return
      token.prev = this

      traverseOneLevel token, (head) =>
        head.parent = @container.parent

      return token

    insert: (token) ->
      if token instanceof StartToken or
         token instanceof EndToken
       console.warn '"insert"-ing a container can cause problems'

      token.next = @next; token.prev = this
      @next.prev = token; @next = token

      token.parent = @container.parent

      return token

    serialize: -> '</container>'

  # Block
  # ==================

  exports.BlockStartToken = class BlockStartToken extends StartToken
    constructor: (@container) -> super; @type = 'blockStart'

  exports.BlockEndToken = class BlockEndToken extends EndToken
    constructor: (@container) -> super; @type = 'blockEnd'
    serialize: -> "</block>"

  exports.Block = class Block extends Container
    constructor: (@precedence = 0, @color = 'blank', @socketLevel = helper.ANY_DROP, @classes = []) ->
      @start = new BlockStartToken this
      @end = new BlockEndToken this


      @socket = new Socket @precedence, false, @classes.concat 'button'

      if 'no+-' not in @classes
        addBlock = new Block @precedence, @color, @socketLevel, @classes.concat 'no+-', 'no-pick', 'add-button'
        addBlock.start.append addBlock.end
        subtractBlock = new Block @precedence, @color, @socketLevel, @classes.concat 'no+-', 'no-pick', 'subtract-button'
        subtractBlock.start.append subtractBlock.end

        addBlock.end.append subtractBlock.start
        @socket.start.append addBlock.start
        subtractBlock.end.append @socket.end

      @type = 'block'

      super

    _cloneEmpty: ->
      clone = new Block @precedence, @color, @socketLevel, @classes
      clone.currentlyParenWrapped = @currentlyParenWrapped

      return clone

    _serialize_header: -> "<block precedence=\"#{
      @precedence}\" color=\"#{
      @color}\" socketLevel=\"#{
      @socketLevel}\" classes=\"#{
      @classes?.join?(' ') ? ''}\"
    >"
    _serialize_footer: -> "</block>"

  # Socket
  # ==================

  exports.SocketStartToken = class SocketStartToken extends StartToken
    constructor: (@container) -> super; @type = 'socketStart'
    stringify: (state) ->
      if @next is @container.end or
        @next.type is 'text' and @next.value is '' then state.emptyToken else ''

  exports.SocketEndToken = class SocketEndToken extends EndToken
    constructor: (@container) -> super; @type = 'socketEnd'

  exports.Socket = class Socket extends Container
    constructor: (@precedence = 0, @handwritten = false, @classes = []) ->
      @start = new SocketStartToken this
      @end = new SocketEndToken this

      @type = 'socket'

      super

    isDroppable: -> @start.next is @end or @start.next.type is 'text'

    _cloneEmpty: -> new Socket @precedence, @handwritten, @accepts

    _serialize_header: -> "<socket precedence=\"#{
        @precedence
      }\" handwritten=\"#{
        @handwritten
      }\" classes=\"#{
        @classes?.join?(' ') ? ''
      }\">"

    _serialize_footer: -> "</socket>"

  # Indent
  # ==================

  exports.IndentStartToken = class IndentStartToken extends StartToken
    constructor: (@container) -> super; @type = 'indentStart'
    stringify: (state) ->
      state.indent += @container.prefix; ''

  exports.IndentEndToken = class IndentEndToken extends EndToken
    constructor: (@container) -> super; @type = 'indentEnd'
    stringify: (state) ->
      unless @container.prefix.length is 0
        state.indent = state.indent[...-@container.prefix.length]
      if @previousVisibleToken().previousVisibleToken() is @container.start then state.emptyToken else ''
    serialize: -> "</indent>"

  exports.Indent = class Indent extends Container
    constructor: (@prefix = '', @classes = []) ->
      @start = new IndentStartToken this
      @end = new IndentEndToken this

      @type = 'indent'

      @depth = @prefix.length

      super

    _cloneEmpty: -> new Indent @prefix
    _serialize_header: -> "<indent prefix=\"#{
      @prefix
    }\" classes=\"#{
      @classes?.join?(' ') ? ''
    }\">"
    _serialize_footer: -> "</indent>"


  # Segment
  # ==================

  exports.SegmentStartToken = class SegmentStartToken extends StartToken
    constructor: (@container) -> super; @type = 'segmentStart'
    isVisible: -> @container.isRoot
    serialize: -> "<segment>"

  exports.SegmentEndToken = class SegmentEndToken extends EndToken
    constructor: (@container) -> super; @type = 'segmentEnd'
    isVisible: -> @container.isRoot
    serialize: -> "</segment>"

  exports.Segment = class Segment extends Container
    constructor: (@isLassoSegment = false) ->
      @start = new SegmentStartToken this
      @end = new SegmentEndToken this
      @isRoot = false
      @classes = ['__segment']

      @type = 'segment'

      super

    _cloneEmpty: -> new Segment @isLassoSegment

    unwrap: ->
      @notifyChange()

      @traverseOneLevel (head, isContainer) =>
        head.parent = @parent

      @start.remove(); @end.remove()

    _serialize_header: -> "<segment isLassoSegment=\"#{@isLassoSegment}\">"
    _serialize_footer: -> "</segment>"


  # Text
  exports.TextToken = class TextToken extends Token
    constructor: (@_value) ->
      super
      @type = 'text'

    # We will define getter/setter for the @value property
    # of TextToken, which is meant to be mutable but
    # also causes content change.
    @trigger 'value', (-> @_value), (value) ->
      @_value = value
      @notifyChange()

    stringify: (state) -> @_value
    serialize: -> helper.escapeXMLText @_value

    clone: -> new TextToken @_value

  exports.NewlineToken = class NewlineToken extends Token
    constructor: (@specialIndent) -> super; @type = 'newline'
    stringify: (state) -> '\n' + (@specialIndent ? state.indent)
    serialize: -> '\n'
    clone: -> new NewlineToken @specialIndent

  exports.CursorToken = class CursorToken extends Token
    constructor: -> super; @type = 'cursor'
    isVisible: NO
    isAffect: NO
    serialize: -> '<cursor/>'
    clone: -> new CursorToken()

  # Utility function for traversing all
  # the blocks at the same nesting depth
  # as the head token.
  traverseOneLevel = (head, fn) ->
    while true
      if head instanceof EndToken or not head?
        break
      else if head instanceof StartToken
        fn head.container, true; head = head.container.end
      else fn head, false

      head = head.next

  return exports
