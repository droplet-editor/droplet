modes = 
  'javascript':
    mode: 'javascript'
    palette: [
      {
        'name': 'Output'
        'color': 'blue'
        'blocks': [ { 'block': 'console.log("hello");' } ]
      }
      {
        'name': 'Variables'
        'color': 'blue'
        'blocks': [
          { 'block': 'var a = 10;' }
          { 'block': 'a = 10;' }
          { 'block': 'a += 1;' }
          { 'block': 'a -= 10;' }
          { 'block': 'a *= 1;' }
          { 'block': 'a /= 1;' }
        ]
      }
      {
        'name': 'Functions'
        'color': 'purple'
        'blocks': [
          { 'block': 'function myFunction(param) {\n  __\n}' }
          { 'block': 'myFunction(arg);' }
        ]
      }
      {
        'name': 'Logic'
        'color': 'teal'
        'blocks': [
          { 'block': 'a === b' }
          { 'block': 'a !== b' }
          { 'block': 'a > b' }
          { 'block': 'a < b' }
          { 'block': 'a || b' }
          { 'block': 'a && b' }
          { 'block': '!a' }
        ]
      }
      {
        'name': 'Operators'
        'color': 'green'
        'blocks': [
          { 'block': 'a + b' }
          { 'block': 'a - b' }
          { 'block': 'a * b' }
          { 'block': 'a / b' }
          { 'block': 'a % b' }
          { 'block': 'Math.pow(a, b)' }
          { 'block': 'Math.sin(a)' }
          { 'block': 'Math.tan(a)' }
          { 'block': 'Math.cos(a)' }
          { 'block': 'Math.random()' }
        ]
      }
      {
        'name': 'Control flow'
        'color': 'orange'
        'blocks': [
          { 'block': 'for (var i = 0; i < 10; i++) {\n  __\n}' }
          { 'block': 'if (a === b) {\n  __\n}' }
          { 'block': 'if (a === b) {\n  __\n} else {\n  __\n}' }
          { 'block': 'while (true) {\n  __\n}' }
          { 'block': 'function myFunction(param) {\n  __\n}' }
        ]
      }
    ]
  'coffeescript':
    mode: 'coffeescript'
    palette: [
      {
        'name': 'Output'
        'color': 'blue'
        'blocks': [ { 'block': 'console.log "hello"' } ]
      }
      {
        'name': 'Variables'
        'color': 'blue'
        'blocks': [
          { 'block': 'a = 10' }
          { 'block': 'a += 1' }
          { 'block': 'a -= 10' }
          { 'block': 'a *= 1' }
          { 'block': 'a /= 1' }
        ]
      }
      {
        'name': 'Functions'
        'color': 'purple'
        'blocks': [
          { 'block': 'myFunction = (param) ->\n  ``' }
          { 'block': 'myFunction(arg);' }
        ]
      }
      {
        'name': 'Logic'
        'color': 'teal'
        'blocks': [
          { 'block': 'a is b' }
          { 'block': 'a isnt b' }
          { 'block': 'a > b' }
          { 'block': 'a < b' }
          { 'block': 'a || b' }
          { 'block': 'a && b' }
          { 'block': '!a' }
        ]
      }
      {
        'name': 'Operators'
        'color': 'green'
        'blocks': [
          { 'block': 'a + b' }
          { 'block': 'a - b' }
          { 'block': 'a * b' }
          { 'block': 'a / b' }
          { 'block': 'a % b' }
          { 'block': 'a ** b' }
          { 'block': 'Math.sin(a)' }
          { 'block': 'Math.tan(a)' }
          { 'block': 'Math.cos(a)' }
          { 'block': 'Math.random()' }
        ]
      }
      {
        'name': 'Control flow'
        'color': 'orange'
        'blocks': [
          { 'block': 'for el, i in list\n  ``' }
          { 'block': 'if a is b\n  ``' }
          { 'block': 'if a is b\n  ``\nelse\n  ``' }
          { 'block': 'while true\n  ``' }
          { 'block': 'myFunction = (param) ->\n  ``' }
        ]
      }
    ]
  'c_cpp':
    'mode': 'c_cpp'
    'modeOptions': 'knownFunctions':
      'GetString':
        'color': 'green'
        'shape': 'value-only'
      'toupper':
        'color': 'green'
        'shape': 'value-only'
      'strlen':
        'color': 'green'
        'shape': 'value-only'
      'printf':
        'color': 'blue'
        'shape': 'block-only'
      'puts':
        'color': 'blue'
        'shape': 'block-only'
      'scanf':
        'color': 'blue'
        'shape': 'block-only'
      'getchar':
        'color': 'green'
        'shape': 'value-only'
      'fopen':
        'color': 'green'
        'shape': 'value-only'
      'fprintf':
        'color': 'blue'
        'shape': 'block-only'
      'fputs':
        'color': 'blue'
        'shape': 'block-only'
      'fscanf':
        'color': 'blue'
        'shape': 'block-only'
      'fgetc':
        'color': 'green'
        'shape': 'value-only'
      'fillRect':
        'color': 'blue'
        'shape': 'block-only'
    'palette': [
      {
        'name': 'Functions'
        'color': 'blue'
        'blocks': [
          {
            'block': 'printf();'
            'expansion': 'printf("%c", character);'
            'context': 'blockItem'
          }
          {
            'block': 'scanf();'
            'expansion': 'scanf("%c", &character);'
            'context': 'blockItem'
          }
          {
            'block': 'strlen()'
            'expansion': 'strlen(str)'
            'context': 'expression'
          }
          {
            'block': 'getchar()'
            'context': 'expression'
          }
          {
            'block': 'FILE *file;'
            'expansion': 'FILE *file = fopen("file.txt", "r");'
            'context': 'blockItem'
          }
          {
            'block': 'fprintf();'
            'expansion': 'fprintf(file, "%s\\n", "Hello, World!");'
            'context': 'blockItem'
          }
          {
            'block': 'fputs();'
            'expansion': 'fputs(file, "Hello, World!");'
            'context': 'blockItem'
          }
          {
            'block': 'fscanf();'
            'expansion': 'fscanf(file, "%s", str);'
            'context': 'blockItem'
          }
          {
            'block': 'fgetc()'
            'expansion': 'fgetc(file)'
            'context': 'expression'
          }
        ]
      }
      {
        'name': 'Variables'
        'color': 'green'
        'blocks': [
          {
            'block': 'int n = 0;'
            'context': 'blockItem'
          }
          {
            'block': 'double f = 0;'
            'context': 'blockItem'
          }
          {
            'block': 'string str = 0;'
            'context': 'blockItem'
          }
          {
            'block': 'a = 0;'
            'context': 'blockItem'
          }
          {
            'block': 'type a = 0;'
            'context': 'blockItem'
          }
          {
            'block': 'type a;'
            'context': 'blockItem'
          }
          {
            'block': 'type a (arg1);'
            'context': 'blockItem'
          }
          {
            'block': 'a + b'
            'context': 'expression'
          }
          {
            'block': 'a - b'
            'context': 'expression'
          }
          {
            'block': 'a * b'
            'context': 'expression'
          }
          {
            'block': 'a / b'
            'context': 'expression'
          }
          {
            'block': 'a % b'
            'context': 'expression'
          }
          {
            'block': 'a[b]'
            'context': 'expression'
          }
        ]
      }
      {
        'name': 'Logic'
        'color': 'blue'
        'blocks': [
          {
            'block': 'a > b'
            'context': 'expression'
          }
          {
            'block': 'a < b'
            'context': 'expression'
          }
          {
            'block': 'a == b'
            'context': 'expression'
          }
          {
            'block': 'a != b'
            'context': 'expression'
          }
          {
            'block': '!a'
            'context': 'expression'
          }
          {
            'block': 'a && b'
            'context': 'expression'
          }
          {
            'block': 'a || b'
            'context': 'expression'
          }
        ]
      }
      {
        'name': 'Control'
        'color': 'purple'
        'blocks': [
          {
            'block': 'if (a == b)\n{\n  puts("Equal");\n}'
            'context': 'blockItem'
          }
          {
            'block': 'if (a == b)\n{\n  puts("Equal");\n} else {\n  puts("Not equal");\n}'
            'context': 'blockItem'
          }
          {
            'block': 'while (i < 10)\n{\n  i++;\n}'
            'context': 'blockItem'
          }
          {
            'block': 'for (int i = 0; i < n; i++)\n{\n  printf("%d\\n", i);\n}'
            'context': 'blockItem'
          }
        ]
      }
      {
        'name': 'Structure'
        'color': 'orange'
        'blocks': [
          {
            'block': '#include <cs50.h>'
            'context': 'compilationUnit'
          }
          {
            'block': '#include "myFile.h"'
            'context': 'compilationUnit'
          }
          {
            'block': '#define MY_CONSTANT 10'
            'context': 'compilationUnit'
          }
          {
            'block': 'int main(int n, char *args[])\n{\n  puts("Hello");\n}'
            'context': 'externalDeclaration'
          }
          {
            'block': 'type function(myType param)\n{\n  return 0;\n}'
            'context': 'externalDeclaration'
          }
          {
            'block': 'struct myStruct\n{\n  int property1;\n  int property2;\n};'
            'context': 'externalDeclaration'
          }
          {
            'block': 'myType myStructProperty;'
            'context': 'structDeclaration'
          }
          {
            'block': 'myType globalVariable = 0;'
            'context': 'externalDeclaration'
          }
          {
            'block': 'typedef type1 type2;'
            'context': 'externalDeclaration'
          }
        ]
      }
      {
        'name': 'Memory'
        'color': 'red'
        'blocks': [
          {
            'block': 'myType *a = malloc(sizeof(myType));'
            'context': 'blockItem'
          }
          {
            'block': 'myType *a = malloc(sizeof(myType) * length);'
            'context': 'blockItem'
          }
          {
            'block': 'myType a[length];'
            'context': 'blockItem'
          }
          {
            'block': '*a'
            'context': 'expression'
          }
          {
            'block': 'a[0]'
            'context': 'expression'
          }
          {
            'block': 'a.property'
            'context': 'expression'
          }
        ]
      }
    ]
sessions = {}
editor = new (droplet.Editor)(document.getElementById('editor'), modes['javascript'])
document.getElementById('toggle').addEventListener 'click', ->
  editor.toggleBlocks()
  return
document.getElementById('language-select').addEventListener 'change', ->
  if @value of sessions
    editor.aceEditor.setSession sessions[@value]
  else
    newSession = sessions[@value] = ace.createEditSession('', 'ace/mode/' + @value)
    editor.aceEditor.setSession newSession
    editor.bindNewSession modes[@value]
  return
