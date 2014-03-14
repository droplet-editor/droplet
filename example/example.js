(function() {
  require.config({
    urlArgs: "bust=" + (new Date()).getTime()
  });

  require(['main'], function(ice) {
    var closeLogsElement, displayMessage, logsContentElement, logsElement, messageElement, paletteElement;
    window.editor = new ice.Editor(document.getElementById('editor'), (function() {
      var _i, _len, _ref, _results;
      _ref = ['fd 100', 'bk 100', 'rt 90', 'lt 90', 'see \'hi\'', 'for i in [1..10]\n  fd 10', 'if touches \'red\'\n  fd 10', 'rtFd = (arg) ->\n  rt 90\n  fd arg\n  return arg'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        paletteElement = _ref[_i];
        _results.push(ice.parse(paletteElement).next.block);
      }
      return _results;
    })());
    editor.setValue('for i in [1..1000]\n  if i % 15 is 0\n    see \'fizzbuzz\'\n  else\n    if i % 5 is 0\n      see \'fizz\'\n    if i % 3 is 0\n      see \'buzz\'\n    if i % 3 isnt 0 and i % 5 isnt 0\n      see i');
    editor.onChange = function() {};
    editor.onChange();
    document.getElementById('undo').addEventListener('click', function() {
      return editor.undo();
    });
    messageElement = document.getElementById('message');
    displayMessage = function(text) {
      messageElement.style.display = 'inline';
      messageElement.innerText = text;
      return setTimeout((function() {
        return messageElement.style.display = 'none';
      }), 2000);
    };
    document.getElementById('toggle').addEventListener('click', function() {
      if (!editor.toggleBlocks()) {
        if (!(editor.currentlyUsingBlocks || editor.currentlyAnimating)) {
          return displayMessage('Syntax error');
        }
      }
    });
    logsElement = document.getElementById('logs');
    logsContentElement = document.getElementById('logsContent');
    closeLogsElement = document.getElementById('closeLogs');
    document.getElementById('run').addEventListener('click', function() {
      var logs, see;
      logs = [];
      see = function(arg) {
        return logs.push(arg);
      };
      eval(CoffeeScript.compile(editor.getValue()));
      see = null;
      logsContentElement.innerText = logs.join('\n');
      logsElement.style.right = '0px';
      return closeLogsElement.style.top = '30px';
    });
    return document.getElementById('closeLogs').addEventListener('click', function() {
      logsElement.style.right = '-500px';
      return closeLogsElement.style.top = '0px';
    });
  });

}).call(this);

/*
//@ sourceMappingURL=example.js.map
*/