helper = require '../../src/helper.coffee'

model = require '../../src/model.coffee'
view = require '../../src/view.coffee'
controller = require '../../src/controller.coffee'

parser = require '../../src/parser.coffee'
Coffee = require '../../src/languages/coffee.coffee'
JavaScript = require '../../src/languages/javascript.coffee'

droplet = require '../../dist/droplet-full.js'

coffee = new Coffee()

asyncTest 'Parser success', ->
  window.dumpObj = []
  for testCase in parserSuccessData
    strictEqual(
      helper.xmlPrettyPrint(coffee.parse(testCase.str, wrapAtRoot: true).serialize()),
      helper.xmlPrettyPrint(testCase.expected),
      testCase.message
    )
    window.dumpObj.push {
      message: testCase.message
      str: testCase.str
      expected: helper.xmlPrettyPrint coffee.parse(testCase.str, wrapAtRoot: true).serialize()
    }
  start()

asyncTest 'XML parser unity', ->
  for testCase in parserSuccessData
    xml = coffee.parse(testCase.str, wrapAtRoot: true).serialize()
    strictEqual(
      helper.xmlPrettyPrint(parser.parseXML(xml).serialize()),
      helper.xmlPrettyPrint(xml),
      'Parser unity for: ' + testCase.message
    )
  start()

asyncTest 'View: compute children', ->
  view_ = new view.View()

  document = coffee.parse '''
  alert 10
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  strictEqual documentView.lineChildren[0].length, 1, 'Children length 1 in `alert 10`'
  strictEqual documentView.lineChildren[0][0].child, document.getBlockOnLine(0), 'Child matches'
  strictEqual documentView.lineChildren[0][0].startLine, 0, 'Child starts on correct line'

  blockView = view_.getViewNodeFor document.getBlockOnLine 0
  strictEqual blockView.lineChildren[0].length, 2, 'Children length 2 in `alert 10` block'
  strictEqual blockView.lineChildren[0][0].child.type, 'text', 'First child is text'
  strictEqual blockView.lineChildren[0][1].child.type, 'socket', 'Second child is socket'

  document = coffee.parse '''
  for [1..10]
    alert 10
    prompt 10
    alert 20
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  blockView = view_.getViewNodeFor document.getBlockOnLine 0
  strictEqual blockView.lineChildren[1].length, 1, 'One child in indent'
  strictEqual blockView.lineChildren[2][0].startLine, 0, 'Indent start line'
  strictEqual blockView.multilineChildrenData[0], 1, 'Indent start data'
  strictEqual blockView.multilineChildrenData[1], 2, 'Indent middle data'
  strictEqual blockView.multilineChildrenData[2], 2, 'Indent middle data'
  strictEqual blockView.multilineChildrenData[3], 3, 'Indent end data'

  document = coffee.parse '''
  for [1..10]
    for [1..10]
      alert 10
      alert 20
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  indentView = view_.getViewNodeFor document.getBlockOnLine(1).end.prev.container
  strictEqual indentView.lineChildren[1][0].child.stringify(), 'alert 10', 'Relative line numbers'

  document = coffee.parse '''
  console.log (for [1..10]
    alert 10)
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  blockView = view_.getViewNodeFor document.getBlockOnLine(0).start.next.next.container

  strictEqual blockView.lineChildren[1].length, 1, 'One child in indent in socket'
  strictEqual blockView.multilineChildrenData[1], 3, 'Indent end data'
  start()

asyncTest 'View: compute dimensions', ->
  view_ = new view.View()

  document = coffee.parse '''
  for [1..10]
    alert 10
    alert 20
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  strictEqual documentView.dimensions[0].height,
    view_.opts.textHeight + 4 * view_.opts.padding + 2 * view_.opts.textPadding,
    'First line height (block, 2 padding)'
  strictEqual documentView.dimensions[1].height,
    view_.opts.textHeight + 2 * view_.opts.padding + 2 * view_.opts.textPadding,
    'Second line height (single block in indent)'
  strictEqual documentView.dimensions[2].height,
    view_.opts.textHeight + 2 * view_.opts.padding + 2 * view_.opts.textPadding +
    view_.opts.indentTongueHeight,
    'Third line height (indentEnd at root)'

  document = coffee.parse '''
  alert (for [1..10]
    alert 10
    alert 20)
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  strictEqual documentView.dimensions[0].height,
    view_.opts.textHeight + 5 * view_.opts.padding + 2 * view_.opts.textPadding,
    'First line height (block, 3.5 padding)'
  strictEqual documentView.dimensions[1].height,
    view_.opts.textHeight + 2 * view_.opts.padding + 2 * view_.opts.textPadding,
    'Second line height (single block in nested indent)'
  strictEqual documentView.dimensions[2].height,
    view_.opts.textHeight + 3 * view_.opts.padding +
    view_.opts.indentTongueHeight + 2 * view_.opts.textPadding,
    'Third line height (indentEnd with padding)'

  document = coffee.parse '''
  alert 10

  alert 20
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  strictEqual documentView.dimensions[1].height,
    view_.opts.textHeight + 2 * view_.opts.padding,
    'Renders empty lines'
  start()

asyncTest 'View: bounding box flag stuff', ->
  view_ = new view.View()

  document = coffee.parse '''
  alert 10
  alert 20
  alert 30
  alert 40
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  blockView = view_.getViewNodeFor document.getBlockOnLine 3

  strictEqual blockView.path._points[0].y,
    view_.opts.textHeight * 4 + view_.opts.padding * 8 + view_.opts.textPadding * 8,
    'Original path points are O.K.'

  document.remove document.getBlockOnLine(2)
  documentView.layout()

  strictEqual blockView.path._points[0].y,
    view_.opts.textHeight * 3 + view_.opts.padding * 6 + view_.opts.textPadding * 6,
    'Final path points are O.K.'
  start()

asyncTest 'View: sockets caching', ->
  view_ = new view.View()

  document = coffee.parse '''
  for i in [[[]]]
    alert 10
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  socketView = view_.getViewNodeFor getNthToken(document, 8).container

  strictEqual socketView.model.stringify(), '[[[]]]', 'Correct block selected'

  strictEqual socketView.dimensions[0].height,
    view_.opts.textHeight + 6 * view_.opts.padding,
    'Original height is O.K.'

  document.remove (block = getNthToken(document, 9).container)
  document.insert document.getBlockOnLine(1).start.prev.prev, block
  documentView.layout()

  strictEqual socketView.dimensions[0].height,
    view_.opts.textHeight + 2 * view_.opts.textPadding,
    'Final height is O.K.'
  start()

asyncTest 'View: bottomLineSticksToTop bug', ->
  view_ = new view.View()

  document = coffee.parse '''
  setTimeout (->
    alert 20
    alert 10), 1 + 2 + 3 + 4 + 5
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  testedBlock = document.getBlockOnLine 2
  testedBlockView = view_.getViewNodeFor testedBlock

  strictEqual testedBlockView.dimensions[0].height,
    2 * view_.opts.textPadding +
    1 * view_.opts.textHeight +
    8 * view_.opts.padding -
    1 * view_.opts.indentTongueHeight, 'Original height O.K.'

  block = document.getBlockOnLine 1
  dest = document.getBlockOnLine(2).end

  document.remove block
  document.insert dest, block

  documentView.layout()

  strictEqual testedBlockView.dimensions[0].height,
    2 * view_.opts.textPadding +
    1 * view_.opts.textHeight +
    2 * view_.opts.padding, 'Final height O.K.'

  document.remove block
  document.insert testedBlock.start.prev.prev, block

  documentView.layout()

  strictEqual testedBlockView.dimensions[0].height,
    2 * view_.opts.textPadding +
    1 * view_.opts.textHeight +
    8 * view_.opts.padding -
    1 * view_.opts.indentTongueHeight, 'Dragging other block in works'
  start()

asyncTest 'View: triple-quote sockets caching issue', ->
  view_ = new view.View()

  document = coffee.parse '''
  console.log 'hi'
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  socketView = view_.getViewNodeFor getNthToken(document, 4).container

  strictEqual socketView.model.stringify(), '\'hi\'', 'Correct block selected'
  strictEqual socketView.dimensions[0].height, view_.opts.textHeight + 2 * view_.opts.textPadding, 'Original height O.K.'
  strictEqual socketView.topLineSticksToBottom, false, 'Original topstick O.K.'

  helper.string [
    socketView.model.start
    new model.TextToken('"""')
    new model.NewlineToken()
    new model.TextToken('hello')
    new model.NewlineToken()
    new model.TextToken('world"""')
    socketView.model.end
  ]

  socketView.model.notifyChange()

  documentView.layout()

  strictEqual socketView.topLineSticksToBottom, true, 'Intermediate topstick O.K.'

  helper.string [
    socketView.model.start
    new model.TextToken('\'hi\'')
    socketView.model.end
  ]

  socketView.model.notifyChange()
  documentView.layout()

  socketView = view_.getViewNodeFor getNthToken(document, 4).container

  strictEqual socketView.dimensions[0].height, view_.opts.textHeight + 2 * view_.opts.textPadding, 'Final height O.K.'
  strictEqual socketView.topLineSticksToBottom, false, 'Final topstick O.K.'
  start()

asyncTest 'View: empty socket heights', ->
  view_ = new view.View()

  document = coffee.parse '''
  if `` is a
    ``
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  emptySocketView = view_.getViewNodeFor getNthToken(document, 6).container
  fullSocketView = view_.getViewNodeFor getNthToken(document, 9).container

  strictEqual emptySocketView.dimensions[0].height, fullSocketView.dimensions[0].height, 'Full and empty sockets same height'
  start()

asyncTest 'View: indent carriage arrow', ->
  view_ = new view.View()

  document = parser.parseXML '''
  <block>hello <indent prefix="  "><block>my <socket>name</socket></block>
  <block>is elder <socket>price</socket></block></indent></block>
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  block = document.getBlockOnLine(1).start.prev.prev.container
  blockView = view_.getViewNodeFor block

  strictEqual blockView.carriageArrow, 1, 'Carriage arrow flag is set'

  strictEqual blockView.dropPoint.x, view_.opts.indentWidth, 'Drop point is on the left'
  strictEqual blockView.dropPoint.y,
    1 * view_.opts.textHeight +
    4 * view_.opts.padding +
    2 * view_.opts.textPadding, 'Drop point is further down'

  indent = block.start.prev.container
  indentView = view_.getViewNodeFor indent


  ok indentView.glue[0]?, 'Carriage arrow causes glue (exists)'
  strictEqual indentView.glue[0].height, view_.opts.padding, 'Carriage arrow causes glue (correct height)'
  start()

asyncTest 'View: sidealong carriage arrow', ->
  view_ = new view.View()

  document = parser.parseXML '''
  <block>hello <indent prefix="  ">
  <block>my <socket>name</socket></block><block>is elder <socket>price</socket></block></indent></block>
  '''

  documentView = view_.getViewNodeFor document
  documentView.layout()

  block = document.getBlockOnLine(1).end.next.container
  blockView = view_.getViewNodeFor block

  strictEqual blockView.carriageArrow, 0, 'Carriage arrow flag is set'

  strictEqual blockView.dropPoint.x, view_.opts.indentWidth, 'Drop point is on the left'

  indent = block.end.next.container
  indentView = view_.getViewNodeFor indent

  strictEqual indentView.dimensions[1].height,
    view_.opts.textHeight +
    2 * view_.opts.textPadding +
    3 * view_.opts.padding, 'Carriage arrow causes expand'
  start()

asyncTest 'Controller: ace editor mode', ->
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }
  done = false
  resolved = false
  resolve = ->
    if resolved then return
    resolved = true
    ok done
    start()
  editor.aceEditor.session.on 'changeMode', ->
    strictEqual editor.aceEditor.session.getMode().$id, 'ace/mode/coffee'
    done = true
    resolve()
  setTimeout resolve, 1000

asyncTest 'Controller: melt/freeze events', ->
  expect 3

  states = []
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }

  editor.on 'statechange', (usingBlocks) ->
    states.push usingBlocks

  editor.performMeltAnimation 10, 10, ->
    editor.performFreezeAnimation 10, 10, ->
      strictEqual states.length, 2
      strictEqual states[0], false
      strictEqual states[1], true
      start()

asyncTest 'Controller: palette events', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: [{
      name: 'Draw'
      color: 'blue'
      blocks: [{
        block: 'pen purple'
        title: 'Set the pen color'
        id: 'pen'
      }],
    }, {
      name: 'Move'
      color: 'red'
      blocks: [{
        block: 'moveto 100, 100'
        title: 'Move to a coordinate'
        id: 'moveto'
      }]
    }]
  }
  dispatchMouse = (name, e) ->
    cr = e.getBoundingClientRect()
    mx = Math.floor (cr.left + cr.right) / 2
    my = Math.floor (cr.top + cr.bottom) / 2
    ev = document.createEvent 'MouseEvents'
    ev.initMouseEvent name, true, true, window,
        0, mx, my, mx, my, false, false, false, false, 0, null
    e.dispatchEvent ev

  states = []
  editor.on 'selectpalette', (name) ->
    states.push 's:' + name
  headers = document.getElementsByClassName 'droplet-palette-group-header'
  for j in [headers.length - 1 .. 0]
    dispatchMouse 'click', headers[j]
  deepEqual states, ['s:Move', 's:Draw']
  # TODO, fix layout in test environment, and test pickblock event.
  start()

asyncTest 'Controller: cursor motion and rendering', ->
  states = []
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }

  editor.setValue '''
  alert 10
  if a is b
    alert 20
    alert 30
  else
    alert 40
  '''

  moveCursorUp = ->
    editor.setCursor(
      (editor.getCursor().prev ? editor.getCursor().start.prev),
      ((token) -> token.type isnt 'socketStart')
      'before'
    )

  moveCursorDown = ->
    editor.setCursor(
      (editor.getCursor().next ? editor.getCursor().end.next),
      ((token) -> token.type isnt 'socketStart')
      'after'
    )

  strictEqual editor.determineCursorPosition().x, 0, 'Cursor position correct (x - down)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight, 'Cursor position correct (y - down)'

  moveCursorDown()

  strictEqual editor.determineCursorPosition().x, 0,
    'Cursor position correct after \'alert 10\' (x - down)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    1 * editor.session.view.opts.textHeight +
    2 * editor.session.view.opts.padding +
    2 * editor.session.view.opts.textPadding, 'Cursor position correct after \'alert 10\' (y - down)'

  moveCursorDown()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct after \'if a is b\' (x - down)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    2 * editor.session.view.opts.textHeight +
    6 * editor.session.view.opts.padding +
    4 * editor.session.view.opts.textPadding, 'Cursor position correct after \'if a is b\' (y - down)'

  moveCursorDown()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct after \'alert 20\' (x - down)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    3 * editor.session.view.opts.textHeight +
    8 * editor.session.view.opts.padding +
    6 * editor.session.view.opts.textPadding, 'Cursor position correct after \'alert 20\' (y - down)'

  moveCursorDown()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct at end of indent (x - down)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    4 * editor.session.view.opts.textHeight +
    10 * editor.session.view.opts.padding +
    8 * editor.session.view.opts.textPadding, 'Cursor position at end of indent (y - down)'

  moveCursorDown()

  strictEqual editor.session.cursor.location.type, 'indentStart', 'Cursor skipped middle of block'

  moveCursorUp()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct at end of indent (x - up)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    4 * editor.session.view.opts.textHeight +
    10 * editor.session.view.opts.padding +
    8 * editor.session.view.opts.textPadding, 'Cursor position at end of indent (y - up)'

  moveCursorUp()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct after \'alert 20\' (x - up)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    3 * editor.session.view.opts.textHeight +
    8 * editor.session.view.opts.padding +
    6 * editor.session.view.opts.textPadding, 'Cursor position correct after \'alert 20\' (y - up)'

  moveCursorUp()

  strictEqual editor.determineCursorPosition().x, editor.session.view.opts.indentWidth,
    'Cursor position correct after \'if a is b\' (y - up)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    2 * editor.session.view.opts.textHeight +
    6 * editor.session.view.opts.padding +
    4 * editor.session.view.opts.textPadding, 'Cursor position correct after \'if a is b\' (y - up)'

  moveCursorUp()

  strictEqual editor.determineCursorPosition().x, 0,
    'Cursor position correct after \'alert 10\' (x - up)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight +
    1 * editor.session.view.opts.textHeight +
    2 * editor.session.view.opts.padding +
    2 * editor.session.view.opts.textPadding, 'Cursor position correct after \'alert 10\' (y - up)'

  moveCursorUp()

  strictEqual editor.determineCursorPosition().x, 0, 'Cursor position correct at origin (x - up)'
  strictEqual editor.determineCursorPosition().y, editor.nubbyHeight, 'Cursor position correct at origin (y - up)'
  start()

asyncTest 'Controller: setMode', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }
  strictEqual 'coffeescript', editor.getMode()
  editor.setMode 'javascript'
  strictEqual 'javascript', editor.getMode()
  start()

###
asyncTest 'Controller: setValue errors', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }

  editor.setEditorState true

  editor.setValue '''
  pen red
  speed 30
  for [1..30]
    lt 90
    lt 90, 20
    if ``
    ``
    lt 90
    lt 90, 20
    dot blue, 15
    dot yellow, 10
    rt 105, 100
    rt 90
  (((((((((((((((((((((((loop))))))))))))))))))))))) = (param) ->
    ``
  '''

  strictEqual editor.currentlyUsingBlocks, false
  start()
###

asyncTest 'Controller: arbitrary row/column marking', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }

  editor.setEditorState true

  editor.setValue '''
  for [1..10]
    alert 10 + 10
    prompt 10 - 10
    alert 10 * 10
    prompt 10 / 10
  '''

  key = editor.mark {row: 2, col: 4}, {color: '#F00'}

  strictEqual editor.session.markedBlocks[key].model.stringify({}), '10 - 10'
  strictEqual editor.session.markedBlocks[key].style.color, '#F00'

  editor.unmark key
  ok key not of editor.session.markedBlocks
  start()

asyncTest 'Controller: dropdown menus', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
    modeOptions: {
      functions: {
        'pen': {
          dropdown: {
            0: [
              {text: 'red', display: '<b>red</b>'}
              'blue'
            ]
          }
        }
      }
    }
  }

  editor.setEditorState true

  editor.setValue '''
  pen red
  '''

  # Assert that the arrow is there
  strictEqual Math.round(editor.session.view.getViewNodeFor(editor.session.tree.getBlockOnLine(0)).bounds[0].width), 90

  # no-throw
  editor.setCursor editor.session.tree.getBlockOnLine(0).end.prev.container.start
  editor.showDropdown()
  start()

asyncTest 'Controller: dropdown menus with functions', ->
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
    modeOptions: {
      functions: {
        'pen': {
          dropdown: {
            0: -> [
              {text: 'red', display: '<b>red</b>'}
              'blue'
            ]
          }
        }
      }
    }
  }

  editor.setEditorState true

  editor.setValue '''
  pen red
  '''

  # Assert that the arrow is there
  strictEqual Math.round(editor.session.view.getViewNodeFor(editor.session.tree.getBlockOnLine(0)).bounds[0].width), 90

  # no-throw
  editor.setCursor editor.session.tree.getBlockOnLine(0).end.prev.container.start
  editor.showDropdown()
  start()

asyncTest 'Controller: showPaletteInTextMode false', ->
  expect 4

  states = []
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: [],
    showPaletteInTextMode: false
  }

  paletteWrapper = document.querySelector('.droplet-palette-wrapper')
  aceEditor = document.querySelector('.ace_editor')

  editor.on 'statechange', (usingBlocks) ->
    states.push usingBlocks

  editor.performMeltAnimation 10, 10, ->
    strictEqual paletteWrapper.style.left, '-9999px'
    strictEqual aceEditor.style.left, '0px'
    editor.performFreezeAnimation 10, 10, ->
      strictEqual paletteWrapper.style.left, '0px'
      strictEqual aceEditor.style.left, '-9999px'
      start()

asyncTest 'Controller: showPaletteInTextMode true', ->
  expect 4

  states = []
  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: [],
    showPaletteInTextMode: true
  }

  paletteWrapper = document.querySelector('.droplet-palette-wrapper')
  aceEditor = document.querySelector('.ace_editor')

  editor.on 'statechange', (usingBlocks) ->
    states.push usingBlocks

  editor.performMeltAnimation 10, 10, ->
    strictEqual paletteWrapper.style.left, '0px'
    strictEqual aceEditor.style.left, '270px'
    editor.performFreezeAnimation 10, 10, ->
      strictEqual paletteWrapper.style.left, '0px'
      strictEqual aceEditor.style.left, '-9999px'
      start()

asyncTest 'Controller: enablePalette false', ->
  expect 4

  document.getElementById('test-main').innerHTML = ''
  editor = new droplet.Editor document.getElementById('test-main'), {
    mode: 'coffeescript'
    palette: []
  }

  paletteWrapper = document.querySelector('.droplet-palette-wrapper')
  dropletWrapper = document.querySelector('.droplet-wrapper-div')

  strictEqual paletteWrapper.style.left, '0px'
  strictEqual dropletWrapper.style.left, '270px'

  verifyPaletteHidden = ->
    strictEqual paletteWrapper.style.left, '-9999px'
    strictEqual dropletWrapper.style.left, '0px'
    start()

  editor.enablePalette false

  setTimeout verifyPaletteHidden, 500

getNthToken = (document, n) ->
  head = document.start
  for [1...n]
    head = head.next
  return head
