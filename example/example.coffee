# Cache bust, since most of our changed code is
# in the require.js 'main' module.
require.config
  paths:
    'ice': '../js/main'
    'ice-helper': '../js/helper'
    'ice-coffee': '../js/coffee'
    'ice-model': '../js/model'
    'ice-view': '../js/view'
    'ice-parser': '../js/parser'
    'ice-draw': '../js/draw'
    'ice-controller': '../js/controller'
    'coffee-script': '../vendor/coffee-script'

readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText


require ['ice'], (ice) ->

  # Example palette
  window.editor = new ice.Editor document.getElementById('editor'), [
    {
      name: 'Common'
      color: 'common'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        'fd 100'
        'bk 100'
        'rt 90'
        'lt 90'
        '''
        button 'Click', ->
          ``
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
        fun = (arg) ->
          return arg
        '''
      ])
    }
    {
      name: 'Turtle'
      color: 'turtle'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        'fd 100'
        'bk 100'
        'rt 90'
        'lt 90'
        'pen red'
        'dot green, 20'
        'slide 10'
        'jumpto 0, 0'
        'turnto 0'
        'rt 90, 100'
        'lt 90, 100'
      ])
    }
    {
      name: 'Control'
      color: 'control'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '''
        if touches 'red'
          fd 10
        '''
        '''
        if touches 'red'
          fd 10
        else
          bk 10
        '''
        '''
        for element, i in list
          see element
        '''
        '''
        for key, value of obj
          see key, value
        '''
        '''
        while touches 'red'
          fd 10
        '''
      ])
    }
    {
      name: 'Functions'
      color: 'functions'
      blocks: [
        ice.parseObj {
          type: 'block'
          socketLevel: 4
          color: 'value'
          children: [
            '('
            {
              type: 'socket'
              precedence: 0
              contents: 'arg'
            }
            ') ->'
            {
              type: 'indent'
              depth: 2
              children: [
                '\n'
                {
                  type: 'block'
                  socketLevel: 1
                  color: 'return'
                  children: [
                    'return '
                    {
                      type: 'socket'
                      precedence: 0
                      contents: 'arg'
                    }
                  ]
                }
              ]
            }
          ]
        }
        ice.parse('return arg').start.next.container
        ice.parseObj {
          type: 'block'
          socketLevel: 1
          color: 'command'
          precedence: 32
          children: [
            {
              type: 'socket'
              precedence: 0
              contents: 'fn'
            },
            '('
            {
              type: 'socket'
              precedence: 0
              contents: 'arg'
            }
            ')'
          ]
        }
      ]
    }
    {
      name: 'Containers'
      color: 'containers'
      blocks: [
        ice.parseObj {
          type: 'block'
          socketLevel: 4
          color: 'value'
          precedence: 32
          children: [
            '['
            {
              type: 'socket'
              precedence: 0
              contents: 'el'
            }
            ']'
          ]
        }
        ice.parse("array.push 'hello'").start.next.container
        ice.parse("array.sort()").start.next.container
        ice.parse('{}').start.next.container
        ice.parseObj {
          type: 'block'
          socketLevel: 4
          precedence: 32
          color: 'value'
          children: [
            '{'
            {
              type: 'indent'
              depth: 2
              children: [
                '\n'
              ]
            }
            '}'
          ]
        }
        ice.parseObj {
          type: 'block'
          color: 'command'
          children: [
            {
              type: 'socket'
              precedence: 0
              contents: 'property'
            }
            ':'
            {
              type: 'socket'
              precedence: 0
              contents: 'value'
            }
          ]
        }
        ice.parse("obj['hello'] = 'world'").start.next.container
      ]
    }
    {
      name: 'Logic'
      color: 'logic'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '1 is 1'
        '1 isnt 2'
        'true and false'
        'false or true'
      ])
    }
    {
      name: 'Math'
      color: 'math'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '2 + 3'
        '2 - 3'
        '2 * 3'
        '2 / 3'
        '2 < 3'
        '3 > 2'
        'Math.pow 2, 3'
        'Math.sqrt 2'
        'random 10'
      ])
    }
  ]
  
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
    quicksort = ([head,tail...]) ->
      return [] unless head?
      globalNumberOfComparisons += 1 + tail.length
      smaller_sorted = quicksort (e for e in tail when e <= head)
      larger_sorted = quicksort (e for e in tail when e > head)
      return smaller_sorted.concat([head]).concat(larger_sorted)
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
    controller: readFile '../src/controller.coffee'
    compiler: readFile '../test/data/nodes.coffee'
    empty: ''
  }

  editor.setEditorState false

  # Update textarea on ICE editor change
  editor.onChange = ->
    # Currently empty function

  # Trigger immediately
  editor.onChange()

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.setValue examplePrograms.fizzbuzz
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
