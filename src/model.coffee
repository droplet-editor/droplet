# Droplet model.
#
# Copyright (c) 2014 Anthony Bau (dab1998@gmail.com)
# MIT License
helper = require './helper.coffee'

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

# TODO add parenting checks
exports.isTreeValid = isTreeValid = (tree) ->
  tortise = hare = tree.start.next

  stack =  []

  while true
    tortise = tortise.next

    lastHare = hare
    hare = hare.next
    unless hare?
      window._droplet_debug_lastHare = lastHare
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
      window._droplet_debug_lastHare = lastHare
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

class Operation
  constructor: (@type, list) ->
    @location = null # Needs to be set by someone else

    @list = list.clone()

    @start = list.start.getLocation()
    @end = list.end.getLocation()

  toString: -> JSON.stringify({
    location: @location.toString()
    list: @list.stringify()
    start: @start.toString()
    end: @end.toString()
    type: @type
  })

class ReplaceOperation
  constructor: (
        @beforeStart, @before, @beforeEnd,
        @afterStart, @after, @afterEnd
      ) ->
    @type = 'replace'

  toString: -> JSON.stringify({
    beforeStart: @beforeStart.toString()
    before: @before.stringify()
    beforeEnd: @beforeEnd.toString()
    afterStart: @afterStart.toString()
    after: @after.stringify()
    afterEnd: @afterEnd.toString()
    type: @type
  })

exports.List = class List
  constructor: (@start, @end) ->
    @id = ++_id

  contains: (token) ->
    if token instanceof Container
      token = token.start

    head = @start
    until head is @end
      if head is token
        return true
      head = head.next

    if token is @end
      return true
    else
      return false

  getDocument: -> @start.getDocument()

  # ## insert ##
  # Insert another list into us
  # and return an (undoable) record
  # of this operation
  insert: (token, list, updates = []) ->
    [first, last] = [list.start, list.end]

    updateTokens = updates.map((x) => @getFromLocation(x))

    # Append newlines, etc. to the parent
    # if necessary.
    switch token.type
      when 'indentStart'
        head = token.container.end.prev

        if head.type is 'newline'
          token = token.next
        else
          first = new NewlineToken()
          helper.connect first, list.start

      when 'blockEnd'
        first = new NewlineToken()
        helper.connect first, list.start

      when 'documentStart'
        unless token.next is token.container.end
          last = new NewlineToken()
          helper.connect list.end, last

    # Get the location
    location = token.getLocation()

    # New list with added newlines
    list = new List first, last

    # Literally splice in
    after = token.next
    helper.connect token, list.start

    if token instanceof StartToken
      list.setParent token.container
    else
      list.setParent token.parent

    helper.connect list.end, after
    list.notifyChange()

    # Make and return an undo operation
    operation = new Operation 'insert', list
    operation.location = location

    # Preserve updates
    updates.forEach (x, i) ->
      x.set(updateTokens[i].getLocation())

    return operation

  # ## remove ##
  # Remove ourselves from the linked
  # list that we are in.
  remove: (list, updates = []) ->
    # Do not leave empty lines behind.

    # First,
    # let's determine what the previous and next
    # visible tokens are, to see if they are
    # two consecutive newlines, or similar.
    first = list.start.prev; last = list.end.next

    # If the previous visible token is a newline,
    # and the next visible token is a newline, indentEnd,
    # or end of document, remove the first one, as it will
    # cause an empty line.
    #
    # Exception: do not do this if it would collapse
    # and indent to 0 length.
    while first?.type is 'newline' and
       last?.type in [undefined, 'newline', 'indentEnd', 'documentEnd'] and
       not (first.prev?.type is 'indentStart' and
       first.prev.container.end is last)
      first = first.prev

    # If the next visible token is a newline,
    # and the previous visible token is the beginning
    # of the document, remove it.
    while last?.type is 'newline' and
        (last?.next?.type is 'newline' or
        first?.type in [undefined, 'documentStart'])
      last = last.next

    first = first.next
    last = last.prev

    # Expand the list based on this analysis
    list = new List first, last

    list.notifyChange()

    updateTokens = updates.map((x) => @getFromLocation(x)).map((x) =>
      if list.contains(x)
        return list.start.prev
      else
        return x
    )

    # Make an undo operation
    record = new Operation 'remove', list
    location = list.start.prev

    helper.connect list.start.prev, list.end.next
    list.start.prev = list.end.next = null
    list.setParent null

    # Correct the location in case
    # lengths or coordinates changed
    record.location = location.getLocation()

    updates.forEach (x, i) =>
      x.set(updateTokens[i].getLocation())

    # Return the undo operation
    return record

  replace: (before, after, updates = []) ->
    updateTextLocations = updates.map((x) => @getFromLocation(x).getTextLocation())

    beforeStart = before.start.getLocation()
    beforeEnd = before.end.getLocation()

    beforeLength = before.stringify().length

    parent = before.start.parent

    helper.connect before.start.prev, after.start
    helper.connect after.end, before.end.next

    before.setParent null
    after.setParent parent
    after.notifyChange()

    afterStart = after.start.getLocation()
    afterEnd = after.end.getLocation()

    updates.forEach (x, i) =>
      x.set(@getFromTextLocation(updateTextLocations[i]).getLocation())

    return new ReplaceOperation(
      beforeStart, before.clone(), beforeEnd,
      afterStart, after.clone(), afterEnd
    )

  perform: (operation, direction, updates = []) ->
    if operation instanceof Operation
      if (operation.type is 'insert') isnt (direction is 'forward')
        list = new List @getFromLocation(operation.start), @getFromLocation(operation.end)
        list.notifyChange()

        # Preserve update tokens
        updateTokens = updates.map((x) => @getFromLocation(x)).map((x) =>
          if list.contains(x)
            return list.start.prev
          else
            return x
        )

        helper.connect list.start.prev, list.end.next

        updates.forEach (x, i) ->
          x.set(updateTokens[i].getLocation())

        return operation

      else if (operation.type is 'remove') isnt (direction is 'forward')
        # Preserve update tokens
        updateTokens = updates.map((x) => @getFromLocation(x))

        list = operation.list.clone()

        before = @getFromLocation(operation.location)
        after = before.next

        helper.connect before, list.start
        helper.connect list.end, after

        if before instanceof StartToken
          list.setParent before.container
        else
          list.setParent before.parent

        list.notifyChange()

        updates.forEach (x, i) ->
          x.set(updateTokens[i].getLocation())

        return operation

    else if operation.type is 'replace'
      updateTextLocations = updates.map((x) => @getFromLocation(x).getTextLocation())

      if direction is 'forward'
        before = new List @getFromLocation(operation.beforeStart), @getFromLocation(operation.beforeEnd)
        after = operation.after.clone()
      else
        before = new List @getFromLocation(operation.afterStart), @getFromLocation(operation.afterEnd)
        after = operation.before.clone()

      parent = before.start.parent

      helper.connect before.start.prev, after.start
      helper.connect after.end, before.end.next

      after.setParent parent
      before.setParent null
      after.notifyChange()

      updates.forEach (x, i) =>
        x.set(@getFromTextLocation(updateTextLocations[i]).getLocation())

      return null # TODO new ReplaceOperation here

  notifyChange: ->
    @traverseOneLevel (head) ->
      head.notifyChange()

  traverseOneLevel: (fn) ->
    traverseOneLevel @start, fn, @end

  isFirstOnLine: ->
    return @start.prev in [@parent?.start, @parent?.parent?.start, null] or
      @start.prev?.type is 'newline'

  isLastOnLine: ->
    return @end.next in [@parent?.end, @parent?.parent?.end, null] or
      @end.next?.type in ['newline', 'indentStart', 'indentEnd']

  getReader: -> {type: 'document', classes: []}

  setParent: (parent) ->
    traverseOneLevel @start, ((head)->
      head.setParent parent
    ), @end

  # ## clone ##
  # Clone this container, with all the token inside,
  # but with no linked-list pointers in common.
  clone: ->
    assembler = head = {}

    @traverseOneLevel (head) =>
      # If we have hit a container,
      # ask it to clone, so that
      # we copy over appropriate metadata.
      if head instanceof Container
        clone = head.clone()
        helper.connect assembler, clone.start
        assembler = clone.end

      # Otherwise, helper.connect just, a cloned
      # version of this token.
      else
        assembler = helper.connect assembler, head.clone()

    head = head.next; head.prev = null

    clone = new List head, assembler
    clone.correctParentTree()

    return clone

  # ## correctParentTree ##
  # Generally called immediately after assembling
  # a token stream by hand; corrects the entire
  # parent tree for the linked list.
  correctParentTree: ->
    @traverseOneLevel (head) =>
      head.parent = this
      if head instanceof Container
        head.start.parent = head.end.parent = this
        head.correctParentTree()

  # ## stringify ##
  # Get a string representation of us,
  # using the `stringify()` method on all of
  # the tokens that we contain.
  stringify: ->
    head = @start
    str = head.stringify()

    until head is @end
      head = head.next
      str += head.stringify()

    return str

  stringifyInPlace: ->
    str = ''

    indent = []

    head = @start
    while true
      if head instanceof IndentStartToken
        indent.push head.container.prefix
      else if head instanceof IndentEndToken
        indent.pop()
      if head instanceof NewlineToken
        str += '\n' + (head.specialIndent ? indent.join(''))
      else
        str += head.stringify()

      if head is @end
        break
      head = head.next

    return str

# Container
# ==================
# A generic XML-style container from which
# all other containers (Block, Indent, Socket) will extend.
exports.Container = class Container extends List
  constructor: ->
    unless @start? or @end?
      @start = new StartToken this
      @end = new EndToken this

      @type = 'container'

    @id = ++_id
    @parent = null
    @version = 0
    helper.connect @start, @end

    @ephemeral = false

    # Line mark colours
    @lineMarkStyles = []

  # A `Container`'s location is its start's location
  # with the container's type
  getLocation: ->
    location = @start.getLocation()
    location.type = @type
    return location
  getTextLocation: ->
    location = @start.getTextLocation()
    location.type = @type
    return location

  # _cloneEmpty should simply instantiate
  # a new instance of this Container
  # with the same metadata.
  _cloneEmpty: -> new Container()

  # Utility function to first block
  # child if an indent/segment
  _firstChild: ->
    head = @start.next
    while head isnt @end
      if head instanceof StartToken
        return head.container
      head = head.next
    return null

  getReader: ->
    {
      id: @id
      type: @type
      precedence: @precedence
      classes: @classes
    }

  setParent: (parent) ->
    @parent = @start.parent = @end.parent = parent

  hasParent: (parent) ->
    head = @
    until head in [parent, null]
      head = head.parent

    return head is parent

  getLinesToParent: ->
    head = @start; lines = 0
    until head is @parent.start
      lines++ if head.type is 'newline'
      head = head.prev
    return lines

  clone: ->
    selfClone = @_cloneEmpty()
    assembler = selfClone.start

    @traverseOneLevel (head) =>
      # If we have hit a container,
      # ask it to clone, so that
      # we copy over appropriate metadata.
      if head instanceof Container
        clone = head.clone()
        helper.connect assembler, clone.start
        assembler = clone.end

      # Otherwise, helper.connect just, a cloned
      # version of this token.
      else
        assembler = helper.connect assembler, head.clone()

    helper.connect assembler, selfClone.end
    selfClone.correctParentTree()

    return selfClone

  rawReplace: (other) ->
    if other.start.prev?
      helper.connect other.start.prev, @start

    if other.end.next?
      helper.connect @end, other.end.next

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
        @end.prev.insert new TextToken value

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

  # ## notifyChange ##
  # Increase version number (for caching purposes)
  notifyChange: ->
    head = this
    while head?
      head.version++
      head = head.parent

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

    while head?.type is 'newline' or (head instanceof StartToken and head.type isnt 'blockStart')
      head = head.next
    if head?.type is 'blockStart' then stack.push head.container

    return stack[stack.length - 1]

  # ## traverseOneLevel ##
  # Identical to the utility function below;
  # traverse one tree level between our
  # start and end tokens.
  traverseOneLevel: (fn) ->
    unless @start.next is @end
      traverseOneLevel @start.next, fn, @end.prev

  # Line mark mutators
  addLineMark: (mark) ->
    @lineMarkStyles.push mark

  removeLineMark: (tag) ->
    @lineMarkStyles = (mark for mark in @lineMarkStyles when mark.tag isnt tag)

  clearLineMarks: ->
    @lineMarkStyles = []

  getFromLocation: (location) ->
    head = @start
    for [0...location.count]
      head = head.next

    if location.type is head.type
      return head
    else if location.type is head.container.type
      return head.container
    else
      throw new Error "Could not retrieve location #{location}"

  # ## getFromTextLocation ##
  # Given a TextLocation, find the token at that row, column, and length.
  getFromTextLocation: (location) ->
    head = @start
    best = head

    row = 0

    until not head? or row is location.row
      head = head.next
      if head instanceof NewlineToken
        row += 1

    # If the coordinate is invalid,
    # just return as close as we can get
    # (our last token)
    if not head?
      return @end
    else
      best = head

    if head instanceof NewlineToken
      col = head.stringify().length - 1
      head = head.next
    else
      col = head.stringify().length

    until (not head? or head instanceof NewlineToken) or col >= location.col
      col += head.stringify().length
      head = head.next

    # Again, if the coordinate was invalid,
    # return as close as we can get
    if col < location.col
      return head ? @end
    else
      best = head

    # Go forward until we are the proper length
    # or the column changed
    if location.length?
      until (not head? or head.stringify().length > 0) or
            ((head.container ? head).stringify().length is location.length)
        head = head.next

      if head? and
          (head.container ? head).stringify().length is location.length
        best = head
      else
        head = best

    # Go forward until we are the proper token type
    # or the column changed
    if location.type?
      until (not head? or head.stringify().length > 0) or
          head.type is location.type or
          head.container.type is location.type
        head = head.next

      if head?.container?.type is location.type
        head = head.container

      if head?.type is location.type
        best = head

    return best

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

  setParent: (@parent) ->

  hasParent: (parent) ->
    head = @
    until head in [parent, null]
      head = head.parent

    return head is parent

  insert: (token) ->
    token.next = @next; token.prev = this
    @next.prev = token; @next = token

    if @ instanceof StartToken
      token.parent = @container
    else
      token.parent = parent

    return token

  remove: ->
    if @prev? then helper.connect @prev, @next
    else if @next? then @next.prev = null

    @prev = @next = @parent = null

  notifyChange: ->
    head = this
    while head?
      head.version++
      head = head.parent

    return null

  isFirstOnLine: ->
    return @prev is @parent?.start or
      @prev?.type is 'newline'

  isLastOnLine: ->
    return @next is @parent?.end or
      @next?.type in ['newline', 'indentEnd']

  clone: -> new Token()

  getSerializedLocation: ->
    head = this; count = 0
    until head is null
      count++
      head = head.prev
    return count

  # Get the indent level here
  getIndent: ->
    head = @
    prefix = ''
    while head?
      if head.type is 'indent'
        prefix = head.prefix + prefix
      head = head.parent
    return prefix

  getTextLocation: ->
    location = new TextLocation(); head = @prev

    location.type = @type
    if @ instanceof StartToken or @ instanceof EndToken
      location.length = @container.stringify().length
    else
      location.length = @stringify().length

    until (not head?) or head instanceof NewlineToken
      location.col += head.stringify().length
      head = head.prev
    if head?
      location.col += head.stringify().length - 1

    while head?
      if head instanceof NewlineToken
        location.row += 1
      head = head.prev

    return location

  getDocument: ->
    head = @container ? @
    until not head? or head instanceof Document
      head = head.parent
    return head

  getLocation: ->
    count = 0
    head = @
    dropletDocument = @getDocument()

    until head is dropletDocument.start
      head = head.prev
      count += 1

    return new Location count, @type

  stringify: -> ''
  serialize: -> ''

exports.Location = class Location
  constructor: (@count, @type) ->

  toString: -> "#{@count}, #{@type}"

  set: (other) -> @count = other.count; @type = other.type

  is: (other) ->
    unless other instanceof Location
      other = other.getLocation()
    return other.count is @count and other.type is @type

  clone: -> new Location @count, @type

exports.TextLocation = class TextLocation
  constructor: (
    @row = 0,
    @col = 0,
    @type = null,
    @length = null
  ) ->

  toString: -> "(#{@row}, #{@col}, #{@type}, #{@length})"

  set: (other) ->
    @row = other.row
    @col = other.col
    @type = other.type
    @length = other.length

  is: (other) ->
    unless other instanceof TextLocation
      other = other.getLocation()

    answer = other.row is @row and other.col is @col and

    if @type? and other.type?
      answer = answer and @type is other.type

    if @length? and other.length?
      answer = answer and @length is other.length

    return answer

exports.StartToken = class StartToken extends Token
  constructor: (@container) ->
    super; @markup = 'begin'

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
  constructor: (@precedence = 0, @color = 'blank', @socketLevel = helper.ANY_DROP, @classes = [], @parseContext, @buttons = {}) ->
    @start = new BlockStartToken this
    @end = new BlockEndToken this

    @type = 'block'

    super

  nextSibling: ->
    head = @end.next
    parent = head.parent
    while head and head.container isnt parent
      if head instanceof StartToken
        return head.container
      head = head.next
    return null

  _cloneEmpty: ->
    clone = new Block @precedence, @color, @socketLevel, @classes, @parseContext, @buttons
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

exports.SocketEndToken = class SocketEndToken extends EndToken
  constructor: (@container) -> super; @type = 'socketEnd'

  stringify: ->
    if @prev is @container.start or
        @prev.type is 'text' and @prev.value is ''
      return @container.emptyString
    else ''

exports.Socket = class Socket extends Container
  constructor: (@emptyString, @parseContext, @precedence = 0, @handwritten = false, @classes = [], @dropdown = null) ->
    @start = new SocketStartToken this
    @end = new SocketEndToken this

    @type = 'socket'

    super

  textContent: ->
    head = @start.next; str = ''
    until head is @end
      str += head.stringify()
      head = head.next
    return str

  hasDropdown: -> @dropdown? and @isDroppable()

  editable: -> (not (@dropdown? and @dropdown.dropdownOnly)) and @isDroppable()

  isDroppable: -> @start.next is @end or @start.next.type is 'text'

  _cloneEmpty: -> new Socket @emptyString, @parseContext, @precedence, @handwritten, @classes, @dropdown

  _serialize_header: -> "<socket precedence=\"#{
      @precedence
    }\" handwritten=\"#{
      @handwritten
    }\" classes=\"#{
      @classes?.join?(' ') ? ''
    }\"#{
      if @dropdown?
        " dropdown=\"#{@dropdown?.join?(' ') ? ''}\""
      else ''
    }>"

  _serialize_footer: -> "</socket>"

# Indent
# ==================

exports.IndentStartToken = class IndentStartToken extends StartToken
  constructor: (@container) -> super; @type = 'indentStart'

exports.IndentEndToken = class IndentEndToken extends EndToken
  constructor: (@container) -> super; @type = 'indentEnd'
  stringify: ->
    if @prev.prev is @container.start
      return @container.emptyString
    else ''
  serialize: -> "</indent>"

exports.Indent = class Indent extends Container
  constructor: (@emptyString, @prefix = '', @classes = []) ->
    @start = new IndentStartToken this
    @end = new IndentEndToken this

    @type = 'indent'

    @depth = @prefix.length

    super

  _cloneEmpty: -> new Indent @emptyString, @prefix, @classes
  firstChild: -> return @_firstChild()

  _serialize_header: -> "<indent prefix=\"#{
    @prefix
  }\" classes=\"#{
    @classes?.join?(' ') ? ''
  }\">"
  _serialize_footer: -> "</indent>"


# Document
# ==================

exports.DocumentStartToken = class DocumentStartToken extends StartToken
  constructor: (@container) -> super; @type = 'documentStart'
  serialize: -> "<document>"

exports.DocumentEndToken = class DocumentEndToken extends EndToken
  constructor: (@container) -> super; @type = 'documentEnd'
  serialize: -> "</document>"

exports.Document = class Document extends Container
  constructor: (@opts = {}) ->
    @start = new DocumentStartToken this
    @end = new DocumentEndToken this
    @classes = ['__document__']

    @type = 'document'

    super

  _cloneEmpty: -> new Document(@opts)
  firstChild: -> return @_firstChild()

  _serialize_header: -> "<document>"
  _serialize_footer: -> "</document>"


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

  stringify: -> @_value
  serialize: -> helper.escapeXMLText @_value

  clone: -> new TextToken @_value

exports.NewlineToken = class NewlineToken extends Token
  constructor: (@specialIndent) -> super; @type = 'newline'
  stringify: -> '\n' + (@specialIndent ? @getIndent())
  serialize: -> '\n'
  clone: -> new NewlineToken @specialIndent

# Utility function for traversing all
# the blocks at the same nesting depth
# as the head token.
traverseOneLevel = (head, fn, tail) ->
  while true
    if head instanceof StartToken
      fn head.container
      head = head.container.end
    else
      fn head

    if head is tail
      return

    head = head.next
