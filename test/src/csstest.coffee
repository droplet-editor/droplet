helper = require '../../src/helper.coffee'
CSS = require '../../src/languages/css.coffee'

asyncTest 'Basic Rule parsing', ->
  cssParser = new CSS()
  window.customSerialization = customSerialization = cssParser.parse(
    '''
    a {
      background: red;
    }
    ''').serialize()
  expectedSerialization = '''<document><block
      precedence="1"
      color="orange"
      socketLevel="0"
      classes="rule"><socket
      precedence="1"
      handwritten="false"
      classes="selector"><block
      precedence="1"
      color="green"
      socketLevel="0"
      classes="selector"><socket
      precedence="1"
      handwritten="false"
      classes="selector-elementname">a</socket></block></socket> {<indent
      prefix="  "
      classes="rule">
    <block
      precedence="1"
      color="amber"
      socketLevel="0"
      classes="property">background: <socket
      precedence="1"
      handwritten="false"
      classes="property-part">red</socket>;</block></indent>
    }</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'The parser is working in a basic sense')
  return start()

asyncTest 'Parse Contexts', ->
  cssParser = new CSS()
  window.customSerialization = customSerialization = cssParser.parse(
    '''
    background:red
    ''', {parentContext: 'rule'}).serialize()
  expectedSerialization = '''<document><block
      precedence="1"
      color="amber"
      socketLevel="0"
      classes="property no-semicolon">background:<socket
      precedence="1"
      handwritten="false"
      classes="property-part">red</socket></block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'a:b resolves to a property in rule context')
  window.customSerialization2 = customSerialization2 = cssParser.parse(
    '''
    background:red
    ''').serialize()
  expectedSerialization2 = '''<document><block
      precedence="1"
      color="green"
      socketLevel="0"
      classes="selector"><socket
      precedence="1"
      handwritten="false"
      classes="selector-elementname">background</socket><socket
      precedence="1"
      handwritten="false"
      classes="selector-modifier"><block
      precedence="1"
      color="lightblue"
      socketLevel="0"
      classes="selector-modifier">:<socket
      precedence="1"
      handwritten="false"
      classes="pseudo"
      dropdown="active hover link focus visited">red</socket></block></socket></block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization2),
      helper.xmlPrettyPrint(expectedSerialization2),
      'a:b resolves to a selector without a context')
  return start()