
define ['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], (helper, model, parser, acorn) ->
  COLORS = {
    'SequenceExpression': 'command'
  }
  STATEMENT_NODE_TYPES = [
    'ExpressionStatement'
  ]


  class javscript extends parser.Parser
    constructor: (@text, @opts = {}) ->
        super
        @lines = @text.split '\n'
        #console.log(@text)

    getcsvBounds: (line, start, end) ->
      return {
        start: {
          line: line
          column: start
        }
        end: {
          line: line
          column: end
        }
      }

    getColor: () ->
      return 'violet'

    getSocketLevel: () -> helper.ANY_DROP
    getAcceptsRule: () -> default: helper.NORMAL

    getClasses: () ->
      return ['mostly-value']

    markRoot: ->
        
        #console.log @text
        #console.log @lines
        
        for line, i in @lines
          @cur = line.split ','
          #console.log i
          console.log @cur
          # Not allowing the blocks of zero length
          if line.length > 0
            @addBlock
              bounds: @getcsvBounds i, 0, line.length
              depth: 1
              precedence: 0
              color: @getColor 
              classes: @getClasses 
              socketLevel: @getSocketLevel 
            st = 0
            # Not allowing the sockets of zero length
            for cr, j in @cur
              #console.log sp
              if cr.length > 0
                #console.log st
                #console.log st + cr.length
                
                @addSocket
                  bounds: @getcsvBounds i, st, st+cr.length
                  depth: 2
                  precedence: 0
                  classes: []
                  accepts: @getAcceptsRule 
                
                st = st + cr.length + 1

    isComment: (str) ->
      str.match(/^\s*#.*$/)?

  return parser.wrapParser javscript
