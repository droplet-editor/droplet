(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['ice-draw'], function(draw) {
    var BlockView, BoundingBoxState, CursorView, DROP_AREA_HEIGHT, EMPTY_INDENT_HEIGHT, EMPTY_INDENT_WIDTH, EMPTY_SOCKET_HEIGHT, EMPTY_SOCKET_WIDTH, FONT_HEIGHT, INDENT_SPACING, IceView, IndentView, MIN_SEGMENT_DROP_AREA_WIDTH, PADDING, PathWaypoint, SOCKET_DROP_PADDING, SegmentView, SocketView, TAB_HEIGHT, TAB_OFFSET, TAB_WIDTH, TOUNGE_HEIGHT, TextView, exports;
    PADDING = 5;
    INDENT_SPACING = 15;
    TOUNGE_HEIGHT = 10;
    FONT_HEIGHT = 15;
    EMPTY_SOCKET_HEIGHT = FONT_HEIGHT + PADDING * 2;
    EMPTY_SOCKET_WIDTH = 20;
    EMPTY_INDENT_HEIGHT = FONT_HEIGHT + PADDING * 2;
    EMPTY_INDENT_WIDTH = 50;
    MIN_SEGMENT_DROP_AREA_WIDTH = 100;
    DROP_AREA_HEIGHT = 30;
    TAB_WIDTH = 15;
    TAB_HEIGHT = 5;
    TAB_OFFSET = 10;
    SOCKET_DROP_PADDING = 3;
    exports = {};
    exports.BoundingBoxState = BoundingBoxState = (function() {
      function BoundingBoxState(point) {
        this.x = point.x;
        this.y = point.y;
      }

      return BoundingBoxState;

    })();
    exports.PathWaypoint = PathWaypoint = (function() {
      function PathWaypoint(left, right) {
        this.left = left;
        this.right = right;
      }

      return PathWaypoint;

    })();
    exports.IceView = IceView = (function() {
      function IceView(block) {
        this.block = block;
        this.children = [];
        this.lineStart = this.lineEnd = null;
        this.lineChildren = {};
        this.dimensions = {};
        this.cursors = [];
        this.dropArea = null;
        this.highlightArea = null;
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
        this.dropArea = this.highlightArea = null;
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
          cursor.token.view.point.y = yCoordinate;
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
    exports.BlockView = BlockView = (function(_super) {
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
              height = Math.max(height, child.dimensions[line].height + (child.lineEnd === line && child.indentEndsOn[line] ? TOUNGE_HEIGHT : 0));
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
        if (this.lineChildren[line].length > 0 && this.lineChildren[line][0].lineEnd === line && this.lineChildren[line][0].indentEndsOn[line]) {
          axis -= TOUNGE_HEIGHT / 2;
        }
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
          return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
        } else if (this.lineChildren[line].length > 0) {
          if (line === this.lineChildren[line][0].lineEnd && (this.lineChildren[line][0].indentEndsOn[line] || this.lineChildren[line][0].block.type === 'indent')) {
            indentChild = this.lineChildren[line][0];
            paddingLeft = this.lineChildren[line][0].block.type === 'indent' ? INDENT_SPACING : PADDING;
            if (this.lineChildren[line].length === 1) {
              return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
            } else {
              return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + paddingLeft, this.bounds[line].y), new draw.Point(this.bounds[line].x + paddingLeft, indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), indentChild.bounds[line].bottom()), new draw.Point(indentChild.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].y), new draw.Point(this.bounds[line].right(), this.bounds[line].bottom())]);
            }
          } else {
            return this.pathWaypoints[line] = new PathWaypoint([new draw.Point(this.bounds[line].x, this.bounds[line].y), new draw.Point(this.bounds[line].x, this.bounds[line].bottom())], [new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].y), new draw.Point(this.bounds[line].x + INDENT_SPACING, this.bounds[line].bottom())]);
          }
        }
      };

      BlockView.prototype.computePath = function() {
        var entryPoint, line, point, waypoint, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3, _ref4;
        BlockView.__super__.computePath.apply(this, arguments);
        this.path = new draw.Path();
        this.dropArea = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - DROP_AREA_HEIGHT / 2, this.bounds[this.lineEnd].width, DROP_AREA_HEIGHT);
        this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineEnd].x, this.bounds[this.lineEnd].bottom() - 5, this.bounds[this.lineEnd].width, 10);
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
    exports.TextView = TextView = (function(_super) {
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

      TextView.prototype.computePlaintextTranslationVector = function(state, ctx) {
        var point;
        point = new draw.Point(state.x, state.y);
        state.x += ctx.measureText(this.block.value).width;
        return point.from(new draw.Point(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y));
      };

      return TextView;

    })(IceView);
    exports.IndentView = IndentView = (function(_super) {
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
        this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - DROP_AREA_HEIGHT / 2, this.bounds[this.lineStart].width, DROP_AREA_HEIGHT);
        this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
        return IndentView.__super__.computePath.apply(this, arguments);
      };

      return IndentView;

    })(IceView);
    exports.SocketView = SocketView = (function(_super) {
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
          this.dropHighlightReigon = new draw.Rectangle(this.dropArea.x - SOCKET_DROP_PADDING, this.dropArea.y - SOCKET_DROP_PADDING, this.dropArea.width + SOCKET_DROP_PADDING * 2, this.dropArea.height + SOCKET_DROP_PADDING * 2);
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
    exports.SegmentView = SegmentView = (function(_super) {
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

      SegmentView.prototype.drawPath = function() {
        this.dropArea = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, Math.max(this.bounds[this.lineStart].width, MIN_SEGMENT_DROP_AREA_WIDTH), 10);
        this.dropHighlightReigon = new draw.Rectangle(this.bounds[this.lineStart].x, this.bounds[this.lineStart].y - 5, this.bounds[this.lineStart].width, 10);
        return SegmentView.__super__.drawPath.apply(this, arguments);
      };

      return SegmentView;

    })(IceView);
    exports.CursorView = CursorView = (function() {
      function CursorView(block) {
        this.block = block;
        this.point = new draw.Point(0, 0);
      }

      return CursorView;

    })();
    return exports;
  });

}).call(this);

/*
//@ sourceMappingURL=view.js.map
*/