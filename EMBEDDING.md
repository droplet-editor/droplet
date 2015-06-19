Embedding Guide
===============

Basic instructions for embedding droplet are described in the README.
Some further details and tips on embedding are included here.

Loading the code
----------------

Code can be loaded either using require.js and loading and configuring
dependencies, or by including dist/droplet-full.js, which includes
most dependencies (except for the ace editor).

An example using require.js to load dependencies individually
can be found in example/example.html.  Notice that requirejs-path.json
is used to specify the location of dependencies, including the location
of the coffeescript and javascript (acorn) parsers.

Use of droplet-full.js can be seen in test/tests.html.  After droplet-full.js
and ace.js are included, require.js can resolve all the droplet dependencies
without loading any other files.  (Note that droplet-full does not embed
ace; it needs to be loaded on its own.)



Droplet Instantiation
---------------------

    editor = new droplet.Editor(containerElement, options);

Constructs a new instance of droplet.

    editor.aceEditor

Provides direct access to the underlying ace editor instance.

    editor.destroy()

Tears down an editor.  Call to avoid leaking resources when elminating
an instance.


Edited Content
--------------

    editor.setValue(text);

Sets the current text in the editor.

    editor.on('change', handler)

Calls back after the edited text has changed. TODO: test whether
we correctly intercept and forward the ace change event.


Block Mode Toggle
-----------------

    editor.setEditorState(useBlockMode);

Sets whether to use block mode (true) or text mode (false).

    editor.currentlyUsingBlocks

Returns true if using block mode.

    editor.on('toggledone', handler)

Calls back after the user has switched between block mode and text mode.


Palette
-------

    editor.on('selectpalette', handler)

Calls handler(palettename) each time the user clicks on a palette,
after the palette is updated.  Can be used for sound effects, logging,
help UI, etc.

    editor.on('pickblock', handler)

Calls handler(block.id) when the user clicks on a block in a palette.
The block id is taken from the block structure set up in options when
the palette is set up.

    editor.on('changepalette', handler)

Calls back after the palette is redrawn (due to a user selection change
or resizing change).  Used for reattaching to palette elements.  In
particular, this event is called after an element of class
"droplet-hover-div" is overlayed on each entry in the selected palette.
Each of those elements will have a "title" attribute containing help text.
Richer tooltips can be connected after this event.


Debugging
---------

    editor.on('linehover', handler)

Fires an event when the mouse hovers over a particular line
number in the block editor.

Parsing
-------

    editor.on('parseerror', handler)

Fires an event whenever block mode cannot process a program due to
an unrecoverabel parsing error.  (Fired when the user tries to switch
to block mode, or to load an unparsable program in block mode.)


Block Mode Appearance
---------------------

    editor.setFontFamily('Source Code Pro')

Sets up a font family to use.

    editor.setFontSize(15)

Sets up a font size (in pixels) to use.

    editor.setTopNubbyStyle(color)

What color to use for the top nubby of the editor.

ModeOptions for Coffeescript and Javascript
-------------------------------------------

When instantiating droplet, the options array can contain a modeOptions
option.  The same type of options objet can be passed as a second
argument to setMode.

modeOptions for both coffeescript and javascript.  Instead of passing three arrays blockFunctions, eitherFunctions, valueFunctions, we now pass a single map 'functions'.

modeOptions is an object that can have a `functions` property that
is an object that represents a whitelist of known functions, and a
`categories` property that represents a set of categorized built-in
language constructs.

```js
functions: {
    knownFunction: {value: true, color: red}
    myFunction: {value: true, command: true}
    'Math.random': {value: true}
    '*.toString': {value: true}
    '?.fd': { ommand: true}
    setColor: {
      command: true,
      dropdown: {
        0: [
          // Dropdown elements can be a string
          'blue',

          // Or an object with text and display
          {text: 'red', display: '<span style="color:red">red</span>'}

          // Or a display and a click handler (call the provided callback to set the value)
          {display: 'click me', click: (callback) -> callback('clicked')}
        ],

        // Dropdown element lists can also be generated on the fly by a function
        1: function() {
          return ['red', 'blue'];
        }

        // With either of these, you can specify
        // that the socket should be only editable by dropdown
        // (no typing) with "dropdownOnly":
        2: {
          dropdownOnly: true,
          options: function() {
            return ['red', 'blue']
          }
        }
      }
    }
},

categories: {
    functions: {color: 'purple'}
    returns: {color: 'yellow'}
    comments: {color: 'gray'}
    arithmetic: {color: 'green'}
    logic: {color: 'cyan'}
    containers: {color: 'teal'}
    assignments: {color: 'blue'}
    loops: {color: 'orange'}
    conditionals: {color: 'orange'}
    value: {color: 'green'}
    command: {color: 'blue'}
    errors: {color: '#f00'}
}
```

Functions are recognized by name, and may be bare (global) function names
or fully-qualified names like 'Math.random'; or they may be wildcard
method names.  '*.toString' matches any method named toString, and
'?.fd' matches any method or top-level function named 'fd'.

Each function is associated with a configuration object.  It can specify:
- value: true if it's a "value" block that should be usable as a value in expressions.
- command: true if it's a "command" block that can serve as a top-level statement.
- (specify both value and command if it can be both).
- color: colorname to set the color of the block.  If omitted, a default color is chosen.
- dropdown: specify dropdowns for specific arguments of a function. This can be either an array of strings, an array of objects with `text` (actual value) and `display` (html to display in the dropdown) properties, or a function that returns one of these.

In addition, there are categories of built-in language constructs.  Each
of these can specify a color.
