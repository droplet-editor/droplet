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

RULES = {
  # tell parser to indent blocks within the main part of a namespace body (indent everything past namespace_member_declarations)
  'namespace_body': {
    'type': 'indent',
    'indexContext': 'namespace_member_declarations',
  },

  'class_body': {
    'type': 'indent',
    'indexContext': 'class_member_declarations',
  },

  # Skips : no block for these elements
  'compilationUnit' : 'skip',
  'using_directives' : 'skip',
  'namespace_or_type_name' : 'skip',
  'namespace_member_declarations' : 'skip',
  'namespace_member_declaration' : 'skip',
  'class_member_declarations' : 'skip',
  'class_member_declaration' : 'skip',
  'all_member_modifiers' : 'skip',
  'type_declaration' : 'skip'
  'qualified_identifier' : 'skip', # TODO: this may cause conflicts later (originally done for namespace names like "foo.bar")

  # Sockets : can be used to enter inputs into a form or specify types
  'IDENTIFIER' : 'socket',
  'NEW' : 'socket',
  'PUBLIC' : 'socket',
  'PROTECTED' : 'socket',
  'INTERNAL' : 'socket',
  'PRIVATE' : 'socket',
  'READONLY' : 'socket',
  'VOLATILE' : 'socket',
  'VIRTUAL' : 'socket',
  'SEALED' : 'socket',
  'OVERRIDE' : 'socket',
  'ABSTRACT' : 'socket',
  'STATIC' : 'socket',
  'UNSAFE' : 'socket',
  'EXTERN' : 'socket',
  'PARTIAL' : 'socket',
  'ASYNC' : 'socket'

  #'using_directive' : -> (node) # TODO: figure out way of adding/removing static keyword easily from using declarations
    #type: 'block', buttons: ADD_BUTTON
}

# Used to color nodes
# See view.coffee for a list of colors
COLOR_RULES = {
 'using_directive' : 'purple',
 'namespace_declaration' : 'green',
 'class_definition' : 'lightblue'
}

COLOR_DEFAULTS = {

}

SHAPE_RULES = {
#  'using_directive' : helper.BLOCK_ONLY
 # 'identifier' : helper.VALUE_ONLY
}

EMPTY_STRINGS = {

}

COLOR_CALLBACK = {

}

SHAPE_CALLBACK = {

}

COLOR_DEFAULTS = {

}

# defines any nodes that are to be turned into different kinds of dropdown menus;
# the choices for those dropdowns are defined by the items to the left of the semicolon
DROPDOWNS = {
  'all_member_modifier' : CLASS_MODIFIERS,
}

MODIFIERS = [
  'public',
  'private',
  'protected',
  'internal',
]

CLASS_MODIFIERS = MODIFIERS.concat([
  'abstract',
  'static',
  'partial',
  'sealed',
])

EMPTY_STRINGS = {

}

PARENS = [

]

SHOULD_SOCKET = (opts, node) ->
  return true

config = {
  RULES,
  COLOR_DEFAULTS,
  COLOR_RULES,
  COLOR_CALLBACK,
  SHAPE_RULES,
  SHAPE_CALLBACK,
  EMPTY_STRINGS,
  COLOR_DEFAULTS,
  DROPDOWNS,
  MODIFIERS,
  CLASS_MODIFIERS,
  EMPTY_STRINGS,
  SHOULD_SOCKET,
  PARENS
}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'CSharp', config