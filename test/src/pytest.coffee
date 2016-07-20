helper = require '../../src/helper.coffee'
Python = require '../../src/languages/python.coffee'

asyncTest 'Python basic parsing', ->
  customPy = new Python({
    functions: {
      'print': {
        value: true
      }
    }
  })

  customSerialization = customPy.parse(
    '''
    print 'hello'
    '''
  ).serialize()

  expectedSerialization = '''
    <document><block
    precedence="0"
    color="command"
    socketLevel="0"
    classes="__parse__small_stmt __parse__print_stmt any-drop">print <socket
    precedence="0"
    handwritten="false"
    classes="__parse__test __parse__or_test __parse__and_test __parse__not_test __parse__comparison __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power __parse__atom __parse__T_STRING">&apos;hello&apos;</socket></block></document>'''

  strictEqual(
    helper.xmlPrettyPrint(customSerialization),
    helper.xmlPrettyPrint(expectedSerialization),
    'Dotted known functions work'
  )

  start()

asyncTest 'Py indent', ->
  customPy = new Python({
    functions: {}
  })
  code = 'for i in range(0, 10):\n continue'
  customSerialization = customPy.parse('for i in range(0, 10):\n continue')
  stringifiedPy = customSerialization.stringify()
  strictEqual(code, stringifiedPy)
  start()

asyncTest 'Py for loop', ->
  customPy = new Python({
    functions: {}
  })

  customSerialization = customPy.parse('for i in range(0, 10):\n continue').serialize()

  expectedSerialization = '''<document><block
precedence="0"
color="control"
socketLevel="0"
classes="__parse__stmt \__parse__compound_stmt __parse__for_stmt any-drop">for <socket
precedence="0"
handwritten="false"
classes="__parse__exprlist __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power __parse__atom __parse__T_NAME">i</socket> in <socket
precedence="0"
handwritten="false"
classes="__parse__testlist __parse__test __parse__or_test __parse__and_test __parse__not_test __parse__comparison __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power"><block
precedence="0"
color="value"
socketLevel="0"
classes="__parse__testlist __parse__test __parse__or_test __parse__and_test __parse__not_test __parse__comparison __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power any-drop">range(<socket
precedence="0"
handwritten="false"
classes="__parse__argument __parse__test __parse__or_test __parse__and_test __parse__not_test __parse__comparison __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power __parse__atom __parse__T_NUMBER">0</socket>, <socket
precedence="0"
handwritten="false"
classes="__parse__argument __parse__test __parse__or_test __parse__and_test __parse__not_test __parse__comparison __parse__expr __parse__xor_expr __parse__and_expr __parse__shift_expr __parse__arith_expr __parse__term __parse__factor __parse__power __parse__atom __parse__T_NUMBER">10</socket>)</block></socket>:<indent
prefix=" "
classes="__parse__suite">
<block
precedence="0"
color="comment"
socketLevel="0"
classes="__handwritten\__ block-only"><socket
precedence="0"
handwritten="true"
classes="">continue</socket></block></indent></block></document>'''

  strictEqual(
    helper.xmlPrettyPrint(customSerialization),
    helper.xmlPrettyPrint(expectedSerialization)
  )
  start()


