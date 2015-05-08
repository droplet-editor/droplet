antlr4 = require 'antlr4'
CLexer = require './CLexer'
CParser = require './CParser'

input = '''
int main(int n, char* args[]) {
  int i = 1 + 2 + 3;
  return 0;
}
'''

chars = new antlr4.InputStream input
lexer = new CLexer.CLexer chars
tokens = new antlr4.CommonTokenStream lexer
parser = new CParser.CParser tokens
parser.buildParseTrees = true
parseTree = parser.compilationUnit()

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
