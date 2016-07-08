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
      line = @lines[bounds.start.line + 1]
      return line[0...line.length - line.trimLeft().length]

    applyRule: (rule, node) ->
      if rule instanceof Function
        rule = rule(node)
      if 'string' is typeof rule
        rule = {type: rule}
      return rule

    det: (node) ->
      if node.type of config.RULES
        type = @applyRule(config.RULES[node.type], node).type
        if type is 'block_explicit'
          return 'block'
        else
          return type
      return 'block'

    detNode: (node) -> if node.blockified then 'block' else @det(node)

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

      return 'any-drop'

    mark: (node, prefix, depth, pass, rules, context, wrap, wrapRules) ->
      if node.type is 'recipe' #rule_collection'
        debugger
      unless pass
        context = node.parent
        while context? and @detNode(context) in ['skip', 'parens']
          context = context.parent

      rules ?= []
      rules = rules.slice 0
      rules.push node.type

      # Pass through to child if single-child
      if node.children.length is 1 and @detNode(node) isnt 'indent' and (node.type not of config.RULES or @applyRule(config.RULES[node.type], node).type isnt 'block_explicit')
        @mark node.children[0], prefix, depth, true, rules, context, wrap, wrapRules

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
                classes: padRules(wrapRules ? rules)
                parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

            @addBlock
              bounds: bounds
              depth: depth + 1
              color: @getColor node, rules
              classes: padRules(wrapRules ? rules).concat(@getShape(node, rules))
              parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

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
              @mark child, prefix, depth, true, rules, context, wrap ? node, wrapRules ? rules
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
                  classes: padRules(wrapRules ? rules)
                  parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor node, rules
                classes: padRules(wrapRules ? rules).concat(@getShape(node, rules))
                parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

          when 'indent'
            # A lone indent needs to be wrapped in a block.
            if @det(context) isnt 'block'
              @addBlock
                bounds: node.bounds
                depth: depth
                color: @getColor node, rules
                classes: padRules(wrapRules ? rules).concat(@getShape(node, rules))
                parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

              depth += 1

            start = origin =
              line: node.children[0].bounds.start.line
              column: node.children[0].bounds.start.column
            for child, i in node.children
              if child.children.length > 0
                if i is 0
                  start.line -= 1
                  start.column = @lines[start.line].length
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
              classes: padRules(wrapRules ? rules)
              parseContext: @applyRule(config.RULES[node.type], node).indentContext

        for child in node.children
          @mark child, prefix, depth + 2, false
      else if context? and @detNode(context) is 'block'
        if @det(node) is 'socket' and ((not config.SHOULD_SOCKET?) or config.SHOULD_SOCKET(@opts, node))
          @addSocket
            bounds: node.bounds
            depth: depth
            classes: padRules(wrapRules ? rules)
            parseContext: rules[0] #(if wrap? then wrap.type else rules[0])

          if config.empty? and not @opts.preserveEmpty and helper.clipLines(@lines, node.bounds.start, node.bounds.end) is config.empty
            @flagToRemove node.bounds, depth + 1

  TreewalkParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      if '__comment__' in block.classes
        return helper.DISCOURAGE
      for c in parseClasses(context)
        if c in parseClasses(block)
          return helper.ENCOURAGE

        # Check to see if we could paren-wrap this
        if config.PAREN_RULES? and c of config.PAREN_RULES
          for m in parseClasses(block)
            if m of config.PAREN_RULES[c]
              return helper.ENCOURAGE
      return helper.DISCOURAGE

    else if context.type is 'indent'
      if '__comment__' in block.classes
        return helper.ENCOURAGE

      if context.parseContext in parseClasses(block)
        return helper.ENCOURAGE

      return helper.DISCOURAGE

    else if context.type is 'document'
      if '__comment__' in block.classes
        return helper.ENCOURAGE

      if 'externalDeclaration' in parseClasses(block) or
         'translationUnit' in parseClasses(block)
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
    for c in parseClasses(context)
      if c in parseClasses(node)
        return

    # Otherwise, wrap according to the provided rule
    for c in parseClasses(context) when c of config.PAREN_RULES
      for m in parseClasses(node) when m of config.PAREN_RULES[c]
        return config.PAREN_RULES[c][m] leading, trailing, node, context

  TreewalkParser.stringFixer = config.stringFixer
  TreewalkParser.getDefaultSelectionRange = config.getDefaultSelectionRange
  TreewalkParser.empty = config.empty

  return TreewalkParser

PARSE_PREFIX = "__parse__"
padRules = (rules) -> rules.map (x) -> "#{PARSE_PREFIX}#{x}"
parseClasses = (node) -> node.classes.filter((x) -> x[...PARSE_PREFIX.length] is PARSE_PREFIX).map((x) -> x[PARSE_PREFIX.length..])
