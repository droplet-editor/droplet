# Droplet config editor
expressionContext = {
  prefix: 'a = '
}
config = {
  "mode": "python",
  "palette": [
        {
            'name': 'Input/output',
            'color': 'blue',
            'blocks': [
                {
                    'block': "print 'hello'",
                },
                {
                    'block': "input('Enter a number')",
                    'wrapperContext': expressionContext
                },
                {
                    'block': "raw_input('Enter a string')",
                    'wrapperContext': expressionContext
                }
            ]
        },
        {
            'name': 'Control flow',
            'color': 'control',
            'blocks': [
                {
                    'block': "for i in range(0, 10):\n  print 'hello'",
                },
                {
                    'block': "if a == b:\n  print 'hello'",
                },
                {
                    'block': "while a < b:\n  print 'hello'",
                }
            ]
        },
        {
            'name': 'Methods',
            'color': 'purple',
            'blocks': [
                {
                    'block': 'import module'
                },
                {
                    'block': 'from module import something'
                },
                {
                    'block': "def myMethod(arg):\n  print 'hello'",
                },
                {
                    'block': "return 'hello'",
                },
                {
                    'block': "myMethod(arg)",
                    'wrapperContext': expressionContext
                },
            ]
        },
        {
            'name': 'Variables',
            'color': 'red',
            'blocks': [
                {
                    'block': 'a = 1'
                }
            ]
        },
        {
            'name': 'Math'
            'color': 'red',
            'blocks': [
                {
                    'block': 'a + b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a - b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a * b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a / b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a % b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a ** b'
                    'wrapperContext': expressionContext
                }
            ]
        }
        {
          'name': 'Logic'
          'color': 'teal'
          'blocks': [
                {
                    'block': 'a == b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a < b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a > b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a and b'
                    'wrapperContext': expressionContext
                },
                {
                    'block': 'a or b'
                    'wrapperContext': expressionContext
                }
            ]
        }
  ]
}

$('#droplet-editor').html ''
editor = new droplet.Editor $('#droplet-editor')[0], config

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')
