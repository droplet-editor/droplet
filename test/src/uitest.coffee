helper = require '../../src/helper.coffee'
model = require '../../src/model.coffee'
view = require '../../src/view.coffee'
draw = require '../../src/draw.coffee'
droplet = require '../../dist/droplet-full.js'
seedrandom = require 'seedrandom'

console.log window.innerWidth, window.innerHeight
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
        title: 'ptest'
      }, {
        block: 'a = b',
        expansion: -> return 'a' + (++varcount) + ' = b'
        title: 'ftest'
      },
      ],
    }]
  })
  simulate('mousedown', '[title=ptest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[title=ptest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-main-scroller' })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-main-scroller' })
  equal(editor.getValue().trim(), 'pen red')
  simulate('mousedown', '[title=ftest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[title=ftest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-main-scroller', dx: 40, dy: 50 })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-main-scroller', dx: 40, dy: 50 })
  equal(editor.getValue().trim(), 'pen red\na1 = b')
  simulate('mousedown', '[title=ftest]')
  simulate('mousemove', '.droplet-drag-cover',
    { location: '[title=ftest]', dx: 5 })
  simulate('mousemove', '.droplet-drag-cover',
    { location: '.droplet-main-scroller', dx: 40, dy: 80 })
  simulate('mouseup', '.droplet-drag-cover',
    { location: '.droplet-main-scroller', dx: 40, dy: 80 })
  equal(editor.getValue().trim(), 'pen red\na1 = b\na2 = b')
  start()

asyncTest 'Controller: reparse fallback', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  varcount = 0
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'javascript',
    palette: []
  })

  editor.setEditorState(true)
  editor.setValue('var hello = 1;')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 160, dy: 20})
  simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 160, dy: 20})

  ok(editor.cursorAtSocket(), 'Has text focus')
  equal(editor.getCursor().stringify(), '1')

  $('.droplet-hidden-input').sendkeys('2 + 3')

  setTimeout((->
    ok(editor.cursorAtSocket(), 'Editor still has text focus')
    equal(editor.getCursor().stringify(), '2 + 3')

    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})

    # Sockets are separate
    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 160, dy: 30})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 160, dy: 30})

    ok(editor.cursorAtSocket(), 'Has text focus')

    equal(editor.getCursor().stringify(), '2', 'Successfully reparsed')

    editor.undo()

    setTimeout (->
      simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 160, dy: 20})
      simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 160, dy: 20})
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
  editor.setValue('var hello = function (a) {};')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
  simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

  ok(editor.cursorAtSocket(), 'Has text focus')
  equal(editor.getCursor().stringify(), 'a')

  $('.droplet-hidden-input').sendkeys('a, b')

  setTimeout((->
    ok(editor.cursorAtSocket(), 'Editor still has text focus')
    equal(editor.getCursor().stringify(), 'a, b')

    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})

    # Did not insert parentheses
    equal(editor.getValue().trim(), 'var hello = function (a, b) {};')

    # Sockets are separate
    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

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

  editor.setEditorState(true)
  editor.setValue('var hello = function (a) {};')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
  simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

  ok(editor.getCursor(), 'Has text focus')
  equal(editor.getCursor().stringify(), 'a')

  $('.droplet-hidden-input').sendkeys('18n')

  setTimeout((->
    ok(editor.getCursor(), 'Editor still has getCursor()')
    equal(editor.getCursor().stringify(), '18n')

    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})

    ok(true, 'Does not throw on reparse')

    foundErrorMark = false
    for key, val of editor.markedBlocks
      if val.model.stringify() is '18n' and
          val.style.color is '#F00'
        foundErrorMark = true
        break

    ok(foundErrorMark, 'Marks block with a red line')

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
  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 30})
  simulate('mousemove', '.droplet-drag-cover'
    {location: '.droplet-main-scroller-stuffing', dx: 305, dy: 35})
  simulate('mouseup', '.droplet-drag-cover'
    {location: '.droplet-main-scroller-stuffing', dx: 305, dy: 35})
  equal(editor.getValue() , 'for (var i = 0; i < 5; i++) {\n' +
                            '  fd(10);\n' +
                            '}\n')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 30})
  simulate('mousemove', '.droplet-drag-cover'
    {location: '.droplet-main-scroller-stuffing', dx: 290, dy: 25})
  simulate('mouseup', '.droplet-drag-cover'
    {location: '.droplet-main-scroller-stuffing', dx: 290, dy: 25})
  equal(editor.getValue() , 'for (var i = 0; i < i++; __) {\n' +
                            '  fd(10);\n' +
                            '}\n')
  start()

getRandomDragOp = (editor, rng) ->
  # Find the locations of all the blocks
  head = editor.tree.start
  # Skip the first block if it is the entire document
  if head.next.container?.end is editor.tree.end.prev
    head = head.next.next
  dragPossibilities = []
  until head is editor.tree.end
    if head.type is 'blockStart'
      bound = editor.view.getViewNodeFor(head.container).bounds[0]
      handle = {x: bound.x + 5, y: bound.y + 5}
      dragPossibilities.push {
        block: head.container
        handle: handle
      }
    head = head.next

  drag = dragPossibilities[Math.floor rng() * dragPossibilities.length]

  # Find all the drop areas
  head = editor.tree.start

  # Disclude the main tree if we're dragging the first block
  if drag is dragPossibilities[0]
    head = head.next
  dropPossibilities = []
  until head is editor.tree.end
    if head is drag.block.start
      head = drag.block.end
    if head.type.match(/Start$/)?
      dropPoint = editor.view.getViewNodeFor(head.container).dropPoint
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
  head = editor.tree.start
  socketPossibilities = []
  until head is editor.tree.end
    if head.type is 'socketStart' and head.container.editable()
      bound = editor.view.getViewNodeFor(head.container).bounds[0]
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
  simulate('mousedown', editor.mainScrollerStuffing, {
    dx: text.socket.handle.x + editor.gutter.offsetWidth,
    dy: text.socket.handle.y
  })
  simulate('mouseup', editor.mainScrollerStuffing, {
    dx: text.socket.handle.x + editor.gutter.offsetWidth,
    dy: text.socket.handle.y
  })
  setTimeout (->
    $(editor.hiddenInput).sendkeys(text.text)
    setTimeout (->
      # Unfocus
      simulate('mousedown', editor.mainScroller, {
        location: editor.mainCanvas
        dx: editor.mainCanvas.offsetWidth - 1
        dy: editor.mainCanvas.offsetHeight - 1
      })
      simulate('mouseup', editor.mainScroller, {
        location: editor.mainCanvas
        dx: editor.mainCanvas.offsetWidth - 1
        dy: editor.mainCanvas.offsetHeight - 1
      })
      setTimeout cb, 0
    ), 0
  ), 0

performDragOperation = (editor, drag, cb) ->
  simulate('mousedown', editor.mainScrollerStuffing, {
    dx: drag.drag.handle.x + editor.gutter.offsetWidth,
    dy: drag.drag.handle.y
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: drag.drag.handle.x + editor.gutter.offsetWidth + 5,
    dy: drag.drag.handle.y + 5
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: drag.drop.point.x + 5
    dy: drag.drop.point.y + 5
  })
  simulate('mouseup', editor.mainScroller, {
    dx: drag.drop.point.x + 5
    dy: drag.drop.point.y + 5
  })
  # Unfocus the text input that may have been focused
  # when we dragged
  setTimeout (->
    simulate('mousedown', editor.mainScroller, {
      location: editor.mainCanvas
      dx: editor.mainCanvas.offsetWidth - 1
      dy: editor.mainCanvas.offsetHeight - 1
    })
    simulate('mouseup', editor.mainScroller, {
      location: editor.mainCanvas
      dx: editor.mainCanvas.offsetWidth - 1
      dy: editor.mainCanvas.offsetHeight - 1
    })
    setTimeout cb, 0
  ), 0

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
        stateStack.push editor.getValue()
        text = stateStack.pop()
        while stateStack[stateStack.length - 1] is text
          text = stateStack.pop()

        while stateStack.length > 0
          text = stateStack.pop()
          while stateStack[stateStack.length - 1] is text
            text = stateStack.pop()
          editor.undo()
          equal editor.getValue(), text, 'Undo was correct'

        start()
      else
        ok (not editor.cursorAtSocket()), 'Properly unfocused'
        setTimeout (-> tick count - 1), 0

    stateStack.push editor.getValue()

    if rng() > 0.5
      op = getRandomDragOp(editor, rng)
      performDragOperation editor, op, cb
    else
      op = getRandomTextOp(editor, rng)
      performTextOperation editor, op, cb

  tick 100
