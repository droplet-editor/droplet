fs = require 'fs'
escape = require 'escape-html'

body = ''

parseType = (type) ->
  bits = type.split ' | '
  bitsCounted = []
  listBody = ''
  for bit in bits
    if bit in bitsCounted then continue
    else listBody += """
      <li class='type_bit'>
        #{escape(bit.replace(/\<|\>/g,''))}
      </li>
    """
  return """
    <ul>
      #{listBody}
    </ul>
  """

fs.readFile 'tags', (err, data) ->
  if err then throw err
  else
    for line in data.toString().split '\n'
      if line[0] is '!' then continue

      tokens = line.split '\t'
      unless tokens[0] is '%anonymous_function' or not tokens[5]?
        type = tokens[5].split(':')[1]
        returnValue = parseType(type.split('function(')[..-1].join(''))
        accepts = parseType(type.split('function(')[type.split('function(').length - 1][...-1])
        body += """
          <tr class='element'>
            <td class='name'>#{escape(tokens[0])}</td>
            <td class='accepts'>#{accepts}</td>
            <td class='returns'>#{returnValue}</td>
          </tr>
        """

    fs.writeFile 'docs.html', """
    <html>
      <head>
        <style>
          div.main {
            padding: 10px;
          }
          table.main_table {
            width: 100%;
          }
          td {
            border: 1px solid black;
          }
        </style>
      </head>
      <body>
        <div class='main'>
          <table class='main_table'>
            #{body}
          </table>
        </div>
      </body>
    </html>
    """
