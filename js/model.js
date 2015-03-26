(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(['droplet-helper'], function(helper) {
    var Block, BlockEndToken, BlockStartToken, Container, CursorToken, EndToken, FORBID, Indent, IndentEndToken, IndentStartToken, NO, NORMAL, NewlineToken, Segment, SegmentEndToken, SegmentStartToken, Socket, SocketEndToken, SocketStartToken, StartToken, TextToken, Token, YES, _id, exports, traverseOneLevel;
    exports = {};
    YES = function() {
      return true;
    };
    NO = function() {
      return false;
    };
    NORMAL = {
      "default": helper.NORMAL
    };
    FORBID = {
      "default": helper.FORBID
    };
    _id = 0;
    Function.prototype.trigger = function(prop, get, set) {
      return Object.defineProperty(this.prototype, prop, {
        get: get,
        set: set
      });
    };
    exports.isTreeValid = function(tree) {
      var hare, k, lastHare, ref, ref1, ref2, ref3, stack, tortise;
      tortise = hare = tree.start.next;
      stack = [];
      while (true) {
        tortise = tortise.next;
        lastHare = hare;
        hare = hare.next;
        if (hare == null) {
          window._ice_debug_lastHare = lastHare;
          throw new Error('Ran off the end of the document before EOF');
        }
        if (lastHare !== hare.prev) {
          throw new Error('Linked list is not properly bidirectional');
        }
        if (hare === tree.end) {
          if (stack.length > 0) {
            throw new Error('Document ended before: ' + ((function() {
              var i, len, results;
              results = [];
              for (i = 0, len = stack.length; i < len; i++) {
                k = stack[i];
                results.push(k.type);
              }
              return results;
            })()).join(','));
          }
          break;
        }
        if (hare instanceof StartToken) {
          stack.push(hare.container);
        } else if (hare instanceof EndToken) {
          if (stack[stack.length - 1] !== hare.container) {
            throw new Error("Stack does not align " + ((ref = stack[stack.length - 1]) != null ? ref.type : void 0) + " != " + ((ref1 = hare.container) != null ? ref1.type : void 0));
          } else {
            stack.pop();
          }
        }
        lastHare = hare;
        hare = hare.next;
        if (hare == null) {
          window._ice_debug_lastHare = lastHare;
          throw new Error('Ran off the end of the document before EOF');
        }
        if (lastHare !== hare.prev) {
          throw new Error('Linked list is not properly bidirectional');
        }
        if (hare === tree.end) {
          if (stack.length > 0) {
            throw new Error('Document ended before: ' + ((function() {
              var i, len, results;
              results = [];
              for (i = 0, len = stack.length; i < len; i++) {
                k = stack[i];
                results.push(k.type);
              }
              return results;
            })()).join(','));
          }
          break;
        }
        if (hare instanceof StartToken) {
          stack.push(hare.container);
        } else if (hare instanceof EndToken) {
          if (stack[stack.length - 1] !== hare.container) {
            throw new Error("Stack does not align " + ((ref2 = stack[stack.length - 1]) != null ? ref2.type : void 0) + " != " + ((ref3 = hare.container) != null ? ref3.type : void 0));
          } else {
            stack.pop();
          }
        }
        if (tortise === hare) {
          throw new Error('Linked list loops');
        }
      }
      return true;
    };
    exports.Container = Container = (function() {
      function Container() {
        if (!((this.start != null) || (this.end != null))) {
          this.start = new StartToken(this);
          this.end = new EndToken(this);
          this.type = 'container';
        }
        this.id = ++_id;
        this.parent = null;
        this.version = 0;
        this.start.append(this.end);
        this.ephemeral = false;
        this.lineMarkStyles = [];
      }

      Container.prototype._cloneEmpty = function() {
        return new Container();
      };

      Container.prototype.getReader = function() {
        return {
          id: this.id,
          type: this.type,
          precedence: this.precedence,
          classes: this.classes
        };
      };

      Container.prototype.hasParent = function(parent) {
        var head;
        head = this;
        while (head !== parent && head !== null) {
          head = head.parent;
        }
        return head === parent;
      };

      Container.prototype.getCommonParent = function(other) {
        var head;
        head = this;
        while (!other.hasParent(head)) {
          head = head.parent;
        }
        return head;
      };

      Container.prototype.getLinesToParent = function() {
        var head, lines;
        head = this.start;
        lines = 0;
        while (head !== this.parent.start) {
          if (head.type === 'newline') {
            lines++;
          }
          head = head.prev;
        }
        return lines;
      };

      Container.prototype.hasCommonParent = function(other) {
        var head;
        head = this;
        while (!other.hasParent(head)) {
          head = head.parent;
        }
        return head != null;
      };

      Container.prototype.rawReplace = function(other) {
        if (other.start.prev != null) {
          other.start.prev.append(this.start);
        }
        if (other.end.next != null) {
          this.end.append(other.end.next);
        }
        this.start.parent = this.end.parent = this.parent = other.parent;
        other.parent = other.start.parent = other.end.parent = null;
        other.start.prev = other.end.next = null;
        return this.notifyChange();
      };

      Container.prototype.getNewlineBefore = function(n) {
        var head, lines;
        head = this.start;
        lines = 0;
        while (!(lines === n || head === this.end)) {
          head = head.next;
          if (head.type === 'newline') {
            lines++;
          }
        }
        return head;
      };

      Container.prototype.getNewlineAfter = function(n) {
        var head;
        head = this.getNewlineBefore(n).next;
        while (!(start.type === 'newline' || head === this.end)) {
          head = head.next;
        }
        return head;
      };

      Container.prototype.getLeadingText = function() {
        if (this.start.next.type === 'text') {
          return this.start.next.value;
        } else {
          return '';
        }
      };

      Container.prototype.getTrailingText = function() {
        if (this.end.prev.type === 'text') {
          return this.end.prev.value;
        } else {
          return '';
        }
      };

      Container.prototype.setLeadingText = function(value) {
        if (value != null) {
          if (this.start.next.type === 'text') {
            if (value.length === 0) {
              return this.start.next.remove();
            } else {
              return this.start.next.value = value;
            }
          } else if (value.length !== 0) {
            return this.start.insert(new TextToken(value));
          }
        }
      };

      Container.prototype.setTrailingText = function(value) {
        if (value != null) {
          if (this.end.prev.type === 'text') {
            if (value.length === 0) {
              return this.end.prev.remove();
            } else {
              return this.end.prev.value = value;
            }
          } else if (value.length !== 0) {
            return this.end.insertBefore(new TextToken(value));
          }
        }
      };

      Container.prototype.clone = function() {
        var assembler, selfClone;
        selfClone = this._cloneEmpty();
        assembler = selfClone.start;
        this.traverseOneLevel((function(_this) {
          return function(head, isContainer) {
            var clone;
            if (isContainer) {
              clone = head.clone();
              assembler.append(clone.start);
              return assembler = clone.end;
            } else if (head.type !== 'cursor') {
              return assembler = assembler.append(head.clone());
            }
          };
        })(this));
        assembler.append(selfClone.end);
        selfClone.correctParentTree();
        return selfClone;
      };

      Container.prototype.stringify = function(emptyToken) {
        var head, state, str;
        if (emptyToken == null) {
          emptyToken = '';
        }
        str = '';
        head = this.start.next;
        state = {
          indent: '',
          emptyToken: emptyToken
        };
        while (head !== this.end) {
          str += head.stringify(state);
          head = head.next;
        }
        return str;
      };

      Container.prototype.serialize = function() {
        var str;
        str = this._serialize_header();
        this.traverseOneLevel(function(child) {
          return str += child.serialize();
        });
        return str += this._serialize_footer();
      };

      Container.prototype._serialize_header = "<container>";

      Container.prototype._serialize_header = "</container>";

      Container.prototype.contents = function() {
        var clone;
        clone = this.clone();
        if (clone.start.next === clone.end) {
          return null;
        } else {
          clone.start.next.prev = null;
          clone.end.prev.next = null;
          return clone.start.next;
        }
      };

      Container.prototype.spliceOut = function() {
        var first, last, ref, ref1, ref2, ref3;
        first = this.start.previousVisibleToken();
        last = this.end.nextVisibleToken();
        while ((first != null ? first.type : void 0) === 'newline' && ((ref = last != null ? last.type : void 0) === (void 0) || ref === 'newline' || ref === 'indentEnd' || ref === 'segmentEnd') && !(((ref1 = first.previousVisibleToken()) != null ? ref1.type : void 0) === 'indentStart' && first.previousVisibleToken().container.end === last)) {
          first = first.previousVisibleToken();
          first.nextVisibleToken().remove();
        }
        while ((last != null ? last.type : void 0) === 'newline' && ((last != null ? (ref2 = last.nextVisibleToken()) != null ? ref2.type : void 0 : void 0) === 'newline' || ((ref3 = first != null ? first.type : void 0) === (void 0) || ref3 === 'segmentStart'))) {
          last = last.nextVisibleToken();
          last.previousVisibleToken().remove();
        }
        this.notifyChange();
        if (this.start.prev != null) {
          this.start.prev.append(this.end.next);
        } else if (this.end.next != null) {
          this.end.next.prev = null;
        }
        this.start.prev = this.end.next = null;
        return this.start.parent = this.end.parent = this.parent = null;
      };

      Container.prototype.spliceIn = function(token) {
        var head, last, ref;
        while (token.type === 'cursor') {
          token = token.prev;
        }
        this.ephemeral = false;
        switch (token.type) {
          case 'indentStart':
            head = token.container.end.prev;
            while ((ref = head.type) === 'cursor' || ref === 'segmentEnd' || ref === 'segmentStart') {
              head = head.prev;
            }
            if (head.type === 'newline') {
              token = token.next;
            } else {
              token = token.insert(new NewlineToken());
            }
            break;
          case 'blockEnd':
            token = token.insert(new NewlineToken());
            break;
          case 'segmentStart':
            if (token.nextVisibleToken() !== token.container.end) {
              token.insert(new NewlineToken());
            }
            break;
          case 'socketStart':
            token.append(token.container.end);
        }
        last = token.next;
        token.append(this.start);
        this.start.parent = this.end.parent = this.parent;
        this.end.append(last);
        return this.notifyChange();
      };

      Container.prototype.moveTo = function(token, mode) {
        var leading, ref, ref1, ref2, trailing;
        if ((this.start.prev != null) || (this.end.next != null)) {
          leading = this.getLeadingText();
          trailing = this.getTrailingText();
          ref = mode.parens(leading, trailing, this, null), leading = ref[0], trailing = ref[1];
          this.setLeadingText(leading);
          this.setTrailingText(trailing);
          this.spliceOut();
        }
        if (token != null) {
          leading = this.getLeadingText();
          trailing = this.getTrailingText();
          ref2 = mode.parens(leading, trailing, this, (ref1 = token.container) != null ? ref1 : token.parent), leading = ref2[0], trailing = ref2[1];
          this.setLeadingText(leading);
          this.setTrailingText(trailing);
          return this.spliceIn(token);
        }
      };

      Container.prototype.notifyChange = function() {
        var head, results;
        head = this;
        results = [];
        while (head != null) {
          head.version++;
          results.push(head = head.parent);
        }
        return results;
      };

      Container.prototype.wrap = function(first, last) {
        this.parent = this.start.parent = this.end.parent = first.parent;
        first.prev.append(this.start);
        this.start.append(first);
        this.end.append(last.next);
        last.append(this.end);
        traverseOneLevel(first, (function(_this) {
          return function(head, isContainer) {
            return head.parent = _this;
          };
        })(this));
        return this.notifyChange();
      };

      Container.prototype.correctParentTree = function() {
        return this.traverseOneLevel((function(_this) {
          return function(head, isContainer) {
            head.parent = _this;
            if (isContainer) {
              head.start.parent = head.end.parent = _this;
              return head.correctParentTree();
            }
          };
        })(this));
      };

      Container.prototype.find = function(fn, excludes) {
        var examined, head, ref;
        if (excludes == null) {
          excludes = [];
        }
        head = this.start;
        while (head !== this.end) {
          examined = head instanceof StartToken ? head.container : head;
          if (indexOf.call(excludes, examined) >= 0) {
            head = examined.end;
          }
          if (!(head instanceof EndToken || ((ref = head.type) === 'newline' || ref === 'cursor'))) {
            if (fn(examined)) {
              return examined;
            }
          }
          head = head.next;
        }
        if (fn(this)) {
          return this;
        }
      };

      Container.prototype.getTokenAtLocation = function(loc) {
        var count, head;
        if (loc == null) {
          return null;
        } else if (loc === 0) {
          return this.start;
        } else {
          head = this.start;
          count = 1;
          while (!(count === loc || head === this.end)) {
            if ((head != null ? head.type : void 0) !== 'cursor') {
              count++;
            }
            head = head.next;
          }
          while ((head != null ? head.type : void 0) === 'cursor') {
            head = head.next;
          }
          return head;
        }
      };

      Container.prototype.getBlockOnLine = function(line) {
        var head, lineCount, ref, stack;
        head = this.start;
        lineCount = 0;
        stack = [];
        while (!(lineCount === line || (head == null))) {
          switch (head.type) {
            case 'newline':
              lineCount++;
              break;
            case 'blockStart':
              stack.push(head.container);
              break;
            case 'blockEnd':
              stack.pop();
          }
          head = head.next;
        }
        while ((ref = head != null ? head.type : void 0) === 'newline' || ref === 'cursor' || ref === 'segmentStart' || ref === 'segmentEnd') {
          head = head.next;
        }
        if ((head != null ? head.type : void 0) === 'blockStart') {
          stack.push(head.container);
        }
        return stack[stack.length - 1];
      };

      Container.prototype.traverseOneLevel = function(fn) {
        return traverseOneLevel(this.start.next, fn);
      };

      Container.prototype.isFirstOnLine = function() {
        var ref, ref1, ref2, ref3, ref4;
        return ((ref = this.start.previousVisibleToken()) === ((ref1 = this.parent) != null ? ref1.start : void 0) || ref === ((ref2 = this.parent) != null ? (ref3 = ref2.parent) != null ? ref3.start : void 0 : void 0) || ref === null) || ((ref4 = this.start.previousVisibleToken()) != null ? ref4.type : void 0) === 'newline';
      };

      Container.prototype.isLastOnLine = function() {
        var ref, ref1, ref2, ref3, ref4, ref5;
        return ((ref = this.end.nextVisibleToken()) === ((ref1 = this.parent) != null ? ref1.end : void 0) || ref === ((ref2 = this.parent) != null ? (ref3 = ref2.parent) != null ? ref3.end : void 0 : void 0) || ref === null) || ((ref4 = (ref5 = this.end.nextVisibleToken()) != null ? ref5.type : void 0) === 'newline' || ref4 === 'indentStart' || ref4 === 'indentEnd');
      };

      Container.prototype.visParent = function() {
        var head;
        head = this.parent;
        while ((head != null ? head.type : void 0) === 'segment' && head.isLassoSegment) {
          head = head.parent;
        }
        return head;
      };

      Container.prototype.addLineMark = function(mark) {
        return this.lineMarkStyles.push(mark);
      };

      Container.prototype.removeLineMark = function(tag) {
        var mark;
        return this.lineMarkStyles = (function() {
          var i, len, ref, results;
          ref = this.lineMarkStyles;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            mark = ref[i];
            if (mark.tag !== tag) {
              results.push(mark);
            }
          }
          return results;
        }).call(this);
      };

      Container.prototype.clearLineMarks = function() {
        return this.lineMarkStyles = [];
      };

      return Container;

    })();
    exports.Token = Token = (function() {
      function Token() {
        this.id = ++_id;
        this.prev = this.next = this.parent = null;
        this.version = 0;
      }

      Token.prototype.hasParent = function(parent) {
        var head;
        head = this;
        while (head !== parent && head !== null) {
          head = head.parent;
        }
        return head === parent;
      };

      Token.prototype.visParent = function() {
        var head;
        head = this.parent;
        while ((head != null ? head.type : void 0) === 'segment' && head.isLassoSegment) {
          head = head.parent;
        }
        return head;
      };

      Token.prototype.getCommonParent = function(other) {
        var head;
        head = this;
        while (!other.hasParent(head)) {
          head = head.parent;
        }
        return head;
      };

      Token.prototype.hasCommonParent = function(other) {
        var head;
        head = this;
        while (!other.hasParent(head)) {
          head = head.parent;
        }
        return head != null;
      };

      Token.prototype.append = function(token) {
        this.next = token;
        if (!token) {
          return;
        }
        token.prev = this;
        if (token.parent !== this.parent) {
          traverseOneLevel(token, (function(_this) {
            return function(head) {
              return head.parent = _this.parent;
            };
          })(this));
        }
        return token;
      };

      Token.prototype.insert = function(token) {
        if (token instanceof StartToken || token instanceof EndToken) {
          console.warn('"insert"-ing a container can cause problems');
        }
        token.next = this.next;
        token.prev = this;
        this.next.prev = token;
        this.next = token;
        token.parent = this.parent;
        return token;
      };

      Token.prototype.insertBefore = function(token) {
        if (this.prev != null) {
          return this.prev.insert(token);
        } else {
          this.prev = token;
          token.next = this;
          return token.parent = this.parent;
        }
      };

      Token.prototype.remove = function() {
        if (this.prev != null) {
          this.prev.append(this.next);
        } else if (this.next != null) {
          this.next.prev = null;
        }
        return this.prev = this.next = this.parent = null;
      };

      Token.prototype.isVisible = YES;

      Token.prototype.isAffect = YES;

      Token.prototype.previousVisibleToken = function() {
        var head;
        head = this.prev;
        while (!((head == null) || head.isVisible())) {
          head = head.prev;
        }
        return head;
      };

      Token.prototype.nextVisibleToken = function() {
        var head;
        head = this.next;
        while (!((head == null) || head.isVisible())) {
          head = head.next;
        }
        return head;
      };

      Token.prototype.previousAffectToken = function() {
        var head;
        head = this.prev;
        while (!((head == null) || head.isAffect())) {
          head = head.prev;
        }
        return head;
      };

      Token.prototype.nextAffectToken = function() {
        var head;
        head = this.next;
        while (!((head == null) || head.isAffect())) {
          head = head.next;
        }
        return head;
      };

      Token.prototype.notifyChange = function() {
        var head;
        head = this;
        while (head != null) {
          head.version++;
          head = head.parent;
        }
        return null;
      };

      Token.prototype.isFirstOnLine = function() {
        var ref, ref1;
        return this.previousVisibleToken() === ((ref = this.parent) != null ? ref.start : void 0) || ((ref1 = this.previousVisibleToken()) != null ? ref1.type : void 0) === 'newline';
      };

      Token.prototype.isLastOnLine = function() {
        var ref, ref1, ref2;
        return this.nextVisibleToken() === ((ref = this.parent) != null ? ref.end : void 0) || ((ref1 = (ref2 = this.nextVisibleToken()) != null ? ref2.type : void 0) === 'newline' || ref1 === 'indentEnd');
      };

      Token.prototype.getSerializedLocation = function() {
        var count, head;
        head = this;
        count = 0;
        while (head !== null) {
          if (head.type !== 'cursor') {
            count++;
          }
          head = head.prev;
        }
        return count;
      };

      Token.prototype.stringify = function() {
        return '';
      };

      Token.prototype.serialize = function() {
        return '';
      };

      return Token;

    })();
    exports.StartToken = StartToken = (function(superClass) {
      extend(StartToken, superClass);

      function StartToken(container) {
        this.container = container;
        StartToken.__super__.constructor.apply(this, arguments);
        this.markup = 'begin';
      }

      StartToken.prototype.append = function(token) {
        this.next = token;
        if (token == null) {
          return;
        }
        token.prev = this;
        traverseOneLevel(token, (function(_this) {
          return function(head) {
            return head.parent = _this.container;
          };
        })(this));
        return token;
      };

      StartToken.prototype.insert = function(token) {
        if (token instanceof StartToken || token instanceof EndToken) {
          console.warn('"insert"-ing a container can cause problems');
        }
        token.next = this.next;
        token.prev = this;
        this.next.prev = token;
        this.next = token;
        token.parent = this.container;
        return token;
      };

      StartToken.prototype.serialize = function() {
        return '<container>';
      };

      return StartToken;

    })(Token);
    exports.EndToken = EndToken = (function(superClass) {
      extend(EndToken, superClass);

      function EndToken(container) {
        this.container = container;
        EndToken.__super__.constructor.apply(this, arguments);
        this.markup = 'end';
      }

      EndToken.prototype.append = function(token) {
        this.next = token;
        if (token == null) {
          return;
        }
        token.prev = this;
        traverseOneLevel(token, (function(_this) {
          return function(head) {
            return head.parent = _this.container.parent;
          };
        })(this));
        return token;
      };

      EndToken.prototype.insert = function(token) {
        if (token instanceof StartToken || token instanceof EndToken) {
          console.warn('"insert"-ing a container can cause problems');
        }
        token.next = this.next;
        token.prev = this;
        this.next.prev = token;
        this.next = token;
        token.parent = this.container.parent;
        return token;
      };

      EndToken.prototype.serialize = function() {
        return '</container>';
      };

      return EndToken;

    })(Token);
    exports.BlockStartToken = BlockStartToken = (function(superClass) {
      extend(BlockStartToken, superClass);

      function BlockStartToken(container) {
        this.container = container;
        BlockStartToken.__super__.constructor.apply(this, arguments);
        this.type = 'blockStart';
      }

      return BlockStartToken;

    })(StartToken);
    exports.BlockEndToken = BlockEndToken = (function(superClass) {
      extend(BlockEndToken, superClass);

      function BlockEndToken(container) {
        this.container = container;
        BlockEndToken.__super__.constructor.apply(this, arguments);
        this.type = 'blockEnd';
      }

      BlockEndToken.prototype.serialize = function() {
        return "</block>";
      };

      return BlockEndToken;

    })(EndToken);
    exports.Block = Block = (function(superClass) {
      extend(Block, superClass);

      function Block(precedence, color, socketLevel, classes) {
        this.precedence = precedence != null ? precedence : 0;
        this.color = color != null ? color : 'blank';
        this.socketLevel = socketLevel != null ? socketLevel : helper.ANY_DROP;
        this.classes = classes != null ? classes : [];
        this.start = new BlockStartToken(this);
        this.end = new BlockEndToken(this);
        this.type = 'block';
        Block.__super__.constructor.apply(this, arguments);
      }

      Block.prototype._cloneEmpty = function() {
        var clone;
        clone = new Block(this.precedence, this.color, this.socketLevel, this.classes);
        clone.currentlyParenWrapped = this.currentlyParenWrapped;
        return clone;
      };

      Block.prototype._serialize_header = function() {
        var ref, ref1;
        return "<block precedence=\"" + this.precedence + "\" color=\"" + this.color + "\" socketLevel=\"" + this.socketLevel + "\" classes=\"" + ((ref = (ref1 = this.classes) != null ? typeof ref1.join === "function" ? ref1.join(' ') : void 0 : void 0) != null ? ref : '') + "\" >";
      };

      Block.prototype._serialize_footer = function() {
        return "</block>";
      };

      return Block;

    })(Container);
    exports.SocketStartToken = SocketStartToken = (function(superClass) {
      extend(SocketStartToken, superClass);

      function SocketStartToken(container) {
        this.container = container;
        SocketStartToken.__super__.constructor.apply(this, arguments);
        this.type = 'socketStart';
      }

      SocketStartToken.prototype.stringify = function(state) {
        if (this.next === this.container.end || this.next.type === 'text' && this.next.value === '') {
          return state.emptyToken;
        } else {
          return '';
        }
      };

      return SocketStartToken;

    })(StartToken);
    exports.SocketEndToken = SocketEndToken = (function(superClass) {
      extend(SocketEndToken, superClass);

      function SocketEndToken(container) {
        this.container = container;
        SocketEndToken.__super__.constructor.apply(this, arguments);
        this.type = 'socketEnd';
      }

      return SocketEndToken;

    })(EndToken);
    exports.Socket = Socket = (function(superClass) {
      extend(Socket, superClass);

      function Socket(precedence, handwritten, classes, dropdown) {
        this.precedence = precedence != null ? precedence : 0;
        this.handwritten = handwritten != null ? handwritten : false;
        this.classes = classes != null ? classes : [];
        this.dropdown = dropdown != null ? dropdown : null;
        this.start = new SocketStartToken(this);
        this.end = new SocketEndToken(this);
        this.type = 'socket';
        Socket.__super__.constructor.apply(this, arguments);
      }

      Socket.prototype.hasDropdown = function() {
        return (this.dropdown != null) && this.isDroppable();
      };

      Socket.prototype.isDroppable = function() {
        return this.start.next === this.end || this.start.next.type === 'text';
      };

      Socket.prototype._cloneEmpty = function() {
        return new Socket(this.precedence, this.handwritten, this.classes, this.dropdown);
      };

      Socket.prototype._serialize_header = function() {
        var ref, ref1, ref2, ref3;
        return "<socket precedence=\"" + this.precedence + "\" handwritten=\"" + this.handwritten + "\" classes=\"" + ((ref = (ref1 = this.classes) != null ? typeof ref1.join === "function" ? ref1.join(' ') : void 0 : void 0) != null ? ref : '') + "\"" + (this.dropdown != null ? " dropdown=\"" + ((ref2 = (ref3 = this.dropdown) != null ? typeof ref3.join === "function" ? ref3.join(' ') : void 0 : void 0) != null ? ref2 : '') + "\"" : '') + ">";
      };

      Socket.prototype._serialize_footer = function() {
        return "</socket>";
      };

      return Socket;

    })(Container);
    exports.IndentStartToken = IndentStartToken = (function(superClass) {
      extend(IndentStartToken, superClass);

      function IndentStartToken(container) {
        this.container = container;
        IndentStartToken.__super__.constructor.apply(this, arguments);
        this.type = 'indentStart';
      }

      IndentStartToken.prototype.stringify = function(state) {
        state.indent += this.container.prefix;
        return '';
      };

      return IndentStartToken;

    })(StartToken);
    exports.IndentEndToken = IndentEndToken = (function(superClass) {
      extend(IndentEndToken, superClass);

      function IndentEndToken(container) {
        this.container = container;
        IndentEndToken.__super__.constructor.apply(this, arguments);
        this.type = 'indentEnd';
      }

      IndentEndToken.prototype.stringify = function(state) {
        if (this.container.prefix.length !== 0) {
          state.indent = state.indent.slice(0, -this.container.prefix.length);
        }
        if (this.previousVisibleToken().previousVisibleToken() === this.container.start) {
          return state.emptyToken;
        } else {
          return '';
        }
      };

      IndentEndToken.prototype.serialize = function() {
        return "</indent>";
      };

      return IndentEndToken;

    })(EndToken);
    exports.Indent = Indent = (function(superClass) {
      extend(Indent, superClass);

      function Indent(prefix, classes) {
        this.prefix = prefix != null ? prefix : '';
        this.classes = classes != null ? classes : [];
        this.start = new IndentStartToken(this);
        this.end = new IndentEndToken(this);
        this.type = 'indent';
        this.depth = this.prefix.length;
        Indent.__super__.constructor.apply(this, arguments);
      }

      Indent.prototype._cloneEmpty = function() {
        return new Indent(this.prefix);
      };

      Indent.prototype._serialize_header = function() {
        var ref, ref1;
        return "<indent prefix=\"" + this.prefix + "\" classes=\"" + ((ref = (ref1 = this.classes) != null ? typeof ref1.join === "function" ? ref1.join(' ') : void 0 : void 0) != null ? ref : '') + "\">";
      };

      Indent.prototype._serialize_footer = function() {
        return "</indent>";
      };

      return Indent;

    })(Container);
    exports.SegmentStartToken = SegmentStartToken = (function(superClass) {
      extend(SegmentStartToken, superClass);

      function SegmentStartToken(container) {
        this.container = container;
        SegmentStartToken.__super__.constructor.apply(this, arguments);
        this.type = 'segmentStart';
      }

      SegmentStartToken.prototype.isVisible = function() {
        return this.container.isRoot;
      };

      SegmentStartToken.prototype.serialize = function() {
        return "<segment>";
      };

      return SegmentStartToken;

    })(StartToken);
    exports.SegmentEndToken = SegmentEndToken = (function(superClass) {
      extend(SegmentEndToken, superClass);

      function SegmentEndToken(container) {
        this.container = container;
        SegmentEndToken.__super__.constructor.apply(this, arguments);
        this.type = 'segmentEnd';
      }

      SegmentEndToken.prototype.isVisible = function() {
        return this.container.isRoot;
      };

      SegmentEndToken.prototype.serialize = function() {
        return "</segment>";
      };

      return SegmentEndToken;

    })(EndToken);
    exports.Segment = Segment = (function(superClass) {
      extend(Segment, superClass);

      function Segment(isLassoSegment) {
        this.isLassoSegment = isLassoSegment != null ? isLassoSegment : false;
        this.start = new SegmentStartToken(this);
        this.end = new SegmentEndToken(this);
        this.isRoot = false;
        this.classes = ['__segment'];
        this.type = 'segment';
        Segment.__super__.constructor.apply(this, arguments);
      }

      Segment.prototype._cloneEmpty = function() {
        return new Segment(this.isLassoSegment);
      };

      Segment.prototype.unwrap = function() {
        this.notifyChange();
        this.traverseOneLevel((function(_this) {
          return function(head, isContainer) {
            return head.parent = _this.parent;
          };
        })(this));
        this.start.remove();
        return this.end.remove();
      };

      Segment.prototype._serialize_header = function() {
        return "<segment isLassoSegment=\"" + this.isLassoSegment + "\">";
      };

      Segment.prototype._serialize_footer = function() {
        return "</segment>";
      };

      return Segment;

    })(Container);
    exports.TextToken = TextToken = (function(superClass) {
      extend(TextToken, superClass);

      function TextToken(_value) {
        this._value = _value;
        TextToken.__super__.constructor.apply(this, arguments);
        this.type = 'text';
      }

      TextToken.trigger('value', (function() {
        return this._value;
      }), function(value) {
        this._value = value;
        return this.notifyChange();
      });

      TextToken.prototype.stringify = function(state) {
        return this._value;
      };

      TextToken.prototype.serialize = function() {
        return helper.escapeXMLText(this._value);
      };

      TextToken.prototype.clone = function() {
        return new TextToken(this._value);
      };

      return TextToken;

    })(Token);
    exports.NewlineToken = NewlineToken = (function(superClass) {
      extend(NewlineToken, superClass);

      function NewlineToken(specialIndent) {
        this.specialIndent = specialIndent;
        NewlineToken.__super__.constructor.apply(this, arguments);
        this.type = 'newline';
      }

      NewlineToken.prototype.stringify = function(state) {
        var ref;
        return '\n' + ((ref = this.specialIndent) != null ? ref : state.indent);
      };

      NewlineToken.prototype.serialize = function() {
        return '\n';
      };

      NewlineToken.prototype.clone = function() {
        return new NewlineToken(this.specialIndent);
      };

      return NewlineToken;

    })(Token);
    exports.CursorToken = CursorToken = (function(superClass) {
      extend(CursorToken, superClass);

      function CursorToken() {
        CursorToken.__super__.constructor.apply(this, arguments);
        this.type = 'cursor';
      }

      CursorToken.prototype.isVisible = NO;

      CursorToken.prototype.isAffect = NO;

      CursorToken.prototype.serialize = function() {
        return '<cursor/>';
      };

      CursorToken.prototype.clone = function() {
        return new CursorToken();
      };

      return CursorToken;

    })(Token);
    traverseOneLevel = function(head, fn) {
      var results;
      results = [];
      while (true) {
        if (head instanceof EndToken || (head == null)) {
          break;
        } else if (head instanceof StartToken) {
          fn(head.container, true);
          head = head.container.end;
        } else {
          fn(head, false);
        }
        results.push(head = head.next);
      }
      return results;
    };
    return exports;
  });

}).call(this);

//# sourceMappingURL=model.js.map
