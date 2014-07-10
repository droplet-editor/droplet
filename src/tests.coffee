require ['ice-model', 'ice-coffee', 'ice-view'], (model, coffee, view) ->
  
  readFile = (name) ->
    q = new XMLHttpRequest()
    q.open 'GET', name, false
    q.send()

    return q.responseText

  test 'Parser unity', ->
    testString = (str) ->
      strictEqual str, coffee.parse(str, wrapAtRoot: true).stringify(), 'Unity test on ' + str

    testString 'fd 10'
    testString 'fd 10 + 10'
    testString 'console.log 10 + 10'
    testString '''
    for i in [1..10]
      console.log 10 + 10
    '''
    testString '''
    array = []
    if a is b
      while p is q
        make spaghetti
        eat spaghetti
        array.push spaghetti
      for i in [1..10]
        console.log 10 + 10
    else
      see 'hi'
      for key, value in window
        see key + ' is ' + value
        see key is value
        see array[n]
    '''

    testFile = (name) ->
      nodes = readFile name

      unparsed = coffee.parse(nodes, wrapAtRoot: true).stringify()

      nodes = nodes.split '\n'
      unparsed = unparsed.split '\n'

      for i in [0..nodes.length] by 30
        strictEqual unparsed[i..i + 30].join('\n'), nodes[i..i + 30].join('\n'), "Unity test on #{name}:#{i}-#{i + 30}"

    testFile 'nodes.coffee'
    testFile 'allTests.coffee'
  
  test 'Parser success', ->
    testString = (m, str, expected) ->
      strictEqual coffee.parse(str, wrapAtRoot: true).serialize(), expected, m
    
    testString 'Function call',
      'fd 10', '<block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block>'
    
    testString 'Variable assignment',
      'a = b', '<block color="#268bd2" precedence="0"><socket precedence="0">a</socket> = <socket precedence="0">b</socket></block>'
    
    testString 'If statement, normal form',
      '''
      if true
        fd 10
      ''', '''
      <block color="#daa520" precedence="0">if <socket precedence="0">true</socket><indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent></block>
      '''

    testString 'Unless statement, normal form',
      '''
      unless true
        fd 10
      ''', '''
      <block color="#daa520" precedence="0">unless <socket precedence="0">true</socket><indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent></block>
      '''

    testString 'One-line if statement',
      'if a then b',
      '<block color="#daa520" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">b</socket></block>'

    testString 'If-else statement, normal form',
      '''
      if true
        fd 10
      else
        fd 10
      ''', '''
      <block color="#daa520" precedence="0">if <socket precedence="0">true</socket><indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent>
      else<indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent></block>
      '''

    testString 'One-line if-else statement',
      'if a then b else c',
      '<block color="#daa520" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">b</socket> else <socket precedence="0">c</socket></block>'

    testString 'While statement, normal form',
      '''
      while a
        fd 10
      ''', '''
      <block color="#daa520" precedence="0">while <socket precedence="0">a</socket><indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent></block>
      '''

    testString 'One-line while statement',
      'while a then fd 10',
      '<block color="#daa520" precedence="0">while <socket precedence="0">a</socket> then <socket precedence="0"><block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></socket></block>'

    testString 'For-in, normal form',
      '''
      for i in list
        fd 10
      ''', '''
      <block color="#daa520" precedence="0">for <socket precedence="0">i</socket> in <socket precedence="0">list</socket><indent depth="2">
      <block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></indent></block>
      '''

    testString 'One-line for-in',
      'for i in list then fd 10'
      '<block color="#daa520" precedence="0">for <socket precedence="0">i</socket> in <socket precedence="0">list</socket> then <socket precedence="0"><block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></socket></block>'

    testString 'Inverted one-line for-in',
      'fd 10 for i in list',
      '<block color="#daa520" precedence="0"><socket precedence="0"><block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block></socket> for <socket precedence="0">i</socket> in <socket precedence="0">list</socket></block>'
    
    testString 'Semicolons at the root',
      'fd 10; bk 10',
      '<block color="#268bd2" precedence="0"><socket precedence="0">'+
      '<block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block>'+
      '</socket>; <socket precedence="0">'+
      '<block color="#268bd2" precedence="0">bk <socket precedence="0">10</socket></block></socket></block>'

    testString 'Semicolons with one-line block',
      'if a then b; c else d',
      '<block color="#daa520" precedence="0">if <socket precedence="0">a</socket> then <socket precedence="0">' +
      '<block color="#268bd2" precedence="0"><socket precedence="0">b</socket>; <socket precedence="0">c</socket>' +
      '</block></socket> else <socket precedence="0">d</socket></block>'

    testString 'Semicolons in sequence',
      '''
      while a
        see hi
        fd 10; bk 10
        see bye
      ''',
      '<block color="#daa520" precedence="0">while <socket precedence="0">a</socket><indent depth="2">\n' +
      '<block color="#268bd2" precedence="0">see <socket precedence="0">hi</socket></block>\n'+
      '<block color="#268bd2" precedence="0"><socket precedence="0">'+
      '<block color="#268bd2" precedence="0">fd <socket precedence="0">10</socket></block>'+
      '</socket>; <socket precedence="0">'+
      '<block color="#268bd2" precedence="0">bk <socket precedence="0">10</socket></block></socket></block>\n'+
      '<block color="#268bd2" precedence="0">see <socket precedence="0">bye</socket></block></indent></block>'

    testString 'Object literal, normal form',
      '''
      foo {
        a: b,
        c: d
      }
      ''',
      '''
      <block color="#268bd2" precedence="0">foo <socket precedence="0"><block color="#26cf3c" precedence="0">{
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
      <block color="#268bd2" precedence="0">foo
        <socket precedence="0"><block color="#26cf3c" precedence="0"><socket precedence="0">a</socket>: <socket precedence="0">b</socket>
        <socket precedence="0">c</socket>: <socket precedence="0">d</socket></block></socket></block>
      '''

    testString 'String interpolation',
      'foo "#{a}"',
      '<block color="#268bd2" precedence="0">foo <socket precedence="0">"#{a}"</socket></block>'

    testString 'Range',
      '[1..10]',
      '<block color="#26cf3c" precedence="100">[<socket precedence="0">1</socket>..<socket precedence="0">10</socket>]</block>'

    testString 'Array',
      '[0, 1]'
      '<block color="#26cf3c" precedence="100">[<socket precedence="0">0</socket>, <socket precedence="0">1</socket>]</block>'

    testString 'Switch, one case, no default',
      '''
      switch k
        when a
          blah blah
      ''', '''
      <block color="#daa520" precedence="0">switch <socket precedence="0">k</socket>
        when <socket precedence="0">a</socket><indent depth="4">
      <block color="#268bd2" precedence="0">blah <socket precedence="0">blah</socket></block></indent></block>
      '''

    testString 'One-line switch, one case, no default',
      '''
      switch k
        when a then b
      ''',
      '''
      <block color="#daa520" precedence="0">switch <socket precedence="0">k</socket>
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
      <block color="#daa520" precedence="0">switch <socket precedence="0">k</socket>
        when <socket precedence="0">a</socket><indent depth="4">
      <block color="#268bd2" precedence="0">blah <socket precedence="0">blah</socket></block></indent>
        when <socket precedence="0">b</socket><indent depth="4">
      <block color="#268bd2" precedence="0">darn <socket precedence="0">it</socket></block></indent>
        else<indent depth="4">
      <block color="#268bd2" precedence="0">what <socket precedence="0">ever</socket></block></indent></block>
      '''

    testString 'Empty function definition', '->', '<block color="#26cf3c" precedence="0">-></block>'

    testString 'Class definition, normal form, constructor only',
      '''
      class Duck
        constructor: ->
      ''',
      '''
      <block color="#daa520" precedence="0">class <socket precedence="0">Duck</socket><indent depth="2">
      <block color="#26cf3c" precedence="0"><socket precedence="0">constructor</socket>: <socket precedence="0"><block color="#26cf3c" precedence="0">-></block></socket></block></indent></block>
      '''

    testString 'Non-parenthetical function call nested in parenthetical function call',
      '''
      a(b
        x: 1)
      ''',
      '''
      <block color="#268bd2" precedence="0">a(<socket precedence="0"><block color="#268bd2" precedence="0">b
        <socket precedence="0"><block color="#26cf3c" precedence="0"><socket precedence="0">x</socket>: <socket precedence="0">1</socket></block></socket>)</block></socket></block>
      '''

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
      <block color="#26cf3c" precedence="1"><socket precedence="1">a</socket> or <socket precedence="1">b</socket></block>
      <block color="#26cf3c" precedence="2"><socket precedence="2">a</socket> and <socket precedence="2">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> is <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> isnt <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> > <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> < <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> >= <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="3"><socket precedence="3">a</socket> <= <socket precedence="3">b</socket></block>
      <block color="#26cf3c" precedence="4"><socket precedence="4">a</socket> + <socket precedence="4">b</socket></block>
      <block color="#26cf3c" precedence="4"><socket precedence="4">a</socket> - <socket precedence="4">b</socket></block>
      <block color="#26cf3c" precedence="5"><socket precedence="5">a</socket> * <socket precedence="5">b</socket></block>
      <block color="#26cf3c" precedence="5"><socket precedence="5">a</socket> / <socket precedence="5">b</socket></block>
      <block color="#26cf3c" precedence="6"><socket precedence="6">a</socket> % <socket precedence="6">b</socket></block>
      <block color="#26cf3c" precedence="7"><socket precedence="7">a</socket> ** <socket precedence="7">b</socket></block>
      <block color="#26cf3c" precedence="7"><socket precedence="7">a</socket> %% <socket precedence="7">b</socket></block>
      <block color="#26cf3c" precedence="100"><socket precedence="101">a</socket>?</block>
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
      
    ''', 'Move both out'
    
    document.getBlockOnLine(0).moveTo document.getBlockOnLine(2).end.prev.container.start

    strictEqual document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move hello back in'

    document.getBlockOnLine(1).moveTo document.getBlockOnLine(0).end.prev.container.start

    strictEqual document.stringify(), '''
    console.log (for i in [1..10]
      console.log hello)
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
    see 1 + 
    ''', 'Unwrap'

  test 'View: compute children', ->
    view_ = new view.View
      padding: 5
      indentWidth: 10
      indentToungeHeight: 10
      tabOffset: 10
      tabWidth: 15
      tabHeight: 5
      tabSideWidth: 0.125
      dropAreaHeight: 20
      indentDropAreaMinWdith: 50
      emptySocketWidth: 20
      emptySocketHeight: 25
      emptyLineHeight: 25
      respectEphemeral: true
      ctx: window.document.querySelector('canvas').getContext('2d')

    document = coffee.parse '''
    fd 10
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    strictEqual documentView.lineChildren[0].length, 1, 'Children length 1 in `fd 10`'
    strictEqual documentView.lineChildren[0][0].child, document.getBlockOnLine(0), 'Child matches'
    strictEqual documentView.lineChildren[0][0].startLine, 0, 'Child starts on correct line'

    blockView = view_.getViewFor document.getBlockOnLine 0
    strictEqual blockView.lineChildren[0].length, 2, 'Children length 2 in `fd 10` block'
    strictEqual blockView.lineChildren[0][0].child.type, 'text', 'First child is text'
    strictEqual blockView.lineChildren[0][1].child.type, 'socket', 'Second child is socket'

    document = coffee.parse '''
    for [1..10]
      fd 10
      bk 10
      fd 20
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    blockView = view_.getViewFor document.getBlockOnLine 0
    strictEqual blockView.lineChildren[1].length, 1, 'One child in indent'
    strictEqual blockView.lineChildren[2][0].startLine, 0, 'Indent start line'
    strictEqual blockView.indentData[0], 1, 'Indent start data'
    strictEqual blockView.indentData[1], 2, 'Indent middle data'
    strictEqual blockView.indentData[2], 2, 'Indent middle data'
    strictEqual blockView.indentData[3], 3, 'Indent end data'

    document = coffee.parse '''
    for [1..10]
      for [1..10]
        fd 10
        fd 20
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    indentView = view_.getViewFor document.getBlockOnLine(1).end.prev.container
    strictEqual indentView.lineChildren[1][0].child.stringify(), 'fd 10', 'Relative line numbers'

    document = coffee.parse '''
    see (for [1..10]
      fd 10)
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    blockView = view_.getViewFor document.getBlockOnLine(0).start.next.next.container

    strictEqual blockView.lineChildren[1].length, 1, 'One child in indent in socket'
    strictEqual blockView.indentData[1], 3, 'Indent end data'

  test 'View: compute dimensions', ->
    view_ = new view.View
      padding: 5
      indentWidth: 10
      indentToungeHeight: 10
      tabOffset: 10
      tabWidth: 15
      tabHeight: 5
      tabSideWidth: 0.125
      dropAreaHeight: 20
      indentDropAreaMinWdith: 50
      emptySocketWidth: 20
      emptySocketHeight: 25
      emptyLineHeight: 25
      respectEphemeral: true
      ctx: window.document.querySelector('canvas').getContext('2d')
    
    document = coffee.parse '''
    for [1..10]
      fd 10
      fd 20
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    strictEqual documentView.dimensions[0].height, 15 + 6 * view_.opts.padding, 'First line height (block, 3 padding)'
    strictEqual documentView.dimensions[1].height, 15 + 4 * view_.opts.padding, 'Second line height (single block in indent)'
    strictEqual documentView.dimensions[2].height, 15 + 4 * view_.opts.padding + view_.opts.indentToungeHeight, 'Third line height (indentEnd at root)'

    document = coffee.parse '''
    fd (for [1..10]
      fd 10
      fd 20)
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    strictEqual documentView.dimensions[0].height, 15 + 8 * view_.opts.padding, 'First line height (block, 4 padding)'
    strictEqual documentView.dimensions[1].height, 15 + 4 * view_.opts.padding, 'Second line height (single block in nested indent)'
    strictEqual documentView.dimensions[2].height, 15 + 5 * view_.opts.padding + view_.opts.indentToungeHeight, 'Third line height (indentEnd with padding)'

    document = coffee.parse '''
    fd 10
    
    fd 20
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    strictEqual documentView.dimensions[1].height, view_.opts.emptyLineHeight, 'Renders empty lines'

  test 'View: bounding box flag stuff', ->
    view_ = new view.View
      padding: 5
      indentWidth: 10
      indentToungeHeight: 10
      tabOffset: 10
      tabWidth: 15
      tabHeight: 5
      tabSideWidth: 0.125
      dropAreaHeight: 20
      indentDropAreaMinWdith: 50
      emptySocketWidth: 20
      emptySocketHeight: 25
      emptyLineHeight: 25
      respectEphemeral: true
      ctx: window.document.querySelector('canvas').getContext('2d')

    document = coffee.parse '''
    fd 10
    fd 20
    fd 30
    fd 40
    '''

    documentView = view_.getViewFor document
    documentView.layout()

    blockView = view_.getViewFor document.getBlockOnLine 3

    strictEqual blockView.path._points[0].y, 15 * 4 + view_.opts.padding * 16, 'Original path points are O.K.'

    document.getBlockOnLine(2).spliceOut()
    documentView.layout()

    strictEqual blockView.path._points[0].y, 15 * 3 + view_.opts.padding * 12, 'Final path points are O.K.'
