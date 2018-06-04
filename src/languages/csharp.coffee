# Droplet C# mode
#
# Copyright (c) 2018 Kevin Jessup
# MIT License

helper = require '../helper.coffee'
parser = require '../parser.coffee'
antlrHelper = require '../antlr.coffee'

model = require '../model.coffee'

{fixQuotedString, looseCUnescape, quoteAndCEscape} = helper

ADD_BUTTON = [
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

BOTH_BUTTON = [
  {
    key: 'subtract-button'
    glyph: '\u25C0'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25B6'
    border: false
  }
]

ADD_BUTTON_VERT = [
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_VERT = [
  {
    key: 'subtract-button'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button'
    glyph: '\u25BC'
    border: false
  }
]

# TODO: all the stuff below this
# TODO: WIP => import statements (using...)

RULES = {
  'statements': { # defines a node to indent within this node based on that subnode's type?
    'type': 'indent',
    'indexContext': 'statement_list',
  }
  # Skips : no block for these elements
  'compilationUnit' : 'skip',
  'using_directives' : 'skip',
  'namespace_or_type_name' : 'skip',

  # Indents: these elements should have indentation

  #'using_directive' : 'socket',

  # Sockets : can be used to enter inputs into a form or specify types

  'identifier' : 'socket'
}

COLOR_DEFAULTS = {

}


# Used to color nodes
# See view.coffee for a list of colors
COLOR_RULES = {
 'using_directive' : 'purple'
}

SHAPE_RULES = {
  'using_directive' : helper.BLOCK_ONLY
 # 'identifier' : helper.VALUE_ONLY
}

NATIVE_TYPES = [
#  'int' # TODO: flesh out types
]

EMPTY_STRINGS = {

}

COLOR_CALLBACK = {

}

SHAPE_CALLBACK = {

}

COLOR_DEFAULTS = {

}

MODIFIERS = {

}

DROPDOWNS = {

}

EMPTY_STRINGS = {

}

PARENS = [

]

SHOULD_SOCKET = (opts, node) ->
  return true

config = {
  RULES, COLOR_DEFAULTS, COLOR_RULES, COLOR_CALLBACK, SHAPE_RULES, SHAPE_CALLBACK, NATIVE_TYPES, EMPTY_STRINGS,
  COLOR_DEFAULTS, MODIFIERS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET, PARENS
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config