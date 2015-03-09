(function() {
  var readFile;

  readFile = function(name) {
    var q;
    q = new XMLHttpRequest();
    q.open('GET', name, false);
    q.send();
    return q.responseText;
  };

  require.config({
    baseUrl: '../js',
    paths: JSON.parse(readFile('../requirejs-paths.json'))
  });

  require(['droplet'], function(droplet) {
    var displayMessage, examplePrograms, messageElement, onChange, startingText;
    window.editor = new droplet.Editor(document.getElementById('editor'), {
      mode: 'css',
      palette: [
        {
          name: 'Basic',
          color: 'violet',
          blocks: []
        }
      ]
    });
    examplePrograms = {
      descriptive: 'body {\n  background: #eee;\n  color: #888;\n}\n\n.spl {\n  background: #eee;\n  color: #888;\n}\n',
      sample: 'monday,4.0,frank\ntuesday,2.3,sally\nwednesday,1.8,carol',
      empty: ''
    };
    editor.setEditorState(false);
    editor.aceEditor.getSession().setUseWrapMode(true);
    editor.aceEditor.getSession().setMode('ace/mode/css');
    startingText = localStorage.getItem('example');
    editor.setValue(startingText || examplePrograms.descriptive);
    onChange = function() {
      return localStorage.setItem('example', editor.getValue());
    };
    editor.on('change', onChange);
    editor.aceEditor.on('change', onChange);
    onChange();
    document.getElementById('which_example').addEventListener('change', function() {
      return editor.setValue(examplePrograms[this.value]);
    });
    editor.clearUndoStack();
    messageElement = document.getElementById('message');
    displayMessage = function(text) {
      messageElement.style.display = 'inline';
      messageElement.innerText = text;
      return setTimeout((function() {
        return messageElement.style.display = 'none';
      }), 2000);
    };
    return document.getElementById('toggle').addEventListener('click', function() {
      editor.toggleBlocks();
      if ($('#palette_dialog').dialog('isOpen')) {
        return $('#palette_dialog').dialog('close');
      } else {
        return $("#palette_dialog").dialog('open');
      }
    });
  });

}).call(this);

//# sourceMappingURL=css.js.map
