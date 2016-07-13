helper = require '../../src/helper.coffee'
model = require '../../src/model.coffee'
view = require '../../src/view.coffee'
draw = require '../../src/draw.coffee'
droplet = require '../../dist/droplet-full.js'
seedrandom = require 'seedrandom'

`
// Mouse event simluation function
function simulate(type, target, options) {
  if ('string' == typeof(target)) {
    target = $(target).get(0)
  }
  options = options || {}
  var pageX = pageY = clientX = clientY = dx = dy = 0
  var location = options.location || target
  if (location) {
    if ('string' == typeof(location)) {
      location = $(location).get(0)
    }
    var gbcr = location.getBoundingClientRect()
    clientX = gbcr.left,
    clientY = gbcr.top,
    pageX = clientX + window.pageXOffset
    pageY = clientY + window.pageYOffset
    dx = Math.floor((gbcr.right - gbcr.left) / 2)
    dy = Math.floor((gbcr.bottom - gbcr.top) / 2)
  }
  if ('dx' in options) dx = options.dx
  if ('dy' in options) dy = options.dy
  pageX = (options.pageX == null ? pageX : options.pageX) + dx
  pageY = (options.pageY == null ? pageY : options.pageY) + dy
  clientX = pageX - window.pageXOffset
  clientY = pageY - window.pageYOffset
  var opts = {
      bubbles: options.bubbles || true,
      cancelable: options.cancelable || true,
      view: options.view || target.ownerDocument.defaultView,
      detail: options.detail || 1,
      pageX: pageX,
      pageY: pageY,
      clientX: clientX,
      clientY: clientY,
      screenX: clientX + window.screenLeft,
      screenY: clientY + window.screenTop,
      ctrlKey: options.ctrlKey || false,
      altKey: options.altKey || false,
      shiftKey: options.shiftKey || false,
      metaKey: options.metaKey || false,
      button: options.button || 0,
      which: options.which || 1,
      relatedTarget: options.relatedTarget || null,
  }
  //console.log(location.className);
  //console.log(JSON.stringify(location.getBoundingClientRect()));
  //console.log(JSON.stringify(opts, function(key, val) { if (key == '' || key == 'pageX' || key == 'pageY' || key == 'clientX' || key == 'clientY' || key == 'screenX' || key == 'screenY') return val; }));
  var evt
  try {
    // Modern API supported by IE9+
    evt = new MouseEvent(type, opts)
  } catch (e) {
    // Old API still required by PhantomJS.
    evt = target.ownerDocument.createEvent('MouseEvents')
    evt.initMouseEvent(type, opts.bubbles, opts.cancelable, opts.view,
      opts.detail, opts.screenX, opts.screenY, opts.clientX, opts.clientY,
      opts.ctrlKey, opts.altKey, opts.shiftKey, opts.metaKey, opts.button,
      opts.relatedTarget)
  }
  target.dispatchEvent(evt)
}
function sequence(delay) {
  var seq = [],
      chain = { then: function(fn) { seq.push(fn); return chain; } }
  function advance() {
    setTimeout(function() {
      if (seq.length) {
        (seq.shift())()
        advance()
      }
    }, delay)
  }
  advance()
  return chain
}
`

pickUpLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  bound = editor.session.view.getViewNodeFor(block).bounds[0]
  simulate('mousedown', editor.mainCanvas, {
    location: editor.dropletElement,
    dx: bound.x + 5 + editor.gutter.clientWidth,
    dy: bound.y + 5
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.dropletElement,
    dx: bound.x + 10 + editor.gutter.clientWidth,
    dy: bound.y + 10
  })

dropLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  blockView = editor.session.view.getViewNodeFor block
  simulate('mousemove', editor.dragCover, {
    location: editor.dropletElement,
    dx: blockView.dropPoint.x + 5 + editor.gutter.clientWidth,
    dy: blockView.dropPoint.y + 5
  })
  simulate('mouseup', editor.mainCanvas, {
    location: editor.dropletElement,
    dx: blockView.dropPoint.x + 5 + editor.gutter.clientWidth,
    dy: blockView.dropPoint.y + 5
  })

asyncTest 'Controller: palette block expansion', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  varcount = 0
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    palette: [{
      name: 'Draw',
      color: 'blue',
      blocks: [{
        block: 'pen()',
        expansion: 'pen red',
        id: 'ptest'
      }, {
        block: 'a = b',
        expansion: -> return 'a' + (++varcount) + ' = b'
        id: 'ftest'
      },
      ],
    }]
  })

  simulate('mousedown', '[data-id=ptest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[data-id=ptest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div' })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div' })
  equal(editor.getValue().trim(), 'pen red')
  simulate('mousedown', '[data-id=ftest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[data-id=ftest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div', dx: 45 + 43, dy: 40 })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div', dx: 45 + 43, dy: 40 })
  equal(editor.getValue().trim(), 'pen red\na3 = b')
  simulate('mousedown', '[data-id=ftest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[data-id=ftest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div', dx: 45 + 43, dy: 70 })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-wrapper-div', dx: 45 + 43, dy: 70 })
  equal(editor.getValue().trim(), 'pen red\na3 = b\na6 = b')
  start()

asyncTest 'Controller: reparse and undo reparse', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  varcount = 0
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'javascript',
    palette: []
  })

  editor.setEditorState(true)
  editor.setValue('var hello = 1;')

  simulate('mousedown', '.droplet-main-canvas', {dx: 120, dy: 20})
  simulate('mouseup', '.droplet-main-canvas', {dx: 120, dy: 20})

  ok(editor.cursorAtSocket(), 'Has text focus')
  equal(editor.getCursor().stringify(), '1')

  $('.droplet-hidden-input').sendkeys('2 + 3')

  setTimeout((->
    ok(editor.cursorAtSocket(), 'Editor still has text focus')
    equal(editor.getCursor().stringify(), '2 + 3')

    # unfocus
    evt = document.createEvent 'Event'
    evt.initEvent 'keydown', true, true
    evt.keyCode = evt.which = 13
    editor.dropletElement.dispatchEvent(evt)

    # Sockets are separate
    simulate('mousedown', '.droplet-main-canvas', {dx: 120, dy: 30})
    simulate('mouseup', '.droplet-main-canvas', {dx: 120, dy: 30})

    ok(editor.cursorAtSocket(), 'Has text focus')

    equal(editor.getCursor().stringify(), '2', 'Successfully reparsed')

    editor.undo()

    setTimeout (->
      simulate('mousedown', '.droplet-main-canvas', {dx: 120, dy: 20})
      simulate('mouseup', '.droplet-main-canvas', {dx: 120, dy: 20})
      equal(editor.getCursor().stringify(), '1', 'Successfully undid reparse')
    ), 0

    start()
  ), 0)

asyncTest 'Controller: reparse fallback', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  varcount = 0
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'javascript',
    palette: []
  })

  editor.setEditorState(true)
  editor.setValue('var hello = mFunction(a);')

  simulate('mousedown', '.droplet-main-canvas', {dx: 220, dy: 30})
  simulate('mouseup', '.droplet-main-canvas', {dx: 220, dy: 30})

  ok(editor.cursorAtSocket(), 'Has text focus')
  equal(editor.getCursor().stringify(), 'a')

  $('.droplet-hidden-input').sendkeys('a, b')

  setTimeout((->
    ok(editor.cursorAtSocket(), 'Editor still has text focus')
    equal(editor.getCursor().stringify(), 'a, b')

    # unfocus
    evt = document.createEvent 'Event'
    evt.initEvent 'keydown', true, true
    evt.keyCode = evt.which = 13
    editor.dropletElement.dispatchEvent(evt)

    # Did not insert parentheses
    equal(editor.getValue().trim(), 'var hello = mFunction(a, b);')

    # Sockets are separate
    simulate('mousedown', '.droplet-main-canvas', {dx: 220, dy: 30})
    simulate('mouseup', '.droplet-main-canvas', {dx: 220, dy: 30})

    ok(editor.cursorAtSocket(), 'Has text focus')

    equal(editor.getCursor().stringify(), 'a')

    start()
  ), 10)

asyncTest 'Controller: does not throw on reparse error', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  varcount = 0
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'javascript',
    palette: []
  })

  before = $('[stroke=#F00]').length

  editor.setEditorState(true)
  editor.setValue('var hello = function (a) {};')

  simulate('mousedown', '.droplet-main-canvas', {dx: 220, dy: 30})
  simulate('mouseup', '.droplet-main-canvas', {dx: 220, dy: 30})

  ok(editor.getCursor(), 'Has text focus')
  equal(editor.getCursor().stringify(), 'a')

  $('.droplet-hidden-input').sendkeys('18n')

  setTimeout((->
    ok(editor.getCursor(), 'Editor still has getCursor()')
    equal(editor.getCursor().stringify(), '18n')

    # unfocus
    evt = document.createEvent 'Event'
    evt.initEvent 'keydown', true, true
    evt.keyCode = evt.which = 13
    editor.dropletElement.dispatchEvent(evt)

    ok(true, 'Does not throw on reparse')

    after = $('[stroke=#F00]').length

    ok(after > before, 'Marks block with a red line')

    start()
  ), 10)

asyncTest 'Controller: Can replace a block where we found it', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'javascript',
    palette: []
  })

  editor.setEditorState(true)
  editor.setValue('for (var i = 0; i < 5; i++) {\n' +
                   '  fd(10);\n' +
                   '}\n')
  simulate('mousedown', '.droplet-main-canvas', {dx: 260, dy: 30})
  simulate('mousemove', '.droplet-drag-cover'
    {location: '.droplet-main-canvas', dx: 265, dy: 35})
  simulate('mouseup', '.droplet-drag-cover'
    {location: '.droplet-main-canvas', dx: 265, dy: 35})
  equal(editor.getValue() , 'for (var i = 0; i < 5; i++) {\n' +
                            '  fd(10);\n' +
                            '}\n')

  simulate('mousedown', '.droplet-main-canvas', {dx: 260, dy: 30})
  simulate('mousemove', '.droplet-drag-cover'
    {location: '.droplet-main-canvas', dx: 210, dy: 25})
  simulate('mouseup', '.droplet-drag-cover'
    {location: '.droplet-main-canvas', dx: 210, dy: 25})
  equal(editor.getValue() , 'for (var i = 0; i < i++; __) {\n' +
                            '  fd(10);\n' +
                            '}\n')
  start()

getRandomDragOp = (editor, rng) ->
  # Find the locations of all the blocks
  head = editor.session.tree.start
  # Skip the first block if it is the entire document
  if head.next.container?.end is editor.session.tree.end.prev
    head = head.next.next
  dragPossibilities = []
  until head is editor.session.tree.end
    if head.type is 'blockStart'
      bound = editor.session.view.getViewNodeFor(head.container).bounds[0]
      handle = {x: bound.x + 5, y: bound.y + 5}
      dragPossibilities.push {
        block: head.container
        handle: handle
      }
    head = head.next

  drag = dragPossibilities[Math.floor rng() * dragPossibilities.length]

  # Find all the drop areas
  head = editor.session.tree.start

  # Disclude the main tree if we're dragging the first block
  if drag is dragPossibilities[0]
    head = head.next
  dropPossibilities = []
  until head is editor.session.tree.end
    if head is drag.block.start
      head = drag.block.end
    if head.type.match(/Start$/)?
      dropPoint = editor.session.view.getViewNodeFor(head.container).dropPoint
      if dropPoint?
        if head.container.type is 'block'
          parent = head.container.parent
        else
          parent = head.container

        canDrop = editor.getAcceptLevel(drag.block, head.container)

        if canDrop is 1
          dropPossibilities.push {
            block: head.container
            point: {x: dropPoint.x, y: dropPoint.y}
          }
    head = head.next

  # If this block is not droppable, try again.
  if dropPossibilities.length is 0
    return getRandomDragOp(editor, rng)

  drop = dropPossibilities[Math.floor rng() * dropPossibilities.length]

  return {drag, drop}

generateRandomAlphabetic = (rng) ->
  alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  str = ''
  str += alphabet[Math.floor rng() * alphabet.length]
  until rng() < 0.1
    str += alphabet[Math.floor rng() * alphabet.length]
  return str

getRandomTextOp = (editor, rng) ->
  head = editor.session.tree.start
  socketPossibilities = []
  until head is editor.session.tree.end
    if head.type is 'socketStart' and head.container.editable()
      bound = editor.session.view.getViewNodeFor(head.container).bounds[0]
      handle = {x: bound.x + 5, y: bound.y + 5}
      socketPossibilities.push {
        block: head.container
        handle: handle
      }
    head = head.next

  socket = socketPossibilities[Math.floor rng() * socketPossibilities.length]

  text = generateRandomAlphabetic rng

  return {socket, text}

performTextOperation = (editor, text, cb) ->
  simulate('mousedown', editor.mainCanvas, {
    location: editor.dropletElement
    dx: text.socket.handle.x + editor.gutter.clientWidth,
    dy: text.socket.handle.y
  })
  simulate('mouseup', editor.mainCanvas, {
    location: editor.dropletElement,
    dx: text.socket.handle.x + editor.gutter.clientWidth,
    dy: text.socket.handle.y
  })
  setTimeout (->
    $(editor.hiddeninput).sendkeys(text.text)

    # Unfocus
    evt = document.createEvent 'Event'
    evt.initEvent 'keydown', true, true
    evt.keyCode = evt.which = 13
    editor.dropletElement.dispatchEvent(evt)

    setTimeout cb, 0
  ), 0

performDragOperation = (editor, drag, cb) ->
  simulate('mousedown', editor.mainCanvas, {
    location: editor.dropletElement,
    dx: drag.drag.handle.x + editor.gutter.clientWidth,
    dy: drag.drag.handle.y
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.dropletElement,
    dx: drag.drag.handle.x + 5 + editor.gutter.clientWidth,
    dy: drag.drag.handle.y + 5
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.dropletElement,
    dx: drag.drop.point.x + 5 + editor.gutter.clientWidth
    dy: drag.drop.point.y + 5
  })
  simulate('mouseup', editor.mainCanvas, {
    location: editor.dropletElement,
    dx: drag.drop.point.x + 5 + editor.gutter.clientWidth
    dy: drag.drop.point.y + 5
  })

  # Unfocus
  if editor.cursorAtSocket()
    evt = document.createEvent 'Event'
    evt.initEvent 'keydown', true, true
    evt.keyCode = evt.which = 13
    editor.dropletElement.dispatchEvent(evt)

  setTimeout cb, 0

executeAsyncSequence = (sequence, i = 0) ->
  if i < sequence.length
    sequence[i]()
    setTimeout (->
      executeAsyncSequence sequence, i + 1
    ), 0

asyncTest 'Controller: remembered sockets', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: false}
        bk: {command: true, value: false}
    palette: [
      {
        name: 'Blocks'
        blocks: [
          {block: 'a is b'}
          {block: 'fd 10'}
          {block: 'bk 10'}
          {block: '''
          for i in [0..10]
            ``
          '''}
          {block: '''
          if a is b
            ``
          '''}
        ]
      }
    ]
  })

  editor.setEditorState(true)
  editor.setValue('''
  for i in [0..10]
    if i % 2 is 0
      fd 10
    else
      bk 10
  ''')

  executeAsyncSequence [
    (->
      pickUpLocation editor, 0, {
        row: 0
        col: 9
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 2
        col: 7
        type: 'socket'
      }
    ), (->
      equal(editor.getValue(), '''
      for i in ``
        if i % 2 is 0
          fd [0..10]
        else
          bk 10\n
      ''')
    ), (->
      pickUpLocation editor, 0, {
        row: 2
        col: 4
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 3
        col: 6
        type: 'indent'
      }
    ), (->
      pickUpLocation editor, 0, {
        row: 4
        col: 7
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 0
        col: 9
        type: 'socket'
      }
    ), (->
      equal(editor.getValue(), '''
      for i in [0..10]
        if i % 2 is 0
          ``
        else
          fd 10
          bk 10\n
      ''')
    ), (->
      editor.undo()
    ), (->
      equal(editor.getValue(), '''
      for i in ``
        if i % 2 is 0
          ``
        else
          fd [0..10]
          bk 10\n
      ''')
    ), (->
      pickUpLocation editor, 0, {
        row: 4
        col: 7
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 0
        col: 9
        type: 'socket'
      }
    ), (->
      equal(editor.getValue(), '''
      for i in [0..10]
        if i % 2 is 0
          ``
        else
          fd 10
          bk 10\n
      ''')
      start()
    )
  ]

asyncTest 'Controller: floating blocks with remembered sockets', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: true}
    palette: [
      {
        name: 'Blocks'
        blocks: [
          {block: 'a is b'}
          {block: 'fd 10'}
          {block: 'bk 10'}
          {block: '''
          for i in [0..10]
            ``
          '''}
          {block: '''
          if a is b
            ``
          '''}
        ]
      }
    ]
  })

  editor.setEditorState(true)
  editor.setValue('''
  fd 10
  fd 20
  fd 30
  ''')

  executeAsyncSequence [
    (->
      pickUpLocation editor, 0, {
        row: 0
        col: 0
        type: 'block'
      }

      # Create a floating block
      simulate('mousemove', editor.dragCover, {
        location: editor.dropletElement,
        dx: 600 + 5 + editor.gutter.clientWidth,
        dy: 10 + 5
      })
      simulate('mouseup', editor.mainCanvas, {
        location: editor.dropletElement,
        dx: 600 + 5 + editor.gutter.clientWidth,
        dy: 10 + 5
      })
    ), (->
      equal(editor.getValue(), '''
      fd 20
      fd 30\n
      ''')

      equal(editor.session.floatingBlocks.length, 1)
    ), (->
      pickUpLocation editor, 0, {
        row: 0
        col: 0
        type: 'block'
      }

      simulate('mousemove', editor.dragCover, {
        location: editor.dropletElement,
        dx: 450 + 5 + editor.gutter.clientWidth,
        dy: 10 + 5
      })
      simulate('mouseup', editor.mainCanvas, {
        location: editor.dropletElement,
        dx: 450 + 5 + editor.gutter.clientWidth,
        dy: 10 + 5
      })
    ), (->
      equal(editor.session.floatingBlocks.length, 2)
      equal(editor.getValue(), '''
      fd 30\n
      ''')
    ), (->
      pickUpLocation editor, 0, {
        row: 0
        col: 0
        type: 'block'
      }
      # Drop in floating block
      dropLocation editor, 2, {
        row: 0
        col: 3
        type: 'socket'
      }
    ), (->
      equal(editor.session.floatingBlocks[1].block.stringify(), '''
      fd fd 30
      ''')
    ), (->
      # Move a block from floating block 1 to 2 so as to destroy floating block 1,
      # potentially messing up the undo stack
      pickUpLocation editor, 1, {
        row: 0
        col: 0
        type: 'block'
      }
      # Drop in floating block
      dropLocation editor, 2, {
        row: 0
        col: 6
        type: 'socket'
      }
    ), (->
      equal(editor.session.floatingBlocks.length, 1)
      equal(editor.session.floatingBlocks[0].block.stringify(), '''
      fd fd fd 10
      ''')
    ), (->
      editor.undo()
    ), (->
      # Ensure that the undo worked
      equal(editor.session.floatingBlocks.length, 2)
      equal(editor.session.floatingBlocks[0].block.stringify(), '''
      fd 10
      ''')
      equal(editor.session.floatingBlocks[1].block.stringify(), '''
      fd fd 30
      ''')
    ), (->
      editor.undo()
    ), (->
      # Ensure that the undo worked
      equal(editor.session.floatingBlocks.length, 2)
      equal(editor.session.floatingBlocks[0].block.stringify(), '''
      fd 10
      ''')
      equal(editor.session.floatingBlocks[1].block.stringify(), '''
      fd 20
      ''')
      equal(editor.getValue(), '''
      fd 30\n
      ''')

      start()
    )
  ]

asyncTest 'Controller: Quoted string selection', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: false}
        bk: {command: true, value: false}
    palette: [
      {
        name: 'Blocks'
        blocks: [
          {block: 'a is b'}
          {block: 'fd 10'}
          {block: 'bk 10'}
          {block: '''
          for i in [0..10]
            ``
          '''}
          {block: '''
          if a is b
            ``
          '''}
        ]
      }
    ]
  })

  editor.setEditorState(true)
  editor.setValue('fd "hello"')

  entity = editor.session.tree.getFromTextLocation({row: 0, col: 'fd '.length, type: 'socket'})
  {x, y} = editor.session.view.getViewNodeFor(entity).bounds[0]

  simulate('mousedown', editor.mainCanvas, {
    location: editor.dropletElement
    dx: x + 5 + editor.gutter.clientWidth
    dy: y + 5
  })
  simulate('mouseup', editor.mainCanvas, {
    location: editor.dropletElement
    dx: x + 5 + editor.gutter.clientWidth
    dy: y + 5
  })

  setTimeout (->
    equal editor.hiddenInput.selectionStart, 1
    equal editor.hiddenInput.selectionEnd, 6

    start()
  ), 0

asyncTest 'Controller: Quoted string CoffeeScript autoescape', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: false}
        bk: {command: true, value: false}
    palette: [
      {
        name: 'Blocks'
        blocks: [
          {block: 'a is b'}
          {block: 'fd 10'}
          {block: 'bk 10'}
          {block: '''
          for i in [0..10]
            ``
          '''}
          {block: '''
          if a is b
            ``
          '''}
        ]
      }
    ]
  })

  editor.setEditorState(true)
  editor.setValue("fd 'hello'")

  entity = editor.session.tree.getFromTextLocation({row: 0, col: 'fd '.length, type: 'socket'})
  {x, y} = editor.session.view.getViewNodeFor(entity).bounds[0]

  executeAsyncSequence [
    (->
      simulate('mousedown', editor.mainCanvas, {
        location: editor.dropletElement
        dx: x + 5 + editor.gutter.clientWidth
        dy: y + 5
      })
      simulate('mouseup', editor.mainCanvas, {
        location: editor.dropletElement
        dx: x + 5 + editor.gutter.clientWidth
        dy: y + 5
      })
    ), (->
      equal editor.hiddenInput.selectionStart, 1
      equal editor.hiddenInput.selectionEnd, 6

      $('.droplet-hidden-input').sendkeys("h\\tel\\\\\"'lo")
    ), (->
      # unfocus
      evt = document.createEvent 'Event'
      evt.initEvent 'keydown', true, true
      evt.keyCode = evt.which = 13
      editor.dropletElement.dispatchEvent(evt)
    ), (->
      equal editor.getValue(), """fd 'h\\tel\\\\"\\'lo'\n"""
      start()
    )
  ]

asyncTest 'Controller: Session switch test', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: false}
        bk: {command: true, value: false}
    palette: [
      {
        name: 'Blocks 1'
        blocks: [
          {block: 'a is b'}
        ]
      }
      {
        name: 'Blocks 2'
        blocks: [
          {block: 'a is b'}
        ]
      }
      {
        name: 'Blocks 3'
        blocks: [
          {block: 'a is b'}
        ]
      }
      {
        name: 'Blocks 4'
        blocks: [
          {block: 'a is b'}
        ]
      }
      {
        name: 'Blocks 5'
        blocks: [
          {block: 'a is b'}
        ]
      }
      {
        name: 'Blocks 6'
        blocks: [
          {block: 'a is b'}
        ]
      }
    ]
  })

  originalSession = editor.aceEditor.getSession()

  editor.setEditorState(true)
  editor.setValue('''
  for i in [0..10]
    if i % 2 is 0
      fd 10
    else
      bk 10
  ''')

  equal editor.paletteHeader.childElementCount, 3, 'Palette header originally has three rows'

  newSession = ace.createEditSession('''
  for (var i = 0; i < 10; i++) {
    if (i % 2 === 0) {
      fd(10);
    }
    else {
      bk(10);
    }
  }
  ''', 'ace/mode/javascript')

  executeAsyncSequence [
    (->
      editor.aceEditor.setSession newSession
    ),
    (->
      editor.bindNewSession({
        mode: 'javascript',
        palette: []
      })

      editor.setEditorState(true)
      equal editor.getValue(), '''
      for (var i = 0; i < 10; i++) {
        if (i % 2 === 0) {
          fd(10);
        }
        else {
          bk(10);
        }
      }\n
      ''', 'Set value of new session'

      equal editor.paletteHeader.childElementCount, 0, 'Palette header now empty'

      equal editor.paletteWrapper.style.left is '0px', true, 'Using blocks'
      editor.setEditorState(false)

      equal editor.paletteWrapper.style.left is '0px', false, 'No longer using blocks'
    ),
    (->
      editor.aceEditor.setSession originalSession
    ),
    (->
      equal editor.getValue(), '''
      for i in [0..10]
        if i % 2 is 0
          fd 10
        else
          bk 10\n
      ''', 'Original text restored'

      equal editor.paletteWrapper.style.left is '0px', true, 'Using blocks again'
      equal editor.paletteHeader.childElementCount, 3, 'Original palette header size restored'
    ),
    (->
      editor.aceEditor.setSession newSession
    ),
    (->
      equal editor.getValue(), '''
      for (var i = 0; i < 10; i++) {
        if (i % 2 === 0) {
          fd(10);
        }
        else {
          bk(10);
        }
      }\n
      ''', 'Set value of new session'

      equal editor.paletteWrapper.style.left is '0px', false, 'No longer using blocks'
      equal editor.paletteHeader.childElementCount, 0, 'Palette header now empty'

      start()
    )
  ]

asyncTest 'Controller: Random drag undo test', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'coffeescript',
    modeOptions:
      functions:
        fd: {command: true, value: false}
        bk: {command: true, value: false}
    palette: [
      {
        name: 'Blocks'
        blocks: [
          {block: 'a is b'}
          {block: 'fd 10'}
          {block: 'bk 10'}
          {block: '''
          for i in [0..10]
            ``
          '''}
          {block: '''
          if a is b
            ``
          '''}
        ]
      }
    ]
  })

  editor.setEditorState(true)
  editor.setValue('''
  for i in [0..10]
    if i % 2 is 0
      fd 10
    else
      bk 10
  ''')
  rng = seedrandom('droplet')
  stateStack = []

  tick = (count) ->
    cb = ->
      if count is 0
        stateStack.push editor.getSerializedEditorState().toString()
        text = stateStack.pop()
        while stateStack[stateStack.length - 1] is text
          text = stateStack.pop()

        while stateStack.length > 0
          text = stateStack.pop()
          while stateStack[stateStack.length - 1] is text
            text = stateStack.pop()
          editor.undo()
          equal editor.getSerializedEditorState().toString(), text, 'Undo was correct'

        start()
      else
        ok (not editor.cursorAtSocket()), 'Properly unfocused'
        setTimeout (-> tick count - 1), 0

    stateStack.push editor.getSerializedEditorState().toString()

    if rng() > 0.5
      op = getRandomDragOp(editor, rng)
      performDragOperation editor, op, cb
    else
      op = getRandomTextOp(editor, rng)
      performTextOperation editor, op, cb

  tick 100

asyncTest 'Controller: ANTLR random drag reparse test', ->
  document.getElementById('test-main').innerHTML = ''
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'c_cpp',
    modeOptions:
      knownFunctions:
        printf: {color: 'blue', shape: 'block-only'}
        puts: {color: 'blue', shape: 'block-only'}
        scanf: {color: 'blue', shape: 'block-only'}
        malloc: {color: 'red', shape: 'value-only'}
    palette: []
  })

  editor.setEditorState(true)
  editor.setValue('''
    #include <stdio.h>
    #include <stdlib.h>
    #define MAXLEN 100

    // Linked list
    struct List {
        long long data;
        struct List *next;
        struct List *prev;
    };
    typedef struct List List;

    // Memoryless swap
    void swap(long long *a, long long *b) {
        *a ^= *b;
        *b ^= *a;
        *a ^= *b;
    }

    // Test if sorted
    int sorted(List *head, int (*fn)(long long, long long)) {
        for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
            if (!fn(cursor->data, cursor->next->data)) {
                return 0;
            }
        }
        return 1;
    }

    // Bubble sort
    void sort(List *head, int (*fn)(long long, long long)) {
        while (!sorted(head, fn)) {
            for (List *cursor = head; cursor && cursor->next; cursor = cursor->next) {
                if (!fn(cursor->data, cursor->next->data))
                    swap(&cursor->data, &cursor->next->data);
            }
        }
    }

    // Comparator
    int comparator(long long a, long long b) {
       return (a > b);
    }

    // Main
    int main(int n, char *args[]) {
        // Arbitrary array initializer just o test that syntax
        int arbitraryArray[] = {1, 2, 3, 4, 5};
        int length;
        scanf("%d", &length);
        if (length > MAXLEN) {
            puts("Error: list is too large");
            return 1;
        }
        List *head = (List*)malloc(sizeof(List));
        scanf("%d", &head->data);
        head->prev = NULL;
        List *cursor = head;
        int temp;
        for (int i = 0; i < length - 1; i++) {
            cursor->next = (List*)malloc(sizeof(List));
            cursor = cursor->next;
            scanf("%d", &temp);
            cursor->data = (long long)temp;
        }
        sort(head, comparator);
        for (cursor = head; cursor; cursor = cursor->next) {
            printf("%d ", cursor->data);
        }
        puts("\\n");
        return 0;
    }
  ''')
  rng = seedrandom('droplet')
  stateStack = []

  tick = (count) ->
    cb = ->
      if count is 0
        start()
      else
        ok editor.session.mode.parse(editor.getValue()), 'Still in a parseable state'
        setTimeout (-> tick count - 1), 0

    if rng() > 0.1
      op = getRandomDragOp(editor, rng)
      performDragOperation editor, op, cb
    else
      op = getRandomTextOp(editor, rng)
      performTextOperation editor, op, cb

  tick 50
