helper = require '../../src/helper.coffee'
model = require '../../src/model.coffee'
view = require '../../src/view.coffee'
droplet = require '../../dist/droplet-full.js'

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
  editor.setValue('var hello = function (a) {}')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
  simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

  ok(editor.textFocus, 'Has text focus')
  equal(editor.textFocus.stringify({empty: ''}), 'a')

  $('.droplet-hidden-input').sendkeys('a, b')

  setTimeout((->
    ok(editor.textFocus, 'Editor still has textFocus')
    equal(editor.textFocus.stringify({empty: ''}), 'a, b')

    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})

    # Did not insert parentheses
    equal(editor.getValue().trim(), 'var hello = function (a, b) {}')

    # Sockets are separate
    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
    simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

    ok(editor.textFocus != null, 'Has text focus')

    equal(editor.textFocus.stringify({empty: ''}), 'a')

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
  editor.setValue('var hello = function (a) {}')

  simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})
  simulate('mouseup', '.droplet-main-scroller-stuffing', {dx: 260, dy: 30})

  ok(editor.textFocus, 'Has text focus')
  equal(editor.textFocus.stringify({empty: ''}), 'a')

  $('.droplet-hidden-input').sendkeys('18n')

  setTimeout((->
    ok(editor.textFocus, 'Editor still has textFocus')
    equal(editor.textFocus.stringify({empty: ''}), '18n')

    simulate('mousedown', '.droplet-main-scroller-stuffing', {dx: 300, dy: 300})

    ok(true, 'Does not throw on reparse')

    foundErrorMark = false
    for key, val of editor.markedBlocks
      if val.model.stringify({empty: ''}) is 'function (18n) {}' and
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
