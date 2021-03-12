C = require '../../src/languages/c.coffee'
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

pickUpLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  bound = editor.session.view.getViewNodeFor(block).bounds[0]
  simulate('mousedown', editor.mainCanvas, {
    dx: bound.x + 5,
    dy: bound.y + 5
  })
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: bound.x + 10,
    dy: bound.y + 10
  })

dropLocation = (editor, document, location) ->
  block = editor.getDocument(document).getFromTextLocation(location)
  blockView = editor.session.view.getViewNodeFor block
  simulate('mousemove', editor.dragCover, {
    location: editor.mainCanvas
    dx: blockView.dropPoint.x + 5,
    dy: blockView.dropPoint.y + 5
  })
  simulate('mouseup', editor.mainCanvas, {
    dx: blockView.dropPoint.x + 5
    dy: blockView.dropPoint.y + 5
  })

executeAsyncSequence = (sequence, i = 0) ->
  if i < sequence.length
    sequence[i]()
    setTimeout (->
      executeAsyncSequence sequence, i + 1
    ), 0

asyncTest 'Controller: ANTLR paren wrap rules', ->
  window.editor = editor = new droplet.Editor(document.getElementById('test-main'), {
    mode: 'c',
    palette: []
  })

  editor.setValue '''
    int main() {
      int y = 1 * 2;
      int x = 1 + 2;
      int a = 1 + 2 * 3;
    }
  '''

  executeAsyncSequence [
    (->
      pickUpLocation editor, 0, {
        row: 2
        col: 10
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 1
        col: 14
        type: 'socket'
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = 1 * (1 + 2);
        int x = __0_droplet__;
        int a = 1 + 2 * 3;
      }\n
      ''', 'Paren-wrapped + block dropping into * block'
    ), (->
      pickUpLocation editor, 0, {
        row: 1
        col: 10
        type: 'block'
      }
      dropLocation editor, 0, {
        row: 3
        col: 10
        type: 'socket'
        length: 1
      }
    ), (->
      equal editor.getValue(), '''
      int main() {
        int y = __0_droplet__;
        int x = __0_droplet__;
        int a = 1 * (1 + 2) + 2 * 3;
      }\n
      ''', 'Did not paren-wrap * block dropping into + block'

      start()
    )
  ]