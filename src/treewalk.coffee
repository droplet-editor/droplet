# Droplet Treewalker framework.
#
# Copyright (c) Anthony Bau (dab1998@gmail.com)
# MIT License
helper = require './helper.coffee'
model = require './model.coffee'
parser = require './parser.coffee'

Graph = require 'node-dijkstra'

EMPTY_OBJECT = {}

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

    handleButton: ->
      if config.handleButton?
        config.handleButton.apply @, arguments

    parseComment: (text) ->
      return config.parseComment text

    preparse: (context = root) -> parse(context, @text)

    markRoot: (context = root, cachedParse = null) ->
      if cachedParse?
        parseTree = cachedParse
      else
        parseTree = parse(context, @text)

      # Parse
      @mark parseTree, '', 0

    guessPrefix: (bounds) ->
      line = @lines[bounds.start.line + 1]
      return line[0...line.length - line.trimLeft().length]

    applyRule: (node) ->
      if node._cachedApplication?
        return node._cachedApplication

      rule = config.RULES[node.type]

      if rule instanceof Function
        rule = rule(node, @opts)

      if 'string' is typeof rule
        rule = {type: rule}

      node._cachedApplication = rule

      return rule

    det: (node) ->
      if node.type of config.RULES
        return @applyRule(node).type
      return 'block'

    getButtons: (node) ->
      if node.type of config.RULES
        return @applyRule(node).buttons ? EMPTY_OBJECT
      return EMPTY_OBJECT

    detNode: (node) -> if node.blockified then 'block' else @det(node)

    getColor: (node) ->
      color = config.COLOR_CALLBACK?(@opts, node)
      if color?
        color = color

      else if node.type of config.COLOR_RULES
        color = config.COLOR_RULES[node.type]

      else
        color = 'comment'

      if @opts.categories? and color of @opts.categories
        return @opts.categories[color]
      else if color of config.COLOR_DEFAULTS
        return config.COLOR_DEFAULTS[color]
      else
        return color

    getShape: (node, rules) ->
      shape = config.SHAPE_CALLBACK?(@opts, node)
      if shape?
        return shape

      else if node.type of config.SHAPE_RULES
        return config.SHAPE_RULES[node.type]

      else
        return helper.ANY_DROP

    getNodeContext: (node, wrap) ->
      if wrap?
        new parser.PreNodeContext(node.type,
          helper.clipLines(@lines, wrap.bounds.start, node.bounds.start).length,
          helper.clipLines(@lines, node.bounds.end, wrap.bounds.end).length
        )
      else
        return new parser.PreNodeContext node.type, 0, 0

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
      if node.children.length is 1 and @detNode(node) not in ['indent', 'buttonContainer']
        @mark node.children[0], prefix, depth, true, rules, context, wrap

      # Check to see if this AST type is part of the special empty strings map.
      # If so, check to see if it is the special empty string for its type,
      # and null it out if it is.
      #
      # TODO this may be a place where we need to optimize performance.
      else if context? and @detNode(context) is 'block' and config.EMPTY_STRINGS? and
            node.type of config.EMPTY_STRINGS and helper.clipLines(@lines, node.bounds.start, node.bounds.end) is config.EMPTY_STRINGS[node.type]
          @addSocket
            empty: config.EMPTY_STRINGS[node.type]
            bounds: node.bounds
            depth: depth
            dropdown: config.DROPDOWNS?[rules[0]] ? null
            parseContext: rules[0]

          @flagToRemove node.bounds, depth + 1

      else if node.children.length > 0
        switch @detNode node
          when 'block'
            if wrap?
              bounds = wrap.bounds
            else
              bounds = node.bounds

            if context? and @detNode(context) in ['block', 'buttonContainer']
              @addSocket
                empty: config.EMPTY_STRINGS?[rules[0]] ? config.empty
                bounds: bounds
                depth: depth
                dropdown: config.DROPDOWNS?[rules[0]] ? null
                parseContext: rules[0]

            @addBlock
              bounds: bounds
              depth: depth + 1
              color: @getColor node
              shape: @getShape node
              buttons: @getButtons node
              nodeContext: @getNodeContext node, wrap
              parseContext: rules[rules.length - 1]

          when 'buttonContainer'
            if wrap?
              bounds = wrap.bounds
            else
              bounds = node.bounds

            @addButtonContainer
              bounds: bounds
              depth: depth + 1
              parseContext: rules[0]
              buttons: @getButtons(node)
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

              if context? and @detNode(context) in ['block', 'buttonContainer']
                @addSocket
                  bounds: bounds
                  depth: depth
                  dropdown: config.DROPDOWNS?[rules[0]] ? null
                  parseContext: rules[0]

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor node
                buttons: @getButtons node
                shape: @getShape node
                nodeContext: @getNodeContext node, wrap
                parseContext: rules[rules.length - 1]

          when 'indent'
            # A lone indent needs to be wrapped in a block.
            if @det(context) isnt 'block'
              @addBlock
                bounds: node.bounds
                depth: depth
                color: @getColor node
                shape: @getShape node
                buttons: @getButtons node
                nodeContext: @getNodeContext node, warp
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
                  end = {
                    line: end.line - 1
                    column: @lines[end.line - 1].length
                  }

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
              indentContext: @applyRule(node).indentContext

          when 'socket'
            if context? and @detNode(context) in ['block', 'buttonContainer']
              @addSocket
                empty: config.EMPTY_STRINGS?[node.type] ? config.empty
                bounds: node.bounds
                depth: depth
                parseContext: rules[0]
                dropdown: config.DROPDOWNS?[rules[0]] ? null

        for child in node.children
          @mark child, prefix, depth + 2, false
      else if context? and @detNode(context) in ['block', 'buttonContainer']
        if @det(node) is 'socket' and ((not config.SHOULD_SOCKET?) or config.SHOULD_SOCKET(@opts, node))
          @addSocket
            empty: config.EMPTY_STRINGS?[node.type] ? config.empty
            bounds: node.bounds
            depth: depth
            parseContext: rules[0]
            dropdown: config.DROPDOWNS?[rules[0]] ? null

          if config.EMPTY_STRINGS? and not @opts.preserveEmpty and helper.clipLines(@lines, node.bounds.start, node.bounds.end) is config.empty
            @flagToRemove node.bounds, depth + 1

  if config.droppabilityGraph?
    droppabilityGraph = new Graph(config.droppabilityGraph)
    parenGraph = new Graph(config.parenGraph)

    TreewalkParser.drop = (block, context, pred) ->
      if block.parseContext is '__comment__' and context.type in ['indent', 'document']
        return helper.ENCOURAGE
      else if context.parseContext is '__comment__'
        return helper.DISCOURAGE

      parseContext = context.indentContext ? context.parseContext
      if helper.dfs(parenGraph, parseContext, block.nodeContext.type)
        return helper.ENCOURAGE
      else
        return helper.FORBID

    TreewalkParser.parens = (leading, trailing, node, context) ->
      # Comments never get paren-wrapped
      if context is null or node.parseContext is '__comment__' or context.parseContext is '__comment__'
        return node.parseContext

      parseContext = context.indentContext ? context.parseContext

      # Check to see if we can unwrap all our parentheses
      if helper.dfs(droppabilityGraph, parseContext, node.nodeContext.type)
        leading node.nodeContext.prefix
        trailing node.nodeContext.suffix

        return node.nodeContext.type

      # Otherwise, for performance reasons,
      # check to see if we can drop without modifying our parentheses
      if node.parseContext isnt node.nodeContext and helper.dfs(droppabilityGraph, parseContext, node.parseContext)
        return node.parseContext

      # Otherwise, do a full paren-wrap traversal. We find the shortest rule-inheritance path
      # from the bottom-most type of the block to the top-most type of the socket, applying
      # any paren rules we encounter along the way.
      else
        path = parenGraph.shortestPath(parseContext, node.nodeContext.type, {reverse: true})

        leading node.nodeContext.prefix
        trailing node.nodeContext.suffix

        for element, i in path when i > 0
          if config.PAREN_RULES[path[i]]?[path[i - 1]]?

            config.PAREN_RULES[path[i]][path[i - 1]](leading, trailing, node, context)

            node.parseContext = path[i]

        return node.parseContext

    TreewalkParser.getParenCandidates = (context) ->
      result = []
      for dest, sources of config.PAREN_RULES
        if helper.dfs(parenGraph, context, dest)
          for source of sources when source not in result
            result.push source
      return result

  else if config.drop?
    TreewalkParser.drop = config.drop
    TreewalkParser.parens = config.parens ? ->


  TreewalkParser.stringFixer = config.stringFixer
  TreewalkParser.rootContext = config.rootContext
  TreewalkParser.getDefaultSelectionRange = config.getDefaultSelectionRange
  TreewalkParser.empty = config.empty

  return TreewalkParser
