# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/json'

dropletConfig.setValue localStorage.getItem('config') ? '''
  {
    "mode": "coffeescript",
    "modeOptions": {
      "functions": {
        "playSomething": { "command": true, "color": "red"},
        "bk": { "command": true, "color": "blue"},
        "sin": { "command": false, "value": true, "color": "green" }
      },
      "categories": {
        "conditionals": { "color": "purple" },
        "loops": { "color": "green" },
        "functions": { "color": "#49e" }
      }
    },

    "palette": [
     {
        "name": "Palette category",
        "color": "blue",
        "blocks": [
          {
            "block": "for [1..3]\\n  ``",
            "title": "Repeat some code"
          },
          {
            "block": "playSomething()",
            "expansion": "playSomething 'arguments', 100, 'too long to show'"
          }
        ]
      }
    ]
  }
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

createEditor JSON.parse dropletConfig.getValue()

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')

# Stuff for testing convenience
$('#update').on 'click', ->
  localStorage.setItem 'config', dropletConfig.getValue()
  createEditor JSON.parse dropletConfig.getValue()

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
