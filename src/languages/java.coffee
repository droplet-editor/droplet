# Droplet Java mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License
# Updated 2018 Jeremiah Blanchard

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

ADD_BUTTON_IF = [
  {
    key: 'add-button-if'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_IF = [
  {
    key: 'subtract-button-if'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button-if'
    glyph: '\u25BC'
    border: false
  }
]

BOTH_BUTTON_SWITCH = [
  {
    key: 'subtract-button-switch'
    glyph: '\u25B2'
    border: false
  }
  {
    key: 'add-button-switch'
    glyph: '\u25BC'
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

############################################################
# Rules tell Droplet what to do with different markers.
#
# ### Format: 'tokenName': 'type' ###
#
# Type			Description
# ----			-----------
# skip			skip this token (don't display it)
# comment		Mark as a code comment
# parens		???
# block			An actual block
# indent		Node that marks indentation
# socket                Location for input
# buttonContainer
# lockedSocket
# document


  # Parens : defines nodes that can have parenthesis in them
  # (used to wrap parenthesis in a block with the
  # expression that is inside them, instead
  # of having the parenthesis be a block with a
  # socket that holds an expression)

  # buttonContainer: defines a node that acts as
  # a "button" that can be placed inside of another block (these nodes generally should not
  # be able to be "by themselves", and wont be blocks if they are by themselves)
  # NOTE: the handleButton function in this file determines the behavior for what
  # happens when one of these buttons is pressed

#
############################################################

RULES = {
  # Indents (These elements should have indentation)
  'classBody': {
    'type': 'indent',
    'indexContext': 'classBodyDeclaration',
  },
  'block': {
    'type': 'indent',
    'indexContext': 'blockStatement',
  },

  # Parens

  ##### Skips (no block for these elements in the tree)
  # Parsing artifacts
  'compilationUnit': 'skip',

  # Modifier wrappers
  'classOrInterfaceModifier': 'skip',
  'modifier': 'skip',

  # Type wrappers
  'classDeclaration': 'skip',
  'memberDeclaration': 'skip',
  'methodDeclaration': 'skip',
  'fieldDeclaration': 'skip',
  'typeTypeOrVoid': 'skip',
  'typeName': 'skip',
  'arguments': 'skip',
  'creator': 'skip',

  # Method wrappers
  'formalParameterList': 'skip',
  'formalParameters': 'skip',
  'formalParameter': 'skip',
  'methodBody': 'skip',
  'methodCall': 'skip',
  'expressionList': 'skip',

  # Statement wrappers
  'expression': 'skip',
  'localVariableDeclaration': 'skip',
  'variableDeclarators': 'skip',
  'variableDeclarator': 'skip',
  'variableDeclaratorId': 'skip',
  'literal': 'skip',
#  'switchLabel': 'skip',

  # Type wrappers

  # Sockets (We can put or type stuff here)
  # Import directives
  
  # Variables / constants / typenames / literals
  'IDENTIFIER': 'socket',
  'qualifiedName': 'socket',
  'typeType': 'socket',
  'DECIMAL_LITERAL': 'socket',
  'HEX_LITERAL': 'socket',
  'OCT_LITERAL': 'socket',
  'BINARY_LITERAL': 'socket',
  'FLOAT_LITERAL': 'socket',
  'HEX_FLOAT_LITERAL': 'socket',
  'CHAR_LITERAL': 'socket',
  'STRING_LITERAL': 'socket',
  'BOOL_LITERAL': 'socket',
  'NULL_LITERAL': 'socket',

  # General modifiers (methods, variables, classes, etc)
  'PRIVATE': 'socket',
  'PROTECTED': 'socket',
  'PUBLIC': 'socket',
  'STATIC': 'socket',
  'FINAL': 'socket',
  'NEW': 'socket',

  # Class modifiers (classes only)
  'ABSTRACT': 'socket',

  # Interface method modifiers (interface methods only)
  'DEFAULT': 'socket', # WARNING: TODO: this clashes with "default" for switch statements

  # Method modifiers
  'SYNCHRONIZED': 'socket',
  'NATIVE': 'socket',
  
  # Field modifiers
  #'CONST': 'socket', Not actually a keyword - just reserved?
  'VOLATILE': 'socket',

  # Primitive types
  'BOOLEAN': 'socket',
  'BYTE': 'socket',
  'CHAR': 'socket',
  'DOUBLE': 'socket',
  'FLOAT': 'socket',
  'INT': 'socket',
  'LONG': 'socket',
  'SHORT': 'socket',
  'VOID': 'socket',

  # Object types
  'CLASS': 'socket',

  #### What about these?: ENUM, INTERFACE, EXTENDS, IMPLEMENTS

  # Blocks
  'classBodyDeclaration': 'block',
  'typeDeclaration': 'block',

  'switchBlockStatementGroup': 'indent',

  'statement': (node) ->
    if node.children[0].data?.text is 'if'
      if node.parent?.type is 'statement' and
         node.parent.children[0].data?.text is 'if' and
         node is node.parent.children[4]
        return 'skip'
 
      else if node.children.length is 5
        return {type: 'block', buttons: BOTH_BUTTON_IF}
      else
        return {type: 'block', buttons: ADD_BUTTON_IF}

    else if node.children[0].data?.text is 'switch'
      return {type: 'block', buttons: BOTH_BUTTON_SWITCH}

    return 'block'
}

###################################################################
# Color rules tell Droplet what color-type each token should use.
#
# ### Format: 'tokenName': 'tokenStyle' ###
#
#
# Styles
# ------
#
#
####################################################################

COLOR_RULES = {
  # Import declarations
  'importDeclaration': 'import',

  # Object-types and methods
  'typeDeclaration': 'type',
  'classBodyDeclaration': 'class',
  'methodDeclaration': 'class',
  'fieldDeclaration': 'class',
  'blockStatement': 'statement',
#  'localVariableDeclarationStatement': 'statement',

  'forControl': 'control_special',
  'enhancedForControl': 'control_special',

  # Variables
  
  'variableDeclarator': 'statement',
  'formalParameter': 'statement',
  'statementExpression': 'statement',
  'expression': 'value',
  'parExpression': 'value',
  'primary': 'value',
  'statement': 'statement',
}

handleButton = (str, type, block) ->
  if type is 'add-button-if'
    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indents = indents[-3...]

    if indents.length is 1
      return str + '\nelse\n{\n  \n}\n'

    else if indents.length is 2
      {string: prefix} = model.stringThrough(
        block.start,
        ((token) -> token is indents[0].end),
        false
      )

      suffix = str[prefix.length + 1...]

      return prefix + '\n}\nelse if (a == b)\n{\n    \n' + suffix

    else if indents.length is 3
      {string: prefix} = model.stringThrough(
        block.start,
        ((token) -> token is indents[1].end),
        false
      )

      suffix = str[prefix.length + 1...]

      return prefix + '\n}\nelse if (a == b)\n{\n    \n' + suffix

  else if type is 'subtract-button-if'
    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indents = indents[-3...]

    if indents.length is 1
      return str

    else
      {string: prefix} = model.stringThrough(
        block.start,
        ((token) -> token is indents[0].end),
        false
      )

      {string: suffix} = model.stringThrough(
        block.end,
        ((token) -> token is indents[1].end),
        true
      )

      return prefix + suffix

  else if type is 'add-button-switch'

    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indent = indents[indents.length - 1]
    preindent = indents[indents.length - 2]

    # Determine if the last indent is a default
    # or a case
    if preindent?
      {string: infix} = model.stringThrough(
        preindent.end,
        ((token) -> token is indent.start),
        false
      )

      # If it's a case, go ahead and append
      # at the end. Otherwise, append
      # before the end.
      if infix.indexOf('case') is -1
        indent = preindent

    {string: prefix} = model.stringThrough(
      block.start,
      ((token) -> token is indent.end),
      false
    )

    suffix = str[prefix.length + 1...]

    return prefix + '\n    case n:\n    break;\n' + suffix

  else if type is 'subtract-button-switch'

    indents = []
    block.traverseOneLevel (child) ->
      if child.type is 'indent'
        indents.push child
    indents = indents[-3...]

    if indents.length is 1
      return str

    if indents.length is 3
      {string: infix} = model.stringThrough(
        indents[1].end,
        ((token) -> token is indents[2].start),
        false
      )

      if infix.indexOf('case') >= 0
        indents.shift()

    {string: prefix} = model.stringThrough(
      block.start,
      ((token) -> token is indents[0].end),
      false
    )

    {string: suffix} = model.stringThrough(
      block.end,
      ((token) -> token is indents[1].end),
      true
    )

    return prefix + suffix

  return str

# Acceptance mapping is [drag][drop]
ACCEPT_MAPPING =
{
  'forControl': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.ENCOURAGE,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.ENCOURAGE,
    'forControl': helper.FORBID,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'enhancedForControl': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.ENCOURAGE,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.ENCOURAGE,
    'forControl': helper.FORBID,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'importDeclaration': {
    'document': helper.ENCOURAGE,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
  },
  '__comment__': {
    'document': helper.ENCOURAGE,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.ENCOURAGE,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.ENCOURAGE,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.ENCOURAGE,
    'forControl': helper.FORBID,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'typeDeclaration': {
    'document': helper.ENCOURAGE,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.FORBID,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.FORBID,
    'forControl': helper.FORBID,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'classBodyDeclaration': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.ENCOURAGE

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.FORBID,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.FORBID,
    'forControl': helper.FORBID,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'blockStatement': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.ENCOURAGE,
    'switchLabel': helper.ENCOURAGE,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.ENCOURAGE,
    'forControl': helper.ENCOURAGE,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'statement': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,

    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'classBodyDeclaration': helper.ENCOURAGE,
    'switchLabel': helper.ENCOURAGE,

    'expression': helper.FORBID,
    'parExpression': helper.FORBID,
    'expressionList': helper.FORBID,
    'statement': helper.ENCOURAGE,
    'forControl': helper.ENCOURAGE,

    'NEW': helper.FORBID,
    'createdName': helper.FORBID,
  },
  'parExpression': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'typeDeclaration': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableDeclarators': helper.FORBID,
    'variableDeclarator': helper.FORBID,
    'variableInitializer': helper.ENCOURAGE,

    'classBodyDeclaration': helper.FORBID,
    'statement': helper.FORBID,
    'forControl': helper.FORBID,

    'parExpression': helper.ENCOURAGE,
    'expression': helper.ENCOURAGE,     
  },
  'primary': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'classBodyDeclaration': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableInitializer': helper.ENCOURAGE,

    'statement': helper.FORBID,
    'forControl': helper.FORBID,

    'parExpression': helper.ENCOURAGE,
    'expression': helper.ENCOURAGE,     
  },
  'switchLabel': {
    'document': helper.FORBID,
    'qualifiedName': helper.FORBID,
    'typeDeclaration': helper.FORBID,

    'modifier': helper.FORBID,
    'classOrInterfaceModifier': helper.FORBID,
    'CLASS': helper.FORBID,
    'IDENTIFIER': helper.FORBID,
    'socket': helper.FORBID,
    'DEFAULT': helper.FORBID,

    'typeType': helper.FORBID,
    'typeTypeOrVoid': helper.FORBID,
    'classBodyDeclaration': helper.FORBID,
    'variableDeclaratorId': helper.FORBID,
    'variableInitializer': helper.FORBID,

    'statement': helper.ENCOURAGE,
    'parExpression': helper.FORBID,
    'expression': helper.FORBID,
  },
}

getType = (block) ->
  if !block?
    return null
  if block.parseContext?
    return block.parseContext
  if block.nodeContext?
    return block.nodeContext.type
  if block.type == "indent" && block.parentParseContext? && block.parentParseContext != null
    return block.parentParseContext
  return block.type

# defines behavior for what happens if we try to drop a block
handleAcceptance = (block, context, pred, next) ->
  dragType = getType(block)
  dropType = getType(context)
  nextType = getType(next)
  predType = getType(pred)

  if !dragType? || dragType == null
    console.log "Could not extract block type: " + helper.noCycleStringify(block)
    return null

  # Special case for imports; they can only occur at the beginning of the document or after other imports.
  # We must also prevent other items from going in front of imports.
  if dragType == 'importDeclaration' && !(predType == 'importDeclaration' || predType == 'document')
    return helper.FORBID

  if nextType == 'importDeclaration' && dragType != 'importDeclaration'
    return helper.FORBID
 
  # Deal with indents
  if dropType == 'intent'
    dropType = predType

  if !dropType? || dropType == null
    console.log "Could not extract context type: " + helper.noCycleStringify(context)
    return null


  if ACCEPT_MAPPING[dragType]? && ACCEPT_MAPPING[dragType][dropType]?
#      console.log ("Drag/Drop " + dragType + "/" + dropType + ": " + ACCEPT_MAPPING[dragType][dropType])
      return ACCEPT_MAPPING[dragType][dropType]

  console.log "Uncaught block/context [" + dragType + "/" + dropType + "] with pred/next [" + predType + "/" + nextType + "]:\n" + helper.noCycleStringify(block) + "\n" + helper.noCycleStringify(context) + "\n" + helper.noCycleStringify(pred) + "\n" +  helper.noCycleStringify(next)
  return null
#  return helper.FORBID


SHAPE_RULES = {
  'primary': helper.VALUE_ONLY,
  'expression': helper.VALUE_ONLY,
  'parExpression': helper.VALUE_ONLY,
  'statement': helper.MOSTLY_BLOCK,
  'blockStatement': helper.MOSTLY_BLOCK,
}

# Use a callback function to determine the color/shape of a construct
COLOR_CALLBACK = { }
SHAPE_CALLBACK = { }

# Default colors for various token types
COLOR_DEFAULTS = {
  'type': 'purple',
  'import': 'grey',
  'class': 'blue',
  'value': 'teal',
  'control_special': 'deeporange',

  'statement': (model) ->
    text = helper.trimIdentifierToken model.nodeContext?.prefix
    if text is 'if' or text is 'switch'
      return 'orange'

    else if text is 'for' or text is 'while' or text is 'do'
      return 'amber'

    else if text is 'break' or text is 'continue'
      return 'deeporange'

    return 'green'
}

# Dropdown menu setup
MODIFIERS = [
  'private',
  'protected',
  'public',
  'static',
  'final',
]

CLASS_MODS = MODIFIERS.concat([
  'abstract',
])

METHOD_MODS = MODIFIERS.concat([
  'synchronized',
  'native',
])

# Basic types
BASIC_TYPES = [
  'byte',
  'short',
  'int',
  'long',
  'float',
  'double',
  'char',
  'boolean',
  'String'
]

RETURN_TYPES = BASIC_TYPES.concat([
  'void',
])

DROPDOWNS = {
  'typeType': BASIC_TYPES,
  'classOrInterfaceModifier': CLASS_MODS,
  'modifier': METHOD_MODS,
  'typeTypeOrVoid': RETURN_TYPES,
  
} # Dropdown types? See C file for clues

EMPTY_STRINGS =
{
  'IDENTIFIER': '_'
  'expression': '_'
  'parExpression': '(_)'
}

SHOULD_SOCKET = (opts, node) ->
  return true

PARENS = [
  'statement'
#  'primary'
]
config = {
  RULES, COLOR_RULES, SHAPE_RULES, COLOR_CALLBACK, SHAPE_CALLBACK, COLOR_DEFAULTS, DROPDOWNS, EMPTY_STRINGS, SHOULD_SOCKET, handleAcceptance, handleButton
#  RULES, INDENTS, SKIPS, PARENS, SOCKET_TOKENS, COLOR_RULES, COLOR_DEFAULTS, COLOR_CALLBACK, COLORS_BACKWARD, SHAPE_RULES, SHAPE_CALLBACK
}

#config.PAREN_RULES = {
#  'statement'
#  'blockStatement'
#  'localVariableDeclarationStatement'
#  'primary'
#}

module.exports = parser.wrapParser antlrHelper.createANTLRParser 'Java', config
