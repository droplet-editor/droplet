require ['ice-model', 'ice-coffee', 'ice-view', 'ice'], (model, coffee, view, ice) ->

  test 'Parser success', ->
    testString = (m, str, expected) ->
      strictEqual coffee.parse(str, wrapAtRoot: true).serialize(), expected, m

    testString 'Function call',
      'fd 10', '<block color="command" precedence="0">fd <socket precedence="-1">10</socket></block>'

    testString 'Variable assignment',
      'a = b', '<block color="command" precedence="0"><socket precedence="0">a</socket> = <socket precedence="0">b</socket></block>'

    testString 'If statement, normal form',
      '''
      if true
        fd 10
      ''', '''
      <block color="control" precedence="0">if <socket precedence="0">true</socket><indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent></block>
      '''

    testString 'Unless statement, normal form',
      '''
      unless true
        fd 10
      ''', '''
      <block color="control" precedence="0">unless <socket precedence="0">true</socket><indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent></block>
      '''

    testString 'One-line if statement',
      'if a then b',
      '<block color="control" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">b</socket></block>'

    testString 'If-else statement, normal form',
      '''
      if true
        fd 10
      else
        fd 10
      ''', '''
      <block color="control" precedence="0">if <socket precedence="0">true</socket><indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent>
      else<indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent></block>
      '''

    testString 'One-line if-else statement',
      'if a then b else c',
      '<block color="control" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">b</socket> else <socket precedence="0">c</socket></block>'

    testString 'While statement, normal form',
      '''
      while a
        fd 10
      ''', '''
      <block color="control" precedence="0">while <socket precedence="0">a</socket><indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent></block>
      '''

    testString 'One-line while statement',
      'while a then fd 10',
      '<block color="control" precedence="0">while <socket precedence="0">a</socket> then <socket precedence="0"><block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></socket></block>'

    testString 'For-in, normal form',
      '''
      for i in list
        fd 10
      ''', '''
      <block color="control" precedence="0">for <socket precedence="0">i</socket> in <socket precedence="0">list</socket><indent depth="2">
      <block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></indent></block>
      '''

    testString 'One-line for-in',
      'for i in list then fd 10'
      '<block color="control" precedence="0">for <socket precedence="0">i</socket> in <socket precedence="0">list</socket> then <socket precedence="0"><block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></socket></block>'

    testString 'Inverted one-line for-in',
      'fd 10 for i in list',
      '<block color="control" precedence="0"><socket precedence="0"><block color="command" precedence="0">fd <socket precedence="-1">10</socket></block></socket> for <socket precedence="0">i</socket> in <socket precedence="0">list</socket></block>'

    testString 'Semicolons at the root',
      'fd 10; bk 10',
      '<block color="command" precedence="0"><socket precedence="0">'+
      '<block color="command" precedence="0">fd <socket precedence="-1">10</socket></block>'+
      '</socket>; <socket precedence="0">'+
      '<block color="command" precedence="0">bk <socket precedence="-1">10</socket></block></socket></block>'

    testString 'Semicolons with one-line block',
      'if a then b; c else d',
      '<block color="control" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">' +
      '<block color="command" precedence="0"><socket precedence="0">b</socket>; <socket precedence="0">c</socket>' +
      '</block></socket> else <socket precedence="0">d</socket></block>'

    testString 'Semicolons in sequence',
      '''
      while a
        see hi
        fd 10; bk 10
        see bye
      ''',
      '<block color="control" precedence="0">while <socket precedence="0">a</socket><indent depth="2">\n' +
      '<block color="command" precedence="0">see <socket precedence="-1">hi</socket></block>\n'+
      '<block color="command" precedence="0"><socket precedence="0">'+
      '<block color="command" precedence="0">fd <socket precedence="-1">10</socket></block>'+
      '</socket>; <socket precedence="0">'+
      '<block color="command" precedence="0">bk <socket precedence="-1">10</socket></block></socket></block>\n'+
      '<block color="command" precedence="0">see <socket precedence="-1">bye</socket></block></indent></block>'

    testString 'Object literal, normal form',
      '''
      foo {
        a: b,
        c: d
      }
      ''',
      '''
      <block color="command" precedence="0">foo <socket precedence="-1"><block color="value" precedence="0">{
        <socket precedence="0">a</socket>: <socket precedence="0">b</socket>,
        <socket precedence="0">c</socket>: <socket precedence="0">d</socket>
      }</block></socket></block>
      '''

    testString 'Object literal, no braces or commas',
      '''
      foo
        a: b
        c: d
      '''
      '''
      <block color="command" precedence="0">foo
        <socket precedence="-1"><block color="value" precedence="0"><socket precedence="0">a</socket>: <socket precedence="0">b</socket>
        <socket precedence="0">c</socket>: <socket precedence="0">d</socket></block></socket></block>
      '''

    testString 'String interpolation',
      'foo "#{a}"',
      '<block color="command" precedence="0">foo <socket precedence="-1">"#{a}"</socket></block>'

    testString 'Range',
      '[1..10]',
      '<block color="value" precedence="100">[<socket precedence="0">1</socket>..<socket precedence="0">10</socket>]</block>'

    testString 'Array',
      '[0, 1]'
      '<block color="value" precedence="100">[<socket precedence="0">0</socket>, <socket precedence="0">1</socket>]</block>'

    testString 'Switch, one case, no default',
      '''
      switch k
        when a
          blah blah
      ''', '''
      <block color="control" precedence="0">switch <socket precedence="0">k</socket>
        when <socket precedence="0">a</socket><indent depth="4">
      <block color="command" precedence="0">blah <socket precedence="-1">blah</socket></block></indent></block>
      '''

    testString 'One-line switch, one case, no default',
      '''
      switch k
        when a then b
      ''',
      '''
      <block color="control" precedence="0">switch <socket precedence="0">k</socket>
        when <socket precedence="0">a</socket> then <socket precedence="0">b</socket></block>
      '''

    testString 'Switch, two cases, with default',
      '''
      switch k
        when a
          blah blah
        when b
          darn it
        else
          what ever
      ''', '''
      <block color="control" precedence="0">switch <socket precedence="0">k</socket>
        when <socket precedence="0">a</socket><indent depth="4">
      <block color="command" precedence="0">blah <socket precedence="-1">blah</socket></block></indent>
        when <socket precedence="0">b</socket><indent depth="4">
      <block color="command" precedence="0">darn <socket precedence="-1">it</socket></block></indent>
        else<indent depth="4">
      <block color="command" precedence="0">what <socket precedence="-1">ever</socket></block></indent></block>
      '''

    testString 'Empty function definition', '->', '<block color="value" precedence="0">-></block>'

    testString 'Class definition, normal form, constructor only',
      '''
      class Duck
        constructor: ->
      ''',
      '''
      <block color="control" precedence="0">class <socket precedence="0">Duck</socket><indent depth="2">
      <block color="value" precedence="0"><socket precedence="0">constructor</socket>: <socket precedence="0"><block color="value" precedence="0">-></block></socket></block></indent></block>
      '''

    testString 'Non-parenthetical function call nested in parenthetical function call',
      '''
      a(b
        x: 1)
      ''',
      '''
      <block color="command" precedence="0">a(<socket precedence="-1"><block color="command" precedence="0">b
        <socket precedence="-1"><block color="value" precedence="0"><socket precedence="0">x</socket>: <socket precedence="0">1</socket></block></socket>)</block></socket></block>
      '''

    testString 'Parentheses around semicolon block',
      '(fd 10; bk 10)',
      '<block color="command" precedence="0">(<socket precedence="0"><block color="command" precedence="0">' +
      'fd <socket precedence="-1">10</socket></block></socket>; <socket precedence="0"><block color="command" precedence="0">' +
      'bk <socket precedence="-1">10</socket></block></socket>)</block>'


    testString 'Operator precedences',
      '''
      a or b
      a and b
      a is b
      a isnt b
      a > b
      a < b
      a >= b
      a <= b
      a + b
      a - b
      a * b
      a / b
      a % b
      a ** b
      a %% b
      a?
      ''','''
      <block color="value" precedence="1"><socket precedence="1">a</socket> or <socket precedence="1">b</socket></block>
      <block color="value" precedence="2"><socket precedence="2">a</socket> and <socket precedence="2">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> is <socket precedence="3">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> isnt <socket precedence="3">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> > <socket precedence="3">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> < <socket precedence="3">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> >= <socket precedence="3">b</socket></block>
      <block color="value" precedence="3"><socket precedence="3">a</socket> <= <socket precedence="3">b</socket></block>
      <block color="value" precedence="4"><socket precedence="4">a</socket> + <socket precedence="4">b</socket></block>
      <block color="value" precedence="4"><socket precedence="4">a</socket> - <socket precedence="4">b</socket></block>
      <block color="value" precedence="5"><socket precedence="5">a</socket> * <socket precedence="5">b</socket></block>
      <block color="value" precedence="5"><socket precedence="5">a</socket> / <socket precedence="5">b</socket></block>
      <block color="value" precedence="6"><socket precedence="6">a</socket> % <socket precedence="6">b</socket></block>
      <block color="value" precedence="7"><socket precedence="7">a</socket> ** <socket precedence="7">b</socket></block>
      <block color="value" precedence="7"><socket precedence="7">a</socket> %% <socket precedence="7">b</socket></block>
      <block color="value" precedence="100"><socket precedence="101">a</socket>?</block>
      '''

  test 'Basic token operations', ->
    a = new model.Token()
    b = new model.Token()
    c = new model.Token()
    d = new model.Token()

    strictEqual a.append(b), b, 'append() return argument'

    strictEqual a.prev, null, 'append assembles correct linked list'
    strictEqual a.next, b, 'append assembles correct linked list'
    strictEqual b.prev, a, 'append assembles correct linked list'
    strictEqual b.next, null, 'append assembles correct linked list'

    b.append c
    b.remove()

    strictEqual a.next, c, 'remove removes token'
    strictEqual c.prev, a, 'remove removes token'

  test 'Containers and parents', ->
    cont1 = new model.Container()
    cont2 = new model.Container()

    a = cont1.start
    b = new model.Token()
    c = cont2.start
    d = new model.Token()
    e = cont2.end
    f = cont1.end

    a.append(b).append(c).append(d)
     .append(e).append(f)

    cont1.correctParentTree()

    strictEqual a.parent, null, 'correctParentTree() output is correct (a)'
    strictEqual b.parent, cont1, 'correctParentTree() output is correct (b)'
    strictEqual c.parent, cont1, 'correctParentTree() output is correct (c)'
    strictEqual d.parent, cont2, 'correctParentTree() output is correct (d)'
    strictEqual e.parent, cont1, 'correctParentTree() output is correct (e)'
    strictEqual f.parent, null, 'correctParentTree() output is correct (f)'

    g = new model.Token()
    h = new model.Token
    g.append h
    d.append g
    h.append e

    strictEqual a.parent, null, 'splice in parents still work'
    strictEqual b.parent, cont1, 'splice in parents still work'
    strictEqual c.parent, cont1, 'splice in parents still work'
    strictEqual d.parent, cont2, 'splice in parents still work'
    strictEqual g.parent, cont2, 'splice in parents still work'
    strictEqual h.parent, cont2, 'splice in parents still work'
    strictEqual e.parent, cont1, 'splice in parents still work'
    strictEqual f.parent, null, 'splice in parents still work'

    cont3 = new model.Container()
    cont3.spliceIn g

    strictEqual h.parent, cont2, 'splice in parents still work'

  test 'Get block on line', ->
    document = coffee.parse '''
    for i in [1..10]
      see i
    if a is b
      see k
      if b is c
        see q
    else
      see j
    '''

    strictEqual document.getBlockOnLine(1).stringify(), 'see i', 'line 1'
    strictEqual document.getBlockOnLine(3).stringify(), 'see k', 'line 3'
    strictEqual document.getBlockOnLine(5).stringify(), 'see q', 'line 5'
    strictEqual document.getBlockOnLine(7).stringify(), 'see j', 'line 7'

  test 'Location serialization unity', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log hello
      if a is b
        console.log world
    '''

    head = document.start.next
    until head is document.end
      strictEqual document.getTokenAtLocation(head.getSerializedLocation()), head, 'Equality for ' + head.type
      head = head.next

  test 'Block move', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log hello
      console.log world
    '''

    document.getBlockOnLine(2).moveTo document.start

    strictEqual document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move console.log world out'

    document.getBlockOnLine(2).moveTo document.start

    strictEqual document.stringify(), '''
    console.log hello
    console.log world
    for i in [1..10]
      ``''', 'Move both out'

    document.getBlockOnLine(0).moveTo document.getBlockOnLine(2).end.prev.container.start

    strictEqual document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move hello back in'

    document.getBlockOnLine(1).moveTo document.getBlockOnLine(0).end.prev.container.start

    strictEqual document.stringify(), '''
    console.log for i in [1..10]
      console.log hello
    ''', 'Move for into socket (req. paren wrap)'

  test 'Paren wrap', ->
    document = coffee.parse '''
    Math.sqrt 2
    see 1 + 1
    '''

    (block = document.getBlockOnLine(0)).moveTo document.getBlockOnLine(1).end.prev.prev.prev.container.start

    strictEqual document.stringify(), '''
    see 1 + (Math.sqrt 2)
    ''', 'Wrap'

    block.moveTo document.start

    strictEqual document.stringify(), '''
    Math.sqrt 2
    see 1 + ``''', 'Unwrap'

  test 'View: compute children', ->
    view_ = new view.View()

    document = coffee.parse '''
    fd 10
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    strictEqual documentView.lineChildren[0].length, 1, 'Children length 1 in `fd 10`'
    strictEqual documentView.lineChildren[0][0].child, document.getBlockOnLine(0), 'Child matches'
    strictEqual documentView.lineChildren[0][0].startLine, 0, 'Child starts on correct line'

    blockView = view_.getViewNodeFor document.getBlockOnLine 0
    strictEqual blockView.lineChildren[0].length, 2, 'Children length 2 in `fd 10` block'
    strictEqual blockView.lineChildren[0][0].child.type, 'text', 'First child is text'
    strictEqual blockView.lineChildren[0][1].child.type, 'socket', 'Second child is socket'

    document = coffee.parse '''
    for [1..10]
      fd 10
      bk 10
      fd 20
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
        fd 10
        fd 20
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    indentView = view_.getViewNodeFor document.getBlockOnLine(1).end.prev.container
    strictEqual indentView.lineChildren[1][0].child.stringify(), 'fd 10', 'Relative line numbers'

    document = coffee.parse '''
    see (for [1..10]
      fd 10)
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    blockView = view_.getViewNodeFor document.getBlockOnLine(0).start.next.next.container

    strictEqual blockView.lineChildren[1].length, 1, 'One child in indent in socket'
    strictEqual blockView.multilineChildrenData[1], 3, 'Indent end data'

  test 'View: compute dimensions', ->
    view_ = new view.View()

    document = coffee.parse '''
    for [1..10]
      fd 10
      fd 20
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
    fd (for [1..10]
      fd 10
      fd 20)
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
    fd 10

    fd 20
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    strictEqual documentView.dimensions[1].height,
      view_.opts.textHeight,
      'Renders empty lines'

  test 'View: bounding box flag stuff', ->
    view_ = new view.View()

    document = coffee.parse '''
    fd 10
    fd 20
    fd 30
    fd 40
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    blockView = view_.getViewNodeFor document.getBlockOnLine 3

    strictEqual blockView.path._points[0].y,
      view_.opts.textHeight * 4 + view_.opts.padding * 8 + view_.opts.textPadding * 8,
      'Original path points are O.K.'

    document.getBlockOnLine(2).spliceOut()
    documentView.layout()

    strictEqual blockView.path._points[0].y,
      view_.opts.textHeight * 3 + view_.opts.padding * 6 + view_.opts.textPadding * 6,
      'Final path points are O.K.'

  test 'View: sockets caching', ->
    view_ = new view.View()

    document = coffee.parse '''
    for i in [[[]]]
      fd 10
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    socketView = view_.getViewNodeFor document.getTokenAtLocation(8).container

    strictEqual socketView.model.stringify(), '[[[]]]', 'Correct block selected'

    strictEqual socketView.dimensions[0].height,
      view_.opts.textHeight + 6 * view_.opts.padding,
      'Original height is O.K.'

    (block = document.getTokenAtLocation(9).container).spliceOut()
    block.spliceIn(document.getBlockOnLine(1).start.prev.prev)
    documentView.layout()

    strictEqual socketView.dimensions[0].height,
      view_.opts.textHeight + 2 * view_.opts.textPadding,
      'Final height is O.K.'

  test 'View: triple-quote sockets caching issue', ->
    view_ = new view.View()

    document = coffee.parse '''
    see 'hi'
    '''

    documentView = view_.getViewNodeFor document
    documentView.layout()

    socketView = view_.getViewNodeFor document.getTokenAtLocation(4).container

    strictEqual socketView.model.stringify(), '\'hi\'', 'Correct block selected'
    strictEqual socketView.dimensions[0].height, view_.opts.textHeight + 2 * view_.opts.textPadding, 'Original height O.K.'
    strictEqual socketView.topLineSticksToBottom, false, 'Original topstick O.K.'

    socketView.model.start.append socketView.model.end
    socketView.model.start.append(new model.TextToken('"""'))
      .append(new model.NewlineToken())
      .append(new model.TextToken('hello'))
      .append(new model.NewlineToken())
      .append(new model.TextToken('world"""'))
      .append(socketView.model.end)
    
    socketView.model.notifyChange()

    documentView.layout()

    strictEqual socketView.topLineSticksToBottom, true, 'Intermediate topstick O.K.'

    socketView.model.start.append new model.TextToken('\'hi\'')
      .append socketView.model.end

    socketView.model.notifyChange()
    documentView.layout()

    socketView = view_.getViewNodeFor document.getTokenAtLocation(4).container

    strictEqual socketView.dimensions[0].height, view_.opts.textHeight + 2 * view_.opts.textPadding, 'Final height O.K.'
    strictEqual socketView.topLineSticksToBottom, false, 'Final topstick O.K.'

  
  asyncTest 'Controller: melt/freeze events', ->
    expect 3

    states = []
    editor = new ice.Editor document.getElementById('test-main'), document.getElementById('test-palette'), []

    editor.on 'statechange', (usingBlocks) ->
      states.push usingBlocks
    
    editor.performMeltAnimation 10, 10, ->
      editor.performFreezeAnimation 10, 10, ->
        strictEqual states.length, 2
        strictEqual states[0], false
        strictEqual states[1], true
        start()
