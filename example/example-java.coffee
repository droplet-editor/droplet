# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/javascript'

dropletConfig.setValue localStorage.getItem('config') ? '''
({
  "mode": "java",
  "palette": [
      {
        'name': 'Input/output',
        'color': 'command',
        'blocks': [
            {
                'block': 'System.out.println(10);',
                'context': 'statement'
            },
            {
                'block': 'Scanner s = new Scanner();',
                'context': 'statement'
            },
            {
                'block': 's.nextInt();',
                'context': 'expression'
            },
            {
                'block': 's.next();',
                'context': 'expression'
            }
         ]
      },
      {
        'name': 'Control flow',
        'color': 'yellow',
        'blocks': [
            {
              'block': 'if (a == b) {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'if (a == b) {\n  \n} else {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'while (a < b) {\n  \n} else {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'for(int i = 0; i < 10; i++) {\n  \n}',
              'context': 'statement'
            }
        ]
      },
      {
        'name': 'Variables',
        'color': 'purple',
        'blocks': [
            {
              'block': 'int a;',
              'context': 'statement'
            },
            {
              'block': 'a = 0;',
              'context': 'statement'
            }
        ]
      },
      {
        'name': 'Methods',
        'color': 'red',
        'blocks': [
            {
                'block': 'public int myMethod(int arg) {\n  \n}',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'private int myMethod(int arg) {\n  \n}',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'return 0;',
                'context': 'statement'
            },
            {
                'block': 'myMethod(arg)',
                'context': 'expression'
            }
        ]
      },
      {
        'name': 'Math',
        'color': 'green',
        'blocks': [
            {
              'block': 'a + b',
              'context': 'expression'
            },
            {
              'block': 'a - b',
              'context': 'expression'
            },
            {
              'block': 'a * b',
              'context': 'expression'
            },
            {
              'block': 'a / b',
              'context': 'expression'
            },
            {
              'block': 'a == b',
              'context': 'expression'
            },
            {
              'block': 'a < b',
              'context': 'expression'
            },
            {
              'block': 'a > b',
              'context': 'expression'
            },
            {
              'block': 'Math.pow(a, b)',
              'context': 'expression'
            }
        ]
      },
      {
        'name': 'Classes',
        'color': 'control',
        'blocks': [
            {
                'block': 'class Example {\n  \n}',
                'context': 'compilationUnit'
            },
            {
                'block': 'class Example extends Blank {\n  \n}',
                'context': 'compilationUnit'
            },
            {
                'block': 'public int x;',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'private int x;',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'public static void main(String[] args) {\n  \n}',
                'context': 'classBodyDeclaration'
            }
         ]
      }
  ]
})
'''

editor = null

# Droplet itself
createEditor = (options) ->
  $('#droplet-editor').html ''
  editor = new droplet.Editor $('#droplet-editor')[0], options

  editor.setEditorState localStorage.getItem('blocks') is 'yes'
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  editor.setValue localStorage.getItem('text') ? ''

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
