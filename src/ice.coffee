class Socket
  constructor: (type, child) ->
    switch type
      when 'static'
      when 'inline'
      when 'block'

class Line
  constructor: (parent, type, sockets) ->

    # Tree 
    @parent = parent
    @sockets = sockets or []
    @type = type

    # Next and previous blocks
    @previous = null
    @next = null

    # Block associated with this object
    @block = new BlockPaper this, {}

class Block
  ###
  # A Block is the tree node associated with a draggable ICE Block.
  ###
  constructor: (parent, type, sockets) ->

    # Tree 
    @parent = parent
    @sockets = sockets or []
    @type = type

    # Next and previous blocks
    @previous = null
    @next = null

    # Block associated with this object
    @block = new BlockPaper this, {}

  toString: -> (socket.toString() for socket in @sockets).join ''
  
  stringify: ->
    if @next? then @toString() + '\n' + @next.stringify()
    else @toString()

class SocketPaper
  constructor: (tree, options) ->
    options = _.extend {
      position: new paper.Point 0, 0
      width: 20
    }

class BlockPaper
  constructor: (tree, options) ->
    options = _.extend {
      position: new paper.Point 0, 0
      width: 100
    }, options

    @_width = options.width
    @tree = tree
    @block = new paper.Path
      segments: [
        [0, 0]

        # Tab
        [10, 0]
        [20, 5]
        [30, 0]

        # Right edge
        [@_width, 0]
        [@_width, 30]

        # Tab
        [30, 30]
        [20, 35]
        [10, 30]

        # Left edge
        [0, 30]
        [0, 0]
      ]
      fillColor: '#000'

    @drop = new paper.Path
      segments: [
        # Bottom bit
        [0, 25]
        [10, 25]
        [20, 30]
        [30, 25]
        [100, 25]

        # Top bit
        [100, 35]
        [30, 35]
        [20, 40]
        [10, 35]
        [0, 35]
        [0, 25]
      ]

    @hang = new paper.Path
      segments: [
        # Bottom bit
        [0, 5]
        [10, 5]
        [20, 10]
        [30, 5]
        [100, 5]

        # Top bit
        [100, -10]
        [30, -10]
        [20, -5]
        [10, -10]
        [0, -10]
        [0, 5]
      ]
    
    @unit = new paper.Group [@block, @drop, @hang]
    @unit.translate options.position

  width: (set) ->
    if set?
      @block.segments[4].point.x += set - @_width
      @block.segments[5].point.x += set - @_width
      @_width = set
    else
      return @_width

  _recomputeWidth: ->
    for socket in @tree.sockets

window.onload = ->
  canvas = document.getElementById 'canvas'
  paper.setup canvas

  paths = []
  dragging = []
  
  for i in [1..5]
    paths.push new BlockPaper null,
      position: new paper.Point [i * 100, i * 100]

    tool = new paper.Tool()
    
    tool.onMouseDown = (event) ->
      dragging.length = 0
      for path in paths
        if path.block.contains event.point
          dragging.push path
          path.width 100 + path.width()
          break

    tool.onMouseDrag = (event) ->
      for path, x in dragging
        path.unit.translate event.delta
        for other in paths
          other.drop.fillColor = null
        for other in paths
          if other isnt path and path.hang.getIntersections(other.drop).length > 0
            other.drop.fillColor = 'red'
            break

    tool.onMouseUp = (event) ->
      for path, x in dragging
        for other in paths
          other.drop.fillColor = null
        for other in paths
          if other isnt path and path.hang.getIntersections(other.drop).length > 0
            other.drop.fillColor = 'red'
            console.log other.drop.position.toString(), path.hang.position.toString()
            path.unit.translate other.drop.position.subtract path.hang.position
            break
