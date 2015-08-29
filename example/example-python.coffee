# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/javascript'

dropletConfig.setValue localStorage.getItem('config') ? '''
({
  "mode": "python",
  "palette": [
        {
            'name': 'Input/output',
            'color': 'blue',
            'blocks': [
                {
                    'block': "print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "input('Enter a number')",
                    'context': 'expr'
                },
                {
                    'block': "raw_input('Enter a string')",
                    'context': 'expr'
                }
            ]
        },
        {
            'name': 'Control flow',
            'color': 'control',
            'blocks': [
                {
                    'block': "for i in range(0, 10):\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "if a == b:\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "while a < b:\n  print 'hello'",
                    'context': 'stmt'
                }
            ]
        },
        {
            'name': 'Methods',
            'color': 'control',
            'blocks': [
                {
                    'block': "def myMethod(arg):\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "return 'hello'",
                    'context': 'stmt'
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
