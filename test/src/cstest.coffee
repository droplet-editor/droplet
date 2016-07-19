helper = require '../../src/helper.coffee'
Coffee = require '../../src/languages/coffee.coffee'

asyncTest 'Parser configurability', ->
  customCoffee = new Coffee({
    functions: {
      marius: {
        color: 'red'
      },
      valjean: {},
      eponine: {
        value: true,
        color: 'purplish'
      },
      fantine: {
        value: true
      },
      cosette: {
        command: true,
        value: true
      }
    }
  })
  window.customSerialization = customSerialization = customCoffee.parse(
    '''
    marius eponine 10
    alert random 100
    cosette 20
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "red",
      "nodeContext": {
        "prefix": "marius ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "marius ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "purplish",
      "nodeContext": {
        "prefix": "eponine ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 3,
      "type": "blockStart"
    },
    "eponine ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    "10",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "``"
    },
    "alert",
    {
      "type": "socketEnd"
    },
    " ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "``"
    },
    "random",
    {
      "type": "socketEnd"
    },
    " ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    "100",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "cosette ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 0,
      "type": "blockStart"
    },
    "cosette ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    "20",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      customSerialization,
      expectedSerialization,
      'Custom known functions work')
  return start()

asyncTest 'Dotted methods', ->
  customCoffee = new Coffee({
    functions: {
      'console.log': {},
      speak: {},
      'Math.log': {
        value: true
      },
      '*.toString': {
        value: true
      },
      '?.fd': {
        command: true
      },
      log: {
        value: true
      },
      setTimeout: {
        command: true,
        value: true
      }
    }
  })
  customSerialization = customCoffee.parse(
      'console.log Math.log log x.toString log.fd()\nfd()').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "console.log ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "console.log ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "Math.log ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 3,
      "type": "blockStart"
    },
    "Math.log ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "log ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 3,
      "type": "blockStart"
    },
    "log ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "PropertyAccess",
      "type": "socketStart",
      "emptyString": "``"
    },
    "x",
    {
      "type": "socketEnd"
    },
    ".toString ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": ".fd()",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "PropertyAccess",
      "type": "socketStart",
      "emptyString": "``"
    },
    "log",
    {
      "type": "socketEnd"
    },
    ".fd()",
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "fd()",
        "suffix": "fd()",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "fd()",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]

  deepEqual(
      customSerialization,
      expectedSerialization,
      'Dotted known functions work')
  start()

asyncTest 'Merged code blocks', ->
  coffee = new Coffee()
  customSerialization = coffee.parse(
    '''
    x = (y) -> y * y
    alert \'clickme\', ->
      console.log \'ouch\'
    '''
  ).serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "purple",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Assign"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Lvalue",
      "type": "socketStart",
      "emptyString": "``"
    },
    "x",
    {
      "type": "socketEnd"
    },
    " = (",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "__comment__",
      "type": "socketStart",
      "emptyString": ""
    },
    "y",
    {
      "type": "socketEnd"
    },
    ") -> ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": 0,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator*"
      },
      "parseContext": "__comment__",
      "shape": 4,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator*",
      "type": "socketStart",
      "emptyString": "``"
    },
    "y",
    {
      "type": "socketEnd"
    },
    " * ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator*",
      "type": "socketStart",
      "emptyString": "``"
    },
    "y",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "alert ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "alert ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": 0,
      "type": "socketStart",
      "emptyString": "``"
    },
    "'clickme'",
    {
      "type": "socketEnd"
    },
    ", ->",
    {
      "indentContext": null,
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "console.log ",
        "suffix": "",
        "type": "Call"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "console.log ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": -1,
      "type": "socketStart",
      "emptyString": "``"
    },
    "'ouch'",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]

  deepEqual(
      customSerialization,
      expectedSerialization,
      'Merged code blocks work')
  return start()

asyncTest 'Custom Colors', ->
  customCoffee = new Coffee({
    categories: {
      functions: {color: '#111'},
      returns: {color: '#222'},
      comments: {color: '#333'},
      arithmetic: {color: '#444'},
      containers: {color: '#666'},
      assignments: {color: '#777'},
      loops: {color: '#888'},
      conditionals: {color: '#999'},
      value: {color: '#aaa'},
      command: {color: '#bbb'}
    }
  })
  customSerialization = customCoffee.parse(
      'return b != (a += [c + d][0])').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "#222",
      "nodeContext": {
        "prefix": "return ",
        "suffix": "",
        "type": "Return"
      },
      "parseContext": "__comment__",
      "shape": 1,
      "type": "blockStart"
    },
    "return ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator!=="
      },
      "parseContext": "__comment__",
      "shape": 4,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator!==",
      "type": "socketStart",
      "emptyString": "``"
    },
    "b",
    {
      "type": "socketEnd"
    },
    " != ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator!==",
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "#777",
      "nodeContext": {
        "prefix": "(",
        "suffix": ")",
        "type": "Assign"
      },
      "parseContext": "__comment__",
      "shape": 2,
      "type": "blockStart"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Lvalue",
      "type": "socketStart",
      "emptyString": "``"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " += ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "FunctionBody",
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "#aaa",
      "nodeContext": {
        "prefix": "",
        "suffix": "]",
        "type": "PropertyAccess"
      },
      "parseContext": "__comment__",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": 0,
      "type": "socketStart",
      "emptyString": "``"
    },
    {
      "color": "#666",
      "nodeContext": {
        "prefix": "[",
        "suffix": "]",
        "type": "Arr"
      },
      "parseContext": "__comment__",
      "shape": 4,
      "type": "blockStart"
    },
    "[",
    {
      "indentContext": null,
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "color": "#444",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator+"
      },
      "parseContext": "__comment__",
      "shape": 4,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator+",
      "type": "socketStart",
      "emptyString": "``"
    },
    "c",
    {
      "type": "socketEnd"
    },
    " + ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator+",
      "type": "socketStart",
      "emptyString": "``"
    },
    "d",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    "]",
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    "[",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "``"
    },
    "0",
    {
      "type": "socketEnd"
    },
    "]",
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    ")",
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      customSerialization,
      expectedSerialization,
      'Custom colors work')
  start()
