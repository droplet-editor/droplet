(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['ice-view'], function(view) {
    var Block, BlockEndToken, BlockStartToken, CursorToken, Indent, IndentEndToken, IndentStartToken, NewlineToken, Segment, SegmentEndToken, SegmentStartToken, Socket, SocketEndToken, SocketStartToken, TextToken, Token, exports;
    exports = {};
    exports.Block = Block = (function() {
      function Block(contents, precedence) {
        var head, token, _i, _len;
        this.precedence = precedence != null ? precedence : 0;
        this.start = new BlockStartToken(this);
        this.end = new BlockEndToken(this);
        this.currentlyParenWrapped = false;
        this.type = 'block';
        this.color = '#ddf';
        this.selected = false;
        head = this.start;
        for (_i = 0, _len = contents.length; _i < _len; _i++) {
          token = contents[_i];
          head = head.append(token.clone());
        }
        head.append(this.end);
        this.view = new view.BlockView(this);
      }

      Block.prototype.clone = function() {
        var block_clone, clone, cursor, head;
        clone = new Block([]);
        clone.color = this.color;
        head = this.start.next;
        cursor = clone.start;
        while (head !== this.end) {
          switch (head.type) {
            case 'blockStart':
              block_clone = head.block.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.block.end;
              break;
            case 'socketStart':
              block_clone = head.socket.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.socket.end;
              break;
            case 'indentStart':
              block_clone = head.indent.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.indent.end;
              break;
            default:
              if (head.type !== 'cursorToken') {
                cursor = cursor.append(head.clone());
              }
          }
          head = head.next;
        }
        cursor.append(clone.end);
        return clone;
      };

      Block.prototype.inSocket = function() {
        var head;
        head = this.start.prev;
        while ((head != null) && head.type === 'segmentStart') {
          head = head.prev;
        }
        return (head != null) && head.type === 'socketStart';
      };

      Block.prototype.moveTo = function(parent) {
        var first, last, _ref;
        while ((this.start.prev != null) && this.start.prev.type === 'segmentStart' && this.start.prev.segment.end === this.end.next) {
          this.start.prev.segment.remove();
        }
        if ((this.end.next != null) && (this.start.prev != null)) {
          last = this.end.next;
          while ((last != null) && (last.type === 'segmentEnd' || last.type === 'cursor')) {
            last = last.next;
          }
          first = this.start.prev;
          while ((first != null) && (first.type === 'segmentStart' || first.type === 'cursor')) {
            first = first.prev;
          }
          if ((first != null) && (first.type === 'newline') && ((last == null) || last.type === 'newline' || last.type === 'indentEnd') && !(((_ref = first.prev) != null ? _ref.type : void 0) === 'indentStart' && last.type === 'indentEnd')) {
            first.remove();
          } else if ((last != null) && (last.type === 'newline') && ((first == null) || first.type === 'newline')) {
            last.remove();
          }
        }
        if (this.start.prev != null) {
          this.start.prev.next = this.end.next;
        }
        if (this.end.next != null) {
          this.end.next.prev = this.start.prev;
        }
        this.start.prev = this.end.next = null;
        if (parent != null) {
          this.end.next = parent.next;
          if (parent.next != null) {
            parent.next.prev = this.end;
          }
          parent.next = this.start;
          this.start.prev = parent;
        }
        while ((parent != null) && parent.type === 'segmentStart') {
          parent = parent.prev;
        }
        if ((parent != null ? parent.type : void 0) === 'socketStart' && parent.socket.precedence > this.precedence) {
          if (!this.currentlyParenWrapped) {
            this.start.insert(new TextToken('('));
            this.end.insertBefore(new TextToken(')'));
            return this.currentlyParenWrapped = true;
          }
        } else if (this.currentlyParenWrapped) {
          this.start.next.remove();
          this.end.prev.remove();
          return this.currentlyParenWrapped = false;
        }
      };

      Block.prototype.checkParenWrap = function() {
        var parent;
        parent = this.start.prev;
        while ((parent != null) && parent.type === 'segmentStart') {
          parent = parent.prev;
        }
        if ((parent != null ? parent.type : void 0) === 'socketStart' && parent.socket.precedence > this.precedence) {
          if (!this.currentlyParenWrapped) {
            this.start.insert(new TextToken('('));
            this.end.insertBefore(new TextToken(')'));
            return this.currentlyParenWrapped = true;
          }
        } else if (this.currentlyParenWrapped) {
          this.start.next.remove();
          this.end.prev.remove();
          return this.currentlyParenWrapped = false;
        }
      };

      Block.prototype.find = function(f) {
        var head;
        head = this.start.next;
        while (head !== this.end) {
          if (head.type === 'blockStart' && f(head.block)) {
            return head.block.find(f);
          } else if (head.type === 'indentStart' && f(head.indent)) {
            return head.indent.find(f);
          } else if (head.type === 'socketStart' && f(head.socket)) {
            return head.socket.find(f);
          }
          head = head.next;
        }
        if (f(this)) {
          return this;
        } else {
          return null;
        }
      };

      Block.prototype.stringify = function() {
        var string;
        string = this.start.stringify({
          indent: ''
        });
        return string.slice(0, +(string.length - this.end.stringify({
          indent: ''
        }).length - 1) + 1 || 9e9);
      };

      return Block;

    })();
    exports.Indent = Indent = (function() {
      function Indent(contents, depth) {
        var block, head, _i, _len;
        this.depth = depth;
        this.start = new IndentStartToken(this);
        this.end = new IndentEndToken(this);
        this.type = 'indent';
        head = this.start;
        for (_i = 0, _len = contents.length; _i < _len; _i++) {
          block = contents[_i];
          head = head.append(block.clone());
        }
        head.append(this.end);
        this.view = new view.IndentView(this);
      }

      Indent.prototype.clone = function() {
        var block_clone, clone, cursor, head;
        clone = new Indent([], this.depth);
        head = this.start.next;
        cursor = clone.start;
        while (head !== this.end) {
          switch (head.type) {
            case 'blockStart':
              block_clone = head.block.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.block.end;
              break;
            case 'socketStart':
              block_clone = head.socket.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.socket.end;
              break;
            case 'indentStart':
              block_clone = head.indent.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.indent.end;
              break;
            default:
              if (head.type !== 'cursorToken') {
                cursor = cursor.append(head.clone());
              }
          }
          head = head.next;
        }
        cursor.append(clone.end);
        return clone;
      };

      Indent.prototype.find = function(f) {
        var head;
        head = this.start.next;
        while (head !== this.end) {
          if (head.type === 'blockStart' && f(head.block)) {
            return head.block.find(f);
          } else if (head.type === 'indentStart' && f(head.indent)) {
            return head.indent.find(f);
          } else if (head.type === 'socketStart' && f(head.socket)) {
            return head.socket.find(f);
          }
          head = head.next;
        }
        if (f(this)) {
          return this;
        } else {
          return null;
        }
      };

      Indent.prototype.stringify = function(state) {
        var string;
        string = this.start.stringify(state);
        return string.slice(0, string.length - this.end.stringify(state).length - 1);
      };

      return Indent;

    })();
    exports.Segment = Segment = (function() {
      function Segment(contents) {
        var block, head, _i, _len;
        this.start = new SegmentStartToken(this);
        this.end = new SegmentEndToken(this);
        this.type = 'segment';
        head = this.start;
        for (_i = 0, _len = contents.length; _i < _len; _i++) {
          block = contents[_i];
          head = head.append(block.clone());
        }
        head.append(this.end);
        this.view = new view.SegmentView(this);
      }

      Segment.prototype.clone = function() {
        var block_clone, clone, cursor, head;
        clone = new Segment([]);
        head = this.start.next;
        cursor = clone.start;
        while (head !== this.end) {
          switch (head.type) {
            case 'blockStart':
              block_clone = head.block.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.block.end;
              break;
            case 'socketStart':
              block_clone = head.socket.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.socket.end;
              break;
            case 'indentStart':
              block_clone = head.indent.clone();
              block_clone.start.prev = cursor;
              cursor.next = block_clone.start;
              cursor = block_clone.end;
              head = head.indent.end;
              break;
            default:
              if (head.type !== 'cursorToken') {
                cursor = cursor.append(head.clone());
              }
          }
          head = head.next;
        }
        cursor.append(clone.end);
        return clone;
      };

      Segment.prototype.remove = function() {
        this.start.remove();
        this.end.remove();
        this.start.next = this.end;
        return this.end.prev = this.start;
      };

      Segment.prototype.moveTo = function(parent) {
        var first, last, _ref;
        while ((this.start.prev != null) && this.start.prev.type === 'segmentStart' && this.start.prev.segment.end === this.end.next) {
          this.start.prev.segment.remove();
        }
        if ((this.end.next != null) && (this.start.prev != null)) {
          last = this.end.next;
          while ((last != null) && (last.type === 'segmentEnd' || last.type === 'cursor')) {
            last = last.next;
          }
          first = this.start.prev;
          while ((first != null) && (first.type === 'segmentStart' || first.type === 'cursor')) {
            first = first.prev;
          }
          if ((first != null) && (first.type === 'newline') && ((last == null) || last.type === 'newline' || last.type === 'indentEnd') && !(((_ref = first.prev) != null ? _ref.type : void 0) === 'indentStart' && last.type === 'indentEnd')) {
            first.remove();
          } else if ((last != null) && (last.type === 'newline') && ((first == null) || first.type === 'newline')) {
            last.remove();
          }
        }
        if (this.start.prev != null) {
          this.start.prev.next = this.end.next;
        }
        if (this.end.next != null) {
          this.end.next.prev = this.start.prev;
        }
        this.start.prev = this.end.next = null;
        if (parent != null) {
          this.end.next = parent.next;
          if (parent.next != null) {
            parent.next.prev = this.end;
          }
          parent.next = this.start;
          return this.start.prev = parent;
        }
      };

      Segment.prototype.find = function(f) {
        var head;
        head = this.start.next;
        while (head !== this.end) {
          if (head.type === 'blockStart' && f(head.block)) {
            return head.block.find(f);
          } else if (head.type === 'indentStart' && f(head.indent)) {
            return head.indent.find(f);
          } else if (head.type === 'socketStart' && f(head.socket)) {
            return head.socket.find(f);
          }
          head = head.next;
        }
        if (f(this)) {
          return this;
        } else {
          return null;
        }
      };

      Segment.prototype.stringify = function() {
        return this.start.stringify({
          indent: '',
          stopToken: this.end
        });
      };

      return Segment;

    })();
    exports.Socket = Socket = (function() {
      function Socket(content, precedence) {
        this.precedence = precedence != null ? precedence : 0;
        this.start = new SocketStartToken(this);
        this.end = new SocketEndToken(this);
        if ((content != null) && (content.start != null)) {
          this.start.next = content.start;
          content.start.prev = this.start;
          this.end.prev = content.end;
          content.end.next = this.end;
        } else if (content != null) {
          this.start.next = content;
          content.prev = this.start;
          this.end.prev = content;
          content.next = this.end;
        } else {
          this.start.next = this.end;
          this.end.prev = this.start;
        }
        this.type = 'socket';
        this.handwritten = false;
        this.view = new view.SocketView(this);
      }

      Socket.prototype.clone = function() {
        if (this.content() != null) {
          return new Socket(this.content().clone());
        } else {
          return new Socket();
        }
      };

      Socket.prototype.content = function() {
        var unwrap;
        unwrap = function(el) {
          switch (el.type) {
            case 'blockStart':
              return el.block;
            case 'segmentStart':
              return unwrap(el.next);
            default:
              return el;
          }
        };
        if (this.start.next !== this.end) {
          return unwrap(this.start.next);
        } else {
          return null;
        }
      };

      Socket.prototype.find = function(f) {
        var head;
        head = this.start.next;
        while (head !== this.end) {
          if (head.type === 'blockStart' && f(head.block)) {
            return head.block.find(f);
          } else if (head.type === 'indentStart' && f(head.indent)) {
            return head.indent.find(f);
          } else if (head.type === 'socketStart' && f(head.socket)) {
            return head.socket.find(f);
          }
          head = head.next;
        }
        if (f(this)) {
          return this;
        } else {
          return null;
        }
      };

      Socket.prototype.stringify = function() {
        return this.start.stringify({
          indent: '',
          stopToken: this.end
        });
      };

      return Socket;

    })();
    exports.Token = Token = (function() {
      function Token() {
        this.prev = this.next = null;
      }

      Token.prototype.append = function(token) {
        token.prev = this;
        return this.next = token;
      };

      Token.prototype.insert = function(token) {
        if (this.next != null) {
          token.next = this.next;
          this.next.prev = token;
        }
        token.prev = this;
        this.next = token;
        return this.next;
      };

      Token.prototype.insertBefore = function(token) {
        if (this.prev != null) {
          token.prev = this.prev;
          this.prev.next = token;
        }
        token.next = this;
        this.prev = token;
        return this.prev;
      };

      Token.prototype.remove = function() {
        if (this.prev != null) {
          this.prev.next = this.next;
        }
        if (this.next != null) {
          this.next.prev = this.prev;
        }
        return this.prev = this.next = null;
      };

      Token.prototype.stringify = function(state) {
        if ((this.next != null) && this.next !== state.stopToken) {
          return this.next.stringify(state);
        } else {
          return '';
        }
      };

      Token.prototype.getExactStringValue = function() {
        return '';
      };

      return Token;

    })();
    exports.CursorToken = CursorToken = (function(_super) {
      __extends(CursorToken, _super);

      function CursorToken() {
        this.prev = this.next = null;
        this.view = new view.CursorView(this);
        this.type = 'cursor';
      }

      CursorToken.prototype.clone = function() {
        return new CursorToken();
      };

      return CursorToken;

    })(Token);
    exports.TextToken = TextToken = (function(_super) {
      __extends(TextToken, _super);

      function TextToken(value) {
        this.value = value;
        this.prev = this.next = null;
        this.view = new view.TextView(this);
        this.type = 'text';
      }

      TextToken.prototype.clone = function() {
        return new TextToken(this.value);
      };

      TextToken.prototype.stringify = function(state) {
        return this.value + ((this.next != null) && this.next !== state.stopToken ? this.next.stringify(state) : '');
      };

      TextToken.prototype.getExactStringValue = function() {
        return this.value;
      };

      return TextToken;

    })(Token);
    exports.BlockStartToken = BlockStartToken = (function(_super) {
      __extends(BlockStartToken, _super);

      function BlockStartToken(block) {
        this.block = block;
        this.prev = this.next = null;
        this.type = 'blockStart';
      }

      return BlockStartToken;

    })(Token);
    exports.BlockEndToken = BlockEndToken = (function(_super) {
      __extends(BlockEndToken, _super);

      function BlockEndToken(block) {
        this.block = block;
        this.prev = this.next = null;
        this.type = 'blockEnd';
      }

      return BlockEndToken;

    })(Token);
    exports.SocketStartToken = SocketStartToken = (function(_super) {
      __extends(SocketStartToken, _super);

      function SocketStartToken(socket) {
        this.socket = socket;
        this.prev = this.next = null;
        this.type = 'socketStart';
      }

      return SocketStartToken;

    })(Token);
    exports.SocketEndToken = SocketEndToken = (function(_super) {
      __extends(SocketEndToken, _super);

      function SocketEndToken(socket) {
        this.socket = socket;
        this.prev = this.next = null;
        this.type = 'socketEnd';
      }

      return SocketEndToken;

    })(Token);
    exports.SegmentStartToken = SegmentStartToken = (function(_super) {
      __extends(SegmentStartToken, _super);

      function SegmentStartToken(segment) {
        this.segment = segment;
        this.prev = this.next = null;
        this.type = 'segmentStart';
      }

      return SegmentStartToken;

    })(Token);
    exports.SegmentEndToken = SegmentEndToken = (function(_super) {
      __extends(SegmentEndToken, _super);

      function SegmentEndToken(segment) {
        this.segment = segment;
        this.prev = this.next = null;
        this.type = 'segmentEnd';
      }

      return SegmentEndToken;

    })(Token);
    exports.IndentStartToken = IndentStartToken = (function(_super) {
      __extends(IndentStartToken, _super);

      function IndentStartToken(indent) {
        this.indent = indent;
        this.prev = this.next = null;
        this.type = 'indentStart';
      }

      IndentStartToken.prototype.stringify = function(state) {
        state.indent += ((function() {
          var _i, _ref, _results;
          _results = [];
          for (_i = 1, _ref = this.indent.depth; 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--) {
            _results.push(' ');
          }
          return _results;
        }).call(this)).join('');
        if (this.next && this.next !== state.stopToken) {
          return this.next.stringify(state);
        } else {
          return '';
        }
      };

      return IndentStartToken;

    })(Token);
    exports.IndentEndToken = IndentEndToken = (function(_super) {
      __extends(IndentEndToken, _super);

      function IndentEndToken(indent) {
        this.indent = indent;
        this.prev = this.next = null;
        this.type = 'indentEnd';
      }

      IndentEndToken.prototype.stringify = function(state) {
        state.indent = state.indent.slice(0, -this.indent.depth);
        if (this.next && this.next !== state.stopToken) {
          return this.next.stringify(state);
        } else {
          return '';
        }
      };

      return IndentEndToken;

    })(Token);
    exports.NewlineToken = NewlineToken = (function(_super) {
      __extends(NewlineToken, _super);

      function NewlineToken() {
        this.prev = this.next = null;
        this.type = 'newline';
      }

      NewlineToken.prototype.clone = function() {
        return new NewlineToken();
      };

      NewlineToken.prototype.stringify = function(state) {
        return '\n' + state.indent + (this.next && this.next !== state.stopToken ? this.next.stringify(state) : '');
      };

      return NewlineToken;

    })(Token);
    return exports;
  });

}).call(this);

/*
//@ sourceMappingURL=model.js.map
*/