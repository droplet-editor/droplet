# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/json'

dropletConfig.setValue localStorage.getItem('config') ? '''
  {
    "mode": "css",
    "palette": [
     {
        "name": "Examples",
        "color": "blue",
        "blocks": [
          {"block": ".spl {\\n  \\n}"},
          {"block": "@media print {\\n  \\n}"},
          {"block": "@page {\\n  \\n}"},
          {"block": "background: 'red';"},
          {"block": "@charset \\"UTF-8\\";"},
          {
            "block": "@import url(\\"\\");",
            "expansion": "@import url(\\"booya.css\\") print, screen;"
          },
          {
            "block": "@namespace \\"uri\\";",
            "expansion": "@namespace svg \\"http://www.w3.org/2000/svg\\";"
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

  editor.clearUndoStack()

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

###
readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText

require.config
  baseUrl: '../js'
  paths: JSON.parse readFile '../requirejs-paths.json'

require ['droplet'], (droplet) ->

  # Example palette
  window.editor = new droplet.Editor document.getElementById('editor'), {
    # CSV TESTING:
    mode: 'css'
    palette: [
      {
        name: 'Basic'
        color: 'violet'
        blocks: [
        ]
      }
    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    descriptive: '''
      body {
        background: #eee;
        color: #888;
      }

      .spl {
        background: #eee;
        color: #888;
      }

      '''

    sample: '''
      @charset "UTF-8";

      @import url("booya.css") print,screen;
      @import "whatup.css" screen;
      @import "wicked.css";

      @namespace "http://www.w3.org/1999/xhtml";
      @namespace svg "http://www.w3.org/2000/svg";

      @keyframes 'diagonal-slide' {
          from {
              left: 0;
              top: 0;
          }

          to {
              left: 100px;
              top: 100px;
          }
      }

      li.inline {
        background: url("something.png");
        display: inline;
        padding-left: 3px;
        padding-right: 7px;
        border-right: 1px dotted #066;
      }

      li.last {
        display: inline;
        padding-left: 3px !important;
        padding-right: 3px;
        border-right: 0px;
      }

      @media print {
          li.inline {
            color: black;
          }
      }

      @page {
        margin: 10%;
        counter-increment: page;

        @top-center {
          font-family: sans-serif;
          font-weight: bold;
          font-size: 2em;
          content: counter(page);
        }
      }

      '''

    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true
  editor.aceEditor.getSession().setMode 'ace/mode/css'

  # Initialize to starting text
  startingText = localStorage.getItem 'example'
  editor.setValue startingText or examplePrograms.descriptive

  # Update textarea on ICE editor change
  onChange = ->
    localStorage.setItem 'example', editor.getValue()

  editor.on 'change', onChange

  editor.aceEditor.on 'change', onChange

  # Trigger immediately
  do onChange

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.clearUndoStack()

  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    editor.toggleBlocks()
    if $('#palette_dialog').dialog 'isOpen'
      $('#palette_dialog').dialog 'close'
    else
      $("#palette_dialog").dialog 'open'
###