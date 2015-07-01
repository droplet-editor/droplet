# Droplet config editor
dropletConfig = ace.edit 'droplet-config'
dropletConfig.setTheme 'ace/theme/chrome'
dropletConfig.getSession().setMode 'ace/mode/json'

dropletConfig.setValue localStorage.getItem('config') ? '''
  {
    "mode": "html",
    "palette": [
      {
        "name": "Metadata",
        "color": "lightblue",
        "blocks": [
          {
            "block":"<!DOCTYPE html>",
            "title":"Defines document type"
          },
          {
            "block":"<html>\\n  \\n</html>",
            "title":"Root of an HTML document"
          },
          {
            "block":"<head>\\n  \\n</head>",
            "title":"Represents a collection of metadata"
          },
          {
            "block":"<title></title>",
            "title":"Document's title or name"
          },
          {
            "block":"<base href=\\"\\" />",
            "title":"Base URL/target for all relative URLs in a document"
          },
          {
            "block":"<link rel=\\"\\" href=\\"\\" />",
            "title":"Link between a document and an external resource"
          },
          {
            "block":"<meta charset=\\"\\" />",
            "title":"Metadata about the HTML document"
          },
          {
            "block":"<style>\\n  \\n</style>",
            "title":"Define style information"
          },
          {
            "block":"<script>\\n  \\n</script>",
            "title":"Define a client-side script, such as a JavaScript"
          }
        ]
      },
      {
        "name": "Sections",
        "color": "orange",
        "blocks": [
          {
            "block":"<body>\\n  \\n</body>",
            "title":"Main content of the document"
          },
          {
            "block":"<article>\\n  \\n</article>",
            "title":"Independent, self-contained content"
          },
          {
            "block":"<section>\\n  \\n</section>",
            "title":"Generic section of a document or application"
          },
          {
            "block":"<nav>\\n  \\n</nav>",
            "title":"Set of navigation links"
          },
          {
            "block":"<aside>\\n  \\n</aside>",
            "title":"Content aside from the content it is placed in"
          },
          {
            "block":"<h1></h1>",
            "title":"Heading for its section - Can use h1..h6 for different sizes"
          },
          {
            "block":"<hgroup>\\n  \\n</hgroup>",
            "title":"Group of headings h1-h6"
          },
          {
            "block":"<header>\\n  \\n</header>",
            "title":"Group of introductory or navigational aids"
          },
          {
            "block":"<footer>\\n  \\n</footer>",
            "title":"Footer for a document or section"
          },
          {
            "block":"<address>\\n  \\n</address>",
            "title":"Contact information for the author/owner"
          }
        ]
      },
      {
        "name": "Grouping",
        "color": "purple",
        "blocks": [
          {
            "block":"<p>\\n  \\n</p>",
            "title":"Represents a paragraph"
          },
          {
            "block":"<hr />",
            "title":"Paragraph-level thematic break"
          },
          {
            "block":"<pre>\\n  \\n</pre>",
            "title":"Block of preformatted text"
          },
          {
            "block":"<blockquote>\\n  \\n</blockquote>",
            "title":"Section that is quoted from another source"
          },
          {
            "block":"<ol>\\n  \\n</ol>",
            "title":"Ordered list"
          },
          {
            "block":"<ul>\\n  \\n</ul>",
            "title":"Unordered list"
          },
          {
            "block":"<li></li>",
            "title":"List item"
          },
          {
            "block":"<dl>\\n  \\n</dl>",
            "title":"Description list"
          },
          {
            "block":"<dt></dt>",
            "title":"Term/name in a description list"
          },
          {
            "block":"<dd></dd>",
            "title":"Description of a term"
          },
          {
            "block":"<figure>\\n  \\n</figure>",
            "title":"Self-contained content, like illustrations, diagrams, photos, code listings, etc"
          },
          {
            "block":"<figcaption></figcaption>",
            "title":"Defines a caption for a <figure> element"
          },
          {
            "block":"<main>\\n  \\n</main>",
            "title":"Container for the dominant contents of another element"
          },
          {
            "block":"<div>\\n  \\n</div>",
            "title":"Defines a division"
          }
        ]
      },
      {
        "name": "Text",
        "color": "lightgreen",
        "blocks": [
          {
            "block":"<a href=\\"\\"></a>",
            "title":"Defines a hyperlink, which is used to link from one page to another"
          },
          {
            "block":"<em></em>",
            "title":"Stress emphasis of its contents"
          },
          {
            "block":"<strong></strong>",
            "title":"Strong importance, seriousness, or urgency for its contents"
          },
          {
            "block":"<small></small>",
            "title":"Side comments such as small print"
          },
          {
            "block":"<s></s>",
            "title":"Contents that are no longer accurate/relevant"
          },
          {
            "block":"<cite></cite>",
            "title":"Title of a work"
          },
          {
            "block":"<q></q>",
            "title":"Short quotation"
          },
          {
            "block":"<dfn></dfn>",
            "title":"Defining instance of a term"
          },
          {
            "block":"<abbr title=\\"\\"></abbr>",
            "title":"Abbreviation or acronym, optionally with its expansion"
          },
          {
            "block":"<ruby>\\n  \\n</ruby>",
            "title":"Ruby annotation(small extra text, attached to the main text to indicate the pronunciation or meaning of the corresponding characters)"
          },
          {
            "block":"<rt></rt>",
            "title":"Marks the ruby text component of a ruby annotation"
          },
          {
            "block":"<rp></rp>",
            "title":"Provide parentheses or other content around a ruby text"
          },
          {
            "block":"<data value=\\"\\"></data>",
            "title":"Represents its contents, along with a machine-readable form of those contents in the value attribute"
          },
          {
            "block":"<time datetime=\\"\\"></time>",
            "title":"Human-readable date/time"
          },
          {
            "block":"<code></code>",
            "title":"Fragment of computer code"
          },
          {
            "block":"<var></var>",
            "title":"Variable"
          },
          {
            "block":"<samp></samp>",
            "title":"Sample or quoted output from another program"
          },
          {
            "block":"<kbd></kbd>",
            "title":"User input (typically keyboard input)"
          },
          {
            "block":"<sub></sub>",
            "title":"Subscript"
          },
          {
            "block":"<sup></sup>",
            "title":"Superscript"
          },
          {
            "block":"<i></i>",
            "title":"Italic"
          },
          {
            "block":"<b></b>",
            "title":"Bold"
          },
          {
            "block":"<u></u>",
            "title":"Underline"
          },
          {
            "block":"<mark></mark>",
            "title":"Marked text"
          },
          {
            "block":"<bdi></bdi>",
            "title":"Bi-directional Isolation"
          },
          {
            "block":"<bdo dir=\\"\\">\\n  \\n</bdo>",
            "title":"Bi-Directional Override"
          },
          {
            "block":"<span></span>",
            "title":"Group inline-elements"
          },
          {
            "block":"<br />",
            "title":"Line break"
          },
          {
            "block":"<wbr />",
            "title":"Line break opportunity"
          },
          {
            "block":"text",
            "title":"Text content"
          }
        ]
      },
      {
        "name": "Other",
        "color": "pink",
        "blocks": [
          {
            "block":"<ins></ins>",
            "title":"Addition to the document"
          },
          {
            "block":"<del></del>",
            "title":"Removal from a document"
          },
          {
            "block":"<details>\\n  \\n</details>",
            "title":"Additional details that the user can view or hide on demand"
          },
          {
            "block":"<summary></summary>",
            "title":"Visible Heading of a <details> element"
          },
          {
            "block":"<menu>\\n  \\n</menu>",
            "title":"List/menu of commands"
          },
          {
            "block":"<menuitem></menuitem>",
            "title":"Command/menuitem inside a menu"
          },
          {
            "block":"<dialog open></dialog>",
            "title":"Dialog box or window"
          },
          {
            "block":"<noscript></noscript>",
            "title":"Alternate content for users that have disabled scripts"
          },
          {
            "block":"<template>\\n  \\n</template>",
            "title":"Declare fragments of HTML that can be cloned and inserted in the document by script"
          },
          {
            "block":"<canvas></canvas>",
            "title":"Draw graphics, on the fly, via scripting"
          },
          {
            "block":"<svg>\\n  \\n</svg>",
            "title":"Define graphics for the Web"
          },
          {
            "block":"<frameset cols=\\"\\">\\n  \\n</frameset>",
            "title":"Holds one or more <frame> elements each of which contains a separate document"
          }
        ]
      },
      {
        "name": "Embedded",
        "color": "teal",
        "blocks": [
          {
            "block":"<img src=\\"\\" alt=\\"\\" />",
            "title":"Image"
          },
          {
            "block":"<iframe>\\n  \\n</iframe>",
            "title":"Nested browsing context"
          },
          {
            "block":"<embed src=\\"\\" />",
            "title":"Integration point for an external (typically non-HTML) application or interactive content"
          },
          {
            "block":"<object data=\\"\\">\\n  \\n</object>",
            "title":"Embedded object within an HTML document"
          },
          {
            "block":"<param name=\\"\\" value=\\"\\" />",
            "title":"Parameters for plugins invoked by <object> elements"
          },
          {
            "block":"<video width=\\"\\" height=\\"\\" controls>\\n  \\n</video>",
            "title":"Playing videos or movies, and audio files with captions"
          },
          {
            "block":"<audio controls>\\n  \\n</audio>",
            "title":"Sound or audio stream"
          },
          {
            "block":"<source src=\\"\\" type=\\"\\" />",
            "title":"Specify multiple alternative media resources for media elements"
          },
          {
            "block":"<track src=\\"\\" />",
            "title":"Explicit external timed text tracks for media elements"
          },
          {
            "block":"<map name=\\"\\">\\n  \\n</map>",
            "title":"Define a client-side image-map(image with clickable areas)"
          },
          {
            "block":"<area shape=\\"\\" href=\\"\\" />",
            "title":"Area inside an image-map"
          }
        ]
      },
      {
        "name": "Table",
        "color": "indigo",
        "blocks": [
          {
            "block":"<table>\\n  \\n</table>",
            "title":"Defines a table"
          },
          {
            "block":"<caption></caption>",
            "title":"Table Caption"
          },
          {
            "block":"<colgroup>\\n  \\n</colgroup>",
            "title":"Group of 1 or more columns"
          },
          {
            "block":"<col style=\\"\\"/>",
            "title":"Column properties for a single column"
          },
          {
            "block":"<tbody>\\n  \\n</tbody>",
            "title":"Body of a table"
          },
          {
            "block":"<thead>\\n  \\n</thead>",
            "title":"Table header"
          },
          {
            "block":"<tfoot>\\n  \\n</tfoot>",
            "title":"Table footer"
          },
          {
            "block":"<tr>\\n  \\n</tr>",
            "title":"Row in a table"
          },
          {
            "block":"<td></td>",
            "title":"Standard cell inside a table row"
          },
          {
            "block":"<th></th>",
            "title":"Header cell inside a table row"
          }
        ]
      },
      {
        "name": "Form",
        "color": "deeporange",
        "blocks": [
          {
            "block":"<form action=\\"\\">\\n  \\n</form>",
            "title":"Create an HTML form"
          },
          {
            "block":"<input type=\\"\\" />",
            "title":"Input field where user can enter data"
          },
          {
            "block":"<label for=\\"\\"></label>",
            "title":"Label for an <input> element"
          },
          {
            "block":"<button></button>",
            "title":"Clickable button"
          },
          {
            "block":"<select>\\n  \\n</select>",
            "title":"Drop-down list"
          },
          {
            "block":"<option value=\\"\\"></option>",
            "title":"Option in a <select> list"
          },
          {
            "block":"<optgroup>\\n  \\n</optgroup>",
            "title":"Group related options in a <select> list"
          },
          {
            "block":"<datalist>\\n  \\n</datalist>",
            "title":"Pre-defined list of inputs for <input> element with autocomplete"
          },
          {
            "block":"<textarea>\\n  \\n</textarea>",
            "title":"Multi-line text input"
          },
          {
            "block":"<keygen />",
            "title":"Key-pair generator field"
          },
          {
            "block":"<output for=\\"\\"></output>",
            "title":"Results of a calculation"
          },
          {
            "block":"<progress value=\\"\\" max=\\"\\"></progress>",
            "title":"Progress of a task"
          },
          {
            "block":"<meter value=\\"\\"></meter>",
            "title":"Scalar measurement within a known range, or a fractional value"
          },
          {
            "block":"<fieldset>\\n  \\n</fieldset>",
            "title":"Group related items in a form"
          },
          {
            "block":"<legend></legend>",
            "title":"Caption for a <fieldset> element"
          }
        ]
      }
    ]
  }
'''

editor = null

# Droplet itself
createEditor = (options) ->
  $('#droplet-editor').html ''
  editor = new droplet.Editor $('#droplet-editor')[0], options

  editor.setEditorState localStorage.getItem('blocks') is 'yes'
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  editor.setValue localStorage.getItem('text') ? ''

  editor.on 'change', ->
    localStorage.setItem 'text', editor.getValue()

  window.editor = editor

createEditor JSON.parse dropletConfig.getValue()

$('#toggle').on 'click', ->
  editor.toggleBlocks()
  localStorage.setItem 'blocks', (if editor.currentlyUsingBlocks then 'yes' else 'no')

# Stuff for testing convenience
$('#update').on 'click', ->
  localStorage.setItem 'config', dropletConfig.getValue()
  createEditor JSON.parse dropletConfig.getValue()

configCurrentlyOut = localStorage.getItem('configOut') is 'yes'

updateConfigDrawerState = ->
  if configCurrentlyOut
    $('#left-panel').css 'left', '0px'
    $('#right-panel').css 'left', '525px'
  else
    $('#left-panel').css 'left', '-500px'
    $('#right-panel').css 'left', '25px'

  editor.resize()

  localStorage.setItem 'configOut', (if configCurrentlyOut then 'yes' else 'no')

$('#close').on 'click', ->
  configCurrentlyOut = not configCurrentlyOut
  updateConfigDrawerState()

updateConfigDrawerState()
