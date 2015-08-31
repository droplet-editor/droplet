# Droplet Python mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'
treewalk = require '../treewalk.coffee'

skulpt = require '../../vendor/skulpt'

PYTHON_KEYWORDS = ['and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']

# PARSER SECTION
parse = (context, text) ->
  result = transform skulpt.parser.parse('file.py', text, context), text.split('\n')
  console.log result
  return result

getBounds = (node, lines) ->
  bounds = {
    start: {
      line: node.lineno - 1
      column: node.col_offset
    }
  }
  if node.children? and node.children.length > 0
    if skulpt.tables.ParseTables.number2symbol[node.type] is 'suite'
      # Avoid including DEDENT in the indent.
      bounds.end = getBounds(node.children[node.children.length - 2], lines).end
    else
      bounds.end = getBounds(node.children[node.children.length - 1], lines).end
  else
    bounds.end = {
      line: node.line_end - 1
      column: node.col_end
    }
  return bounds

transform = (node, lines, parent = null) ->
  type = skulpt.tables.ParseTables.number2symbol[node.type] ? skulpt.Tokenizer.tokenNames[node.type] ? node.type
  if type is 'T_NAME'
    if node.value in PYTHON_KEYWORDS
      type = 'T_KEYWORD'
  result = {
    type: type
    bounds: getBounds(node, lines)
    parent: parent
  }
  result.children = if node.children?
      node.children.map ((x) -> transform(x, lines, result))
    else []

  return result

# CONFIG SECTION
config = {
  INDENTS: ['suite']
  SKIPS: [
    'file_input'
    'parameters'
    'compound_stmt'
    'small_stmt'
    'simple_stmt'
    'trailer'
    'arglist'
    'testlist_comp'
    'with_item'
    'listmaker'
    'list_for'
  ]
  PARENS : [
    'stmt'
  ]
  SOCKET_TOKENS : [
    'T_NAME', 'T_NUMBER', 'T_STRING'
  ]
  COLORS_FORWARD : {
    'term': 'value'
    'funcdef': 'control'
    'for_stmt': 'control'
    'while_stmt': 'control'
    'with_stmt': 'control'
    'if_stmt': 'control'
    'try_stmt': 'control'
    'import_stmt': 'command'
    'print_stmt': 'command'
    'expr_stmt': 'command'
    'return_stmt': 'return'
    'testlist': 'value'
    'comparison': 'value'
    'test': 'value'
    'expr': 'value'
  }
  COLORS_BACKWARD : {}
  BLOCK_TOKENS: [], PLAIN_SOCKETS: [], VALUE_TYPES: [], BLOCK_TYPES: []
}

result = treewalk.createTreewalkParser parse, config
result.canParse = (node) ->
  return ('stmt' in node.classes) or
         ('small_stmt' in node.classes)
module.exports = parser.wrapParser result
