# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/json'

dropletConfig.setValue localStorage.getItem('config') ? '''
  {
    "mode": "css",
    "palette": [
     {
        "name": "All",
        "color": "lightblue",
        "blocks": [
          {"block": "a {\\n  \\n}"},
          {"block": "background: 'red';"},
          {
            "block": "selector.highlights",
            "expansion": "elementName.class#id:hover::before > div[target=_blank]"
          },
          {"block": "@charset \\"UTF-8\\";"},
          {
            "block": "@import url(\\"\\");",
            "expansion": "@import url(\\"booya.css\\") print, screen;"
          },
          {
            "block": "@namespace \\"uri\\";",
            "expansion": "@namespace svg \\"http://www.w3.org/2000/svg\\";"
          },
          {"block": "@font-face {\\n  \\n}"},
          {"block": "@keyframes mymove {\\n  \\n}"},
          {"block": "@page {\\n  \\n}"},
          {"block": "@media print {\\n  \\n}"}
        ]
      },
      {
        "name": "Properties",
        "color": "orange",
        "blocks": [
          {"block": "display: none;"},
          {"block": "width: 1366px;"},
          {"block": "height: 80%;"},
          {"block": "font-size: small;"},
          {"block": "font-weight: 500;"},
          {
            "block": "font-family: serif;",
            "expansion": "font-family: \\"Times New Roman\\", Times, serif;"
          },
          {"block": "color: blue;"},
          {"block": "float: left;"},
          {
            "block": "padding: 10%",
            "expansion": "padding: 25px 50px 75px 100px;"
          },
          {"block": "text-align: center;"},
          {"block": "border: 5px solid red;"},
          {"block": "margin: 10px;"},
          {"block": "position: relative;"},
          {"block": "z-index: 10;"},
          {
            "block": "background: black;",
            "expansion": "background: #ffffff url(\\"img_tree.png\\") no-repeat right top;"
          },
          {"block": "text-decoration: none;"},
          {"block": "left: 100px;"},
          {"block": "overflow: hidden;"},
          {"block": "clear: none;"},
          {"block": "cursor: crosshair;"},
          {"block": "visibility: hidden;"}
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
