# Droplet config editor
window.expressionContext = {
    prefix: 'a = '
}

window.dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/javascript'

# dropletConfig.setValue localStorage.getItem('config') ? '''
dropletConfig.setValue '''
  ({
    "mode": "javascript",
    "palette": [
      {
        'name': 'Output',
        'color': 'blue',
        'blocks': [ { 'block': 'console.log("hello");' } ]
      },
      {
        'name': 'Variables',
        'color': 'blue',
        'blocks': [
          { 'block': 'var a = 10;' },
          { 'block': 'a = 10;' },
          { 'block': 'a += 1;' },
          { 'block': 'a -= 10;' },
          { 'block': 'a *= 1;' },
          { 'block': 'a /= 1;' }
        ]
      },
      {
        'name': 'Functions',
        'color': 'purple',
        'blocks': [
          { 'block': 'function myFunction(param) {__}' },
          { 'block': 'myFunction(arg);' }
        ]
      },
      {
        'name': 'Logic',
        'color': 'teal',
        'blocks': [
          { 'block': 'a === b' },
          { 'block': 'a !== b' },
          { 'block': 'a > b' },
          { 'block': 'a < b' },
          { 'block': 'a || b' },
          { 'block': 'a && b' },
          { 'block': '!a' }
        ]
      },
      {
        'name': 'Operators',
        'color': 'green',
        'blocks': [
          { 'block': 'a + b' },
          { 'block': 'a - b' },
          { 'block': 'a * b' },
          { 'block': 'a / b' },
          { 'block': 'a % b' },
          { 'block': 'Math.pow(a, b)' },
          { 'block': 'Math.sin(a)' },
          { 'block': 'Math.tan(a)' },
          { 'block': 'Math.cos(a)' },
          { 'block': 'Math.random()' }
        ]
      },
      {
        'name': 'Control flow',
        'color': 'orange',
        'blocks': [
          { 'block': 'for (var i = 0; i < 10; i++) {__}' },
          { 'block': 'if (a === b) {__}' },
          { 'block': 'if (a === b) {__} else {_}' },
          { 'block': 'while (true) {__}' },
          { 'block': 'function myFunction(param) {_}' }
        ]
      },
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