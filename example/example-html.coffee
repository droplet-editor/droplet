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
          {"block":"<!DOCTYPE html>", "title":"Defines document type"},
          {"block":"<html>\\n  \\n</html>"},
          {"block":"<head>\\n  \\n</head>"},
          {"block":"<title></title>"},
          {"block":"<base href=\\"\\" />"},
          {"block":"<link rel=\\"\\" href=\\"\\" />"},
          {"block":"<meta charset=\\"\\" />"},
          {"block":"<style>\\n  \\n</style>"}
        ]
      },
      {
        "name": "Sections",
        "color": "orange",
        "blocks": [
          {"block":"<body>\\n  \\n</body>"},
          {"block":"<article>\\n  \\n</article>"},
          {"block":"<section>\\n  \\n</section>"},
          {"block":"<nav>\\n  \\n</nav>"},
          {"block":"<aside>\\n  \\n</aside>"},
          {"block":"<h1></h1>"},
          {"block":"<hgroup>\\n  \\n</hgroup>"},
          {"block":"<header>\\n  \\n</header>"},
          {"block":"<footer>\\n  \\n</footer>"},
          {"block":"<address>\\n  \\n</address>"}
        ]
      },
      {
        "name": "Grouping",
        "color": "purple",
        "blocks": [
          {"block":"<p>\\n  \\n</p>"},
          {"block":"<hr />"},
          {"block":"<pre>\\n  \\n</pre>"},
          {"block":"<blockquote>\\n  \\n</blockquote>"},
          {"block":"<ol>\\n  \\n</ol>"},
          {"block":"<ul>\\n  \\n</ul>"},
          {"block":"<li></li>"},
          {"block":"<dl>\\n  \\n</dl>"},
          {"block":"<dt></dt>"},
          {"block":"<dd></dd>"},
          {"block":"<figure>\\n  \\n</figure>"},
          {"block":"<figcaption></figcaption>"},
          {"block":"<main>\\n  \\n</main>"},
          {"block":"<div>\\n  \\n</div>"}
        ]
      },
      {
        "name": "Text",
        "color": "lightgreen",
        "blocks": [
          {"block":"<a href=\\"\\"></a>"},
          {"block":"<em></em>"},
          {"block":"<strong></strong>"},
          {"block":"<small></small>"},
          {"block":"<big></big>"},
          {"block":"<cite></cite>"},
          {"block":"<q></q>"},
          {"block":"<dfn></dfn>"},
          {"block":"<abbr title=\\"\\"></abbr>"},
          {"block":"<ruby>\\n  \\n</ruby>"},
          {"block":"<rt></rt>"},
          {"block":"<rp></rp>"},
          {"block":"<data></data>"},
          {"block":"<data value=\\"\\"></data>"},
          {"block":"<time></time>"},
          {"block":"<code></code>"},
          {"block":"<var></var>"},
          {"block":"<samp></samp>"},
          {"block":"<kbd></kbd>"},
          {"block":"<sub></sub>"},
          {"block":"<sup></sup>"},
          {"block":"<i></i>"},
          {"block":"<b></b>"},
          {"block":"<u></u>"},
          {"block":"<mark></mark>"},
          {"block":"<bdi></bdi>"},
          {"block":"<bdo dir=\\"\\">\\n  \\n</bdo>"},
          {"block":"<span></span>"},
          {"block":"<br />"},
          {"block":"<wbr />"},
          {"block":"text"}
        ]
      },
      {
        "name": "Other",
        "color": "pink",
        "blocks": [
          {"block":"<ins></ins>"},
          {"block":"<del></del>"},
          {"block":"<details>\\n  \\n</details>"},
          {"block":"<summary></summary>"},
          {"block":"<menu>\\n  \\n</menu>"},
          {"block":"<menuitem></menuitem>"},
          {"block":"<dialog open></dialog>"},
          {"block":"<script>\\n  \\n</script>"},
          {"block":"<script src=\\"\\"></script>"},
          {"block":"<noscript></noscript>"},
          {"block":"<template>\\n  \\n</template>"},
          {"block":"<canvas></canvas>"},
          {"block":"<applet code=\\"\\">\\n  \\n</applet>"},
          {"block":"<basefont color=\\"\\" size=\\"\\" />"},
          {"block":"<bgsound src=\\"\\" />"},
          {"block":"<center>\\n  \\n</center>"},
          {"block":"<command type=\\"\\" label=\\"\\" />"},
          {"block":"<font sixe=\\"\\" color=\\"\\">\\n  \\n</font>"},
          {"block":"<frameset cols=\\"\\">\\n  \\n</frameset>"},
          {"block":"<marquee></marquee>"},
          {"block":"<strike></strike>"},
          {"block":"<tt></tt>"},
          {"block":"<svg>\\n  \\n</svg>"}
        ]
      },
      {
        "name": "Embedded",
        "color": "teal",
        "blocks": [
          {"block":"<img src=\\"\\" alt=\\"\\" />"},
          {"block":"<iframe>\\n  \\n</iframe>"},
          {"block":"<embed src=\\"\\" />"},
          {"block":"<object data=\\"\\">\\n  \\n</object>"},
          {"block":"<param name=\\"\\" value=\\"\\" />"},
          {"block":"<video width=\\"\\" height=\\"\\" controls>\\n  \\n</video>"},
          {"block":"<audio controls>\\n  \\n</audio>"},
          {"block":"<source src=\\"\\" type=\\"\\" />"},
          {"block":"<track src=\\"\\" />"},
          {"block":"<map name=\\"\\">\\n  \\n</map>"},
          {"block":"<area shape=\\"\\" href=\\"\\" />"}
        ]
      },
      {
        "name": "Table",
        "color": "indigo",
        "blocks": [
          {"block":"<table>\\n  \\n</table>"},
          {"block":"<caption></caption>"},
          {"block":"<colgroup>\\n  \\n</colgroup>"},
          {"block":"<col style=\\"\\"/>"},
          {"block":"<tbody>\\n  \\n</tbody>"},
          {"block":"<thead>\\n  \\n</thead>"},
          {"block":"<tfoot>\\n  \\n</tfoot>"},
          {"block":"<tr>\\n  \\n</tr>"},
          {"block":"<td></td>"},
          {"block":"<th></th>"}
        ]
      },
      {
        "name": "Form",
        "color": "deeporange",
        "blocks": [
          {"block":"<form action=\\"\\">\\n  \\n</form>"},
          {"block":"<label for=\\"\\"></label>"},
          {"block":"<input type=\\"\\" />"},
          {"block":"<button></button>"},
          {"block":"<select>\\n  \\n</select>"},
          {"block":"<datalist>\\n  \\n</datalist>"},
          {"block":"<optgroup>\\n  \\n</optgroup>"},
          {"block":"<option value=\\"\\"></option>"},
          {"block":"<textarea>\\n  \\n</textarea>"},
          {"block":"<keygen />"},
          {"block":"<output for=\\"\\"></output>"},
          {"block":"<progress value=\\"\\" max=\\"\\"></progress>"},
          {"block":"<meter value=\\"\\"></meter>"},
          {"block":"<fieldset>\\n  \\n</fieldset>"},
          {"block":"<legend></legend>"}
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

  editor.clearUndoStack()

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
