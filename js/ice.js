(function() {
  var ANIMATION_FRAME_RATE, Block, BlockEndToken, BlockStartToken, BlockView, BoundingBoxState, CursorToken, CursorView, DROP_AREA_HEIGHT, EMPTY_INDENT_HEIGHT, EMPTY_INDENT_WIDTH, EMPTY_SOCKET_HEIGHT, EMPTY_SOCKET_WIDTH, Editor, FONT_HEIGHT, FONT_SIZE, INDENT_SPACES, INDENT_SPACING, INPUT_LINE_HEIGHT, IceEditorChangeEvent, IceView, Indent, IndentEndToken, IndentStartToken, IndentView, MIN_DRAG_DISTANCE, MIN_SEGMENT_DROP_AREA_WIDTH, NewlineToken, PADDING, PALETTE_MARGIN, PALETTE_WIDTH, PathWaypoint, SCROLL_INTERVAL, SOCKET_DROP_PADDING, Segment, SegmentEndToken, SegmentStartToken, SegmentView, Socket, SocketEndToken, SocketStartToken, SocketView, TAB_HEIGHT, TAB_OFFSET, TAB_WIDTH, TOUNGE_HEIGHT, TextToken, TextView, Token, exports,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  exports = {};

  exports.Block = Block = (function() {
    function Block(contents) {
      var head, token, _i, _len;
      this.start = new BlockStartToken(this);
      this.end = new BlockEndToken(this);
      this.type = 'block';
      this.color = '#ddf';
      this.selected = false;
      head = this.start;
      for (_i = 0, _len = contents.length; _i < _len; _i++) {
        token = contents[_i];
        head = head.append(token.clone());
      }
      head.append(this.end);
      this.view = new BlockView(this);
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
        return this.start.prev = parent;
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

    Block.prototype.toString = function() {
      var string;
      string = this.start.toString({
        indent: ''
      });
      return string.slice(0, +(string.length - this.end.toString({
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
      this.view = new IndentView(this);
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

    Indent.prototype.toString = function(state) {
      var string;
      string = this.start.toString(state);
      return string.slice(0, string.length - this.end.toString(state).length - 1);
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
      this.view = new SegmentView(this);
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

    Segment.prototype.toString = function() {
      var start;
      start = this.start.toString({
        indent: ''
      });
      return start.slice(0, start.length - this.end.toString({
        indent: ''
      }).length);
    };

    return Segment;

  })();

  exports.Socket = Socket = (function() {
    function Socket(content) {
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
      this.view = new SocketView(this);
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

    Socket.prototype.toString = function() {
      return this.start.toString({
        indent: ''
      }).slice(0, -this.end.toString({
        indent: ''
      }).length);
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

    Token.prototype.toString = function(state) {
      if (this.next != null) {
        return this.next.toString(state);
      } else {
        return '';
      }
    };

    return Token;

  })();

  exports.CursorToken = CursorToken = (function(_super) {
    __extends(CursorToken, _super);

    function CursorToken() {
      this.prev = this.next = null;
      this.view = new CursorView(this);
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
      this.view = new TextView(this);
      this.type = 'text';
    }

    TextToken.prototype.clone = function() {
      return new TextToken(this.value);
    };

    TextToken.prototype.toString = function(state) {
      return this.value + (this.next != null ? this.next.toString(state) : '');
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

    IndentStartToken.prototype.toString = function(state) {
      state.indent += ((function() {
        var _i, _ref, _results;
        _results = [];
        for (_i = 1, _ref = this.indent.depth; 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--) {
          _results.push(' ');
        }
        return _results;
      }).call(this)).join('');
      if (this.next) {
        return this.next.toString(state);
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

    IndentEndToken.prototype.toString = function(state) {
      state.indent = state.indent.slice(0, -this.indent.depth);
      if (this.next) {
        return this.next.toString(state);
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

    NewlineToken.prototype.toString = function(state) {
      return '\n' + state.indent + (this.next ? this.next.toString(state) : '');
    };

    return NewlineToken;

  })(Token);

  window.ICE = exports;

  PADDING = 5;

  INDENT_SPACING = 15;

  TOUNGE_HEIGHT = 10;

  FONT_HEIGHT = 15;

  EMPTY_SOCKET_HEIGHT = FONT_HEIGHT + PADDING * 2;

  EMPTY_SOCKET_WIDTH = 20;

  EMPTY_INDENT_HEIGHT = FONT_HEIGHT + PADDING * 2;

  EMPTY_INDENT_WIDTH = 50;

  MIN_SEGMENT_DROP_AREA_WIDTH = 100;

  DROP_AREA_HEIGHT = 30;

  TAB_WIDTH = 15;

  TAB_HEIGHT = 5;

  TAB_OFFSET = 10;

  SOCKET_DROP_PADDING = 3;

  BoundingBoxState = (function() {
    function BoundingBoxState(point) {
      this.x = point.x;
      this.y = point.y;
    }

    return BoundingBoxState;

  })();

  PathWaypoint = (function() {
    function PathWaypoint(left, right) {
      this.left = left;
      this.right = right;
    }

    return PathWaypoint;

  })();

  IceView = (function() {
    function IceView(block) {
      this.block = block;
      this.children = [];
      this.lineStart = this.lineEnd = null;
      this.lineChildren = {};
      this.dimensions = {};
      this.cursors = [];
      this.dropArea = null;
      this.highlightArea = null;
      this.indented = {};
      this.indentEndsOn = {};
      this.indentStartsOn = {};
      this.pathWaypoints = {};
      this.bounds = {};
    }

    IceView.prototype.computeChildren = function(line) {
      var head, l, occupiedLine, _base, _base1, _base10, _base11, _base2, _base3, _base4, _base5, _base6, _base7, _base8, _base9, _i, _j, _k, _l, _m, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      this.children = [];
      this.lineStart = this.lineEnd = null;
      this.dropArea = this.highlightArea = null;
      this.lineChildren = {};
      this.dimensions = {};
      this.indented = {};
      this.indentEndsOn = {};
      this.indentStartsOn = {};
      this.pathWaypoints = {};
      this.bounds = {};
      this.cursors = [];
      this.lineStart = line;
      head = this.block.start.next;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'blockStart':
            line = head.block.view.computeChildren(line);
            this.children.push(head.block.view);
            for (occupiedLine = _i = _ref = head.block.view.lineStart, _ref1 = head.block.view.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; occupiedLine = _ref <= _ref1 ? ++_i : --_i) {
              if ((_base = this.lineChildren)[occupiedLine] == null) {
                _base[occupiedLine] = [];
              }
              this.lineChildren[occupiedLine].push(head.block.view);
              (_base1 = this.indented)[occupiedLine] || (_base1[occupiedLine] = head.block.view.indented[occupiedLine]);
              (_base2 = this.indentEndsOn)[occupiedLine] || (_base2[occupiedLine] = head.block.view.indentEndsOn[occupiedLine]);
            }
            head = head.block.end;
            break;
          case 'indentStart':
            line = head.indent.view.computeChildren(line);
            this.children.push(head.indent.view);
            for (occupiedLine = _j = _ref2 = head.indent.view.lineStart, _ref3 = head.indent.view.lineEnd; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; occupiedLine = _ref2 <= _ref3 ? ++_j : --_j) {
              if ((_base3 = this.lineChildren)[occupiedLine] == null) {
                _base3[occupiedLine] = [];
              }
              this.lineChildren[occupiedLine].push(head.indent.view);
              this.indented[occupiedLine] = true;
            }
            this.indentEndsOn[head.indent.view.lineEnd] = true;
            this.indentStartsOn[head.indent.view.lineStart] = true;
            head = head.indent.end;
            break;
          case 'socketStart':
            line = head.socket.view.computeChildren(line);
            this.children.push(head.socket.view);
            for (occupiedLine = _k = _ref4 = head.socket.view.lineStart, _ref5 = head.socket.view.lineEnd; _ref4 <= _ref5 ? _k <= _ref5 : _k >= _ref5; occupiedLine = _ref4 <= _ref5 ? ++_k : --_k) {
              if ((_base4 = this.lineChildren)[occupiedLine] == null) {
                _base4[occupiedLine] = [];
              }
              this.lineChildren[occupiedLine].push(head.socket.view);
              (_base5 = this.indented)[occupiedLine] || (_base5[occupiedLine] = head.socket.view.indented[occupiedLine]);
              (_base6 = this.indentEndsOn)[occupiedLine] || (_base6[occupiedLine] = head.socket.view.indentEndsOn[occupiedLine]);
            }
            head = head.socket.end;
            break;
          case 'segmentStart':
            line = head.segment.view.computeChildren(line);
            this.children.push(head.segment.view);
            for (occupiedLine = _l = _ref6 = head.segment.view.lineStart, _ref7 = head.segment.view.lineEnd; _ref6 <= _ref7 ? _l <= _ref7 : _l >= _ref7; occupiedLine = _ref6 <= _ref7 ? ++_l : --_l) {
              if ((_base7 = this.lineChildren)[occupiedLine] == null) {
                _base7[occupiedLine] = [];
              }
              this.lineChildren[occupiedLine].push(head.segment.view);
              (_base8 = this.indented)[occupiedLine] || (_base8[occupiedLine] = head.segment.view.indented[occupiedLine]);
              (_base9 = this.indentEndsOn)[occupiedLine] || (_base9[occupiedLine] = head.segment.view.indentEndsOn[occupiedLine]);
            }
            head = head.segment.end;
            break;
          case 'text':
            head.view.computeChildren(line);
            this.children.push(head.view);
            if ((_base10 = this.lineChildren)[line] == null) {
              _base10[line] = [];
            }
            this.lineChildren[line].push(head.view);
            break;
          case 'cursor':
            this.cursors.push({
              token: head,
              line: line
            });
            break;
          case 'newline':
            line += 1;
        }
        head = head.next;
      }
      this.lineEnd = line;
      for (l = _m = _ref8 = this.lineStart, _ref9 = this.lineEnd; _ref8 <= _ref9 ? _m <= _ref9 : _m >= _ref9; l = _ref8 <= _ref9 ? ++_m : --_m) {
        if ((_base11 = this.lineChildren)[l] == null) {
          _base11[l] = [];
        }
      }
      return line;
    };

    IceView.prototype.computeDimensions = function() {
      var child, _i, _len, _ref;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.computeDimensions();
      }
      return this.dimensions;
    };

    IceView.prototype.computeBoundingBox = function(line, state) {
      var child, _i, _len, _ref;
      _ref = this.lineChildren[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.computeBoundingBox(line, state);
      }
      return this.bounds[line] = new draw.NoRectangle();
    };

    IceView.prototype.computePath = function() {
      var child, _i, _len, _ref;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.computePath();
      }
      return this.bounds;
    };

    IceView.prototype.drawPath = function(ctx) {
      var child, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.drawPath(ctx));
      }
      return _results;
    };

    IceView.prototype.drawCursor = function(ctx) {
      var child, cursor, yCoordinate, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.drawCursor(ctx);
      }
      _ref1 = this.cursors;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        cursor = _ref1[_j];
        if (cursor.token.prev.type === 'newline' || cursor.token.prev.type === 'segmentStart') {
          yCoordinate = this.bounds[cursor.line].y;
        } else {
          yCoordinate = this.bounds[cursor.line].bottom();
        }
        cursor.token.view.point.y = yCoordinate;
        ctx.fillStyle = '#000';
        ctx.strokeSTyle = '#000';
        ctx.beginPath();
        if (this.bounds[cursor.line].x >= 5) {
          ctx.moveTo(this.bounds[cursor.line].x, yCoordinate);
          ctx.lineTo(this.bounds[cursor.line].x - 5, yCoordinate - 5);
          ctx.lineTo(this.bounds[cursor.line].x - 5, yCoordinate + 5);
        } else {
          ctx.moveTo(this.bounds[cursor.line].x, yCoordinate);
          ctx.lineTo(this.bounds[cursor.line].x + 5, yCoordinate - 5);
          ctx.lineTo(this.bounds[cursor.line].x + 5, yCoordinate + 5);
        }
        ctx.stroke();
        _results.push(ctx.fill());
      }
      return _results;
    };

    IceView.prototype.draw = function(ctx) {
      this.drawPath(ctx);
      return this.drawCursor(ctx);
    };

    IceView.prototype.computeBoundingBoxes = function() {
      var cursor, line, _i, _ref, _ref1;
      cursor = new draw.Point(0, 0);
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        this.computeBoundingBox(line, new BoundingBoxState(cursor));
        cursor.y += this.dimensions[line].height;
      }
      return this.bounds;
    };

    IceView.prototype.getBounds = function() {
      var bound, line, _i, _ref, _ref1;
      bound = new draw.NoRectangle();
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        bound.unite(this.bounds[line]);
      }
      return bound;
    };

    IceView.prototype.compute = function(line) {
      if (line == null) {
        line = 0;
      }
      this.computeChildren(line);
      this.computeDimensions();
      this.computeBoundingBoxes();
      return this.computePath();
    };

    IceView.prototype.translate = function(point) {
      var bound, child, line, _i, _len, _ref, _ref1, _results;
      _ref = this.bounds;
      for (line in _ref) {
        bound = _ref[line];
        bound.translate(point);
      }
      _ref1 = this.children;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        child = _ref1[_i];
        _results.push(child.translate(point));
      }
      return _results;
    };

    return IceView;

  })();

  BlockView = (function(_super) {
    __extends(BlockView, _super);

    function BlockView(block) {
      BlockView.__super__.constructor.call(this, block);
      this.path = null;
    }

    BlockView.prototype.computeDimensions = function() {
      var child, height, line, width, _i, _j, _len, _ref, _ref1, _ref2, _results;
      BlockView.__super__.computeDimensions.apply(this, arguments);
      _results = [];
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        width = PADDING;
        height = 2 * PADDING;
        _ref2 = this.lineChildren[line];
        for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
          child = _ref2[_j];
          if (child.block.type === 'indent') {
            width += child.dimensions[line].width + INDENT_SPACING;
            height = Math.max(height, child.dimensions[line].height + (child.lineEnd === line ? TOUNGE_HEIGHT : 0));
          } else if (child.indented[line]) {
            width += child.dimensions[line].width + PADDING;
            height = Math.max(height, child.dimensions[line].height);
          } else {
            width += child.dimensions[line].width + PADDING;
            height = Math.max(height, child.dimensions[line].height + 2 * PADDING);
          }
        }
        _results.push(this.dimensions[line] = new draw.Size(width, height));
      }
      return _results;
    };

    BlockView.prototype.computeBoundingBox = function(line, state) {
      var axis, child, cursor, indentChild, paddingLeft, _i, _len, _ref;
      axis = state.y + this.dimensions[line].height / 2;
      cursor = state.x;
      this.bounds[line] = new draw.Rectangle(state.x, state.y, this.dimensions[line].width, this.dimensions[line].height);
      _ref = this.lineChildren[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        if (child.block.type === 'indent') {
          cursor += INDENT_SPACING;
          child.computeBoundingBox(line, new BoundingBoxState(new draw.Point(cursor, state.y)));
        } else {
          cursor += PADDING;
          child.computeBoundingBox(line, new BoundingBoxState(new draw.Point(cursor, axis - child.dimensions[line].height / 2)));
        }
        cursor += child.dimensions[line].width;
      }
      if (this.lineChildren[line].length > 0 && !(this.lineChildren[line][0].indented[line] || this.lineChildren[line][0].block.type === 'indent')) {
        return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
      } else if (this.lineChildren[line].length > 0) {
        if (line === this.lineChildren[line][0].lineEnd && this.lineChildren[line][0].block.type === 'indent') {
          indentChild = this.lineChildren[line][0];
          paddingLeft = this.lineChildren[line][0].block.type === 'indent' ? INDENT_SPACING : PADDING;
          if (this.lineChildren[line].length === 1) {
            return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
          } else {
            return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
          }
        } else {
          return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].y), new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].bottom())]);
        }
      }
    };

    BlockView.prototype.computePath = function() {
      var entryPoint, line, point, waypoint, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3, _ref4;
      BlockView.__super__.computePath.apply(this, arguments);
      this.path = new draw.Path();
      this.dropArea = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - DROP_AREA_HEIGHT / 2, this.bounds[this.lineEnd].width, DROP_AREA_HEIGHT);
      this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - 5, this.bounds[this.lineEnd].width, 10);
      if (!((_ref = this.block.inSocket()) != null ? _ref : false)) {
        this.path.push(new draw.Point(this.bounds[this.lineStart].x + TAB_OFFSET, this.bounds[this.lineStart].y));
        this.path.push(new draw.Point(this.bounds[this.lineStart].x + TAB_OFFSET + TAB_WIDTH / 8, this.bounds[this.lineStart].y + TAB_HEIGHT));
        this.path.push(new draw.Point(this.bounds[this.lineStart].x + TAB_OFFSET + TAB_WIDTH * 7 / 8, this.bounds[this.lineStart].y + TAB_HEIGHT));
        this.path.push(new draw.Point(this.bounds[this.lineStart].x + TAB_OFFSET + TAB_WIDTH, this.bounds[this.lineStart].y));
      }
      _ref1 = this.pathWaypoints;
      for (line in _ref1) {
        waypoint = _ref1[line];
        if (this.indentStartsOn[line]) {
          entryPoint = new draw.Point(this.bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH, this.bounds[line].y);
          if (this.path._points.length > 0 && entryPoint.y !== this.path._points[this.path._points.length - 1].y) {
            this.path.push(new draw.Point(this.path._points[this.path._points.length - 1].x, entryPoint.y));
          }
          this.path.push(entryPoint);
          this.path.push(new draw.Point(this.bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH * 7 / 8, this.bounds[line].y + TAB_HEIGHT));
          this.path.push(new draw.Point(this.bounds[line].x + INDENT_SPACING + TAB_OFFSET + TAB_WIDTH / 8, this.bounds[line].y + TAB_HEIGHT));
          this.path.push(new draw.Point(this.bounds[line].x + INDENT_SPACING + TAB_OFFSET, this.bounds[line].y));
        }
        _ref2 = waypoint.left;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          point = _ref2[_i];
          if (this.path._points.length > 0 && point.x !== this.path._points[0].x) {
            this.path.unshift(new draw.Point(point.x, this.path._points[0].y));
          }
          this.path.unshift(point);
        }
        _ref3 = waypoint.right;
        for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
          point = _ref3[_j];
          if (this.path._points.length > 0 && point.y !== this.path._points[this.path._points.length - 1].y) {
            this.path.push(new draw.Point(this.path._points[this.path._points.length - 1].x, point.y));
          }
          this.path.push(point);
        }
      }
      if (!((_ref4 = this.block.inSocket()) != null ? _ref4 : false)) {
        this.path.unshift(new draw.Point(this.bounds[this.lineEnd].x + TAB_OFFSET, this.bounds[this.lineEnd].bottom()));
        this.path.unshift(new draw.Point(this.bounds[this.lineEnd].x + TAB_OFFSET + TAB_WIDTH / 8, this.bounds[this.lineEnd].bottom() + TAB_HEIGHT));
        this.path.unshift(new draw.Point(this.bounds[this.lineEnd].x + TAB_OFFSET + TAB_WIDTH * 7 / 8, this.bounds[this.lineEnd].bottom() + TAB_HEIGHT));
        this.path.unshift(new draw.Point(this.bounds[this.lineEnd].x + TAB_OFFSET + TAB_WIDTH, this.bounds[this.lineEnd].bottom()));
      }
      this.path.style.fillColor = this.block.color;
      return this.path.style.strokeColor = '#000';
    };

    BlockView.prototype.drawPath = function(ctx) {
      if (this.path._points.length === 0) {
        debugger;
      }
      this.path.draw(ctx);
      return BlockView.__super__.drawPath.apply(this, arguments);
    };

    BlockView.prototype.translate = function(point) {
      this.path.translate(point);
      return BlockView.__super__.translate.apply(this, arguments);
    };

    return BlockView;

  })(IceView);

  TextView = (function(_super) {
    __extends(TextView, _super);

    function TextView(block) {
      TextView.__super__.constructor.call(this, block);
      this.textElement = null;
    }

    TextView.prototype.computeChildren = function(line) {
      return this.lineStart = this.lineEnd = line;
    };

    TextView.prototype.computeDimensions = function() {
      this.textElement = new draw.Text(new draw.Point(0, 0), this.block.value);
      this.dimensions[this.lineStart] = new draw.Size(this.textElement.bounds().width, this.textElement.bounds().height);
      return this.dimesions;
    };

    TextView.prototype.computeBoundingBox = function(line, state) {
      if (line === this.lineStart) {
        this.bounds[line] = new draw.Rectangle(state.x, state.y, this.dimensions[line].width, this.dimensions[line].height);
        return this.textElement.setPosition(new draw.Point(state.x, state.y));
      }
    };

    TextView.prototype.computePath = function() {};

    TextView.prototype.drawPath = function(ctx) {
      return this.textElement.draw(ctx);
    };

    TextView.prototype.translate = function(point) {
      this.textElement.translate(point);
      return TextView.__super__.translate.apply(this, arguments);
    };

    TextView.prototype.computePlaintextTranslationVector = function(state, ctx) {
      var point;
      point = new draw.Point(state.x, state.y);
      state.x += ctx.measureText(this.block.value).width;
      return point.from(new draw.Point(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y));
    };

    return TextView;

  })(IceView);

  IndentView = (function(_super) {
    __extends(IndentView, _super);

    function IndentView(block) {
      IndentView.__super__.constructor.call(this, block);
    }

    IndentView.prototype.computeChildren = function(line) {
      IndentView.__super__.computeChildren.apply(this, arguments);
      this.lineStart += 1;
      return this.lineEnd;
    };

    IndentView.prototype.computeDimensions = function() {
      var child, height, line, width, _i, _j, _len, _ref, _ref1, _ref2, _results;
      IndentView.__super__.computeDimensions.apply(this, arguments);
      if (this.lineEnd >= this.lineStart) {
        _results = [];
        for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
          height = width = 0;
          _ref2 = this.lineChildren[line];
          for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
            child = _ref2[_j];
            width += child.dimensions[line].width;
            height = Math.max(height, child.dimensions[line].height);
          }
          height = Math.max(height, EMPTY_INDENT_HEIGHT);
          width = Math.max(width, EMPTY_INDENT_WIDTH);
          _results.push(this.dimensions[line] = new draw.Size(width, height));
        }
        return _results;
      }
    };

    IndentView.prototype.computeBoundingBox = function(line, state) {
      var child, cursorX, cursorY, _i, _len, _ref, _results;
      cursorX = state.x;
      cursorY = state.y;
      this.bounds[line] = new draw.Rectangle(state.x, state.y, this.dimensions[line].width, this.dimensions[line].height);
      _ref = this.lineChildren[line];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.computeBoundingBox(line, new BoundingBoxState(new draw.Point(cursorX, cursorY)));
        _results.push(cursorX += child.dimensions[line].width);
      }
      return _results;
    };

    IndentView.prototype.computePath = function() {
      this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - DROP_AREA_HEIGHT / 2, this.bounds[this.lineStart].width, DROP_AREA_HEIGHT);
      this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
      return IndentView.__super__.computePath.apply(this, arguments);
    };

    return IndentView;

  })(IceView);

  SocketView = (function(_super) {
    __extends(SocketView, _super);

    function SocketView(block) {
      SocketView.__super__.constructor.call(this, block);
    }

    SocketView.prototype.computeDimensions = function() {
      var content, line, value, _ref;
      SocketView.__super__.computeDimensions.apply(this, arguments);
      if ((content = this.block.content()) != null) {
        switch (this.block.content().type) {
          case 'block':
            _ref = content.view.dimensions;
            for (line in _ref) {
              value = _ref[line];
              this.dimensions[line] = new draw.Size(value.width, value.height);
            }
            break;
          case 'text':
            this.dimensions[content.view.lineStart] = new draw.Size(content.view.dimensions[content.view.lineStart].width + 2 * PADDING, content.view.dimensions[content.view.lineStart].height + 2 * PADDING);
            this.dimensions[content.view.lineStart].width = Math.max(this.dimensions[content.view.lineStart].width, EMPTY_SOCKET_WIDTH);
        }
      } else {
        this.dimensions[this.lineStart] = new draw.Size(EMPTY_SOCKET_WIDTH, EMPTY_SOCKET_HEIGHT);
      }
      return this.dimensions;
    };

    SocketView.prototype.computeBoundingBox = function(line, state) {
      this.bounds[line] = new draw.Rectangle(state.x, state.y, this.dimensions[line].width, this.dimensions[line].height);
      if (this.lineChildren[line].length === 0) {

      } else if (this.lineChildren[line].length > 1) {
        throw 'Error: more than one child inside a socket';
      } else if (this.block.content().type === 'text') {
        return this.lineChildren[line][0].computeBoundingBox(line, new BoundingBoxState(new draw.Point(state.x + PADDING, state.y + PADDING)));
      } else {
        return this.lineChildren[line][0].computeBoundingBox(line, state);
      }
    };

    SocketView.prototype.computePath = function() {
      var _ref;
      if (((_ref = this.block.content()) != null ? _ref.type : void 0) !== 'block') {
        (this.dropArea = new draw.Rectangle()).copy(this.bounds[this.lineStart]);
        this.dropHighlightReigon = new draw.Rectangle(this.dropArea.x - SOCKET_DROP_PADDING, this.dropArea.y - SOCKET_DROP_PADDING, this.dropArea.width + SOCKET_DROP_PADDING * 2, this.dropArea.height + SOCKET_DROP_PADDING * 2);
      }
      return SocketView.__super__.computePath.apply(this, arguments);
    };

    SocketView.prototype.drawPath = function(ctx) {
      if ((this.block.content() == null) || this.block.content().type === 'text') {
        this.bounds[this.lineStart].stroke(ctx, '#000');
        this.bounds[this.lineStart].fill(ctx, '#FFF');
      }
      return SocketView.__super__.drawPath.apply(this, arguments);
    };

    return SocketView;

  })(IceView);

  SegmentView = (function(_super) {
    __extends(SegmentView, _super);

    function SegmentView(block) {
      SegmentView.__super__.constructor.call(this, block);
    }

    SegmentView.prototype.computeDimensions = function() {
      var child, height, line, width, _i, _j, _len, _ref, _ref1, _ref2, _results;
      SegmentView.__super__.computeDimensions.apply(this, arguments);
      _results = [];
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        height = width = 0;
        _ref2 = this.lineChildren[line];
        for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
          child = _ref2[_j];
          width += child.dimensions[line].width;
          height = Math.max(height, child.dimensions[line].height);
        }
        _results.push(this.dimensions[line] = new draw.Size(width, height));
      }
      return _results;
    };

    SegmentView.prototype.computeBoundingBox = function(line, state) {
      var child, cursorX, cursorY, _i, _len, _ref, _results;
      cursorX = state.x;
      cursorY = state.y;
      this.bounds[line] = new draw.Rectangle(state.x, state.y, this.dimensions[line].width, this.dimensions[line].height);
      _ref = this.lineChildren[line];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child.computeBoundingBox(line, new BoundingBoxState(new draw.Point(cursorX, cursorY)));
        _results.push(cursorX += child.dimensions[line].width);
      }
      return _results;
    };

    SegmentView.prototype.drawPath = function() {
      this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, Math.max(this.bounds[this.lineStart].width, MIN_SEGMENT_DROP_AREA_WIDTH), 10);
      this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
      return SegmentView.__super__.drawPath.apply(this, arguments);
    };

    return SegmentView;

  })(IceView);

  CursorView = (function() {
    function CursorView(block) {
      this.block = block;
      this.point = new draw.Point(0, 0);
    }

    return CursorView;

  })();

  INDENT_SPACES = 2;

  INPUT_LINE_HEIGHT = 15;

  PALETTE_MARGIN = 10;

  PALETTE_WIDTH = 300;

  MIN_DRAG_DISTANCE = 5;

  FONT_SIZE = 15;

  ANIMATION_FRAME_RATE = 50;

  SCROLL_INTERVAL = 50;

  exports.IceEditorChangeEvent = IceEditorChangeEvent = (function() {
    function IceEditorChangeEvent(block, target) {
      this.block = block;
      this.target = target;
    }

    return IceEditorChangeEvent;

  })();

  exports.Editor = Editor = (function() {
    function Editor(wrapper, paletteBlocks) {
      var child, deleteFromCursor, drag, eventName, getPointFromEvent, getRectFromPoints, highlight, hitTest, hitTestFloating, hitTestFocus, hitTestLasso, hitTestPalette, hitTestRoot, insertHandwrittenBlock, moveBlockTo, moveCursorBefore, moveCursorDown, moveCursorTo, moveCursorUp, offset, paletteBlock, redrawTextInput, scrollCursorIntoView, setTextInputAnchor, setTextInputFocus, setTextInputHead, textInputAnchor, textInputHead, textInputSelecting, track, _editedInputLine, _i, _j, _len, _len1, _ref, _ref1,
        _this = this;
      this.paletteBlocks = paletteBlocks;
      this.el = document.createElement('div');
      this.el.className = 'ice_editor';
      wrapper.appendChild(this.el);
      this.aceEl = document.createElement('div');
      this.aceEl.className = 'ice_ace';
      wrapper.appendChild(this.aceEl);
      this.aceEl.appendChild(this.ace = document.createElement('textarea'));
      this.ace.className = 'fullscreen_textarea';
      if (this.paletteBlocks == null) {
        this.paletteBlocks = [];
      }
      this.paletteBlocks = (function() {
        var _i, _len, _ref, _results;
        _ref = this.paletteBlocks;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          paletteBlock = _ref[_i];
          _results.push(paletteBlock.clone());
        }
        return _results;
      }).call(this);
      this.tree = null;
      this.floatingBlocks = [];
      this.focus = null;
      this.editedText = null;
      this.handwritten = false;
      this.hiddenInput = null;
      this.ephemeralOldFocusValue = null;
      this.isEditingText = function() {
        return _this.hiddenInput === document.activeElement;
      };
      textInputAnchor = textInputHead = null;
      textInputSelecting = false;
      _editedInputLine = -1;
      this.selection = null;
      this.lassoSegment = null;
      this._lassoBounds = null;
      this.cursor = new CursorToken();
      this.undoStack = [];
      this.scrollOffset = new draw.Point(0, 0);
      offset = null;
      highlight = null;
      this.currentlyAnimating = false;
      this.main = document.createElement('canvas');
      this.main.className = 'canvas';
      this.main.height = this.el.offsetHeight;
      this.main.width = this.el.offsetWidth - PALETTE_WIDTH;
      this.palette = document.createElement('canvas');
      this.palette.className = 'palette';
      this.palette.height = this.el.offsetHeight;
      this.palette.width = PALETTE_WIDTH;
      drag = document.createElement('canvas');
      drag.className = 'drag';
      drag.height = this.el.offsetHeight;
      drag.width = this.el.offsetWidth - PALETTE_WIDTH;
      this.hiddenInput = document.createElement('input');
      this.hiddenInput.className = 'hidden_input';
      track = document.createElement('div');
      track.className = 'trackArea';
      _ref = [this.main, this.palette, drag, track, this.hiddenInput];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        this.el.appendChild(child);
      }
      this.mainCtx = this.main.getContext('2d');
      this.dragCtx = drag.getContext('2d');
      this.paletteCtx = this.palette.getContext('2d');
      draw._setCTX(this.mainCtx);
      this.clear = function() {
        return _this.mainCtx.clearRect(_this.scrollOffset.x, _this.scrollOffset.y, _this.main.width, _this.main.height);
      };
      this.redraw = function() {
        var float, view, _j, _k, _len1, _len2, _ref1, _ref2, _results;
        _this.clear();
        _this.tree.view.compute();
        _this.tree.view.draw(_this.mainCtx);
        if (_this.lassoSegment != null) {
          _this._lassoBounds = _this.lassoSegment.view.getBounds();
          _ref1 = _this.floatingBlocks;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            float = _ref1[_j];
            if (_this.lassoSegment === float.block) {
              _this._lassoBounds.translate(float.position);
            }
          }
          if (_this.lassoSegment !== _this.selection) {
            _this._lassoBounds.stroke(_this.mainCtx, '#000');
            _this._lassoBounds.fill(_this.mainCtx, 'rgba(0, 0, 256, 0.3)');
          }
        }
        _ref2 = _this.floatingBlocks;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          float = _ref2[_k];
          view = float.block.view;
          view.compute();
          view.translate(float.position);
          _results.push(view.draw(_this.mainCtx));
        }
        return _results;
      };
      this.attemptReparse = function() {
        var element, excludes, handwrittenBlock, head, newBlock, parent, reparseQueue, stack, _j, _k, _len1, _len2;
        head = _this.tree.start;
        stack = [];
        excludes = [];
        reparseQueue = [];
        while (head !== _this.tree.end) {
          switch (head.type) {
            case 'blockStart':
              stack.push(head.block);
              break;
            case 'indentStart':
              stack.push(head.indent);
              break;
            case 'socketStart':
              if (head.socket.handwritten && stack[stack.length - 1].type === 'block' && head.socket !== _this.focus) {
                reparseQueue.push(stack[stack.length - 1]);
              }
              stack.push(head.socket);
              break;
            case 'cursor':
              for (_j = 0, _len1 = stack.length; _j < _len1; _j++) {
                element = stack[_j];
                excludes.push(element);
              }
              break;
            case 'blockEnd':
            case 'socketEnd':
            case 'indentEnd':
              stack.pop();
          }
          head = head.next;
        }
        for (_k = 0, _len2 = reparseQueue.length; _k < _len2; _k++) {
          handwrittenBlock = reparseQueue[_k];
          if (__indexOf.call(excludes, handwrittenBlock) < 0) {
            try {
              console.log('trying');
              parent = handwrittenBlock.start.prev;
              newBlock = (coffee.parse(handwrittenBlock.toString())).segment;
              handwrittenBlock.start.prev.append(handwrittenBlock.end.next);
              handwrittenBlock.start.prev = null;
              handwrittenBlock.end.next = null;
              newBlock.moveTo(parent);
              newBlock.remove();
            } catch (_error) {}
          }
        }
        return _this.redraw();
      };
      moveBlockTo = function(block, target) {
        var float, parent, _j, _len1, _ref1;
        parent = block.start.prev;
        while ((parent != null) && (parent.type === 'newline' || (parent.type === 'segmentStart' && parent.segment !== _this.tree) || parent.type === 'cursor')) {
          parent = parent.prev;
        }
        console.log(_this.floatingBlocks);
        _ref1 = _this.floatingBlocks;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          float = _ref1[_j];
          if (block === float.block) {
            _this.undoStack.push({
              type: 'floatingBlockMove',
              block: block,
              position: float.position
            });
          }
          block.moveTo(target);
          if (_this.onChange != null) {
            _this.onChange(new IceEditorChangeEvent(block, target));
          }
          return;
        }
        _this.undoStack.push({
          type: 'blockMove',
          block: block,
          target: parent != null ? ((function() {
            switch (parent.type) {
              case 'indentStart':
              case 'indentEnd':
                return parent.indent;
              case 'blockStart':
              case 'blockEnd':
                return parent.block;
              case 'socketStart':
              case 'socketEnd':
                return parent.socket;
              case 'segmentStart':
              case 'segmentEnd':
                return parent.segment;
              default:
                return parent;
            }
          })()) : null
        });
        block.moveTo(target);
        if (_this.onChange != null) {
          return _this.onChange(new IceEditorChangeEvent(block, target));
        }
      };
      this.undo = function() {
        var float, head, i, lastOperation, operation, _j, _k, _len1, _len2, _ref1, _ref2;
        if (!(_this.undoStack.length > 0)) {
          return;
        }
        operation = lastOperation = _this.undoStack.pop();
        if (operation.type === 'blockMove') {
          _ref1 = _this.floatingBlocks;
          for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
            float = _ref1[i];
            if (operation.block === float.block) {
              _this.floatingBlocks.splice(i, 1);
            }
          }
          while (true) {
            if (operation == null) {
              break;
            }
            if (operation.target != null) {
              switch (operation.target.type) {
                case 'indent':
                  head = operation.target.end.prev;
                  while (head.type === 'segmentEnd' || head.type === 'segmentStart' || head.type === 'cursor') {
                    head = head.prev;
                  }
                  if (head.type === 'newline') {
                    operation.block.moveTo(operation.target.start.next);
                  } else {
                    operation.block.moveTo(operation.target.start.insert(new NewlineToken()));
                  }
                  break;
                case 'block':
                  operation.block.moveTo(operation.target.end.insert(new NewlineToken()));
                  break;
                case 'socket':
                  if (operation.target.content() != null) {
                    operation.target.content().remove();
                  }
                  operation.block.moveTo(operation.target.start);
                  break;
                default:
                  if (operation.target === _this.tree) {
                    operation.block.moveTo(_this.tree.start);
                    if (operation.block.end.next !== _this.tree.end) {
                      operation.block.end.insert(new NewlineToken());
                    }
                  }
              }
            } else {
              operation.block.moveTo(operation.target);
            }
            if (operation.type === 'floatingBlockMove') {
              console.log('floatingBlockMove', operation);
              operation.block.moveTo(null);
              _this.floatingBlocks.push({
                position: operation.position,
                block: operation.block
              });
            }
            if ((operation.target != null) || operation.type !== 'blockMove' || operation.block !== lastOperation.block) {
              break;
            }
            operation = _this.undoStack.pop();
          }
        } else if (operation.type === 'socketTextChange') {
          operation.socket.content().value = operation.value;
        } else if (operation.type === 'floatingBlockMove') {
          _ref2 = _this.floatingBlocks;
          for (i = _k = 0, _len2 = _ref2.length; _k < _len2; i = ++_k) {
            float = _ref2[i];
            if (operation.block === float.block) {
              _this.floatingBlocks.splice(i, 1);
            }
          }
          console.log('floatingBlockMove');
          operation.block.moveTo(null);
          _this.floatingBlocks.push({
            position: operation.position,
            block: operation.block
          });
        }
        _this.redraw();
        if (_this.onChange != null) {
          return _this.onChange(new IceEditorChangeEvent(operation.block, operation.target));
        }
      };
      this.redrawPalette = function() {
        var lastBottomEdge, _j, _len1, _ref1, _results;
        lastBottomEdge = 0;
        _ref1 = _this.paletteBlocks;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          paletteBlock = _ref1[_j];
          paletteBlock.view.compute();
          paletteBlock.view.translate(new draw.Point(0, lastBottomEdge));
          lastBottomEdge = paletteBlock.view.bounds[paletteBlock.view.lineEnd].bottom() + PALETTE_MARGIN;
          _results.push(paletteBlock.view.draw(_this.paletteCtx));
        }
        return _results;
      };
      this.redrawPalette();
      insertHandwrittenBlock = function() {
        var newBlock, newSocket;
        newBlock = new Block([]);
        newSocket = new Socket([]);
        newSocket.handwritten = true;
        newBlock.start.insert(newSocket.start);
        newBlock.end.prev.insert(newSocket.end);
        if (_this.cursor.next.type === 'newline' || _this.cursor.next.type === 'indentEnd' || _this.cursor.next.type === 'segmentEnd') {
          if (_this.cursor.next.type === 'indentEnd' && _this.cursor.prev.type === 'newline') {
            moveBlockTo(newBlock, _this.cursor.prev);
          } else {
            moveBlockTo(newBlock, _this.cursor.prev.insert(new NewlineToken()));
          }
          _this.redraw();
          setTextInputFocus(newSocket);
        } else if (_this.cursor.prev.type === 'newline' || _this.cursor.prev.type === 'segmentStart') {
          moveBlockTo(newBlock, _this.cursor.prev);
          newBlock.end.insert(new NewlineToken());
          _this.redraw();
          setTextInputFocus(newSocket);
        }
        return scrollCursorIntoView();
      };
      scrollCursorIntoView = function() {
        _this.redraw();
        if (_this.cursor.view.point.y < _this.scrollOffset.y) {
          _this.mainCtx.translate(0, _this.scrollOffset.y - _this.cursor.view.point.y);
          _this.scrollOffset.y = _this.cursor.view.point.y;
          return _this.redraw();
        } else if (_this.cursor.view.point.y > (_this.scrollOffset.y + _this.main.height)) {
          _this.mainCtx.translate(0, (_this.scrollOffset.y + _this.main.height) - _this.cursor.view.point.y);
          _this.scrollOffset.y = _this.cursor.view.point.y - _this.main.height;
          return _this.redraw();
        }
      };
      moveCursorTo = function(token) {
        var head, _ref1;
        _this.cursor.remove();
        head = token;
        if (head !== _this.tree.start) {
          while (!((head == null) || ((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd' || _ref1 === 'segmentEnd'))) {
            head = head.next;
          }
        }
        if (head == null) {
          return;
        }
        if (head.type === 'newline' || head === _this.tree.start) {
          head.insert(_this.cursor);
        } else {
          head.insertBefore(_this.cursor);
        }
        _this.attemptReparse();
        return scrollCursorIntoView();
      };
      moveCursorBefore = function(token) {
        _this.cursor.remove();
        token.insertBefore(_this.cursor);
        _this.attemptReparse();
        return scrollCursorIntoView();
      };
      deleteFromCursor = function() {
        var head;
        head = _this.cursor.prev;
        while (head !== null && head.type !== 'indentStart' && head.type !== 'blockEnd') {
          head = head.prev;
        }
        if (head === null) {
          return;
        }
        if (head.type === 'blockEnd') {
          moveBlockTo(head.block, null);
          _this.redraw();
        }
        return scrollCursorIntoView();
      };
      moveCursorUp = function() {
        var depth, head, _ref1, _ref2;
        head = _this.cursor.prev.prev;
        while (head !== null && !(((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd') || head === _this.tree.start)) {
          head = head.prev;
        }
        if (head === null) {
          return;
        }
        if (head.type === 'indentEnd') {
          moveCursorBefore(head);
        } else {
          moveCursorTo(head);
        }
        head = _this.cursor;
        depth = 0;
        while (!((((_ref2 = head.type) === 'blockEnd' || _ref2 === 'indentEnd') || head === _this.tree.end) && depth === 0)) {
          switch (head.type) {
            case 'blockStart':
            case 'indentStart':
            case 'socketStart':
              depth += 1;
              break;
            case 'blockEnd':
            case 'indentEnd':
            case 'socketEnd':
              depth -= 1;
          }
          head = head.next;
        }
        if (head.type === 'blockEnd') {
          return moveCursorUp();
        }
      };
      moveCursorDown = function() {
        var depth, head, _ref1, _ref2;
        head = _this.cursor.next.next;
        while (head !== null && !(((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd') || head === _this.tree.end)) {
          head = head.next;
        }
        if (head === null) {
          return;
        }
        if (head.type === 'indentEnd' || head.type === 'segmentEnd') {
          moveCursorBefore(head);
        } else {
          moveCursorTo(head);
        }
        head = _this.cursor;
        depth = 0;
        while (!((((_ref2 = head.type) === 'blockEnd' || _ref2 === 'indentEnd') || head === _this.tree.end) && depth === 0)) {
          switch (head.type) {
            case 'blockStart':
            case 'indentStart':
            case 'socketStart':
              depth += 1;
              break;
            case 'blockEnd':
            case 'indentEnd':
            case 'socketEnd':
              depth -= 1;
          }
          head = head.next;
        }
        if (head.type === 'blockEnd') {
          return moveCursorDown();
        }
      };
      _ref1 = ['input', 'keydown', 'keyup', 'keypress'];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        eventName = _ref1[_j];
        this.hiddenInput.addEventListener(eventName, function(event) {
          if (!_this.isEditingText()) {
            return true;
          }
          return redrawTextInput();
        });
      }
      this.hiddenInput.addEventListener('keydown', function(event) {
        var head, newIndent, _ref2, _ref3, _ref4, _ref5;
        if (!_this.isEditingText()) {
          return true;
        }
        switch (event.keyCode) {
          case 13:
            if (_this.handwritten) {
              return insertHandwrittenBlock();
            } else {
              setTextInputFocus(null);
              _this.hiddenInput.blur();
              return _this.redraw();
            }
            break;
          case 8:
            if (_this.handwritten && _this.hiddenInput.value.length === 0) {
              deleteFromCursor();
              setTextInputFocus(null);
              return _this.hiddenInput.blur();
            }
            break;
          case 9:
            if (_this.handwritten) {
              head = _this.focus.start.prev.prev;
              while (head !== null && head.type !== 'blockEnd' && head.type !== 'blockStart') {
                head = head.prev;
              }
              if (head.type === 'blockStart') {

              } else if (head.prev.type === 'indentEnd') {
                moveBlockTo(_this.focus.start.prev.block, head.prev.prev.insert(new NewlineToken()));
                moveCursorTo(_this.focus.start.prev.block.end);
                _this.redraw();
                event.preventDefault();
                return false;
              } else {
                newIndent = new Indent([], INDENT_SPACES);
                head.prev.insert(newIndent.start);
                head.prev.insert(newIndent.end);
                moveBlockTo(_this.focus.start.prev.block, newIndent.start.insert(new NewlineToken()));
                moveCursorTo(_this.focus.start.prev.block.end);
                _this.redraw();
                event.preventDefault();
                return false;
              }
            }
            break;
          case 38:
            setTextInputFocus(null);
            _this.hiddenInput.blur();
            moveCursorUp();
            return _this.redraw();
          case 40:
            setTextInputFocus(null);
            _this.hiddenInput.blur();
            moveCursorDown();
            return _this.redraw();
          case 37:
            if (_this.hiddenInput.selectionStart === _this.hiddenInput.selectionEnd && _this.hiddenInput.selectionStart === 0) {
              head = _this.focus.start;
              while (!((head == null) || head.type === 'socketEnd' && !((_ref2 = (_ref3 = head.socket.content()) != null ? _ref3.type : void 0) === 'block' || _ref2 === 'socket'))) {
                head = head.prev;
              }
              if (head == null) {
                return;
              }
              return setTextInputFocus(head.socket);
            }
            break;
          case 39:
            if (_this.hiddenInput.selectionStart === _this.hiddenInput.selectionEnd && _this.hiddenInput.selectionStart === _this.hiddenInput.value.length) {
              head = _this.focus.end;
              while (!((head == null) || head.type === 'socketStart' && !((_ref4 = (_ref5 = head.socket.content()) != null ? _ref5.type : void 0) === 'block' || _ref4 === 'socket'))) {
                head = head.next;
              }
              if (head == null) {
                return;
              }
              return setTextInputFocus(head.socket);
            }
        }
      });
      this.hiddenInput.addEventListener('blur', function(event) {
        if (event.target !== document.activeElement) {
          return setTextInputFocus(null);
        }
      });
      document.body.addEventListener('keydown', function(event) {
        var head, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
        if ((_ref2 = event.target.tagName) === 'INPUT' || _ref2 === 'TEXTAREA') {
          return;
        }
        switch (event.keyCode) {
          case 13:
            if (!_this.isEditingText()) {
              insertHandwrittenBlock();
            }
            break;
          case 38:
            if (_this.cursor != null) {
              moveCursorUp();
            }
            break;
          case 40:
            if (_this.cursor != null) {
              moveCursorDown();
            }
            break;
          case 8:
            if (_this.cursor != null) {
              deleteFromCursor();
            }
            break;
          case 37:
            if (_this.cursor != null) {
              head = _this.cursor;
              while (!((head == null) || head.type === 'socketEnd' && !((_ref3 = (_ref4 = head.socket.content()) != null ? _ref4.type : void 0) === 'block' || _ref3 === 'socket'))) {
                head = head.prev;
              }
              if (head == null) {
                return;
              }
              setTextInputFocus(head.socket);
            }
            break;
          case 39:
            if (_this.cursor != null) {
              head = _this.cursor;
              while (!((head == null) || head.type === 'socketStart' && !((_ref5 = (_ref6 = head.socket.content()) != null ? _ref6.type : void 0) === 'block' || _ref5 === 'socket'))) {
                head = head.next;
              }
              if (head == null) {
                return;
              }
              setTextInputFocus(head.socket);
            }
        }
        if ((_ref7 = event.keyCode) === 13 || _ref7 === 38 || _ref7 === 40 || _ref7 === 8) {
          _this.redraw();
        }
        if ((_ref8 = event.keyCode) === 13 || _ref8 === 38 || _ref8 === 40 || _ref8 === 8 || _ref8 === 37) {
          return event.preventDefault();
        }
      });
      hitTest = function(point, root) {
        var head, seek;
        head = root;
        seek = null;
        while (head !== seek) {
          if (head.type === 'blockStart' && head.block.view.path.contains(point)) {
            seek = head.block.end;
          }
          head = head.next;
        }
        if (seek != null) {
          return seek.block;
        } else {
          return null;
        }
      };
      hitTestRoot = function(point) {
        return hitTest(point, _this.tree.start);
      };
      hitTestFloating = function(point) {
        var float, _k, _ref2;
        _ref2 = _this.floatingBlocks;
        for (_k = _ref2.length - 1; _k >= 0; _k += -1) {
          float = _ref2[_k];
          if (hitTest(point, float.block.start) !== null) {
            return float.block;
          }
        }
        return null;
      };
      hitTestFocus = function(point) {
        var head;
        head = _this.tree.start;
        while (head !== null) {
          if (head.type === 'socketStart' && (head.next.type === 'text' || head.next.type === 'socketEnd') && head.socket.view.bounds[head.socket.view.lineStart].contains(point)) {
            return head.socket;
          }
          head = head.next;
        }
        return null;
      };
      hitTestLasso = function(point) {
        if ((_this.lassoSegment != null) && _this._lassoBounds.contains(point)) {
          return _this.lassoSegment;
        } else {
          return null;
        }
      };
      hitTestPalette = function(point) {
        var block, _k, _len2, _ref2;
        point = new draw.Point(point.x + PALETTE_WIDTH, point.y - _this.scrollOffset.y);
        _ref2 = _this.paletteBlocks;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          block = _ref2[_k];
          if (hitTest(point, block.start) != null) {
            return block;
          }
        }
        return null;
      };
      getPointFromEvent = function(event) {
        switch (false) {
          case event.offsetX == null:
            return new draw.Point(event.offsetX - PALETTE_WIDTH, event.offsetY + _this.scrollOffset.y);
          case !event.layerX:
            return new draw.Point(event.layerX - PALETTE_WIDTH, event.layerY + _this.scrollOffset.y);
        }
      };
      track.addEventListener('mousedown', function(event) {
        var flag, float, point, _k, _len2, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
        if (event.button !== 0) {
          return;
        }
        _this.hiddenInput.blur();
        point = getPointFromEvent(event);
        _this.ephemeralSelection = (_ref2 = (_ref3 = (_ref4 = (_ref5 = hitTestFloating(point)) != null ? _ref5 : hitTestLasso(point)) != null ? _ref4 : hitTestFocus(point)) != null ? _ref3 : hitTestRoot(point)) != null ? _ref2 : hitTestPalette(point);
        if (_this.ephemeralSelection == null) {
          if (_this.lassoSegment != null) {
            flag = false;
            _ref6 = _this.floatingBlocks;
            for (_k = 0, _len2 = _ref6.length; _k < _len2; _k++) {
              float = _ref6[_k];
              if (float.block === _this.lassoSegment) {
                flag = true;
                break;
              }
            }
            if (!flag) {
              _this.lassoSegment.remove();
            }
            _this.lassoSegment = null;
            _this.redraw();
          }
          return _this.lassoAnchor = point;
        } else if (_this.ephemeralSelection.type === 'socket') {
          setTextInputFocus(_this.ephemeralSelection);
          _this.ephemeralSelection = null;
          return setTimeout((function() {
            setTextInputAnchor(point);
            redrawTextInput();
            return textInputSelecting = true;
          }), 0);
        } else {
          if (_ref7 = _this.ephemeralSelection, __indexOf.call(_this.paletteBlocks, _ref7) >= 0) {
            _this.ephemeralPoint = new draw.Point(point.x - _this.scrollOffset.x, point.y - _this.scrollOffset.y);
          } else {
            _this.ephemeralPoint = new draw.Point(point.x, point.y);
          }
          return moveCursorTo(_this.ephemeralSelection.end);
        }
      });
      track.addEventListener('mousemove', function(event) {
        var dest, fixedDest, float, head, i, next_head, old_highlight, point, rect, selectionInPalette, _k, _len2, _ref2, _ref3;
        if (_this.ephemeralSelection != null) {
          point = getPointFromEvent(event);
          if (point.from(_this.ephemeralPoint).magnitude() > MIN_DRAG_DISTANCE) {
            _this.selection = _this.ephemeralSelection;
            _this.ephemeralSelection = null;
            head = _this.selection.start;
            while (head !== _this.selection.end) {
              next_head = head.next;
              if (head.type === 'cursor') {
                head.remove();
              }
              head = next_head;
            }
            if (_ref2 = _this.selection, __indexOf.call(_this.paletteBlocks, _ref2) >= 0) {
              _this.ephemeralPoint.add(PALETTE_WIDTH, 0);
              selectionInPalette = true;
            }
            rect = _this.selection.view.bounds[_this.selection.view.lineStart];
            offset = _this.ephemeralPoint.from(new draw.Point(rect.x, rect.y));
            if (selectionInPalette) {
              _this.selection = _this.selection.clone();
            }
            moveBlockTo(_this.selection, null);
            _ref3 = _this.floatingBlocks;
            for (i = _k = 0, _len2 = _ref3.length; _k < _len2; i = ++_k) {
              float = _ref3[i];
              if (float.block === _this.selection) {
                _this.floatingBlocks.splice(i, 1);
                break;
              }
            }
            _this.selection.view.compute();
            _this.selection.view.draw(_this.dragCtx);
            if (selectionInPalette) {
              fixedDest = new draw.Point(rect.x - PALETTE_WIDTH, rect.y);
            } else {
              fixedDest = new draw.Point(rect.x - _this.scrollOffset.x, rect.y - _this.scrollOffset.y);
            }
            drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
            _this.redraw();
          }
        }
        if (_this.selection != null) {
          point = getPointFromEvent(event);
          point.add(-_this.scrollOffset.x, -_this.scrollOffset.y);
          fixedDest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          point.translate(_this.scrollOffset);
          dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          old_highlight = highlight;
          highlight = _this.tree.find(function(block) {
            var _ref4;
            return (!((_ref4 = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref4 : false)) && (block.view.dropArea != null) && block.view.dropArea.contains(dest);
          });
          if (old_highlight !== highlight) {
            _this.redraw();
          }
          if (highlight != null) {
            highlight.view.dropHighlightReigon.fill(_this.mainCtx, '#fff');
          }
          return drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
        }
      });
      track.addEventListener('mouseup', function(event) {
        var dest, head, point;
        if (_this.ephemeralSelection != null) {
          _this.ephemeralSelection = null;
          _this.ephemeralPoint = null;
        }
        if (_this.selection != null) {
          point = getPointFromEvent(event);
          dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          if (highlight != null) {
            switch (highlight.type) {
              case 'indent':
                head = highlight.end.prev;
                while (head.type === 'segmentEnd' || head.type === 'segmentStart' || head.type === 'cursor') {
                  head = head.prev;
                }
                if (head.type === 'newline') {
                  moveBlockTo(_this.selection, highlight.start.next);
                } else {
                  moveBlockTo(_this.selection, highlight.start.insert(new NewlineToken()));
                }
                break;
              case 'block':
                moveBlockTo(_this.selection, highlight.end.insert(new NewlineToken()));
                break;
              case 'socket':
                if (highlight.content() != null) {
                  highlight.content().remove();
                }
                moveBlockTo(_this.selection, highlight.start);
                break;
              default:
                if (highlight === _this.tree) {
                  moveBlockTo(_this.selection, _this.tree.start);
                  if (_this.selection.end.next !== _this.tree.end) {
                    _this.selection.end.insert(new NewlineToken());
                  }
                }
            }
          } else {
            if (dest.x > 0) {
              _this.floatingBlocks.push({
                position: dest,
                block: _this.selection
              });
            } else if (_this.selection === _this.lassoSegment) {
              _this.lassoSegment = null;
            }
          }
          drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(0px, 0px)";
          _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
          if (highlight != null) {
            moveCursorTo(_this.selection.end);
          }
          _this.selection = null;
          return _this.redraw();
        }
      });
      getRectFromPoints = function(a, b) {
        return new draw.Rectangle(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(a.x - b.x), Math.abs(a.y - b.y));
      };
      track.addEventListener('mousemove', function(event) {
        var point, rect;
        if (_this.lassoAnchor != null) {
          point = getPointFromEvent(event);
          point.add(-_this.scrollOffset.x, -_this.scrollOffset.y);
          rect = getRectFromPoints(new draw.Point(_this.lassoAnchor.x - _this.scrollOffset.x, _this.lassoAnchor.y - _this.scrollOffset.y), point);
          _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
          _this.dragCtx.strokeStyle = '#00f';
          return _this.dragCtx.strokeRect(rect.x, rect.y, rect.width, rect.height);
        }
      });
      track.addEventListener('mouseup', function(event) {
        var depth, firstLassoed, head, lastLassoed, point, rect, tokensToInclude;
        if (_this.lassoAnchor != null) {
          point = getPointFromEvent(event);
          rect = getRectFromPoints(_this.lassoAnchor, point);
          head = _this.tree.start;
          firstLassoed = null;
          while (head !== _this.tree.end) {
            if (head.type === 'blockStart' && head.block.view.path.intersects(rect)) {
              firstLassoed = head;
              break;
            }
            head = head.next;
          }
          head = _this.tree.end;
          lastLassoed = null;
          while (head !== _this.tree.start) {
            if (head.type === 'blockEnd' && head.block.view.path.intersects(rect)) {
              lastLassoed = head;
              break;
            }
            head = head.prev;
          }
          if ((firstLassoed != null) && (lastLassoed != null)) {
            tokensToInclude = [];
            head = firstLassoed;
            while (head !== lastLassoed) {
              switch (head.type) {
                case 'blockStart':
                case 'blockEnd':
                  tokensToInclude.push(head.block.start);
                  tokensToInclude.push(head.block.end);
                  break;
                case 'indentStart':
                case 'indentEnd':
                  tokensToInclude.push(head.indent.start);
                  tokensToInclude.push(head.indent.end);
                  break;
                case 'segmentStart':
                case 'segmentEnd':
                  tokensToInclude.push(head.segment.start);
                  tokensToInclude.push(head.segment.end);
              }
              head = head.next;
            }
            head = _this.tree.start;
            while (head !== _this.tree.end) {
              if (__indexOf.call(tokensToInclude, head) >= 0) {
                firstLassoed = head;
                break;
              }
              head = head.next;
            }
            head = _this.tree.end;
            lastLassoed = null;
            while (head !== _this.tree.start) {
              if (__indexOf.call(tokensToInclude, head) >= 0) {
                lastLassoed = head;
                break;
              }
              head = head.prev;
            }
            if (firstLassoed.type === 'indentStart') {
              depth = 0;
              while (depth > 0 || head.type !== 'blockStart') {
                if (firstLassoed.type === 'blockStart') {
                  depth -= 1;
                } else if (firstLassoed.type === 'blockEnd') {
                  depth += 1;
                }
                firstLassoed = firstLassoed.prev;
              }
              lastLassoed = firstLassoed.block.end;
            }
            if (firstLassoed.type === 'indentStart') {
              depth = 0;
              while (depth > 0 || head.type !== 'blockEnd') {
                if (lastLassoed.type === 'blockEnd') {
                  depth -= 1;
                } else if (lastLassoed.type === 'blockStart') {
                  depth += 1;
                }
              }
              firstLassoed = lastLassoed.block.start;
            }
            _this.lassoSegment = new Segment([]);
            firstLassoed.insertBefore(_this.lassoSegment.start);
            lastLassoed.insert(_this.lassoSegment.end);
            _this.redraw();
          }
          _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
          if (_this.lassoSegment != null) {
            moveCursorTo(_this.lassoSegment.end);
          }
          _this.lassoAnchor = null;
          return _this.redraw();
        }
      });
      redrawTextInput = function() {
        var end, start;
        _this.editedText.value = _this.hiddenInput.value;
        _this.redraw();
        start = _this.editedText.view.bounds[_editedInputLine].x + _this.mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionStart)).width;
        end = _this.editedText.view.bounds[_editedInputLine].x + _this.mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionEnd)).width;
        if (start === end) {
          return _this.mainCtx.strokeRect(start, _this.editedText.view.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT);
        } else {
          _this.mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3';
          return _this.mainCtx.fillRect(start, _this.editedText.view.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT);
        }
      };
      setTextInputFocus = function(focus) {
        var depth, head, newParse, _ref2, _ref3;
        if (_this.focus != null) {
          try {
            newParse = coffee.parse(_this.focus.toString()).next;
            if (newParse.type === 'blockStart') {
              if (_this.focus.handwritten) {
                newParse.block.moveTo(_this.focus.start.prev.block.start.prev);
                _this.focus.start.prev.block.moveTo(null);
              } else {
                if (((_ref2 = _this.focus.content()) != null ? _ref2.type : void 0) === 'text') {
                  _this.focus.content().remove();
                } else if (((_ref3 = _this.focus.content()) != null ? _ref3.type : void 0) === 'block') {
                  _this.focus.content().moveTo(null);
                }
                newParse.block.moveTo(_this.focus.start);
              }
            }
          } catch (_error) {}
          if (_this.onChange != null) {
            _this.onChange(new IceEditorChangeEvent(_this.focus, focus));
          }
          if (_this.ephemeralOldFocusValue !== _this.focus.toString()) {
            _this.undoStack.push({
              type: 'socketTextChange',
              socket: _this.focus,
              value: _this.ephemeralOldFocusValue
            });
          }
        }
        _this.focus = focus;
        if (_this.focus != null) {
          _this.ephemeralOldFocusValue = _this.focus.toString();
        } else {
          _this.ephemeralOldFocusValue = null;
        }
        if (_this.focus === null) {
          return;
        }
        _editedInputLine = _this.focus.view.lineStart;
        _this.handwritten = _this.focus.handwritten;
        if (!_this.focus.content()) {
          _this.editedText = new TextToken('');
          _this.focus.start.insert(_this.editedText);
        } else if (_this.focus.content().type === 'text') {
          _this.editedText = _this.focus.content();
        } else {
          throw 'Cannot edit occupied socket.';
        }
        head = _this.focus.end;
        depth = 0;
        while (head.type !== 'newline' && head.type !== 'indentEnd' && head.type !== 'segmentEnd') {
          head = head.next;
        }
        if (head.type === 'newline') {
          moveCursorTo(head);
        } else {
          moveCursorBefore(head);
        }
        _this.hiddenInput.value = _this.editedText.value;
        return setTimeout((function() {
          return _this.hiddenInput.focus();
        }), 0);
      };
      setTextInputHead = function(point) {
        textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x) / _this.mainCtx.measureText(' ').width);
        return _this.hiddenInput.setSelectionRange(Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead));
      };
      setTextInputAnchor = function(point) {
        textInputAnchor = textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x - PADDING) / _this.mainCtx.measureText(' ').width);
        return _this.hiddenInput.setSelectionRange(textInputAnchor, textInputHead);
      };
      track.addEventListener('mousemove', function(event) {
        var point;
        if (_this.isEditingText() && textInputSelecting) {
          point = getPointFromEvent(event);
          setTextInputHead(point);
          return redrawTextInput();
        }
      });
      track.addEventListener('mouseup', function(event) {
        if (_this.isEditingText()) {
          return textInputSelecting = false;
        }
      });
      track.addEventListener('mousewheel', function(event) {
        _this.clear();
        if (event.wheelDelta > 0) {
          if (_this.scrollOffset.y >= SCROLL_INTERVAL) {
            _this.scrollOffset.add(0, -SCROLL_INTERVAL);
            _this.mainCtx.translate(0, SCROLL_INTERVAL);
          } else {
            _this.mainCtx.translate(0, _this.scrollOffset.y);
            _this.scrollOffset.y = 0;
          }
        } else {
          _this.scrollOffset.add(0, SCROLL_INTERVAL);
          _this.mainCtx.translate(0, -SCROLL_INTERVAL);
        }
        return _this.redraw();
      });
    }

    Editor.prototype.setValue = function(value) {
      this.tree = coffee.parse(value).segment;
      return this.redraw();
    };

    Editor.prototype.getValue = function() {
      return this.tree.toString();
    };

    Editor.prototype.performMeltAnimation = function() {
      var count, head, state, textElements, tick, translationVectors,
        _this = this;
      if (this.currentlyAnimating) {
        return;
      } else {
        this.currentlyAnimating = true;
      }
      this.redraw();
      textElements = [];
      translationVectors = [];
      head = this.tree.start;
      state = {
        x: 0,
        y: 0,
        indent: 0
      };
      while (head !== this.tree.end) {
        if (head.type === 'text') {
          translationVectors.push(head.view.computePlaintextTranslationVector(state, this.mainCtx));
          textElements.push(head);
        } else if (head.type === 'newline') {
          state.y += FONT_SIZE;
          state.x = state.indent * this.mainCtx.measureText(' ').width;
        } else if (head.type === 'indentStart') {
          state.indent += head.indent.depth;
        } else if (head.type === 'indentEnd') {
          state.indent -= head.indent.depth;
        }
        head = head.next;
      }
      count = 0;
      tick = function() {
        var element, i, _i, _len;
        count += 1;
        if (count < ANIMATION_FRAME_RATE) {
          setTimeout(tick, 1000 / ANIMATION_FRAME_RATE);
        }
        _this.main.style.left = PALETTE_WIDTH * (1 - count / ANIMATION_FRAME_RATE);
        _this.palette.style.opacity = Math.max(0, 1 - 2 * (count / ANIMATION_FRAME_RATE));
        _this.clear();
        _this.mainCtx.globalAlpha = Math.max(0, 1 - 2 * count / ANIMATION_FRAME_RATE);
        _this.tree.view.draw(_this.mainCtx);
        _this.mainCtx.globalAlpha = 1;
        for (i = _i = 0, _len = textElements.length; _i < _len; i = ++_i) {
          element = textElements[i];
          element.view.textElement.draw(_this.mainCtx);
          element.view.translate(new draw.Point(translationVectors[i].x / ANIMATION_FRAME_RATE, translationVectors[i].y / ANIMATION_FRAME_RATE));
        }
        if (count >= ANIMATION_FRAME_RATE) {
          _this.ace.value = _this.getValue();
          _this.el.style.display = 'none';
          _this.aceEl.style.display = 'block';
          return _this.currentlyAnimating = false;
        }
      };
      return tick();
    };

    Editor.prototype.performFreezeAnimation = function() {
      var count, head, state, textElements, tick, translationVectors,
        _this = this;
      if (this.currentlyAnimating) {
        return;
      } else {
        this.currentlyAnimating = true;
      }
      this.setValue(this.ace.value);
      this.redraw();
      textElements = [];
      translationVectors = [];
      head = this.tree.start;
      state = {
        x: 0,
        y: 0,
        indent: 0
      };
      while (head !== this.tree.end) {
        if (head.type === 'text') {
          translationVectors.push(head.view.computePlaintextTranslationVector(state, this.mainCtx));
          head.view.translate(translationVectors[translationVectors.length - 1]);
          textElements.push(head);
        } else if (head.type === 'newline') {
          state.y += FONT_SIZE;
          state.x = state.indent * this.mainCtx.measureText(' ').width;
        } else if (head.type === 'indentStart') {
          state.indent += head.indent.depth;
        } else if (head.type === 'indentEnd') {
          state.indent -= head.indent.depth;
        }
        head = head.next;
      }
      this.aceEl.style.display = 'none';
      this.el.style.display = 'block';
      count = 0;
      tick = function() {
        var element, i, _i, _len;
        count += 1;
        if (count < ANIMATION_FRAME_RATE) {
          setTimeout(tick, 1000 / ANIMATION_FRAME_RATE);
        }
        _this.main.style.left = PALETTE_WIDTH * (count / ANIMATION_FRAME_RATE);
        _this.palette.style.opacity = Math.max(0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE));
        _this.clear();
        _this.mainCtx.globalAlpha = Math.max(0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE));
        _this.tree.view.draw(_this.mainCtx);
        _this.mainCtx.globalAlpha = 1;
        for (i = _i = 0, _len = textElements.length; _i < _len; i = ++_i) {
          element = textElements[i];
          element.view.textElement.draw(_this.mainCtx);
          element.view.translate(new draw.Point(-translationVectors[i].x / ANIMATION_FRAME_RATE, -translationVectors[i].y / ANIMATION_FRAME_RATE));
        }
        if (count === ANIMATION_FRAME_RATE) {
          _this.redraw();
          return _this.currentlyAnimating = false;
        }
      };
      return tick();
    };

    return Editor;

  })();

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/