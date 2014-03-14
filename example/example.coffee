# Cache bust, since most of our changed code is
# in the require.js 'main' module.
require.config
  urlArgs: "bust=" + (new Date()).getTime()

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
    see 'hi'
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
      see 'fizzbuzz'
    else
      if i % 5 is 0
        see 'fizz'
      if i % 3 is 0
        see 'buzz'
      if i % 3 isnt 0 and i % 5 isnt 0
        see i
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
      unless editor.currentlyUsingBlocks or editor.currentlyAnimating
        displayMessage 'Syntax error'
  
  ###
  logsElement = document.getElementById 'logs'
  logsContentElement = document.getElementById 'logsContent'
  closeLogsElement = document.getElementById 'closeLogs'
  document.getElementById('run').addEventListener 'click', ->
    logs = []
    see = (arg) ->
      logs.push arg
    eval CoffeeScript.compile editor.getValue()
    see = null

    logsContentElement.innerText = logs.join '\n'
    logsElement.style.right = '0px'
    closeLogsElement.style.top = '30px'
  
  document.getElementById('closeLogs').addEventListener 'click', ->
    logsElement.style.right = '-500px'
    closeLogsElement.style.top = '0px'
  ###
