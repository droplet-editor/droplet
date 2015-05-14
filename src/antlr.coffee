# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model', 'droplet-parser', 'droplet-treewalk', 'antlr'], (helper, model, parser, treewalk, antlr) ->
  exports = {}

  exports.createANTLRParser = (name, config, root) ->
    root ?= 'compilationUnit'

    parse = (context, text) ->
      # Construct but do not execute all of the necessary ANTLR accessories
      chars = new antlr.antlr4.InputStream(text)
      lexer = new antlr["#{name}Lexer"]["#{name}Lexer"](chars)
      tokens = new antlr.antlr4.CommonTokenStream(lexer)
      parser = new antlr["#{name}Parser"]["#{name}Parser"](tokens)

      # Build the actual parse tree
      parser.buildParseTrees = true
      return transform parser[context]()

    # Transform an ANTLR tree into a treewalker-type tree
    transform = (node, parent = null) ->
      result = {}
      if node.children?
        result.terminal = node.children.length is 0
        result.type = node.parser.ruleNames[node.ruleIndex]
        result.children = (transform(child, result) for child in node.children)
        result.bounds = getBounds node
        result.parent = parent
      else
        result.terminal = true
        result.type = (node.parser ? node.parentCtx.parser).symbolicNames[node.symbol.type]
        result.children = []
        result.bounds = getBounds node
        result.parent = parent

      return result

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

    return treewalk.createTreewalkParser parse, config, root

  return exports
