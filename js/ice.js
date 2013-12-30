/*
# A RecomputeState is a vanilla stack
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, IndentEndToken, IndentStartToken, LINE_HEIGHT, NewlineToken, PADDING, RecomputeState, Socket, TextToken, TextTokenPaper, Token, drawLine, indentParse, lispParse, _iter, _iterStack,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  RecomputeState = (function() {
    function RecomputeState() {
      this.stack = {
        next: null,
        data: null
      };
    }

    RecomputeState.prototype.first = function() {
      return this.stack.data;
    };

    RecomputeState.prototype.push = function(element) {
      return this.stack = {
        next: this.stack,
        data: element
      };
    };

    RecomputeState.prototype.pop = function() {
      var removed;
      removed = this.stack;
      this.stack = this.stack.next;
      return removed;
    };

    return RecomputeState;

  })();

  /*
  # A Block is a bunch of tokens that are grouped together.
  */


  Block = (function() {
    function Block(contents) {
      var head, token, _i, _len;
      this.start = new BlockStartToken(this);
      head = this.start;
      for (_i = 0, _len = contents.length; _i < _len; _i++) {
        token = contents[_i];
        head.next = token.clone();
        head.next.previous = head;
        head = head.next;
      }
      head.next = this.end;
      this.end = new BlockEndToken(this);
      this.paper = new BlockPaper(this);
    }

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
      this.end.next = parent.next;
      parent.next.prev = this.end;
      parent.next = this.start;
      return this.start.prev = parent;
    };

    Block.prototype.recompute = function(state) {};

    Block.prototype.find = function(f) {
      var head;
      head = this.start.next;
      while (head !== this.end) {
        if (head.type === 'blockStart' && f(head.block)) {
          return head.block.find(f);
        }
        head = head.next;
      }
      return this;
    };

    Block.prototype.toString = function() {
      var string;
      string = this.start.toString();
      return string.slice(0, +(string.length - this.end.toString().length - 1) + 1 || 9e9);
    };

    return Block;

  })();

  Token = (function() {
    function Token() {
      this.prev = this.next = null;
    }

    Token.prototype.insert = function(token) {
      if (this.next != null) {
        this.next.prev = token;
      }
      token.prev = this;
      return this.next = token;
    };

    Token.prototype.recompute = function(state) {
      if (this.next != null) {
        return this.next.recompute(state);
      }
    };

    Token.prototype.toString = function() {
      if (this.next != null) {
        return this.next.toString();
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

    TextToken.prototype.toString = function() {
      return this.value + (this.next != null ? this.next.toString() : '');
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

    BlockStartToken.prototype.recompute = function(state) {
      state.push();
      if (this.next != null) {
        return this.next.recompute(state);
      }
    };

    return BlockStartToken;

  })(Token);

  BlockEndToken = (function(_super) {
    __extends(BlockEndToken, _super);

    function BlockEndToken(block) {
      this.block = block;
      this.prev = this.next = null;
      this.type = 'blockEnd';
    }

    BlockEndToken.prototype.recompute = function() {
      state.pop();
      this.block.recompute(state);
      if (this.next != null) {
        return this.next.recompute(state);
      }
    };

    return BlockEndToken;

  })(Token);

  NewlineToken = (function(_super) {
    __extends(NewlineToken, _super);

    function NewlineToken(indent) {
      this.indent = indent;
      if (this.indent == null) {
        this.indent = '';
      }
      this.prev = this.next = null;
      this.type = 'newline';
    }

    NewlineToken.prototype.toString = function() {
      return '\n' + this.indent + (this.next ? this.next.toString() : '');
    };

    return NewlineToken;

  })(Token);

  IndentStartToken = (function(_super) {
    __extends(IndentStartToken, _super);

    function IndentStartToken() {
      this.prev = this.Next = null;
      this.type = 'indentStart';
    }

    return IndentStartToken;

  })(Token);

  IndentEndToken = (function(_super) {
    __extends(IndentEndToken, _super);

    function IndentEndToken() {
      this.prev = this.Next = null;
      this.type = 'indentEnd';
    }

    return IndentEndToken;

  })(Token);

  /*
  # A Socket is a token that a Block can move to.
  */


  Socket = (function(_super) {
    __extends(Socket, _super);

    function Socket(accepts) {
      this.accepts = accepts;
      this.value = this.prev = this.next = null;
      this.type = 'socket';
    }

    Socket.prototype.toString = function() {
      return (this.value != null ? this.value.toString() : '') + (this.next != null ? this.next.toString() : '');
    };

    return Socket;

  })(Token);

  /*
  # Example LISP parser
  */


  lispParse = function(str) {
    var block, block_stack, char, currentString, first, head, _i, _len;
    currentString = '';
    first = head = new TextToken('');
    block_stack = [];
    for (_i = 0, _len = str.length; _i < _len; _i++) {
      char = str[_i];
      switch (char) {
        case '(':
          head = head.insert(new TextToken(currentString));
          block_stack.push(block = new Block([]));
          head = head.insert(block.start);
          head = head.insert(new TextToken('('));
          currentString = '';
          break;
        case ')':
          head = head.insert(new TextToken(currentString));
          head = head.insert(new TextToken(')'));
          head = head.insert(block_stack.pop().end);
          currentString = '';
          break;
        case ' ':
          head = head.insert(new TextToken(currentString));
          head = head.insert(new TextToken(' '));
          currentString = '';
          break;
        case '\n':
          head = head.insert(new TextToken(currentString));
          head = head.insert(new NewlineToken());
          currentString = '';
          break;
        default:
          currentString += char;
      }
    }
    head = head.insert(new TextToken(currentString));
    return first;
  };

  indentParse = function(str) {
    var block, blockStack, cindent, first, head, indent, indentStack, line, lines, _i, _len;
    lines = str.split('\n');
    indent = 0;
    indentStack = [0];
    blockStack = [];
    first = head = new TextToken('');
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      cindent = line.length - line.trim().length;
      if (cindent <= indent && blockStack.length > 0) {
        head = head.insert(blockStack.pop().end);
      }
      head = head.insert(new NewlineToken());
      head.indent = line.slice(0, cindent);
      if (cindent > indent) {
        indentStack.push(indent);
        indent = cindent;
        head = head.insert(new IndentStartToken());
      }
      while (indent > cindent) {
        indent = indentStack.pop();
        head = head.insert(new IndentEndToken());
        head = head.insert(blockStack.pop().end);
      }
      blockStack.push(block = new Block([]));
      head = head.insert(block.start);
      head = head.insert(new TextToken(line.slice(cindent)));
    }
    return first;
  };

  window.ICE = {
    lispParse: lispParse,
    indentParse: indentParse
  };

  /*
  # Constants
  */


  PADDING = 5;

  LINE_HEIGHT = 15;

  TextTokenPaper = (function() {
    /*
    # Plain text
    */

    function TextTokenPaper(block) {
      this.block = block;
      this._initd = false;
      try {
        this._init();
      } catch (_error) {}
    }

    TextTokenPaper.prototype._init = function() {
      this.initd = true;
      return this.text = new paper.PointText({
        point: [0, 0],
        content: this.block.value,
        font: 'Courier New',
        fillColor: 'black'
      });
    };

    TextTokenPaper.prototype.draw = function(state) {
      if (!this.initd) {
        this._init();
      }
      this.text.bounds.point.x = state.point.x;
      this.text.position.y = state.axis;
      state.point.x += this.text.bounds.size.width + PADDING;
      return this.text.bringToFront();
    };

    return TextTokenPaper;

  })();

  BlockPaper = (function() {
    /*
    # (A block)
    */

    function BlockPaper(block) {
      this.block = block;
      this.padding = 1;
      this._initd = false;
      this._linerect = {
        head: new paper.Point(0, 0),
        tail: new paper.Point(0, 0)
      };
      try {
        this._init;
      } catch (_error) {}
    }

    BlockPaper.prototype.init = function(state) {
      this._linerect.head = new paper.Point(state.point.x, state.axis - (LINE_HEIGHT / 2 + this.padding * PADDING));
      this.container = new paper.Path();
      this.container.strokeColor = 'black';
      this.container.fillColor = 'white';
      return state.point.x += PADDING;
    };

    BlockPaper.prototype.line = function(state) {
      console.log('lining with', this._linerect);
      this.container.insert(0, this._linerect.head);
      this.container.insert(0, new paper.Point(this._linerect.head.x, this._linerect.tail.y));
      this.container.add(new paper.Point(this._linerect.tail.x, this._linerect.head.y));
      this.container.add(this._linerect.tail);
      this._linerect = {};
      return this.padding = 1;
    };

    BlockPaper.prototype.mouth = function(state) {
      var corner;
      corner = new paper.Point(this._linerect.head.x + PADDING, state.lineStart.y + PADDING);
      state.point.x += PADDING;
      state.mouthStack.push({
        corner: corner
      });
      return state.blockStack.push({
        type: 'mouthStopper'
      });
    };

    BlockPaper.prototype.unmouth = function(state) {
      return console.log(state);
    };

    BlockPaper.prototype.finish = function(state) {
      state.point.x += PADDING;
      this._linerect.tail = new paper.Point(state.point.x, state.axis + (LINE_HEIGHT / 2 + this.padding * PADDING));
      this.line(state);
      return this.container.closed = true;
    };

    return BlockPaper;

  })();

  _iter = function(start, end, f) {
    var _results;
    _results = [];
    while (start !== end) {
      f(start);
      _results.push(start = start.next);
    }
    return _results;
  };

  _iterStack = function(blockStack, f, g) {
    var block, i, stopped, _i, _len, _ref, _results;
    stopped = false;
    if (f == null) {
      f = function() {};
    }
    if (g == null) {
      g = f;
    }
    _ref = blockStack.slice(0).reverse();
    _results = [];
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      block = _ref[i];
      if (block.type === 'mouthStopper') {
        _results.push(stopped = true);
      } else if (stopped) {
        _results.push(g(block, blockStack.length - i - 1));
      } else {
        _results.push(f(block, blockStack.length - i - 1));
      }
    }
    return _results;
  };

  drawLine = function(start, end, state) {
    var block, i, maxPadding, padding, tempStack, _i, _len, _ref;
    state.lineStart = state.point.clone();
    _ref = state.blockStack;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      block = _ref[i];
      if (block.type !== 'mouthStopper') {
        block._linerect.head = state.lineStart.add(i * PADDING, i * PADDING);
      }
    }
    maxPadding = padding = state.padding;
    tempStack = state.blockStack.slice(0);
    _iter(start, end, function(block) {
      switch (block.constructor.name) {
        case 'BlockStartToken':
          padding++;
          tempStack.push(block.block.paper);
          break;
        case 'BlockEndToken':
          padding--;
          tempStack.pop();
      }
      _iterStack(tempStack, function(block, i) {
        if (tempStack.length - i > block.padding) {
          return block.padding = tempStack.length - i;
        }
      });
      if (padding > maxPadding) {
        return maxPadding = padding;
      }
    });
    state.axis = state.point.y + maxPadding * PADDING + (LINE_HEIGHT / 2);
    state.thick = function() {
      return maxPadding - state.padding;
    };
    state.mouthCorner = function() {
      return state.mouthStack[state.mouthStack.length - 1].corner;
    };
    _iter(start, end, function(block) {
      switch (block.type) {
        case 'text':
          return block.paper.draw(state);
        case 'blockStart':
          debugger;
          state.blockStack.push(block.block.paper);
          block.block.paper.init(state);
          return state.padding++;
        case 'blockEnd':
          state.padding--;
          state.blockStack.pop();
          return block.block.paper.finish(state);
        case 'indentStart':
          state.lastMouthStack.push(state.blockStack.length);
          return state.blockStack[state.blockStack.length - 1].mouth(state);
        case 'indentEnd':
          state.blockStack.pop();
          state.mouthStack.pop();
          state.lastMouthStack.pop();
          return state.blockStack[state.blockStack.length - 1].unmouth(state);
      }
    });
    state.point.y += LINE_HEIGHT + maxPadding * PADDING * 2;
    state.point.x += (state.blockStack.length - state.lastMouth() - 1) * PADDING;
    state.lineEnd = state.point.clone();
    state.point.x = state.mouthCorner().x;
    _iterStack(state.blockStack, (function(block, i) {
      console.log(state.lineEnd);
      block._linerect.tail = state.lineEnd.subtract(new paper.Point(i * PADDING, i * PADDING));
      return block.line(state);
    }), function(block) {
      block._linerect.tail = new paper.Point(state.mouthCorner().x, state.lineEnd.y);
      return block.line(state);
    });
    paper.view.draw();
    debugger;
  };

  window.onload = function() {
    var a, lastStart, state;
    paper.setup(document.getElementById('canvas'));
    window.blocks = a = ICE.indentParse('if a is b\n  do a, ->\n    b c\n  do b, ->\n    c d\nelse\n  do c, ->\n    d e');
    lastStart = a;
    state = {
      point: new paper.Point(0, 10),
      axis: null,
      padding: 0,
      blockStack: [],
      lastMouthStack: [],
      lastMouth: function() {
        var _ref;
        return (_ref = state.lastMouthStack[state.lastMouthStack.length - 1]) != null ? _ref : 0;
      },
      mouthStack: [
        {
          corner: new paper.Point(0, 0)
        }
      ]
    };
    _iter(a, null, function(block) {
      if (block.constructor.name === 'NewlineToken') {
        drawLine(lastStart, block, state);
        return lastStart = block.next;
      }
    });
    drawLine(lastStart, null, state);
    return paper.view.draw();
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/