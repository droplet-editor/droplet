/*
# Copyright (c) 2014 Anthony Bau.
# MIT License.
#
# Tree classes and operations for ICE editor.
*/


(function() {
  var Block, BlockEndToken, BlockStartToken, BlockView, BoundingBoxState, CursorToken, CursorView, EMPTY_INDENT_HEIGHT, EMPTY_INDENT_WIDTH, EMPTY_SOCKET_HEIGHT, EMPTY_SOCKET_WIDTH, Editor, FONT_HEIGHT, INDENT_SPACES, INDENT_SPACING, INPUT_LINE_HEIGHT, IceEditorChangeEvent, IceView, Indent, IndentEndToken, IndentStartToken, IndentView, NewlineToken, PADDING, PALETTE_MARGIN, PALETTE_WIDTH, PathWaypoint, Segment, SegmentEndToken, SegmentStartToken, SegmentView, Socket, SocketEndToken, SocketStartToken, SocketView, TAB_HEIGHT, TAB_OFFSET, TAB_WIDTH, TOUNGE_HEIGHT, TextToken, TextView, Token, exports,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  exports = {};

  /*
  # A Block is a bunch of tokens that are grouped together.
  */


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

    Block.prototype.embedded = function() {
      return this.start.prev.type === 'socketStart';
    };

    Block.prototype.contents = function() {
      var contents, head;
      contents = [];
      head = this.start;
      while (head !== this.end) {
        contents.push(head);
        head = head.next;
      }
      contents.push(this.end);
      return contents;
    };

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

    Block.prototype.lines = function() {
      var contents, currentLine, head;
      contents = [];
      currentLine = [];
      head = this.start;
      while (head !== this.end) {
        contents.push(head);
        if (head.type === 'newline') {
          contents.push(currentLine);
          currentLine = [];
        }
        head = head.next;
      }
      currentLine.push(this.end);
      contents.push(currentLine);
      return contents;
    };

    Block.prototype._moveTo = function(parent) {
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
        parent.next.prev = this.end;
        parent.next = this.start;
        return this.start.prev = parent;
      }
    };

    Block.prototype.findBlock = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'blockStart' && f(head.block)) {
          return head.block.findBlock(f);
        }
        head = head.next;
      }
      if (f(this)) {
        return this;
      } else {
        return null;
      }
    };

    Block.prototype.findSocket = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'socketStart' && f(head.socket)) {
          return head.socket.findSocket(f);
        }
        head = head.next;
      }
      return null;
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

    Indent.prototype.embedded = function() {
      return false;
    };

    Indent.prototype.toString = function(state) {
      var string;
      string = this.start.toString(state);
      return string.slice(0, string.length - this.end.toString(state).length - 1);
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

    Segment.prototype.embedded = function() {
      return false;
    };

    Segment.prototype.remove = function() {
      this.start.remove();
      this.end.remove();
      this.start.next = this.end;
      return this.end.prev = this.start;
    };

    Segment.prototype._moveTo = function(parent) {
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
        parent.next.prev = this.end;
        parent.next = this.start;
        return this.start.prev = parent;
      }
    };

    Segment.prototype.findBlock = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'blockStart' && f(head.block)) {
          return head.block.findBlock(f);
        }
        head = head.next;
      }
      return null;
    };

    Segment.prototype.findSocket = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'socketStart' && f(head.socket)) {
          return head.socket.findSocket(f);
        }
        head = head.next;
      }
      return null;
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

    Socket.prototype.embedded = function() {
      return false;
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

    Socket.prototype.findSocket = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'socketStart' && f(head.socket)) {
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
      if (this.content() != null) {
        return this.content().toString({
          indent: ''
        });
      } else {
        return '';
      }
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

  /*
  # Special kinds of tokens
  */


  exports.CursorToken = CursorToken = (function(_super) {
    __extends(CursorToken, _super);

    function CursorToken() {
      this.prev = this.next = null;
      this.view = new CursorView(this);
      this.type = 'cursor';
    }

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

  /*
  # Example LISP parser/
  */


  exports.lispParse = function(str) {
    var block, block_stack, char, currentString, first, head, socket, socket_stack, _i, _len;
    currentString = '';
    first = head = new TextToken('');
    block_stack = [];
    socket_stack = [];
    for (_i = 0, _len = str.length; _i < _len; _i++) {
      char = str[_i];
      switch (char) {
        case '(':
          head = head.append(new TextToken(currentString));
          block_stack.push(block = new Block([]));
          socket_stack.push(socket = new Socket(block));
          head = head.append(socket.start);
          head = head.append(block.start);
          head = head.append(new TextToken('('));
          currentString = '';
          break;
        case ')':
          head = head.append(new TextToken(currentString));
          head = head.append(new TextToken(')'));
          head = head.append(block_stack.pop().end);
          head = head.append(socket_stack.pop().end);
          currentString = '';
          break;
        case ' ':
          head = head.append(new TextToken(currentString));
          head = head.append(new TextToken(' '));
          currentString = '';
          break;
        case '\n':
          head = head.append(new TextToken(currentString));
          head = head.append(new NewlineToken());
          currentString = '';
          break;
        default:
          currentString += char;
      }
    }
    head = head.append(new TextToken(currentString));
    return first;
  };

  exports.indentParse = function(str) {
    var block, char, currentString, depth_stack, first, head, indent, line, popped, socket, stack, _i, _j, _len, _len1, _ref, _ref1;
    head = first = new TextToken('');
    stack = [];
    depth_stack = [0];
    _ref = str.split('\n');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      indent = line.length - line.trimLeft().length;
      if (indent > _.last(depth_stack)) {
        head = head.append((new Indent([], indent - _.last(depth_stack))).start);
        stack.push(head.indent);
        depth_stack.push(indent);
      }
      while (indent < _.last(depth_stack)) {
        head = head.append(stack.pop().end);
        depth_stack.pop();
      }
      head = head.append(new NewlineToken());
      currentString = '';
      _ref1 = line.trimLeft();
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        char = _ref1[_j];
        switch (char) {
          case '(':
            if (currentString.length > 0) {
              head = head.append(new TextToken(currentString));
            }
            if (stack.length > 0 && _.last(stack).type === 'block') {
              stack.push(socket = new Socket(block));
              head = head.append(socket.start);
            }
            stack.push(block = new Block([]));
            head = head.append(block.start);
            head = head.append(new TextToken('('));
            currentString = '';
            break;
          case ')':
            if (currentString.length > 0) {
              head = head.append(new TextToken(currentString));
            }
            popped = {};
            while (popped.type !== 'block') {
              popped = stack.pop();
              if (popped.type === 'block') {
                head = head.append(new TextToken(')'));
              }
              head = head.append(popped.end);
              if (head.type === 'indentEnd') {
                depth_stack.pop();
              }
            }
            if (stack.length > 0 && _.last(stack).type === 'socket') {
              head = head.append(stack.pop().end);
            }
            currentString = '';
            break;
          case ' ':
            if (currentString.length > 0) {
              head = head.append(new TextToken(currentString));
            }
            head = head.append(new TextToken(' '));
            currentString = '';
            break;
          default:
            currentString += char;
        }
      }
      if (currentString.length > 0) {
        head = head.append(new TextToken(currentString));
      }
    }
    while (stack.length > 0) {
      head = head.append(stack.pop().end);
    }
    return first.next.next;
  };

  window.ICE = exports;

  /*
  # Magic constants
  */


  PADDING = 5;

  INDENT_SPACING = 10;

  TOUNGE_HEIGHT = 10;

  FONT_HEIGHT = 15;

  EMPTY_SOCKET_HEIGHT = FONT_HEIGHT + PADDING * 2;

  EMPTY_SOCKET_WIDTH = 20;

  EMPTY_INDENT_HEIGHT = FONT_HEIGHT + PADDING * 2;

  EMPTY_INDENT_WIDTH = 50;

  TAB_WIDTH = 15;

  TAB_HEIGHT = 5;

  TAB_OFFSET = 10;

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
        /*
        # Normally, we just enclose everything within these bounds
        */

        return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
      } else if (this.lineChildren[line].length > 0) {
        /*
        # There is, however, the special case when a child on this line is indented, or is an indent.
        */

        if (line === this.lineChildren[line][0].lineEnd && this.lineChildren[line][0].block.type === 'indent') {
          /*
          # If the indent ends on this line, we draw the piece underneath it, and any 'G'-shape elements after it.
          */

          indentChild = this.lineChildren[line][0];
          paddingLeft = this.lineChildren[line][0].block.type === 'indent' ? INDENT_SPACING : PADDING;
          if (this.lineChildren[line].length === 1) {
            return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
          } else {
            return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
          }
        } else {
          /*
          # When the child in front of us is indented, we only draw a thin strip
          # of conainer block to the left of them, with width INDENT_SPACING
          */

          return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].y), new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].bottom())]);
        }
      }
    };

    BlockView.prototype.computePath = function() {
      var entryPoint, line, point, waypoint, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3, _ref4;
      BlockView.__super__.computePath.apply(this, arguments);
      this.path = new draw.Path();
      this.dropArea = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - 5, this.bounds[this.lineEnd].width, 10);
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
      this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
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
      /*
      # A Segment can compute its bounds the same way an Indent does.
      */

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

    return SegmentView;

  })(IceView);

  CursorView = (function(_super) {
    __extends(CursorView, _super);

    function CursorView(block) {
      CursorView.__super__.constructor.call(this, block);
    }

    CursorView.prototype.computeChildren = function(line) {
      return this.lineStart = this.lineEnd = line;
    };

    return CursorView;

  })(IceView);

  INDENT_SPACES = 2;

  INPUT_LINE_HEIGHT = 15;

  PALETTE_MARGIN = 10;

  PALETTE_WIDTH = 300;

  exports.IceEditorChangeEvent = IceEditorChangeEvent = (function() {
    function IceEditorChangeEvent(block, target) {
      this.block = block;
      this.target = target;
    }

    return IceEditorChangeEvent;

  })();

  exports.Editor = Editor = (function() {
    function Editor(el, paletteBlocks) {
      var child, deleteFromCursor, drag, dragCtx, eventName, getPointFromEvent, getRectFromPoints, highlight, hitTest, hitTestFloating, hitTestFocus, hitTestLasso, hitTestPalette, hitTestRoot, insertHandwrittenBlock, main, mainCtx, moveBlockTo, moveCursorBefore, moveCursorDown, moveCursorTo, moveCursorUp, offset, palette, paletteBlock, paletteCtx, redrawTextInput, setTextInputAnchor, setTextInputFocus, setTextInputHead, textInputAnchor, textInputHead, textInputSelecting, track, _editedInputLine, _i, _j, _len, _len1, _ref, _ref1,
        _this = this;
      this.paletteBlocks = paletteBlocks;
      /*
      # Field declaration
      # (useful to have all in one place)
      */

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
      /*
      # MODEL instances (program state)
      */

      this.tree = null;
      this.floatingBlocks = [];
      /*
      # TEXT INPUT interactive fields
      */

      this.focus = null;
      this.editedText = null;
      this.handwritten = false;
      this.hiddenInput = null;
      this.isEditingText = function() {
        return _this.hiddenInput === document.activeElement;
      };
      textInputAnchor = textInputHead = null;
      textInputSelecting = false;
      _editedInputLine = -1;
      /*
      # NORMAL DRAG interactive fields
      */

      this.selection = null;
      /*
      # LASSO SELECT interactive fields
      */

      this.lassoSegment = null;
      this._lassoBounds = null;
      /*
      # CURSOR interactive fields
      */

      this.cursor = new CursorToken();
      this.scrollOffset = new draw.Point(0, 0);
      offset = null;
      highlight = null;
      /*
      # DOM SETUP
      */

      main = document.createElement('canvas');
      main.className = 'canvas';
      main.height = el.offsetHeight;
      main.width = el.offsetWidth - PALETTE_WIDTH;
      palette = document.createElement('canvas');
      palette.className = 'palette';
      palette.height = el.offsetHeight;
      palette.width = PALETTE_WIDTH;
      drag = document.createElement('canvas');
      drag.className = 'drag';
      drag.height = el.offsetHeight;
      drag.width = el.offsetWidth - PALETTE_WIDTH;
      this.hiddenInput = document.createElement('input');
      this.hiddenInput.className = 'hidden_input';
      track = document.createElement('div');
      track.className = 'trackArea';
      _ref = [main, palette, drag, track, this.hiddenInput];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        el.appendChild(child);
      }
      mainCtx = main.getContext('2d');
      dragCtx = drag.getContext('2d');
      paletteCtx = palette.getContext('2d');
      draw._setCTX(mainCtx);
      /*
      # General-purpose methods that call the view.
      */

      this.clear = function() {
        return mainCtx.clearRect(_this.scrollOffset.x, _this.scrollOffset.y, main.width, main.height);
      };
      this.redraw = function() {
        var float, view, _j, _k, _len1, _len2, _ref1, _ref2, _results;
        _this.clear();
        _this.tree.view.compute();
        _this.tree.view.draw(mainCtx);
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
            _this._lassoBounds.stroke(mainCtx, '#000');
            _this._lassoBounds.fill(mainCtx, 'rgba(0, 0, 256, 0.3)');
          }
        }
        _ref2 = _this.floatingBlocks;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          float = _ref2[_k];
          view = float.block.view;
          view.compute();
          view.translate(float.position);
          _results.push(view.draw(mainCtx));
        }
        return _results;
      };
      this.attemptReparse = function() {
        try {
          _this.tree = (coffee.parse(_this.getValue())).segment;
          return _this.redraw();
        } catch (_error) {}
      };
      moveBlockTo = function(block, target) {
        block._moveTo(target);
        if (_this.onChange != null) {
          return _this.onChange(new IceEditorChangeEvent(block, target));
        }
      };
      /*
      # The redrawPalette function ought to be called only once in the current code structure.
      # If we want to scroll the palette later on, then this will be called to do so.
      */

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
          _results.push(paletteBlock.view.draw(paletteCtx));
        }
        return _results;
      };
      this.redrawPalette();
      /*
      # Cursor operations
      */

      insertHandwrittenBlock = function() {
        var newBlock, newSocket;
        newBlock = new Block([]);
        newSocket = new Socket([]);
        newSocket.handwritten = true;
        newBlock.start.insert(newSocket.start);
        newBlock.end.prev.insert(newSocket.end);
        if (_this.cursor.next.type === 'newline' || _this.cursor.next.type === 'indentEnd' || _this.cursor.next.type === 'segmentEnd') {
          moveBlockTo(newBlock, _this.cursor.prev.insert(new NewlineToken()));
          _this.redraw();
          return setTextInputFocus(newSocket);
        } else if (_this.cursor.prev.type === 'newline' || _this.cursor.prev.type === 'segmentStart') {
          moveBlockTo(newBlock, _this.cursor.prev);
          newBlock.end.insert(new NewlineToken());
          _this.redraw();
          return setTextInputFocus(newSocket);
        }
      };
      moveCursorTo = function(token) {
        _this.cursor.remove();
        return token.insert(_this.cursor);
      };
      moveCursorBefore = function(token) {
        _this.cursor.remove();
        return token.insertBefore(_this.cursor);
      };
      deleteFromCursor = function() {
        var head, _ref1;
        head = _this.cursor.prev;
        console.log(head, head.toString({
          indent: ''
        }));
        while (head !== null && head.type !== 'indentStart' && head.type !== 'blockEnd') {
          console.log(head, (_ref1 = head.block) != null ? typeof _ref1.toString === "function" ? _ref1.toString() : void 0 : void 0);
          head = head.prev;
          console.log(head.toString({
            indent: ''
          }));
        }
        console.log(head.toString({
          indent: ''
        }));
        if (head.type === 'blockEnd') {
          moveBlockTo(head.block, null);
          return _this.redraw();
        }
      };
      /*
      # TODO the following are known not to be able to navigate to the end of an indent.
      */

      moveCursorUp = function() {
        var head, _ref1;
        head = _this.cursor.prev.prev;
        while (head !== null && !((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd' || _ref1 === 'segmentStart')) {
          head = head.prev;
        }
        if (head === null) {
          return;
        }
        if (head.type === 'indentEnd') {
          return moveCursorBefore(head);
        } else {
          return moveCursorTo(head);
        }
      };
      moveCursorDown = function() {
        var head, _ref1;
        head = _this.cursor.next.next;
        while (head !== null && !((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd' || _ref1 === 'segmentEnd')) {
          head = head.next;
        }
        if (head === null) {
          return;
        }
        if (head.type === 'indentEnd' || head.type === 'segmentEnd') {
          return moveCursorBefore(head);
        } else {
          return moveCursorTo(head);
        }
      };
      /*
      # Bind events to the hidden input
      */

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
        var head, newIndent;
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
        }
      });
      /*
      @hiddenInput.addEventListener 'blur', (event) =>
        console.log 'blurred'
        # If we have actually blurred (as opposed to simply unfocused the browser window)
        if event.target isnt document.activeElement then setTextInputFocus null
      */

      /*
      # Bind keyboard shortcut events to the document
      */

      document.body.addEventListener('keydown', function(event) {
        var head, _ref2, _ref3;
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
              while (head.type !== 'socketEnd') {
                head = head.prev;
              }
              setTextInputFocus(head.socket);
            }
        }
        if ((_ref3 = event.keyCode) === 13 || _ref3 === 38 || _ref3 === 40 || _ref3 === 8) {
          return _this.redraw();
        }
      });
      /*
      # Hit-testing functions
      */

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
        var float, _k, _len2, _ref2;
        _ref2 = _this.floatingBlocks;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
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
        point = new draw.Point(point.x + PALETTE_WIDTH, point.y);
        _ref2 = _this.paletteBlocks;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          block = _ref2[_k];
          if (hitTest(point, block.start) != null) {
            return block;
          }
        }
        return null;
      };
      /*
      # Mouse events
      */

      getPointFromEvent = function(event) {
        switch (false) {
          case event.offsetX == null:
            return new draw.Point(event.offsetX - PALETTE_WIDTH, event.offsetY + _this.scrollOffset.y);
          case !event.layerX:
            return new draw.Point(event.layerX - PALETTE_WIDTH, event.layerY + _this.scrollOffset.y);
        }
      };
      /*
      # The mousedown event, which sets fields according to what we have just selected.
      */

      track.addEventListener('mousedown', function(event) {
        var fixedDest, flag, float, i, point, rect, selectionInPalette, _k, _l, _len2, _len3, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
        point = getPointFromEvent(event);
        _this.selection = (_ref2 = (_ref3 = (_ref4 = (_ref5 = hitTestFloating(point)) != null ? _ref5 : hitTestLasso(point)) != null ? _ref4 : hitTestFocus(point)) != null ? _ref3 : hitTestRoot(point)) != null ? _ref2 : hitTestPalette(point);
        if (_this.selection == null) {
          /*
          # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
          */

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
        } else if (_this.selection.type === 'socket') {
          /*
          # If we have clicked on a socket, then TEXT INPUT, indicated by (@isEditingText())
          */

          setTextInputFocus(_this.selection);
          return setTimeout((function() {
            console.log('setting anchor', _this.focus);
            setTextInputAnchor(point);
            redrawTextInput();
            textInputSelecting = true;
            return _this.selection = null;
          }), 0);
        } else {
          /*
          # If we have clicked on a block or segment, then NORMAL DRAG, indicated by (@selection?)
          */

          selectionInPalette = false;
          if (_ref7 = _this.selection, __indexOf.call(_this.paletteBlocks, _ref7) >= 0) {
            point.add(PALETTE_WIDTH, 0);
            selectionInPalette = true;
          }
          rect = _this.selection.view.bounds[_this.selection.view.lineStart];
          offset = point.from(new draw.Point(rect.x, rect.y));
          if (selectionInPalette) {
            _this.selection = _this.selection.clone();
          }
          _ref8 = _this.floatingBlocks;
          for (i = _l = 0, _len3 = _ref8.length; _l < _len3; i = ++_l) {
            float = _ref8[i];
            if (float.block === _this.selection) {
              _this.floatingBlocks.splice(i, 1);
              break;
            }
          }
          moveBlockTo(_this.selection, null);
          _this.selection.view.compute();
          _this.selection.view.draw(dragCtx);
          if (selectionInPalette) {
            fixedDest = new draw.Point(rect.x - PALETTE_WIDTH, rect.y);
          } else {
            fixedDest = new draw.Point(rect.x - _this.scrollOffset.x, rect.y - _this.scrollOffset.y);
          }
          drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
          return _this.redraw();
        }
      });
      /*
      # Track mouse events for NORMAL DRAG (only)
      */

      track.addEventListener('mousemove', function(event) {
        var dest, fixedDest, old_highlight, point;
        if (_this.selection != null) {
          point = getPointFromEvent(event);
          point.add(-_this.scrollOffset.x, -_this.scrollOffset.y);
          fixedDest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          point.translate(_this.scrollOffset);
          dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          old_highlight = highlight;
          highlight = _this.tree.find(function(block) {
            var _ref2;
            return (!((_ref2 = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref2 : false)) && (block.view.dropArea != null) && block.view.dropArea.contains(dest);
          });
          if (old_highlight !== highlight) {
            _this.redraw();
          }
          if (highlight != null) {
            highlight.view.dropArea.fill(mainCtx, '#fff');
          }
          return drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
        }
      });
      track.addEventListener('mouseup', function(event) {
        var dest, head, point;
        if (_this.selection != null) {
          point = getPointFromEvent(event);
          dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          if (highlight != null) {
            /*
            # Drop areas signify different things depending on the block that they belong to
            */

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
                  _this.selection.end.insert(new NewlineToken());
                }
            }
          } else {
            if (point.x > 0) {
              _this.floatingBlocks.push({
                position: dest,
                block: _this.selection
              });
            }
          }
          drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(0px, 0px)";
          dragCtx.clearRect(0, 0, drag.width, drag.height);
          if (highlight != null) {
            head = _this.selection.end;
            while (head !== _this.tree.end && head.type !== 'newline') {
              head = head.next;
            }
            if (head === _this.tree.end) {
              moveCursorBefore(head);
            } else {
              moveCursorTo(head);
            }
          }
          _this.selection = null;
          return _this.redraw();
        }
      });
      /*
      # Track mouse events for LASSO SELECT
      */

      getRectFromPoints = function(a, b) {
        return new draw.Rectangle(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(a.x - b.x), Math.abs(a.y - b.y));
      };
      track.addEventListener('mousemove', function(event) {
        var point, rect;
        if (_this.lassoAnchor != null) {
          point = getPointFromEvent(event);
          point.translate(_this.scrollOffset);
          rect = getRectFromPoints(_this.lassoAnchor, point);
          dragCtx.clearRect(0, 0, drag.width, drag.height);
          dragCtx.strokeStyle = '#00f';
          return dragCtx.strokeRect(rect.x, rect.y, rect.width, rect.height);
        }
      });
      track.addEventListener('mouseup', function(event) {
        var depth, firstLassoed, head, lastLassoed, point, rect, tokensToInclude;
        if (_this.lassoAnchor != null) {
          point = getPointFromEvent(event);
          point.translate(_this.scrollOffset);
          rect = getRectFromPoints(_this.lassoAnchor, point);
          /*
          # First pass for lasso segment detection: get intersecting blocks.
          */

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
            /*
            # Second pass for lasso segment detection: validate the selection and record wrapping blocks as necessary.
            */

            tokensToInclude = [];
            head = firstLassoed;
            while (head !== lastLassoed) {
              /*
              # For each bit of markup, make sure to include both its start token and end token
              */

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
            /*
            # Third pass for lasso segment detection: include all necessary tokens demanded by validation
            */

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
            /*
            # Fourth pass for lasso segment detection: make sure that we have selected the wrapping block for any indents
            #
            # Note that this will only occur when we have inserted the indentStart at the beginning or indentEnd at the end
            # in the second and third pass. This in turn will occur ONLY when the user has selected multiple blocks belonging to the
            # same wrapping block, and nothing outside it (i.e. the wrapping block of the indent wraps the entire selection).
            #
            # So it suffices to select that entire wrapping block.
            */

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
          dragCtx.clearRect(0, 0, drag.width, drag.height);
          if (_this.lassoSegment != null) {
            moveCursorTo(_this.lassoSegment.end);
          }
          _this.lassoAnchor = null;
          return _this.redraw();
        }
      });
      /*
      # Utility functions for TEXT INPUT
      */

      redrawTextInput = function() {
        var end, start;
        _this.editedText.value = _this.hiddenInput.value;
        _this.redraw();
        start = _this.editedText.view.bounds[_editedInputLine].x + mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionStart)).width;
        end = _this.editedText.view.bounds[_editedInputLine].x + mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionEnd)).width;
        if (start === end) {
          return mainCtx.strokeRect(start, _this.editedText.view.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT);
        } else {
          mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3';
          return mainCtx.fillRect(start, _this.editedText.view.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT);
        }
      };
      setTextInputFocus = function(focus) {
        var depth, head;
        _this.focus = focus;
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
        textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width);
        return _this.hiddenInput.setSelectionRange(Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead));
      };
      setTextInputAnchor = function(point) {
        textInputAnchor = textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width);
        return _this.hiddenInput.setSelectionRange(textInputAnchor, textInputHead);
      };
      /*
      # Track mouse events for TEXT INPUT
      */

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
      /*
      # Track events for SCROLLING
      */

      track.addEventListener('mousewheel', function(event) {
        _this.clear();
        if (event.wheelDelta > 0) {
          if (_this.scrollOffset.y >= 100) {
            _this.scrollOffset.add(0, -100);
            mainCtx.translate(0, 100);
          }
        } else {
          _this.scrollOffset.add(0, 100);
          mainCtx.translate(0, -100);
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

    return Editor;

  })();

  window.onload = function() {
    var paletteElement;
    window.editor = new Editor(document.getElementById('editor'), (function() {
      var _i, _len, _ref, _results;
      _ref = ['for i in [1..10]\n  alert \'hello\'', 'alert \'hello\'', 'if a is b\n  alert \'hi\'\nelse\n  alert \'bye\'', 'a = b'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        paletteElement = _ref[_i];
        _results.push(coffee.parse(paletteElement).next.block);
      }
      return _results;
    })());
    editor.setValue('for i in [1..10]\n  if i % 2 is 0\n    alert i\n    alert \'bye\'\n  else\n    alert \'fizz\'\n  alert \'buzz\'');
    editor.onChange = function() {
      return document.getElementById('out').innerText = editor.getValue();
    };
    return document.getElementById('out').addEventListener('input', function() {
      try {
        return editor.setValue(this.value);
      } catch (_error) {}
    });
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/