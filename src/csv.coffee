###
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
###

define ['droplet-helper', 'droplet-parser'], (helper, parser) ->
  
  exports = {}

  COLORS = {
    'Default': 'violet'
  }

  MOSTLY_VALUE = ['mostly-value']


  exports.CSVParser = class CSVParser extends parser.Parser
    
    constructor: (@text, @opts = {}) ->
      super
      @lines = @text.split '\n'
      @text = @text

    getAcceptsRule: (node) -> default: helper.NORMAL

    getPrecedence: (node) -> 1

    getClasses: (node) -> MOSTLY_VALUE

    getColor: (node) -> COLORS['Default']

    getBounds: (node) ->
      return bounds = {
        start: {
          line: node.index
          column: node.start
        }
        end: {
          line: node.index
          column: node.end
        }
      }

    getSocketLevel: (node) -> helper.ANY_DROP

    csvBlock: (node) ->
      @addBlock
        bounds: @getBounds node
        depth: 0
        precedence: @getPrecedence node
        color: @getColor node
        socketLevel: @getSocketLevel node

    csvSocket: (node) ->
      @addSocket
        bounds: @getBounds node
        depth: 1
        precedence: @getPrecedence node
        classes: @getClasses node
        acccepts: @getAcceptsRule node

    markRoot: ->
      root = @CSVtree @text
      @mark root

    mark: (node) ->
      if node.type is 'Statement'
        @csvBlock node
      else if node.type is 'Value'
        @csvSocket node

      for child in node.children
        @mark child


    CSVtree: (text) ->
      ###
        Structure of node:
        node->index = line number
        node->type = Tree/Statement/Value/Comment
        node->start = starting character
        node->end = ending character
        node->children = children
      ###
      return @getNode text, 'Tree'

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

    getNode: (text, type, index, start, end) ->
      node = {}
      node.index = index
      node.type = type
      node.start = start
      node.end = end
      node.children = []
      if type is 'Tree'
        text = text.split '\n'
        for row, i in text
          if (row.length is 0) or (@isComment row)
            node.children.push @getNode(row, 'Comment', i, 0, row.length)
          else
            node.children.push @getNode(row, 'Statement', i, 0, row.length)
      else if type is 'Statement'
        text = text.split ','
        tot = 0
        for val in text
          start = 0
          end = val.length
          while start != end
            if val[start] == " "
              start += 1
            else if val[end-1] == " "
              end -= 1
            else
              break
          node.children.push @getNode val, 'Value', index, start+tot, end+tot
          tot += val.length + 1
      return node

  CSVParser.parens = (leading, trainling, node, context) ->
    return [leading, trainling]

  return parser.wrapParser CSVParser
