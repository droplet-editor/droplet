helper = require '../../src/helper.coffee'
HTML = require '../../src/languages/html.coffee'

asyncTest 'Basic Document parsing', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <!doctype html>
    <html>
      <head>
        <title>Hello</title>
      </head>
      <body>
        Welcome to my page!
      </body>
    </html>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "lightblue",
      "nodeContext": {
        "prefix": "<!doctype html>",
        "suffix": "<!doctype html>",
        "type": "emptyTag"
      },
      "parseContext": "emptyTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<!doctype html>",
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightblue",
      "nodeContext": {
        "prefix": "<html>",
        "suffix": "</html>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<html>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightblue",
      "nodeContext": {
        "prefix": "<head>",
        "suffix": "</head>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<head>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightblue",
      "nodeContext": {
        "prefix": "<title>",
        "suffix": "</title>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<title>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Hello",
    {
      "type": "socketEnd"
    },
    {
      "type": "blockEnd"
    },
    {
      "type": "indentEnd"
    },
    "</title>",
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
    "</head>",
    {
      "type": "blockEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "orange",
      "nodeContext": {
        "prefix": "<body>",
        "suffix": "</body>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<body>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Welcome to my page!",
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
      "specialIndent": undefined,
      "type": "newline"
    },
    "</body>",
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
    "</html>",
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
      'The parser is working in a basic sense')
  return start()

asyncTest 'Removal of Empty nodes', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <html>
      <p>
        Welcome to my world
      </p>
    </html>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "lightblue",
      "nodeContext": {
        "prefix": "<html>",
        "suffix": "</html>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<html>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "purple",
      "nodeContext": {
        "prefix": "<p>",
        "suffix": "</p>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<p>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Welcome to my world",
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
      "specialIndent": undefined,
      "type": "newline"
    },
    "</p>",
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
    "</html>",
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
      'Artificial nodes are removed')
  return start()

asyncTest 'Optional Closing tags', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <ul>
      <li>Item1
      <li>Item2
    </ul>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "purple",
      "nodeContext": {
        "prefix": "<ul>",
        "suffix": "</ul>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<ul>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "purple",
      "nodeContext": {
        "prefix": "<li>",
        "suffix": "",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<li>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Item1",
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
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "purple",
      "nodeContext": {
        "prefix": "<li>",
        "suffix": "",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<li>",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Item2",
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
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "</ul>",
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
      'Optional closing elements are closed properly')
  return start()

asyncTest 'Attribute Sockets', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body background="red">

    </body>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "orange",
      "nodeContext": {
        "prefix": "<body ",
        "suffix": "</body>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<body ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "blockTag",
      "type": "socketStart",
      "emptyString": ""
    },
    "background=\"red\"",
    {
      "type": "socketEnd"
    },
    ">",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": "",
      "type": "newline"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "</body>",
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
      'Attributes are socketed')
  return start()

asyncTest 'Scoket empty attribute values', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body background = "">

    </body>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "orange",
      "nodeContext": {
        "prefix": "<body ",
        "suffix": "</body>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<body ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "blockTag",
      "type": "socketStart",
      "emptyString": ""
    },
    "background = \"\"",
    {
      "type": "socketEnd"
    },
    ">",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": "",
      "type": "newline"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "</body>",
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
      'Empty Attribute values are part of sockets')
  return start()

asyncTest 'Check overrides', ->
  htmlParser = new HTML({
    tags: {body: {category: 'spl'}}
    categories: {spl: {color: 'green'}}
  })
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body background = "">

    </body>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "green",
      "nodeContext": {
        "prefix": "<body ",
        "suffix": "</body>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<body ",
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "blockTag",
      "type": "socketStart",
      "emptyString": ""
    },
    "background = \"\"",
    {
      "type": "socketEnd"
    },
    ">",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": "",
      "type": "newline"
    },
    {
      "type": "indentEnd"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    "</body>",
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
      'Tag and category overrides work')
  return start()

asyncTest 'Trailing Space', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body>   
      Hello
    </body>
    ''').serialize()
  expectedSerialization = [
    {
      "indentContext": undefined,
      "type": "documentStart"
    },
    {
      "color": "orange",
      "nodeContext": {
        "prefix": "<body>   ",
        "suffix": "</body>",
        "type": "blockTag"
      },
      "parseContext": "blockTag",
      "shape": 0,
      "type": "blockStart"
    },
    "<body>   ",
    {
      "indentContext": "blockTag",
      "prefix": "  ",
      "type": "indentStart"
    },
    {
      "specialIndent": undefined,
      "type": "newline"
    },
    {
      "color": "lightgreen",
      "nodeContext": {
        "prefix": "",
        "suffix": "",
        "type": "text"
      },
      "parseContext": "text",
      "shape": 0,
      "type": "blockStart"
    },
    {
      "dropdown": false,
      "handwritten": false,
      "parseContext": "text",
      "type": "socketStart",
      "emptyString": ""
    },
    "Hello",
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
      "specialIndent": undefined,
      "type": "newline"
    },
    "</body>",
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
      'Trailing space is part of parent block')
  return start()
