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

    getAcceptsRule: (index) -> default: helper.NORMAL

    getPrecedence: (index) ->
      return 1

    getClasses: (index) ->
      return MOSTLY_VALUE

    getColor: (index) ->
      return COLORS['Default']

    getBounds: (index, start, end) ->
      return bounds = {
        start: {
          line: index
          column: start
        }
        end: {
          line: index
          column: end
        }
      }

    getSocketLevel: (index) -> helper.ANY_DROP

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

    csvBlock: (index) ->
      @addBlock
        bounds: @getBounds index, 0, @lines[index].length
        depth: 0
        precedence: @getPrecedence index
        color: @getColor index
        socketLevel: @getSocketLevel index

    csvSocket: (index, start, end) ->
      @addSocket
        bounds: @getBounds index, start, end
        depth: 1
        precedence: @getPrecedence index
        classes: @getClasses index
        acccepts: @getAcceptsRule index

    parseLine: (line, index) ->
      line = line.concat(',')
      started = false
      start = 0
      end = 0
      for ch, j in line
        if ch == ','
          end = j
          @csvSocket index, start, end
          start = j+1

    markRoot: ->
      for line, i in @lines
        if line != '' and not @isComment(line)
          @csvBlock i
          @parseLine line, i

  return parser.wrapParser CSVParser
