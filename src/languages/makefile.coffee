#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'
treewalk = require '../treewalk.coffee'

# PARSER SECTION
_parse = (context = 'file', text, lineno = 0) ->
  # Root-level context
  if context is 'file'
    lines = text.split '\n'

    rules = []

    currentCollection = null
    endObj = null
    for line, i in lines
      if line[0] is '\t'
        if currentCollection?
          currentCollection.push _parse('recipe', line, lineno + i)
          endObj.line = lineno + i
          endObj.column = line.length

      else if line.match(/^\s*#/)?
        continue

      else if line.indexOf(':') isnt -1 and (line.indexOf('=') is -1 or line.indexOf(':') < line.indexOf('=') - 1)
        currentCollection = []
        endObj = {
          line: lineno + i
          column: line.length
        }
        rules.push {
          type: 'rule'
          children: [
            _parse('target_line', line, lineno + i),
            {
              type: 'rule_collection'
              children: currentCollection
              bounds: {
                start: {
                  line: lineno + i
                  column: line.length
                }
                end: endObj
              }
            }
          ]
          bounds: {
            start: {
              line: lineno + i
              column: 0
            }
            end: endObj
          }
        }
      else if line.indexOf('=') >= 0
        rules.push _parse('assignment', line, lineno + i)

    return {
      type: 'file'
      children: rules
      bounds: {
        start: {
          line: 0
          column: 0
        }
        end: {
          line: lines.length - 1
          column: lines[lines.length - 1].length
        }
      }
    }

  # Recipe -- just freeform text
  else if context is 'recipe'
    return {
      type: 'recipe'
      children: [
        {
          type: 'recipe_contents'
          children: []
          bounds: {
            start: {
              line: lineno
              column: 1
            }
            end: {
              line: lineno
              column: text.length
            }
          }
        }
      ]
      bounds: {
        start: {
          line: lineno
          column: 1
        }
        end: {
          line: lineno
          column: text.length
        }
      }
    }

  # Target text -- like assignment, a left and a right side
  else if context is 'target_line' or context is 'assignment'
    if context is 'target_line'
      colon = text.match(/\s*:\s*/)
    else
      colon = text.match(/\s*=\s*/)
    children = [
      {
        type: if context is 'target_line' then 'target_list' else 'assignee'
        children: []
        bounds: {
          start: {
            line: lineno
            column: 0
          }
          end: {
            line: lineno
            column: colon.index
          }
        }
      }
    ]
    if colon.index + colon[0].length < text.length
      children.push {
        type: if context is 'target_line' then 'target_deps' else 'assignand'
        children: []
        bounds: {
          start: {
            line: lineno
            column: colon.index + colon[0].length
          }
          end: {
            line: lineno
            column: text.length
          }
        }
      }
    return {
      type: context
      children
      bounds: {
        start: {
          line: lineno
          column: 0
        }
        end: {
          line: lineno
          column: text.length
        }
      }
    }


transform = (tree, parent = null) ->
  tree.parent = parent
  tree.children = tree.children.map (child) -> transform child, tree
  return tree

parse = (context, text) ->
  console.log 'WHOLE TREE:', _parse context, text, 0
  transform(_parse(context, text, 0))

RULES = {
  'file': 'skip'
  'target_line': 'skip'

  'rule_collection': 'indent'

  'target_list': 'socket'
  'target_deps': 'socket'
  'assignee': 'socket'
  'assignand': 'socket'

  'recipe': 'block_explicit'

  'recipe_contents': 'socket'
}

COLOR_RULES = [
  ['assignment', 'command']
  ['rule', 'control']
  ['recipe', 'command']
]
SHAPE_RULES = []

config = { RULES, COLOR_RULES, SHAPE_RULES }

config.isComment = (text) -> text.match(/^\s*#/)?
config.parseComment = (text) ->
  return {
    color: 'comment'
    sockets: [[text.match(/^\s*#/)[0].length, text.length]]
  }

config.PAREN_RULES = {}

config.empty = config.emptyIndent = ''

module.exports = parser.wrapParser treewalk.createTreewalkParser parse, config
