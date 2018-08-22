var editor, options;

initEditor = function(settings, code)
{
    console.log("Settings: " + JSON.stringify(eval(settings)));
    console.log("Code: " + code);
    editor = createEditor(eval(settings));
    editor.setValue(code);
}

createEditor = function(options)
{
  window.options = options;
  editor = new droplet.Editor(document.getElementById('droplet-editor'), options);
  editor.on('change', function()
  {
    return sessionStorage.setItem('code', editor.getValue());
  });
  return window.editor = editor;
}

// Default
java =
{
  'mode': 'java',
  'palette':
  [
    {
      'name': 'General',
      'color': 'blue',
      'blocks': [
        {
          'block': 'import java.io.*;',
          'context': 'compilationUnit'
        },
        {
          'block': 'import java.util.Scanner;',
          'context': 'compilationUnit'
        },
        {
          'block': 'public class Main\n{\npublic static void main(String[] args)\n{\n\t\n}\n}',
          'context': 'typeDeclaration'
        },
        {
          'block': 'int x = 0;',
          'context': 'blockStatement'
        },
        {
          'block': 'int x;',
          'context': 'blockStatement'
        },
        {
          'block': 'x = 1;',
          'context': 'blockStatement'
        },
      ]
    },
    {
      'name': 'Classes',
      'color': 'purple',
      'blocks':
      [
        {
          'block': 'public class ClassName\n{\n\t\n}',
          'context': 'typeDeclaration'
        },
        {
          'block': 'public static int methodName(int param1)\n{\n\t\n}',
          'context': 'classBodyDeclaration'
        },
        {
          'block': 'public int methodName(int param1)\n{\n\t\n}',
          'context': 'classBodyDeclaration'
        },
        {
          'block': 'public static int i = 0;',
          'context': 'classBodyDeclaration'
        },
        {
          'block': 'public int i = 0;',
          'context': 'classBodyDeclaration'
        },
        {
          'block': 'ClassName.methodName(param1);',
          'context': 'statement'
        }
      ]
    },
    {
      'name': 'Selection (If)',
      'color': 'orange',
      'blocks':
      [
        {
          'block': 'if (x == y)\n{\n\t\n}',
          'context': 'statement'
        },
        {
          'block': 'if (x == y)\n{\n\t\n}\nelse\n{\n\t\n}',
          'context': 'statement'
        },
        {
          'block': 'if (x == y)\n{\n\t\n}\nelse if (x > y)\n{\n\t\n}\nelse\n{\n\t\n}',
          'context': 'statement'
        },
//        {
//          'block': 'switch(i) {\ncase 0:\nbreak;\ndefault:\nbreak;\n}',
//          'context': 'statement'
//        },
      ]
    },
    {
      'name': 'Loops',
      'color': 'deeporange',
      'blocks':
      [
        {
          'block': 'for(int i = 0; i < x; i++)\n{\n\t\n}',
          'context': 'statement'
        },
        {
          'block': 'for(int i : containerVariable)\n{\n\t\n}',
          'context': 'statement'
        },
        {
          'block': 'while(0 == 0)\n{\n\t\n}',
          'context': 'statement'
        },
        {
          'block': 'do\t\t\t\n{\n}\nwhile(0 == 0);',
          'context': 'statement'
        },
        {
          'block': 'break;',
          'context': 'statement'
        },
        {
          'block': 'continue;',
          'context': 'statement'
        },
      ]
    },
    {
      'name': 'Logic',
      'color': 'cyan',
      'blocks':
      [
        {
          'block' : '(x == y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x != y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x < y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x <= y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x > y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x >= y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x && y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(x || y)',
          'context' : 'parExpression'
        },
        {
          'block' : '(!x)',
          'context' : 'parExpression'
        },
      ]
    },
    {
      'name': 'Arithmetic',
      'color': 'green',
      'blocks':
      [
        {
          'block' : '(x)',
          'context' : 'parExpression'
        },
        {
          'block' : 'x + y',
          'context' : 'expression'
        },
        {
          'block' : 'x - y',
          'context' : 'expression'
        },
        {
          'block' : 'x * y',
          'context' : 'expression'
        },
        {
          'block' : 'x / y',
          'context' : 'expression'
        },
        {
          'block' : 'x % y',
          'context' : 'expression'
        },
        {
          'block' : 'x++',
          'context' : 'expression'
        },
        {
          'block' : 'x--',
          'context' : 'expression'
        },
        {
          'block' : '++x',
          'context' : 'expression'
        },
        {
          'block' : '--x',
          'context' : 'expression'
        },
        {
          'block': 'x > y ? x : y',
          'context': 'expression'
        },
        {
          'block' : 'x += 1;',
          'context' : 'statement'
        },
        {
          'block' : 'x -= 1;',
          'context' : 'statement'
        },
        {
          'block' : 'x *= 1;',
          'context' : 'statement'
        },
        {
          'block' : 'x /= 1;',
          'context' : 'statement'
        },
        {
          'block' : 'x %= 1;',
          'context' : 'statement'
        },
      ]
    }
  ]
};

initEditor( { 'mode': 'java', 'palette': [] }, "");
