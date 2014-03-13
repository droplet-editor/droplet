(function() {
  require(['main'], function(ice) {
    var paletteElement;
    window.editor = new ice.Editor(document.getElementById('editor'), (function() {
      var _i, _len, _ref, _results;
      _ref = ['fd 100', 'bk 100', 'rt 90', 'lt 90', 'for i in [1..10]\n  fd 10', 'if touches \'red\'\n  fd 10', 'rtFd = (arg) ->\n  rt 90\n  fd arg\n  return arg'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        paletteElement = _ref[_i];
        _results.push(ice.parse(paletteElement).next.block);
      }
      return _results;
    })());
    editor.setValue('for i in [1..1000]\n  if i % 15 is 0\n    console.log \'fizzbuzz\'\n  else\n    if i % 5 is 0\n      console.log \'fizz\'\n    if i % 3 is 0\n      console.log \'buzz\'\n    if i % 3 isnt 0 and i % 5 isnt 0\n      console.log i');
    editor.onChange = function() {
      return document.getElementById('out').value = editor.getValue();
    };
    editor.onChange();
    document.getElementById('out').addEventListener('input', function() {
      try {
        return editor.setValue(this.value);
      } catch (_error) {}
    });
    document.getElementById('undo').addEventListener('click', function() {
      return editor.undo();
    });
    document.getElementById('melt').addEventListener('click', function() {
      return editor.performMeltAnimation();
    });
    return document.getElementById('freeze').addEventListener('click', function() {
      return editor.performFreezeAnimation();
    });
  });

}).call(this);

/*
//@ sourceMappingURL=example.js.map
*/