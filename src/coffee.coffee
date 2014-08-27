# # ICE Editor CoffeeScript mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model', 'droplet-parser', 'coffee-script'], (helper, model, parser, CoffeeScript) ->
  exports = {}


  ANY_DROP = helper.ANY_DROP
  BLOCK_ONLY = helper.BLOCK_ONLY
  MOSTLY_BLOCK = helper.MOSTLY_BLOCK
  MOSTLY_VALUE = helper.MOSTLY_VALUE
  VALUE_ONLY = helper.VALUE_ONLY

  BLOCK_FUNCTIONS = [
    'fd'
    'bk'
    'rt'
    'lt'
    'slide'
    'movexy'
    'moveto'
    'jump'
    'jumpto'
    'turnto'
    'home'
    'pen'
    'fill'
    'dot'
    'box'
    'mirror'
    'twist'
    'scale'
    'pause'
    'st'
    'ht'
    'cs'
    'cg'
    'ct'
    'pu'
    'pd'
    'pe'
    'pf'
    'play'
    'tone'
    'silence'
    'speed'
    'wear'
    'drawon'
    'label'
    'reload'
    'see'
    'sync'
    'send'
    'recv'
    'click'
    'mousemove'
    'mouseup'
    'mousedown'
    'keyup'
    'keydown'
    'keypress'
  ]

  VALUE_FUNCTIONS = [
    'abs'
    'acos'
    'asin'
    'atan'
    'atan2'
    'cos'
    'sin'
    'tan'
    'ceil'
    'floor'
    'round'
    'exp'
    'ln'
    'log10'
    'pow'
    'sqrt'
    'max'
    'min'
    'random'
    'pagexy'
    'getxy'
    'direction'
    'distance'
    'shown'
    'hidden'
    'inside'
    'touches'
    'within'
    'notwithin'
    'nearest'
    'pressed'
    'canvas'
    'hsl'
    'hsla'
    'rgb'
    'rgba'
    'cell'
  ]

  EITHER_FUNCTIONS = [
    'button'
    'read'
    'readstr'
    'readnum'
    'write'
    'table'
    'append'
    'finish'
    'loadscript'
  ]

  STATEMENT_KEYWORDS = [
    'break'
    'continue'
  ]

  OPERATOR_PRECEDENCES =
    '||': 1
    '&&': 2
    'instanceof': 3
    '===': 3
    '!==': 3
    '>': 3
    '<': 3
    '>=': 3
    '<=': 3
    '+': 4
    '-': 4
    '*': 5
    '/': 5
    '%': 6
    '**': 7
    '%%': 7

  SAY_NORMAL= default: helper.NORMAL
  SAY_FORBID = default: helper.FORBID

  YES = -> yes
  NO = -> no

  spacestring = (n) -> (' ' for [0...Math.max(0, n)]).join('')

  getClassesFor = (node) ->
    classes = []

    classes.push node.nodeType()
    if node.nodeType() is 'Call' and (not node.do) and (not node.isNew)
      classes.push 'works-as-method-call'

    return classes

  exports.CoffeeScriptParser = class CoffeeScriptParser extends parser.Parser
    constructor: (@text) ->
      super

      @lines = @text.split '\n'

      @hasLineBeenMarked = {}

      for line, i in @lines
        @hasLineBeenMarked[i] = false

    markRoot: ->
      # Preprocess comments
      do @stripComments

      retries = Math.max(1, Math.min(5, Math.ceil(@lines.length / 2)))
      firstError = null
      # Get the CoffeeScript AST from the text
      loop
        try
          nodes = CoffeeScript.nodes(@text).expressions
          break
        catch e
          firstError ?= e
          if retries > 0 and fixCoffeeScriptError @lines, e
            @text = @lines.join '\n'
          else
            throw firstError
        retries -= 1

      # Mark all the nodes
      # in the block.
      for node in nodes
        @mark node, 3, 0, null, 0

      # Deal with semicoloned lines
      # at the root level
      @wrapSemicolons nodes, 0

    isComment: (str) ->
      str.match(/^\s*#.*$/)?

    stripComments: ->
      # Preprocess comment lines:
      tokens = CoffeeScript.tokens @text,
        rewrite: false
        preserveComments: true

      # In the @lines record, replace all
      # comments with spaces, so that blocks
      # avoid them whenever possible.
      for token in tokens
        if token[0] is 'COMMENT'

          if token[2].first_line is token[2].last_line
            line = @lines[token[2].first_line]
            @lines[token[2].first_line] =
              line[...token[2].first_column] +
              spacestring(token[2].last_column - token[2].first_column + 1) +
              line[token[2].last_column...]

          else
            line = @lines[token[2].first_line]
            @lines[token[2].first_line] = line[...token[2].first_column] +
              spacestring(line.length - token[2].first_column)

            @lines[token[2].last_line] =
              spacestring(token[2].last_column + 1) +
                @lines[token[2].last_line][token[2].last_column + 1...]

            for i in [(token[2].first_line + 1)...token[2].last_line]
              @lines[i] = spacestring(@lines[i].length)

      # We will leave comments unmarked
      # until the applyMarkup postprocessing
      # phase, when they will be surrounded
      # by blocks if they are outside anything else.
      return null

    # ## mark ##
    # Mark a single node.  The main recursive function.
    mark: (node, depth, precedence, wrappingParen, indentDepth) ->
      switch node.nodeType()

        # ### Block ###
        # A Block is a group of expressions,
        # which is represented by either an indent or a socket.
        when 'Block'
          # Abort if empty
          if node.expressions.length is 0 then return

          # Otherwise, get the bounds to determine
          # whether we want to do it on one line or multiple lines.
          bounds = @getBounds node

          # See if we want to wrap in a socket
          # rather than an indent.
          shouldBeOneLine = false

          # Check to see if any parent node is occupying a line
          # we are on. If so, we probably want to wrap in
          # a socket rather than an indent.
          for line in [bounds.start.line..bounds.end.line]
            shouldBeOneLine or= @hasLineBeenMarked[line]

          if @lines[bounds.start.line][...bounds.start.column].trim().length isnt 0
            shouldBeOneLine = true

          if shouldBeOneLine
            @csSocket node, depth, 0

          # Otherwise, wrap in an indent.
          else
            # Determine the new indent depth by literal text inspection
            textLine = @lines[node.locationData.first_line]
            trueIndentDepth = textLine.length - textLine.trimLeft().length

            # As a block, we also want to consume as much whitespace above us as possible
            # (to free it from actual ICE editor blocks).
            while bounds.start.line > 0 and @lines[bounds.start.line - 1].trim().length is 0
              bounds.start.line -= 1
              bounds.start.column = @lines[bounds.start.line].length + 1

            # Move the boundaries back by one line,
            # as per the standard way to add an Indent.
            bounds.start.line -= 1
            bounds.start.column = @lines[bounds.start.line].length + 1

            @addIndent {
              depth: depth
              bounds: bounds
              prefix: @lines[node.locationData.first_line][indentDepth...trueIndentDepth]
            }

            # Then update indent depth data to reflect.
            indentDepth = trueIndentDepth

          # Mark children. We do this at depth + 3 to
          # make room for semicolon wrappers where necessary.
          for expr in node.expressions
            @mark expr, depth + 3, 0, null, indentDepth

          # Wrap semicolons.
          @wrapSemicolons node.expressions, depth

        # ### Parens ###
        # Parens are special; they get no marks
        # but pass to the next node with themselves
        # as the wrapping parens.
        #
        # If we are ourselves wrapped by a parenthesis,
        # then keep that parenthesis when we pass on.
        when 'Parens'
          if node.body?
            unless node.body.nodeType() is 'Block'
              @mark node.body, depth + 1, 0, (wrappingParen ? node), indentDepth
            else
              if node.body.unwrap() is node.body
                # We are filled with some things
                # connected by semicolons; wrap them all,
                @csBlock node, depth, -2, 'command', null, MOSTLY_BLOCK

                for expr in node.body.expressions
                  @csSocketAndMark expr, depth + 1, -2, indentDepth

              else
                @mark node.body.unwrap(), depth + 1, 0, (wrappingParen ? node), indentDepth

        # ### Op ###
        # Color VALUE, sockets @first and (sometimes) @second
        when 'Op'
          # An addition operator might be
          # a string interpolation, in which case
          # we want to ignore it.
          if node.first? and node.second? and node.operator is '+'
            # We will search for a literal "+" symbol
            # between the two operands. If there is none,
            # we assume string interpolation.
            firstBounds = @getBounds node.first
            secondBounds = @getBounds node.second

            lines = @lines[firstBounds.end.line..secondBounds.start.line].join('\n')

            infix = lines[firstBounds.end.column...-(@lines[secondBounds.start.line].length - secondBounds.start.column)]

            if infix.indexOf('+') is -1
              return

          # Treat unary - and + specially if they surround a literal: then
          # they should just be sucked into the literal.
          if node.first and not node.second and node.operator in ['+', '-'] and
              node.first?.base?.nodeType?() is 'Literal'
            return

          @csBlock node, depth, OPERATOR_PRECEDENCES[node.operator], 'value', wrappingParen, VALUE_ONLY

          @csSocketAndMark node.first, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth

          if node.second?
            @csSocketAndMark node.second, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth

        # ### Existence ###
        # Color VALUE, socket @expression, precedence 100
        when 'Existence'
          @csBlock node, depth, 100, 'value', wrappingParen, VALUE_ONLY
          @csSocketAndMark node.expression, depth + 1, 101, indentDepth

        # ### In ###
        # Color VALUE, sockets @object and @array, precedence 100
        when 'In'
          @csBlock node, depth, 0, 'value', wrappingParen, VALUE_ONLY
          @csSocketAndMark node.object, depth + 1, 0, indentDepth
          @csSocketAndMark node.array, depth + 1, 0, indentDepth

        # ### Value ###
        # Completely pass through to @base; we do not care
        # about this node.
        when 'Value'
          if node.properties? and node.properties.length > 0
            @csBlock node, depth, 0, 'value', wrappingParen, MOSTLY_VALUE
            @csSocketAndMark node.base, depth + 1, 0, indentDepth
            for property in node.properties
              if property.nodeType() is 'Access'
                @csSocketAndMark property.name, depth + 1, -2, indentDepth, {
                    'works-as-method-call': helper.ENCOURAGE_ALL
                    'default': helper.FORBID
                  }
              else if property.nodeType() is 'Index'
                @csSocketAndMark property.index, depth + 1, 0, indentDepth

          # Fake-remove backticks hack
          else if node.base.nodeType() is 'Literal' and
              node.base.value is ''
            fakeBlock =
                @csBlock node.base, depth, 0, 'value', wrappingParen, ANY_DROP
            fakeBlock.flagToRemove = true

          # Preserved-error backticks hack
          else if node.base.nodeType() is 'Literal' and
              /^#/.test(node.base.value)
            @csBlock node.base, depth, 0, 'blank', wrappingParen, ANY_DROP
            errorSocket = @csSocket node.base, depth + 1, -2
            errorSocket.flagToStrip = { left: 2, right: 1 }

          else
            @mark node.base, depth + 1, 0, wrappingParen, indentDepth

        # ### Keywords ###
        when 'Literal'
          if node.value in STATEMENT_KEYWORDS
            # handle break and continue
            @csBlock node, depth, 0, 'return', wrappingParen, BLOCK_ONLY
          else
            # otherwise, leave it as a white block
            0

        # ### Literal ###
        # No-op. Translate directly to text
        when 'Literal', 'Bool', 'Undefined', 'Null' then 0

        # ### Call ###
        # Color COMMAND, sockets @variable and @args.
        # We will not add a socket around @variable when it
        # is only some text
        when 'Call'
          if node.variable?
            methodname = null
            unrecognized = false
            if node.variable.properties?.length > 0
              methodname = node.variable.
                  properties[node.variable.properties.length - 1].name?.value
            else if node.variable.base?.value
              methodname = node.variable.base.value
            if methodname in BLOCK_FUNCTIONS
              @csBlock node, depth, 0, 'command', wrappingParen, MOSTLY_BLOCK
            else if methodname in VALUE_FUNCTIONS
              @csBlock node, depth, 0, 'value', wrappingParen, MOSTLY_VALUE
            else
              @csBlock node, depth, 0, 'command', wrappingParen, ANY_DROP
              unrecognized = not(methodname in EITHER_FUNCTIONS)

            # Deal with weird coffeescript rewrites, e.g., /// #{x} ///
            # is rewritten to RegExp(...)
            if methodname?.length > 1 and node?.variable?.locationData and
                node.variable.locationData.first_column is
                node.variable.locationData.last_column and
                node.variable.locationData.first_line is
                node.variable.locationData.last_line
              unrecognized = false

            if unrecognized or node.variable.base?.nodeType() isnt 'Literal'
              @csSocketAndMark node.variable, depth + 1, 0, indentDepth
            else if node.variable.properties?.length > 0
              @csSocketAndMark node.variable.base, depth + 1, 0, indentDepth
          else
            @csBlock node, depth, 0, 'command', wrappingParen, ANY_DROP

          unless node.do
            for arg, index in node.args
              precedence = 0
              # special case: the last argument slot of a function
              # gathers anything inside it, without parens needed.
              if index is node.args.length - 1 then precedence = -1
              @csSocketAndMark arg, depth + 1, precedence, indentDepth

        # ### Code ###
        # Function definition. Color VALUE, sockets @params,
        # and indent @body.
        when 'Code'
          @csBlock node, depth, 0, 'value', wrappingParen, VALUE_ONLY

          for param in node.params
            @csSocketAndMark param, depth + 1, 0, indentDepth, SAY_FORBID

          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Assign ###
        # Color COMMAND, sockets @variable and @value.
        when 'Assign'
          @csBlock node, depth, 0, 'command', wrappingParen, MOSTLY_BLOCK
          @csSocketAndMark node.variable, depth + 1, 0, indentDepth, {
            'Value': helper.NORMAL
            'default': helper.FORBID
          }

          @csSocketAndMark node.value, depth + 1, 0, indentDepth

        # ### For ###
        # Color CONTROL, options sockets @index, @source, @name, @from.
        # Indent/socket @body.
        when 'For'
          @csBlock node, depth, -3, 'control', wrappingParen, MOSTLY_BLOCK

          for childName in ['source', 'from', 'guard', 'step']
            if node[childName]? then @csSocketAndMark node[childName], depth + 1, 0, indentDepth

          for childName in ['index', 'name']
            if node[childName]? then @csSocketAndMark node[childName], depth + 1, 0, indentDepth, SAY_FORBID

          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Range ###
        # Color VALUE, sockets @from and @to.
        when 'Range'
          @csBlock node, depth, 100, 'value', wrappingParen, VALUE_ONLY
          @csSocketAndMark node.from, depth, 0, indentDepth
          @csSocketAndMark node.to, depth, 0, indentDepth

        # ### If ###
        # Color CONTROL, socket @condition.
        # indent/socket body, optional indent/socket node.elseBody.
        #
        # Special case: "unless" keyword; in this case
        # we want to skip the Op that wraps the condition.
        when 'If'
          @csBlock node, depth, 0, 'control', wrappingParen, MOSTLY_BLOCK

          # Check to see if we are an "unless".
          # We will deem that we are an unless if:
          #   - Our starting line contains "unless" and
          #   - Our condition starts at the same location as
          #     ourselves.

          # Note: for now, we have hacked CoffeeScript
          # to give us the raw condition location data.
          #
          # Perhaps in the future we should do this at
          # wrapper level.

          ###
          bounds = @getBounds node
          if @lines[bounds.start.line].indexOf('unless') >= 0 and
              @locationsAreIdentical(bounds.start, @getBounds(node.condition).start) and
              node.condition.nodeType() is 'Op'

            @csSocketAndMark node.condition.first, depth + 1, 0, indentDepth
          else
          ###

          @csSocketAndMark node.rawCondition, depth + 1, 0, indentDepth

          @mark node.body, depth + 1, 0, null, indentDepth

          if node.elseBody?
            # Artificially "mark" the line containing the "else"
            # token, so that the following body can be single-line
            # if necessary.
            @flagLineAsMarked node.elseToken.first_line

            @mark node.elseBody, depth + 1, 0, null, indentDepth

        # ### Arr ###
        # Color VALUE, sockets @objects.
        when 'Arr'
          @csBlock node, depth, 100, 'value', wrappingParen, VALUE_ONLY
          for object in node.objects
            @csSocketAndMark object, depth + 1, 0, indentDepth

        # ### Return ###
        # Color RETURN, optional socket @expression.
        when 'Return'
          @csBlock node, depth, 0, 'return', wrappingParen, BLOCK_ONLY
          if node.expression?
            @csSocketAndMark node.expression, depth + 1, 0, indentDepth

        # ### While ###
        # Color CONTROL. Socket @condition, socket/indent @body.
        when 'While'
          @csBlock node, depth, -3, 'control', wrappingParen, MOSTLY_BLOCK
          @csSocketAndMark node.rawCondition, depth + 1, 0, indentDepth
          if node.guard? then @csSocketAndMark node.guard, depth + 1, 0, indentDepth
          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Switch ###
        # Color CONTROL. Socket @subject, optional sockets @cases[x][0],
        # indent/socket @cases[x][1]. indent/socket @otherwise.
        when 'Switch'
          @csBlock node, depth, 0, 'control', wrappingParen, MOSTLY_BLOCK

          if node.subject? then @csSocketAndMark node.subject, depth + 1, 0, indentDepth

          for switchCase in node.cases
            if switchCase[0].constructor is Array
              for condition in switchCase[0]
                @csSocketAndMark condition, depth + 1, 0, indentDepth # (condition)
            else
              @csSocketAndMark switchCase[0], depth + 1, 0, indentDepth # (condition)
            @mark switchCase[1], depth + 1, 0, null, indentDepth # (body)

          if node.otherwise?
            @mark node.otherwise, depth + 1, 0, null, indentDepth

        # ### Class ###
        # Color CONTROL. Optional sockets @variable, @parent. Optional indent/socket
        # @obdy.
        when 'Class'
          @csBlock node, depth, 0, 'control', wrappingParen, ANY_DROP

          if node.variable? then @csSocketAndMark node.variable, depth + 1, 0, indentDepth, SAY_FORBID
          if node.parent? then @csSocketAndMark node.parent, depth + 1, 0, indentDepth

          if node.body? then @mark node.body, depth + 1, 0, null, indentDepth

        # ### Obj ###
        # Color VALUE. Optional sockets @property[x].variable, @property[x].value.
        # TODO: This doesn't quite line up with what we want it to be visually;
        # maybe our View architecture is wrong.
        when 'Obj'
          @csBlock node, depth, 0, 'value', wrappingParen, VALUE_ONLY

          for property in node.properties
            if property.nodeType() is 'Assign'
              @csSocketAndMark property.variable, depth + 1, 0, indentDepth, SAY_FORBID
              @csSocketAndMark property.value, depth + 1, 0, indentDepth


    locationsAreIdentical: (a, b) ->
      return a.line is b.line and a.column is b.column

    boundMin: (a, b) ->
      if a.line < b.line then a
      else if b.line < a.line then b
      else if a.column < b.column then a
      else b

    boundMax: (a, b) ->
      if a.line < b.line then b
      else if b.line < a.line then a
      else if a.column < b.column then b
      else a

    # ## getBounds ##
    # Get the boundary locations of a CoffeeScript node,
    # using CoffeeScript location data and
    # adjust to deal with some quirks.
    getBounds: (node) ->
      # Most of the time, we can just
      # take CoffeeScript locationData.
      bounds =
        start:
          line: node.locationData.first_line
          column: node.locationData.first_column
        end:
          line: node.locationData.last_line
          column: node.locationData.last_column + 1

      # There are four cases where CoffeeScript
      # actually gets location data wrong.

      # The first is CoffeeScript 'Block's,
      # which give us only the first line.
      # So we need to adjust.
      if node.nodeType() is 'Block'
        # If we have any child expressions,
        # set the end boundary to be the end
        # of the last one
        if node.expressions.length > 0
          bounds.end = @getBounds(node.expressions[node.expressions.length - 1]).end

        #If we have no child expressions, make the bounds actually empty.
        else
          bounds.start = bounds.end

      # The second is 'If' statements,
      # which do not surround the elseBody
      # when it exists.
      if node.nodeType() is 'If'
        bounds.start = @boundMin bounds.start, @getBounds(node.body).start
        bounds.end = @boundMax @getBounds(node.rawCondition).end, @getBounds(node.body).end

        if node.elseBody?
          bounds.end = @boundMax bounds.end, @getBounds(node.elseBody).end

      # The third is 'While', which
      # fails to surround the loop body,
      # or sometimes the loop guard.
      if node.nodeType() is 'While'
        bounds.start = @boundMin bounds.start, @getBounds(node.body).start
        bounds.end = @boundMax bounds.end, @getBounds(node.body).end

        if node.guard?
          bounds.end = @boundMax bounds.end, @getBounds(node.guard).end

      # Hack: Functions should end immediately
      # when their bodies end.
      if node.nodeType() is 'Code' and node.body?
        bounds.end = @getBounds(node.body).end

      # The fourth is general. Sometimes we get
      # spaces at the start of the next line.
      # We don't want those spaces; discard them.
      while @lines[bounds.end.line][...bounds.end.column].trim().length is 0
        bounds.end.line -= 1
        bounds.end.column = @lines[bounds.end.line].length + 1

      # When we have a 'Value' object,
      # its base may have some exceptions in it,
      # in which case we want to pass on to
      # those.
      if node.nodeType() is 'Value'
        bounds = @getBounds node.base

        if node.properties? and node.properties.length > 0
          for property in node.properties
            bounds.end = @boundMax bounds.end, @getBounds(property).end

      return bounds

    flagLineAsMarked: (line) ->
      @hasLineBeenMarked[line] = true
      while @lines[line][@lines[line].length - 1] is '\\'
        line += 1
        @hasLineBeenMarked[line] = true

    # ## addMarkup ##
    # Override addMarkup to flagLineAsMarked
    addMarkup: (container, bounds, depth) ->
      super

      @flagLineAsMarked bounds.start.line

    # ## csBlock ##
    # A general utility function for adding an ICE editor
    # block around a given node.
    csBlock: (node, depth, precedence, color, wrappingParen, socketLevel) ->
      @addBlock {
        bounds: @getBounds (wrappingParen ? node)
        depth: depth
        precedence: precedence
        color: color
        socketLevel: socketLevel
        classes: getClassesFor node
        parenWrapped: wrappingParen?
      }

    # ## csSocket ##
    # A similar utility function for adding sockets.
    csSocket: (node, depth, precedence, accepts = SAY_NORMAL) ->
      @addSocket {
        bounds: @getBounds node
        depth: depth
        precedence: precedence
        accepts: accepts
      }

    # ## csSocketAndMark ##
    # Adds a socket for a node, and recursively @marks it.
    csSocketAndMark: (node, depth, precedence, indentDepth, accepts = SAY_NORMAL) ->
      socket = @csSocket node, depth, precedence, accepts
      @mark node, depth + 1, precedence, null, indentDepth
      return socket

    # ## wrapSemicolonLine ##
    # Wrap a single line in a block
    # for semicolons.
    wrapSemicolonLine: (firstBounds, lastBounds, expressions, depth) ->
      surroundingBounds = {
        start: firstBounds.start
        end: lastBounds.end
      }
      @addBlock {
        bounds: surroundingBounds
        depth: depth + 1
        precedence: -2
        color: 'command'
        socketLevel: ANY_DROP
        classes: ['semicolon']
      }

      # Add sockets for each expression
      for child in expressions
        @csSocket child, depth + 2, -2

    # ## wrapSemicolons ##
    # If there are mutliple expressions we have on the same line,
    # add a semicolon block around them.
    wrapSemicolons: (expressions, depth) ->
      # We will keep track of the first and last
      # nodes on the current line, and their bounds.
      firstNode = lastNode =
        firstBounds = lastBounds = null

      # We will also keep track of the nodes
      # that are on this line, so that
      # we can surround them in sockets
      # in the future.
      nodesOnCurrentLine = []

      for expr in expressions
        # Get the bounds for this expression
        bounds = @getBounds expr

        # If we are on the same line as the last expression, update
        # lastNode to reflect.
        if bounds.start.line is firstBounds?.end.line
          lastNode = expr; lastBounds = bounds
          nodesOnCurrentLine.push expr

        # Otherwise, we are on a new line.
        # See if the previous line needed a semicolon wrapper

        # If there were at least two blocks on the previous line,
        # they do need a semicolon wrapper.
        else
          if lastNode?
            @wrapSemicolonLine firstBounds, lastBounds, nodesOnCurrentLine, depth

          # Regardless of whether or not we added semicolons on the last line,
          # clear the records to make way for the new line.
          firstNode = expr; lastNode = null
          firstBounds = @getBounds expr; lastBounds = null
          nodesOnCurrentLine = [expr]

      # Wrap up the last line if necessary.
      if lastNode?
        @wrapSemicolonLine firstBounds, lastBounds, nodesOnCurrentLine, depth

  # ERROR RECOVERY
  # =============

  fixCoffeeScriptError = (lines, e) ->
    console.log 'encountered error', e.message, 'line',  e.location?.first_line
    if /unexpected\s*(?:newline|if|for|while|switch|unless|end of input)/.test(
        e.message) and /^\s*(?:if|for|while|unless)\s+\S+/.test(
        lines[e.location.first_line])
      return addEmptyBackTickLineAfter lines, e.location.first_line
    if /unexpected/.test(e.message)
      return backTickLine lines, e.location.first_line

    if /missing "/.test(e.message) and '"' in lines[e.location.first_line]
      return backTickLine lines, e.location.first_line

    # Try to find the line with an opening unmatched thing
    if /unmatched|missing \)/.test(e.message)
      unmatchedline = findUnmatchedLine lines, e.location.first_line
      if unmatchedline isnt null
        return backTickLine lines, unmatchedline
    return null

  findUnmatchedLine = (lines, above) ->
    # Not done yet
    return null

  backTickLine = (lines, n) ->
    if n < 0 or n >= lines.length
      return false
    # This strategy fails if the line is already backticked or is empty.
    if /`/.test(lines[n]) or /^\s*$/.test(lines[n])
      return false
    lines[n] = lines[n].replace /^(\s*)(\S.*\S|\S)(\s*)$/, '$1`#$2`$3'
    return true

  addEmptyBackTickLineAfter = (lines, n) ->
    if n < 0 or n >= lines.length
      return false
    # Refuse to add another empty backtick line if there is one already
    if n + 1 < lines.length and /^\s*``$/.test lines[n + 1]
      return false
    leading = /^\s*/.exec lines[n]
    # If we are all spaces then fail.
    if not leading or leading[0].length >= lines[n].length
      return false
    lines.splice n + 1, 0, leading[0] + '  ``'

  exports.parse = (text, opts) ->
    opts ?= wrapAtRoot: true
    parser = new CoffeeScriptParser text
    return parser.parse opts

  exports.parens = (leading, trailing, node, context) ->
    if context is null or context.type isnt 'socket' or
        context.precedence < node.precedence
      while true
        if leading.match(/^\s*\(/)? and trailing.match(/\)\s*/)?
          leading = leading.replace(/^\s*\(\s*/, '')
          trailing = trailing.replace(/^\s*\)\s*/, '')
        else
          break
    else
      leading = '(' + leading
      trailing = trailing + ')'

    return [leading, trailing]

  exports.empty = "``"

  return exports
