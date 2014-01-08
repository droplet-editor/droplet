/*
# A Block is a bunch of tokens that are grouped together.
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, DROP_AREA_MAX_WIDTH, INDENT, IcePaper, Indent, IndentEndToken, IndentPaper, IndentStartToken, MOUTH_BOTTOM, NewlineToken, PADDING, Socket, SocketEndToken, SocketPaper, SocketStartToken, TextToken, TextTokenPaper, Token, indentParse, lispParse,
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

  INDENT = 13;

  MOUTH_BOTTOM = 100;

  DROP_AREA_MAX_WIDTH = 50;

  window.RUN_PAPER_TESTS = false;

  IcePaper = (function() {
    function IcePaper(block) {
      this.block = block;
    }

    IcePaper.prototype.compute = function(state) {};

    IcePaper.prototype.draw = function() {};

    IcePaper.prototype.setLeftCenter = function(line, point) {};

    IcePaper.prototype.translate = function(vector) {};

    return IcePaper;

  })();

  IndentPaper = (function(_super) {
    __extends(IndentPaper, _super);

    function IndentPaper(block) {
      this.block = block;
    }

    IndentPaper.prototype.compute = function(state) {
      var axis, bottom, element, elements, head, line, lineGroup, lineStart, _i, _j, _len, _ref;
      this.point = new paper.Point(0, 0);
      this.lines = {};
      elements = [];
      this.lineStart = lineStart = state.line += 1;
      this.group = new paper.Group([]);
      this.children = [];
      /*
      # Loop through the children and compute them
      */

      head = this.block.start.next;
      if (head !== this.block.end) {
        head = head.next;
      }
      while (head !== this.block.end) {
        switch (head.type) {
          case 'text':
            element = head.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            this.group.addChild(element.group);
            head = head.next;
            break;
          case 'blockStart':
            element = head.block.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            this.group.addChild(element.group);
            head = head.block.end.next;
            break;
          case 'newline':
            state.line += 1;
            head = head.next;
            break;
          default:
            head = head.next;
        }
      }
      this.lineEnd = state.line;
      this.lineGroups = {};
      axis = 0;
      bottom = 0;
      for (line = _i = lineStart, _ref = state.line; lineStart <= _ref ? _i <= _ref : _i >= _ref; line = lineStart <= _ref ? ++_i : --_i) {
        this.lineGroups[line] = (lineGroup = []);
        for (_j = 0, _len = elements.length; _j < _len; _j++) {
          element = elements[_j];
          if (line in element.lines) {
            lineGroup.push(element);
            this.group.addChild(element.group);
          }
        }
        this.setLeftCenter(line, new paper.Point(0, axis));
        axis = bottom + this.lines[line].height / 2;
        this.setLeftCenter(line, new paper.Point(0, axis));
        bottom += this.lines[line].height;
        this.lines[line].selected = true;
      }
      return this;
    };

    IndentPaper.prototype.draw = function() {
      var child, _i, _len, _ref, _results;
      this.group.addChild(this._dropArea = new paper.Path.Rectangle(new paper.Rectangle(this.point.subtract(0, 5), new paper.Size(DROP_AREA_MAX_WIDTH, 10))));
      this._dropArea.bringToFront();
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.draw());
      }
      return _results;
    };

    IndentPaper.prototype.erase = function() {
      var child, _i, _len, _ref, _results;
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.erase());
      }
      return _results;
    };

    IndentPaper.prototype.setLeftCenter = function(line, point) {
      var element, leftCenter, _i, _len, _ref;
      this.lines[line] = new paper.Rectangle(point, new paper.Size(0, 0));
      this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      _ref = this.lineGroups[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        element.setLeftCenter(line, new paper.Point(this.lines[line].right, point.y));
        this.lines[line] = this.lines[line].unite(element.lines[line]);
      }
      leftCenter = this.lines[line].leftCenter;
      this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      if (line === this.lineStart) {
        return this.point = this.lines[line].point;
      }
    };

    IndentPaper.prototype.translate = function(vector) {
      var child, line, _i, _len, _ref, _results;
      this.point = this.point.add(vector);
      for (line in this.lines) {
        this.lines[line].point = this.lines[line].point.add(vector);
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
      var vector;
      vector = point.subtract(this.point);
      return this.translate(vector);
    };

    IndentPaper.prototype.getHeight = function() {
      var bounds, line;
      bounds = new paper.Rectangle(this.group.bounds.point, new paper.Size(0, 0));
      for (line in this.lines) {
        bounds = bounds.unite(this.lines[line]);
      }
      return bounds.height;
    };

    return IndentPaper;

  })(IcePaper);

  BlockPaper = (function(_super) {
    __extends(BlockPaper, _super);

    function BlockPaper(block) {
      this.block = block;
    }

    BlockPaper.prototype.compute = function(state) {
      var axis, bottom, cont, element, elements, head, indent, indents, line, lineGroup, lineStart, _i, _j, _k, _len, _len1, _ref, _ref1;
      this.lines = {};
      elements = [];
      indents = [];
      this.lineStart = lineStart = state.line;
      this.indentedLines = {};
      this.group = new paper.Group([]);
      this.children = [];
      this.indentEnds = [];
      /*
      # Loop through the children and compute them
      */

      head = this.block.start.next;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'text':
            element = head.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            this.group.addChild(element.group);
            head = head.next;
            break;
          case 'blockStart':
            element = head.block.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            this.group.addChild(element.group);
            head = head.block.end.next;
            break;
          case 'indentStart':
            indent = head.indent.paper.compute(state);
            indents.push(indent);
            this.children.push(indent);
            this.indentEnds[indent.lineEnd] = indent;
            this.group.addChild(indent.group);
            head = head.indent.end.next;
            break;
          case 'socketStart':
            element = head.socket.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            this.group.addChild(element.group);
            head = head.socket.end.next;
            break;
          case 'newline':
            state.line += 1;
            head = head.next;
            break;
          default:
            head = head.next;
        }
      }
      this.lineEnd = state.line;
      this.bounds = {};
      this.lineGroups = {};
      axis = 0;
      bottom = 0;
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        this.lineGroups[line] = (lineGroup = []);
        cont = false;
        for (_j = 0, _len = indents.length; _j < _len; _j++) {
          indent = indents[_j];
          if (line in indent.lines) {
            if (line === indent.lineStart) {
              indent.setPosition(new paper.Point(INDENT, bottom));
            }
            this.indentedLines[line] = indent;
            this.bounds[line] = new paper.Rectangle(indent.lines[line].point.subtract(INDENT, 0), new paper.Size(INDENT, indent.lines[line].height));
            this.lines[line] = indent.lines[line];
            if (line === indent.lineEnd) {
              this.lines[line].height += 10;
              this.bounds[line].height += 10;
            }
            bottom += indent.lines[line].height;
            cont = true;
          }
        }
        if (cont) {
          continue;
        }
        for (_k = 0, _len1 = elements.length; _k < _len1; _k++) {
          element = elements[_k];
          if (line in element.lines) {
            lineGroup.push(element);
          }
        }
        this.setLeftCenter(line, new paper.Point(0, axis));
        axis = bottom + this.lines[line].height / 2;
        this.setLeftCenter(line, new paper.Point(0, axis));
        bottom += this.lines[line].height;
        this.lines[line].selected = true;
      }
      return this;
    };

    BlockPaper.prototype.draw = function() {
      var child, line, _i, _j, _len, _ref, _ref1, _ref2;
      if (this._container != null) {
        this._container.remove();
      }
      this._container = new paper.Path();
      this._container.strokeColor = 'black';
      this._container.fillColor = 'white';
      this.group.addChild(this._container);
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        if (line in this.indentEnds) {
          this._container.add(this.bounds[line].topRight);
          this._container.add(this.bounds[line].bottomRight.add(new paper.Point(0, -10)));
          this._container.add(this.bounds[line].bottomRight.add(new paper.Point(MOUTH_BOTTOM, -10)));
          this._container.add(this.bounds[line].bottomRight.add(new paper.Point(MOUTH_BOTTOM, 0)));
          this._container.insert(0, this.bounds[line].topLeft);
          this._container.insert(0, this.bounds[line].bottomLeft);
        } else {
          this._container.add(this.bounds[line].topRight);
          this._container.add(this.bounds[line].bottomRight);
          this._container.insert(0, this.bounds[line].topLeft);
          this._container.insert(0, this.bounds[line].bottomLeft);
        }
      }
      this.group.addChild(this._dropArea = new paper.Path.Rectangle(new paper.Rectangle(this._container.bounds.bottomLeft.subtract(0, 5), new paper.Size(Math.min(DROP_AREA_MAX_WIDTH, this.group.bounds.width), 10))));
      this._dropArea.closed = true;
      this._container.closed = true;
      _ref2 = this.children;
      for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
        child = _ref2[_j];
        child.draw();
      }
      this._dropArea.bringToFront();
      return this._container.sendToBack();
    };

    BlockPaper.prototype.erase = function() {
      var child, _i, _len, _ref, _results;
      if (this._container != null) {
        this._container.remove();
      }
      if (this._dropArea != null) {
        this._dropArea.remove();
      }
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.erase());
      }
      return _results;
    };

    BlockPaper.prototype.deferIndent = function(line) {
      return (line in this.indentedLines) && !(line in this.indentEnds);
    };

    BlockPaper.prototype.setLeftCenter = function(line, point) {
      var element, leftCenter, _i, _len, _ref;
      if (line in this.indentEnds) {
        this.indentedLines[line].setLeftCenter(line, point.add(INDENT, -5));
        this.bounds[line].point = point.subtract(0, this.lines[line].height / 2);
        this.lines[line] = this.indentedLines[line].lines[line];
        this.lines[line].width = Math.max(this.lines[line].width, MOUTH_BOTTOM);
        this.lines[line].height += 10;
        return;
      }
      if (line in this.indentedLines) {
        this.indentedLines[line].setLeftCenter(line, point.add(INDENT, 0));
        this.bounds[line].point = point.subtract(0, this.lines[line].height / 2);
        this.lines[line] = this.indentedLines[line].lines[line].clone();
        return;
      }
      this.lines[line] = new paper.Rectangle(point, new paper.Size(PADDING, 0));
      this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      _ref = this.lineGroups[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        element.setLeftCenter(line, new paper.Point(this.lines[line].right, point.y));
        if (element.block.type === 'socket' && element.block.content().paper.deferIndent(line)) {
          this.bounds[line] = element.block.content().paper.bounds[line].clone();
          this.lines[line] = element.lines[line].clone();
          return;
        }
        this.lines[line] = this.lines[line].unite(element.lines[line]);
      }
      leftCenter = this.lines[line].leftCenter;
      this.lines[line].width += PADDING;
      this.lines[line].height += PADDING * 2;
      this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      return this.bounds[line] = this.lines[line].clone();
    };

    BlockPaper.prototype.translate = function(vector) {
      var child, line, _i, _len, _ref, _results;
      if (this._container != null) {
        this._container.translate(vector);
      }
      for (line in this.lines) {
        this.lines[line].point = this.lines[line].point.add(vector);
      }
      for (line in this.bounds) {
        this.bounds[line].point = this.bounds[line].point.add(vector);
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
      this.block = block;
      this.empty = false;
    }

    SocketPaper.prototype._recopy = function() {
      var contentPaper, line;
      contentPaper = this.block.content().paper;
      for (line in contentPaper.lines) {
        this.lines[line] = contentPaper.lines[line];
      }
      return this.group = contentPaper.group;
    };

    SocketPaper.prototype.compute = function(state) {
      var content;
      this.lines = {};
      if ((content = this.block.content()) != null) {
        content.paper.compute(state);
        this._recopy();
      } else {
        this.lines[state.line] = new paper.Rectangle(0, 0, 20, 20);
        this._line = state.line;
        this.group = new paper.Group([]);
      }
      this.empty = this.block.content != null;
      return this;
    };

    SocketPaper.prototype.draw = function() {
      if (this._container != null) {
        this._container.remove();
      }
      if (this.block.content() != null) {
        this.block.content().paper.draw();
        return this.group = this.block.group;
      } else {
        this._container = new paper.Path.Rectangle(this.lines[this._line]);
        this._container.strokeColor = 'black';
        this._dropArea = this._container.clone();
        this._dropArea.strokeColor = null;
        this.group.addChild(this._container);
        return this.group.addChild(this._dropArea);
      }
    };

    SocketPaper.prototype.erase = function() {
      if (this._container != null) {
        return this._container.remove();
      }
    };

    SocketPaper.prototype.setLeftCenter = function(line, point) {
      if (this.block.content() != null) {
        this.block.content().paper.setLeftCenter(line, point);
        return this.lines[line] = this.block.content().paper.lines[line];
      } else {
        return this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      }
    };

    SocketPaper.prototype.translate = function(vector) {
      if (this.block.content() != null) {
        this.block.content().paper.translate(vector);
        return this._recopy();
      } else {
        return this.lines[this._line].point = this.lines[this._line].point.add(vector);
      }
    };

    return SocketPaper;

  })(IcePaper);

  TextTokenPaper = (function(_super) {
    __extends(TextTokenPaper, _super);

    function TextTokenPaper(block) {
      this.block = block;
    }

    TextTokenPaper.prototype.compute = function(state) {
      if (this.text != null) {
        this.text.remove();
      }
      this.text = new paper.PointText(new paper.Point(0, 0));
      this.text.content = this.block.value;
      this.text.fillColor = 'black';
      this.text.font = 'Courier New';
      this.text.fontSize = 18;
      this.group = new paper.Group([this.text]);
      this.lines = {};
      this.lines[state.line] = this.text.bounds;
      this.line = state.line;
      return this;
    };

    TextTokenPaper.prototype.draw = function() {};

    TextTokenPaper.prototype.erase = function() {
      if (this.text != null) {
        return this.text.remove();
      }
    };

    TextTokenPaper.prototype.setLeftCenter = function(line, point) {
      if (line in this.lines) {
        this.text.position = new paper.Point(point.x + this.text.bounds.width / 2, point.y);
      }
      return this.lines[this.line] = this.text.bounds;
    };

    TextTokenPaper.prototype.translate = function(vector) {
      this.text.translate(vector);
      return this.lines[this.line].point = this.lines[this.line].point.add(vector);
    };

    return TextTokenPaper;

  })(IcePaper);

  /*
  # Tests
  */


  window.onload = function() {
    var a, highlight, offset, out, roots, selection, tool;
    if (!window.RUN_PAPER_TESTS) {
      return;
    }
    paper.setup(document.getElementById('canvas'));
    a = ICE.indentParse('(defun turing (lambda (tuples left right state)\n  ((lambda (tuple)\n      (if (= (car tuple) -1)\n        (turing tuples (cons (car (cdr tuple) left) (cdr right) (car (cdr (cdr tuple)))))\n        (if (= (car tuple 1))\n          (turing tuples (cdr left) (cons (car (cdr tuple)) right) (car (cdr (cdr tuple))))\n          (turing tuples left right (car (cdr tuple))))))\n    (lookup tuples (car right) state)))');
    /*
    a = ICE.indentParse '''
    (lambda
      (lambda
        (x)
        (y)
        (z)))
    '''
    */

    console.log(a);
    a.block.paper.compute({
      line: 0
    });
    a.block.paper.draw();
    paper.view.draw();
    tool = new paper.Tool();
    selection = null;
    highlight = null;
    offset = new paper.Point(0, 0);
    event.point = new paper.Point(0, 0);
    roots = [];
    tool.onMouseDown = function(event) {
      var block, found, parent_root, pos, root, _i, _len;
      block = a.block.findBlock(function(block) {
        return (block.paper._container.hitTest(event.point)) != null;
      });
      parent_root = null;
      for (_i = 0, _len = roots.length; _i < _len; _i++) {
        root = roots[_i];
        if ((root.paper._container.hitTest(event.point)) != null) {
          block = root;
        }
        found = root.findBlock(function(block) {
          return (block.paper._container.hitTest(event.point)) != null;
        });
        if (found !== root) {
          block = found;
          parent_root = root;
        }
      }
      if (block === a.block) {
        selection = null;
        return;
      }
      if ((block.start.prev != null) && block.start.prev.type === 'newline') {
        block.start.prev.remove();
      }
      block._moveTo(null);
      selection = block.paper;
      offset = selection.group.position.subtract(event.point);
      a.block.paper.erase();
      a.block.paper.compute({
        line: 0
      });
      a.block.paper.draw();
      if (parent_root != null) {
        pos = parent_root.paper.group.position;
        parent_root.paper.erase();
        parent_root.paper.compute({
          line: 0
        });
        parent_root.paper.draw();
        parent_root.paper.group.position = pos;
      }
      out.innerText = a.block.toString({
        indent: ''
      });
      selection.erase();
      selection.compute({
        line: 0
      });
      selection.draw();
      return selection.group.position = event.point.add(offset);
    };
    out = document.getElementById('out');
    tool.onMouseUp = function(event) {
      if ((highlight != null) && (selection != null)) {
        if (highlight.type === 'block') {
          selection.block._moveTo(highlight.end.insert(new NewlineToken()));
        } else if (highlight.type === 'indent') {
          selection.block._moveTo(highlight.start.insert(new NewlineToken()));
        } else if (highlight.type === 'socket') {
          selection.block._moveTo(highlight.start);
        }
        highlight.paper._dropArea.remove();
        a.block.paper.erase();
        a.block.paper.compute({
          line: 0
        });
        a.block.paper.draw();
        out.innerText = a.block.toString({
          indent: ''
        });
      }
      if ((selection != null) && (highlight == null)) {
        roots.push(selection.block);
      }
      return highlight = selection = null;
    };
    return tool.onMouseMove = function(event) {
      if (selection != null) {
        selection.group.position = event.point.add(offset);
        if (highlight != null) {
          highlight.paper._dropArea.fillColor = null;
        }
        highlight = a.block.find(function(block) {
          return (block.paper._dropArea != null) && block.paper._dropArea.bounds.contains(selection.group.bounds.point) && block.start.prev.type !== 'socketStart';
        });
        if (highlight === a.block) {
          return highlight = null;
        } else {
          if (highlight.paper.group != null) {
            highlight.paper.group.bringToFront();
          }
          highlight.paper._dropArea.bringToFront();
          selection.group.bringToFront();
          if (highlight !== a.block) {
            return highlight.paper._dropArea.fillColor = 'red';
          }
        }
      }
    };
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/