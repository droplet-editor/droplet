antlr4 = require 'antlr4'
logoLexer = require './logoLexer'
logoParser = require './logoParser'

input = '''
repeat 3 [fd 10]
'''

chars = new antlr4.InputStream input
lexer = new logoLexer.logoLexer chars
tokens = new antlr4.CommonTokenStream lexer
parser = new logoParser.logoParser tokens
parser.buildParseTrees = true
parseTree = parser.prog()

print = (el, indent) ->
  if el.ruleIndex?
    console.log indent + parser.ruleNames[el.ruleIndex] + "(#{el.start.line}:#{el.start.column}, #{el.stop.line}:#{el.stop.column})"
  else
    console.log indent + el.symbol
    #console.log parser.symbolicNames[el.symbol.type]
  if el.children?
    for child in el.children
      print(child, '--' + indent)

print parseTree, ''

exports.parser = parser
