###
  Added Quote Example
  TODO: Add More cases :)
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
    # Csv TESTING:
    mode: 'csv'
    modeOptions: {
      blockFunctions: ['pen', 'dot', 'blarg']
    }
    palette: [
      {
        name: 'Draw'
        color: 'Blue'
        blocks: [
          {block:'Ford, 1997, E350', title: 'Three blocks'}
          {block:'Ford, 1998', title: 'Two blocks'}
          {block:'Ford', title: 'Single block'}
          {block:'# Comment it', title: 'Comment block'}
          {block: 'Ford,,,Ford',title: 'Special'}
          {block: '__', title: 'Empty'}
        ]
      }
    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    fizzbuzz: '''
    # Example 1
    1997,Ford,E350
    # Example 1
    "1997","Ford","E350"
    # Example 1
    1997,Ford,E350,"Super, luxurious truck"    
    # Example 1
    1997,Ford,E350,"Super, ""luxurious"" truck"
    # Example 1
    1997,Ford,E350,"Go get one now
    they are going fast"    
    '''
    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true
  editor.aceEditor.getSession().setMode 'ace/mode/csv'

  # Initialize to starting text
  startingText = localStorage.getItem 'example'
  editor.setValue startingText or examplePrograms.fizzbuzz

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
