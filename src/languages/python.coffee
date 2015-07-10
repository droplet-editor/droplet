# Droplet Python mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'
treewalk = require '../treewalk.coffee'

skulpt = require '../../vendor/skulpt'

# PARSER SECTION
parse = (context, text) ->
  result = transform skulpt.parser.parse('file.py', text), text.split('\n')
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
  result = {
    type: skulpt.tables.ParseTables.number2symbol[node.type] ? skulpt.Tokenizer.tokenNames[node.type] ? node.type
    bounds: getBounds(node, lines)
    parent: parent
  }
  result.children = if node.children?
      node.children.map ((x) -> transform(x, lines, result))
    else []

  return result

# CONFIG SECTION
INDENTS = ['suite']
SKIPS = [
  'file_input'
  'parameters'
  'compound_stmt'
  'small_stmt'
  'simple_stmt'
  'trailer'
  'arglist'
  'testlist_comp'
]
PARENS = [
  'stmt'
]
SOCKET_TOKENS = [
  'T_NAME', 'T_NUMBER', 'T_STRING'
]
COLORS_FORWARD = {
  'funcdef': 'control'
  'for_stmt': 'control'
  'while_stmt': 'control'
  'if_stmt': 'control'
  'import_stmt': 'command'
  'print_stmt': 'command'
  'expr_stmt': 'command'
  'testlist': 'value'
  'test': 'value'
  'expr': 'value'
}
COLORS_BACKWARD = {}

config = {
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD,
}

module.exports = parser.wrapParser treewalk.createTreewalkParser parse, config
