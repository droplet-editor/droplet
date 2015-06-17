assert = require 'assert'
fs = require 'fs'

Coffee = require '../../src/languages/coffee.coffee'

coffee = new Coffee()

describe 'DropletLocation unity', (done) ->
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
