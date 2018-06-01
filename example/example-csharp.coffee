csharp =
  'mode': 'csharp'
  'palette': [
  ]
sessions = {}
editor = new (droplet.Editor)(document.getElementById('editor'), csharp)
document.getElementById('toggle').addEventListener 'click', ->
  editor.toggleBlocks()
  return
