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
    var displayMessage, examplePrograms, isComment, messageElement, onChange, startingText;
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
      descriptive: '//Going by wikipedia examples\n//This works\n1997,Ford,E350\n\n//This works\n"1997","Ford","E350"\n\n//This works\n1997,Ford,E350,"Super, luxurious truck"\n\n//This works partially\n1997,Ford,E350,"Super, ""luxurious"" truck"\n\n//Whitespaces around words aren\'t modifiable\n1997, Ford, E350\nnot same as\n1997,Ford,E350',
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
    document.getElementById('toggle').addEventListener('click', function() {
      editor.toggleBlocks();
      if ($('#palette_dialog').dialog('isOpen')) {
        return $('#palette_dialog').dialog('close');
      } else {
        return $("#palette_dialog").dialog('open');
      }
    });
    isComment = function(str) {
      return str.match(/^\s*\/\/.*$/);
    };
    window.addSocket = function(line) {
      var lines;
      lines = editor.getValue().split('\n');
      if (!isComment(lines[line])) {
        if (lines[line] !== '') {
          lines[line] += '," "';
        } else {
          lines[line] = '" "';
        }
        return editor.setValue(lines.join('\n'));
      }
    };
    return window.removeSocket = function(line) {
      var i, in_quotes, j, lines, ref;
      lines = editor.getValue().split('\n');
      if (!isComment(lines[line])) {
        in_quotes = false;
        for (i = j = ref = lines[line].length - 1; j >= 1; i = j += -1) {
          if (lines[line][i] === '"') {
            in_quotes = !in_quotes;
          } else if (lines[line][i] === ',' && !in_quotes) {
            break;
          }
        }
        lines[line] = lines[line].slice(0, i);
        return editor.setValue(lines.join('\n'));
      }
    };
  });

}).call(this);

//# sourceMappingURL=csv.js.map
