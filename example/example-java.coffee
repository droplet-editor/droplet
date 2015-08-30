# Droplet config editor
config = ({
  "mode": "java",
  "palette": [
      {
        'name': 'Input/output',
        'color': 'command',
        'blocks': [
            {
                'block': 'System.out.println(10);',
                'context': 'statement'
            },
            {
                'block': 'Scanner s = new Scanner();',
                'context': 'statement'
            },
            {
                'block': 's.nextInt();',
                'context': 'expression'
            },
            {
                'block': 's.next();',
                'context': 'expression'
            }
         ]
      },
      {
        'name': 'Control flow',
        'color': 'yellow',
        'blocks': [
            {
              'block': 'if (a == b) {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'if (a == b) {\n  \n} else {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'while (a < b) {\n  \n} else {\n  \n}',
              'context': 'statement'
            },
            {
              'block': 'for(int i = 0; i < 10; i++) {\n  \n}',
              'context': 'statement'
            }
        ]
      },
      {
        'name': 'Variables',
        'color': 'purple',
        'blocks': [
            {
              'block': 'int a;',
              'context': 'statement'
            },
            {
              'block': 'a = 0;',
              'context': 'statement'
            }
        ]
      },
      {
        'name': 'Methods',
        'color': 'red',
        'blocks': [
            {
                'block': 'public int myMethod(int arg) {\n  \n}',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'private int myMethod(int arg) {\n  \n}',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'return 0;',
                'context': 'statement'
            },
            {
                'block': 'myMethod(arg)',
                'context': 'expression'
            }
        ]
      },
      {
        'name': 'Math',
        'color': 'green',
        'blocks': [
            {
              'block': 'a + b',
              'context': 'expression'
            },
            {
              'block': 'a - b',
              'context': 'expression'
            },
            {
              'block': 'a * b',
              'context': 'expression'
            },
            {
              'block': 'a / b',
              'context': 'expression'
            },
            {
              'block': 'a == b',
              'context': 'expression'
            },
            {
              'block': 'a < b',
              'context': 'expression'
            },
            {
              'block': 'a > b',
              'context': 'expression'
            },
            {
              'block': 'Math.pow(a, b)',
              'context': 'expression'
            }
        ]
      },
      {
        'name': 'Classes',
        'color': 'control',
        'blocks': [
            {
                'block': 'class Example {\n  \n}',
                'context': 'compilationUnit'
            },
            {
                'block': 'class Example extends Blank {\n  \n}',
                'context': 'compilationUnit'
            },
            {
                'block': 'public int x;',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'private int x;',
                'context': 'classBodyDeclaration'
            },
            {
                'block': 'public static void main(String[] args) {\n  \n}',
                'context': 'classBodyDeclaration'
            }
         ]
      }
  ]
})

$('#droplet-editor').html ''
editor = new droplet.Editor $('#droplet-editor')[0], config

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')
