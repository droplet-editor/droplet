# Droplet BASIC mode
#
# Copyright (c) Anthony Bau
# MIT License

parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

INDENTS = ['compoundStatement']
SKIPS = [
  'prog',
  'gte',
  'lte',
]
PARENS = ['func']
SOCKET_TOKENS = ['NUMBER', 'FLOAT', 'STRINGLITERAL', 'LETTERS', 'COMMENT']
COLORS_FORWARD = {
  'line': 'control'
  'statement': 'command'
  'expression': 'value'
  'printlist': 'value'
}
COLORS_BACKWARD = {
}

config = {
  INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLORS_FORWARD, COLORS_BACKWARD
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'jvmBasic', config, 'prog'
