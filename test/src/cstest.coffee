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
  expectedSerialization = '''<document
    ><block
      precedence="0"
      color="red"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    >marius <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="purplish"
      socketLevel="0"
      classes="Call works-as-method-call mostly-value"
    >eponine <socket
      precedence="-1"
      handwritten="false"
      classes="Value">10</socket></block></socket></block>\n<block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call any-drop"
    ><socket
      precedence="0"
      handwritten="false"
      classes="Value"
    >alert</socket> <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call any-drop"
    ><socket
      precedence="0"
      handwritten="false"
      classes="Value"
    >random</socket> <socket
      precedence="-1"
      handwritten="false"
      classes="Value">100</socket></block></socket></block>\n<block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call any-drop">cosette <socket
      precedence="-1"
      handwritten="false"
      classes="Value">20</socket></block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document
    ><block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    >console.log <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="green"
      socketLevel="0"
      classes="Call works-as-method-call mostly-value"
    >Math.log <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="green"
      socketLevel="0"
      classes="Call works-as-method-call mostly-value"
    >log <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="green"
      socketLevel="0"
      classes="Call works-as-method-call mostly-value"
    ><socket
      precedence="0"
      handwritten="false"
      classes="Literal"
    >x</socket>.toString <socket
      precedence="-1"
      handwritten="false"
      classes="Call works-as-method-call"
    ><block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    ><socket
      precedence="0"
      handwritten="false"
      classes="Literal"
    >log</socket>.fd()</block></socket
    ></block></socket
    ></block></socket
    ></block></socket></block
    >\n<block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    >fd()</block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
  expectedSerialization = '''<document
    ><block
      precedence="0"
      color="purple"
      socketLevel="0"
      classes="Assign mostly-block"
    ><socket
      precedence="0"
      handwritten="false"
      classes="Value lvalue"
    >x</socket
    > = (<socket
      precedence="0"
      handwritten="false"
      classes="Param forbid-all"
    >y</socket
    >) -&gt; <socket
      precedence="0"
      handwritten="false"
      classes="Block"
    ><block
      precedence="5"
      color="green"
      socketLevel="0"
      classes="Op value-only"
    ><socket
      precedence="5"
      handwritten="false"
      classes="Value"
    >y</socket
    > * <socket
      precedence="5"
      handwritten="false"
      classes="Value"
    >y</socket></block></socket></block
    >\n<block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    >alert <socket
      precedence="0"
      handwritten="false"
      classes="Value"
    >\'clickme\'</socket
    >, -&gt;<indent
      prefix="  "
      classes=""
    >\n<block
      precedence="0"
      color="blue"
      socketLevel="0"
      classes="Call works-as-method-call mostly-block"
    >console.log <socket
      precedence="-1"
      handwritten="false"
      classes="Value"
    >\'ouch\'</socket></block></indent></block></document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
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
      'return b != (a += [c + d][0]);').serialize()
  expectedSerialization = '''<document
    ><block
     precedence="0"
     color="#222"
     socketLevel="0"
     classes="Return block-only"
    >return <socket
     precedence="0"
     handwritten="false"
     classes="Op"
    ><block
     precedence="3"
     color="cyan"
     socketLevel="0"
     classes="Op value-only"
    ><socket
     precedence="3"
     handwritten="false"
     classes="Value"
    >b</socket
    > != <socket
     precedence="3"
     handwritten="false"
     classes="Value"
    ><block
     precedence="0"
     color="#777"
     socketLevel="0"
     classes="Assign mostly-block"
    >(<socket
     precedence="0"
     handwritten="false"
     classes="Value lvalue"
    >a</socket
    > += <socket
     precedence="0"
     handwritten="false"
     classes="Value"
    ><block
     precedence="0"
     color="#aaa"
     socketLevel="0"
     classes="Value mostly-value"
    ><socket
     precedence="0"
     handwritten="false"
     classes="Arr"
    ><block
     precedence="100"
     color="#666"
     socketLevel="0"
     classes="Arr value-only"
    >[<indent
     prefix="  "
     classes=""
    ><block
     precedence="4"
     color="#444"
     socketLevel="0"
     classes="Op value-only"
    ><socket
     precedence="4"
     handwritten="false"
     classes="Value"
    >c</socket
    > + <socket
     precedence="4"
     handwritten="false"
     classes="Value"
    >d</socket
    ></block
    ></indent
    >]</block
    ></socket
    >[<socket
     precedence="0"
     handwritten="false"
     classes="Value"
    >0</socket
    >]</block
    ></socket
    >)</block
    ></socket
    ></block
    ></socket
    ></block
    >;</document>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Custom colors work')
  start()
