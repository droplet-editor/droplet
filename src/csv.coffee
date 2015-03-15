###
  Name : Ashish Kumar, Third Year UnderGraduate, IIIT Hyderabad
  ```Pre Project for Block Editing for Html and CSS```
  Working Since: 1st Week of March 2015
  1st Commit: Using Acorn Javascript Parser
  2nd Commit: Changed Parser to my own using line and comma split
  3rd Commit: Some minute changes required for running it on localhost
  4th Commit: Enhancing the parser for quotes and No drop in a row
  5th Commit: Add + and - feature :)
  6th Commit: [To be Commited] : Add as many tests and Check it [Testing Phase]
###


define ['droplet-helper', 'droplet-model', 'droplet-parser'], (helper, model, parser) ->
  exports = {}

  ###
    Let's Define the Node Types
    Root: Program root
    Row : Rows in csv
    Simple: Quoted Values in a row
    NotSimple: Without Quoted in a row
  ###
  NODE_TYPES = [
    'Root'
    'Row'
    'NotSimple'
    'Simple'
  ]

  FORBID_ALL = ['forbid-all']
  BLOCK_ONLY = ['block-only']

  exports.CsvScriptParser = class CsvScriptParser extends parser.Parser
    constructor: (@text, @opts = {}) ->
        super
        @lines = @text.split '\n'

    ###
      Helper Functions used in building of parser and adapter
    ###
    getcsvBounds: (startline, startcol, endline, endcol) ->
      # Args: starline, startcol, endline, endcol
      # Return: Bounds for corresponding block
      return {
        start: {
          line: startline
          column: startcol
        }
        end: {
          line: endline
          column: endcol
        }
      }

    getColor: (csvNode) ->
      # Args: Node
      # Return: Color for the corresponding node
      return 'command'

    getSocketLevel: (csvNode) -> 
      # Args: Node
      # Return: Socket level for the corresponding node
      helper.ANY_DROP

    getAcceptsRule: (csvNode) -> 
      # Args: Node
      # Return: Socket Accepted rule for the corresponding node
      default: helper.VALUE_ONLY

    getClasses: (node) ->
      # Args: Node
      # Return: Class for the corresponding node
      if node.type is 'Simple'
        return FORBID_ALL
      else if node.type is 'NotSimple'
        return FORBID_ALL
      else
        return BLOCK_ONLY

    getNode: (type, start, end, loc, lastSocket, beginSocket) ->
      # Args: type, start, end, loc
      # Return: Node 
      return {
         type: type
         start: start
         end: end
         loc: loc
         body: []
         last: lastSocket
         begin: beginSocket
      }

    checkStart: (index) ->
      if index is 0
        return true
      return false

    getleftIndent: (str) ->
      # Args: String
      # Return: String with left white spaces
      return str[0...str.length - str.trimLeft().length]
      
    getrightIndent: (str) ->
      # Args: String
      # Return: String with right white spaces  
      return str[str.trimRight().length...str.length]

    csvAddblock: (csvNode) ->
      # Adds a block 
      # Args: Node
      # Return: 
      @addBlock
        bounds: csvNode.loc
        depth: 1
        precedence: 0
        add: true
        del: true
        color: @getColor  csvNode 
        classes: @getClasses csvNode
        socketLevel: @getSocketLevel csvNode

    csvAddSocket: (csvNode) ->
      # Addes a socket
      # Args: Node
      # Return:  
      @addSocket
        bounds: csvNode.loc
        depth: 2
        precedence: 1
        classes: []
        last: csvNode.last
        begin: csvNode.begin
        accepts: @getAcceptsRule csvNode

    ###
      Csv Parse that parses the given text 
      For Ex:
        ashish,ashish,"ashish",ashish,"ashish"
      Parse Tree:
        root ->
          Row ->
            NotSimple,
            NotSimple,
            Simple,
            NotSimple,
            Simple,
    ###
    csvParse: (lines, text) ->
      
      ###
        Root Node of the tree with type as 'Root'
        TODO: Need to take care of ,,,,,,,,,,,,,
      ###
      rootBound = @getcsvBounds 0, 0, lines.length, lines[lines.length-1].length 
      rootNode = @getNode 'Root', 0, text.length+1, rootBound, false, false
      
      # Traverse in each line
      for line, i in lines
        if not @isComment line
          # Socket Found:
          value = line
          # Getting the leading spaces
          prefix = @getleftIndent value
          # Getting the trailing spaces
          suffix = @getrightIndent value
          rowBound = @getcsvBounds i , prefix.length, i, line.length - suffix.length
          rowNode = @getNode 'Row', prefix.length, line.length - suffix.length, rowBound, false, false
        
          # Add only if there is something in the line
          if line.length > 0 
            isquote = 0
            st = 0

            for val, ind in line
              if val is ',' and isquote is 0 
                  # Socket Found:
                  value = line[st...ind]  
                  # Getting the leading spaces
                  prefix = @getleftIndent value
                  # Getting the trailing spaces
                  suffix = @getrightIndent value

                  # Node with value 
                  colBound = @getcsvBounds i, st + prefix.length, i, ind - suffix.length 
                  colNode = @getNode 'Simple', st + prefix.length, ind - suffix.length, colBound, false, @checkStart st
                  rowNode.body.push colNode
                  st = ind + 1
              else if val is '"' and isquote is 1 
                  # Close quote
                  isquote = 0
              else if val is '"' and isquote is 0
                  # Open quote
                  isquote = 1
            
            # Last Socket
            value = line[st...line.length]  
            # Getting the leading spaces
            prefix = @getleftIndent value
            # Getting the trailing spaces
            suffix = @getrightIndent value 
            # Node with value             
            colBound = @getcsvBounds i, st + prefix.length, i, line.length - suffix.length
            colNode = @getNode 'Simple', st + prefix.length, line.length - suffix.length, colBound, true, @checkStart st
            rowNode.body.push colNode
            
            rootNode.body.push rowNode

      return rootNode

    markRoot: ->
        #console.log @text
        #console.log @lines
        tree = @csvParse @lines, @text
        console.log tree
        @mark tree

    mark: (node) ->
      if node.type is 'Root'
        for i in node.body
          @mark i
      else if node.type is 'Row'
        @csvAddblock node
        for i in node.body
          @mark i
      else 
        @csvAddSocket node
      
      
    isComment: (str) ->
      str.match(/^\s*#.*$/)?


  CsvScriptParser.parens = (leading, trailing, node, context) ->
    # "leading" is the leading text owned by the block and not its children;
    # "trailing" is similar trailing text. "node" is the Block that is being dropped,
    # and context is the Socket or Indent it is being dropped into.
    #console.log leading leading()
    #console.log trailing trailing()
    return [leading, trailing]

  ### 
    No Drop Allowed in Sockets 
  ###
  CsvScriptParser.drop = (block, context, pred) ->
    if context.type is 'socket'
          return helper.FORBID
    else
        return helper.ENCOURAGE
  
  ###
   Trimming according to wikipedia rules
   IS recursive embedding allowed?
    input: "ashish "ashish "ashish "" "
    Current output: "ashish ""ashish ""ashish "" "
    Output with recursive implementation: "ashish  ""ashish ""ashish """" "
   ans: No
    parser will detect it like "ashish " , ashish, "ashish ", " "
      If we want to allow recursive embedding, We can use the stack operations
      We will push the quotes upto number_of_quotes/2 and then start poping upto zero
      by this the nearest possible quoting will happen
  ###
  CsvScriptParser.trimString = (str, islast, isbegin) ->
    ret = str.trim()
    if ret.length > 0
      isquote = 0
      iscomma = 0
      qstart = true
      qend = true
      if ret[0] != '"'
        ret = '"' + ret[0...ret.length]
        qstart = false
      if ret[ret.length - 1] != '"'
        ret += '"'
        qend = false
      
      ret = ret[1..ret.length-2]
      for i, j in ret
        if i == '"'
          isquote = 1
        if i ==','
          iscomma = 1

      ###
        Case: Csv rule for:
        embedded line breaks must be quoted

        TODO: Currently I am checking it for any last and starting socket but
              Here I need to add one more condition if current start is start and 
              It have quote at the end of text then only the quotes arround the text
              only if its previous block's last socket has quotes at the start 
              i.e. line breaks
      ###
      if (qstart is false) or (qend is false)
        if (qstart is true and islast is true) or (qend is true and isbegin is true)
          iscomma = 1

      if iscomma != 0 or isquote != 0
        cur = ret.replace(/\"/g, '\"\"')
        cur = cur.replace(/\"\"*/g,'\"\"')
        ret = '"' + cur + '"'


    return ret

  ###
    :::Trimming and Conversion starts here , Trimming with self rules::::
    Trim the current socket's string as below
    For Ex:
              "ashish",ashish ashish,"ashish" "ashish"
       -> 
    Socket no: 1       ,   2     ,  3     ,   4     ,   5
              "ashish" , ashish   , ashish , "ashish", "ashish"

    Rules for embedded quoting
    If you try
      " "ashish " "
      It will split out as " ",ashish," "
  ###
  CsvScriptParser.triString = (str) ->
    # Trim out left and right spaces 
    str = str.trim()
    ret = ""
    st = 0
    isquote = 0
    islastcomma = 0
    if str.length > 1
      for val, ind in str
        if val is ',' and isquote is 0
          # Case when you are about to add ashish and current literal is ,
          if ind is str.length-1 
            # Check if current index is last index
            ret = ret + str.slice(st,ind) 
          else
            ret = ret + str.slice(st,ind)  + ','
          st = ind + 1
          islastcomma = 1
        else if val is '"' and isquote is 1
          # Case when you are about to add "ashish and current literal is quote
          if ind is str.length-1
            # Check if current index is last index
            ret = ret + str.slice(st,ind) + '"'
          else
            ret = ret + str.slice(st,ind) + '"' + ','
          st = ind + 1
          isquote = 0
          islastcomma = 1
        else if val is '"' and isquote is 0
          # Case when you are about to start a quoted string 
          if islastcomma is 0 and st != ind
            # Case when last character is not comma
            # Add the string uto ind
            if ind is str.length-1
              # Check if current index is last index
              ret = ret + str.slice(st,ind) 
            else
              ret = ret + str.slice(st,ind) + ','
            islastcomma = 1
          else
            islastcomma = 0
          st = ind 
          isquote = 1
        else
          if val is ','
            islastcomma = 1
          else if val != ' ' 
            islastcomma = 0

      if st < str.length
        if isquote is 1
          ret = ret + str.slice(st,str.length) + '"'
        else
          ret = ret + str.slice(st,str.length)
    return ret    

  CsvScriptParser.empty = "__"
  
  return parser.wrapParser CsvScriptParser
