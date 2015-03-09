(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['droplet-helper', 'droplet-model', 'droplet-parser', 'coffee-script'], function(helper, model, parser, CoffeeScript) {
    var ANY_DROP, BLOCK_ONLY, CoffeeScriptParser, FORBID_ALL, KNOWN_FUNCTIONS, LVALUE, MOSTLY_BLOCK, MOSTLY_VALUE, NO, OPERATOR_PRECEDENCES, PROPERTY_ACCESS, STATEMENT_KEYWORDS, VALUE_ONLY, YES, addEmptyBackTickLineAfter, annotateCsNodes, backTickLine, exports, findUnmatchedLine, fixCoffeeScriptError, getClassesFor, spacestring;
    exports = {};
    ANY_DROP = ['any-drop'];
    BLOCK_ONLY = ['block-only'];
    MOSTLY_BLOCK = ['mostly-block'];
    MOSTLY_VALUE = ['mostly-value'];
    VALUE_ONLY = ['value-only'];
    LVALUE = ['lvalue'];
    FORBID_ALL = ['forbid-all'];
    PROPERTY_ACCESS = ['prop-access'];
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
    STATEMENT_KEYWORDS = ['break', 'continue'];

    /*
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
     */
    OPERATOR_PRECEDENCES = {
      '||': 1,
      '&&': 2,
      'instanceof': 3,
      '===': 3,
      '!==': 3,
      '>': 3,
      '<': 3,
      '>=': 3,
      '<=': 3,
      '+': 4,
      '-': 4,
      '*': 5,
      '/': 5,
      '%': 6,
      '**': 7,
      '%%': 7
    };
    YES = function() {
      return true;
    };
    NO = function() {
      return false;
    };
    spacestring = function(n) {
      return ((function() {
        var j, ref, results;
        results = [];
        for (j = 0, ref = Math.max(0, n); 0 <= ref ? j < ref : j > ref; 0 <= ref ? j++ : j--) {
          results.push(' ');
        }
        return results;
      })()).join('');
    };
    getClassesFor = function(node) {
      var classes;
      classes = [];
      classes.push(node.nodeType());
      if (node.nodeType() === 'Call' && (!node["do"]) && (!node.isNew)) {
        classes.push('works-as-method-call');
      }
      return classes;
    };
    annotateCsNodes = function(tree) {
      tree.eachChild(function(child) {
        child.dropletParent = tree;
        return annotateCsNodes(child);
      });
      return tree;
    };
    exports.CoffeeScriptParser = CoffeeScriptParser = (function(superClass) {
      extend(CoffeeScriptParser, superClass);

      function CoffeeScriptParser(text, opts) {
        var base, i, j, len, line, ref;
        this.text = text;
        this.opts = opts != null ? opts : {};
        CoffeeScriptParser.__super__.constructor.apply(this, arguments);
        if ((base = this.opts).functions == null) {
          base.functions = KNOWN_FUNCTIONS;
        }
        this.lines = this.text.split('\n');
        this.hasLineBeenMarked = {};
        ref = this.lines;
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          line = ref[i];
          this.hasLineBeenMarked[i] = false;
        }
      }

      CoffeeScriptParser.prototype.markRoot = function() {
        var e, firstError, j, len, node, nodes, retries, tree;
        this.stripComments();
        retries = Math.max(1, Math.min(5, Math.ceil(this.lines.length / 2)));
        firstError = null;
        while (true) {
          try {
            tree = CoffeeScript.nodes(this.text);
            annotateCsNodes(tree);
            nodes = tree.expressions;
            break;
          } catch (_error) {
            e = _error;
            if (firstError == null) {
              firstError = e;
            }
            if (retries > 0 && fixCoffeeScriptError(this.lines, e)) {
              this.text = this.lines.join('\n');
            } else {
              if (firstError.location) {
                firstError.loc = {
                  line: firstError.location.first_line,
                  column: firstError.location.first_column
                };
              }
              throw firstError;
            }
          }
          retries -= 1;
        }
        for (j = 0, len = nodes.length; j < len; j++) {
          node = nodes[j];
          this.mark(node, 3, 0, null, 0);
        }
        return this.wrapSemicolons(nodes, 0);
      };

      CoffeeScriptParser.prototype.isComment = function(str) {
        return str.match(/^\s*#.*$/) != null;
      };

      CoffeeScriptParser.prototype.stripComments = function() {
        var i, j, k, len, line, ref, ref1, syntaxError, token, tokens;
        try {
          tokens = CoffeeScript.tokens(this.text, {
            rewrite: false,
            preserveComments: true
          });
        } catch (_error) {
          syntaxError = _error;
          if (syntaxError.location) {
            syntaxError.loc = {
              line: syntaxError.location.first_line,
              column: syntaxError.location.first_column
            };
          }
          throw syntaxError;
        }
        for (j = 0, len = tokens.length; j < len; j++) {
          token = tokens[j];
          if (token[0] === 'COMMENT') {
            if (token[2].first_line === token[2].last_line) {
              line = this.lines[token[2].first_line];
              this.lines[token[2].first_line] = line.slice(0, token[2].first_column) + spacestring(token[2].last_column - token[2].first_column + 1) + line.slice(token[2].last_column);
            } else {
              line = this.lines[token[2].first_line];
              this.lines[token[2].first_line] = line.slice(0, token[2].first_column) + spacestring(line.length - token[2].first_column);
              this.lines[token[2].last_line] = spacestring(token[2].last_column + 1) + this.lines[token[2].last_line].slice(token[2].last_column + 1);
              for (i = k = ref = token[2].first_line + 1, ref1 = token[2].last_line; ref <= ref1 ? k < ref1 : k > ref1; i = ref <= ref1 ? ++k : --k) {
                this.lines[i] = spacestring(this.lines[i].length);
              }
            }
          }
        }
        return null;
      };

      CoffeeScriptParser.prototype.functionNameNodes = function(node) {
        var j, len, nodes, prop, ref, ref1;
        if (node.nodeType() !== 'Call') {
          throw new Error;
        }
        if (node.variable != null) {
          nodes = [];
          if ((ref = node.variable.base) != null ? ref.value : void 0) {
            nodes.push(node.variable.base);
          } else {
            nodes.push(null);
          }
          if (node.variable.properties != null) {
            ref1 = node.variable.properties;
            for (j = 0, len = ref1.length; j < len; j++) {
              prop = ref1[j];
              nodes.push(prop.name);
            }
          }
          return nodes;
        }
        return [];
      };

      CoffeeScriptParser.prototype.emptyLocation = function(loc) {
        return loc.first_column === loc.last_column && loc.first_line === loc.last_line;
      };

      CoffeeScriptParser.prototype.implicitName = function(nn) {
        var node, ref;
        if (nn.length === 0) {
          return false;
        }
        node = nn[nn.length - 1];
        return (node != null ? (ref = node.value) != null ? ref.length : void 0 : void 0) > 1 && this.emptyLocation(node.locationData);
      };

      CoffeeScriptParser.prototype.lookupFunctionName = function(nn) {
        var full, last;
        if (nn.length > 1) {
          full = (nn.map(function(n) {
            return (n != null ? n.value : void 0) || '*';
          })).join('.');
          if (full in this.opts.functions) {
            return {
              name: full,
              dotted: true,
              fn: this.opts.functions[full]
            };
          }
        }
        last = nn[nn.length - 1];
        if ((last != null) && last.value in this.opts.functions) {
          return {
            name: last.value,
            dotted: false,
            fn: this.opts.functions[last.value]
          };
        }
        return null;
      };

      CoffeeScriptParser.prototype.addCode = function(node, depth, indentDepth) {
        var j, len, param, ref;
        ref = node.params;
        for (j = 0, len = ref.length; j < len; j++) {
          param = ref[j];
          this.csSocketAndMark(param, depth, 0, indentDepth, FORBID_ALL);
        }
        return this.mark(node.body, depth, 0, null, indentDepth);
      };

      CoffeeScriptParser.prototype.mark = function(node, depth, precedence, wrappingParen, indentDepth) {
        var arg, bounds, childName, classes, color, condition, errorSocket, expr, fakeBlock, firstBounds, index, infix, j, k, known, l, last, len, len1, len2, len3, len4, len5, len6, len7, len8, len9, line, lines, m, namenodes, o, object, p, property, q, r, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref18, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, results, results1, results2, results3, results4, s, secondBounds, shouldBeOneLine, switchCase, t, textLine, trueIndentDepth, u;
        switch (node.nodeType()) {
          case 'Block':
            if (node.expressions.length === 0) {
              return;
            }
            bounds = this.getBounds(node);
            shouldBeOneLine = false;
            for (line = j = ref = bounds.start.line, ref1 = bounds.end.line; ref <= ref1 ? j <= ref1 : j >= ref1; line = ref <= ref1 ? ++j : --j) {
              shouldBeOneLine || (shouldBeOneLine = this.hasLineBeenMarked[line]);
            }
            if (this.lines[bounds.start.line].slice(0, bounds.start.column).trim().length !== 0) {
              shouldBeOneLine = true;
            }
            if (shouldBeOneLine) {
              this.csSocket(node, depth, 0);
            } else {
              textLine = this.lines[node.locationData.first_line];
              trueIndentDepth = textLine.length - textLine.trimLeft().length;
              while (bounds.start.line > 0 && this.lines[bounds.start.line - 1].trim().length === 0) {
                bounds.start.line -= 1;
                bounds.start.column = this.lines[bounds.start.line].length + 1;
              }
              bounds.start.line -= 1;
              bounds.start.column = this.lines[bounds.start.line].length + 1;
              this.addIndent({
                depth: depth,
                bounds: bounds,
                prefix: this.lines[node.locationData.first_line].slice(indentDepth, trueIndentDepth)
              });
              indentDepth = trueIndentDepth;
            }
            ref2 = node.expressions;
            for (k = 0, len = ref2.length; k < len; k++) {
              expr = ref2[k];
              this.mark(expr, depth + 3, 0, null, indentDepth);
            }
            return this.wrapSemicolons(node.expressions, depth);
          case 'Parens':
            if (node.body != null) {
              if (node.body.nodeType() !== 'Block') {
                return this.mark(node.body, depth + 1, 0, wrappingParen != null ? wrappingParen : node, indentDepth);
              } else {
                if (node.body.unwrap() === node.body) {
                  this.csBlock(node, depth, -2, 'command', null, MOSTLY_BLOCK);
                  ref3 = node.body.expressions;
                  results = [];
                  for (l = 0, len1 = ref3.length; l < len1; l++) {
                    expr = ref3[l];
                    results.push(this.csSocketAndMark(expr, depth + 1, -2, indentDepth));
                  }
                  return results;
                } else {
                  return this.mark(node.body.unwrap(), depth + 1, 0, wrappingParen != null ? wrappingParen : node, indentDepth);
                }
              }
            }
            break;
          case 'Op':
            if ((node.first != null) && (node.second != null) && node.operator === '+') {
              firstBounds = this.getBounds(node.first);
              secondBounds = this.getBounds(node.second);
              lines = this.lines.slice(firstBounds.end.line, +secondBounds.start.line + 1 || 9e9).join('\n');
              infix = lines.slice(firstBounds.end.column, -(this.lines[secondBounds.start.line].length - secondBounds.start.column));
              if (infix.indexOf('+') === -1) {
                return;
              }
            }
            if (node.first && !node.second && ((ref4 = node.operator) === '+' || ref4 === '-') && ((ref5 = node.first) != null ? (ref6 = ref5.base) != null ? typeof ref6.nodeType === "function" ? ref6.nodeType() : void 0 : void 0 : void 0) === 'Literal') {
              return;
            }
            this.csBlock(node, depth, OPERATOR_PRECEDENCES[node.operator], 'value', wrappingParen, VALUE_ONLY);
            this.csSocketAndMark(node.first, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth);
            if (node.second != null) {
              return this.csSocketAndMark(node.second, depth + 1, OPERATOR_PRECEDENCES[node.operator], indentDepth);
            }
            break;
          case 'Existence':
            this.csBlock(node, depth, 100, 'value', wrappingParen, VALUE_ONLY);
            return this.csSocketAndMark(node.expression, depth + 1, 101, indentDepth);
          case 'In':
            this.csBlock(node, depth, 0, 'value', wrappingParen, VALUE_ONLY);
            this.csSocketAndMark(node.object, depth + 1, 0, indentDepth);
            return this.csSocketAndMark(node.array, depth + 1, 0, indentDepth);
          case 'Value':
            if ((node.properties != null) && node.properties.length > 0) {
              this.csBlock(node, depth, 0, 'value', wrappingParen, MOSTLY_VALUE);
              this.csSocketAndMark(node.base, depth + 1, 0, indentDepth);
              ref7 = node.properties;
              results1 = [];
              for (m = 0, len2 = ref7.length; m < len2; m++) {
                property = ref7[m];
                if (property.nodeType() === 'Access') {
                  results1.push(this.csSocketAndMark(property.name, depth + 1, -2, indentDepth, PROPERTY_ACCESS));
                } else if (property.nodeType() === 'Index') {
                  results1.push(this.csSocketAndMark(property.index, depth + 1, 0, indentDepth));
                } else {
                  results1.push(void 0);
                }
              }
              return results1;
            } else if (node.base.nodeType() === 'Literal' && node.base.value === '') {
              fakeBlock = this.csBlock(node.base, depth, 0, 'value', wrappingParen, ANY_DROP);
              return fakeBlock.flagToRemove = true;
            } else if (node.base.nodeType() === 'Literal' && /^#/.test(node.base.value)) {
              this.csBlock(node.base, depth, 0, 'blank', wrappingParen, ANY_DROP);
              errorSocket = this.csSocket(node.base, depth + 1, -2);
              return errorSocket.flagToStrip = {
                left: 2,
                right: 1
              };
            } else {
              return this.mark(node.base, depth + 1, 0, wrappingParen, indentDepth);
            }
            break;
          case 'Literal':
            if (ref8 = node.value, indexOf.call(STATEMENT_KEYWORDS, ref8) >= 0) {
              return this.csBlock(node, depth, 0, 'return', wrappingParen, BLOCK_ONLY);
            } else {
              return 0;
            }
            break;
          case 'Literal':
          case 'Bool':
          case 'Undefined':
          case 'Null':
            return 0;
          case 'Call':
            if (node.variable != null) {
              namenodes = this.functionNameNodes(node);
              known = this.lookupFunctionName(namenodes);
              if (known) {
                if (known.fn.value) {
                  color = known.fn.color || (known.fn.command ? 'command' : 'value');
                  classes = known.fn.command ? ANY_DROP : MOSTLY_VALUE;
                } else {
                  color = known.fn.color || 'command';
                  classes = MOSTLY_BLOCK;
                }
              } else {
                color = 'command';
                classes = ANY_DROP;
              }
              this.csBlock(node, depth, 0, color, wrappingParen, classes);
              if (this.implicitName(namenodes)) {

              } else if (!known) {
                this.csSocketAndMark(node.variable, depth + 1, 0, indentDepth);
              } else if (!known.dotted && ((ref9 = node.variable.properties) != null ? ref9.length : void 0) > 0) {
                this.csSocketAndMark(node.variable.base, depth + 1, 0, indentDepth);
              }
            } else {
              this.csBlock(node, depth, 0, 'command', wrappingParen, ANY_DROP);
            }
            if (!node["do"]) {
              ref10 = node.args;
              results2 = [];
              for (index = o = 0, len3 = ref10.length; o < len3; index = ++o) {
                arg = ref10[index];
                last = index === node.args.length - 1;
                precedence = last ? -1 : 0;
                if (last && arg.nodeType() === 'Code') {
                  results2.push(this.addCode(arg, depth + 1, indentDepth));
                } else {
                  results2.push(this.csSocketAndMark(arg, depth + 1, precedence, indentDepth));
                }
              }
              return results2;
            }
            break;
          case 'Code':
            this.csBlock(node, depth, 0, 'value', wrappingParen, VALUE_ONLY);
            return this.addCode(node, depth + 1, indentDepth);
          case 'Assign':
            this.csBlock(node, depth, 0, 'command', wrappingParen, MOSTLY_BLOCK);
            this.csSocketAndMark(node.variable, depth + 1, 0, indentDepth, LVALUE);
            if (node.value.nodeType() === 'Code') {
              return this.addCode(node.value, depth + 1, indentDepth);
            } else {
              return this.csSocketAndMark(node.value, depth + 1, 0, indentDepth);
            }
            break;
          case 'For':
            this.csBlock(node, depth, -3, 'control', wrappingParen, MOSTLY_BLOCK);
            ref11 = ['source', 'from', 'guard', 'step'];
            for (p = 0, len4 = ref11.length; p < len4; p++) {
              childName = ref11[p];
              if (node[childName] != null) {
                this.csSocketAndMark(node[childName], depth + 1, 0, indentDepth);
              }
            }
            ref12 = ['index', 'name'];
            for (q = 0, len5 = ref12.length; q < len5; q++) {
              childName = ref12[q];
              if (node[childName] != null) {
                this.csSocketAndMark(node[childName], depth + 1, 0, indentDepth, FORBID_ALL);
              }
            }
            return this.mark(node.body, depth + 1, 0, null, indentDepth);
          case 'Range':
            this.csBlock(node, depth, 100, 'value', wrappingParen, VALUE_ONLY);
            this.csSocketAndMark(node.from, depth, 0, indentDepth);
            return this.csSocketAndMark(node.to, depth, 0, indentDepth);
          case 'If':
            this.csBlock(node, depth, 0, 'control', wrappingParen, MOSTLY_BLOCK);

            /*
            bounds = @getBounds node
            if @lines[bounds.start.line].indexOf('unless') >= 0 and
                @locationsAreIdentical(bounds.start, @getBounds(node.condition).start) and
                node.condition.nodeType() is 'Op'
            
              @csSocketAndMark node.condition.first, depth + 1, 0, indentDepth
            else
             */
            this.csSocketAndMark(node.rawCondition, depth + 1, 0, indentDepth);
            this.mark(node.body, depth + 1, 0, null, indentDepth);
            if (node.elseBody != null) {
              this.flagLineAsMarked(node.elseToken.first_line);
              return this.mark(node.elseBody, depth + 1, 0, null, indentDepth);
            }
            break;
          case 'Arr':
            this.csBlock(node, depth, 100, 'violet', wrappingParen, VALUE_ONLY);
            if (node.objects.length > 0) {
              this.csIndentAndMark(indentDepth, node.objects, depth + 1);
            }
            ref13 = node.objects;
            results3 = [];
            for (r = 0, len6 = ref13.length; r < len6; r++) {
              object = ref13[r];
              if (object.nodeType() === 'Value' && object.base.nodeType() === 'Literal' && ((ref14 = (ref15 = object.properties) != null ? ref15.length : void 0) === 0 || ref14 === (void 0))) {
                results3.push(this.csBlock(object, depth + 2, 100, 'return', null, VALUE_ONLY));
              } else {
                results3.push(void 0);
              }
            }
            return results3;
            break;
          case 'Return':
            this.csBlock(node, depth, 0, 'return', wrappingParen, BLOCK_ONLY);
            if (node.expression != null) {
              return this.csSocketAndMark(node.expression, depth + 1, 0, indentDepth);
            }
            break;
          case 'While':
            this.csBlock(node, depth, -3, 'control', wrappingParen, MOSTLY_BLOCK);
            this.csSocketAndMark(node.rawCondition, depth + 1, 0, indentDepth);
            if (node.guard != null) {
              this.csSocketAndMark(node.guard, depth + 1, 0, indentDepth);
            }
            return this.mark(node.body, depth + 1, 0, null, indentDepth);
          case 'Switch':
            this.csBlock(node, depth, 0, 'control', wrappingParen, MOSTLY_BLOCK);
            if (node.subject != null) {
              this.csSocketAndMark(node.subject, depth + 1, 0, indentDepth);
            }
            ref16 = node.cases;
            for (s = 0, len7 = ref16.length; s < len7; s++) {
              switchCase = ref16[s];
              if (switchCase[0].constructor === Array) {
                ref17 = switchCase[0];
                for (t = 0, len8 = ref17.length; t < len8; t++) {
                  condition = ref17[t];
                  this.csSocketAndMark(condition, depth + 1, 0, indentDepth);
                }
              } else {
                this.csSocketAndMark(switchCase[0], depth + 1, 0, indentDepth);
              }
              this.mark(switchCase[1], depth + 1, 0, null, indentDepth);
            }
            if (node.otherwise != null) {
              return this.mark(node.otherwise, depth + 1, 0, null, indentDepth);
            }
            break;
          case 'Class':
            this.csBlock(node, depth, 0, 'control', wrappingParen, ANY_DROP);
            if (node.variable != null) {
              this.csSocketAndMark(node.variable, depth + 1, 0, indentDepth, FORBID_ALL);
            }
            if (node.parent != null) {
              this.csSocketAndMark(node.parent, depth + 1, 0, indentDepth);
            }
            if (node.body != null) {
              return this.mark(node.body, depth + 1, 0, null, indentDepth);
            }
            break;
          case 'Obj':
            this.csBlock(node, depth, 0, 'violet', wrappingParen, VALUE_ONLY);
            ref18 = node.properties;
            results4 = [];
            for (u = 0, len9 = ref18.length; u < len9; u++) {
              property = ref18[u];
              if (property.nodeType() === 'Assign') {
                this.csSocketAndMark(property.variable, depth + 1, 0, indentDepth, FORBID_ALL);
                results4.push(this.csSocketAndMark(property.value, depth + 1, 0, indentDepth));
              } else {
                results4.push(void 0);
              }
            }
            return results4;
        }
      };

      CoffeeScriptParser.prototype.locationsAreIdentical = function(a, b) {
        return a.line === b.line && a.column === b.column;
      };

      CoffeeScriptParser.prototype.boundMin = function(a, b) {
        if (a.line < b.line) {
          return a;
        } else if (b.line < a.line) {
          return b;
        } else if (a.column < b.column) {
          return a;
        } else {
          return b;
        }
      };

      CoffeeScriptParser.prototype.boundMax = function(a, b) {
        if (a.line < b.line) {
          return b;
        } else if (b.line < a.line) {
          return a;
        } else if (a.column < b.column) {
          return b;
        } else {
          return a;
        }
      };

      CoffeeScriptParser.prototype.getBounds = function(node) {
        var bounds, j, len, match, property, ref, ref1, ref2, ref3;
        bounds = {
          start: {
            line: node.locationData.first_line,
            column: node.locationData.first_column
          },
          end: {
            line: node.locationData.last_line,
            column: node.locationData.last_column + 1
          }
        };
        if (node.nodeType() === 'Block') {
          if (node.expressions.length > 0) {
            bounds.end = this.getBounds(node.expressions[node.expressions.length - 1]).end;
          } else {
            bounds.start = bounds.end;
          }
        }
        if (node.nodeType() === 'If') {
          bounds.start = this.boundMin(bounds.start, this.getBounds(node.body).start);
          bounds.end = this.boundMax(this.getBounds(node.rawCondition).end, this.getBounds(node.body).end);
          if (node.elseBody != null) {
            bounds.end = this.boundMax(bounds.end, this.getBounds(node.elseBody).end);
          }
        }
        if (node.nodeType() === 'While') {
          bounds.start = this.boundMin(bounds.start, this.getBounds(node.body).start);
          bounds.end = this.boundMax(bounds.end, this.getBounds(node.body).end);
          if (node.guard != null) {
            bounds.end = this.boundMax(bounds.end, this.getBounds(node.guard).end);
          }
        }
        if (node.nodeType() === 'Code' && (node.body != null)) {
          bounds.end = this.getBounds(node.body).end;
        }
        while (this.lines[bounds.end.line].slice(0, bounds.end.column).trim().length === 0) {
          bounds.end.line -= 1;
          bounds.end.column = this.lines[bounds.end.line].length + 1;
        }
        if (node.nodeType() === 'Value') {
          bounds = this.getBounds(node.base);
          if ((node.properties != null) && node.properties.length > 0) {
            ref = node.properties;
            for (j = 0, len = ref.length; j < len; j++) {
              property = ref[j];
              bounds.end = this.boundMax(bounds.end, this.getBounds(property).end);
            }
          }
        }
        if (((ref1 = node.dropletParent) != null ? typeof ref1.nodeType === "function" ? ref1.nodeType() : void 0 : void 0) === 'Arr' || ((ref2 = node.dropletParent) != null ? typeof ref2.nodeType === "function" ? ref2.nodeType() : void 0 : void 0) === 'Value' && ((ref3 = node.dropletParent.dropletParent) != null ? typeof ref3.nodeType === "function" ? ref3.nodeType() : void 0 : void 0) === 'Arr') {
          match = this.lines[bounds.end.line].slice(bounds.end.column).match(/^\s*,\s*/);
          if (match != null) {
            bounds.end.column += match[0].length;
          }
        }
        return bounds;
      };

      CoffeeScriptParser.prototype.flagLineAsMarked = function(line) {
        var results;
        this.hasLineBeenMarked[line] = true;
        results = [];
        while (this.lines[line][this.lines[line].length - 1] === '\\') {
          line += 1;
          results.push(this.hasLineBeenMarked[line] = true);
        }
        return results;
      };

      CoffeeScriptParser.prototype.addMarkup = function(container, bounds, depth) {
        CoffeeScriptParser.__super__.addMarkup.apply(this, arguments);
        this.flagLineAsMarked(bounds.start.line);
        return container;
      };

      CoffeeScriptParser.prototype.csBlock = function(node, depth, precedence, color, wrappingParen, classes) {
        if (classes == null) {
          classes = [];
        }
        return this.addBlock({
          bounds: this.getBounds(wrappingParen != null ? wrappingParen : node),
          depth: depth,
          precedence: precedence,
          color: color,
          classes: getClassesFor(node).concat(classes),
          parenWrapped: wrappingParen != null
        });
      };

      CoffeeScriptParser.prototype.csIndent = function(indentDepth, firstNode, lastNode, depth) {
        var first, last, prefix, trueDepth;
        first = this.getBounds(firstNode).start;
        last = this.getBounds(lastNode).end;
        if (this.lines[first.line].slice(0, first.column).trim().length === 0) {
          first.line -= 1;
          first.column = this.lines[first.line].length;
        }
        if (first.line !== last.line) {
          trueDepth = this.lines[last.line].length - this.lines[last.line].trimLeft().length;
          prefix = this.lines[last.line].slice(indentDepth, trueDepth);
        } else {
          trueDepth = indentDepth + 2;
          prefix = '  ';
        }
        this.addIndent({
          bounds: {
            start: first,
            end: last
          },
          depth: depth,
          prefix: prefix
        });
        return trueDepth;
      };

      CoffeeScriptParser.prototype.csIndentAndMark = function(indentDepth, nodes, depth) {
        var j, len, node, results, trueDepth;
        trueDepth = this.csIndent(indentDepth, nodes[0], nodes[nodes.length - 1], depth);
        results = [];
        for (j = 0, len = nodes.length; j < len; j++) {
          node = nodes[j];
          results.push(this.mark(node, depth + 1, 0, null, trueDepth));
        }
        return results;
      };

      CoffeeScriptParser.prototype.csSocket = function(node, depth, precedence, classes) {
        if (classes == null) {
          classes = [];
        }
        return this.addSocket({
          bounds: this.getBounds(node),
          depth: depth,
          precedence: precedence,
          classes: getClassesFor(node).concat(classes)
        });
      };

      CoffeeScriptParser.prototype.csSocketAndMark = function(node, depth, precedence, indentDepth, classes) {
        var socket;
        socket = this.csSocket(node, depth, precedence, classes);
        this.mark(node, depth + 1, precedence, null, indentDepth);
        return socket;
      };

      CoffeeScriptParser.prototype.wrapSemicolonLine = function(firstBounds, lastBounds, expressions, depth) {
        var child, j, len, results, surroundingBounds;
        surroundingBounds = {
          start: firstBounds.start,
          end: lastBounds.end
        };
        this.addBlock({
          bounds: surroundingBounds,
          depth: depth + 1,
          precedence: -2,
          color: 'command',
          socketLevel: ANY_DROP,
          classes: ['semicolon']
        });
        results = [];
        for (j = 0, len = expressions.length; j < len; j++) {
          child = expressions[j];
          results.push(this.csSocket(child, depth + 2, -2));
        }
        return results;
      };

      CoffeeScriptParser.prototype.wrapSemicolons = function(expressions, depth) {
        var bounds, expr, firstBounds, firstNode, j, lastBounds, lastNode, len, nodesOnCurrentLine;
        firstNode = lastNode = firstBounds = lastBounds = null;
        nodesOnCurrentLine = [];
        for (j = 0, len = expressions.length; j < len; j++) {
          expr = expressions[j];
          bounds = this.getBounds(expr);
          if (bounds.start.line === (firstBounds != null ? firstBounds.end.line : void 0)) {
            lastNode = expr;
            lastBounds = bounds;
            nodesOnCurrentLine.push(expr);
          } else {
            if (lastNode != null) {
              this.wrapSemicolonLine(firstBounds, lastBounds, nodesOnCurrentLine, depth);
            }
            firstNode = expr;
            lastNode = null;
            firstBounds = this.getBounds(expr);
            lastBounds = null;
            nodesOnCurrentLine = [expr];
          }
        }
        if (lastNode != null) {
          return this.wrapSemicolonLine(firstBounds, lastBounds, nodesOnCurrentLine, depth);
        }
      };

      return CoffeeScriptParser;

    })(parser.Parser);
    fixCoffeeScriptError = function(lines, e) {
      var unmatchedline;
      if (/unexpected\s*(?:newline|if|for|while|switch|unless|end of input)/.test(e.message) && /^\s*(?:if|for|while|unless)\s+\S+/.test(lines[e.location.first_line])) {
        return addEmptyBackTickLineAfter(lines, e.location.first_line);
      }
      if (/unexpected/.test(e.message)) {
        return backTickLine(lines, e.location.first_line);
      }
      if (/missing "/.test(e.message) && indexOf.call(lines[e.location.first_line], '"') >= 0) {
        return backTickLine(lines, e.location.first_line);
      }
      if (/unmatched|missing \)/.test(e.message)) {
        unmatchedline = findUnmatchedLine(lines, e.location.first_line);
        if (unmatchedline !== null) {
          return backTickLine(lines, unmatchedline);
        }
      }
      return null;
    };
    findUnmatchedLine = function(lines, above) {
      return null;
    };
    backTickLine = function(lines, n) {
      if (n < 0 || n >= lines.length) {
        return false;
      }
      if (/`/.test(lines[n]) || /^\s*$/.test(lines[n])) {
        return false;
      }
      lines[n] = lines[n].replace(/^(\s*)(\S.*\S|\S)(\s*)$/, '$1`#$2`$3');
      return true;
    };
    addEmptyBackTickLineAfter = function(lines, n) {
      var leading;
      if (n < 0 || n >= lines.length) {
        return false;
      }
      if (n + 1 < lines.length && /^\s*``$/.test(lines[n + 1])) {
        return false;
      }
      leading = /^\s*/.exec(lines[n]);
      if (!leading || leading[0].length >= lines[n].length) {
        return false;
      }
      return lines.splice(n + 1, 0, leading[0] + '  ``');
    };
    CoffeeScriptParser.empty = "``";
    CoffeeScriptParser.drop = function(block, context, pred) {
      var ref, ref1;
      if (context.type === 'socket') {
        if (indexOf.call(context.classes, 'forbid-all') >= 0) {
          return helper.FORBID;
        }
        if (indexOf.call(context.classes, 'lvalue') >= 0) {
          if (indexOf.call(block.classes, 'Value') >= 0 && ((ref = block.properties) != null ? ref.length : void 0) > 0) {
            return helper.ENCOURAGE;
          } else {
            return helper.FORBID;
          }
        } else if (indexOf.call(context.classes, 'property-access') >= 0) {
          if (indexOf.call(block.classes, 'works-as-method-call') >= 0) {
            return helper.ENCOURAGE;
          } else {
            return helper.FORBID;
          }
        } else if (indexOf.call(block.classes, 'value-only') >= 0 || indexOf.call(block.classes, 'mostly-value') >= 0 || indexOf.call(block.classes, 'any-drop') >= 0) {
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
    CoffeeScriptParser.parens = function(leading, trailing, node, context) {
      trailing(trailing().replace(/\s*,\s*$/, ''));
      if (context === null || context.type !== 'socket' || context.precedence < node.precedence) {
        while (true) {
          if ((leading().match(/^\s*\(/) != null) && (trailing().match(/\)\s*/) != null)) {
            leading(leading().replace(/^\s*\(\s*/, ''));
            trailing(trailing().replace(/\s*\)\s*$/, ''));
          } else {
            break;
          }
        }
      } else {
        leading('(' + leading());
        trailing(trailing() + ')');
      }
    };
    return parser.wrapParser(CoffeeScriptParser);
  });

}).call(this);

//# sourceMappingURL=coffee.js.map
