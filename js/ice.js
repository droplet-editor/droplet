(function() {
  var Block, BlockPaper, Socket;

  Socket = (function() {
    function Socket(type, child) {}

    return Socket;

  })();

  Block = (function() {
    /*
    # A Block is the tree node associated with a draggable ICE Block.
    */

    function Block(parent, type, sockets) {
      this.parent = parent;
      this.sockets = sockets || [];
      this.type = type;
      this.previous = null;
      this.next = null;
      this.block = new BlockPaper(this, {});
    }

    Block.prototype.toString = function() {
      var socket;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = this.sockets;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          socket = _ref[_i];
          _results.push(socket.toString());
        }
        return _results;
      }).call(this)).join('');
    };

    Block.prototype.stringify = function() {
      if (this.next != null) {
        return this.toString() + '\n' + this.next.stringify();
      } else {
        return this.toString();
      }
    };

    return Block;

  })();

  BlockPaper = (function() {
    function BlockPaper(tree, options) {
      options = _.extend({
        position: new paper.Point(0, 0),
        width: 100
      }, options);
      this._width = options.width;
      this.tree = tree;
      this.block = new paper.Path({
        segments: [[0, 0], [10, 0], [20, 5], [30, 0], [this._width, 0], [this._width, 30], [30, 30], [20, 35], [10, 30], [0, 30], [0, 0]],
        fillColor: '#000'
      });
      this.drop = new paper.Path({
        segments: [[0, 25], [10, 25], [20, 30], [30, 25], [100, 25], [100, 35], [30, 35], [20, 40], [10, 35], [0, 35], [0, 25]]
      });
      this.hang = new paper.Path({
        segments: [[0, 5], [10, 5], [20, 10], [30, 5], [100, 5], [100, -10], [30, -10], [20, -5], [10, -10], [0, -10], [0, 5]]
      });
      this.unit = new paper.Group([this.block, this.drop, this.hang]);
      this.unit.translate(options.position);
    }

    BlockPaper.prototype.width = function(set) {
      if (set != null) {
        this.block.segments[4].point.x += set - this._width;
        this.block.segments[5].point.x += set - this._width;
        return this._width = set;
      } else {
        return this._width;
      }
    };

    return BlockPaper;

  })();

  window.onload = function() {
    var canvas, dragging, i, paths, tool, _i, _results;
    canvas = document.getElementById('canvas');
    paper.setup(canvas);
    paths = [];
    dragging = [];
    _results = [];
    for (i = _i = 1; _i <= 5; i = ++_i) {
      paths.push(new BlockPaper(null, {
        position: new paper.Point([i * 100, i * 100])
      }));
      tool = new paper.Tool();
      tool.onMouseDown = function(event) {
        var path, _j, _len, _results1;
        dragging.length = 0;
        _results1 = [];
        for (_j = 0, _len = paths.length; _j < _len; _j++) {
          path = paths[_j];
          if (path.block.contains(event.point)) {
            dragging.push(path);
            path.width(100 + path.width());
            break;
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      };
      tool.onMouseDrag = function(event) {
        var other, path, x, _j, _k, _len, _len1, _results1;
        _results1 = [];
        for (x = _j = 0, _len = dragging.length; _j < _len; x = ++_j) {
          path = dragging[x];
          path.unit.translate(event.delta);
          for (_k = 0, _len1 = paths.length; _k < _len1; _k++) {
            other = paths[_k];
            other.drop.fillColor = null;
          }
          _results1.push((function() {
            var _l, _len2, _results2;
            _results2 = [];
            for (_l = 0, _len2 = paths.length; _l < _len2; _l++) {
              other = paths[_l];
              if (other !== path && path.hang.getIntersections(other.drop).length > 0) {
                other.drop.fillColor = 'red';
                break;
              } else {
                _results2.push(void 0);
              }
            }
            return _results2;
          })());
        }
        return _results1;
      };
      _results.push(tool.onMouseUp = function(event) {
        var other, path, x, _j, _k, _len, _len1, _results1;
        _results1 = [];
        for (x = _j = 0, _len = dragging.length; _j < _len; x = ++_j) {
          path = dragging[x];
          for (_k = 0, _len1 = paths.length; _k < _len1; _k++) {
            other = paths[_k];
            other.drop.fillColor = null;
          }
          _results1.push((function() {
            var _l, _len2, _results2;
            _results2 = [];
            for (_l = 0, _len2 = paths.length; _l < _len2; _l++) {
              other = paths[_l];
              if (other !== path && path.hang.getIntersections(other.drop).length > 0) {
                other.drop.fillColor = 'red';
                console.log(other.drop.position.toString(), path.hang.position.toString());
                path.unit.translate(other.drop.position.subtract(path.hang.position));
                break;
              } else {
                _results2.push(void 0);
              }
            }
            return _results2;
          })());
        }
        return _results1;
      });
    }
    return _results;
  };

}).call(this);

/*
//@ sourceMappingURL=ice.js.map
*/