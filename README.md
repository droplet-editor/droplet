Droplet Editor
=================

[![Build Status](https://travis-ci.org/droplet-editor/droplet.svg?branch=master)](https://travis-ci.org/dabbler0/droplet)

Droplet seeks to re-envision "block programming" as "text editing". It is useful as a transitional tool for beginners using languages like Scratch, and is a go-to text editor for everyone on mobile devices (where keyboards don't work so well).

How to Embed
------------
Droplet is a browserify package, so you can include it with npm, requirejs, or as a browser global. To embed, call `new droplet.Editor()` on a div.

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
<script src="dist/droplet-full.min.js"></script>
<script src="index.coffee" type="text-coffeescript"></script>
<div id="editor"></div>
</html>
```

```coffeescript
editor = new droplet.Editor document.getElementById('editor'), {
  # Language
  mode: 'coffeescript'

  # Options for the CoffeeScript parser
  # (the JavaScript parser currently takes the same options)
  modeOptions: {
    functions: {
      fd: { command: true, color: 'red'}
      bk: { command: true, color: 'blue'}
      sin: { command: false, value: true, color: 'green' }
    }
    categories: {
      conditionals: { color: 'purple' }
      loops: { color: 'green' }
      functions: { color: '#49e' }
    }
  }

  # Palette description
  palette: [
   {
      name: 'Palette category'
      color: 'blue' # Header color
      blocks: [
        {
          block: "for [1..3]\n  ``"
          title: "Repeat some code" # title-text
        },
        {
          block: "playSomething()"
          expansion: "playSomething 'arguments', 100, 'too long to show'"
        },
      ]
    }
  ]
}

editor.setValue '''
for i in [1..10]
  document.write 'hello world'
'''
```

Contributing
============

Droplet uses Grunt and npm to build. Run:

```shell
git pull https://github.com/dabbler0/droplet.git
cd droplet
npm install
grunt all
```

When developing, run:
```shell
grunt testserver
```

This will run the development server and watch the `src/` and `example/` directories for recompilation. Visit `localhost:8000/example/example.html` for a simple running environment. A view debugger is available at `localhost:8000/example/test.html`.

Run `grunt all` to run the tests.


Installing
==========

On Ubuntu xenial, you can install the latest version of nodejs as follows:

1. Create a new file "/etc/apt/sources.list.d/nodesource.list" with these contents:

```shell
deb https://deb.nodesource.com/node_6.x xenial main
deb-src https://deb.nodesource.com/node_6.x xenial main
```

2. Get the Nodesource GPG signing key:
```shell
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
```

3. Update and upgrade:
```shell
sudo apt-get update
sudo apt-get install nodejs
```

Adding a Language
-----------------
Make a CoffeeScript (or JavaScript) file that looks like this:

```coffeescript
helper = require './helper.coffee'
parser = require './parser.coffee'

class MyParser extends parser.Parser
  markRoot: ->

module.exports = parser.wrapParser MyParser
```

Put it in `src/myparser.coffee`.

Require it from `modes.coffee`:

```coffeescript
javascript = require './javascript.coffee'
coffee = require './coffee.coffee'
myparser = require './myparser.coffee'

module.exports = {
  'javascript': javascript
  'coffee': coffee
  'coffeescript': coffee
  'myparser': myparser
  'myparser-alias': myparser
}
```

Then grunt. Your mode is integrated!

To have your parser actually put blocks in, you will need to do some things in the `markRoot` function. Fields and methods you need to know about:
```coffeescript
# Get the raw text passed into the parser:
@text

# Get the `modeOptions` passed down from editor instantiation
@opts

# Add a Block
@addBlock({
  # Configure the location of the block (all required)
  bounds: {
    start: {line: Number, column: Number} # Lines and columns are zero-indexed
    end: {line: Number, column: Number}
  }
  depth: Number # Depth in the tree

  # Configure the block you're about to add (all optional)
  color: '#HEXCOLOR'
  precedence: Number
  classes: [] # Array of strings.
  buttons: {
    addButton: Boolean
    subtractButton: Boolean
  }
})

# Add a Socket
@addSocket({
  # Configure the location of the socket (all required)
  bounds: {
    start: {line: Number, column: Number} # Lines and columns are zero-indexed
    end: {line: Number, column: Number}
  }
  depth: Number # Depth in the tree

  # Configure the block you're about to add (all optional)
  precedence: Number
  classes: [] # Array of strings
})

# Add an Indent
@addIndent({
  # Configure the location of the socket (all required)
  bounds: {
    start: {line: Number, column: Number} # Lines and columns are zero-indexed
    end: {line: Number, column: Number}
  }
  depth: Number # Depth in the tree

  # Configure the indent you're about to add (all optional)
  prefix: '  ' # String that is a prefix of all the lines
  classes: [] # Array of strings
})
```

Call these in markRoot to insert Blocks, Sockets and Indents.

You may also want to override the following callbacks:
```coffeescript
# Parens is called whenever a block is dropped into
# another block; you are allowed to change the leading
# and trailing text of the block at this moment (for parentheses, semicolons, etc.)
#
# The default for this is based on the precedence numbers.
MyParser.parens = (leading, trailing, node, context) ->
  # "leading" is the leading text owned by the block and not its children;
  # "trailing" is similar trailing text. "node" is the Block that is being dropped,
  # and context is the Socket or Indent it is being dropped into.
  return [newLeading, newTrailing]

# Text to fill in an empty socket when switching modes:
MyParser.empty = "blarg"

MyParser.drop = (block, context, preceding, succeeding) ->
  # block: the block that user is dragging
  # context: the place the user is dropping that block into
  # preceding: if in sequence, the block immediately before
  # succeeding: if in sequence, the block immediately after

  # block, context, preceding and succeeding will have
  # properties `classes` (from when you created the block),
  # `precedence`, and `type` ('block', 'socket', 'indent', or 'segment')
  if allowedIn(block, context)
    return helper.ENCOURAGE
  else if maybe(block, context)
    return helper.DISCOURAGE
  else
    return helper.FORBID

# HandleButton is called whenever a button is clicked
# You are allowed to modify this text provided
# the new text forms a single block
# which will replace the original block
MyParser.handleButton = (text, command, block) ->
  # "text" is the text of the block whose button was clicked
  # "command" is the button which was clicked
  # and is equal to 'add-button'
  # or 'subtract-button' telling which block was clicked
  # "block" contains information about the original block
  switch command
    when 'add-button'
      return newText
    when 'subtract-button'
      return newText
  # Return 'text' is you don't want to change anything
  return text
```

View Options
------------
You can pass a `viewSettings` object into the options to configure various aspects of the renderer.

```javascript
{
  viewSettings: {
    padding: 5, // Padding around each block
    indentWidth: 20, // Width of the left side of indent C-shaped blocks
    indentTongueHeight: 20, // Height of the bottom of indent C-shaped blocks when there is no other text on that bottom line (used mainly in Python/Coffee modes) 
    tabOffset: 10, // Distance from the left side of the puzzle-piece tab to the left side of the block
    tabWidth: 15, // Width of the bottom of the tab (from top point to top point)
    tabHeight: 4, // Height of the tab
    tabSideWidth: 1, / 4 // Fraction the width that is taken up by the sides of the tab (larger means flatter/fatter slanted sides)
    emptySocketWidth: 20, // Size of a socket with no text in it
    emptyLineHeight: 25, // Height of a line with no blocks on it
    shadowBlur: 5, // Blur factor for the drop shadow when dragging
    colors: { // Color aliases used in various places elsewhere; changing these will change lots of colors
      error: '#ff0000',
      comment: '#c0c0c0',  // currently grayish
      return: '#fff59d',   // currently yellowish
      control: '#ffcc80',  // currently orangeish
      value: '#a5d6a7',    // currently greenish
      command: '#90caf9' // currently blueish
    }
  }
}
```
