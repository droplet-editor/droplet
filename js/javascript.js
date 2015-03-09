(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], function(helper, model, parser, acorn) {
    var CLASS_EXCEPTIONS, COLORS, DEFAULT_INDENT_DEPTH, JavaScriptParser, KNOWN_FUNCTIONS, NEVER_PAREN, OPERATOR_PRECEDENCES, STATEMENT_NODE_TYPES, exports;
    exports = {};
    STATEMENT_NODE_TYPES = ['ExpressionStatement', 'ReturnStatement', 'BreakStatement', 'ThrowStatement'];
    NEVER_PAREN = 100;
    KNOWN_FUNCTIONS = {
      'alert': {},
      'prompt': {},
      'console.log': {},
      'Math.abs': {
        value: true
      },
      'Math.acos': {
        value: true
      },
      'Math.asin': {
        value: true
      },
      'Math.atan': {
        value: true
      },
      'Math.atan2': {
        value: true
      },
      'Math.cos': {
        value: true
      },
      'Math.sin': {
        value: true
      },
      'Math.tan': {
        value: true
      },
      'Math.ceil': {
        value: true
      },
      'Math.floor': {
        value: true
      },
      'Math.round': {
        value: true
      },
      'Math.exp': {
        value: true
      },
      'Math.ln': {
        value: true
      },
      'Math.log10': {
        value: true
      },
      'Math.pow': {
        value: true
      },
      'Math.sqrt': {
        value: true
      },
      'Math.max': {
        value: true
      },
      'Math.min': {
        value: true
      },
      'Math.random': {
        value: true
      }
    };
    COLORS = {
      'BinaryExpression': 'value',
      'UnaryExpression': 'value',
      'FunctionExpression': 'value',
      'FunctionDeclaration': 'violet',
      'AssignmentExpression': 'command',
      'CallExpression': 'command',
      'ReturnStatement': 'return',
      'MemberExpression': 'value',
      'IfStatement': 'control',
      'ForStatement': 'control',
      'ForInStatement': 'control',
      'UpdateExpression': 'command',
      'VariableDeclaration': 'command',
      'LogicalExpression': 'value',
      'WhileStatement': 'control',
      'DoWhileStatement': 'control',
      'ObjectExpression': 'value',
      'SwitchStatement': 'control',
      'BreakStatement': 'return',
      'NewExpression': 'command',
      'ThrowStatement': 'return',
      'TryStatement': 'control',
      'ArrayExpression': 'value',
      'SequenceExpression': 'command',
      'ConditionalExpression': 'value'
    };
    OPERATOR_PRECEDENCES = {
      '*': 5,
      '/': 5,
      '%': 5,
      '+': 6,
      '-': 6,
      '<<': 7,
      '>>': 7,
      '>>>': 7,
      '<': 8,
      '>': 8,
      '>=': 8,
      'in': 8,
      'instanceof': 8,
      '==': 9,
      '!=': 9,
      '===': 9,
      '!==': 9,
      '&': 10,
      '^': 11,
      '|': 12,
      '&&': 13,
      '||': 14
    };
    CLASS_EXCEPTIONS = {
      'ForStatement': ['ends-with-brace', 'block-only'],
      'FunctionDeclaration': ['ends-with-brace', 'block-only'],
      'IfStatement': ['ends-with-brace', 'block-only'],
      'WhileStatement': ['ends-with-brace', 'block-only'],
      'DoWhileStatement': ['ends-with-brace', 'block-only'],
      'SwitchStatement': ['ends-with-brace', 'block-only'],
      'AssignmentExpression': ['mostly-block']
    };
    DEFAULT_INDENT_DEPTH = '  ';
    exports.JavaScriptParser = JavaScriptParser = (function(superClass) {
      extend(JavaScriptParser, superClass);

      function JavaScriptParser(text1, opts) {
        var base;
        this.text = text1;
        this.opts = opts != null ? opts : {};
        JavaScriptParser.__super__.constructor.apply(this, arguments);
        if ((base = this.opts).functions == null) {
          base.functions = KNOWN_FUNCTIONS;
        }
        this.lines = this.text.split('\n');
      }

      JavaScriptParser.prototype.markRoot = function() {
        var tree;
        tree = acorn.parse(this.text, {
          locations: true,
          line: 0,
          allowReturnOutsideFunction: true
        });
        return this.mark(0, tree, 0, null);
      };

      JavaScriptParser.prototype.fullFunctionNameArray = function(node) {
        var obj, props;
        if (node.type !== 'CallExpression') {
          throw new Error;
        }
        obj = node.callee;
        props = [];
        while (obj.type === 'MemberExpression') {
          props.unshift(obj.property.name);
          obj = obj.object;
        }
        if (obj.type === 'Identifier') {
          props.unshift(obj.name);
        } else {
          props.unshift('*');
        }
        return props;
      };

      JavaScriptParser.prototype.lookupFunctionName = function(node) {
        var fname, full, last;
        fname = this.fullFunctionNameArray(node);
        if (fname.length > 1) {
          full = fname.join('.');
          if (full in this.opts.functions) {
            return {
              name: full,
              dotted: true,
              fn: this.opts.functions[full]
            };
          }
        }
        last = fname[fname.length - 1];
        if (last in this.opts.functions) {
          return {
            name: last,
            dotted: false,
            fn: this.opts.functions[last]
          };
        }
        return null;
      };

      JavaScriptParser.prototype.getAcceptsRule = function(node) {
        return {
          "default": helper.NORMAL
        };
      };

      JavaScriptParser.prototype.getClasses = function(node) {
        var known;
        if (node.type in CLASS_EXCEPTIONS) {
          return CLASS_EXCEPTIONS[node.type].concat([node.type]);
        } else {
          if (node.type === 'CallExpression') {
            known = this.lookupFunctionName(node);
            if (!known || (known.fn.value && known.fn.command)) {
              return [node.type, 'any-drop'];
            }
            if (known.fn.value) {
              return [node.type, 'mostly-value'];
            } else {
              return [node.type, 'mostly-block'];
            }
          }
          if (node.type.match(/Expression$/) != null) {
            return [node.type, 'mostly-value'];
          } else if (node.type.match(/(Statement|Declaration)$/) != null) {
            return [node.type, 'mostly-block'];
          } else {
            return [node.type, 'any-drop'];
          }
        }
      };

      JavaScriptParser.prototype.getPrecedence = function(node) {
        switch (node.type) {
          case 'BinaryExpression':
            return OPERATOR_PRECEDENCES[node.operator];
          case 'AssignStatement':
            return 16;
          case 'UnaryExpression':
            if (node.prefix) {
              return 4;
            } else {
              return 3;
            }
            break;
          case 'CallExpression':
            return 2;
          case 'NewExpression':
            return 2;
          case 'MemberExpression':
            return 1;
          case 'ExpressionStatement':
            return this.getPrecedence(node.expression);
          default:
            return 0;
        }
      };

      JavaScriptParser.prototype.getColor = function(node) {
        var known;
        switch (node.type) {
          case 'ExpressionStatement':
            return this.getColor(node.expression);
          case 'CallExpression':
            known = this.lookupFunctionName(node);
            if (!known) {
              return 'violet';
            } else if (known.fn.color) {
              return known.fn.color;
            } else if (known.fn.value && !known.fn.command) {
              return 'value';
            } else {
              return 'command';
            }
            break;
          default:
            return COLORS[node.type];
        }
      };

      JavaScriptParser.prototype.getSocketLevel = function(node) {
        return helper.ANY_DROP;
      };

      JavaScriptParser.prototype.getBounds = function(node) {
        var bounds, line, ref, semicolon, semicolonLength;
        if (node.type === 'BlockStatement') {
          bounds = {
            start: {
              line: node.loc.start.line,
              column: node.loc.start.column + 1
            },
            end: {
              line: node.loc.end.line,
              column: node.loc.end.column - 1
            }
          };
          if (this.lines[bounds.end.line].slice(0, bounds.end.column).trim().length === 0) {
            bounds.end.line -= 1;
            bounds.end.column = this.lines[bounds.end.line].length;
          }
          return bounds;
        } else if (ref = node.type, indexOf.call(STATEMENT_NODE_TYPES, ref) >= 0) {
          line = this.lines[node.loc.end.line];
          semicolon = this.lines[node.loc.end.line].slice(node.loc.end.column - 1).indexOf(';');
          if (semicolon >= 0) {
            semicolonLength = this.lines[node.loc.end.line].slice(node.loc.end.column - 1).match(/;\s*/)[0].length;
            return {
              start: {
                line: node.loc.start.line,
                column: node.loc.start.column
              },
              end: {
                line: node.loc.end.line,
                column: node.loc.end.column + semicolon + semicolonLength - 1
              }
            };
          }
        }
        return {
          start: {
            line: node.loc.start.line,
            column: node.loc.start.column
          },
          end: {
            line: node.loc.end.line,
            column: node.loc.end.column
          }
        };
      };

      JavaScriptParser.prototype.getCaseIndentBounds = function(node) {
        var bounds;
        bounds = {
          start: this.getBounds(node.consequent[0]).start,
          end: this.getBounds(node.consequent[node.consequent.length - 1]).end
        };
        if (this.lines[bounds.start.line].slice(0, bounds.start.column).trim().length === 0) {
          bounds.start.line -= 1;
          bounds.start.column = this.lines[bounds.start.line].length;
        }
        if (this.lines[bounds.end.line].slice(0, bounds.end.column).trim().length === 0) {
          bounds.end.line -= 1;
          bounds.end.column = this.lines[bounds.end.line].length;
        }
        return bounds;
      };

      JavaScriptParser.prototype.getIndentPrefix = function(bounds, indentDepth) {
        var line;
        if (bounds.end.line - bounds.start.line < 1) {
          return DEFAULT_INDENT_DEPTH;
        } else {
          line = this.lines[bounds.start.line + 1];
          return line.slice(indentDepth, line.length - line.trimLeft().length);
        }
      };

      JavaScriptParser.prototype.isComment = function(text) {
        return text.match(/^\s*\/\/.*$/);
      };

      JavaScriptParser.prototype.mark = function(indentDepth, node, depth, bounds) {
        var argument, block, declaration, element, expression, i, j, k, known, l, len, len1, len10, len2, len3, len4, len5, len6, len7, len8, len9, m, n, o, p, param, prefix, property, q, r, ref, ref1, ref10, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, results, results1, results10, results2, results3, results4, results5, results6, results7, results8, results9, s, statement, switchCase;
        switch (node.type) {
          case 'Program':
            ref = node.body;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              statement = ref[i];
              results.push(this.mark(indentDepth, statement, depth + 1, null));
            }
            return results;
            break;
          case 'Function':
            this.jsBlock(node, depth, bounds);
            return this.mark(indentDepth, node.body, depth + 1, null);
          case 'SequenceExpression':
            this.jsBlock(node, depth, bounds);
            ref1 = node.expressions;
            results1 = [];
            for (j = 0, len1 = ref1.length; j < len1; j++) {
              expression = ref1[j];
              results1.push(this.jsSocketAndMark(indentDepth, expression, depth + 1, null));
            }
            return results1;
            break;
          case 'FunctionDeclaration':
            this.jsBlock(node, depth, bounds);
            this.mark(indentDepth, node.body, depth + 1, null);
            this.jsSocketAndMark(indentDepth, node.id, depth + 1, null, null, ['no-drop']);
            ref2 = node.params;
            results2 = [];
            for (k = 0, len2 = ref2.length; k < len2; k++) {
              param = ref2[k];
              results2.push(this.jsSocketAndMark(indentDepth, param, depth + 1, null, null, ['no-drop']));
            }
            return results2;
            break;
          case 'FunctionExpression':
            this.jsBlock(node, depth, bounds);
            this.mark(indentDepth, node.body, depth + 1, null);
            if (node.id != null) {
              this.jsSocketAndMark(indentDepth, node.id, depth + 1, null, null, ['no-drop']);
            }
            ref3 = node.params;
            results3 = [];
            for (l = 0, len3 = ref3.length; l < len3; l++) {
              param = ref3[l];
              results3.push(this.jsSocketAndMark(indentDepth, param, depth + 1, null, null, ['no-drop']));
            }
            return results3;
            break;
          case 'AssignmentExpression':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.left, depth + 1, null);
            return this.jsSocketAndMark(indentDepth, node.right, depth + 1, null);
          case 'ReturnStatement':
            this.jsBlock(node, depth, bounds);
            if (node.argument != null) {
              return this.jsSocketAndMark(indentDepth, node.argument, depth + 1, null);
            }
            break;
          case 'BreakStatement':
          case 'ContinueStatement':
            this.jsBlock(node, depth, bounds);
            if (node.label != null) {
              return this.jsSocketAndMark(indentDepth, node.label, depth + 1, null);
            }
            break;
          case 'ThrowStatement':
            this.jsBlock(node, depth, bounds);
            return this.jsSocketAndMark(indentDepth, node.argument, depth + 1, null);
          case 'IfStatement':
          case 'ConditionalExpression':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.test, depth + 1, NEVER_PAREN);
            this.jsSocketAndMark(indentDepth, node.consequent, depth + 1, null);
            if (node.alternate != null) {
              return this.jsSocketAndMark(indentDepth, node.alternate, depth + 1, 10);
            }
            break;
          case 'ForStatement':
            this.jsBlock(node, depth, bounds);
            if (node.init != null) {
              this.jsSocketAndMark(indentDepth, node.init, depth + 1, NEVER_PAREN, null, ['for-statement-init']);
            }
            if (node.test != null) {
              this.jsSocketAndMark(indentDepth, node.test, depth + 1, 10);
            }
            if (node.update != null) {
              this.jsSocketAndMark(indentDepth, node.update, depth + 1, 10);
            }
            return this.mark(indentDepth, node.body, depth + 1);
          case 'ForInStatement':
            this.jsBlock(node, depth, bounds);
            if (node.left != null) {
              this.jsSocketAndMark(indentDepth, node.left, depth + 1, NEVER_PAREN, null, ['foreach-lhs']);
            }
            if (node.right != null) {
              this.jsSocketAndMark(indentDepth, node.right, depth + 1, 10);
            }
            return this.mark(indentDepth, node.body, depth + 1);
          case 'BlockStatement':
            prefix = this.getIndentPrefix(this.getBounds(node), indentDepth);
            indentDepth += prefix.length;
            this.addIndent({
              bounds: this.getBounds(node),
              depth: depth,
              prefix: prefix
            });
            ref4 = node.body;
            results4 = [];
            for (m = 0, len4 = ref4.length; m < len4; m++) {
              statement = ref4[m];
              results4.push(this.mark(indentDepth, statement, depth + 1, null));
            }
            return results4;
            break;
          case 'BinaryExpression':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.left, depth + 1, OPERATOR_PRECEDENCES[node.operator]);
            return this.jsSocketAndMark(indentDepth, node.right, depth + 1, OPERATOR_PRECEDENCES[node.operator]);
          case 'UnaryExpression':
            this.jsBlock(node, depth, bounds);
            return this.jsSocketAndMark(indentDepth, node.argument, depth + 1, this.getPrecedence(node));
          case 'ExpressionStatement':
            return this.mark(indentDepth, node.expression, depth + 1, this.getBounds(node));
          case 'Identifier':
            if (node.name === '__') {
              block = this.jsBlock(node, depth, bounds);
              return block.flagToRemove = true;
            }
            break;
          case 'CallExpression':
          case 'NewExpression':
            this.jsBlock(node, depth, bounds);
            known = this.lookupFunctionName(node);
            if (!known) {
              this.jsSocketAndMark(indentDepth, node.callee, depth + 1, NEVER_PAREN);
            }
            ref5 = node["arguments"];
            results5 = [];
            for (n = 0, len5 = ref5.length; n < len5; n++) {
              argument = ref5[n];
              results5.push(this.jsSocketAndMark(indentDepth, argument, depth + 1, NEVER_PAREN));
            }
            return results5;
            break;
          case 'MemberExpression':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.object, depth + 1);
            return this.jsSocketAndMark(indentDepth, node.property, depth + 1);
          case 'UpdateExpression':
            this.jsBlock(node, depth, bounds);
            return this.jsSocketAndMark(indentDepth, node.argument, depth + 1);
          case 'VariableDeclaration':
            this.jsBlock(node, depth, bounds);
            ref6 = node.declarations;
            results6 = [];
            for (o = 0, len6 = ref6.length; o < len6; o++) {
              declaration = ref6[o];
              results6.push(this.mark(indentDepth, declaration, depth + 1));
            }
            return results6;
            break;
          case 'VariableDeclarator':
            this.jsSocketAndMark(indentDepth, node.id, depth);
            if (node.init != null) {
              return this.jsSocketAndMark(indentDepth, node.init, depth);
            }
            break;
          case 'LogicalExpression':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.left, depth + 1);
            return this.jsSocketAndMark(indentDepth, node.right, depth + 1);
          case 'WhileStatement':
          case 'DoWhileStatement':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.body, depth + 1);
            return this.jsSocketAndMark(indentDepth, node.test, depth + 1);
          case 'ObjectExpression':
            this.jsBlock(node, depth, bounds);
            ref7 = node.properties;
            results7 = [];
            for (p = 0, len7 = ref7.length; p < len7; p++) {
              property = ref7[p];
              this.jsSocketAndMark(indentDepth, property.key, depth + 1);
              results7.push(this.jsSocketAndMark(indentDepth, property.value, depth + 1));
            }
            return results7;
            break;
          case 'SwitchStatement':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.discriminant, depth + 1);
            ref8 = node.cases;
            results8 = [];
            for (q = 0, len8 = ref8.length; q < len8; q++) {
              switchCase = ref8[q];
              results8.push(this.mark(indentDepth, switchCase, depth + 1, null));
            }
            return results8;
            break;
          case 'SwitchCase':
            if (node.test != null) {
              this.jsSocketAndMark(indentDepth, node.test, depth + 1);
            }
            if (node.consequent.length > 0) {
              bounds = this.getCaseIndentBounds(node);
              prefix = this.getIndentPrefix(this.getBounds(node), indentDepth);
              indentDepth += prefix.length;
              this.addIndent({
                bounds: bounds,
                depth: depth + 1,
                prefix: prefix
              });
              ref9 = node.consequent;
              results9 = [];
              for (r = 0, len9 = ref9.length; r < len9; r++) {
                statement = ref9[r];
                results9.push(this.mark(indentDepth, statement, depth + 2));
              }
              return results9;
            }
            break;
          case 'TryStatement':
            this.jsBlock(node, depth, bounds);
            this.jsSocketAndMark(indentDepth, node.block, depth + 1, null);
            if (node.handler != null) {
              if (node.handler.guard != null) {
                this.jsSocketAndMark(indentDepth, node.handler.guard, depth + 1, null);
              }
              if (node.handler.param != null) {
                this.jsSocketAndMark(indentDepth, node.handler.param, depth + 1, null);
              }
              this.jsSocketAndMark(indentDepth, node.handler.body, depth + 1, null);
            }
            if (node.finalizer != null) {
              return this.jsSocketAndMark(indentDepth, node.finalizer, depth + 1, null);
            }
            break;
          case 'ArrayExpression':
            this.jsBlock(node, depth, bounds);
            ref10 = node.elements;
            results10 = [];
            for (s = 0, len10 = ref10.length; s < len10; s++) {
              element = ref10[s];
              if (element != null) {
                results10.push(this.jsSocketAndMark(indentDepth, element, depth + 1, null));
              } else {
                results10.push(void 0);
              }
            }
            return results10;
            break;
          case 'Literal':
            return null;
          default:
            return console.log('Unrecognized', node);
        }
      };

      JavaScriptParser.prototype.jsBlock = function(node, depth, bounds) {
        return this.addBlock({
          bounds: bounds != null ? bounds : this.getBounds(node),
          depth: depth,
          precedence: this.getPrecedence(node),
          color: this.getColor(node),
          classes: this.getClasses(node),
          socketLevel: this.getSocketLevel(node)
        });
      };

      JavaScriptParser.prototype.jsSocketAndMark = function(indentDepth, node, depth, precedence, bounds, classes) {
        if (node.type !== 'BlockStatement') {
          this.addSocket({
            bounds: bounds != null ? bounds : this.getBounds(node),
            depth: depth,
            precedence: precedence,
            classes: classes != null ? classes : [],
            accepts: this.getAcceptsRule(node)
          });
        }
        return this.mark(indentDepth, node, depth + 1, bounds);
      };

      return JavaScriptParser;

    })(parser.Parser);
    JavaScriptParser.parens = function(leading, trailing, node, context) {
      var results;
      if ((context != null ? context.type : void 0) === 'socket' || ((context == null) && indexOf.call(node.classes, 'mostly-value') >= 0 || indexOf.call(node.classes, 'value-only') >= 0) || indexOf.call(node.classes, 'ends-with-brace') >= 0 || node.type === 'segment') {
        trailing(trailing().replace(/;?\s*$/, ''));
      } else {
        trailing(trailing().replace(/;?\s*$/, ';'));
      }
      if (context === null || context.type !== 'socket' || context.precedence > node.precedence) {
        results = [];
        while (true) {
          if ((leading().match(/^\s*\(/) != null) && (trailing().match(/\)\s*/) != null)) {
            leading(leading().replace(/^\s*\(\s*/, ''));
            results.push(trailing(trailing().replace(/\s*\)\s*$/, '')));
          } else {
            break;
          }
        }
        return results;
      } else {
        leading('(' + leading());
        return trailing(trailing() + ')');
      }
    };
    JavaScriptParser.drop = function(block, context, pred) {
      var ref, ref1;
      if (context.type === 'socket') {
        if (indexOf.call(context.classes, 'lvalue') >= 0) {
          if (indexOf.call(block.classes, 'Value') >= 0 && ((ref = block.properties) != null ? ref.length : void 0) > 0) {
            return helper.ENCOURAGE;
          } else {
            return helper.FORBID;
          }
        } else if (indexOf.call(context.classes, 'no-drop') >= 0) {
          return helper.FORBID;
        } else if (indexOf.call(context.classes, 'property-access') >= 0) {
          if (indexOf.call(block.classes, 'works-as-method-call') >= 0) {
            return helper.ENCOURAGE;
          } else {
            return helper.FORBID;
          }
        } else if (indexOf.call(block.classes, 'value-only') >= 0 || indexOf.call(block.classes, 'mostly-value') >= 0 || indexOf.call(block.classes, 'any-drop') >= 0 || indexOf.call(context.classes, 'for-statement-init') >= 0) {
          return helper.ENCOURAGE;
        } else if (indexOf.call(block.classes, 'mostly-block') >= 0) {
          return helper.DISCOURAGE;
        }
      } else if ((ref1 = context.type) === 'indent' || ref1 === 'segment') {
        if (indexOf.call(block.classes, 'block-only') >= 0 || indexOf.call(block.classes, 'mostly-block') >= 0 || indexOf.call(block.classes, 'any-drop') >= 0 || block.type === 'segment') {
          return helper.ENCOURAGE;
        } else if (indexOf.call(block.classes, 'mostly-value') >= 0) {
          return helper.DISCOURAGE;
        }
      }
      return helper.DISCOURAGE;
    };
    JavaScriptParser.empty = "__";
    return parser.wrapParser(JavaScriptParser);
  });

}).call(this);

//# sourceMappingURL=javascript.js.map
