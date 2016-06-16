# Droplet ANTLR adapter
#
# Copyright (c) 2015 Anthony Bau (dab1998@gmail.com)
# MIT License

helper = require './helper.coffee'
model = require './model.coffee'
parser = require './parser.coffee'
treewalk = require './treewalk.coffee'
antlr4 = require 'antlr4'

ANTLR_PARSER_COLLECTION = {
  'JavaLexer': require('../antlr/JavaLexer'),
  'JavaParser': require('../antlr/JavaParser'),
  'CLexer': require('../antlr/CLexer'),
  'CParser': require('../antlr/CParser'),
  'C_preLexer': require('../antlr/C_preLexer'),
  'C_preParser': require('../antlr/C_preParser'),
  'jvmBasicLexer': require('../antlr/jvmBasicLexer'),
  'jvmBasicParser': require('../antlr/jvmBasicParser'),
}

exports.createANTLRParser = (passes, config, root) ->
  resultPasses = []

  unless passes instanceof Array
    passes = [passes]

  for pass in passes then do (pass) ->
    root ?= 'compilationUnit'

    parse = (context, text) ->
      # Construct but do not execute all of the necessary ANTLR accessories
      chars = new antlr4.InputStream(text)
      lexer = new ANTLR_PARSER_COLLECTION["#{pass.name}Lexer"]["#{pass.name}Lexer"](chars)
      tokens = new antlr4.CommonTokenStream(lexer)
      parser = new ANTLR_PARSER_COLLECTION["#{pass.name}Parser"]["#{pass.name}Parser"](tokens)

      postprocess = pass.postprocess ? (x) -> x

      # Build the actual parse tree
      parser.buildParseTrees = true
      if context of parser
        postprocess transform parser[context]()
      else
        postprocess transform parser[root]()

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
        if node.symbol?.text
          result.data = {text: node.symbol.text}

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
    resultPasses.push {
      parse, config: pass.config
    }

  return treewalk.createTreewalkParser resultPasses, config, root
