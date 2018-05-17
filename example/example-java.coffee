java = 
  'mode': 'java'
  'palette': [
  ]
sessions = {}
editor = new (droplet.Editor)(document.getElementById('editor'), java)
document.getElementById('toggle').addEventListener 'click', ->
  editor.toggleBlocks()
  return
