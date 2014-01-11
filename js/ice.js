/*
# A Block is a bunch of tokens that are grouped together.
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, DROP_AREA_MAX_WIDTH, FONT_SIZE, INDENT, IcePaper, Indent, IndentEndToken, IndentPaper, IndentStartToken, MOUTH_BOTTOM, NewlineToken, PADDING, Socket, SocketEndToken, SocketPaper, SocketStartToken, TextToken, TextTokenPaper, Token, indentParse, lispParse,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Block = (function() {
    function Block(contents) {
      var head, token, _i, _len;
      this.start = new BlockStartToken(this);
      this.end = new BlockEndToken(this);
      this.type = 'block';
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
      return this;
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
      return this;
    };

    Block.prototype.toString = function(state) {
      var string;
      string = this.start.toString(state);
      return string.slice(0, +(string.length - this.end.toString(state).length - 1) + 1 || 9e9);
    };

    return Block;

  })();

  Indent = (function() {
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

    Indent.prototype.embedded = function() {
      return false;
    };

    Indent.prototype.toString = function(state) {
      var string;
      string = this.start.toString(state);
      return string.slice(0, +(string.length - this.end.toString(state).length - 1) + 1 || 9e9);
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
      return this;
    };

    return Indent;

  })();

  Socket = (function() {
    function Socket(content) {
      this.start = new SocketStartToken(this);
      this.end = new SocketEndToken(this);
      if (content != null) {
        this.start.next = this.content.start;
        this.end.prev = this.content.end;
      } else {
        this.start.next = this.end;
        this.end.prev = this.start;
      }
      this.type = 'socket';
      this.paper = new SocketPaper(this);
    }

    Socket.prototype.embedded = function() {
      return false;
    };

    Socket.prototype.content = function() {
      if (this.start.next !== this.end) {
        return this.start.next.block;
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
      return this;
    };

    Socket.prototype.toString = function(state) {
      if (this.content) {
        return this.content.toString();
      } else {
        return '';
      }
    };

    return Socket;

  })();

  Token = (function() {
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


  TextToken = (function(_super) {
    __extends(TextToken, _super);

    function TextToken(value) {
      this.value = value;
      this.prev = this.next = null;
      this.paper = new TextTokenPaper(this);
      this.type = 'text';
    }

    TextToken.prototype.toString = function(state) {
      return this.value + (this.next != null ? this.next.toString(state) : '');
    };

    return TextToken;

  })(Token);

  BlockStartToken = (function(_super) {
    __extends(BlockStartToken, _super);

    function BlockStartToken(block) {
      this.block = block;
      this.prev = this.next = null;
      this.type = 'blockStart';
    }

    return BlockStartToken;

  })(Token);

  BlockEndToken = (function(_super) {
    __extends(BlockEndToken, _super);

    function BlockEndToken(block) {
      this.block = block;
      this.prev = this.next = null;
      this.type = 'blockEnd';
    }

    return BlockEndToken;

  })(Token);

  NewlineToken = (function(_super) {
    __extends(NewlineToken, _super);

    function NewlineToken() {
      this.prev = this.next = null;
      this.type = 'newline';
    }

    NewlineToken.prototype.toString = function(state) {
      return '\n' + state.indent + (this.next ? this.next.toString(state) : '');
    };

    return NewlineToken;

  })(Token);

  IndentStartToken = (function(_super) {
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

  IndentEndToken = (function(_super) {
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

  SocketStartToken = (function(_super) {
    __extends(SocketStartToken, _super);

    function SocketStartToken(socket) {
      this.socket = socket;
      this.prev = this.next = null;
      this.type = 'socketStart';
    }

    return SocketStartToken;

  })(Token);

  SocketEndToken = (function(_super) {
    __extends(SocketEndToken, _super);

    function SocketEndToken(socket) {
      this.socket = socket;
      this.prev = this.next = null;
      this.type = 'socketEnd';
    }

    return SocketEndToken;

  })(Token);

  /*
  # Example LISP parser/
  */


  lispParse = function(str) {
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

  indentParse = function(str) {
    var block, char, currentString, depth_stack, first, head, indent, line, socket, stack, _i, _j, _len, _len1, _ref, _ref1;
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
            head = head.append(new TextToken(')'));
            while (head.type !== 'blockEnd') {
              head = head.append(stack.pop().end);
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

  window.ICE = {
    lispParse: lispParse,
    indentParse: indentParse
  };

  PADDING = 2;

  INDENT = 10;

  MOUTH_BOTTOM = 50;

  DROP_AREA_MAX_WIDTH = 50;

  FONT_SIZE = 20;

  /*
  # For developers, bits of policy:
  # 1. Calling IcePaper.draw() must ALWAYS render the entire block and all its children.
  # 2. ONLY IcePaper.compute() may modify the pointer value of @lineGroups or @bounds. Use copy() and clear().
  */


  window.RUN_PAPER_TESTS = false;

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
    }

    BlockPaper.prototype.compute = function(state) {
      var axis, head, height, i, indent, line, top, _i, _ref, _ref1;
      this.indented = {};
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
        height = Math.max(height, child.bounds[line].height);
      }
      return height + 2 * PADDING;
    };

    BlockPaper.prototype.setLeftCenter = function(line, point) {
      var child, cursor, i, _bottomModifier, _i, _len, _ref;
      cursor = point.clone();
      cursor.add(PADDING, 0);
      this.lineGroups[line].empty();
      this._pathBits[line].left.length = 0;
      this._pathBits[line].right.length = 0;
      this.bounds[line].clear();
      this.bounds[line].swallow(point);
      _bottomModifier = 0;
      _ref = this._lineChildren[line];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        child = _ref[i];
        if (i === 0 && child.block.type === 'indent') {
          this.indented[line] = true;
          cursor.add(INDENT, 0);
          child.setLeftCenter(line, cursor);
          this._pathBits[line].right.push(new draw.Point(child.bounds[line].x, child.bounds[line].y));
          this._pathBits[line].right.push(new draw.Point(child.bounds[line].x, child.bounds[line].bottom()));
          if (this._lineChildren[line].length > 1) {
            this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].bottom()));
            this._pathBits[line].right.push(new draw.Point(child.bounds[line].right(), child.bounds[line].y));
          }
          if (child.lineEnd === line) {
            _bottomModifier += INDENT;
          }
        } else {
          this.indented[line] = this.indented[line] || (child.indented != null ? child.indented[line] : false);
          child.setLeftCenter(line, cursor);
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
      this._pathBits[line].left.push(new draw.Point(this.bounds[line].x, this.bounds[line].y));
      this._pathBits[line].left.push(new draw.Point(this.bounds[line].x, this.bounds[line].bottom() + _bottomModifier));
      if (this._lineChildren[line][0].block.type === 'indent' && this._lineChildren[line][0].lineEnd !== line) {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].y));
        return this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].bottom()));
      } else if (this._lineChildren[line][0].block.type === 'indent' && this._lineChildren[line][0].lineEnd === line) {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].y));
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].x + INDENT + PADDING, this.bounds[line].bottom()));
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom()));
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
        return this.bounds[line].height += 10;
      } else {
        this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].y));
        return this._pathBits[line].right.push(new draw.Point(this.bounds[line].right(), this.bounds[line].bottom() + _bottomModifier));
      }
    };

    BlockPaper.prototype.finish = function() {
      var bit, child, line, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
      this._container = new draw.Path();
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
      var child, line, _i, _len, _ref, _results;
      this.point.translate(vector);
      for (line in this.bounds) {
        this.lineGroups[line].translate(vector);
        this.bounds[line].translate(vector);
      }
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
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
      if ((this._content = this.block.content()) != null) {
        (contentPaper = this._content.paper).compute(state);
        for (line in contentPaper.bounds) {
          this.bounds[line] = contentPaper.bounds[line];
          this.lineGroups[line] = contentPaper.lineGroups[line];
        }
        this.indented = this._content.paper.indented;
        this.group = contentPaper.group;
        this.children = [this._content.paper];
        this.lineStart = contentPaper.lineStart;
        this.lineEnd = contentPaper.lineEnd;
      } else {
        this.bounds[state.line] = new draw.Rectangle(0, 0, 20, 20);
        this.lineStart = this.lineEnd = this._line = state.line;
        this.children = [];
        this.indented = {};
        this.indented[this._line] = false;
      }
      this._empty = typeof content !== "undefined" && content !== null;
      return this;
    };

    SocketPaper.prototype.setLeftCenter = function(line, point) {
      if (!this._empty) {
        this._content.paper.setLeftCenter(line, point);
        return this.lineGroups[line].recompute();
      } else {
        this.bounds[line].x = point.x;
        this.bounds[line].y = point.y - this.bounds[line].height / 2;
        return this.lineGroups[line].setPosition(new draw.Point(point.x, point.y - this.bounds[line].height / 2));
      }
    };

    SocketPaper.prototype.draw = function(ctx) {
      var rect;
      if (!this.empty) {
        return this._content.paper.draw(ctx);
      } else {
        rect = this.bounds[this._line];
        ctx.strokeStyle = '#000';
        return ctx.strokeRect(rect.x, rect.y, rect.width, rect.height);
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
      this.group = new draw.Group();
      this.children = [];
      this.lineStart = state.line += 1;
      head = this.block.start.next.next;
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
      i = 0;
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        if (!(line in this.children[i].bounds)) {
          i += 1;
        }
        this.bounds[line] = this.children[i].bounds[line];
        this.lineGroups[line] = new draw.Group();
        this.lineGroups[line].push(this.children[i].lineGroups[line]);
        this._lineBlocks[line] = this.children[i];
      }
      return this;
    };

    IndentPaper.prototype.setLeftCenter = function(line, point) {
      this._lineBlocks[line].setLeftCenter(line, point);
      return this.lineGroups[line].recompute();
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
      this.lineGroups[this._line] = new draw.Group();
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
  # Tests
  */


  window.onload = function() {
    var canvas, ctx, tree;
    if (!window.RUN_PAPER_TESTS) {
      return;
    }
    draw._setCTX(ctx = (canvas = document.getElementById('canvas')).getContext('2d'));
    tree = ICE.indentParse('(defun turing (lambda (tuples left right state)\n  ((lambda (tuple)\n      (if (= (car tuple) -1)\n        (turing tuples (cons (car (cdr tuple) left) (cdr right) (car (cdr (cdr tuple)))))\n        (if (= (car tuple 1))\n          (turing tuples (cdr left) (cons (car (cdr tuple)) right) (car (cdr (cdr tuple))))\n          (turing tuples left right (car (cdr tuple))))))\n    (lookup tuples (car right) state)))');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    tree.block.paper.compute({
      line: 0
    });
    tree.block.paper.finish();
    return tree.block.paper.draw(ctx);
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/