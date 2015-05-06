# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model', 'droplet-parser', 'antlr'], (helper, model, parser, antlr) ->
  exports = {}

  # CONFIG SECTION
  INDENTS = ['block', 'classBody']
  SKIPS = ['compilationUnit',
    'classDeclaration',
    'memberDeclaration',
    'constructorDeclaration',
    'methodDeclaration',
    'formalParameters',
    'formalParameterList'
  ]
  PARENS = [
    'statement'
    'primary'
  ]
  SOCKET_TOKENS = [
    'Identifier'
    'IntegerLiteral'
    'StringLiteral'
  ]
  COLORS = {
    'typeDeclaration': 'control'
    'classBodyDeclaration': 'control'
    'variableDeclarator': 'command'
    'formalParameter': 'command'
    'statementExpression': 'command'
    'expression': 'value'
  }

  exports.JavaParser = class JavaParser extends parser.Parser
    constructor: (@text, @opts = {}) ->
      super

      # Construct but do not execute all of the necessary ANTLR accessories
      @chars = new antlr.antlr4.InputStream @text
      @lexer = new antlr.JavaLexer.JavaLexer @chars
      @tokens = new antlr.antlr4.CommonTokenStream @lexer
      @parser = new antlr.JavaParser.JavaParser @tokens

      @lines = @text.split '\n'

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

    markRoot: (context = 'compilationUnit') ->
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

    getBounds: (node) ->
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

    det: (rule) ->
      if rule in INDENTS then return 'indent'
      else if rule in SKIPS then return 'skip'
      else if rule in PARENS then return 'parens'
      else return 'block'

    detNode: (node) -> @det(node.parser.ruleNames[node.ruleIndex])
    detToken: (node) -> if (node.parser ? node.parentCtx.parser).symbolicNames[node.symbol.type] in SOCKET_TOKENS then 'socket' else 'none'

    getDropType: (context) -> ({
      'block': 'mostly-value'
      'indent': 'mostly-block'
      'skip': 'mostly-block'
    })[@detNode(context)]

    getColor: (rules) ->
      for el, i in rules
        if el of COLORS
          return COLORS[el]
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
              bounds = @getBounds wrap
            else
              bounds = @getBounds node

            if context? and @detNode(context) is 'block'
              @addSocket
                bounds: bounds
                depth: depth
                classes: [rules[0]]

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
                bounds = @getBounds wrap
              else
                bounds = @getBounds node

              if context? and @detNode(context) is 'block'
                @addSocket
                  bounds: bounds
                  depth: depth
                  classes: [rules[0]]

              @addBlock
                bounds: bounds
                depth: depth + 1
                color: @getColor rules
                classes: rules.concat(if context? then @getDropType(context) else 'any-drop')
                parseContext: (if wrap? then wrap.parser.ruleNames[wrap.ruleIndex] else rules[0])

          when 'indent'
            start = @getBounds(node.children[0]).start
            for child, i in node.children
              if child.children?
                break
              else
                start = @getBounds(child).end

            end = @getBounds(node.children[node.children.length - 1]).end
            for child, i in node.children by -1
              if child.children?
                end = @getBounds(child).end
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
            bounds: @getBounds node
            depth: depth
            classes: [rules[0]]

  JavaParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      if context.classes[0] in block.classes
        return helper.ENCOURAGE
      else
        return helper.DISCOURAGE

  JavaParser.parens = (leading, trailing, node, context) ->

  return parser.wrapParser JavaParser
