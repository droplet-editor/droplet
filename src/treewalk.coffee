# Droplet Treewalker framework.
#
# Copyright (c) Anthony Bau (dab1998@gmail.com)
# MIT License
helper = require './helper.coffee'
model = require './model.coffee'
parser = require './parser.coffee'

Graph = require 'node-dijkstra'

exports.createTreewalkParser = (parse, config, root) ->
  class TreewalkParser extends parser.Parser
    constructor: (@text, @opts = {}) ->
      super

      @lines = @text.split '\n'

    isComment: (text) ->
      if config?.isComment?
        return config.isComment(text)
      else
        return false

    parseComment: (text) ->
      return config.parseComment text

    markRoot: (context = root) ->
      parseTree = parse(context, @text)

      # Parse
      @mark parseTree, '', 0

    guessPrefix: (bounds) ->
      line = @lines[bounds.start.line + 1]
      return line[0...line.length - line.trimLeft().length]

    applyRule: (rule, node) ->
      if 'string' is typeof rule
        return {type: rule}
      else if rule instanceof Function
        return rule(node)
      else
        return rule

    det: (node) ->
      if node.type of config.RULES
        return @applyRule(config.RULES[node.type], node).type
      return 'block'

    detNode: (node) -> if node.blockified then 'block' else @det(node)

    getColor: (node) ->
      color = config.COLOR_CALLBACK?(@opts, node)
      if color?
        return color

      else if node.type of config.COLOR_RULES
        return config.COLOR_RULES[node.type]

      else
        return 'comment'

    getShape: (node, rules) ->
      shape = config.SHAPE_CALLBACK?(@opts, node)
      if shape?
        return shape

      else if node.type of config.SHAPE_RULES
        return config.SHAPE_RULES[node.type]

      else
        return helper.ANY_DROP

    mark: (node, prefix, depth, pass, rules, context, wrap) ->
      unless pass
        context = node.parent
        while context? and @detNode(context) in ['skip', 'parens']
          context = context.parent

      rules ?= []
      rules = rules.slice 0

      unless wrap?
        rules.push node.type

      # Pass through to child if single-child
      if node.children.length is 1 and @detNode(node) isnt 'indent'
        @mark node.children[0], prefix, depth, true, rules, context, wrap

      else if node.children.length > 0
        switch @detNode node
          when 'block'
            if wrap?
              bounds = wrap.bounds
            else
              bounds = node.bounds

            if context? and @detNode(context) is 'block'
              @addSocket
                bounds: bounds
                depth: depth
                parseContext: rules[0]

            @addBlock
              bounds: bounds
              depth: depth + 1
              color: @getColor node
              shape: @getShape node
              parseContext: rules[rules.length - 1]

          when 'parens'
            # Parens are assumed to wrap the only child that has children
            child = null; ok = true
            for el, i in node.children
              if el.children.length > 0
                if child?
                  ok = false
                  break
                else
                  child = el
            if ok
              @mark child, prefix, depth, true, rules, context, wrap ? node
              return

            else
              node.blockified = true

              if wrap?
                bounds = wrap.bounds
              else
                bounds = node.bounds

              if context? and @detNode(context) is 'block'
                @addSocket
                  bounds: bounds
                  depth: depth
                  parseContext: rules[0]

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor node
                shape: @getShape node
                parseContext: rules[rules.length - 1]

          when 'indent'
            # A lone indent needs to be wrapped in a block.
            if @det(context) isnt 'block'
              @addBlock
                bounds: node.bounds
                depth: depth
                color: @getColor node
                shape: @getShape node
                parseContext: rules[rules.length - 1]

              depth += 1

            start = origin = node.children[0].bounds.start
            for child, i in node.children
              if child.children.length > 0
                break
              else unless helper.clipLines(@lines, origin, child.bounds.end).trim().length is 0 or i is node.children.length - 1
                start = child.bounds.end

            end = node.children[node.children.length - 1].bounds.end
            for child, i in node.children by -1
              if child.children.length > 0
                end = child.bounds.end
                break
              else unless i is 0
                end = child.bounds.start
                if @lines[end.line][...end.column].trim().length is 0
                  end.line -= 1
                  end.column = @lines[end.line].length

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
              indentContext: @applyRule(config.RULES[node.type], node).indentContext

        for child in node.children
          @mark child, prefix, depth + 2, false
      else if context? and @detNode(context) is 'block'
        if @det(node) is 'socket' and ((not config.SHOULD_SOCKET?) or config.SHOULD_SOCKET(@opts, node))
          @addSocket
            bounds: node.bounds
            depth: depth
            parseContext: rules[0]

          if config.empty? and not @opts.preserveEmpty and helper.clipLines(@lines, node.bounds.start, node.bounds.end) is config.empty
            @flagToRemove node.bounds, depth + 1

  if config.droppabilityGraph?
    droppabilityGraph = new Graph(config.droppabilityGraph)
    parenGraph = new Graph(config.parenGraph)

    TreewalkParser.drop = (block, context, pred) ->
      parseContext = context.indentContext ? context.parseContext
      if helper.dfs(parenGraph, parseContext, block.parseContext)
        return helper.ENCOURAGE
      else
        return helper.FORBID

    TreewalkParser.parens = (leading, trailing, node, context) ->
      if context is null
        return [leading, trailing, node.parseContext]

      parseContext = context.indentContext ? context.parseContext
      if helper.dfs(droppabilityGraph, parseContext, node.parseContext)
        return [leading, trailing, node.parseContext]

      else
        path = parenGraph.shortestPath(parseContext, node.parseContext, {reverse: true})
        console.log 'Paren wrap required in path', path
        for element, i in path when i > 0
          if config.PAREN_RULES[path[i]]?[path[i - 1]]?

            console.log 'Applying paren to form', path[i], 'from', path[i - 1]

            [leading, trailing] = config.PAREN_RULES[path[i]][path[i - 1]](leading, trailing, node, context)

            node.parseContext = path[i]

        return [leading, trailing, node.parseContext]

  else if config.drop?
    TreewalkParser.drop = config.drop
    TreewalkParser.parens = config.parens ? ->

  TreewalkParser.stringFixer = config.stringFixer
  TreewalkParser.rootContext = config.rootContext
  TreewalkParser.getDefaultSelectionRange = config.getDefaultSelectionRange
  TreewalkParser.empty = config.empty

  return TreewalkParser
