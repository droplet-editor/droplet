helper = require '../../src/helper.coffee'
JavaScript = require '../../src/languages/javascript.coffee'

asyncTest 'JS dotted methods', ->
  customJS = new JavaScript({
    functions: {
      'console.log': {},
      speak: {},
      'Math.log': {
        value: true
      },
      '*.toString': {
        value: true
      },
      '?.pos': {
        command: true,
        color: 'red'
      },
      setTimeout: {
        command: true,
        value: true
      }
    }
  })

  customSerialization = customJS.parse(
    '''
    x.pos(100);
    return console.log(Math.log(log(x.toString(~pos()))));
    '''
  ).serialize()

  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "red",
      "nodeContext": {
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 2,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "CalleeObject",
      "type": "socketStart",
      "emptyString": "__"
    },
    "x",
    {
      "type": "socketEnd"
    },
    ".pos(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "100",
    {
      "type": "socketEnd"
    },
    ");",
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "yellow",
      "nodeContext": {
        "prefix": "return ",
        "suffix": ";",
        "type": "ReturnStatement"
      },
      "parseContext": "program",
      "shape": 2,
      "type": "blockStart"
    },
    "return ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "console.log(",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 2,
      "type": "blockStart"
    },
    "console.log(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "Math.log(",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    "Math.log(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "log",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "CalleeObject",
      "type": "socketStart",
      "emptyString": "__"
    },
    "x",
    {
      "type": "socketEnd"
    },
    ".toString(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "~",
        "suffix": "",
        "type": "Operator~"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    "~",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "red",
      "nodeContext": {
        "prefix": "pos()",
        "suffix": "pos()",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 2,
      "type": "blockStart"
    },
    "pos()",
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
    ")",
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
    ")",
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
    ";",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      (customSerialization),
      (expectedSerialization),
      'Dotted known functions work')
  start()

asyncTest 'JS Custom Colors', ->
  customJS = new JavaScript({
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
  customSerialization = customJS.parse(
      'return b != (a += [c + d][0]);').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "#222",
      "nodeContext": {
        "prefix": "return ",
        "suffix": ";",
        "type": "ReturnStatement"
      },
      "parseContext": "program",
      "shape": 2,
      "type": "blockStart"
    },
    "return ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator!="
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator!=",
      "type": "socketStart",
      "emptyString": "__"
    },
    "b",
    {
      "type": "socketEnd"
    },
    " != ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator!=",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "#777",
      "nodeContext": {
        "prefix": "(",
        "suffix": ")",
        "type": "AssignmentExpression"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Lvalue",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " += ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "#666",
      "nodeContext": {
        "prefix": "",
        "suffix": "]",
        "type": "MemberExpression"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "#666",
      "nodeContext": {
        "prefix": "[",
        "suffix": "]",
        "type": "ArrayExpression"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    "[",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "#444",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator+"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator+",
      "type": "socketStart",
      "emptyString": "__"
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
      "emptyString": "__"
    },
    "d",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
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
    "[",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
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
    ";",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      (customSerialization),
      (expectedSerialization),
      'JS Custom colors work')
  start()

asyncTest 'JS empty indents', ->
  customJS = new JavaScript()
  code = 'if (__) {\n\n}'
  customSerialization = customJS.parse('if (__) {\n\n}')
  stringifiedJS = customSerialization.stringify()
  deepEqual(stringifiedJS, code)
  start()

asyncTest 'JS LogicalExpressions', ->
  customJS = new JavaScript()
  customSerialization = customJS.parse(
      'a && b').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator&&"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator&&",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " && ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator&&",
      "type": "socketStart",
      "emptyString": "__"
    },
    "b",
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
      (customSerialization),
      (expectedSerialization),
      'Logical expression precedences are assigned.')
  start()

asyncTest 'JS omits unary +/- for literals', ->
  customJS = new JavaScript()
  customSerialization = customJS.parse(
      'foo(+1, -1, +a());').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "foo",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "+1",
    {
      "type": "socketEnd"
    },
    ", ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "-1",
    {
      "type": "socketEnd"
    },
    ", ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "+",
        "suffix": "",
        "type": "Operator+"
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    "+",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "blue",
      "nodeContext": {
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression"
      "type": "socketStart",
      "emptyString": ""
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
    ");",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      (customSerialization),
      (expectedSerialization),
      'Unary literal +/- are not parsed, but unary nonliteral operators are')
  start()


asyncTest 'JS Elif', ->
  customJS = new JavaScript()
  customSerialization = customJS.parse(
      'if (a == 0) {\n' +
      '  fd(0);\n' +
      '} else if (a == 1) {\n' +
      '  fd(100);\n' +
      '} else if (a == 2) {\n' +
      '  fd(200);\n' +
      '}'
  ).serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "orange",
      "nodeContext": {
        "prefix": "if (",
        "suffix": "}",
        "type": "IfStatement"
      },
      "parseContext": "program",
      "shape": 1,
      "type": "blockStart"
    },
    "if (",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator=="
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " == ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "0",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    ") {",
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
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "fd",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "0",
    {
      "type": "socketEnd"
    },
    ");",
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "} else if (",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator=="
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " == ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "1",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    ") {",
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
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "fd",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "100",
    {
      "type": "socketEnd"
    },
    ");",
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "} else if (",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    {
      "color": "cyan",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "Operator=="
      },
      "parseContext": "program",
      "shape": 3,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "a",
    {
      "type": "socketEnd"
    },
    " == ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Operator==",
      "type": "socketStart",
      "emptyString": "__"
    },
    "2",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "socketEnd"
    },
    ") {",
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
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "fd",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": "__"
    },
    "200",
    {
      "type": "socketEnd"
    },
    ");",
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "}",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      (customSerialization),
      (expectedSerialization),
      'Combines if-else')
  start()

asyncTest 'JS beginner mode loops', ->
  customJS = new JavaScript({
    categories: {loops: {color: 'green', beginner: true}}
  })
  customSerialization = customJS.parse(
    '''
    for (var i = 0; i < 10; i++) {
      go();
    }
    '''
  ).serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "for (var i = 0; i < ",
        "suffix": "}",
        "type": "ForStatement"
      },
      "parseContext": "program",
      "shape": 1,
      "type": "blockStart"
    },
    "for (var i = 0; i < ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "program",
      "type": "socketStart",
      "emptyString": "__"
    },
    "10",
    {
      "type": "socketEnd"
    },
    "; i++) {",
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
        "prefix": "",
        "suffix": ")",
        "type": "CallExpression"
      },
      "parseContext": "program",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Callee",
      "type": "socketStart",
      "emptyString": "__"
    },
    "go",
    {
      "type": "socketEnd"
    },
    "(",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "Expression",
      "type": "socketStart",
      "emptyString": ""
    },
    {
      "type": "socketEnd"
    },
    ");",
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "}",
    {
      "type": "blockEnd"
    },
    {
      "type": "documentEnd"
    }
  ]
  deepEqual(
      (customSerialization),
      (expectedSerialization),
      'Combines if-else')
  start()

asyncTest 'JS object expression', ->
  customJS = new JavaScript()
  customSerialization = customJS.parse('{a: 1}').serialize()
  expectedSerialization =
    '<document><block ' +
    'precedence=\"0\" ' +
    'color=\"teal\" ' +
    'socketLevel=\"0\" ' +
    'classes=\"ObjectExpression mostly-value\">({<socket ' +
    'precedence=\"0\" ' +
    'handwritten=\"false\" ' +
    'classes=\"\">a</socket>: <socket ' +
    'precedence=\"0\" ' +
    'handwritten=\"false\" ' +
    'classes=\"\">1</socket>})</block></document>'
  strictEqual(
    helper.xmlPrettyPrint(customSerialization),
    helper.xmlPrettyPrint(expectedSerialization),
    'Parses bare object expression')
  start()
