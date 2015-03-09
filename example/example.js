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

      /*
      mode: 'javascript'
      palette: [
        {
          name: 'Draw'
          color: 'blue'
          blocks: [
            {block:'pen(red);', title: 'Set the pen color'}
            {block:'fd(100);', title: 'Move forward'}
            {block:'rt(90);', title: 'Turn right'}
            {block:'lt(90);', title: 'Turn left'}
            {block:'bk(100);', title: 'Move backward'}
            {block:'dot(blue, 50);', title: 'Make a dot'}
            {block:'box(green, 50);', title: 'Make a square'}
            {block:'speed(10);', title: 'Set the speed of the turtle'}
            {block:'label(\'hello\');', title: 'Write text at the turtle'}
            {block:'ht();', title:'Hide the turtle'}
            {block:'st();', title:'Show the turtle'}
            {block:'pu();', title:'Pick the pen up'}
            {block:'pd();', title:'Put the pen down'}
            {block:'pen(purple, 10);', title:'Set the pen color and thickness'}
            {block:'rt(180, 100);', title:'Make a wide right turn'}
            {block:'lt(180, 100);', title:'Make a wide left turn'}
            {block:'slide(100, 20);', title:'Slide sideways or diagonally'}
            {block:'jump(100, 20);', title:'Jump without drawing'}
            {block:'play(\'GEC\');', title:'Play music notes'}
            {block:'wear(\'/img/cat-icon\');', title:'Change the turtle image'}
          ]
        }
        {
          name: 'Control'
          color: 'orange'
          blocks: [
            {block: '''
            for (var i = 0; i < 4; i++) {
              __;
            }
            ''', title: 'Do something multiple times'}
            {block: '''
            if (__) {
              __;
            }
            ''', title: 'Do something only if a condition is true'}
            {block: '''
            if (__) {
              __;
            } else {
              __;
            }
            ''', title: 'Do something if a condition is true, otherwise do something else'}
            {block: '''
            while (__) {
              __;
            }
            ''', title: 'Repeat something while a condition is true'}
          ]
        }
        {
          name: 'Math'
          color: 'green'
          blocks: [
            {block: 'var x = __;', title: 'Create a variable for the first time'}
            {block: 'x = __;', title: 'Reassign a variable'}
            {block: '__ + __', title: 'Add two numbers'}
            {block: '__ - __', title: 'Subtract two numbers'}
            {block: '__ * __', title: 'Multiply two numbers'}
            {block: '__ / __', title: 'Divide two numbers'}
            {block: '__ === __', title: 'Compare two numbers'}
            {block: '__ > __', title: 'Compare two numbers'}
            {block: '__ < __', title: 'Compare two numbers'}
            {block: 'random(1, 100)', title: 'Get a random number in a range'}
            {block: 'round(__)', title: 'Round to the nearest integer'}
            {block: 'abs(__)', title: 'Absolute value'}
            {block: 'max(__, __)', title: 'Absolute value'}
            {block: 'min(__, __)', title: 'Absolute value'}
          ]
        }
        {
          name: 'Functions'
          color: 'violet'
          blocks: [
            {block:'''
            function myFunction() {
              __;
            }
            ''', title: 'Create a function without an argument'}
            {block:'''
            function myFunction(n) {
              __;
            }
            ''', title: 'Create a function with an argument'}
            {block: '''
            myFunction()
            ''', title: 'Use a function without an argument'}
            {block: '''
            myFunction(n)
            ''', title: 'Use a function with argument'}
          ]
        }
      ]
       */
      mode: 'coffeescript',
      palette: [
        {
          name: 'Draw',
          color: 'blue',
          blocks: [
            {
              block: 'pen red',
              title: 'Set the pen color'
            }, {
              block: 'fd 100',
              title: 'Move forward'
            }, {
              block: 'rt 90',
              title: 'Turn right'
            }, {
              block: 'lt 90',
              title: 'Turn left'
            }, {
              block: 'bk 100',
              title: 'Move backward'
            }, {
              block: 'dot blue, 50',
              title: 'Make a dot'
            }, {
              block: 'box green, 50',
              title: 'Make a square'
            }, {
              block: 'speed 10',
              title: 'Set the speed of the turtle'
            }, {
              block: 'label \'hello\'',
              title: 'Write text at the turtle'
            }, {
              block: 'do ht',
              title: 'Hide the turtle'
            }, {
              block: 'do st',
              title: 'Show the turtle'
            }, {
              block: 'do pu',
              title: 'Lift the pen up'
            }, {
              block: 'do pd',
              title: 'Put the pen down'
            }, {
              block: 'pen purple, 10',
              title: 'Set the pen color and size'
            }, {
              block: 'rt 180, 100',
              title: 'Make a wide right turn'
            }, {
              block: 'lt 180, 100',
              title: 'Make a wide left turn'
            }, {
              block: 'slide 100, 20',
              title: 'Slide diagonally or sideways'
            }, {
              block: 'jump 100, 20',
              title: 'Jump without drawing'
            }, {
              block: 'play \'GEC\'',
              title: 'Play music notes'
            }, {
              block: 'wear \'/img/cat-icon\'',
              title: 'Change the turtle picture'
            }
          ]
        }, {
          name: 'Control',
          color: 'orange',
          blocks: [
            {
              block: 'button \'Click\', ->\n  ``',
              title: 'Make a button and do something when clicked'
            }, {
              block: 'for [1..3]\n  ``',
              title: 'Do something multiple times'
            }, {
              block: 'for x in [1..3]\n  ``',
              title: 'Do something multiple times...?'
            }, {
              block: 'while ``\n  ``',
              title: 'Repeat something while a condition is true'
            }, {
              block: 'read \'Name?\', (n) ->\n  write \'Hello\' + n',
              title: 'Read input from the user'
            }, {
              block: 'if ``\n  ``',
              title: 'Do something only if a condition is true'
            }, {
              block: 'if ``\n  ``\nelse\n  ``',
              title: 'Do something if a condition is true, otherwise do something else'
            }
          ]
        }, {
          name: 'Calculate',
          color: 'green',
          blocks: [
            {
              block: 'x = ``',
              title: 'Set a variable'
            }, {
              block: '`` + ``',
              title: 'Add two numbers'
            }, {
              block: '`` - ``',
              title: 'Subtract two numbers'
            }, {
              block: '`` * ``',
              title: 'Multiply two numbers'
            }, {
              block: '`` / ``',
              title: 'Divide two numbers'
            }, {
              block: '`` is ``',
              title: 'Compare two values'
            }, {
              block: '`` < ``',
              title: 'Compare two values'
            }, {
              block: '`` > ``',
              title: 'Compare two values'
            }, {
              block: 'random [1..100]',
              title: 'Get a random number in a range'
            }, {
              block: 'round ``',
              title: 'Round to the nearest integer'
            }, {
              block: 'abs ``',
              title: 'Absolute value'
            }, {
              block: 'max ``, ``',
              title: 'Get the larger of two numbers'
            }, {
              block: 'min ``, ``',
              title: 'Get the smaller on two numbers'
            }, {
              block: 'f = (param) ->\n  ``',
              title: 'Define a new function'
            }, {
              block: 'myFunction(myArgument)',
              title: 'Use a custom function'
            }
          ]
        }, {
          name: 'Interact',
          color: 'violet',
          blocks: [
            {
              block: 'speed Infinity',
              title: 'Make the turtle move immediately'
            }, {
              block: 'tick 1, ->\n  ``',
              title: 'Do something at equally-spaced times'
            }, {
              block: 'moveto lastclick',
              title: 'Move to a location'
            }, {
              block: 'turnto lastmousemove',
              title: 'Turn towards a location'
            }, {
              block: 'click ->\n  write \'Heh!\'',
              title: 'Do something when the turtle is clicked'
            }, {
              block: 'if pressed \'enter\'\n  write \'Holding.\'',
              title: 'Test if a key is pressed'
            }, {
              block: 'p = new Piano',
              title: 'Make a new piano'
            }, {
              block: 'p.play \'EDC\'',
              title: 'Tell a piano to play notes'
            }, {
              block: 'w = new Webcam',
              title: 'Make a new webcam'
            }, {
              block: 't = new Turtle',
              title: 'Make a new turtle'
            }
          ]
        }
      ]
    });
    examplePrograms = {
      fizzbuzz: 'for i in [1..1000]\n  if i % 15 is 0\n    see \'fizzbuzz\'\n  else\n    if i % 5 is 0\n      see \'fizz\'\n    if i % 3 is 0\n      see \'buzz\'\n    if i % 3 isnt 0 and i % 5 isnt 0\n      see i',
      quicksort: 'globalNumberOfComparisons = 0\nbubblesort = (list) ->\n  for _ in [1..list.length]\n    for item, i in list\n      globalNumberOfComparisons += 1\n      if list[i] > list[i+1]\n        temp = list[i]\n        list[i] = list[i + 1]\n        list[i + 1] = temp\n  return list\nquicksort = ([head,tail...]) ->\n  return [] unless head?\n  globalNumberOfComparisons += 1 + tail.length\n  smaller_sorted = quicksort (e for e in tail when e <= head)\n  larger_sorted = quicksort (e for e in tail when e > head)\n  return smaller_sorted.concat([head]).concat(larger_sorted)\narray = [1..1000]\narray.sort (a, b) ->\n  if Math.random() > 0.5\n    return 1\n  else\n    return -1\n  return 0\nquicksort array\nquicksortSpeed = globalNumberOfComparisons\nsee \'Quicksort finished in \' + globalNumberOfComparisons + \' operations\'\narray.sort (a, b) ->\n  if Math.random() > 0.5\n    return 1\n  else\n    return -1\n  return 0\nglobalNumberOfComparisons = 0\nbubblesort array\nsee \'Bubblesort finished in \' + globalNumberOfComparisons + \' operations\'\nsee \'Quicksort was \' + globalNumberOfComparisons / quicksortSpeed + \' times faster\'',
      church: 'zero = (f) -> (x) -> x\nchurch = (n) ->\n  if n > 0\n    return succ church n-1\n  return zero\nunchurch = (n) -> n((x) -> x + 1) 0\nsucc = (n) -> (f) -> (x) -> f n(f) x\nadd = (m, n) -> (f) -> (x) -> m(f) n(f) x\nmult = (m, n) -> (f) -> n m f\nexp = (m, n) -> n m\npred = (n) -> (f) -> (x) -> n((g) -> (h) -> h(g(f)))(->x)((u)->u)\nsub = (m, n) -> n(pred) m\nsee unchurch exp church(2), church(6)\nsee unchurch add church(3), church(10)\nsee unchurch sub church(10), church(3)',
      controller: readFile('../src/controller.coffee'),
      compiler: readFile('../test/data/nodes.coffee'),
      empty: ''
    };
    editor.setEditorState(false);
    editor.aceEditor.getSession().setUseWrapMode(true);
    startingText = localStorage.getItem('example');
    editor.setValue(startingText || examplePrograms.fizzbuzz);
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
      return editor.toggleBlocks();
    });
  });

}).call(this);

//# sourceMappingURL=example.js.map
