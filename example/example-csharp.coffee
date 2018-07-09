csharp =
  'mode': 'csharp'
  'palette': [
    {
      'name': 'Templates'
      'color': 'blue'
      'blocks': [
        {
          'block': 'using System;'
          'context': 'using_directives'
        }
        {
          'block': 'using System.IO;'
          'context': 'using_directives'
        }
        {
          'block': 'namespace namespaceName {\n\t\n}'
          'context': 'namespace_declaration'
        }
        {
          'block': 'int i = 0;'
          'context': 'common_member_declaration'
        }
        {
          'block': 'public static void main();'
          'expansion': 'public static void main(string[] args) {\n\t\n}'
          'context': 'class_member_declaration'
        }
        {
          'block': 'for(int i = 0; i < x; i++);'
          'expansion': 'for(int i = 0; i < x; i++) {\n\t\n}'
          'context': 'simple_embedded_statement'
        }
        {
          'block': 'if (x == y) {\n\t\n}'
          'context': 'simple_embedded_statement'
        }
      ]
    }
    {
      'name': 'Classes'
      'color': 'purple'
      'blocks': [
        {
          'block': 'public class className {\n\t\n}'
          'context': 'type_declaration'
        }
        {
          'block': 'int methodName(int param1) {\n\t\n}'
          'context': 'common_member_declaration'
        }
        {
          'block': 'className.methodName(param1);'
          'context': 'simple_embedded_statement'
        }
      ]
    }
    {
      'name': 'Logic'
      'color': 'orange'
      'blocks': [
        {
          'block' : 'x < y'
          'context' : 'expression'
        }
        {
          'block' : 'x <= y'
          'context' : 'expression'
        }
        {
          'block' : 'x > y'
          'context' : 'expression'
        }
        {
          'block' : 'x >= y'
          'context' : 'expression'
        }
        {
          'block' : 'x == y'
          'context' : 'expression'
        }
        {
          'block' : 'x++'
          'context' : 'expression'
        }
        {
          'block' : 'x--'
          'context' : 'expression'
        }
      ]
    }
  ]
sessions = {}
editor = new (droplet.Editor)(document.getElementById('editor'), csharp)
document.getElementById('toggle').addEventListener 'click', ->
  editor.toggleBlocks()
  return
