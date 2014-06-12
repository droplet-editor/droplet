require ['ice-coffee'], (coffee) ->
  
  readFile = (name) ->
    q = new XMLHttpRequest()
    q.open 'GET', name, false
    q.send()

    return q.responseText

  test 'Parser unity', ->
    testString = (str) ->
      equal str, coffee.parse(str).stringify(), 'Unity test on ' + str

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
    
    nodes = readFile 'nodes.coffee'
    console.log nodes

    equal nodes, coffee.parse(nodes).stringify(), 'Unity test on nodes.coffee'
    
  
  test 'Parser success', ->
    testString = (m, str, expected) ->
      equal coffee.parse(str).serialize(), expected, m
    
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

    equal document.getBlockOnLine(1).stringify(), 'see i', 'line 1'
    equal document.getBlockOnLine(3).stringify(), 'see k', 'line 3'
    equal document.getBlockOnLine(5).stringify(), 'see q', 'line 5'
    equal document.getBlockOnLine(7).stringify(), 'see j', 'line 7'

  test 'Location serialization unity', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log hello
      if a is b
        console.log world
    '''

    head = document.start.next
    until head is document.end
      equal document.getTokenAtLocation(head.getSerializedLocation()), head, 'Equality for ' + head.type
      head = head.next

  test 'Block move', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log hello
      console.log world
    '''

    document.getBlockOnLine(2).moveTo document.start

    equal document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move console.log world out'

    document.getBlockOnLine(2).moveTo document.start

    equal document.stringify(), '''
    console.log hello
    console.log world
    for i in [1..10]
      
    ''', 'Move both out'
    
    document.getBlockOnLine(0).moveTo document.getBlockOnLine(2).end.prev.indent.start

    equal document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move hello back in'

    document.getBlockOnLine(1).moveTo document.getBlockOnLine(0).end.prev.socket.start

    equal document.stringify(), '''
    console.log (for i in [1..10]
      console.log hello)
    ''', 'Move for into socket (req. paren wrap)'

  test 'Paren wrap', ->
    document = coffee.parse '''
    Math.sqrt 2
    see 1 + 1
    '''

    (block = document.getBlockOnLine(0)).moveTo document.getBlockOnLine(1).end.prev.prev.prev.socket.start

    equal document.stringify(), '''
    see 1 + (Math.sqrt 2)
    ''', 'Wrap'

    block.moveTo document.start

    equal document.stringify(), '''
    Math.sqrt 2
    see 1 + 
    ''', 'Unwrap'
