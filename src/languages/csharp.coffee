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
  # Skips : no block for these elements

 # 'compilation_unit' : 'skip'
  #'using_directives' : 'skip'

# Indents: these elements should have indentation

 'using_directive': (node) ->
    sockets =  [ ]
    color = 'purple'
    return {sockets, color}


# Sockets : can be used to enter inputs into a form or specify types
#  'using_directive': (node) ->
 #   sockets =  [
 #     node.children[1].children[0].children[0]]
  #  color = 'purple'

 #   return {sockets, color}

 # 'local_variable_declaration' : {type: 'block', buttons: BOTH_BUTTON}
}

COLOR_DEFAULTS = {

}

COLOR_RULES = {
# 'using_directive': 'declaration'
}

SHAPE_RULES = {
#'using_directive' : helper.BLOCK_ONLY # e.g. 'using System;'
 # 'local_variable_declaration' : helper.BLOCK_ONLY
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

EMPTY_STRINGS = { }

PARENS = [ ]

SHOULD_SOCKET = (opts, node) ->
  return true

config = {
  RULES, COLOR_DEFAULTS, COLOR_RULES, COLOR_CALLBACK, SHAPE_RULES, SHAPE_CALLBACK, NATIVE_TYPES, EMPTY_STRINGS,
  COLOR_DEFAULTS, MODIFIERS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET, PARENS
}

config.rootContext = 'compilation_unit'

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config