# Droplet config editor
config = {
  mode: "c"
  palette: [
    {
      name: 'Input/output',
      color: 'blue'
      blocks: [
        {
          'block': 'puts("Hello!");'
          'context': 'statement'
        },
        {
          'block': 'printf("1 + 2 = %d", 2);'
          'context': 'statement'
        },
        {
          'block': 'scanf("%s", &s);'
          'context': 'statement'
        },
        {
          'block': 'scanf("%d", &d);'
          'context': 'statement'
        }
      ]
    },
    {
      name: 'Control flow',
      color: 'control'
      blocks: [
        {
          'block': 'if (a == b) {\n  \n}'
          'context': 'statement'
        },
        {
          'block': 'for (int i = 0; i < 10; i++) {\n  \n}'
          'context': 'statement'
        },
        {
          'block': 'while (a < b) {\n  \n}'
          'context': 'statement'
        }
      ]
    },
    {
      name: 'Methods',
      color: 'purple'
      blocks: [
        {
          'block': 'int main(int n, char* args[]) {\n  \n}'
          'context': 'compilationUnit'
        },
        {
          'block': 'int myMethod(int arg) {\n  \n}'
          'context': 'compilationUnit'
        },
        {
          'block': 'myMethod(arg)'
          'context': 'expression'
        }
        {
          'block': 'return 0;'
          'context': 'statement'
        }
      ]
    },
    {
      name: 'Variables',
      color: 'red'
      blocks: [
        {
          'block': 'int a = 0;'
          'context': 'statement'
        }
        {
          'block': 'a = 0;'
          'context': 'statement'
        }
      ]
    },
    {
      name: 'Math',
      color: 'green'
      blocks: [
        {
          'block': 'a + b'
          'context': 'expression'
        },
        {
          'block': 'a - b'
          'context': 'expression'
        },
        {
          'block': 'a * b'
          'context': 'expression'
        },
        {
          'block': 'a / b'
          'context': 'expression'
        },
        {
          'block': 'a > b'
          'context': 'expression'
        },
        {
          'block': 'a < b'
          'context': 'expression'
        },
        {
          'block': 'a == b'
          'context': 'expression'
        }
      ]
    },
    {
      name: 'Pointers'
      color: 'yellow'
      blocks: [
        {
          'block': '&a'
          'context': 'expression'
        },
        {
          'block': '*a'
          'context': 'expression'
        }
        {
          'block': 'malloc(sizeof(char))'
          'context': 'expression'
        }
        {
          'block': 'free(&a)'
          'context': 'statement'
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
