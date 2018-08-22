var editor, sessions, java;

sessions = {};

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
          'id': 'import_group',
          'block': 'import java.io.*;',
          'context': 'compilationUnit'
        },
        {
          'id': 'import_item',
          'block': 'import java.util.Scanner;',
          'context': 'compilationUnit'
        },
        {
          'id': 'class_and_main',
          'block': 'public class Main\n{\n    public static void main(String[] args)\n    {\n        \n    }\n}',
          'context': 'typeDeclaration'
        },
        {
          'id': 'declare_assign',
          'block': 'int x = 0;',
          'context': 'blockStatement'
        },
        {
          'id': 'declaration',
          'block': 'int x;',
          'context': 'blockStatement'
        },
        {
          'id': 'assignment',
          'block': 'x = 1;',
          'context': 'blockStatement'
        },
        {
          'id': 'comment',
          'block': '//Comment\n',
        },
      ]
    },
    {
      'name': 'Classes',
      'color': 'purple',
      'blocks':
      [
        {
          'id': 'class_declaration',
          'block': 'public class ClassName\n{\n    \n}',
          'context': 'typeDeclaration'
        },
        {
          'id': 'static_method',
          'block': 'public static int methodName(int param1)\n{\n    \n}',
          'context': 'classBodyDeclaration'
        },
        {
          'id': 'instance_method',
          'block': 'public int methodName(int param1)\n{\n    \n}',
          'context': 'classBodyDeclaration'
        },
        {
          'id': 'static_variable',
          'block': 'public static int i = 0;',
          'context': 'classBodyDeclaration'
        },
        {
          'id': 'instance_variable',
          'block': 'public int i = 0;',
          'context': 'classBodyDeclaration'
        },
        {
          'id': 'method_invocation',
          'block': 'ClassName.methodName(param1);',
          'context': 'statement'
        }
      ]
    },
    {
      'name': 'Selection',
      'color': 'orange',
      'blocks':
      [
        {
          'id': 'if',
          'block': 'if (x == y)\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'if_else',
          'block': 'if (x == y)\n{\n    \n}\nelse\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'if_elseif_else',
          'block': 'if (x == y)\n{\n    \n}\nelse if (x > y)\n{\n    \n}\nelse\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'switch',
          'block': 'switch (x)\n{\n    case 0:\n    break;\n    default:\n    break;\n}',
          'context': 'statement'
        },
      ]
    },
    {
      'name': 'Loops',
      'color': 'deeporange',
      'blocks':
      [
        {
          'id': 'for',
          'block': 'for(int i = 0; i < x; i++)\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'for_each',
          'block': 'for(int i : containerVariable)\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'while',
          'block': 'while(0 == 0)\n{\n    \n}',
          'context': 'statement'
        },
        {
          'id': 'do_while',
          'block': 'do        \n{\n    \n}\nwhile(0 == 0);',
          'context': 'statement'
        },
        {
          'id': 'break',
          'block': 'break;',
          'context': 'statement'
        },
        {
          'id': 'continue',
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
          'id': 'equal',
          'block' : '(x == y)',
          'context' : 'parExpression'
        },
        {
          'id': 'not_equal',
          'block' : '(x != y)',
          'context' : 'parExpression'
        },
        {
          'id': 'less_than',
          'block' : '(x < y)',
          'context' : 'parExpression'
        },
        {
          'id': 'less_or_equal',
          'block' : '(x <= y)',
          'context' : 'parExpression'
        },
        {
          'id': 'greater_than',
          'block' : '(x > y)',
          'context' : 'parExpression'
        },
        {
          'id': 'greater_or_equal',
          'block' : '(x >= y)',
          'context' : 'parExpression'
        },
        {
          'id': 'and',
          'block' : '(x && y)',
          'context' : 'parExpression'
        },
        {
          'id': 'or',
          'block' : '(x || y)',
          'context' : 'parExpression'
        },
        {
          'id': 'not',
          'block' : '(!x)',
          'context' : 'parExpression'
        },
      ]
    },
    {
      'name': 'Arithmetic',
      'color': 'teal',
      'blocks':
      [
        {
          'id': 'parens',
          'block' : '(x)',
          'context' : 'parExpression'
        },
        {
          'id': 'addition',
          'block' : '(x + y)',
          'context' : 'expression'
        },
        {
          'id': 'subtraction',
          'block' : '(x - y)',
          'context' : 'expression'
        },
        {
          'id': 'mutiply',
          'block' : '(x * y)',
          'context' : 'expression'
        },
        {
          'id': 'divide',
          'block' : '(x / y)',
          'context' : 'expression'
        },
        {
          'id': 'modulo',
          'block' : '(x % y)',
          'context' : 'expression'
        },
        {
          'id': 'post_increment',
          'block' : '(x++)',
          'context' : 'expression'
        },
        {
          'id': 'post_decrement',
          'block' : '(x--)',
          'context' : 'expression'
        },
        {
          'id': 'pre_increment',
          'block' : '(++x)',
          'context' : 'expression'
        },
        {
          'id': 'pre_decrement',
          'block' : '(--x)',
          'context' : 'expression'
        },
        {
          'id': 'ternary',
          'block': '(x > y ? x : y)',
          'context': 'expression'
        },
        {
          'id': 'plus_eq',
          'block' : 'x += 1;',
          'context' : 'statement'
        },
        {
          'id': 'minus_eq',
          'block' : 'x -= 1;',
          'context' : 'statement'
        },
        {
          'id': 'mult_eq',
          'block' : 'x *= 1;',
          'context' : 'statement'
        },
        {
          'id': 'div_eq',
          'block' : 'x /= 1;',
          'context' : 'statement'
        },
        {
          'id': 'mod_eq',
          'block' : 'x %= 1;',
          'context' : 'statement'
        },
      ]
    }
  ],
//  modeOptions:
//  {
//    functions:
//    {

//    },
//  }
};

editor = new droplet.Editor(document.getElementById('editor'), java);

document.getElementById('toggle').addEventListener('click', function() {
  editor.toggleBlocks();
});

