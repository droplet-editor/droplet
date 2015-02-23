define ['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], (helper, model, parser, acorn) ->
  exports = {}

  STATEMENT_NODE_TYPES = [
    'ExpressionStatement'
    'ReturnStatement'
    'BreakStatement'
    'ThrowStatement'
  ]

  NEVER_PAREN = 100

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
    'write'
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
    'alert'
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
    'table'
    'append'
    'finish'
    'loadscript'
  ]


  COLORS = {
    'BinaryExpression': 'value'
    'UnaryExpression': 'value'
    'FunctionExpression': 'value'
    'FunctionDeclaration': 'violet'
    'AssignmentExpression': 'command'
    'CallExpression': 'command'
    'ReturnStatement': 'return'
    'MemberExpression': 'value'
    'IfStatement': 'control'
    'ForStatement': 'control'
    'ForInStatement': 'control'
    'UpdateExpression': 'command'
    'VariableDeclaration': 'command'
    'LogicalExpression': 'value'
    'WhileStatement': 'control'
    'DoWhileStatement': 'control'
    'ObjectExpression': 'value'
    'SwitchStatement': 'control'
    'BreakStatement': 'return'
    'NewExpression': 'command'
    'ThrowStatement': 'return'
    'TryStatement': 'control'
    'ArrayExpression': 'value'
    'SequenceExpression': 'command'
    'ConditionalExpression': 'value'
  }

  OPERATOR_PRECEDENCES = {
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
    '^': 10
    '|': 10
    '&&': 10
    '||': 10
  }

  CLASS_EXCEPTIONS = {
    'ForStatement': ['ends-with-brace', 'block-only']
    'FunctionDeclaration': ['ends-with-brace', 'block-only']
    'IfStatement': ['ends-with-brace', 'block-only']
    'WhileStatement': ['ends-with-brace', 'block-only']
    'DoWhileStatement': ['ends-with-brace', 'block-only']
    'SwitchStatement': ['ends-with-brace', 'block-only']
    'AssignmentExpression': ['mostly-block']
  }

  DEFAULT_INDENT_DEPTH = '  '

  exports.JavaScriptParser = class JavaScriptParser extends parser.Parser
    constructor: (@text, @opts = {}) ->
      super

      @opts.blockFunctions ?= BLOCK_FUNCTIONS
      @opts.valueFunctions ?= VALUE_FUNCTIONS
      @opts.eitherFunctions ?= EITHER_FUNCTIONS
      @functionWhitelist = @opts.blockFunctions.concat(@opts.eitherFunctions).concat(@opts.valueFunctions)

      @lines = @text.split '\n'

    markRoot: ->
      tree = acorn.parse(@text, {
        locations: true
        line: 0
      })

      #console.log 'PROGRAM IS', JSON.stringify tree, null, 2

      @mark 0, tree, 0, null

    fullFunctionNameArray: (node) ->
      if node.type isnt 'CallExpression' then throw new Error
      obj = node.callee
      props = []
      while obj.type is 'MemberExpression'
        props.unshift obj.property.name
        obj = obj.object
      if obj.type is 'Identifier'
        props.unshift obj.name
      else
        props.unshift '*'
      props

    functionMatchesList: (node, list) ->
      fname = @fullFunctionNameArray node
      return (fname[fname.length - 1] in list) or
             (fname.length > 1 and fname.join('.') in list)

    getAcceptsRule: (node) -> default: helper.NORMAL
    getClasses: (node) ->
      if node.type of CLASS_EXCEPTIONS
        return CLASS_EXCEPTIONS[node.type].concat([node.type])
      else
        if node.type is 'CallExpression'
          if @functionMatchesList node, @opts.blockFunctions
            return [node.type, 'mostly-block']
          else if @functionMatchesList node, @opts.valueFunctions
            return [node.type, 'mostly-value']
          else
            return [node.type, 'any-drop']
        if node.type.match(/Expression$/)?
          return [node.type, 'mostly-value']
        else if node.type.match(/(Statement|Declaration)$/)?
          return [node.type, 'mostly-block']
        else
          return [node.type, 'any-drop']

    getPrecedence: (node) ->
      switch node.type
        when 'BinaryExpression'
          return OPERATOR_PRECEDENCES[node.operator]
        when 'AssignStatement'
          return 17
        when 'UnaryExpression'
          return 17
        when 'CallExpression'
          return 2
        when 'ExpressionStatement'
          return @getPrecedence node.expression
        else
          return 0

    getColor: (node) ->
      switch node.type
        when 'ExpressionStatement'
          return @getColor node.expression
        when 'CallExpression'
          if @functionMatchesList node, @opts.blockFunctions
            return 'command'
          else if @functionMatchesList node, @opts.valueFunctions
            return 'value'
          else
            return 'violet'
        else
          return COLORS[node.type]

    getSocketLevel: (node) -> helper.ANY_DROP

    getBounds: (node) ->
      # If we are a statement, scan
      # to find the semicolon
      if node.type is 'BlockStatement'
        bounds = {
          start: {
            line: node.loc.start.line
            column: node.loc.start.column + 1
          }
          end: {
            line: node.loc.end.line
            column: node.loc.end.column - 1
          }
        }

        if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
          bounds.end.line -= 1
          bounds.end.column = @lines[bounds.end.line].length

        return bounds

      else if node.type in STATEMENT_NODE_TYPES
        line = @lines[node.loc.end.line]
        semicolon = @lines[node.loc.end.line][node.loc.end.column - 1..].indexOf ';'
        if semicolon >= 0
          semicolonLength = @lines[node.loc.end.line][node.loc.end.column - 1..].match(/;\s*/)[0].length
          return {
            start: {
              line: node.loc.start.line
              column: node.loc.start.column
            }
            end: {
              line: node.loc.end.line
              column: node.loc.end.column + semicolon + semicolonLength - 1
            }
          }

      return {
        start: {
          line: node.loc.start.line
          column: node.loc.start.column
        }
        end: {
          line: node.loc.end.line
          column: node.loc.end.column
        }
      }

    getCaseIndentBounds: (node) ->
      bounds = {
        start: @getBounds(node.consequent[0]).start
        end: @getBounds(node.consequent[node.consequent.length - 1]).end
      }

      if @lines[bounds.start.line][...bounds.start.column].trim().length is 0
        bounds.start.line -= 1
        bounds.start.column = @lines[bounds.start.line].length

      if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
        bounds.end.line -= 1
        bounds.end.column = @lines[bounds.end.line].length

      return bounds

    getIndentPrefix: (bounds, indentDepth) ->
      if bounds.end.line - bounds.start.line < 1
        return DEFAULT_INDENT_DEPTH
      else
        line = @lines[bounds.start.line + 1]
        return line[indentDepth...(line.length - line.trimLeft().length)]

    isComment: (text) ->
      text.match(/^\s*\/\/.*$/)

    mark: (indentDepth, node, depth, bounds) ->
      switch node.type
        when 'Program'
          for statement in node.body
            @mark indentDepth, statement, depth + 1, null
        when 'Function'
          @jsBlock node, depth, bounds
          @mark indentDepth, node.body, depth + 1, null
        when 'SequenceExpression'
          @jsBlock node, depth, bounds
          for expression in node.expressions
            @jsSocketAndMark indentDepth, expression, depth + 1, null
        when 'FunctionDeclaration'
          @jsBlock node, depth, bounds
          @mark indentDepth, node.body, depth + 1, null
          @jsSocketAndMark indentDepth, node.id, depth + 1, null, null, ['no-drop']
          for param in node.params
            @jsSocketAndMark indentDepth, param, depth + 1, null, null, ['no-drop']
        when 'FunctionExpression'
          @jsBlock node, depth, bounds
          @mark indentDepth, node.body, depth + 1, null
          if node.id?
            @jsSocketAndMark indentDepth, node.id, depth + 1, null, null, ['no-drop']
          for param in node.params
            @jsSocketAndMark indentDepth, param, depth + 1, null, null, ['no-drop']
        when 'AssignmentExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.left, depth + 1, null
          @jsSocketAndMark indentDepth, node.right, depth + 1, null
        when 'ReturnStatement'
          @jsBlock node, depth, bounds
          if node.argument?
            @jsSocketAndMark indentDepth, node.argument, depth + 1, null
        when 'BreakStatement', 'ContinueStatement'
          @jsBlock node, depth, bounds
          if node.label?
            @jsSocketAndMark indentDepth, node.label, depth + 1, null
        when 'ThrowStatement'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1, null
        when 'IfStatement', 'ConditionalExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.test, depth + 1, NEVER_PAREN
          @jsSocketAndMark indentDepth, node.consequent, depth + 1, null
          if node.alternate?
            @jsSocketAndMark indentDepth, node.alternate, depth + 1, 10
        when 'ForStatement'
          @jsBlock node, depth, bounds
          if node.init?
            @jsSocketAndMark indentDepth, node.init, depth + 1, NEVER_PAREN, null, ['for-statement-init']
          if node.test?
            @jsSocketAndMark indentDepth, node.test, depth + 1, 10
          if node.update?
            @jsSocketAndMark indentDepth, node.update, depth + 1, 10

          @mark indentDepth, node.body, depth + 1
        when 'ForInStatement'
          @jsBlock node, depth, bounds
          if node.left?
            @jsSocketAndMark indentDepth, node.left, depth + 1, NEVER_PAREN, null, ['foreach-lhs']
          if node.right?
            @jsSocketAndMark indentDepth, node.right, depth + 1, 10
          @mark indentDepth, node.body, depth + 1
        when 'BlockStatement'
          prefix = @getIndentPrefix(@getBounds(node), indentDepth)
          indentDepth += prefix.length
          @addIndent
            bounds: @getBounds node
            depth: depth
            prefix: prefix

          for statement in node.body
            @mark indentDepth, statement, depth + 1, null
        when 'BinaryExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.left, depth + 1, OPERATOR_PRECEDENCES[node.operator]
          @jsSocketAndMark indentDepth, node.right, depth + 1, OPERATOR_PRECEDENCES[node.operator]
        when 'UnaryExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1, 17
        when 'ExpressionStatement'
          @mark indentDepth, node.expression, depth + 1, @getBounds node
        when 'Identifier'
          if node.name is '__'
            block = @jsBlock node, depth, bounds
            block.flagToRemove = true
        when 'CallExpression', 'NewExpression'
          @jsBlock node, depth, bounds
          if not @functionMatchesList node, @functionWhitelist
            @jsSocketAndMark indentDepth, node.callee, depth + 1, NEVER_PAREN
          for argument in node.arguments
            @jsSocketAndMark indentDepth, argument, depth + 1, NEVER_PAREN
        when 'MemberExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.object, depth + 1
          @jsSocketAndMark indentDepth, node.property, depth + 1
        when 'UpdateExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.argument, depth + 1
        when 'VariableDeclaration'
          @jsBlock node, depth, bounds
          for declaration in node.declarations
            @mark indentDepth, declaration, depth + 1
        when 'VariableDeclarator'
          @jsSocketAndMark indentDepth, node.id, depth
          if node.init?
            @jsSocketAndMark indentDepth, node.init, depth
        when 'LogicalExpression'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.left, depth + 1
          @jsSocketAndMark indentDepth, node.right, depth + 1
        when 'WhileStatement', 'DoWhileStatement'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.body, depth + 1
          @jsSocketAndMark indentDepth, node.test, depth + 1
        when 'ObjectExpression'
          @jsBlock node, depth, bounds
          for property in node.properties
            @jsSocketAndMark indentDepth, property.key, depth + 1
            @jsSocketAndMark indentDepth, property.value, depth + 1
        when 'SwitchStatement'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.discriminant, depth + 1
          for switchCase in node.cases
            @mark indentDepth, switchCase, depth + 1, null
        when 'SwitchCase'
          if node.test?
            @jsSocketAndMark indentDepth, node.test, depth + 1

          if node.consequent.length > 0
            bounds = @getCaseIndentBounds node
            prefix = @getIndentPrefix(@getBounds(node), indentDepth)
            indentDepth += prefix.length

            @addIndent
              bounds: bounds
              depth: depth + 1
              prefix: prefix

            for statement in node.consequent
              @mark indentDepth, statement, depth + 2
        when 'TryStatement'
          @jsBlock node, depth, bounds
          @jsSocketAndMark indentDepth, node.block, depth + 1, null
          if node.handler?
            if node.handler.guard?
              @jsSocketAndMark indentDepth, node.handler.guard, depth + 1, null
            if node.handler.param?
              @jsSocketAndMark indentDepth, node.handler.param, depth + 1, null
            @jsSocketAndMark indentDepth, node.handler.body, depth + 1, null
          if node.finalizer?
            @jsSocketAndMark indentDepth, node.finalizer, depth + 1, null
        when 'ArrayExpression'
          @jsBlock node, depth, bounds
          for element in node.elements
            if element?
              @jsSocketAndMark indentDepth, element, depth + 1, null
        when 'Literal'
          null
        else
          console.log 'Unrecognized', node

    jsBlock: (node, depth, bounds) ->
      @addBlock
        bounds: bounds ? @getBounds node
        depth: depth
        precedence: @getPrecedence node
        color: @getColor node
        classes: @getClasses node
        socketLevel: @getSocketLevel node

    jsSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes) ->
      unless node.type is 'BlockStatement'
        @addSocket
          bounds: bounds ? @getBounds node
          depth: depth
          precedence: precedence
          classes: classes ? []
          accepts: @getAcceptsRule node

      @mark indentDepth, node, depth + 1, bounds

  JavaScriptParser.parens = (leading, trailing, node, context) ->
    if context?.type is 'socket' or
       (not context? and 'mostly-value' in node.classes or 'value-only' in node.classes) or
       'ends-with-brace' in node.classes or
       node.type is 'segment'
      trailing trailing().replace(/;?\s*$/, '')
    else
      trailing trailing().replace(/;?\s*$/, ';')

    if context is null or context.type isnt 'socket' or
        context.precedence > node.precedence
      while true
        if leading().match(/^\s*\(/)? and trailing().match(/\)\s*/)?
          leading leading().replace(/^\s*\(\s*/, '')
          trailing trailing().replace(/\s*\)\s*$/, '')
        else
          break
    else
      leading '(' + leading()
      trailing trailing() + ')'

  JavaScriptParser.drop = (block, context, pred) ->
    if context.type is 'socket'
      if 'lvalue' in context.classes
        if 'Value' in block.classes and block.properties?.length > 0
          return helper.ENCOURAGE
        else
          return helper.FORBID

      else if 'no-drop' in context.classes
        return helper.FORBID

      else if 'property-access' in context.classes
        if 'works-as-method-call' in block.classes
          return helper.ENCOURAGE
        else
          return helper.FORBID

      else if 'value-only' in block.classes or
          'mostly-value' in block.classes or
          'any-drop' in block.classes or
          'for-statement-init' in context.classes
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

  JavaScriptParser.empty = "__"

  return parser.wrapParser JavaScriptParser
