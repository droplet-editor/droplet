require ['main'], (ice) ->
  # Example palette
  window.editor = new ice.Editor document.getElementById('editor'), (ice.parse(paletteElement).next.block for paletteElement in [
    '''
    fd 100
    '''
    '''
    bk 100
    '''
    '''
    rt 90
    '''
    '''
    lt 90
    '''
    '''
    for i in [1..10]
      fd 10
    '''
    '''
    if touches 'red'
      fd 10
    '''
    '''
    rtFd = (arg) ->
      rt 90
      fd arg
      return arg
    '''
  ])
  
  # Example program (fizzbuzz)
  editor.setValue '''
  for i in [1..1000]
    if i % 15 is 0
      console.log 'fizzbuzz'
    else
      if i % 5 is 0
        console.log 'fizz'
      if i % 3 is 0
        console.log 'buzz'
      if i % 3 isnt 0 and i % 5 isnt 0
        console.log i
  '''
  
  # Update textarea on ICE editor change
  editor.onChange = ->
    # Currently empty function
  
  # Trigger immediately
  editor.onChange()
  
  # Buttons for undo, melt, and freeze
  document.getElementById('undo').addEventListener 'click', ->
    editor.undo()
  
  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    unless editor.toggleBlocks()
      # If we were unsuccessful at toggling,
      # put up a message.
      unless editor.currentlyUsingBlocks
        displayMessage 'Syntax error'
