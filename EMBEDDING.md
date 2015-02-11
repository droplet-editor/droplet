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


