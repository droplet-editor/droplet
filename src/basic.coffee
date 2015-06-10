# # ICE Editor Java mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-parser', 'droplet-antlr-parser'], (parser, antlrHelper) ->
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

  return parser.wrapParser antlrHelper.createANTLRParser 'jvmBasic', config, 'prog'
