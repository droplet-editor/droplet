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
  examplePrograms = {
    fizzbuzz: '''
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
    quicksort: '''
    globalNumberOfComparisons = 0
    bubblesort = (list) ->
      for _ in [1..list.length]
        for item, i in list
          globalNumberOfComparisons += 1
          if list[i] > list[i+1]
            temp = list[i]
            list[i] = list[i + 1]
            list[i + 1] = temp
      return list
    quicksort = (list) ->
      if list.length <= 1
        return list
      pivotGuess = 0
      for item in list
        globalNumberOfComparisons += 1
        pivotGuess += item / list.length
      smallerList = []
      biggerList = []
      for item in list
        globalNumberOfComparisons += 1
        if item < pivotGuess
          smallerList.push item
        else
          biggerList.push item
      sortedSmallerList = quicksort smallerList
      sortedBiggerList = quicksort biggerList
      for item in sortedBiggerList
        sortedSmallerList.push item
      return sortedSmallerList
    array = [1..1000]
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    quicksort array
    quicksortSpeed = globalNumberOfComparisons
    see 'Quicksort finished in ' + globalNumberOfComparisons + ' operations'
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    globalNumberOfComparisons = 0
    bubblesort array
    see 'Bubblesort finished in ' + globalNumberOfComparisons + ' operations'
    see 'Quicksort was ' + globalNumberOfComparisons / quicksortSpeed + ' times faster'
    '''
    church: '''
    zero = (f) -> (x) -> x
    church = (n) ->
      if n > 0
        return succ church n-1
      return zero
    unchurch = (n) -> n((x) -> x + 1) 0
    succ = (n) -> (f) -> (x) -> f n(f) x
    add = (m, n) -> (f) -> (x) -> m(f) n(f) x
    mult = (m, n) -> (f) -> n m f
    exp = (m, n) -> n m
    pred = (n) -> (f) -> (x) -> n((g) -> (h) -> h(g(f)))(->x)((u)->u)
    sub = (m, n) -> n(pred) m
    see unchurch exp church(2), church(6)
    see unchurch add church(3), church(10)
    see unchurch sub church(10), church(3)
    '''
  }

  # Update textarea on ICE editor change
  editor.onChange = ->
    # Currently empty function
  
  # Trigger immediately
  editor.onChange()

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.setValue examplePrograms.quicksort
  
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
  
  logsElement = document.getElementById 'logs'
  logsContentElement = document.getElementById 'logsContent'
  closeLogsElement = document.getElementById 'closeLogs'
  document.getElementById('run').addEventListener 'click', ->
    logs = []
    see = (arg) ->
      logs.push arg
    eval CoffeeScript.compile editor.getValue()
    see = null

    logsContentElement.innerHTML = logs.join('\n').replace(/</g,'&lt;').replace(/>/g, '&gt;').replace(/&/g,'&amp;').replace(/\n/g, '<br/>')
    logsElement.style.right = '0px'
    closeLogsElement.style.top = '30px'
  
  document.getElementById('closeLogs').addEventListener 'click', ->
    logsElement.style.right = '-500px'
    closeLogsElement.style.top = '0px'
