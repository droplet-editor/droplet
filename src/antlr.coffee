# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model', 'droplet-parser', 'antlr'], (helper, model, parser, antlr) ->
  exports = {}

  exports.createANTLRParser = (config, name, root) ->
    root ?= 'compilationUnit'

    getBounds = (node) ->
      if node.start? and node.stop?
        return {
          start: {
            line: node.start.line - 1
            column: node.start.column
          }
          end: {
            line: node.stop.line - 1
            column: node.stop.column + node.stop.stop - node.stop.start + 1
          }
        }
      else
        return {
          start: {
            line: node.symbol.line - 1
            column: node.symbol.column
          }
          end: {
            line: node.symbol.line - 1
            column: node.symbol.column + node.symbol.stop - node.symbol.start + 1
          }
        }

    removeParens = (text, expressionType) ->
      chars = new antlr.antlr4.InputStream(text)
      lexer = new antlr["#{name}Lexer"]["#{name}Lexer"](chars)
      tokens = new antlr.antlr4.CommonTokenStream(lexer)
      parser = new antlr["#{name}Parser"]["#{name}Parser"](tokens)

      lines = text.split '\n'

      parser.buildParseTrees = true
      parseTree = parser[expressionType]()
      while parseTree.children? and
            parseTree.children.length is 1 and
            parseTree.parser.ruleNames[parseTree.ruleIndex] is expressionType
        parseTree = parseTree.children[0]

      {start, end} = getBounds parseTree

      return helper.clipText lines, start, end

    class ANTLRParser extends parser.Parser
      constructor: (@text, @opts = {}) ->
        super

        # Construct but do not execute all of the necessary ANTLR accessories
        @chars = new antlr.antlr4.InputStream(@text)
        @lexer = new antlr["#{name}Lexer"]["#{name}Lexer"](@chars)
        @tokens = new antlr.antlr4.CommonTokenStream(@lexer)
        @parser = new antlr["#{name}Parser"]["#{name}Parser"](@tokens)

        @lines = @text.split '\n'

      isComment: (text) ->
        text.match(/^\s*\/\/.*$/)

      markRoot: (context = root) ->
        # Build the actual parse tree
        @parser.buildParseTrees = true
        parseTree = @parser[context]()

        # Parse
        @mark parseTree, '', 0

      guessPrefix: (bounds) ->
        votes = {}
        for i in [bounds.start.line + 1..bounds.end.line]
          line = @lines[i]
          prefix = line[0...line.length - line.trimLeft().length]
          votes[prefix] ?= 0
          votes[prefix] += 1
        max = -Infinity; best = ''
        for key, val of votes
          if val > max
            best = key
            max = val
        return best


      det: (rule) ->
        if rule in config.INDENTS then return 'indent'
        else if rule in config.SKIPS then return 'skip'
        else if rule in config.PARENS then return 'parens'
        else return 'block'

      detNode: (node) -> @det(node.parser.ruleNames[node.ruleIndex])
      detToken: (node) ->
        if node.symbol?
          if (node.parser ? node.parentCtx.parser).symbolicNames[node.symbol.type] in config.SOCKET_TOKENS then 'socket' else 'none'
        else 'none'

      getDropType: (context) -> ({
        'block': 'mostly-value'
        'indent': 'mostly-block'
        'skip': 'mostly-block'
      })[@detNode(context)]

      getColor: (rules) ->
        for el, i in rules by -1
          if el of config.COLORS_BACKWARD
            return config.COLORS_BACKWARD[el]
        for el, i in rules
          if el of config.COLORS_FORWARD
            return config.COLORS_FORWARD[el]
        return 'violet'

      mark: (node, prefix, depth, pass, rules, context, wrap) ->
        unless pass
          context = node.parentCtx
          while context? and @detNode(context) is 'skip'
            context = context.parentCtx

        rules ?= []
        if node.ruleIndex?
          rules.push node.parser.ruleNames[node.ruleIndex]

        # Pass through to child
        if node.children? and node.children.length is 1
          @mark node.children[0], prefix, depth, true, rules, context, wrap

        else if node.children?
          switch @detNode node
            when 'block'
              if wrap?
                bounds = getBounds wrap
              else
                bounds = getBounds node

              if context? and @detNode(context) is 'block'
                @addSocket
                  bounds: bounds
                  depth: depth
                  classes: rules

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor rules
                classes: rules.concat(if context? then @getDropType(context) else 'any-drop')
                parseContext: (if wrap? then wrap.parser.ruleNames[wrap.ruleIndex] else rules[0])

            when 'parens'
              # Parens are assumed to wrap the only child that has children
              child = null; ok = true
              for el, i in node.children
                if el.children?
                  if child?
                    ok = false
                    break
                  else
                    child = el
              if ok
                @mark child, prefix, depth, true, rules, context, wrap ? node
                return

              else
                if wrap?
                  bounds = getBounds wrap
                else
                  bounds = getBounds node

                if context? and @detNode(context) is 'block'
                  @addSocket
                    bounds: bounds
                    depth: depth
                    classes: rules

                @addBlock
                  bounds: bounds
                  depth: depth + 1
                  color: @getColor rules
                  classes: rules.concat(if context? then @getDropType(context) else 'any-drop')
                  parseContext: (if wrap? then wrap.parser.ruleNames[wrap.ruleIndex] else rules[0])

            when 'indent'
              start = getBounds(node.children[0]).start
              for child, i in node.children
                if child.children?
                  break
                else
                  start = getBounds(child).end

              end = getBounds(node.children[node.children.length - 1]).end
              for child, i in node.children by -1
                if child.children?
                  end = getBounds(child).end
                  break

              bounds = {
                start: start
                end: end
              }

              oldPrefix = prefix
              prefix = @guessPrefix bounds

              @addIndent
                bounds: bounds
                depth: depth
                prefix: prefix[oldPrefix.length...prefix.length]

          for child in node.children
            @mark child, prefix, depth + 2, false
        else if context? and @detNode(context) is 'block'
          if @detToken(node) is 'socket'
            @addSocket
              bounds: getBounds node
              depth: depth
              classes: rules

    ANTLRParser.drop = (block, context, pred) ->
      if context.type is 'socket'
        for c in context.classes
          if c in block.classes
            return helper.ENCOURAGE
          else
            return helper.DISCOURAGE

    # Doesn't yet deal with parens
    ANTLRParser.parens = (leading, trailing, node, context) ->

    return ANTLRParser

  return exports
