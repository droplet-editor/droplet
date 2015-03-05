define ['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], (helper, model, parser, acorn) ->
	
	exports = {}

	COLORS = {
		'Default': 'violet'
	}

	exports.CSVParser = class CSVParser extends parser.Parser
		
		constructor: (@text, @opts = {}) ->
			super
			@lines = @text.split '\n'

		markRoot: ->
			tree = acorn.parse(@text, {
				locations: true
				line: 0
			})

			@mark 0, tree, 0, null

		getAcceptsRule: (node) -> default: helper.NORMAL

		getClasses: (node) ->
			return [node.type, 'mostly-value']

		getPrecedence: (node) ->
			return 1

		getColor: (node) ->
			return COLORS['Default']

		getBounds: (node) ->
			return node.loc

		getSocketLevel: (node) -> helper.ANY_DROP

		isComment: (text) ->
			text.match(/^\s*\/\/.*$/)

		mark: (indentDepth, node, depth, bounds) ->

			console.log node.type, node, bounds

			switch node.type
				when 'Program'
					for sequence in node.body
						@mark indentDepth, sequence, depth + 1, null
				when 'SequenceExpression'
					@csvBlock node, depth, bounds
					for expression in node.expressions
						@csvSocketAndMark indentDepth, expression, depth + 1, null
				when 'ExpressionStatement'
					@mark indentDepth, node.expression, depth + 1, @getBounds node


		csvBlock: (node, depth, bounds) ->
			@addBlock
				bounds: bounds ? @getBounds node
				depth: depth
				precedence: @getPrecedence node
				color: @getColor node
				classes: @getClasses node
				socketLevel: @getSocketLevel node

		csvSocketAndMark: (indentDepth, node, depth, precedence, bounds, classes) ->
			unless node.type is 'BlockStatement'
				@addSocket
					bounds: bounds ? @getBounds node
					depth: depth
					precedence: precedence
					classes: classes ? []
					acccepts: @getAcceptsRule node

			@mark indentDepth, node, depth + 1, bounds

	return parser.wrapParser CSVParser