# Droplet model.
#
# Copyright (c) 2014 Anthony Bau
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
    @location = list.start.prev.getLocation()

    @list = list.clone()

    @start = list.start.getLocation()
    @end = list.end.getLocation()

  toString: -> JSON.stringify({
    location: @location.toString()
    list: @list.stringify()
    start: @start.toString()
    end: @end.toString()
  })

exports.List = class List
  constructor: (@start, @end) ->
    @id = ++_id

  # ## insert ##
  # Insert another list into us
  # and return an (undoable) record
  # of this operation
  insert: (token, list) ->
    [first, last] = [list.start, list.end]

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
    return new Operation 'insert', list

  # ## remove ##
  # Remove ourselves from the linked
  # list that we are in.
  remove: (list) ->
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

    # Make an undo operation
    record = new Operation 'remove', list
    location = list.start.prev

    helper.connect list.start.prev, list.end.next
    list.start.prev = list.end.next = null
    list.setParent null

    # Correct the location in case
    # lengths or coordinates changed
    record.location = location.getLocation()

    # Return the undo operation
    return record

  perform: (operation, direction) ->
    if (operation.type is 'insert') isnt (direction is 'forward')
      list = new List @getFromLocation(operation.start), @getFromLocation(operation.end)
      list.notifyChange()
      helper.connect list.start.prev, list.end.next
      return new Operation 'remove', list
    else
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

      return new Operation 'insert', list

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
    until head is @end
      if head instanceof IndentStartToken
        indent.push head.container.prefix
      else if head instanceof IndentEndToken
        indent.pop()
      else if head instanceof NewlineToken
        str += '\n' + (head.specialIndent ? indent.join(''))
      else
        str += head.stringify()
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

  # ## getFromLocation ##
  # Given a DropletLocation, find the token at that row, column, and length.
  getFromLocation: (location) ->
    head = @start

    row = 0

    until row is location.row
      head = head.next
      if head instanceof NewlineToken
        row += 1

    if head instanceof NewlineToken
      col = head.stringify().length - 1
    else
      col = head.stringify().length

    until col >= location.col
      head = head.next
      col += head.stringify().length

    # If _we_ were the one who made the length equal,
    # move over; locations always refer to the _start_ of the token.
    if col is location.col and head.stringify().length > 0
      head = head.next

    if location.length?
      until (head.container ? head).stringify().length is location.length
        head = head.next

    if location.type?
      until head.type is location.type
        head = head.next

    return head

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

  getLocation: () ->
    location = new DropletLocation(); head = @prev

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

  stringify: -> ''
  serialize: -> ''

class DropletLocation
  constructor: (
    @row = 0,
    @col = 0,
    @type = null,
    @length = null
  ) ->

  toString: -> "(#{@row}, #{@col}, #{@type}, #{@length})"

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
  constructor: (@precedence = 0, @color = 'blank', @socketLevel = helper.ANY_DROP, @classes = []) ->
    @start = new BlockStartToken this
    @end = new BlockEndToken this

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
  stringify: ->
    if @next is @container.end or
        @next.type is 'text' and @next.value is ''
      return @container.emptyString
    else ''

exports.SocketEndToken = class SocketEndToken extends EndToken
  constructor: (@container) -> super; @type = 'socketEnd'

exports.Socket = class Socket extends Container
  constructor: (@emptyString, @precedence = 0, @handwritten = false, @classes = [], @dropdown = null) ->
    @start = new SocketStartToken this
    @end = new SocketEndToken this

    @type = 'socket'

    super

  hasDropdown: -> @dropdown? and @isDroppable()

  editable: -> (not (@dropdown? and @dropdown.dropdownOnly)) and @isDroppable()

  isDroppable: -> @start.next is @end or @start.next.type is 'text'

  _cloneEmpty: -> new Socket @emptyString, @precedence, @handwritten, @classes, @dropdown

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
  constructor: ->
    @start = new DocumentStartToken this
    @end = new DocumentEndToken this
    @classes = ['__document__']

    @type = 'document'

    super

  _cloneEmpty: -> new Document()

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
