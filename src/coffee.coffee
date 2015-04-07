# # ICE Editor CoffeeScript mode
#
# Copyright (c) Anthony Bau
# MIT License

define ['droplet-helper', 'droplet-model', 'droplet-parser', 'coffee-script'], (helper, model, parser, CoffeeScript) ->
  exports = {}


  ANY_DROP = ['any-drop']
  BLOCK_ONLY = ['block-only']
  MOSTLY_BLOCK = ['mostly-block']
  MOSTLY_VALUE = ['mostly-value']
  VALUE_ONLY = ['value-only']
  LVALUE = ['lvalue']
  FORBID_ALL = ['forbid-all']
  PROPERTY_ACCESS = ['prop-access']

  KNOWN_FUNCTIONS =
    'alert'       : {}
    'prompt'      : {}
    'console.log' : {}
    'Math.abs'    : {value: true}
    'Math.acos'   : {value: true}
    'Math.asin'   : {value: true}
    'Math.atan'   : {value: true}
    'Math.atan2'  : {value: true}
    'Math.cos'    : {value: true}
    'Math.sin'    : {value: true}
    'Math.tan'    : {value: true}
    'Math.ceil'   : {value: true}
    'Math.floor'  : {value: true}
    'Math.round'  : {value: true}
    'Math.exp'    : {value: true}
    'Math.ln'     : {value: true}
    'Math.log10'  : {value: true}
    'Math.pow'    : {value: true}
    'Math.sqrt'   : {value: true}
    'Math.max'    : {value: true}
    'Math.min'    : {value: true}
    'Math.random' : {value: true}

  STATEMENT_KEYWORDS = [
    'break'
    'continue'
  ]

  CATEGORIES = {
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

  NODE_CATEGORY = {
    Parens: 'command'
    Op: 'value'         # overridden by operator test
    Existence: 'logic'
    In: 'logic'
    Value: 'value'
    Literal: 'value'    # overridden by break, continue, errors
    Call: 'command'     # overridden by complicated logic
    Code: 'functions'
    Class: 'functions'
    Assign: 'command'   # overriden by test for function definition
    For: 'loops'
    While: 'loops'
    If: 'conditionals'
    Switch: 'conditionals'
    Range: 'containers'
    Arr: 'containers'
    Obj: 'containers'
    Return: 'returns'
  }

  LOGICAL_OPERATORS = {
    '==': true
    '!=': true
    '===': true
    '!==': true
    '<': true
    '<=': true
    '>': true
    '>=': true
    'in': true
    'instanceof': true
    '||': true
    '&&': true
    '!': true
  }

  ###
  OPERATOR_PRECEDENCES =
    '*': 5
    '/': 5
    '%': 5
    '+': 6
    '-': 6
    '<<': 7
    '>>': 7
    '>>>': 7
    '<': 8
    '>': 8
    '>=': 8
    'in': 8
    'instanceof': 8
    '==': 9
    '!=': 9
    '===': 9
    '!==': 9
    '&': 10
    '^': 11
    '|': 12
    '&&': 13
    '||': 14
  ###

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

  YES = -> yes
  NO = -> no

  spacestring = (n) -> (' ' for [0...Math.max(0, n)]).join('')

  getClassesFor = (node) ->
    classes = []

    classes.push node.nodeType()
    if node.nodeType() is 'Call' and (not node.do) and (not node.isNew)
      classes.push 'works-as-method-call'

    return classes

  annotateCsNodes = (tree) ->
    tree.eachChild (child) ->
      child.dropletParent = tree
      annotateCsNodes child
    return tree

  exports.CoffeeScriptParser = class CoffeeScriptParser extends parser.Parser
    constructor: (@text, opts) ->
      super

      @opts.functions ?= KNOWN_FUNCTIONS
      @opts.categories = helper.extend({}, CATEGORIES, @opts.categories)

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
          tree = CoffeeScript.nodes(@text)
          annotateCsNodes tree
          nodes = tree.expressions
          break
        catch e
          firstError ?= e
          if retries > 0 and fixCoffeeScriptError @lines, e
            @text = @lines.join '\n'
          else
            # If recovery isn't possible, insert a loc object with
            # the possible location of the error, and throw the error.
            if firstError.location
              firstError.loc =
                line: firstError.location.first_line
                column: firstError.location.first_column
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
      try
        tokens = CoffeeScript.tokens @text,
          rewrite: false
          preserveComments: true
      catch syntaxError
        # Right now, we do not attempt to recover from failures in tokenization
        if syntaxError.location
          syntaxError.loc =
            line: syntaxError.location.first_line
            column: syntaxError.location.first_column
        throw syntaxError

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

    functionNameNodes: (node) ->
      if node.nodeType() isnt 'Call' then throw new Error
      if node.variable?
        # Two possible forms of a Call node:
        # fn(...) ->
        #    node.variable.base = fn
        # x.y.z.fn()
        #    node.variable.base = x
        #    properties = [y, z, fn]
        nodes = []
        if node.variable.base?.value
          nodes.push node.variable.base
        else
          nodes.push null
        if node.variable.properties?
          for prop in node.variable.properties
              nodes.push prop.name
        return nodes
      return []

    emptyLocation: (loc) ->
      loc.first_column is loc.last_column and loc.first_line is loc.last_line

    implicitName: (nn) ->
      # Deal with weird coffeescript rewrites, e.g., /// #{x} ///
      # is rewritten to RegExp(...)
      if nn.length is 0 then return false
      node = nn[nn.length - 1]
      return node?.value?.length > 1 and @emptyLocation node.locationData

    lookupFunctionName: (nn) ->
      # Test the name nodes list against the given list, and return
      # null if not found, or a tuple of information about the match.
      if nn.length > 1
        full = (nn.map (n) -> n?.value or '*').join '.'
        if full of @opts.functions
          return name: full, dotted: true, fn: @opts.functions[full]
      last = nn[nn.length - 1]
      if last? and last.value of @opts.functions
        return name: last.value, dotted: false, fn: @opts.functions[last.value]
      return null

    # ## addCode ##
    # This shared logic handles the sockets for the Code function
    # definitions, even when merged into a parent block.
    addCode: (node, depth, indentDepth) ->
      for param in node.params
        @csSocketAndMark param, depth, 0, indentDepth, FORBID_ALL
      @mark node.body, depth, 0, null, indentDepth

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
                @csBlock node, depth, -2, null, MOSTLY_BLOCK

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

          @csBlock node, depth, OPERATOR_PRECEDENCES[node.operator], wrappingParen, VALUE_ONLY

          @csSocketAndMark node.first, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth

          if node.second?
            @csSocketAndMark node.second, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth

        # ### Existence ###
        # Color VALUE, socket @expression, precedence 100
        when 'Existence'
          @csBlock node, depth, 100, wrappingParen, VALUE_ONLY
          @csSocketAndMark node.expression, depth + 1, 101, indentDepth

        # ### In ###
        # Color VALUE, sockets @object and @array, precedence 100
        when 'In'
          @csBlock node, depth, 0, wrappingParen, VALUE_ONLY
          @csSocketAndMark node.object, depth + 1, 0, indentDepth
          @csSocketAndMark node.array, depth + 1, 0, indentDepth

        # ### Value ###
        # Completely pass through to @base; we do not care
        # about this node.
        when 'Value'
          if node.properties? and node.properties.length > 0
            @csBlock node, depth, 0, wrappingParen, MOSTLY_VALUE
            @csSocketAndMark node.base, depth + 1, 0, indentDepth
            for property in node.properties
              if property.nodeType() is 'Access'
                @csSocketAndMark property.name, depth + 1, -2, indentDepth, PROPERTY_ACCESS
              else if property.nodeType() is 'Index'
                @csSocketAndMark property.index, depth + 1, 0, indentDepth

          # Fake-remove backticks hack
          else if node.base.nodeType() is 'Literal' and
              node.base.value is ''
            fakeBlock =
                @csBlock node.base, depth, 0, wrappingParen, ANY_DROP
            fakeBlock.flagToRemove = true

          # Preserved-error backticks hack
          else if node.base.nodeType() is 'Literal' and
              /^#/.test(node.base.value)
            @csBlock node.base, depth, 0, wrappingParen, ANY_DROP
            errorSocket = @csSocket node.base, depth + 1, -2
            errorSocket.flagToStrip = { left: 2, right: 1 }

          else
            @mark node.base, depth + 1, 0, wrappingParen, indentDepth

        # ### Keywords ###
        when 'Literal'
          if node.value in STATEMENT_KEYWORDS
            # handle break and continue
            @csBlock node, depth, 0, wrappingParen, BLOCK_ONLY
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
            namenodes = @functionNameNodes node
            known = @lookupFunctionName namenodes
            if known
              if known.fn.value
                classes = if known.fn.command then ANY_DROP else MOSTLY_VALUE
              else
                classes = MOSTLY_BLOCK
            else
              classes = ANY_DROP
            @csBlock node, depth, 0, wrappingParen, classes

            # Some function names (like /// RegExps ///) are never editable.
            if @implicitName namenodes
              # do nothing
            else if not known
              # In the 'advanced' case where the methodname should be
              # editable, treat the whole (x.y.fn) as an expression to socket.
              @csSocketAndMark node.variable, depth + 1, 0, indentDepth
            else if not known.dotted and node.variable.properties?.length > 0
              # In the 'beginner' case of a simple method call with a
              # simple base object variable, let the variable be socketed.
              @csSocketAndMark node.variable.base, depth + 1, 0, indentDepth
          else
            @csBlock node, depth, 0, wrappingParen, ANY_DROP

          unless node.do
            for arg, index in node.args
              last = index is node.args.length - 1
              # special case: the last argument slot of a function
              # gathers anything inside it, without parens needed.
              precedence = if last then -1 else 0
              if last and arg.nodeType() is 'Code'
                # Inline function definitions that appear as the last arg
                # of a function call will be melded into the parent block.
                @addCode arg, depth + 1, indentDepth
              else
                @csSocketAndMark arg, depth + 1, precedence, indentDepth, null, known?.fn?.dropdown?[index]

        # ### Code ###
        # Function definition. Color VALUE, sockets @params,
        # and indent @body.
        when 'Code'
          @csBlock node, depth, 0, wrappingParen, VALUE_ONLY
          @addCode node, depth + 1, indentDepth

        # ### Assign ###
        # Color COMMAND, sockets @variable and @value.
        when 'Assign'
          @csBlock node, depth, 0, wrappingParen, MOSTLY_BLOCK
          @csSocketAndMark node.variable, depth + 1, 0, indentDepth, LVALUE

          if node.value.nodeType() is 'Code'
            @addCode node.value, depth + 1, indentDepth
          else
            @csSocketAndMark node.value, depth + 1, 0, indentDepth

        # ### For ###
        # Color CONTROL, options sockets @index, @source, @name, @from.
        # Indent/socket @body.
        when 'For'
          @csBlock node, depth, -3, wrappingParen, MOSTLY_BLOCK

          for childName in ['source', 'from', 'guard', 'step']
            if node[childName]? then @csSocketAndMark node[childName], depth + 1, 0, indentDepth

          for childName in ['index', 'name']
            if node[childName]? then @csSocketAndMark node[childName], depth + 1, 0, indentDepth, FORBID_ALL

          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Range ###
        # Color VALUE, sockets @from and @to.
        when 'Range'
          @csBlock node, depth, 100, wrappingParen, VALUE_ONLY
          @csSocketAndMark node.from, depth, 0, indentDepth
          @csSocketAndMark node.to, depth, 0, indentDepth

        # ### If ###
        # Color CONTROL, socket @condition.
        # indent/socket body, optional indent/socket node.elseBody.
        #
        # Special case: "unless" keyword; in this case
        # we want to skip the Op that wraps the condition.
        when 'If'
          @csBlock node, depth, 0, wrappingParen, MOSTLY_BLOCK

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
          @csBlock node, depth, 100, wrappingParen, VALUE_ONLY

          if node.objects.length > 0
            @csIndentAndMark indentDepth, node.objects, depth + 1
          for object in node.objects
            if object.nodeType() is 'Value' and object.base.nodeType() is 'Literal' and
                object.properties?.length in [0, undefined]
              @csBlock object, depth + 2, 100, null, VALUE_ONLY

        # ### Return ###
        # Color RETURN, optional socket @expression.
        when 'Return'
          @csBlock node, depth, 0, wrappingParen, BLOCK_ONLY
          if node.expression?
            @csSocketAndMark node.expression, depth + 1, 0, indentDepth

        # ### While ###
        # Color CONTROL. Socket @condition, socket/indent @body.
        when 'While'
          @csBlock node, depth, -3, wrappingParen, MOSTLY_BLOCK
          @csSocketAndMark node.rawCondition, depth + 1, 0, indentDepth
          if node.guard? then @csSocketAndMark node.guard, depth + 1, 0, indentDepth
          @mark node.body, depth + 1, 0, null, indentDepth

        # ### Switch ###
        # Color CONTROL. Socket @subject, optional sockets @cases[x][0],
        # indent/socket @cases[x][1]. indent/socket @otherwise.
        when 'Switch'
          @csBlock node, depth, 0, wrappingParen, MOSTLY_BLOCK

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
          @csBlock node, depth, 0, wrappingParen, ANY_DROP

          if node.variable? then @csSocketAndMark node.variable, depth + 1, 0, indentDepth, FORBID_ALL
          if node.parent? then @csSocketAndMark node.parent, depth + 1, 0, indentDepth

          if node.body? then @mark node.body, depth + 1, 0, null, indentDepth

        # ### Obj ###
        # Color VALUE. Optional sockets @property[x].variable, @property[x].value.
        # TODO: This doesn't quite line up with what we want it to be visually;
        # maybe our View architecture is wrong.
        when 'Obj'
          @csBlock node, depth, 0, wrappingParen, VALUE_ONLY

          for property in node.properties
            if property.nodeType() is 'Assign'
              @csSocketAndMark property.variable, depth + 1, 0, indentDepth, FORBID_ALL
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

      # Special case to deal with commas in arrays:
      if node.dropletParent?.nodeType?() is 'Arr' or
         node.dropletParent?.nodeType?() is 'Value' and node.dropletParent.dropletParent?.nodeType?() is 'Arr'
        match = @lines[bounds.end.line][bounds.end.column...].match(/^\s*,\s*/)
        if match?
          bounds.end.column += match[0].length

      return bounds

    # ## getColor ##
    # Looks up color of the given node, respecting options.
    getColor: (node) ->
      category = NODE_CATEGORY[node.nodeType()] or 'command'
      switch node.nodeType()
        when 'Op'
          if LOGICAL_OPERATORS[node.operator]
            category = 'logic'
          else
            category = 'arithmetic'
        when 'Call'
          if node.variable?
            namenodes = @functionNameNodes node
            known = @lookupFunctionName namenodes
            if known
              if known.fn.value
                category = known.fn.color or
                  if known.fn.command then 'command' else 'value'
              else
                category = known.fn.color or 'command'
        when 'Assign'
          # Assignments with a function RHS are function definitions
          if node.value.nodeType() is 'Code'
            category = 'functions'
        when 'Literal'
          # Preserved errors
          if /^#/.test(node.value)
            category = 'error'
          # break and continue
          else if node.value in STATEMENT_KEYWORDS
            category = 'returns'
      return @opts.categories[category]?.color or category

    # ## flagLineAsMarked ##
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

      return container

    # ## csBlock ##
    # A general utility function for adding an ICE editor
    # block around a given node.
    csBlock: (node, depth, precedence, wrappingParen, classes = []) ->
      @addBlock {
        bounds: @getBounds (wrappingParen ? node)
        depth: depth
        precedence: precedence
        color: @getColor(node)
        classes: getClassesFor(node).concat classes
        parenWrapped: wrappingParen?
      }

    # Add an indent node and guess
    # at the indent depth
    csIndent: (indentDepth, firstNode, lastNode, depth) ->
      first = @getBounds(firstNode).start
      last = @getBounds(lastNode).end

      if @lines[first.line][...first.column].trim().length is 0
        first.line -= 1
        first.column = @lines[first.line].length

      if first.line isnt last.line
        trueDepth = @lines[last.line].length - @lines[last.line].trimLeft().length
        prefix = @lines[last.line][indentDepth...trueDepth]
      else
        trueDepth = indentDepth + 2
        prefix = '  '

      @addIndent {
        bounds: {
          start: first
          end: last
        }
        depth: depth

        prefix: prefix
      }

      return trueDepth

    csIndentAndMark: (indentDepth, nodes, depth) ->
      trueDepth = @csIndent indentDepth, nodes[0], nodes[nodes.length - 1], depth
      for node in nodes
        @mark node, depth + 1, 0, null, trueDepth

    # ## csSocket ##
    # A similar utility function for adding sockets.
    csSocket: (node, depth, precedence, classes = [], dropdown) ->
      @addSocket {
        bounds: @getBounds node
        depth, precedence, dropdown
        classes: getClassesFor(node).concat classes
      }

    # ## csSocketAndMark ##
    # Adds a socket for a node, and recursively @marks it.
    csSocketAndMark: (node, depth, precedence, indentDepth, classes, dropdown) ->
      socket = @csSocket node, depth, precedence, classes, dropdown
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
        color: @opts.categories['command'].color
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

  CoffeeScriptParser.empty = "``"

  CoffeeScriptParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      if 'forbid-all' in context.classes
        return helper.FORBID

      if 'lvalue' in context.classes
        if 'Value' in block.classes and block.properties?.length > 0
          return helper.ENCOURAGE
        else
          return helper.FORBID

      else if 'property-access' in context.classes
        if 'works-as-method-call' in block.classes
          return helper.ENCOURAGE
        else
          return helper.FORBID

      else if 'value-only' in block.classes or
          'mostly-value' in block.classes or
          'any-drop' in block.classes
        return helper.ENCOURAGE

      else if 'mostly-block' in block.classes
        return helper.DISCOURAGE

    else if context.type in ['indent', 'segment']
      if 'block-only' in block.classes or
          'mostly-block' in block.classes or
          'any-drop' in block.classes or
          block.type is 'segment'
        return helper.ENCOURAGE

      else if 'mostly-value' in block.classes
        return helper.DISCOURAGE

    return helper.DISCOURAGE

  CoffeeScriptParser.parens = (leading, trailing, node, context) ->
    trailing trailing().replace /\s*,\s*$/, ''
    if context is null or context.type isnt 'socket' or
        context.precedence < node.precedence
      while true
        if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
          leading leading().replace(/^\s*\(\s*/, '')
          trailing trailing().replace(/\s*\)\s*$/, '')
        else
          break
    else
      leading '(' + leading()
      trailing trailing() + ')'

    return

  return parser.wrapParser CoffeeScriptParser
