/*
# Copyright (c) 2014 Anthony Bau.
# MIT License.
#
# Tree classes and operations for ICE editor.
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, DROP_AREA_MAX_WIDTH, EMPTY_INDENT_WIDTH, EMPTY_SEGMENT_DROP_WIDTH, Editor, FONT_SIZE, INDENT, IcePaper, Indent, IndentEndToken, IndentPaper, IndentStartToken, MIN_INDENT_DROP_WIDTH, MOUTH_BOTTOM, NewlineToken, PADDING, PALETTE_WHITESPACE, PALETTE_WIDTH, Segment, SegmentEndToken, SegmentPaper, SegmentStartToken, Socket, SocketEndToken, SocketPaper, SocketStartToken, TextToken, TextTokenPaper, Token, exports, out,
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
            cursor = cursor.append(head.clone());
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
        console.log('removing a segment');
        this.start.prev.segment.remove();
      }
      if ((this.end.next != null) && (this.start.prev != null)) {
        last = this.end.next;
        while ((last != null) && last.type === 'segmentEnd') {
          last = last.next;
        }
        first = this.start.prev;
        while ((first != null) && first.type === 'segmentStart') {
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
            cursor = cursor.append(head.clone());
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
            cursor = cursor.append(head.clone());
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
        console.log('removing a segment');
        this.start.prev.segment.remove();
      }
      if ((this.end.next != null) && (this.start.prev != null)) {
        last = this.end.next;
        while ((last != null) && last.type === 'segmentEnd') {
          last = last.next;
        }
        first = this.start.prev;
        while ((first != null) && first.type === 'segmentStart') {
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
      this._container.style.strokeColor = '#000';
      this._container.style.fillColor = this.block.color;
      this.dropArea = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - 5, this.bounds[this.lineEnd].width, 10);
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

  IndentPaper = (function(_super) {
    __extends(IndentPaper, _super);

    function IndentPaper(block) {
      IndentPaper.__super__.constructor.call(this, block);
      this._lineBlocks = {};
    }

    IndentPaper.prototype.compute = function(state) {
      var head, i, line, _i, _ref, _ref1;
      this.bounds = {};
      this.lineGroups = {};
      this._lineBlocks = {};
      this.indentEnd = {};
      this.group = new draw.Group();
      this.children = [];
      this.lineStart = state.line += 1;
      head = this.block.start.next.next;
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
          this.bounds[line] = this.children[i].bounds[line];
          this.lineGroups[line] = new draw.Group();
          this.indentEnd[line] = this.children[i].indentEnd[line];
          this.lineGroups[line].push(this.children[i].lineGroups[line]);
          this._lineBlocks[line] = this.children[i];
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
        while (!(line <= this.children[i].lineEnd)) {
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

  /*
  # Controller (user-interaction) code for ICE editor.
  #
  # Copyright (c) 2014 Anthony Bau
  # MIT License
  */


  out = null;

  exports.Editor = Editor = (function() {
    function Editor(el) {
      var anchor, block, canvas, clear, ctx, div, dragCanvas, dragCtx, fastDraw, floating_blocks, focus, head, highlight, input, lassoAnchor, lassoBounds, lassoHead, lassoSegment, offset, paletteCanvas, paletteCtx, palette_blocks, redraw, reparse, running_height, scrollOffset, selection, setFocus, tree, _i, _len;
      canvas = document.createElement('canvas');
      canvas.className = 'canvas';
      canvas.height = el.offsetHeight;
      canvas.width = el.offsetWidth - PALETTE_WIDTH;
      paletteCanvas = document.createElement('canvas');
      paletteCanvas.className = 'palette';
      paletteCanvas.height = el.offsetHeight;
      paletteCanvas.width = PALETTE_WIDTH;
      dragCanvas = document.createElement('canvas');
      dragCanvas.className = 'drag';
      dragCanvas.height = el.offsetHeight;
      dragCanvas.width = el.offsetWidth - PALETTE_WIDTH;
      div = document.createElement('div');
      div.className = 'trackArea';
      el.appendChild(canvas);
      el.appendChild(dragCanvas);
      el.appendChild(paletteCanvas);
      el.appendChild(div);
      ctx = canvas.getContext('2d');
      dragCtx = dragCanvas.getContext('2d');
      paletteCtx = paletteCanvas.getContext('2d');
      draw._setCTX(ctx);
      tree = coffee.parse('window.onload = ->\n  if document.getElementsByClassName(\'test\').length > 0\n    for [1..10]\n      document.body.appendChild document.createElement \'script\'\n    alert \'found a test element\'\n  document.getElementsByTagName(\'button\').onclick = ->\n    alert \'somebody clicked a button\'');
      /*
      # Dragging
      */

      scrollOffset = new draw.Point(0, 0);
      highlight = null;
      selection = null;
      offset = null;
      /*
      # Hidden input hack
      */

      input = null;
      focus = null;
      anchor = head = null;
      /*
      # Lasso select
      */

      lassoAnchor = null;
      lassoHead = null;
      lassoSegment = null;
      lassoBounds = null;
      floating_blocks = [];
      clear = function() {
        return ctx.clearRect(scrollOffset.x, scrollOffset.y, canvas.width, canvas.height);
      };
      redraw = function() {
        var block, _i, _len;
        clear();
        tree.segment.paper.compute({
          line: 0
        });
        tree.segment.paper.finish();
        tree.segment.paper.draw(ctx);
        out.value = tree.segment.toString({
          indent: ''
        });
        if (lassoSegment != null) {
          lassoSegment.paper.prepBounds();
        }
        for (_i = 0, _len = floating_blocks.length; _i < _len; _i++) {
          block = floating_blocks[_i];
          block.block.paper.compute({
            line: 0
          });
          block.block.paper.translate(block.position);
          block.block.paper.finish();
          block.block.paper.draw(ctx);
        }
        if (lassoSegment != null) {
          if (lassoSegment !== selection) {
            (lassoBounds = lassoSegment.paper.getBounds()).stroke(ctx, '#000');
            return lassoBounds.fill(ctx, 'rgba(0, 0, 256, 0.3)');
          }
        }
      };
      reparse = function() {
        try {
          tree = coffee.parse(tree.segment.toString());
        } catch (_error) {}
        return redraw();
      };
      fastDraw = function() {
        var block, _i, _len;
        clear();
        tree.segment.paper.draw(ctx);
        for (_i = 0, _len = floating_blocks.length; _i < _len; _i++) {
          block = floating_blocks[_i];
          block.block.paper.draw(ctx);
        }
        if (lassoSegment != null) {
          if (lassoSegment !== selection) {
            lassoBounds.stroke(ctx, '#000');
            return lassoBounds.fill(ctx, 'rgba(0, 0, 256, 0.3)');
          }
        }
      };
      setFocus = function(focus, point) {
        var line, start, text, _removed;
        console.log('setting');
        if (focus.content() != null) {
          text = focus.content();
        } else {
          focus.start.insert(text = new TextToken(''));
        }
        if (input != null) {
          input.parentNode.removeChild(input);
        }
        _removed = false;
        document.body.appendChild(input = document.createElement('input'));
        input.className = 'hidden_input';
        line = focus.paper._line;
        input.value = focus.content().value;
        if (point != null) {
          anchor = head = Math.round((start = point.x - focus.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width);
        }
        redraw();
        input.addEventListener('input', input.onkeydown = input.onkeyup = input.onkeypress = function(event) {
          var end, newBlock, newSocket, old_bounds;
          if (_removed) {
            return;
          }
          console.log(focus.handwritten);
          if (focus.handwritten && event.type === 'keydown') {
            switch (event.keyCode) {
              case 13:
                newBlock = new Block([]);
                newSocket = new Socket([]);
                newSocket.handwritten = true;
                newBlock.start.insert(newSocket.start);
                newBlock.end.prev.insert(newSocket.end);
                newBlock._moveTo(focus.end.next.insert(new NewlineToken()));
                focus = newSocket;
                redraw();
                redraw();
                setFocus(newSocket);
                _removed = true;
                return;
            }
          }
          text.value = this.value;
          text.paper.compute({
            line: line
          });
          focus.paper.compute({
            line: line
          });
          old_bounds = tree.segment.paper.bounds[line].y;
          tree.segment.paper.setLeftCenter(line, new draw.Point(0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2));
          if (tree.segment.paper.bounds[line].y !== old_bounds) {
            tree.segment.paper.setLeftCenter(line, new draw.Point(0, tree.segment.paper.bounds[line].y + tree.segment.paper.bounds[line].height / 2 - 1));
          }
          tree.segment.paper.finish();
          fastDraw();
          out.value = tree.segment.toString({
            indent: ''
          });
          start = text.paper.bounds[line].x + ctx.measureText(this.value.slice(0, this.selectionStart)).width;
          end = text.paper.bounds[line].x + ctx.measureText(this.value.slice(0, this.selectionEnd)).width;
          if (start === end) {
            return ctx.strokeRect(start, text.paper.bounds[line].y, 0, 15);
          } else {
            ctx.fillStyle = 'rgba(0, 0, 256, 0.3)';
            return ctx.fillRect(start, text.paper.bounds[line].y, end - start, 15);
          }
        });
        return setTimeout((function() {
          input.focus();
          input.setSelectionRange(anchor, anchor);
          return input.dispatchEvent(new CustomEvent('input'));
        }), 0);
      };
      redraw();
      /*
      # Here to below will eventually become part of the IceEditor() class
      */

      div.addEventListener('touchstart', div.onmousedown = function(event) {
        var block, bounds, clicked, cloneLater, handInsert, i, newBlock, newSocket, pickedLasso, point, shiftedPoint, _i, _j, _len, _len1;
        if (event.offsetX != null) {
          point = new draw.Point(event.offsetX, event.offsetY);
        } else {
          point = new draw.Point(event.layerX, event.layerY);
        }
        point.add(-PALETTE_WIDTH, 0);
        point.translate(scrollOffset);
        pickedLasso = handInsert = false;
        if ((lassoSegment != null) && lassoBounds.contains(point)) {
          selection = lassoSegment;
          pickedLasso = true;
        }
        if (!pickedLasso) {
          clicked = tree.segment.find(function(block) {
            var _ref, _ref1;
            return (((_ref = block.type) === 'indent' || _ref === 'block') && !((_ref1 = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref1 : false)) && (block.paper.dropArea != null) && block.paper.dropArea.contains(point);
          });
          if (clicked != null) {
            newBlock = new Block([]);
            newSocket = new Socket([]);
            newSocket.handwritten = true;
            newBlock.start.insert(newSocket.start);
            newBlock.end.prev.insert(newSocket.end);
            if (clicked.type === 'indent') {
              newBlock._moveTo(clicked.start.insert(new NewlineToken()));
            } else if (clicked.type === 'block') {
              newBlock._moveTo(clicked.end.insert(new NewlineToken()));
            }
            focus = newSocket;
            handInsert = true;
            redraw();
          }
        }
        if (!pickedLasso && !handInsert) {
          focus = tree.segment.findSocket(function(block) {
            return block.paper._empty && block.paper.bounds[block.paper._line].contains(point);
          });
          if (focus == null) {
            if (lassoSegment != null) {
              if (lassoSegment.start.prev != null) {
                lassoSegment.remove();
              }
              lassoSegment = null;
            }
            for (i = _i = 0, _len = floating_blocks.length; _i < _len; i = ++_i) {
              block = floating_blocks[i];
              if (block.block.findBlock(function(x) {
                return x.paper._container.contains(point);
              }) != null) {
                floating_blocks.splice(i, 1);
                selection = block.block;
                break;
              } else {
                selection = null;
              }
            }
            console.log('found selection', selection);
            if (selection == null) {
              console.log('looking for block inside tree');
              selection = tree.segment.findBlock(function(block) {
                return block.paper._container.contains(point);
              });
              cloneLater = false;
              if (selection == null) {
                shiftedPoint = new draw.Point(point.x + PALETTE_WIDTH, point.y);
                shiftedPoint.add(-scrollOffset.x, -scrollOffset.y);
                for (_j = 0, _len1 = palette_blocks.length; _j < _len1; _j++) {
                  block = palette_blocks[_j];
                  if (block.findBlock(function(x) {
                    return x.paper._container.contains(shiftedPoint);
                  }) != null) {
                    selection = block;
                    cloneLater = true;
                    break;
                  } else {
                    selection = null;
                  }
                }
              }
            }
          }
        } else if (!handInsert) {
          focus = null;
        }
        if ((focus != null) && !pickedLasso) {
          setFocus(focus, point);
        } else if (selection != null) {
          /* 
          # We've now found the selected text, move it as necessary.
          */

          console.log('selection exists');
          if ((selection.start.prev != null) && selection.start.prev.type === 'newline') {
            selection.start.prev.remove();
          }
          bounds = selection.paper.bounds[selection.paper.lineStart];
          if (cloneLater) {
            offset = shiftedPoint.from(new draw.Point(bounds.x, bounds.y));
          } else {
            offset = point.from(new draw.Point(bounds.x, bounds.y));
          }
          if (cloneLater) {
            selection = selection.clone();
          } else {
            selection._moveTo(null);
          }
          redraw();
          selection.paper.compute({
            line: 0
          });
          selection.paper.finish();
          selection.paper.draw(dragCtx);
          if (selection === lassoSegment) {
            lassoSegment.paper.prepBounds();
            (lassoBounds = lassoSegment.paper.getBounds()).stroke(dragCtx, '#000');
            lassoBounds.fill(dragCtx, 'rgba(0, 0, 256, 0.3)');
          }
          div.onmousemove(event);
        } else {
          console.log('doing a lasso select', pickedLasso, handInsert);
          lassoAnchor = lassoHead = point;
          dragCanvas.style.webkitTransform = "translate(0px, 0px)";
          dragCanvas.style.mozTransform = "translate(0px, 0px)";
          dragCanvas.style.transform = "translate(0px, 0px)";
          document.body.style.opacity = 1 - Math.random() * 1e-10;
        }
        return redraw();
      });
      div.addEventListener('touchmove', div.onmousemove = function(event) {
        var bounds, corner, dest, end, line, old_highlight, point, scrollDest, size, start, text;
        if (event.offsetX != null) {
          point = new draw.Point(event.offsetX, event.offsetY);
        } else {
          point = new draw.Point(event.layerX, event.layerY);
        }
        point.add(-PALETTE_WIDTH, 0);
        if (selection != null) {
          scrollDest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          point.translate(scrollOffset);
          dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
          old_highlight = highlight;
          highlight = tree.segment.find(function(block) {
            var _ref;
            return (!((_ref = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref : false)) && (block.paper.dropArea != null) && block.paper.dropArea.contains(dest);
          });
          if (highlight !== old_highlight || window.PERFORMANCE_TEST) {
            fastDraw();
            if (highlight != null) {
              highlight.paper.dropArea.fill(ctx, '#fff');
            }
          }
          dragCanvas.style.webkitTransform = "translate(" + scrollDest.x + "px, " + scrollDest.y + "px)";
          dragCanvas.style.mozTransform = "translate(" + scrollDest.x + "px, " + scrollDest.y + "px)";
          dragCanvas.style.transform = "translate(" + scrollDest.x + "px, " + scrollDest.y + "px)";
          document.body.style.opacity = 1 - Math.random() * 1e-10;
          return event.preventDefault();
        } else if ((focus != null) && (anchor != null)) {
          text = focus.content();
          line = text.paper._line;
          head = Math.round((point.x - text.paper.bounds[focus.paper._line].x) / ctx.measureText(' ').width);
          bounds = text.paper.bounds[line];
          ctx.clearRect(bounds.x, bounds.y, bounds.width, bounds.height);
          text.paper.draw(ctx);
          start = text.paper.bounds[line].x + ctx.measureText(text.value.slice(0, head)).width;
          end = text.paper.bounds[line].x + ctx.measureText(text.value.slice(0, anchor)).width;
          if (start === end) {
            return ctx.strokeRect(start, text.paper.bounds[line].y, 0, 15);
          } else {
            ctx.fillStyle = 'rgba(0, 0, 256, 0.3)';
            return ctx.fillRect(start, text.paper.bounds[line].y, end - start, 15);
          }
        } else if (lassoAnchor != null) {
          dragCtx.clearRect(0, 0, dragCanvas.width, dragCanvas.height);
          dragCtx.strokeStyle = '#00f';
          lassoHead = point;
          point.translate(scrollOffset);
          corner = {
            x: Math.min(lassoAnchor.x, point.x),
            y: Math.min(lassoAnchor.y, point.y)
          };
          size = {
            width: Math.abs(lassoAnchor.x - point.x),
            height: Math.abs(lassoAnchor.y - point.y)
          };
          return dragCtx.strokeRect(corner.x - scrollOffset.x, corner.y - scrollOffset.y, size.width, size.height);
        }
      });
      div.addEventListener('touchend', div.onmouseup = function(event) {
        var corner, dest, firstLassoed, lassoRect, lastLassoed, point, size, stack, _head, _ref, _stack;
        if (selection != null) {
          if (highlight != null) {
            switch (highlight.type) {
              case 'indent':
                selection._moveTo(highlight.start.insert(new NewlineToken()));
                break;
              case 'block':
                selection._moveTo(highlight.end.insert(new NewlineToken()));
                break;
              case 'socket':
                if (highlight.content() != null) {
                  highlight.content().remove();
                }
                selection._moveTo(highlight.start);
            }
            if (highlight === tree.segment) {
              selection._moveTo(highlight.start);
              selection.end.insert(new NewlineToken());
            }
            redraw();
          } else {
            if (event.offsetX != null) {
              point = new draw.Point(event.offsetX, event.offsetY);
            } else {
              point = new draw.Point(event.layerX, event.layerY);
            }
            point.add(-PALETTE_WIDTH, 0);
            point.translate(scrollOffset);
            dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
            if (dest.x > 0) {
              selection.paper.compute({
                line: 0
              });
              selection.paper.translate(dest);
              selection.paper.finish();
              selection.paper.draw(ctx);
              floating_blocks.push({
                block: selection,
                position: dest
              });
            } else {
              lassoSegment = null;
            }
          }
        } else if (focus != null) {
          input.setSelectionRange(Math.min(anchor, head), Math.max(anchor, head));
          anchor = head = null;
        } else if (lassoAnchor != null) {
          corner = {
            x: Math.min(lassoAnchor.x, lassoHead.x),
            y: Math.min(lassoAnchor.y, lassoHead.y)
          };
          size = {
            width: Math.abs(lassoAnchor.x - lassoHead.x),
            height: Math.abs(lassoAnchor.y - lassoHead.y)
          };
          lassoRect = new draw.Rectangle(corner.x, corner.y, size.width, size.height);
          firstLassoed = null;
          head = tree.segment.start;
          while (head !== tree.segment.end) {
            if (head.type === 'blockStart' && head.block.paper._container.intersects(lassoRect)) {
              firstLassoed = head.block;
              break;
            }
            head = head.next;
          }
          lastLassoed = null;
          head = tree.segment.end;
          while (head !== tree.segment.start) {
            if (head.type === 'blockEnd' && head.block.paper._container.intersects(lassoRect)) {
              lastLassoed = head.block;
              break;
            }
            head = head.prev;
          }
          if ((firstLassoed != null) && (lastLassoed != null)) {
            stack = [firstLassoed];
            head = firstLassoed.start.next;
            while (head !== lastLassoed.end) {
              switch (head.type) {
                case 'blockStart':
                  stack.push(head.block);
                  break;
                case 'segmentStart':
                  stack.push(head.segment);
                  break;
                case 'indentStart':
                  stack.push(head.indent);
                  break;
                case 'blockEnd':
                  if (stack.length > 0) {
                    stack.pop();
                  } else {
                    firstLassoed = head.block;
                  }
                  break;
                case 'segmentEnd':
                  if (stack.length > 0) {
                    stack.pop();
                  } else {
                    firstLassoed = head.segment;
                  }
                  break;
                case 'indentEnd':
                  if (stack.length > 0) {
                    stack.pop();
                  } else {
                    firstLassoed = head.indent;
                    _head = head.indent.start;
                    _stack = [];
                    while (_head !== null) {
                      if (_head.type === 'blockEnd') {
                        _stack.push(_head.block);
                      } else if (_head.type === 'blockStart') {
                        if (_stack.length > 0) {
                          _stack.pop();
                        } else {
                          stack.unshift(_head.block);
                          firstLassoed = _head.block;
                          break;
                        }
                      }
                      _head = _head.prev;
                    }
                  }
              }
              head = head.next;
            }
            if (stack[0].type === 'indent') {
              head = stack[0].end;
              _stack = [];
              while (head !== null) {
                if (head.type === 'blockStart') {
                  console.log('discards', head.block.toString());
                  _stack.push(head.block);
                } else if (head.type === 'blockEnd') {
                  console.log(head.block.toString(), stack);
                  if (_stack.length > 0) {
                    _stack.pop();
                  } else {
                    if (_ref = head.block, __indexOf.call(stack, _ref) < 0) {
                      firstLassoed = head.block;
                    }
                    stack[0] = head.block;
                    break;
                  }
                }
                head = head.next;
              }
            }
            lastLassoed = stack[0];
            lassoSegment = new Segment([]);
            firstLassoed.start.prev.insert(lassoSegment.start);
            lastLassoed.end.insert(lassoSegment.end);
          }
        }
        dragCtx.clearRect(0, 0, canvas.width, canvas.height);
        selection = null;
        lassoAnchor = null;
        if (focus == null) {
          return redraw();
        }
      });
      div.addEventListener('mousewheel', function(event) {
        if (scrollOffset.y > 0 || event.deltaY > 0) {
          ctx.translate(0, -event.deltaY);
          scrollOffset.add(0, event.deltaY);
          fastDraw();
          event.preventDefault();
          return false;
        }
        return true;
      });
      out.onkeyup = function() {
        var e;
        try {
          tree = coffee.parse(out.value);
          return redraw();
        } catch (_error) {
          e = _error;
          ctx.fillStyle = "#f00";
          return ctx.fillText(e.message, 0, 0);
        }
      };
      palette_blocks = [(coffee.parse('a = b')).segment, (coffee.parse('alert \'hi\'')).segment, (coffee.parse('for i in [1..10]\n  alert \'good\'')).segment, (coffee.parse('return 0')).segment];
      running_height = 0;
      for (_i = 0, _len = palette_blocks.length; _i < _len; _i++) {
        block = palette_blocks[_i];
        block.paper.compute({
          line: 0
        });
        block.paper.translate(new draw.Point(0, running_height));
        block.paper.finish();
        running_height = block.paper.bounds[block.paper.lineEnd].bottom() + PALETTE_WHITESPACE;
        block.paper.draw(paletteCtx);
      }
    }

    return Editor;

  })();

  window.onload = function() {
    if (!window.RUN_PAPER_TESTS) {
      return;
    }
    out = document.getElementById('out');
    return new Editor(document.getElementById('editor'));
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/