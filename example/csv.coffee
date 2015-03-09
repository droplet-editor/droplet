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
    mode: 'csv'
    palette: [
      {
        name: 'Basic'
        color: 'violet'
        blocks: [
          {block:'v1,v2,v3', title: 'Comma Separated Values'}
          {block: '//This is a sample comment.', title: 'Comment'}
        ]
      }
    ]
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    descriptive: '''
      //Going by wikipedia examples
      //This works
      1997,Ford,E350

      //This works
      "1997","Ford","E350"

      //This works
      1997,Ford,E350,"Super, luxurious truck"

      //This works partially
      1997,Ford,E350,"Super, ""luxurious"" truck"

      //Whitespaces around words aren't modifiable
      1997, Ford, E350
      not same as
      1997,Ford,E350
      '''

    sample: '''
      monday,4.0,frank
      tuesday,2.3,sally
      wednesday,1.8,carol
      '''

    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true
  editor.aceEditor.getSession().setMode 'ace/mode/csv'

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
