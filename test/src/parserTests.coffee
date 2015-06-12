assert = require 'assert'
fs = require 'fs'

Coffee = require '../../src/coffee.coffee'

coffee = new Coffee()

describe 'Parser unity', (done) ->
  testString = (str) ->
    it 'should round-trip ' + str.split('\n')[0] +
        (if str.split('\n').length > 1 then '...' else ''), ->
      assert.equal str, coffee.parse(str, wrapAtRoot: true).stringify(coffee)
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
  testFile = (name) ->
    it "should round-trip on #{name}", ->
      file = fs.readFileSync(name).toString()

      unparsed = coffee.parse(file, wrapAtRoot: true).stringify(coffee)

      filelines = file.split '\n'
      for line, i in unparsed.split '\n'
        assert.equal line, filelines[i], "#{i} failed"

  testFile 'test/data/nodes.coffee'
  testFile 'test/data/allTests.coffee'
