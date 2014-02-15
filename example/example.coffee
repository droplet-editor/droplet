window.onload = ->
  # Example palette
  window.editor = new ICE.Editor document.getElementById('editor'), (coffee.parse(paletteElement).next.block for paletteElement in [
    '''
    for i in [1..10]
      alert 'hello'
    '''
    '''
    alert 'hello'
    '''
    '''
    if a is b
      alert 'hi'
    else
      alert 'bye'
    '''
    '''
    a = b
    '''
    '''
    return 0
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
    document.getElementById('out').value = editor.getValue()
  
  # Update ICE Editor on textarea change
  document.getElementById('out').addEventListener 'input', ->
    try
      editor.setValue this.value
  
  # Buttons for undo, melt, and freeze
  document.getElementById('undo').addEventListener 'click', ->
    editor.undo()

  document.getElementById('melt').addEventListener 'click', ->
    editor.performMeltAnimation()

  document.getElementById('freeze').addEventListener 'click', ->
    editor.performFreezeAnimation()
