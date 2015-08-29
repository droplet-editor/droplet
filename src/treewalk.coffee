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
      text.match(/^\s*\/\/.*$/)

    markRoot: (context = root) ->
      parseTree = parse(context, @text)

      # Parse
      @mark parseTree, '', 0

    guessPrefix: (bounds) ->
      ###
      # By voting:
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
      ###
      # First line:
      i = bounds.start.line + 1

      until i > bounds.end.line or (@lines[i].trim().length > 0)
        i += 1

      if i > bounds.end.line
        line = @lines[bounds.start.line + 1]
      else
        line = @lines[i]

      prefix = line[0...line.length - line.trimLeft().length]

      return prefix


    det: (rule) ->
      if rule in config.INDENTS then return 'indent'
      else if rule in config.SKIPS then return 'skip'
      else if rule in config.PLAIN_SOCKETS then return 'plainSocket'
      else if rule in config.PARENS then return 'parens'
      else return 'block'

    detNode: (node) -> if node.blockified then 'block' else @det(node.type)
    detDropType: (rules) ->
      for el, i in rules
        if el in config.VALUE_TYPES
          return 'mostly-value'
        else if el in config.BLOCK_TYPES
          return 'mostly-block'
      return 'any-drop'
    detToken: (node) ->
      if node.type?
        #console.log node.type
        if node.type in config.SOCKET_TOKENS then 'socket'
        else if node.type in config.BLOCK_TOKENS then 'block'
        else 'none'
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

    getMarkedChild: (node) ->
      child = null
      for el, i in node.children
        if (el.children.length > 0 and @detNode(el) is 'block') or
           (el.children.length is 0 and @detToken(el) isnt 'none') or
           (el = @getMarkedChild(el))?
          if child?
            return null
          else
            child = el
      return child

    mark: (node, prefix, depth, pass, rules, context, wrap) ->
      unless pass
        context = node.parent
        while context? and @detNode(context) in ['skip', 'parens']
          context = context.parent

      rules ?= []
      rules.push node.type

      # Pass through to child if single-child
      if node.children.length is 1 and @detNode(node) isnt 'plainSocket'
        @mark node.children[0], prefix, depth, true, rules, context, wrap

      else if node.children.length > 0
        switch @detNode(node)
          when 'plainSocket'
            if wrap?
              bounds = wrap.bounds
            else
              bounds = node.bounds

            if context? and @detNode(context) is 'block'
              @addSocket
                bounds: bounds
                depth: depth
                classes: rules

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

            @addBlock
              bounds: bounds
              depth: depth + 1
              color: @getColor rules
              classes: rules.concat(if context? then @getDropType(context) else @detDropType(rules))
              parseContext: (if wrap? then wrap.type else rules[0])

          when 'parens'
            # Parens are assumed to wrap the only child that has children,
            # or the only child
            child = @getMarkedChild node
            if child?
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

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor rules
                classes: rules.concat(if context? then @getDropType(context) else 'any-drop')
                parseContext: (if wrap? then wrap.type else rules[0])

          when 'indent' then if @det(context) is 'block'
            start = origin = node.children[0].bounds.start

            if config.INDENT_START_EXCLUDE_TOKEN
              # Config
              for child, i in node.children
                if child.children.length > 0
                  break
                else if child.type is config.INDENT_START_EXCLUDE_TOKEN
                  start = child.bounds.end
                  break

            else
              # Heuristic
              for child, i in node.children
                if child.children.length > 0
                  break
                else unless (helper.clipLines(@lines, origin, child.bounds.end).trim().length is 0) # TODO this is very buggy for empty indents
                  #console.log 'excluding start', helper.clipLines(@lines, origin, child.bounds.end)
                  start = child.bounds.end

            end = node.children[node.children.length - 1].bounds.end

            # Use last child wherever possible
            worked = false
            for child, i in node.children by -1
              if child.children.length > 0
                end = child.bounds.end
                worked = true
                break

            # Otherwise try to use our config
            if config.INDENT_END_EXCLUDE_TOKEN? and not worked
              for child, i in node.children by -1
                if child.type is config.INDENT_END_EXCLUDE_TOKEN
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

        for child in node.children
          @mark child, prefix, depth + 2, false
      else if context? and @detNode(context) is 'block'
        if @detToken(node) is 'socket'
          @addSocket
            bounds: node.bounds
            depth: depth
            classes: rules
      else if @detToken(node) is 'block'
        if wrap?
          bounds = wrap.bounds
        else
          bounds = node.bounds

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
          parseContext: (if wrap? then wrap.type else rules[0])

  TreewalkParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      for c in context.classes
        if c in block.classes
          return helper.ENCOURAGE
      return helper.DISCOURAGE

  # Doesn't yet deal with parens
  TreewalkParser.parens = (leading, trailing, node, context) ->

  return TreewalkParser
