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

window.editor = editor = null

# Droplet itself
createEditor = (options) ->
  $('#droplet-editor').html ''
  editor = new droplet.Editor $('#droplet-editor')[0], options

  editor.setEditorState localStorage.getItem('blocks') is 'yes'
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  editor.setValue localStorage.getItem('text') ? ''

  editor.clearUndoStack()

  editor.on 'change', ->
    localStorage.setItem 'text', editor.getValue()

createEditor JSON.parse dropletConfig.getValue()

$('#update').on 'click', ->
  createEditor JSON.parse dropletConfig.getValue()

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')
