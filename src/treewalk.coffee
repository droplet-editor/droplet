# Droplet Treewalker framework.
#
# Copyright (c) Anthony Bau (dab1998@gmail.com)
# MIT License
helper = require './helper.coffee'
model = require './model.coffee'
parser = require './parser.coffee'

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

    getDropType: (context) -> ({
      'block': 'mostly-value'
      'indent': 'mostly-block'
      'skip': 'mostly-block'
    })[@detNode(context)]

    getColor: (node, rules) ->
      color = config.COLOR_CALLBACK?(@opts, node)
      if color?
        return color

      # Apply the static rules set given in config
      rulesSet = {}
      rules.forEach (el) -> rulesSet[el] = true

      for colorRule in config.COLOR_RULES
        if colorRule[0] of rulesSet
          return colorRule[1]

      return 'comment'

    getShape: (node, rules) ->
      shape = config.SHAPE_CALLBACK?(@opts, node)
      if shape?
        return shape

      # Apply the static rules set given in config
      rulesSet = {}
      rules.forEach (el) -> rulesSet[el] = true

      for shapeRule in config.SHAPE_RULES
        if shapeRule[0] of rulesSet
          return shapeRule[1]

      return 'comment'

    mark: (node, prefix, depth, pass, rules, context, wrap) ->
      unless pass
        context = node.parent
        while context? and @detNode(context) in ['skip', 'parens']
          context = context.parent

      rules ?= []
      rules.push node.type

      # Pass through to child if single-child
      if node.children.length is 1
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
                classes: rules
                parseContext: (if wrap? then wrap.type else rules[0])

            @addBlock
              bounds: bounds
              depth: depth + 1
              color: @getColor node, rules
              classes: rules.concat(if context? then @getDropType(context) else @getShape(node, rules))
              parseContext: (if wrap? then wrap.type else rules[0])

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
                  classes: rules
                  parseContext: (if wrap? then wrap.type else rules[0])

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor node, rules
                classes: rules.concat(if context? then @getDropType(context) else @getShape(node, rules))
                parseContext: (if wrap? then wrap.type else rules[0])

          when 'indent'
            # A lone indent needs to be wrapped in a block.
            if @det(context) isnt 'block'
              @addBlock
                bounds: node.bounds
                depth: depth
                color: @getColor node, rules
                classes: rules.concat(if context? then @getDropType(context) else @getShape(node, rules))
                parseContext: (if wrap? then wrap.type else rules[0])

              depth += 1

            start = origin = node.children[0].bounds.start
            for child, i in node.children
              if child.children.length > 0
                break
              else unless helper.clipLines(@lines, origin, child.bounds.end).trim().length is 0
                #console.log 'excluding start', helper.clipLines(@lines, origin, child.bounds.end)
                start = child.bounds.end

            end = node.children[node.children.length - 1].bounds.end
            for child, i in node.children by -1
              if child.children.length > 0
                end = child.bounds.end
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
              classes: rules
              parseContext: @applyRule(config.RULES[node.type], node).indentContext

        for child in node.children
          @mark child, prefix, depth + 2, false
      else if context? and @detNode(context) is 'block'
        if @det(node) is 'socket' and config.SHOULD_SOCKET(@opts, node)
          @addSocket
            bounds: node.bounds
            depth: depth
            classes: rules
            parseContext: (if wrap? then wrap.type else rules[0])

  TreewalkParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      if '__comment__' in context.classes
        return helper.DISCOURAGE
      for c in context.classes
        if c in block.classes
          return helper.ENCOURAGE

        # Check to see if we could paren-wrap this
        if config.PAREN_RULES? and c of config.PAREN_RULES
          for m in block.classes
            if m of config.PAREN_RULES[c]
              return helper.ENCOURAGE
      return helper.DISCOURAGE

    else if context.type is 'indent'
      console.log context.parseContext, block.classes
      if '__comment__' in block.classes
        return helper.ENCOURAGE

      if context.parseContext in block.classes
        return helper.ENCOURAGE

      return helper.DISCOURAGE

    else if context.type is 'document'
      if '__comment__' in block.classes
        return helper.ENCOURAGE

      if 'externalDeclaration' in block.classes or
         'translationUnit' in block.classes
        return helper.ENCOURAGE

      return helper.DISCOURAGE

    return helper.DISCOURAGE


  # Doesn't yet deal with parens
  TreewalkParser.parens = (leading, trailing, node, context)->
    # If we're moving to null, remove parens (where possible)
    unless context?
      if config.unParenWrap?
        return config.unParenWrap leading, trailing, node, context
      else
        return


    # If we already match types, we're fine
    for c in context.classes
      if c in node.classes
        return

    # Otherwise, wrap according to the provided rule
    for c in context.classes when c of config.PAREN_RULES
      for m in node.classes when m of config.PAREN_RULES[c]
        return config.PAREN_RULES[c][m] leading, trailing, node, context

  return TreewalkParser
