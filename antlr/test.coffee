antlr4 = require 'antlr4'
JavaLexer = require './JavaLexer'
JavaParser = require './JavaParser'

input = '''
public class Test {
  public Test() {
    while(true) {
      System.out.println('hello');
    }
  }
}
'''

chars = new antlr4.InputStream input
lexer = new JavaLexer.JavaLexer chars
tokens = new antlr4.CommonTokenStream lexer
parser = new JavaParser.JavaParser tokens
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
