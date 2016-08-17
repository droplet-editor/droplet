helper = require '../../src/helper.coffee'
Python = require '../../src/languages/python.coffee'

asyncTest 'Python basic parsing', ->
  py = new Python({
    functions: {
      'print': {
        value: true
      }
    }
  })

  serialRes = py.parse(
    '''
    print 'hello'
    '''
  ).serialize()

  # why is "indentContext":undefined required here?
  serialComp = [{"type":"documentStart","indentContext":undefined,
  },
    {"type":"blockStart","color":"command","shape":0,"parseContext":"print_stmt","nodeContext":{"type":"print_stmt","prefix":"print ","suffix":""}},
    "print ",
    {"type":"socketStart","emptyString":"__0_droplet__","parseContext":"test","handwritten":false,"dropdown":false},"'hello'",{"type":"socketEnd"},
    {"type":"blockEnd"},
    {"type":"documentEnd"}]

  deepEqual serialRes, serialComp, 'Basic parsing should work'
  start()

asyncTest 'Py indent', ->
  py = new Python({
    functions: {}
  })
  code = 'for i in range(0, 10):\n continue'
  result = py.parse(code)
  stringifiedRes = result.stringify()
  strictEqual(code, stringifiedRes)
  start()

asyncTest 'Py for loop', ->
  py = new Python({
    functions: {}
  })

  serialRes = py.parse('for i in range(0, 10):\n continue').serialize()
  serialComp = [{"type":"documentStart","indentContext":undefined},
    {"type":"blockStart","color":"control","shape":0,"parseContext":"for_stmt","nodeContext":{"type":"for_stmt","prefix":"for ","suffix":""}},
    "for ",
    {"type":"socketStart","emptyString":"__0_droplet__","parseContext":"exprlist","handwritten":false,"dropdown":false},"i",{"type":"socketEnd"},
    " in ",
    {"type":"socketStart","emptyString":"__0_droplet__","parseContext":"testlist","handwritten":false,"dropdown":false},
    {"type":"blockStart","color":"comment","shape":0,"parseContext":"power","nodeContext":{"type":"power","prefix":"range(","suffix":")"}},
    "range(",
    {"type":"socketStart","emptyString":"__0_droplet__","parseContext":"argument","handwritten":false,"dropdown":false},"0",{"type":"socketEnd"},
    ", ",
    {"type":"socketStart","emptyString":"__0_droplet__","parseContext":"argument","handwritten":false,"dropdown":false},"10",{"type":"socketEnd"}
  ,")",
    {"type":"blockEnd"},
    {"type":"socketEnd"},":",
    {"type":"indentStart","prefix":" ","indentContext":"small_stmt"},{"type":"newline","specialIndent":undefined, # ???
    },
    {"type":"blockStart","color":0,"shape":1,"parseContext":0,"nodeContext":{"type":"__comment__","prefix":"","suffix":""}},
    {"type":"socketStart","emptyString":"","parseContext":null,"handwritten":true,"dropdown":false},"continue",{"type":"socketEnd"},{"type":"blockEnd"},{"type":"indentEnd"},
    {"type":"blockEnd"},
    {"type":"documentEnd"}]

  deepEqual serialRes, serialComp, 'For loop block and indent should work'
  start()


