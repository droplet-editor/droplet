/*
# A RecomputeState is a vanilla stack
*/


(function() {
  var Block, BlockEndToken, BlockStartToken, NewlineToken, RecomputeState, Socket, TextToken, Token, lispParse,
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

    function NewlineToken() {
      this.prev = this.next = null;
    }

    NewlineToken.prototype.toString = function() {
      return '\n' + (this.next ? this.next.toString() : '');
    };

    return NewlineToken;

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

  window.ICE = {
    lispParse: lispParse
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/