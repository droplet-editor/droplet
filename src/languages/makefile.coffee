# Droplet Python mode
#
# Copyright (c) 2015 Anthony Bau
# MIT License

helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'
treewalk = require '../treewalk.coffee'

# PARSER SECTION
parse = (context, text, lineno = 0) ->
  # Root-level context
  if context is 'file'
    lines = text.split '\n'

    rules = []

    currentCollection = null
    endObj = null
    for line, i in lines
      if line[0] is '\t'
        if currentCollection?
          currentCollection.push parse('recipe', line, lineno + i)
          endObj.line = lineno + i
          endObj.column = line.length

      else if line.match(/^\s*#/)?
        continue

      else if line.indexOf(':') < line.indexOf('=') - 1
        currentCollection = []
        endObj = {
          line: lineno + i
          column: line.length
        }
        rules.push {
          type: 'rule'
          children: [
            parse('target_line', line, lineno + i),
            {
              type: 'rule_collection'
              children: currentCollection
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
        rules.push parse('assignment', line, lineno + i)

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
              text: lineno
              column: 0
            }
            end: {
              text: lineno
              column: text.length
            }
          }
      ]
      bounds: {
        start: {
          text: lineno
          column: 0
        }
        end: {
          text: lineno
          column: text.length
        }
      }
    }

  # Target text -- like assignment, a left and a right side
  else if context is 'target_text' or context is 'assignment'
    if context is 'target_text'
      colon = text.match(/\s*:\s*/)[0]
    else
      colon = text.match(/\s*=\s*/)[0]
    return {
      type: context
      children: [
        {
          type: if context is 'target_text' then 'target_list' else 'assignee'
          children: []
          bounds: {
            start: {
              text: lineno
              column: 0
            }
            end: {
              text: lineno
              column: colon.index
            }
          }
        }
        {
          type: if context is 'target_text' then 'target_deps' else 'assignand'
          children: []
          bounds: {
            start: {
              text: lineno
              column: colon.index + colon[0].length
            }
            end: {
              text: lineno
              column: text.length
            }
          }
        }
      ]
    }


RULES = {
  'file': 'skip'
  'target_line': 'skip'

  'rule_collection': 'indent'

  'target_list': 'socket'
  'target_deps': 'socket'
  'assignee': 'socket'
  'assignand': 'socket'
  'recipe': 'socket'
}

COLOR_RULES = []
SHAPE_RULES = []

config = { RULES, COLOR_RJULES, SHAPE_RULES }

config.parseComment = (text) ->
  return {
    color: 'comment'
    ranges: [[text.match(/^\s*#/)[0].length, text.length]]
  }

module.exports = parser.wrapParser treewalk.createTreewalkParser parse, config
