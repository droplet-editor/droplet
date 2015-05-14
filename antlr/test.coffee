antlr4 = require 'antlr4'
Python3Lexer = require './Python3Lexer'
Python3Parser = require './Python3Parser'

input = '''
def main():
  print('hello')
print('goodbye')
'''

chars = new antlr4.InputStream input
lexer = new Python3Lexer.Python3Lexer chars
tokens = new antlr4.CommonTokenStream lexer
parser = new Python3Parser.Python3Parser tokens
parser.buildParseTrees = true
parseTree = parser.file_input()

console.log tokens.tokens

print = (el, indent) ->
  if el.ruleIndex?
    console.log indent + parser.ruleNames[el.ruleIndex] + "(#{el.start.line}:#{el.start.column}, #{el.stop.line}:#{el.stop.column})"
  else
    console.log indent + el.symbol
    #console.log parser.symbolicNames[el.symbol.type]
  if el.children?
    for child in el.children
      print(child, '--' + indent)

#print parseTree, ''

exports.parser = parser
