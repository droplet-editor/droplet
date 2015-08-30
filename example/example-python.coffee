# Droplet config editor
config = {
  "mode": "python",
  "palette": [
        {
            'name': 'Input/output',
            'color': 'blue',
            'blocks': [
                {
                    'block': "print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "input('Enter a number')",
                    'context': 'expr'
                },
                {
                    'block': "raw_input('Enter a string')",
                    'context': 'expr'
                }
            ]
        },
        {
            'name': 'Control flow',
            'color': 'control',
            'blocks': [
                {
                    'block': "for i in range(0, 10):\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "if a == b:\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "while a < b:\n  print 'hello'",
                    'context': 'stmt'
                }
            ]
        },
        {
            'name': 'Methods',
            'color': 'control',
            'blocks': [
                {
                    'block': "def myMethod(arg):\n  print 'hello'",
                    'context': 'stmt'
                },
                {
                    'block': "return 'hello'",
                    'context': 'stmt'
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
