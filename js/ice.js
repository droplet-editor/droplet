/*
# A RecomputeState is a vanilla stack
*/


(function() {
  var Block, BlockEndToken, BlockPaper, BlockStartToken, INDENT, IcePaper, Indent, IndentEndToken, IndentPaper, IndentStartToken, NewlineToken, PADDING, RecomputeState, TextToken, TextTokenPaper, Token, indentParse, lispParse,
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
      this.end = new BlockEndToken(this);
      head = this.start;
      for (_i = 0, _len = contents.length; _i < _len; _i++) {
        token = contents[_i];
        head = head.insert(token.clone());
      }
      head.insert(this.end);
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
      head = this.start;
      for (_i = 0, _len = contents.length; _i < _len; _i++) {
        block = contents[_i];
        head = head.insert(block.clone());
      }
      head.insert(this.end);
      this.paper = new IndentPaper(this);
    }

    Indent.prototype.toString = function(state) {
      var string;
      string = this.start.toString(state);
      return string.slice(0, +(string.length - this.end.toString(state).length - 1) + 1 || 9e9);
    };

    return Indent;

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

  /*
  # Example LISP parser/
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
    var first, head, indent, line, lineate, lines, new_node, node, root, _i, _len;
    lines = str.split('\n');
    node = root = {
      parent: null,
      head: null,
      indent: -1,
      children: []
    };
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      indent = line.length - line.trimLeft().length;
      while (indent <= node.indent) {
        node = node.parent;
      }
      new_node = {
        parent: node,
        head: line,
        indent: indent,
        children: []
      };
      node.children.push(new_node);
      node = new_node;
    }
    head = first = new TextToken('');
    (lineate = function(_node) {
      var child, _block, _indent, _j, _len1, _ref;
      _block = new Block([]);
      if (_node.head != null) {
        head = head.insert(new NewlineToken());
        head = head.insert(_block.start);
        head = head.insert(new TextToken(_node.head.slice(_node.indent)));
      }
      if (_node.children.length > 0) {
        _indent = new Indent([], _node.children[0].indent - _node.indent);
        head = head.insert(_indent.start);
        _ref = _node.children;
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          child = _ref[_j];
          lineate(child);
        }
        head = head.insert(_indent.end);
      }
      return head = head.insert(_block.end);
    })(root);
    first = first.next.next.next;
    return first;
  };

  window.ICE = {
    lispParse: lispParse,
    indentParse: indentParse
  };

  PADDING = 2;

  INDENT = 7;

  window.RUN_PAPER_TESTS = false;

  IcePaper = (function() {
    function IcePaper(block) {
      this.block = block;
    }

    IcePaper.prototype.compute = function(state) {};

    IcePaper.prototype.draw = function() {};

    IcePaper.prototype.netLeftCenter = function(line, point) {};

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

      head = this.block.start.next.next;
      while (head !== this.block.end) {
        switch (head.type) {
          case 'text':
            element = head.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            head = head.next;
            break;
          case 'blockStart':
            element = head.block.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            head = head.block.end.next;
            break;
          case 'newline':
            state.line += 1;
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
      _ref = this.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.draw());
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
      return this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
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
      var axis, bottom, cont, element, elements, head, indent, indents, line, lineGroup, lineStart, _i, _j, _k, _len, _len1, _ref;
      this.lines = {};
      elements = [];
      indents = [];
      this.lineStart = lineStart = state.line;
      this.indentedLines = {};
      this.group = new paper.Group([]);
      this.children = [];
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
            head = head.next;
            break;
          case 'blockStart':
            element = head.block.paper.compute(state);
            elements.push(element);
            this.children.push(element);
            head = head.block.end.next;
            break;
          case 'indentStart':
            indent = head.indent.paper.compute(state);
            indents.push(indent);
            this.children.push(indent);
            head = head.indent.end.next;
            break;
          case 'newline':
            state.line += 1;
            head = head.next;
        }
      }
      this.lineEnd = state.line;
      this.lineGroups = {};
      axis = 0;
      bottom = 0;
      for (line = _i = lineStart, _ref = state.line; lineStart <= _ref ? _i <= _ref : _i >= _ref; line = lineStart <= _ref ? ++_i : --_i) {
        this.lineGroups[line] = (lineGroup = []);
        for (_j = 0, _len = indents.length; _j < _len; _j++) {
          indent = indents[_j];
          if (line in indent.lines) {
            if (line === indent.lineStart) {
              indent.setPosition(new paper.Point(INDENT, bottom));
            }
            this.indentedLines[line] = indent;
            this.lines[line] = new paper.Rectangle(indent.lines[line].point.subtract(INDENT, 0), new paper.Size(INDENT, indent.lines[line].height));
            this.group.addChild(element.group);
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
            this.group.addChild(element.group);
          }
        }
        this.setLeftCenter(line, new paper.Point(0, axis));
        axis = bottom + this.lines[line].height / 2;
        this.setLeftCenter(line, new paper.Point(0, axis));
        bottom += this.lines[line].height;
        this.lines[line].selected = true;
        line += 1;
      }
      return this;
    };

    BlockPaper.prototype.draw = function() {
      var child, line, _i, _j, _len, _ref, _ref1, _ref2, _results;
      this._container = new paper.Path();
      this._container.strokeColor = 'black';
      for (line = _i = _ref = this.lineStart, _ref1 = this.lineEnd; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; line = _ref <= _ref1 ? ++_i : --_i) {
        this._container.add(this.lines[line].topRight);
        this._container.add(this.lines[line].bottomRight);
        this._container.insert(0, this.lines[line].topLeft);
        this._container.insert(0, this.lines[line].bottomLeft);
      }
      this._container.closed = true;
      _ref2 = this.children;
      _results = [];
      for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
        child = _ref2[_j];
        _results.push(child.draw());
      }
      return _results;
    };

    BlockPaper.prototype.setLeftCenter = function(line, point) {
      var element, leftCenter, _i, _len, _ref;
      if (line in this.indentedLines) {
        this.indentedLines[line].setLeftCenter(line, point.add(INDENT, 0));
        this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
        return;
      }
      this.lines[line] = new paper.Rectangle(point, new paper.Size(PADDING, 0));
      this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
      _ref = this.lineGroups[line];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        element.setLeftCenter(line, new paper.Point(this.lines[line].right, point.y));
        this.lines[line] = this.lines[line].unite(element.lines[line]);
      }
      leftCenter = this.lines[line].leftCenter;
      this.lines[line].width += PADDING;
      this.lines[line].height += PADDING * 2;
      return this.lines[line].point = point.subtract(0, this.lines[line].height / 2);
    };

    BlockPaper.prototype.translate = function(vector) {
      var child, line, _i, _len, _ref, _results;
      if (this._container != null) {
        this._container.translate(vector);
      }
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

    return BlockPaper;

  })(IcePaper);

  TextTokenPaper = (function(_super) {
    __extends(TextTokenPaper, _super);

    function TextTokenPaper(block) {
      this.block = block;
    }

    TextTokenPaper.prototype.compute = function(state) {
      this.text = new paper.PointText(new paper.Point(0, 0));
      this.text.content = this.block.value;
      this.text.fillColor = 'black';
      this.text.font = 'Courier New';
      this.group = new paper.Group([this.text]);
      this.lines = {};
      this.lines[state.line] = this.text.bounds;
      this.line = state.line;
      return this;
    };

    TextTokenPaper.prototype.draw = function() {};

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
    var a;
    if (!window.RUN_PAPER_TESTS) {
      return;
    }
    paper.setup(document.getElementById('canvas'));
    a = ICE.indentParse('window.onload = ->\n  paper.setup document.getElementById \'canvas\'\n  for i in [1..4]\n    square = paper.Path new paper.Rectangle\n      point: new paper.Point i, i\n      size: new paper.Size i, i\n    paper.view.draw()\n    if i % 2 is 0\n      alert \'even\'\n      if i is nested\n        nesting\n          nesting\n            nesting\n    else\n      alert \'bad\'\n  if done_drawing()\n    alert \'done drawing\'');
    a.block.paper.compute({
      line: 0
    });
    a.block.paper.draw();
    return paper.view.draw();
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/