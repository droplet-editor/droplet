antlr4 = require 'antlr4'
JavaLexer = require './JavaLexer'
JavaParser = require './JavaParser'

input = '''
class Vector {
  double x, y;
  public Vector (double _x, double _y) {
    x = _x; y = _y;
  }
  public mag() {
    return Math.sqrt(x * x + y * y);
  }
  public add(Vector other) {
    return new Vector(other.x + x, other.y + y);
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
  if el.children?
    for child in el.children
      print(child, '--' + indent)

print parseTree, ''

exports.parser = parser
