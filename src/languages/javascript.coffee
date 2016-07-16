# Droplet C mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

RULES = {
  'program': 'skip'
  'variableDeclarationList': 'skip'
  'variableDeclaration': 'skip'
  'initialiser': 'skip'
  'block': 'skip'
  'arguments': 'skip'

  # Parens
  'expressionStatement': {type: 'parens', 'parenType': 'expressionSequence'}

  # Special: sourceElements is a list of statements, which should
  # be indented, except when they are the entire program
  'sourceElements': (node) ->
    if node.parent.type is 'program'
      'skip'
    else
      {
        type: 'indent'
        indentContext: 'sourceElement'
      }

  # Indent
  'statementList': {
    type: 'indent'
    indentContext: 'statement'
  }

  'propertyNameAndValueList': 'skip'
  'propertyAssignment': 'skip'


  # Socket
  'Identifier': 'socket'
  'NullLiteral': 'socket'
  'BooleanLiteral': 'socket'
  'This': 'socket'
  'OctalIntegerLiteral': 'socket'
  'DecimalLiteral': 'socket'
  'HexIntegerLiteral': 'socket'
  'StringLiteral': 'socket'
}

COLOR_RULES = {
  'iterationStatement': 'control'
  'singleExpression': 'value'
  'variableStatement': 'command'
  'objectLiteral': 'value'
}

SHAPE_RULES = {
}

config = {
  RULES, COLOR_RULES, SHAPE_RULES
}

ADD_SEMICOLON = (leading, trailing) ->
  trailing trailing() + ';'

config.PAREN_RULES = {
  'expressionStatement': {
    'expressionSequence': ADD_SEMICOLON
  }
}

config.SHOULD_SOCKET = (opts, node) -> true

# Color and shape callbacks look up the method name
# in the known functions list if available.
config.COLOR_CALLBACK = (opts, node) ->

config.SHAPE_CALLBACK = (opts, node) ->

config.isComment = (text) ->
  text.match(/^(\s*\/\/.*)$/)?

config.parseComment = (text) ->
  # Try standard comment
  comment = text.match(/^(\s*\/\/)(.*)$/)
  if comment?
    sockets =  [
      [comment[1].length, comment[1].length + comment[2].length]
    ]
    color = 'comment'

    return {sockets, color}

config.getDefaultSelectionRange = (string) ->
  start = 0; end = string.length
  if string.length > 1 and string[0] is string[string.length - 1] and string[0] is '"'
    start += 1; end -= 1
  if string.length > 1 and string[0] is '<' and string[string.length - 1] is '>'
    start += 1; end -= 1
  if string.length is 3 and string[0] is string[string.length - 1] is '\''
    start += 1; end -= 1
  return {start, end}

config.stringFixer = (string) ->
  if /^['"]|['"]$/.test string
    return fixQuotedString [string]
  else
    return string

config.empty = '__'
config.emptyIndent = ''
config.rootContext = 'program'

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'ECMAScript', config, 'program'
