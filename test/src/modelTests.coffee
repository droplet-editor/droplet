assert = require 'assert'
fs = require 'fs'

Coffee = require '../../src/languages/coffee.coffee'
model = require '../../src/model.coffee'
helper = require '../../src/helper.coffee'

coffee = new Coffee()

describe 'Model',->
  it 'should be able to perform basic token operations', ->
    a = new model.Token()
    b = new model.Token()
    c = new model.Token()
    d = new model.Token()

    assert.strictEqual helper.connect(a, b), b, 'connect() returns argument'

    assert.strictEqual a.prev, null, 'connect assembles correct linked list'
    assert.strictEqual a.next, b, 'connect assembles correct linked list'
    assert.strictEqual b.prev, a, 'connect assembles correct linked list'
    assert.strictEqual b.next, null, 'connect assembles correct linked list'

    helper.connect b, c
    b.remove()

    assert.strictEqual a.next, c, 'remove removes token'
    assert.strictEqual c.prev, a, 'remove removes token'

  it 'should be able to do proper parenting', ->
    cont1 = new model.Document()
    cont2 = new model.Container()

    a = cont1.start
    b = new model.Token()
    c = cont2.start
    d = new model.Token()
    e = cont2.end
    f = cont1.end

    helper.string [a, b, c, d, e, f]

    cont1.correctParentTree()

    assert.strictEqual a.parent, null, 'correctParentTree() output is correct (a)'
    assert.strictEqual b.parent, cont1, 'correctParentTree() output is correct (b)'
    assert.strictEqual c.parent, cont1, 'correctParentTree() output is correct (c)'
    assert.strictEqual d.parent, cont2, 'correctParentTree() output is correct (d)'
    assert.strictEqual e.parent, cont1, 'correctParentTree() output is correct (e)'
    assert.strictEqual f.parent, null, 'correctParentTree() output is correct (f)'

    g = new model.Token()
    h = new model.Token()
    helper.connect g, h

    list = new model.List g, h
    cont1.insert d, list

    assert.strictEqual a.parent, null, 'splice in parents still work'
    assert.strictEqual b.parent, cont1, 'splice in parents still work'
    assert.strictEqual c.parent, cont1, 'splice in parents still work'
    assert.strictEqual d.parent, cont2, 'splice in parents still work'
    assert.strictEqual g.parent, cont2, 'splice in parents still work'
    assert.strictEqual h.parent, cont2, 'splice in parents still work'
    assert.strictEqual e.parent, cont1, 'splice in parents still work'
    assert.strictEqual f.parent, null, 'splice in parents still work'

    cont3 = new model.Container()
    cont1.insert g, cont3

    assert.strictEqual h.parent, cont2, 'splice in parents still work'

  it 'should be able to get a block on a line', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log i
    if a is b
      console.log k
      if b is c
        console.log q
    else
      console.log j
    '''

    assert.strictEqual document.getBlockOnLine(1).stringify(), 'console.log i', 'line 1'
    assert.strictEqual document.getBlockOnLine(3).stringify(), 'console.log k', 'line 3'
    assert.strictEqual document.getBlockOnLine(5).stringify(), 'console.log q', 'line 5'
    assert.strictEqual document.getBlockOnLine(7).stringify(), 'console.log j', 'line 7'

  it 'should be able to move a block', ->
    document = coffee.parse '''
    for i in [1..10]
      console.log hello
      console.log world
    '''

    block = document.getBlockOnLine(2)
    document.remove block
    document.insert document.start, block

    assert.strictEqual document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move console.log world out'

    block = document.getBlockOnLine(2)
    document.remove block
    document.insert document.start, block

    assert.strictEqual document.stringify(), '''
    console.log hello
    console.log world
    for i in [1..10]
      ``
    ''', 'Move both out'

    block = document.getBlockOnLine(0)
    destination = document.getBlockOnLine(2).end.prev.container.start
    document.remove block
    document.insert destination, block

    assert.strictEqual document.stringify(), '''
    console.log world
    for i in [1..10]
      console.log hello
    ''', 'Move hello back in'

  it 'should assign indentation properly', ->
    document = coffee.parse '''
    for i in [1..10]
      ``
    for i in [1..10]
      alert 10
    '''

    block = document.getBlockOnLine(2)
    destination = document.getBlockOnLine(1).end.prev.container.start
    document.remove block
    document.insert destination, block

    assert.strictEqual document.stringify(), '''
    for i in [1..10]
      for i in [1..10]
        alert 10
    '''

  # DropletLocation unity
  testString = (str) ->
    it "should have unity for all tokens on '#{str[..10]}...'", ->
      document = coffee.parse(str, wrapAtRoot: true)
      head = document.start
      until head is document.end
        assert.strictEqual document.getFromLocation(head.getLocation()), head
        head = head.next
  testString '/// #{x} ///'
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
