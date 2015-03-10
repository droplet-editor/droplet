(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(['droplet-helper', 'droplet-model'], function(helper, model) {
    var Parser, ParserFactory, YES, _extend, exports, hasSomeTextAfter, stripFlaggedBlocks;
    exports = {};
    _extend = function(opts, defaults) {
      var key, val;
      if (opts == null) {
        return defaults;
      }
      for (key in defaults) {
        val = defaults[key];
        if (!(key in opts)) {
          opts[key] = val;
        }
      }
      return opts;
    };
    YES = function() {
      return true;
    };
    exports.ParserFactory = ParserFactory = (function() {
      function ParserFactory(opts1) {
        this.opts = opts1 != null ? opts1 : {};
      }

      ParserFactory.prototype.createParser = function(text) {
        return new Parser(text, this.opts);
      };

      return ParserFactory;

    })();
    exports.Parser = Parser = (function() {
      function Parser(text1, opts1) {
        this.text = text1;
        this.opts = opts1 != null ? opts1 : {};
        this.originalText = this.text;
        this.markup = [];
      }

      Parser.prototype._parse = function(opts) {
        var segment;
        opts = _extend(opts, {
          wrapAtRoot: true
        });
        this.markRoot();
        this.sortMarkup();
        segment = this.applyMarkup(opts);
        this.detectParenWrap(segment);
        stripFlaggedBlocks(segment);
        segment.correctParentTree();
        segment.isRoot = true;
        return segment;
      };

      Parser.prototype.markRoot = function() {};

      Parser.prototype.isParenWrapped = function(block) {
        return block.start.next.type === 'text' && block.start.next.value[0] === '(' && block.end.prev.type === 'text' && block.end.prev.value[block.end.prev.value.length - 1] === ')';
      };

      Parser.prototype.detectParenWrap = function(segment) {
        var head;
        head = segment.start;
        while (head !== segment.end) {
          head = head.next;
          if (head.type === 'blockStart' && this.isParenWrapped(head.container)) {
            head.container.currentlyParenWrapped = true;
          }
        }
        return segment;
      };

      Parser.prototype.addBlock = function(opts) {
        var block;
        block = new model.Block(opts.precedence, opts.color, opts.socketLevel, opts.classes, false);
        return this.addMarkup(block, opts.bounds, opts.depth);
      };

      Parser.prototype.addSocket = function(opts) {
        var socket;
        socket = new model.Socket(opts.precedence, false, opts.classes);
        return this.addMarkup(socket, opts.bounds, opts.depth);
      };

      Parser.prototype.addIndent = function(opts) {
        var indent;
        indent = new model.Indent(opts.prefix, opts.classes);
        return this.addMarkup(indent, opts.bounds, opts.depth);
      };

      Parser.prototype.addMarkup = function(container, bounds, depth) {
        this.markup.push({
          token: container.start,
          location: bounds.start,
          depth: depth,
          start: true
        });
        this.markup.push({
          token: container.end,
          location: bounds.end,
          depth: depth,
          start: false
        });
        return container;
      };

      Parser.prototype.sortMarkup = function() {
        return this.markup.sort(function(a, b) {
          var isDifferent;
          if (a.location.line > b.location.line) {
            return 1;
          }
          if (b.location.line > a.location.line) {
            return -1;
          }
          if (a.location.column > b.location.column) {
            return 1;
          }
          if (b.location.column > a.location.column) {
            return -1;
          }
          isDifferent = 1;
          if (a.token.container === b.token.container) {
            isDifferent = -1;
          }
          if (a.start && !b.start) {
            return isDifferent;
          }
          if (b.start && !a.start) {
            return -isDifferent;
          }
          if (a.start && b.start) {
            if (a.depth > b.depth) {
              return 1;
            } else {
              return -1;
            }
          }
          if ((!a.start) && (!b.start)) {
            if (a.depth > b.depth) {
              return -1;
            } else {
              return 1;
            }
          }
        });
      };

      Parser.prototype.constructHandwrittenBlock = function(text) {
        var block, socket, textToken;
        block = new model.Block(0, 'blank', helper.ANY_DROP, false);
        socket = new model.Socket(0, true);
        textToken = new model.TextToken(text);
        block.start.append(socket.start);
        socket.start.append(textToken);
        textToken.append(socket.end);
        socket.end.append(block.end);
        if (this.isComment(text)) {
          block.socketLevel = helper.BLOCK_ONLY;
        }
        return block;
      };

      Parser.prototype.applyMarkup = function(opts) {
        var block, document, head, i, indentDepth, j, k, l, lastIndex, len, len1, len2, line, lines, mark, markupOnLines, name, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, stack;
        markupOnLines = {};
        ref = this.markup;
        for (j = 0, len = ref.length; j < len; j++) {
          mark = ref[j];
          if (markupOnLines[name = mark.location.line] == null) {
            markupOnLines[name] = [];
          }
          markupOnLines[mark.location.line].push(mark);
        }
        lines = this.text.split('\n');
        indentDepth = 0;
        stack = [];
        document = new model.Segment();
        head = document.start;
        for (i = k = 0, len1 = lines.length; k < len1; i = ++k) {
          line = lines[i];
          if (!(i in markupOnLines)) {
            if (indentDepth >= line.length || line.slice(0, indentDepth).trim().length > 0) {
              head.specialIndent = ((function() {
                var l, ref1, results;
                results = [];
                for (l = 0, ref1 = line.length - line.trimLeft().length; 0 <= ref1 ? l < ref1 : l > ref1; 0 <= ref1 ? l++ : l--) {
                  results.push(' ');
                }
                return results;
              })()).join('');
              line = line.trimLeft();
            } else {
              line = line.slice(indentDepth);
            }
            if (line.length > 0) {
              if ((opts.wrapAtRoot && stack.length === 0) || ((ref1 = stack[stack.length - 1]) != null ? ref1.type : void 0) === 'indent') {
                block = this.constructHandwrittenBlock(line);
                head.append(block.start);
                head = block.end;
              } else {
                head = head.append(new model.TextToken(line));
              }
            } else if (((ref2 = (ref3 = stack[stack.length - 1]) != null ? ref3.type : void 0) === 'indent' || ref2 === 'segment' || ref2 === (void 0)) && hasSomeTextAfter(lines, i)) {
              block = new model.Block(0, 'yellow', helper.BLOCK_ONLY);
              head = head.append(block.start);
              head = head.append(block.end);
            }
            head = head.append(new model.NewlineToken());
          } else {
            if (indentDepth >= line.length || line.slice(0, indentDepth).trim().length > 0) {
              lastIndex = line.length - line.trimLeft().length;
              head.specialIndent = line.slice(0, lastIndex);
            } else {
              lastIndex = indentDepth;
            }
            ref4 = markupOnLines[i];
            for (l = 0, len2 = ref4.length; l < len2; l++) {
              mark = ref4[l];
              if (!(lastIndex >= mark.location.column || lastIndex >= line.length)) {
                if ((opts.wrapAtRoot && stack.length === 0) || ((ref5 = stack[stack.length - 1]) != null ? ref5.type : void 0) === 'indent') {
                  block = this.constructHandwrittenBlock(line.slice(lastIndex, mark.location.column));
                  head.append(block.start);
                  head = block.end;
                } else {
                  head = head.append(new model.TextToken(line.slice(lastIndex, mark.location.column)));
                }
              }
              switch (mark.token.type) {
                case 'indentStart':
                  if ((stack != null ? (ref6 = stack[stack.length - 1]) != null ? ref6.type : void 0 : void 0) !== 'block') {
                    throw new Error('Improper parser: indent must be inside block, but is inside ' + (stack != null ? (ref7 = stack[stack.length - 1]) != null ? ref7.type : void 0 : void 0));
                  }
                  indentDepth += mark.token.container.prefix.length;
                  break;
                case 'blockStart':
                  if (((ref8 = stack[stack.length - 1]) != null ? ref8.type : void 0) === 'block') {
                    throw new Error('Improper parser: block cannot nest immediately inside another block.');
                  }
                  break;
                case 'socketStart':
                  if (((ref9 = stack[stack.length - 1]) != null ? ref9.type : void 0) !== 'block') {
                    throw new Error('Improper parser: socket must be immediately inside a block.');
                  }
                  break;
                case 'indentEnd':
                  indentDepth -= mark.token.container.prefix.length;
              }
              if (mark.token instanceof model.StartToken) {
                stack.push(mark.token.container);
              } else if (mark.token instanceof model.EndToken) {
                if (mark.token.container !== stack[stack.length - 1]) {
                  throw new Error("Improper parser: " + head.container.type + " ended too early.");
                }
                stack.pop();
              }
              head = head.append(mark.token);
              lastIndex = mark.location.column;
            }
            if (!(lastIndex >= line.length)) {
              head = head.append(new model.TextToken(line.slice(lastIndex, line.length)));
            }
            head = head.append(new model.NewlineToken());
          }
        }
        head = head.prev;
        head.next.remove();
        head = head.append(document.end);
        return document;
      };

      return Parser;

    })();
    exports.parseXML = function(xml) {
      var head, parser, root, stack;
      root = new model.Segment();
      head = root.start;
      stack = [];
      parser = sax.parser(true);
      parser.ontext = function(text) {
        var i, j, len, results, token, tokens;
        tokens = text.split('\n');
        results = [];
        for (i = j = 0, len = tokens.length; j < len; i = ++j) {
          token = tokens[i];
          if (token.length !== 0) {
            head = head.append(new model.TextToken(token));
          }
          if (i !== tokens.length - 1) {
            results.push(head = head.append(new model.NewlineToken()));
          } else {
            results.push(void 0);
          }
        }
        return results;
      };
      parser.onopentag = function(node) {
        var attributes, container, ref, ref1, ref2;
        attributes = node.attributes;
        switch (node.name) {
          case 'block':
            container = new model.Block(attributes.precedence, attributes.color, attributes.socketLevel, (ref = attributes.classes) != null ? typeof ref.split === "function" ? ref.split(' ') : void 0 : void 0);
            break;
          case 'socket':
            container = new model.Socket(attributes.precedence, attributes.handritten, (ref1 = attributes.classes) != null ? typeof ref1.split === "function" ? ref1.split(' ') : void 0 : void 0);
            break;
          case 'indent':
            container = new model.Indent(attributes.prefix, (ref2 = attributes.classe) != null ? typeof ref2.split === "function" ? ref2.split(' ') : void 0 : void 0);
            break;
          case 'segment':
            if (stack.length !== 0) {
              container = new model.Segment();
            }
            break;
          case 'br':
            head = head.append(new model.NewlineToken());
            return null;
        }
        if (container != null) {
          stack.push({
            node: node,
            container: container
          });
          return head = head.append(container.start);
        }
      };
      parser.onclosetag = function(nodeName) {
        if (stack.length > 0 && nodeName === stack[stack.length - 1].node.name) {
          head = head.append(stack[stack.length - 1].container.end);
          return stack.pop();
        }
      };
      parser.onerror = function(e) {
        throw e;
      };
      parser.write(xml).close();
      head = head.append(root.end);
      return root;
    };
    hasSomeTextAfter = function(lines, i) {
      while (i !== lines.length) {
        if (lines[i].length > 0) {
          return true;
        }
        i += 1;
      }
      return false;
    };
    stripFlaggedBlocks = function(segment) {
      var container, head, ref, results, text;
      head = segment.start;
      results = [];
      while (head !== segment.end) {
        if (head instanceof model.StartToken && head.container.flagToRemove) {
          container = head.container;
          head = container.end.next;
          results.push(container.spliceOut());
        } else if (head instanceof model.StartToken && head.container.flagToStrip) {
          if ((ref = head.container.parent) != null) {
            ref.color = 'error';
          }
          text = head.next;
          text.value = text.value.substring(head.container.flagToStrip.left, text.value.length - head.container.flagToStrip.right);
          results.push(head = text.next);
        } else {
          results.push(head = head.next);
        }
      }
      return results;
    };
    Parser.parens = function(leading, trailing, node, context) {
      var results;
      if (context === null || context.type !== 'socket' || (context != null ? context.precedence : void 0) < node.precedence) {
        results = [];
        while (true) {
          if ((leading().match(/^\s*\(/) != null) && (trailing().match(/\)\s*/) != null)) {
            leading(leading().replace(/^\s*\(\s*/, ''));
            results.push(trailing(trailing().replace(/^\s*\)\s*/, '')));
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
    Parser.drop = function(block, context, pred) {
      if (block.type === 'segment' && context.type === 'socket') {
        return helper.FORBID;
      } else {
        return helper.ENCOURAGE;
      }
    };
    Parser.normalString = function(str) {
      return str.trim();
    };
    Parser.escapeString = function(str) {
      console.log(str);
      str = str.trim();
      return str = str[0] + str.slice(1, -1).replace(/(\'|\"|\n)/g, '\\$1') + str[str.length - 1];
    };
    Parser.empty = '';
    exports.wrapParser = function(CustomParser) {
      var CustomParserFactory;
      return CustomParserFactory = (function(superClass) {
        extend(CustomParserFactory, superClass);

        function CustomParserFactory(opts1) {
          this.opts = opts1 != null ? opts1 : {};
          this.empty = CustomParser.empty;
        }

        CustomParserFactory.prototype.createParser = function(text) {
          return new CustomParser(text, this.opts);
        };

        CustomParserFactory.prototype.parse = function(text, opts) {
          if (opts == null) {
            opts = {
              wrapAtRoot: true
            };
          }
          return this.createParser(text)._parse(opts);
        };

        CustomParserFactory.prototype.parens = function(leading, trailing, node, context) {
          var leadingFn, trailingFn;
          leadingFn = function(value) {
            if (value != null) {
              leading = value;
            }
            return leading;
          };
          if (trailing != null) {
            trailingFn = function(value) {
              if (value != null) {
                trailing = value;
              }
              return trailing;
            };
          } else {
            trailingFn = leadingFn;
          }
          CustomParser.parens(leadingFn, trailingFn, node, context);
          return [leading, trailing];
        };

        CustomParserFactory.prototype.drop = function(block, context, pred) {
          return CustomParser.drop(block, context, pred);
        };

        CustomParserFactory.prototype.normalString = function(str) {
          return CustomParser.normalString(str);
        };

        CustomParserFactory.prototype.escapeString = function(str) {
          return CustomParser.escapeString(str);
        };

        return CustomParserFactory;

      })(ParserFactory);
    };
    return exports;
  });

}).call(this);

//# sourceMappingURL=parser.js.map
