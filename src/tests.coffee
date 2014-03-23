require ['ice-coffee'], (coffee) ->
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
