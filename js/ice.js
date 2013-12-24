(function() {
  var Block, Socket, State, defaultState, defaultStateElement;

  State = (function() {
    /*
    # RecomputeState is just a stack.
    */

    function State(elements) {
      var element, _i, _len;
      this.stack = {
        next: null,
        element: null
      };
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        this.push(element);
      }
    }

    State.prototype.pop = function() {
      return this.stack = this.stack.next;
    };

    State.prototype.push = function(element) {
      var new_stack;
      new_stack = {
        next: this.stack,
        element: element
      };
      return this.stack = new_stack;
    };

    State.prototype.first = function() {
      return this.stack.element;
    };

    return State;

  })();

  /*
  # The "default" state for when we know nothing about a block or field
  */


  defaultStateElement = function() {
    return {
      multiline: false
    };
  };

  defaultState = function() {
    return new State([defaultStateElement()]);
  };

  /*
  # A Block is the draggable wrapper for Sockets
  */


  Block = (function() {
    function Block(prev, next) {
      this.prev = prev;
      this.next = next;
      this.paper = null;
      this.multiline = false;
    }

    Block.prototype.moveTo = function(socket) {
      this.prev.empty();
      this.prev = null;
      socket.empty();
      this.prev = socket;
      this.next = socket.next;
      socket.insert(this);
      return this.next.recompute(new State([
        {
          multiline: this.multiline
        }
      ]));
    };

    Block.prototype.recompute = function(state) {
      state.push(defaultStateElement());
      return this.next.recompute(state);
    };

    Block.prototype._endRecompute = function(state, next) {
      this.multiline = state.first.multiline;
      state.pop();
      if (next.type !== 'connection') {
        state.first.multiline = this.multiline;
      }
      return next.recompute(state);
    };

    Block.prototype.stringify = function() {
      return this.next.stringify;
    };

    return Block;

  })();

  Socket = (function() {
    function Socket(prev, next) {
      this.prev = prev;
      this.next = next;
      this.paper = null;
      this.multiline = false;
      this.type = null;
    }

    Socket.prototype.empty = function() {
      return this.next = this.next.next;
    };

    Socket.prototype.insert = function(next) {
      return this.next = next;
    };

    Socket.prototype.recompute = function(state) {
      if (type === 'end') {
        return this.block._endRecompute(state, this.next);
      } else {
        return this.next.recompute(state);
      }
    };

    Socket.prototype.stringify = function() {
      var string;
      return string = typeof value === 'string' || value instanceof String ? value : '';
    };

    return Socket;

  })();

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/