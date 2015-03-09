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
      mode: 'csv',
      palette: [
        {
          name: 'Basic',
          color: 'violet',
          blocks: [
            {
              block: 'v1,v2,v3',
              title: 'Comma Separated Values'
            }, {
              block: '//This is a sample comment.',
              title: 'Comment'
            }
          ]
        }
      ]
    });
    examplePrograms = {
      descriptive: 'monday,4.0,frank\ntuesday,2.3,sally\nwednesday,1.8,carol\n//This is a comment\nspaces,   around    ,a word are automatically stripped, in, block, view\nIf I enter a lot of consequtive ,,,,,,, you can enter values b/w them in block mode\n\n\n^New Lines\n\n//Also, a, comment, with commas, should remain as it is\n      //Space before a comment is not stripped',
      sample: 'monday,4.0,frank\ntuesday,2.3,sally\nwednesday,1.8,carol',
      empty: ''
    };
    editor.setEditorState(false);
    editor.aceEditor.getSession().setUseWrapMode(true);
    editor.aceEditor.getSession().setMode('ace/mode/csv');
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

//# sourceMappingURL=csv.js.map
