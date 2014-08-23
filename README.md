Melt Editor
=================

Melt editor seeks to re-envision "block programming" as "text editing". It is useful as a transitional tool for beginners using languages like Scratch, and is a go-to text editor for everyone on mobile devices (where keyboards are sucky).

Examples
--------
To embed, call new melt.Editor() on a div.

```html
<html>
<head>
<style>
#editor {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
}
</style>
</head>
<div id="editor">
</div>
</html>
```

```coffeescript
require ['melt'], (melt) ->
  editor = new melt.Editor document.getElementById('editor'), [
     {
        block: "for [1..3]\n  ``"
        title: "Repeat some code"
     }
  ]
  
  editor.setValue '''
  for i in [1..10]
    document.write 'hello world'
  '''
```
