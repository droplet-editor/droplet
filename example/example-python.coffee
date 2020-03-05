# Droplet config editor
window.expressionContext = {
  prefix: 'a = '
}

window.dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/python'

# dropletConfig.setValue localStorage.getItem('config') ? '''
dropletConfig.setValue '''
  ({
    "mode": "python",
    "modeOptions": {
      "functions": {
        "myFunction": {
          "color": "purple",
          "dropdown": [['foo', 'bar'], ['baz', 'qux']]
        },
        'colorTest': {
          'color': 'yellow',
          'dropdown': [null, ['1', '2', '3']]
        },
        'nestedFn': {
          'color': 'pink'
        }
      }
    },
    "palette": [
      {
        'name': 'Input/output',
        'color': 'blue',
        'blocks': [
          {
            'block': "print 'hello'",
          },
          {
            'block': "input('Enter a number')",
            'wrapperContext': expressionContext
          },
          {
            'block': "raw_input('Enter a string')",
            'wrapperContext': expressionContext
          },
          {
            'block': 'myFunction(drop, down)'
          },
          {
            'block': 'colorTest(0, 1)'
          },
          {
            'block': 'nestedFn(nestedFn(nestedFn))'
          }
        ]
      },
      {
        'name': 'Control flow',
        'color': 'control',
        'blocks': [
          {
            'block': "for i in range(0, 10):\\n  print 'hello'",
          },
          {
            'block': "if a == b:\\n  print 'hello'",
          },
          {
            'block': "while a < b:\\n  print 'hello'",
          }
        ]
      },
      {
        'name': 'Methods',
        'color': 'purple',
        'blocks': [
          {
            'block': 'import module'
          },
          {
            'block': 'from module import something'
          },
          {
            'block': "def myMethod(arg):\\n  print 'hello'",
          },
          {
            'block': "return 'hello'",
          },
          {
            'block': "myMethod(arg)",
            'wrapperContext': expressionContext
          },
        ]
      },
      {
        'name': 'Variables',
        'color': 'red',
        'blocks': [
          {
            'block': 'a = 1'
          }
        ]
      },
      {
        'name': 'Math',
        'color': 'red',
        'blocks': [
          {
            'block': 'a + b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a - b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a * b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a / b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a % b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a ** b',
            'wrapperContext': expressionContext
          }
        ]
      },
      {
        'name': 'Logic',
        'color': 'teal',
        'blocks': [
          {
            'block': 'a == b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a < b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a > b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a and b',
            'wrapperContext': expressionContext
          },
          {
            'block': 'a or b',
            'wrapperContext': expressionContext
          }
        ]
      }
    ]
  })
'''

# Droplet itself
createEditor = (options) ->
  $('#droplet-editor').html ''
  editor = new droplet.Editor $('#droplet-editor')[0], options

  editor.setEditorState localStorage.getItem('blocks') is 'yes'
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  #editor.setValue localStorage.getItem('text') ? ''

  editor.on 'change', ->
    localStorage.setItem 'text', editor.getValue()

  window.editor = editor

createEditor eval dropletConfig.getValue()

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')

# Stuff for testing convenience
$('#update').on 'click', ->
  localStorage.setItem 'config', dropletConfig.getValue()
  createEditor eval dropletConfig.getValue()

configCurrentlyOut = localStorage.getItem('configOut') is 'yes'

updateConfigDrawerState = ->
  if configCurrentlyOut
    $('#left-panel').css 'left', '0px'
    $('#right-panel').css 'left', '525px'
  else
    $('#left-panel').css 'left', '-500px'
    $('#right-panel').css 'left', '25px'

  editor.resize()

  localStorage.setItem 'configOut', (if configCurrentlyOut then 'yes' else 'no')

$('#close').on 'click', ->
  configCurrentlyOut = not configCurrentlyOut
  updateConfigDrawerState()

updateConfigDrawerState()