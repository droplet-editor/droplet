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
  expectedSerialization = '''<document><block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="#documentType">&amp;lt;!doctype html&amp;gt;</block>
    <block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="html">&amp;lt;html&amp;gt;<indent
      prefix="  "
      classes="html">
    <block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="head">&amp;lt;head&amp;gt;<indent
      prefix="  "
      classes="head">
    <block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="title">&amp;lt;title&amp;gt;<indent
      prefix="  "
      classes="title"><block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Hello</socket></block></indent>&amp;lt;/title&amp;gt;</block></indent>
    &amp;lt;/head&amp;gt;</block>
    <block
      precedence="1"
      color="orange"
      socketLevel="0"
      classes="body">&amp;lt;body&amp;gt;<indent
      prefix="  "
      classes="body">
    <block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Welcome to my page!</socket></block></indent>
    &amp;lt;/body&amp;gt;</block></indent>
    &amp;lt;/html&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document><block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="html">&amp;lt;html&amp;gt;<indent
      prefix="  "
      classes="html">
    <block
      precedence="1"
      color="purple"
      socketLevel="0"
      classes="p">&amp;lt;p&amp;gt;<indent
      prefix="  "
      classes="p">
    <block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Welcome to my world</socket></block></indent>
    &amp;lt;/p&amp;gt;</block></indent>
    &amp;lt;/html&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document><block
      precedence="1"
      color="purple"
      socketLevel="0"
      classes="ul">&amp;lt;ul&amp;gt;<indent
      prefix="  "
      classes="ul">
    <block
      precedence="1"
      color="purple"
      socketLevel="0"
      classes="li">&amp;lt;li&amp;gt;<indent
      prefix="  "
      classes="li"><block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Item1</socket></block></indent></block>
    <block
      precedence="1"
      color="purple"
      socketLevel="0"
      classes="li">&amp;lt;li&amp;gt;<indent
      prefix="  "
      classes="li"><block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Item2</socket></block></indent></block></indent>
    &amp;lt;/ul&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Optional closing elements are closed properly')
  return start()

asyncTest 'Attribute Sockets', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body background="red">

    </body>
    ''').serialize()
  expectedSerialization = '''<document><block
      precedence="1"
      color="orange"
      socketLevel="0"
      classes="body">&amp;lt;body <socket
      precedence="0"
      handwritten="false"
      classes="#attribute">background="red"</socket>&amp;gt;<indent
      prefix="  "
      classes="body">
    </indent>
    &amp;lt;/body&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Attributes are socketed')
  return start()

asyncTest 'Scoket empty attribute values', ->
  htmlParser = new HTML()
  window.customSerialization = customSerialization = htmlParser.parse(
    '''
    <body background = "">

    </body>
    ''').serialize()
  expectedSerialization = '''<document><block
      precedence="1"
      color="orange"
      socketLevel="0"
      classes="body">&amp;lt;body <socket
      precedence="0"
      handwritten="false"
      classes="#attribute">background = ""</socket>&amp;gt;<indent
      prefix="  "
      classes="body">
    </indent>
    &amp;lt;/body&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document><block
      precedence="1"
      color="green"
      socketLevel="0"
      classes="body">&amp;lt;body <socket
      precedence="0"
      handwritten="false"
      classes="#attribute">background = ""</socket>&amp;gt;<indent
      prefix="  "
      classes="body">
    </indent>
    &amp;lt;/body&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document><block
      precedence="1"
      color="orange"
      socketLevel="0"
      classes="body">&amp;lt;body>   <indent
      prefix="  "
      classes="body">
    <block
      precedence="1"
      color="lightgreen"
      socketLevel="0"
      classes="#text"><socket
      precedence="0"
      handwritten="false"
      classes="#text">Hello</socket></block></indent>
    &amp;lt;/body&amp;gt;</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Trailing space is part of parent block')
  return start()
