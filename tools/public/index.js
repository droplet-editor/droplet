var editor = new droplet.Editor(document.querySelector('#editor'), {
  'mode': 'c',
  'palette': [],
  'enablePaletteAtStart': false
});

editor.setReadOnly(true);

document.querySelector('#next').addEventListener('click', function() {
  var q = new XMLHttpRequest();
  q.open('GET', '/getcode', false);
  q.send();
  document.querySelector('pre').innerText = q.responseText;
  editor.setValue(q.responseText);
  editor.setEditorState(true);
});
