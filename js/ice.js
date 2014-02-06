/*
# Copyright (c) 2014 Anthony Bau.
# MIT License.
#
# Tree classes and operations for ICE editor.
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, CursorToken, CursorTokenPaper, DEFAULT_CURSOR_WIDTH, DROP_AREA_MAX_WIDTH, EMPTY_INDENT_WIDTH, EMPTY_SEGMENT_DROP_WIDTH, Editor, FONT_SIZE, INDENT, INDENT_SPACES, INPUT_LINE_HEIGHT, IcePaper, Indent, IndentEndToken, IndentPaper, IndentStartToken, MIN_INDENT_DROP_WIDTH, MOUTH_BOTTOM, NewlineToken, PADDING, PALETTE_MARGIN, PALETTE_WHITESPACE, PALETTE_WIDTH, Segment, SegmentEndToken, SegmentPaper, SegmentStartToken, Socket, SocketEndToken, SocketPaper, SocketStartToken, TextToken, TextTokenPaper, Token, exports,
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
      this.paper = new BlockPaper(this);
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
      var first, last;
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
        if ((first != null) && (first.type === 'newline') && ((last == null) || last.type === 'newline' || last.type === 'indentEnd')) {
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
      this.paper = new IndentPaper(this);
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
      this.paper = new SegmentPaper(this);
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
      var first, last;
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
        if ((first != null) && (first.type === 'newline') && ((last == null) || last.type === 'newline' || last.type === 'indentEnd')) {
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
      this.paper = new SocketPaper(this);
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
      this.paper = new CursorTokenPaper(this);
      this.type = 'cursor';
    }

    return CursorToken;

  })(Token);

  exports.TextToken = TextToken = (function(_super) {
    __extends(TextToken, _super);

    function TextToken(value) {
      this.value = value;
      this.prev = this.next = null;
      this.paper = new TextTokenPaper(this);
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
  # Copyright (c) 2014 Anthony Bau
  # MIT License
  #
  # Rendering classes and functions for ICE editor.
  */


  /*
  # TODO Trigger rewrite this coming weekend.
  */


  PADDING = 5;

  INDENT = 10;

  MOUTH_BOTTOM = 50;

  DROP_AREA_MAX_WIDTH = 50;

  FONT_SIZE = 15;

  EMPTY_INDENT_WIDTH = 50;

  PALETTE_WIDTH = 300;

  PALETTE_WHITESPACE = 10;

  MIN_INDENT_DROP_WIDTH = 20;

  EMPTY_SEGMENT_DROP_WIDTH = 100;

  DEFAULT_CURSOR_WIDTH = 100;

  /*
  # For developers, bits of policy:
  # 1. Calling IcePaper.draw() must ALWAYS render the entire block and all its children.
  # 2. ONLY IcePaper.compute() may modify the pointer value of @lineGroups or @bounds. Use copy() and clear().
  */


  window.RUN_PAPER_TESTS = false;

  window.PERFORMANCE_TEST = false;

  IcePaper = (function() {
    function IcePaper(block) {
      this.block = block;
      this.point = new draw.Point(0, 0);
      this.group = new draw.Group();
      this.bounds = {};
      this.lineGroups = {};
      this.children = [];
      this.lineStart = this.lineEnd = 0;
    }

    IcePaper.prototype.compute = function(state) {
      return this;
    };

    IcePaper.prototype.finish = function() {
      var child, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.finish());
      }
      return _results;
    };

    IcePaper.prototype.draw = function() {};

    IcePaper.prototype.setLeftCenter = function(line, point) {};

    IcePaper.prototype.translate = function(vector) {
      this.point.translate(vector);
      return this.group.translate(vector);
    };

    IcePaper.prototype.position = function(point) {
      return this.translate(this.point.from(point));
    };

    return IcePaper;

  })();

  BlockPaper = (function(_super) {
    __extends(BlockPaper, _super);

    function BlockPaper(block) {
      BlockPaper.__super__.constructor.call(this, block);
      this._lineChildren = {};
      this.indented = {};
      this.indentEnd = {};
    }

    BlockPaper.prototype.compute = function(state) {
      var axis, head, height, i, indent, line, top, _i, _ref, _ref1;
      this.indented = {};
      this.indentEnd = {};
      this._pathBits = {};
      this.bounds = {};
      this.lineGroups = {};
      this.children = [];
      this.lineStart = state.line;
      head = this.block.start.next;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'text':
            this.children.push(head.paper.compute(state));
            this.group.push(head.paper.group);
            break;
          case 'blockStart':
            this.children.push(head.block.paper.compute(state));
            this.group.push(head.block.paper.group);
            head = head.block.end;
            break;
          case 'indentStart':
            indent = head.indent.paper.compute(state);
            this.children.push(indent);
            this.group.push(indent.group);
            head = head.indent.end;
            break;
          case 'socketStart':
            this.children.push(head.socket.paper.compute(state));
            this.group.push(head.socket.paper.group);
            head = head.socket.end;
            break;
          case 'newline':
            state.line += 1;
        }
        head = head.next;
      }
      this.lineEnd = state.line;
      i = 0;
      top = 0;
      axis = 0;
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        this._lineChildren[line] = [];
        this._pathBits[line] = {
          left: [],
          right: []
        };
        this.lineGroups[line] = new draw.Group();
        this.bounds[line] = new draw.NoRectangle();
        while (i < this.children.length && line > this.children[i].lineEnd) {
          i += 1;
        }
        while (i < this.children.length && line >= this.children[i].lineStart && line <= this.children[i].lineEnd) {
          this._lineChildren[line].push(this.children[i]);
          i += 1;
        }
        i -= 1;
        height = this._computeHeight(line);
        axis = top + height / 2;
        this.setLeftCenter(line, new draw.Point(0, axis));
        top += this.bounds[line].height;
      }
      return this;
    };

    BlockPaper.prototype._computeHeight = function(line) {
      var child, height, _heightModifier, _i, _len, _ref;
      height = 0;
      _heightModifier = 0;
      _ref = this._lineChildren[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        if (child.block.type === 'indent' && line === child.lineEnd) {
          height = Math.max(height, child.bounds[line].height + 10);
        } else {
          height = Math.max(height, child.bounds[line].height);
        }
      }
      if (this.indented[line] || this._lineChildren[line].length > 0 && this._lineChildren[line][0].block.type === 'indent') {
        height -= 2 * PADDING;
      }
      return height + 2 * PADDING;
    };

    BlockPaper.prototype.setLeftCenter = function(line, point) {
      var child, cursor, i, indentChild, topPoint, _bottomModifier, _i, _len, _ref;
      cursor = point.clone();
      cursor.add(PADDING, 0);
      this.lineGroups[line].empty();
      this._pathBits[line].left.length = 0;
      this._pathBits[line].right.length = 0;
      this.bounds[line].clear();
      this.bounds[line].swallow(point);
      _bottomModifier = 0;
      topPoint = null;
      this.indented[line] = this.indentEnd[line] = false;
      indentChild = null;
      _ref = this._lineChildren[line];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        child = _ref[i];
        if (i === 0 && child.block.type === 'indent') {
          this.indented[line] = true;
          this.indentEnd[line] = (line === child.lineEnd) || child.indentEnd[line];
          cursor.add(INDENT, 0);
          indentChild = child;
          child.setLeftCenter(line, new draw.Point(cursor.x, cursor.y - this._computeHeight(line) / 2 + child.bounds[line].height / 2));
          if (child.bounds[line].height === 0) {
            this._pathBits[line].right.push(topPoint = new draw.Point(child.bounds[line].x, child.bounds[line].y));
            this._pathBits[line].right.push(new draw.Point(child.bounds[line].x, child.bounds[line].y + 10));
            this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].y + 10));
            if (this._lineChildren[line].length > 1) {
              this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].y - 5 - PADDING));
            }
          } else {
            this._pathBits[line].right.push(topPoint = new draw.Point(child.bounds[line].x, child.bounds[line].y));
            this._pathBits[line].right.push(new draw.Point(child.bounds[line].x, child.bounds[line].bottom()));
            if (line === child.lineEnd && this._lineChildren[line].length > 1) {
              this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].bottom()));
              this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].y));
            }
          }
          if (child.lineEnd === line) {
            _bottomModifier += INDENT;
          }
        } else {
          this.indented[line] = this.indented[line] || (child.indented != null ? child.indented[line] : false);
          this.indentEnd[line] = this.indentEnd[line] || (child.indentEnd != null ? child.indentEnd[line] : false);
          if ((child.indentEnd != null) && child.indentEnd[line]) {
            child.setLeftCenter(line, new draw.Point(cursor.x, cursor.y - this._computeHeight(line) / 2 + child.bounds[line].height / 2));
          } else {
            child.setLeftCenter(line, cursor);
          }
        }
        this.lineGroups[line].push(child.lineGroups[line]);
        this.bounds[line].unite(child.bounds[line]);
        cursor.add(child.bounds[line].width, 0);
      }
      if (!this.indented[line]) {
        this.bounds[line].width += PADDING;
        this.bounds[line].y -= PADDING;
        this.bounds[line].height += PADDING * 2;
      }
      if (topPoint != null) {
        topPoint.y = this.bounds[line].y;
      }
      this._pathBits[line].left.push(new draw.Point(this.bounds[line].x, this.bounds[line].y));
      this._pathBits[line].left.push(new draw.Point(this.bounds[line].x, this.bounds[line].bottom() + _bottomModifier));
      if (this._lineChildren[line][0].block.type === 'indent' && this._lineChildren[line][0].lineStart === line) {
        child = this._lineChildren[line][0];
        this._pathBits[line].right.unshift(new draw.Point(this.bounds[line].x + INDENT + PADDING + 10, this.bounds[line].y));
        this._pathBits[line].right.unshift(new draw.Point(this.bounds[line].x + INDENT + PADDING + 10, this.bounds[line].y + 5));
        this._pathBits[line].right.unshift(new draw.Point(this.bounds[line].x + INDENT + PADDING + 30, this.bounds[line].y + 5));
        this._pathBits[line].right.unshift(new draw.Point(this.bounds[line].x + INDENT + PADDING + 30, this.bounds[line].y));
      }
      if (this.indentEnd[line] && this._lineChildren[line].length > 1) {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].y));
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
        return this.bounds[line].height += 10;
      } else if (this.indented[line] && !(this._lineChildren[line][0].block.type === 'indent' && this._lineChildren[line][0].lineEnd === line)) {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].y));
        return this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].bottom()));
      } else if (this._lineChildren[line][0].block.type === 'indent' && this._lineChildren[line][0].lineEnd === line) {
        if (this._lineChildren[line].length > 1) {
          this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].y));
          this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
        } else {
          this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom()));
          this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
        }
        return this.bounds[line].height += 10;
      } else {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].y));
        return this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
      }
    };

    BlockPaper.prototype.finish = function() {
      var bit, child, line, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
      this._container = new draw.Path();
      if (!this.block.inSocket()) {
        this._container.push(new draw.Point(this.bounds[this.lineStart].x + 10, this.bounds[this.lineStart].y));
        this._container.push(new draw.Point(this.bounds[this.lineStart].x + 10, this.bounds[this.lineStart].y + 5));
        this._container.push(new draw.Point(this.bounds[this.lineStart].x + 30, this.bounds[this.lineStart].y + 5));
      }
      for (line in this._pathBits) {
        _ref = this._pathBits[line].left;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          bit = _ref[_i];
          this._container.unshift(bit);
        }
        _ref1 = this._pathBits[line].right;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          bit = _ref1[_j];
          this._container.push(bit);
        }
      }
      if (!this.block.inSocket()) {
        this._container.unshift(new draw.Point(this.bounds[this.lineEnd].x + 10, this.bounds[this.lineEnd].bottom() + 5));
        this._container.unshift(new draw.Point(this.bounds[this.lineEnd].x + 30, this.bounds[this.lineEnd].bottom() + 5));
        this._container.unshift(new draw.Point(this.bounds[this.lineEnd].x + 30, this.bounds[this.lineEnd].bottom()));
      }
      this._container.style.strokeColor = this.block.selected ? '#FFF' : '#000';
      this._container.style.fillColor = this.block.color;
      this.dropArea = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - 5, this.bounds[this.lineEnd].width, 10);
      this.topCursorArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
      _ref2 = this.children;
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        child = _ref2[_k];
        _results.push(child.finish());
      }
      return _results;
    };

    BlockPaper.prototype.draw = function(ctx) {
      var child, _i, _len, _ref, _results;
      this._container.draw(ctx);
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.draw(ctx));
      }
      return _results;
    };

    BlockPaper.prototype.translate = function(vector) {
      var bit, child, line, point, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _ref3, _results;
      this.point.translate(vector);
      for (line in this.bounds) {
        this.lineGroups[line].translate(vector);
        this.bounds[line].translate(vector);
      }
      _ref = this._pathBits;
      for (line in _ref) {
        bit = _ref[line];
        _ref1 = bit.left;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          point = _ref1[_i];
          point.translate(vector);
        }
        _ref2 = bit.right;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          point = _ref2[_j];
          point.translate(vector);
        }
      }
      _ref3 = this.children;
      _results = [];
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        child = _ref3[_k];
        _results.push(child.translate(vector));
      }
      return _results;
    };

    return BlockPaper;

  })(IcePaper);

  SocketPaper = (function(_super) {
    __extends(SocketPaper, _super);

    function SocketPaper(block) {
      SocketPaper.__super__.constructor.call(this, block);
      this._empty = false;
      this._content = null;
      this._line = 0;
      this.indented = {};
      this.children = [];
    }

    SocketPaper.prototype.compute = function(state) {
      var contentPaper, line;
      this.bounds = {};
      this.lineGroups = {};
      this.group = new draw.Group();
      this.dropArea = null;
      if ((this._content = this.block.content()) != null) {
        (contentPaper = this._content.paper).compute(state);
        for (line in contentPaper.bounds) {
          if (this._content.type === 'text') {
            this._line = state.line;
            this.bounds[line] = new draw.NoRectangle();
            this.bounds[line].copy(contentPaper.bounds[line]);
            this.bounds[line].y -= PADDING;
            this.bounds[line].width += 2 * PADDING;
            this.bounds[line].x -= PADDING;
            this.bounds[line].height += 2 * PADDING;
            this.bounds[line].width = Math.max(this.bounds[line].width, 20);
            this.dropArea = this.bounds[line];
          } else {
            this.bounds[line] = contentPaper.bounds[line];
          }
          this.lineGroups[line] = contentPaper.lineGroups[line];
        }
        this.indented = this._content.paper.indented;
        this.indentEnd = this._content.paper.indentEnd;
        this.group = contentPaper.group;
        this.children = [this._content.paper];
        this.lineStart = contentPaper.lineStart;
        this.lineEnd = contentPaper.lineEnd;
      } else {
        this.dropArea = this.bounds[state.line] = new draw.Rectangle(0, 0, 20, 20);
        this.lineStart = this.lineEnd = this._line = state.line;
        this.children = [];
        this.indented = {};
        this.indented[this._line] = false;
        this.lineGroups[this._line] = new draw.Group();
      }
      this._empty = (this._content == null) || this._content.type === 'text';
      return this;
    };

    SocketPaper.prototype.setLeftCenter = function(line, point) {
      if (this._content != null) {
        if (this._content.type === 'text') {
          line = this._content.paper._line;
          this._content.paper.setLeftCenter(line, new draw.Point(point.x + PADDING, point.y));
          this.bounds[line].copy(this._content.paper.bounds[line]);
          this.bounds[line].y -= PADDING;
          this.bounds[line].width += 2 * PADDING;
          this.bounds[line].x -= PADDING;
          this.bounds[line].height += 2 * PADDING;
          this.bounds[line].width = Math.max(this.bounds[line].width, 20);
        } else {
          this._content.paper.setLeftCenter(line, point);
        }
        return this.lineGroups[line].recompute();
      } else {
        this.bounds[line].x = point.x;
        this.bounds[line].y = point.y - this.bounds[line].height / 2;
        return this.lineGroups[line].setPosition(new draw.Point(point.x, point.y - this.bounds[line].height / 2));
      }
    };

    SocketPaper.prototype.draw = function(ctx) {
      var line, rect;
      if (this._content != null) {
        if (this._content.type === 'text') {
          line = this._content.paper._line;
          ctx.strokeStyle = '#000';
          ctx.fillStyle = '#fff';
          ctx.fillRect(this.bounds[line].x, this.bounds[line].y, this.bounds[line].width, this.bounds[line].height);
          ctx.strokeRect(this.bounds[line].x, this.bounds[line].y, this.bounds[line].width, this.bounds[line].height);
        }
        return this._content.paper.draw(ctx);
      } else {
        rect = this.bounds[this._line];
        ctx.strokeStyle = '#000';
        ctx.fillStyle = '#fff';
        ctx.fillRect(rect.x, rect.y, rect.width, rect.height);
        return ctx.strokeRect(rect.x, rect.y, rect.width, rect.height);
      }
    };

    SocketPaper.prototype.translate = function(vector) {
      var line;
      if (this._content != null) {
        this._content.paper.translate(vector);
        if (this._content.type === 'text') {
          line = this._content.paper._line;
          this.bounds[line].copy(this._content.paper.bounds[line]);
          this.bounds[line].y -= PADDING;
          this.bounds[line].width += 2 * PADDING;
          this.bounds[line].x -= PADDING;
          this.bounds[line].height += 2 * PADDING;
          return this.bounds[line].width = Math.max(this.bounds[line].width, 20);
        }
      } else {
        return this.bounds[this._line].translate(vector);
      }
    };

    return SocketPaper;

  })(IcePaper);

  CursorTokenPaper = (function(_super) {
    __extends(CursorTokenPaper, _super);

    function CursorTokenPaper(block) {
      CursorTokenPaper.__super__.constructor.call(this, block);
      this._rect = new draw.NoRectangle();
    }

    CursorTokenPaper.prototype.compute = function(state) {
      this.lineStart = this.lineEnd = state.line;
      return this;
    };

    CursorTokenPaper.prototype.setRect = function(rect) {
      this._rect = rect;
      return this.useTop = false;
    };

    CursorTokenPaper.prototype.setRectTop = function(rect) {
      this._rect = rect;
      return this.useTop = true;
    };

    CursorTokenPaper.prototype.finish = function() {};

    CursorTokenPaper.prototype.draw = function(ctx) {
      var _this = this;
      return setTimeout((function() {
        var y;
        ctx.strokeStyle = '#000';
        ctx.fillStyle = '#FFF';
        y = _this.useTop ? _this._rect.y : _this._rect.bottom();
        ctx.beginPath();
        ctx.moveTo(_this._rect.x, y);
        ctx.lineTo(_this._rect.x - 5, y + 5);
        ctx.lineTo(_this._rect.x - 5, y - 5);
        ctx.lineTo(_this._rect.x, y);
        ctx.lineTo(_this._rect.x + _this._rect.width, y);
        ctx.lineTo(_this._rect.x + _this._rect.width + 5, y - 5);
        ctx.lineTo(_this._rect.x + _this._rect.width + 5, y + 5);
        ctx.lineTo(_this._rect.x + _this._rect.width, y);
        ctx.stroke();
        return ctx.fill();
      }), 0);
    };

    return CursorTokenPaper;

  })(IcePaper);

  IndentPaper = (function(_super) {
    __extends(IndentPaper, _super);

    function IndentPaper(block) {
      IndentPaper.__super__.constructor.call(this, block);
      this._lineBlocks = {};
    }

    IndentPaper.prototype.compute = function(state) {
      var head, i, line, setCursor, _i, _ref, _ref1;
      this.bounds = {};
      this.lineGroups = {};
      this._lineBlocks = {};
      this.indentEnd = {};
      this.group = new draw.Group();
      this.children = [];
      this.lineStart = state.line += 1;
      head = this.block.start.next;
      if (head.type === 'cursor') {
        head = head.next;
      }
      if (head.type === 'newline') {
        head = head.next;
      }
      if (this.block.start.next === this.block.end) {
        head = this.block.end;
      }
      while (head !== this.block.end) {
        switch (head.type) {
          case 'blockStart':
            this.children.push(head.block.paper.compute(state));
            this.group.push(head.block.paper.group);
            head = head.block.end;
            break;
          case 'cursor':
            this.children.push(head.paper.compute(state));
            this.group.push(head.paper.group);
            break;
          case 'newline':
            state.line += 1;
        }
        head = head.next;
      }
      this.lineEnd = state.line;
      if (this.children.length > 0) {
        i = 0;
        for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
          while (!(line <= this.children[i].lineEnd)) {
            i += 1;
          }
          setCursor = false;
          if ((this.children[i] != null) && this.children[i].block.type === 'cursor') {
            setCursor = true;
            i += 1;
          }
          this.bounds[line] = this.children[i].bounds[line];
          this.lineGroups[line] = new draw.Group();
          this.indentEnd[line] = this.children[i].indentEnd[line];
          this.lineGroups[line].push(this.children[i].lineGroups[line]);
          this._lineBlocks[line] = this.children[i];
          if (setCursor) {
            this.children[i - 1].setRectTop(this.bounds[line]);
          } else if ((this.children[i + 1] != null) && this.children[i + 1].block.type === 'cursor') {
            this.children[i + 1].setRect(this.bounds[line]);
          }
        }
      } else {
        this.lineGroups[this.lineStart] = new draw.Group();
        this._lineBlocks[this.lineStart] = null;
        this.bounds[this.lineStart] = new draw.Rectangle(0, 0, EMPTY_INDENT_WIDTH, 0);
      }
      return this;
    };

    IndentPaper.prototype.finish = function() {
      var child, _i, _len, _ref, _results;
      this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, Math.max(this.bounds[this.lineStart].width, MIN_INDENT_DROP_WIDTH), 10);
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.finish());
      }
      return _results;
    };

    IndentPaper.prototype.setLeftCenter = function(line, point) {
      if (this._lineBlocks[line] != null) {
        this._lineBlocks[line].setLeftCenter(line, point);
        return this.lineGroups[line].recompute();
      } else {
        this.bounds[this.lineStart].clear();
        this.bounds[this.lineStart].swallow(point);
        return this.bounds[this.lineStart].width = EMPTY_INDENT_WIDTH;
      }
    };

    IndentPaper.prototype.draw = function(ctx) {
      var child, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.draw(ctx));
      }
      return _results;
    };

    IndentPaper.prototype.translate = function(vector) {
      var child, _i, _len, _ref, _results;
      this.point.add(vector);
      if (this.bounds[this.lineStart].height === 0) {
        this.bounds[this.lineStart].translate(vector);
      }
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.translate(vector));
      }
      return _results;
    };

    IndentPaper.prototype.setPosition = function(point) {
      return this.translate(point.from(this.point));
    };

    return IndentPaper;

  })(IcePaper);

  SegmentPaper = (function(_super) {
    __extends(SegmentPaper, _super);

    function SegmentPaper(block) {
      SegmentPaper.__super__.constructor.call(this, block);
      this._lineBlocks = {};
    }

    SegmentPaper.prototype.compute = function(state) {
      var head, i, line, running_height, _i, _ref, _ref1;
      this.bounds = {};
      this.lineGroups = {};
      this._lineBlocks = {};
      this.indentEnd = {};
      this.group = new draw.Group();
      this.children = [];
      this.lineStart = state.line += 1;
      head = this.block.start.next;
      if (this.block.start.next === this.block.end) {
        head = this.block.end;
      }
      running_height = 0;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'blockStart':
            this.children.push(head.block.paper.compute(state));
            head.block.paper.translate(new draw.Point(0, running_height));
            running_height = head.block.paper.bounds[head.block.paper.lineEnd].bottom();
            this.group.push(head.block.paper.group);
            head = head.block.end;
            break;
          case 'cursor':
            this.children.push(head.paper.compute(state));
            if (this.children.length > 2) {
              head.paper.setRect(new draw.Rectangle(0, running_height, this.children[this.children.length - 2].bounds[this.children[this.children.length - 2].lineEnd].width, 0));
            } else {
              head.paper.setRect(new draw.Rectangle(0, running_height, DEFAULT_CURSOR_WIDTH, 0));
            }
            this.group.push(head.paper.group);
            break;
          case 'newline':
            state.line += 1;
        }
        head = head.next;
      }
      this.lineEnd = state.line;
      if (this.children.length === 0) {
        this.bounds[state.line] = new draw.Rectangle(0, 0, 0, 0);
        return this;
      }
      i = 0;
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        while (!(line <= this.children[i].lineEnd && this.children[i].block.type !== 'cursor')) {
          i += 1;
        }
        this.bounds[line] = this.children[i].bounds[line];
        this.lineGroups[line] = new draw.Group();
        this.indentEnd[line] = this.children[i].indentEnd[line];
        this.lineGroups[line].push(this.children[i].lineGroups[line]);
        this._lineBlocks[line] = this.children[i];
      }
      return this;
    };

    SegmentPaper.prototype.prepBounds = function() {
      var head, i, line, running_height, _i, _ref, _ref1;
      this.bounds = {};
      this.lineGroups = {};
      this._lineBlocks = {};
      this.indentEnd = {};
      this.group = new draw.Group();
      this.children = [];
      this.lineStart = Infinity;
      this.lineEnd = 0;
      head = this.block.start.next;
      if (this.block.start.next === this.block.end) {
        head = this.block.end;
      }
      running_height = 0;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'blockStart':
            this.children.push(head.block.paper);
            this.lineStart = Math.min(this.lineStart, head.block.paper.lineStart);
            this.lineEnd = Math.max(this.lineEnd, head.block.paper.lineEnd);
            head = head.block.end;
        }
        head = head.next;
      }
      i = 0;
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        while (!(line <= this.children[i].lineEnd)) {
          i += 1;
        }
        this.bounds[line] = this.children[i].bounds[line];
      }
      return this;
    };

    SegmentPaper.prototype.getBounds = function() {
      var bounds, head;
      head = this.block.start.next;
      if (this.block.start.next === this.block.end) {
        head = this.block.end;
      }
      bounds = new draw.NoRectangle();
      while (head !== this.block.end) {
        switch (head.type) {
          case 'blockStart':
            bounds.unite(head.block.paper._container.bounds());
        }
        head = head.next;
      }
      return bounds;
    };

    SegmentPaper.prototype.finish = function() {
      var child, _i, _len, _ref, _results;
      this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, Math.max(this.bounds[this.lineStart].width, MIN_INDENT_DROP_WIDTH), 10);
      if (this.bounds[this.lineStart].width === 0) {
        this.dropArea.width = EMPTY_SEGMENT_DROP_WIDTH;
      }
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.finish());
      }
      return _results;
    };

    SegmentPaper.prototype.setLeftCenter = function(line, point) {
      if (this._lineBlocks[line] != null) {
        this._lineBlocks[line].setLeftCenter(line, point);
        return this.lineGroups[line].recompute();
      } else {
        this.bounds[this.lineStart].clear();
        this.bounds[this.lineStart].swallow(point);
        return this.bounds[this.lineStart].width = EMPTY_INDENT_WIDTH;
      }
    };

    SegmentPaper.prototype.draw = function(ctx) {
      var child, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.draw(ctx));
      }
      return _results;
    };

    SegmentPaper.prototype.translate = function(vector) {
      var child, _i, _len, _ref, _results;
      this.point.add(vector);
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.translate(vector));
      }
      return _results;
    };

    SegmentPaper.prototype.setPosition = function(point) {
      return this.translate(point.from(this.point));
    };

    return SegmentPaper;

  })(IcePaper);

  TextTokenPaper = (function(_super) {
    __extends(TextTokenPaper, _super);

    function TextTokenPaper(block) {
      TextTokenPaper.__super__.constructor.call(this, block);
      this._line = 0;
    }

    TextTokenPaper.prototype.compute = function(state) {
      this.lineStart = this.lineEnd = this._line = state.line;
      this.lineGroups = {};
      this.bounds = {};
      this.group = this.lineGroups[this._line] = new draw.Group();
      this.lineGroups[this._line].push(this._text = new draw.Text(new draw.Point(0, 0), this.block.value));
      this.bounds[this._line] = this._text.bounds();
      return this;
    };

    TextTokenPaper.prototype.draw = function(ctx) {
      return this._text.draw(ctx);
    };

    TextTokenPaper.prototype.setLeftCenter = function(line, point) {
      if (line === this._line) {
        this._text.setPosition(new draw.Point(point.x, point.y - this.bounds[this._line].height / 2));
        return this.lineGroups[this._line].recompute();
      }
    };

    TextTokenPaper.prototype.translate = function(vector) {
      return this._text.translate(vector);
    };

    return TextTokenPaper;

  })(IcePaper);

  INDENT_SPACES = 2;

  INPUT_LINE_HEIGHT = 15;

  PALETTE_MARGIN = 10;

  exports.Editor = Editor = (function() {
    function Editor(el, paletteBlocks) {
      var child, deleteFromCursor, drag, dragCtx, eventName, getPointFromEvent, getRectFromPoints, highlight, hitTest, hitTestFloating, hitTestFocus, hitTestLasso, hitTestPalette, hitTestRoot, insertHandwrittenBlock, main, mainCtx, moveCursorBefore, moveCursorDown, moveCursorTo, moveCursorUp, offset, palette, paletteBlock, paletteCtx, redrawTextInput, setTextInputAnchor, setTextInputFocus, setTextInputHead, textInputAnchor, textInputHead, textInputSelecting, track, _editedInputLine, _i, _j, _len, _len1, _ref, _ref1,
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
        var float, paper, _j, _len1, _ref1, _results;
        _this.clear();
        _this.tree.paper.compute({
          line: 0
        });
        _this.tree.paper.finish();
        _this.tree.paper.draw(mainCtx);
        if (_this.lassoSegment != null) {
          _this.lassoSegment.paper.prepBounds();
          if (_this.lassoSegment !== _this.selection) {
            (_this._lassoBounds = _this.lassoSegment.paper.getBounds()).stroke(mainCtx, '#000');
            _this._lassoBounds.fill(mainCtx, 'rgba(0, 0, 256, 0.3)');
          }
        }
        _ref1 = _this.floatingBlocks;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          float = _ref1[_j];
          paper = float.block.paper;
          paper.compute({
            line: 0
          });
          paper.translate(float.position);
          paper.finish();
          _results.push(paper.draw(mainCtx));
        }
        return _results;
      };
      this.attemptReparse = function() {
        try {
          _this.tree = (coffee.parse(_this.getValue())).segment;
          return _this.redraw();
        } catch (_error) {}
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
          paletteBlock.paper.compute({
            line: 0
          });
          paletteBlock.paper.translate(new draw.Point(0, lastBottomEdge));
          lastBottomEdge = paletteBlock.paper.bounds[paletteBlock.paper.lineEnd].bottom() + PALETTE_MARGIN;
          paletteBlock.paper.finish();
          _results.push(paletteBlock.paper.draw(paletteCtx));
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
          newBlock._moveTo(_this.cursor.prev.insert(new NewlineToken()));
          _this.redraw();
          return setTextInputFocus(newSocket);
        } else if (_this.cursor.prev.type === 'newline') {
          newBlock._moveTo(_this.cursor.prev);
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
          head.block._moveTo(null);
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
                _this.focus.start.prev.block._moveTo(head.prev.prev.insert(new NewlineToken()));
                moveCursorTo(_this.focus.start.prev.block.end);
                _this.redraw();
                event.preventDefault();
                return false;
              } else {
                newIndent = new Indent([], INDENT_SPACES);
                head.prev.insert(newIndent.start);
                head.prev.insert(newIndent.end);
                _this.focus.start.prev.block._moveTo(newIndent.start.insert(new NewlineToken()));
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
          if (head.type === 'blockStart' && head.block.paper._container.contains(point)) {
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
          if (head.type === 'socketStart' && (head.next.type === 'text' || head.next.type === 'socketEnd') && head.socket.paper.bounds[head.socket.paper._line].contains(point)) {
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
        var fixedDest, float, i, point, rect, selectionInPalette, _k, _len2, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
        point = getPointFromEvent(event);
        _this.selection = (_ref2 = (_ref3 = (_ref4 = (_ref5 = hitTestFloating(point)) != null ? _ref5 : hitTestLasso(point)) != null ? _ref4 : hitTestFocus(point)) != null ? _ref3 : hitTestRoot(point)) != null ? _ref2 : hitTestPalette(point);
        if (_this.selection == null) {
          /*
          # If we haven't clicked on any clickable element, then LASSO SELECT, indicated by (@lassoAnchor?)
          */

          if (_this.lassoSegment != null) {
            _this.lassoSegment.remove();
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
          if (_ref6 = _this.selection, __indexOf.call(_this.paletteBlocks, _ref6) >= 0) {
            point.add(PALETTE_WIDTH, 0);
            selectionInPalette = true;
          }
          rect = _this.selection.paper.bounds[_this.selection.paper.lineStart];
          offset = point.from(new draw.Point(rect.x, rect.y));
          if (selectionInPalette) {
            _this.selection = _this.selection.clone();
          }
          _ref7 = _this.floatingBlocks;
          for (i = _k = 0, _len2 = _ref7.length; _k < _len2; i = ++_k) {
            float = _ref7[i];
            if (float.block === _this.selection) {
              _this.floatingBlocks.splice(i, 1);
              break;
            }
          }
          _this.selection._moveTo(null);
          _this.selection.paper.compute({
            line: 0
          });
          _this.selection.paper.finish();
          _this.selection.paper.draw(dragCtx);
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
            return (!((_ref2 = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref2 : false)) && (block.paper.dropArea != null) && block.paper.dropArea.contains(dest);
          });
          if (old_highlight !== highlight) {
            _this.redraw();
          }
          if (highlight != null) {
            highlight.paper.dropArea.fill(mainCtx, '#fff');
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
                _this.selection._moveTo(highlight.start.insert(new NewlineToken()));
                break;
              case 'block':
                _this.selection._moveTo(highlight.end.insert(new NewlineToken()));
                break;
              case 'socket':
                if (highlight.content() != null) {
                  highlight.content().remove();
                }
                _this.selection._moveTo(highlight.start);
                break;
              default:
                if (highlight === _this.tree) {
                  _this.selection._moveTo(_this.tree.start);
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
            if (head.type === 'blockStart' && head.block.paper._container.intersects(rect)) {
              firstLassoed = head;
              break;
            }
            head = head.next;
          }
          head = _this.tree.end;
          lastLassoed = null;
          while (head !== _this.tree.start) {
            if (head.type === 'blockEnd' && head.block.paper._container.intersects(rect)) {
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
        start = _this.editedText.paper.bounds[_editedInputLine].x + mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionStart)).width;
        end = _this.editedText.paper.bounds[_editedInputLine].x + mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionEnd)).width;
        if (start === end) {
          return mainCtx.strokeRect(start, _this.editedText.paper.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT);
        } else {
          mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3';
          return mainCtx.fillRect(start, _this.editedText.paper.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT);
        }
      };
      setTextInputFocus = function(focus) {
        var depth, head;
        _this.focus = focus;
        if (_this.focus === null) {
          return;
        }
        _editedInputLine = _this.focus.paper._line;
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
        textInputHead = Math.round((point.x - _this.focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width);
        return _this.hiddenInput.setSelectionRange(Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead));
      };
      setTextInputAnchor = function(point) {
        textInputAnchor = textInputHead = Math.round((point.x - _this.focus.paper.bounds[_editedInputLine].x) / mainCtx.measureText(' ').width);
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
    return editor.setValue('for i in [1..10]\n  if i % 2 is 0\n    alert i\n    alert \'bye\'\n  else\n    alert \'fizz\'\n  alert \'buzz\'');
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/