(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

  define(['droplet-helper', 'droplet-draw', 'droplet-model'], function(helper, draw, model) {
    var ANY_DROP, BLOCK_ONLY, CARRIAGE_ARROW_INDENT, CARRIAGE_ARROW_NONE, CARRIAGE_ARROW_SIDEALONG, CARRIAGE_GROW_DOWN, DEFAULT_OPTIONS, MOSTLY_BLOCK, MOSTLY_VALUE, MULTILINE_END, MULTILINE_END_START, MULTILINE_MIDDLE, MULTILINE_START, NO, NO_MULTILINE, VALUE_ONLY, View, YES, arrayEq, avgColor, defaultStyleObject, exports, toHex, toRGB, twoDigitHex, zeroPad;
    NO_MULTILINE = 0;
    MULTILINE_START = 1;
    MULTILINE_MIDDLE = 2;
    MULTILINE_END = 3;
    MULTILINE_END_START = 4;
    ANY_DROP = helper.ANY_DROP;
    BLOCK_ONLY = helper.BLOCK_ONLY;
    MOSTLY_BLOCK = helper.MOSTLY_BLOCK;
    MOSTLY_VALUE = helper.MOSTLY_VALUE;
    VALUE_ONLY = helper.VALUE_ONLY;
    CARRIAGE_ARROW_SIDEALONG = 0;
    CARRIAGE_ARROW_INDENT = 1;
    CARRIAGE_ARROW_NONE = 2;
    CARRIAGE_GROW_DOWN = 3;
    DEFAULT_OPTIONS = {
      buttonWidth: 13,
      buttonHeight: 13,
      buttonPadding: 10,
      buttonOffset: 5,
      padding: 5,
      indentWidth: 10,
      indentTongueHeight: 10,
      tabOffset: 10,
      tabWidth: 15,
      tabHeight: 5,
      tabSideWidth: 0.125,
      dropAreaHeight: 20,
      indentDropAreaMinWidth: 50,
      minSocketWidth: 10,
      textHeight: 15,
      textPadding: 1,
      emptyLineWidth: 50,
      highlightAreaHeight: 10,
      bevelClip: 3,
      shadowBlur: 5,
      ctx: document.createElement('canvas').getContext('2d'),
      colors: {
        error: '#ff0000',
        "return": '#fff59d',
        control: '#ffcc80',
        value: '#a5d6a7',
        command: '#90caf9',
        red: '#ef9a9a',
        pink: '#f48fb1',
        purple: '#ce93d8',
        deeppurple: '#b39ddb',
        indigo: '#9fa8da',
        blue: '#90caf9',
        lightblue: '#81d4fa',
        cyan: '#80deea',
        teal: '#80cbc4',
        green: '#a5d6a7',
        lightgreen: '#c5e1a5',
        lime: '#e6ee9c',
        yellow: '#fff59d',
        amber: '#ffe082',
        orange: '#ffcc80',
        deeporange: '#ffab91',
        brown: '#bcaaa4',
        grey: '#eeeeee',
        bluegrey: '#b0bec5'
      }
    };
    YES = function() {
      return true;
    };
    NO = function() {
      return false;
    };
    exports = {};
    defaultStyleObject = function() {
      return {
        selected: 0,
        grayscale: 0
      };
    };
    arrayEq = function(a, b) {
      var i, k;
      if (a.length !== b.length) {
        return false;
      }
      if ((function() {
        var j, len1, results;
        results = [];
        for (i = j = 0, len1 = a.length; j < len1; i = ++j) {
          k = a[i];
          results.push(k !== b[i]);
        }
        return results;
      })()) {
        return false;
      }
      return true;
    };
    exports.View = View = (function() {
      var BlockViewNode, ContainerViewNode, CursorViewNode, GenericViewNode, IndentViewNode, SegmentViewNode, SocketViewNode, TextViewNode;

      function View(opts) {
        var option, ref;
        this.opts = opts != null ? opts : {};
        this.map = {};
        this.draw = (ref = this.opts.draw) != null ? ref : new draw.Draw();
        for (option in DEFAULT_OPTIONS) {
          if (!(option in this.opts)) {
            this.opts[option] = DEFAULT_OPTIONS[option];
          }
        }
        this.draw.setCtx(this.opts.ctx);
      }

      View.prototype.clearCache = function() {
        return this.map = {};
      };

      View.prototype.getViewNodeFor = function(model) {
        if (model.id in this.map) {
          return this.map[model.id];
        } else {
          return this.createView(model);
        }
      };

      View.prototype.hasViewNodeFor = function(model) {
        return (model != null) && model.id in this.map;
      };

      View.prototype.createView = function(model) {
        switch (model.type) {
          case 'text':
            return new TextViewNode(model, this);
          case 'block':
            return new BlockViewNode(model, this);
          case 'indent':
            return new IndentViewNode(model, this);
          case 'socket':
            return new SocketViewNode(model, this);
          case 'segment':
            return new SegmentViewNode(model, this);
          case 'cursor':
            return new CursorViewNode(model, this);
        }
      };

      View.prototype.getColor = function(color) {
        var ref;
        if (color && '#' === color.charAt(0)) {
          return color;
        } else {
          return (ref = this.opts.colors[color]) != null ? ref : '#ffffff';
        }
      };

      GenericViewNode = (function() {
        function GenericViewNode(model1, view1) {
          this.model = model1;
          this.view = view1;
          this.view.map[this.model.id] = this;
          this.invalidate = false;
          this.lineLength = 0;
          this.children = [];
          this.lineChildren = [];
          this.multilineChildrenData = [];
          this.margins = {
            left: 0,
            right: 0,
            top: 0,
            bottom: 0
          };
          this.topLineSticksToBottom = false;
          this.bottomLineSticksToTop = false;
          this.minDimensions = [];
          this.minDistanceToBase = [];
          this.dimensions = [];
          this.distanceToBase = [];
          this.bevels = {
            topLeft: false,
            topRight: false,
            bottomLeft: false,
            bottomRight: false
          };
          this.bounds = [];
          this.changedBoundingBox = true;
          this.glue = {};
          this.path = new this.view.draw.Path();
          this.dropArea = this.highlightArea = null;
          this.computedVersion = -1;
        }

        GenericViewNode.prototype.serialize = function(line) {
          var child, i, j, l, len1, len2, len3, len4, len5, len6, m, o, p, prop, q, ref, ref1, ref2, ref3, ref4, ref5, ref6, result, s;
          result = [];
          ref = ['lineLength', 'margins', 'topLineSticksToBottom', 'bottomLineSticksToTop', 'changedBoundingBox', 'path', 'highlightArea', 'computedVersion', 'carriageArrow', 'bevels'];
          for (j = 0, len1 = ref.length; j < len1; j++) {
            prop = ref[j];
            result.push(prop + ': ' + JSON.stringify(this[prop]));
          }
          ref1 = this.children;
          for (i = l = 0, len2 = ref1.length; l < len2; i = ++l) {
            child = ref1[i];
            result.push(("child " + i + ": {startLine: " + child.startLine + ", ") + ("endLine: " + child.endLine + "}"));
          }
          if (line != null) {
            ref2 = ['multilineChildrenData', 'minDimensions', 'minDistanceToBase', 'dimensions', 'distanceToBase', 'bounds', 'glue'];
            for (m = 0, len3 = ref2.length; m < len3; m++) {
              prop = ref2[m];
              result.push(prop + " " + line + ": " + (JSON.stringify(this[prop][line])));
            }
            ref3 = this.lineChildren[line];
            for (i = o = 0, len4 = ref3.length; o < len4; i = ++o) {
              child = ref3[i];
              result.push(("line " + line + " child " + i + ": ") + ("{startLine: " + child.startLine + ", ") + ("endLine: " + child.endLine + "}}"));
            }
          } else {
            for (line = p = 0, ref4 = this.lineLength; 0 <= ref4 ? p < ref4 : p > ref4; line = 0 <= ref4 ? ++p : --p) {
              ref5 = ['multilineChildrenData', 'minDimensions', 'minDistanceToBase', 'dimensions', 'distanceToBase', 'bounds', 'glue'];
              for (q = 0, len5 = ref5.length; q < len5; q++) {
                prop = ref5[q];
                result.push(prop + " " + line + ": " + (JSON.stringify(this[prop][line])));
              }
              ref6 = this.lineChildren[line];
              for (i = s = 0, len6 = ref6.length; s < len6; i = ++s) {
                child = ref6[i];
                result.push(("line " + line + " child " + i + ": ") + ("{startLine: " + child.startLine + ", ") + ("endLine: " + child.endLine + "}}"));
              }
            }
          }
          return result.join('\n');
        };

        GenericViewNode.prototype.computeChildren = function() {
          return this.lineLength;
        };

        GenericViewNode.prototype.computeCarriageArrow = function() {
          return this.carriageArrow = CARRIAGE_ARROW_NONE;
        };

        GenericViewNode.prototype.computeMargins = function() {
          var childObj, j, left, len1, padding, parenttype, ref, ref1, right;
          if (this.computedVersion === this.model.version && ((this.model.parent == null) || this.model.parent.version === this.view.getViewNodeFor(this.model.parent).computedVersion)) {
            return this.margins;
          }
          parenttype = (ref = this.model.parent) != null ? ref.type : void 0;
          padding = this.view.opts.padding;
          left = this.model.isFirstOnLine() || this.lineLength > 1 ? padding : 0;
          right = this.model.isLastOnLine() || this.lineLength > 1 ? padding : 0;
          if (parenttype === 'block' && this.model.type === 'indent') {
            this.margins = {
              top: this.view.opts.padding,
              bottom: this.lineLength > 1 ? this.view.opts.indentTongueHeight : this.view.opts.padding,
              firstLeft: 0,
              midLeft: this.view.opts.indentWidth,
              lastLeft: this.view.opts.indentWidth,
              firstRight: 0,
              midRight: 0,
              lastRight: padding
            };
          } else if (this.model.type === 'text' && parenttype === 'socket') {
            this.margins = {
              top: this.view.opts.textPadding,
              bottom: this.view.opts.textPadding,
              firstLeft: this.view.opts.textPadding,
              midLeft: this.view.opts.textPadding,
              lastLeft: this.view.opts.textPadding,
              firstRight: this.view.opts.textPadding,
              midRight: this.view.opts.textPadding,
              lastRight: this.view.opts.textPadding
            };
          } else if (this.model.type === 'text' && parenttype === 'block') {
            this.margins = {
              top: padding,
              bottom: padding,
              firstLeft: left,
              midLeft: left,
              lastLeft: left,
              firstRight: right,
              midRight: right,
              lastRight: right
            };
          } else if (parenttype === 'block') {
            this.margins = {
              top: padding,
              bottom: padding,
              firstLeft: left,
              midLeft: padding,
              lastLeft: padding,
              firstRight: right,
              midRight: 0,
              lastRight: right
            };
          } else {
            this.margins = {
              firstLeft: 0,
              midLeft: 0,
              lastLeft: 0,
              firstRight: 0,
              midRight: 0,
              lastRight: 0,
              top: 0,
              bottom: 0
            };
          }
          this.firstMargins = {
            left: this.margins.firstLeft,
            right: this.margins.firstRight,
            top: this.margins.top,
            bottom: this.lineLength === 1 ? this.margins.bottom : 0
          };
          this.midMargins = {
            left: this.margins.midLeft,
            right: this.margins.midRight,
            top: 0,
            bottom: 0
          };
          this.lastMargins = {
            left: this.margins.lastLeft,
            right: this.margins.lastRight,
            top: this.lineLength === 1 ? this.margins.top : 0,
            bottom: this.margins.bottom
          };
          ref1 = this.children;
          for (j = 0, len1 = ref1.length; j < len1; j++) {
            childObj = ref1[j];
            this.view.getViewNodeFor(childObj.child).computeMargins();
          }
          return null;
        };

        GenericViewNode.prototype.getMargins = function(line) {
          if (line === 0) {
            return this.firstMargins;
          } else if (line === this.lineLength - 1) {
            return this.lastMargins;
          } else {
            return this.midMargins;
          }
        };

        GenericViewNode.prototype.computeBevels = function() {
          return this.bevels = {
            topLeft: false,
            topRight: false,
            bottomLeft: false,
            bottomRight: false
          };
        };

        GenericViewNode.prototype.computeMinDimensions = function() {
          var i, j, ref;
          if (this.minDimensions.length > this.lineLength) {
            this.minDimensions.length = this.minDistanceToBase.length = this.lineLength;
          } else {
            while (this.minDimensions.length !== this.lineLength) {
              this.minDimensions.push(new this.view.draw.Size(0, 0));
              this.minDistanceToBase.push({
                above: 0,
                below: 0
              });
            }
          }
          for (i = j = 0, ref = this.lineLength; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
            this.minDimensions[i].width = this.minDimensions[i].height = 0;
            this.minDistanceToBase[i].above = this.minDistanceToBase[i].below = 0;
          }
          return null;
        };

        GenericViewNode.prototype.computeDimensions = function(startLine, force, root) {
          var changed, childObj, distance, i, j, l, len1, len2, line, lineCount, m, oldDimensions, oldDistanceToBase, parentNode, ref, ref1, ref2, size;
          if (root == null) {
            root = false;
          }
          if (this.computedVersion === this.model.version && !force && !this.invalidate) {
            return;
          }
          oldDimensions = this.dimensions;
          oldDistanceToBase = this.distanceToBase;
          this.dimensions = (function() {
            var j, ref, results;
            results = [];
            for (j = 0, ref = this.lineLength; 0 <= ref ? j < ref : j > ref; 0 <= ref ? j++ : j--) {
              results.push(new this.view.draw.Size(0, 0));
            }
            return results;
          }).call(this);
          this.distanceToBase = (function() {
            var j, ref, results;
            results = [];
            for (j = 0, ref = this.lineLength; 0 <= ref ? j < ref : j > ref; 0 <= ref ? j++ : j--) {
              results.push({
                above: 0,
                below: 0
              });
            }
            return results;
          }).call(this);
          ref = this.minDimensions;
          for (i = j = 0, len1 = ref.length; j < len1; i = ++j) {
            size = ref[i];
            this.dimensions[i].width = size.width;
            this.dimensions[i].height = size.height;
            this.distanceToBase[i].above = this.minDistanceToBase[i].above;
            this.distanceToBase[i].below = this.minDistanceToBase[i].below;
          }
          if ((this.model.parent != null) && !root && (this.topLineSticksToBottom || this.bottomLineSticksToTop || (this.lineLength > 1 && !this.model.isLastOnLine()))) {
            parentNode = this.view.getViewNodeFor(this.model.parent);
            if (this.topLineSticksToBottom) {
              distance = this.distanceToBase[0];
              distance.below = Math.max(distance.below, parentNode.distanceToBase[startLine].below);
              this.dimensions[0] = new this.view.draw.Size(this.dimensions[0].width, distance.below + distance.above);
            }
            if (this.bottomLineSticksToTop) {
              lineCount = this.distanceToBase.length;
              distance = this.distanceToBase[lineCount - 1];
              distance.above = Math.max(distance.above, parentNode.distanceToBase[startLine + lineCount - 1].above);
              this.dimensions[lineCount - 1] = new this.view.draw.Size(this.dimensions[lineCount - 1].width, distance.below + distance.above);
            }
            if (this.lineLength > 1 && !this.model.isLastOnLine() && this.model.type === 'block') {
              distance = this.distanceToBase[this.lineLength - 1];
              distance.below = parentNode.distanceToBase[startLine + this.lineLength - 1].below;
              this.dimensions[lineCount - 1] = new this.view.draw.Size(this.dimensions[lineCount - 1].width, distance.below + distance.above);
            }
          }
          changed = oldDimensions.length !== this.lineLength;
          if (!changed) {
            for (line = l = 0, ref1 = this.lineLength; 0 <= ref1 ? l < ref1 : l > ref1; line = 0 <= ref1 ? ++l : --l) {
              if (!oldDimensions[line].equals(this.dimensions[line]) || oldDistanceToBase[line].above !== this.distanceToBase[line].above || oldDistanceToBase[line].below !== this.distanceToBase[line].below) {
                changed = true;
                break;
              }
            }
          }
          this.changedBoundingBox || (this.changedBoundingBox = changed);
          ref2 = this.children;
          for (m = 0, len2 = ref2.length; m < len2; m++) {
            childObj = ref2[m];
            if (indexOf.call(this.lineChildren[0], childObj) >= 0 || indexOf.call(this.lineChildren[this.lineLength - 1], childObj) >= 0) {
              this.view.getViewNodeFor(childObj.child).computeDimensions(childObj.startLine, changed);
            } else {
              this.view.getViewNodeFor(childObj.child).computeDimensions(childObj.startLine, false);
            }
          }
          return null;
        };

        GenericViewNode.prototype.computeBoundingBoxX = function(left, line) {
          var ref, ref1, ref2;
          if (this.computedVersion === this.model.version && left === ((ref = this.bounds[line]) != null ? ref.x : void 0) && !this.changedBoundingBox || ((ref1 = this.bounds[line]) != null ? ref1.x : void 0) === left && ((ref2 = this.bounds[line]) != null ? ref2.width : void 0) === this.dimensions[line].width) {
            return this.bounds[line];
          }
          this.changedBoundingBox = true;
          if (this.bounds[line] != null) {
            this.bounds[line].x = left;
            this.bounds[line].width = this.dimensions[line].width;
          } else {
            this.bounds[line] = new this.view.draw.Rectangle(left, 0, this.dimensions[line].width, 0);
          }
          return this.bounds[line];
        };

        GenericViewNode.prototype.computeAllBoundingBoxX = function(left) {
          var j, len1, line, ref, size;
          if (left == null) {
            left = 0;
          }
          ref = this.dimensions;
          for (line = j = 0, len1 = ref.length; j < len1; line = ++j) {
            size = ref[line];
            this.computeBoundingBoxX(left, line);
          }
          return this.bounds;
        };

        GenericViewNode.prototype.computeGlue = function() {
          return this.glue = {};
        };

        GenericViewNode.prototype.computeBoundingBoxY = function(top, line) {
          var ref;
          if (this.computedVersion === this.model.version && top === ((ref = this.bounds[line]) != null ? ref.y : void 0) && !this.changedBoundingBox || this.bounds[line].y === top && this.bounds[line].height === this.dimensions[line].height) {
            return this.bounds[line];
          }
          this.changedBoundingBox = true;
          this.bounds[line].y = top;
          this.bounds[line].height = this.dimensions[line].height;
          return this.bounds[line];
        };

        GenericViewNode.prototype.computeAllBoundingBoxY = function(top) {
          var j, len1, line, ref, size;
          if (top == null) {
            top = 0;
          }
          ref = this.dimensions;
          for (line = j = 0, len1 = ref.length; j < len1; line = ++j) {
            size = ref[line];
            this.computeBoundingBoxY(top, line);
            top += size.height;
            if (line in this.glue) {
              top += this.glue[line].height;
            }
          }
          return this.bounds;
        };

        GenericViewNode.prototype.getBounds = function() {
          return this.totalBounds;
        };

        GenericViewNode.prototype.computeOwnPath = function() {
          return this.path = new this.view.draw.Path();
        };

        GenericViewNode.prototype.computePath = function() {
          var bound, child, childObj, j, l, len1, len2, len3, m, maxRight, ref, ref1, ref2;
          if (this.computedVersion === this.model.version && (this.model.isLastOnLine() === this.lastComputedLinePredicate) && !this.changedBoundingBox) {
            return null;
          }
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).computePath();
          }
          if (this.changedBoundingBox || (this.model.isLastOnLine() !== this.lastComputedLinePredicate)) {
            this.computeOwnPath();
            this.totalBounds = new this.view.draw.NoRectangle();
            if (this.bounds.length > 0) {
              this.totalBounds.unite(this.bounds[0]);
              this.totalBounds.unite(this.bounds[this.bounds.length - 1]);
            }
            if (this.bounds.length > this.children.length) {
              ref1 = this.children;
              for (l = 0, len2 = ref1.length; l < len2; l++) {
                child = ref1[l];
                this.totalBounds.unite(this.view.getViewNodeFor(child.child).totalBounds);
              }
            } else {
              maxRight = this.totalBounds.right();
              ref2 = this.bounds;
              for (m = 0, len3 = ref2.length; m < len3; m++) {
                bound = ref2[m];
                this.totalBounds.x = Math.min(this.totalBounds.x, bound.x);
                maxRight = Math.max(maxRight, bound.right());
              }
              this.totalBounds.width = maxRight - this.totalBounds.x;
            }
            this.totalBounds.unite(this.path.bounds());
          }
          this.lastComputedLinePredicate = this.model.isLastOnLine();
          return null;
        };

        GenericViewNode.prototype.computeOwnDropArea = function() {};

        GenericViewNode.prototype.computeDropAreas = function() {
          var childObj, j, len1, ref;
          if (this.computedVersion === this.model.version && !this.changedBoundingBox) {
            return null;
          }
          this.computeOwnDropArea();
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).computeDropAreas();
          }
          return null;
        };

        GenericViewNode.prototype.computeNewVersionNumber = function() {
          var childObj, j, len1, ref;
          if (this.computedVersion === this.model.version && !this.changedBoundingBox) {
            return null;
          }
          this.changedBoundingBox = false;
          this.invalidate = false;
          this.computedVersion = this.model.version;
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).computeNewVersionNumber();
          }
          return null;
        };

        GenericViewNode.prototype.drawSelf = function(ctx, style) {};

        GenericViewNode.prototype.draw = function(ctx, boundingRect, style) {
          var childObj, j, len1, ref;
          if (this.totalBounds.overlap(boundingRect)) {
            if (style == null) {
              style = defaultStyleObject();
            }
            if (this.model.ephemeral && this.view.opts.respectEphemeral) {
              style.grayscale++;
            }
            this.drawSelf(ctx, style);
            ref = this.children;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              childObj = ref[j];
              this.view.getViewNodeFor(childObj.child).draw(ctx, boundingRect, style);
            }
            if (this.model.ephemeral && this.view.opts.respectEphemeral) {
              style.grayscale--;
            }
          }
          return null;
        };

        GenericViewNode.prototype.drawShadow = function(ctx) {};

        GenericViewNode.prototype.debugDimensions = function(x, y, line, ctx) {
          var childObj, childView, j, len1, ref, results;
          ctx.fillStyle = '#00F';
          ctx.strokeStyle = '#000';
          ctx.lineWidth = 1;
          ctx.fillRect(x, y, this.dimensions[line].width, this.dimensions[line].height);
          ctx.strokeRect(x, y, this.dimensions[line].width, this.dimensions[line].height);
          ref = this.lineChildren[line];
          results = [];
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            childView = this.view.getViewNodeFor(childObj.child);
            x += childView.getMargins(line).left;
            childView.debugDimensions(x, y, line - childObj.startLine, ctx);
            results.push(x += childView.dimensions[line - childObj.startLine].width + childView.getMargins(line).right);
          }
          return results;
        };

        GenericViewNode.prototype.debugAllDimensions = function(ctx) {
          var j, len1, line, ref, size, y;
          ctx.globalAlpha = 0.1;
          y = 0;
          ref = this.dimensions;
          for (line = j = 0, len1 = ref.length; j < len1; line = ++j) {
            size = ref[line];
            this.debugDimensions(0, y, line, ctx);
            y += size.height;
          }
          return ctx.globalAlpha = 1;
        };

        GenericViewNode.prototype.debugAllBoundingBoxes = function(ctx) {
          var bound, childObj, j, l, len1, len2, ref, ref1;
          ctx.globalAlpha = 0.1;
          ref = this.bounds;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            bound = ref[j];
            bound.fill(ctx, '#00F');
            bound.stroke(ctx, '#000');
          }
          ref1 = this.children;
          for (l = 0, len2 = ref1.length; l < len2; l++) {
            childObj = ref1[l];
            this.view.getViewNodeFor(childObj.child).debugAllBoundingBoxes(ctx);
          }
          return ctx.globalAlpha = 1;
        };

        return GenericViewNode;

      })();

      ContainerViewNode = (function(superClass) {
        extend(ContainerViewNode, superClass);

        function ContainerViewNode(model1, view1) {
          this.model = model1;
          this.view = view1;
          ContainerViewNode.__super__.constructor.apply(this, arguments);
        }

        ContainerViewNode.prototype.computeChildren = function() {
          var base, i, j, line, ref;
          if (this.computedVersion === this.model.version) {
            return this.lineLength;
          }
          this.lineLength = 0;
          this.lineChildren = [[]];
          this.children = [];
          this.multilineChildrenData = [];
          this.topLineSticksToBottom = false;
          this.bottomLineSticksToTop = false;
          line = 0;
          this.model.traverseOneLevel((function(_this) {
            return function(head, isContainer) {
              var base, base1, childLength, childObject, i, j, l, ref, ref1, ref2, ref3, view;
              if (head.type === 'newline') {
                line += 1;
                return (base = _this.lineChildren)[line] != null ? base[line] : base[line] = [];
              } else {
                view = _this.view.getViewNodeFor(head);
                childLength = view.computeChildren();
                childObject = {
                  child: head,
                  startLine: line,
                  endLine: line + childLength - 1
                };
                _this.children.push(childObject);
                for (i = j = ref = line, ref1 = line + childLength; ref <= ref1 ? j < ref1 : j > ref1; i = ref <= ref1 ? ++j : --j) {
                  if ((base1 = _this.lineChildren)[i] == null) {
                    base1[i] = [];
                  }
                  if (head.type !== 'cursor') {
                    _this.lineChildren[i].push(childObject);
                  }
                }
                if (view.lineLength > 1) {
                  if (_this.multilineChildrenData[line] === MULTILINE_END) {
                    _this.multilineChildrenData[line] = MULTILINE_END_START;
                  } else {
                    _this.multilineChildrenData[line] = MULTILINE_START;
                  }
                  for (i = l = ref2 = line + 1, ref3 = line + childLength - 1; ref2 <= ref3 ? l < ref3 : l > ref3; i = ref2 <= ref3 ? ++l : --l) {
                    _this.multilineChildrenData[i] = MULTILINE_MIDDLE;
                  }
                  _this.multilineChildrenData[line + childLength - 1] = MULTILINE_END;
                }
                return line += childLength - 1;
              }
            };
          })(this));
          this.lineLength = line + 1;
          if (this.bounds.length !== this.lineLength) {
            this.changedBoundingBox = true;
            this.bounds = this.bounds.slice(0, this.lineLength);
          }
          for (i = j = 0, ref = this.lineLength; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
            if ((base = this.multilineChildrenData)[i] == null) {
              base[i] = NO_MULTILINE;
            }
          }
          if (this.lineLength > 1) {
            this.topLineSticksToBottom = true;
            this.bottomLineSticksToTop = true;
          }
          return this.lineLength;
        };

        ContainerViewNode.prototype.computeCarriageArrow = function(root) {
          var childObj, head, j, len1, oldCarriageArrow, parent, ref;
          if (root == null) {
            root = false;
          }
          oldCarriageArrow = this.carriageArrow;
          this.carriageArrow = CARRIAGE_ARROW_NONE;
          parent = this.model.visParent();
          if ((!root) && (parent != null ? parent.type : void 0) === 'indent' && this.view.getViewNodeFor(parent).lineLength > 1 && this.lineLength === 1) {
            head = this.model.start;
            while (!(head === parent.start || head.type === 'newline')) {
              head = head.prev;
            }
            if (head === parent.start) {
              if (this.model.isLastOnLine()) {
                this.carriageArrow = CARRIAGE_ARROW_INDENT;
              } else {
                this.carriageArrow = CARRIAGE_GROW_DOWN;
              }
            } else if (!this.model.isFirstOnLine()) {
              this.carriageArrow = CARRIAGE_ARROW_SIDEALONG;
            }
          }
          if (this.carriageArrow !== oldCarriageArrow) {
            this.changedBoundingBox = true;
          }
          if (this.computedVersion === this.model.version && ((this.model.parent == null) || this.model.parent.version === this.view.getViewNodeFor(this.model.parent).computedVersion)) {
            return null;
          }
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).computeCarriageArrow();
          }
          return null;
        };

        ContainerViewNode.prototype.computeBevels = function() {
          var childObj, j, len1, oldBevels, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7;
          oldBevels = this.bevels;
          this.bevels = {
            top: true,
            bottom: true
          };
          if ((((ref = this.model.visParent()) != null ? ref.type : void 0) === 'indent' || ((ref1 = this.model.visParent()) != null ? ref1.isRoot : void 0)) && ((ref2 = this.model.start.previousAffectToken()) != null ? ref2.type : void 0) === 'newline' && ((ref3 = this.model.start.previousAffectToken()) != null ? ref3.previousAffectToken() : void 0) !== this.model.visParent().start) {
            this.bevels.top = false;
          }
          if ((((ref4 = this.model.visParent()) != null ? ref4.type : void 0) === 'indent' || ((ref5 = this.model.visParent()) != null ? ref5.isRoot : void 0)) && ((ref6 = this.model.end.nextAffectToken()) != null ? ref6.type : void 0) === 'newline') {
            this.bevels.bottom = false;
          }
          if (!(oldBevels.top === this.bevels.top && oldBevels.bottom === this.bevels.bottom)) {
            this.changedBoundingBox = true;
          }
          if (this.computedVersion === this.model.version) {
            return null;
          }
          ref7 = this.children;
          for (j = 0, len1 = ref7.length; j < len1; j++) {
            childObj = ref7[j];
            this.view.getViewNodeFor(childObj.child).computeBevels();
          }
          return null;
        };

        ContainerViewNode.prototype.computeMinDimensions = function() {
          var bottomMargin, childNode, childObject, desiredLine, j, l, len1, len2, len3, len4, len5, len6, line, lineChild, lineChildView, linesToExtend, m, margins, minDimension, minDimensions, minDistanceToBase, o, p, preIndentLines, q, ref, ref1, ref2, size;
          if (this.computedVersion === this.model.version) {
            return null;
          }
          ContainerViewNode.__super__.computeMinDimensions.apply(this, arguments);
          linesToExtend = [];
          preIndentLines = [];
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObject = ref[j];
            childNode = this.view.getViewNodeFor(childObject.child);
            childNode.computeMinDimensions();
            minDimensions = childNode.minDimensions;
            minDistanceToBase = childNode.minDistanceToBase;
            for (line = l = 0, len2 = minDimensions.length; l < len2; line = ++l) {
              size = minDimensions[line];
              desiredLine = line + childObject.startLine;
              margins = childNode.getMargins(line);
              this.minDimensions[desiredLine].width += size.width + margins.left + margins.right;
              if (childObject.child.type === 'indent' && line === minDimensions.length - 1 && desiredLine < this.lineLength - 1) {
                bottomMargin = 0;
                linesToExtend.push(desiredLine + 1);
              } else if (childObject.child.type === 'indent' && line === 0) {
                preIndentLines.push(desiredLine);
                bottomMargin = margins.bottom;
              } else {
                bottomMargin = margins.bottom;
              }
              this.minDistanceToBase[desiredLine].above = Math.max(this.minDistanceToBase[desiredLine].above, minDistanceToBase[line].above + margins.top);
              this.minDistanceToBase[desiredLine].below = Math.max(this.minDistanceToBase[desiredLine].below, minDistanceToBase[line].below + bottomMargin);
            }
          }
          ref1 = this.minDimensions;
          for (line = m = 0, len3 = ref1.length; m < len3; line = ++m) {
            minDimension = ref1[line];
            if (this.lineChildren[line].length === 0) {
              if (this.model.type === 'socket') {
                this.minDistanceToBase[line].above = this.view.opts.textHeight * this.view.opts.textPadding;
                this.minDistanceToBase[line].above = this.view.opts.textPadding;
              } else {
                this.minDistanceToBase[line].above = this.view.opts.textHeight + this.view.opts.padding;
                this.minDistanceToBase[line].below = this.view.opts.padding;
              }
            }
            minDimension.height = this.minDistanceToBase[line].above + this.minDistanceToBase[line].below;
          }
          for (o = 0, len4 = linesToExtend.length; o < len4; o++) {
            line = linesToExtend[o];
            this.minDimensions[line].width = Math.max(this.minDimensions[line].width, this.minDimensions[line - 1].width);
          }
          for (p = 0, len5 = preIndentLines.length; p < len5; p++) {
            line = preIndentLines[p];
            this.minDimensions[line].width = Math.max(this.minDimensions[line].width, this.view.opts.indentWidth + this.view.opts.tabWidth + this.view.opts.tabOffset + this.view.opts.bevelClip);
          }
          ref2 = this.lineChildren[this.lineLength - 1];
          for (q = 0, len6 = ref2.length; q < len6; q++) {
            lineChild = ref2[q];
            lineChildView = this.view.getViewNodeFor(lineChild.child);
            if (lineChildView.carriageArrow !== CARRIAGE_ARROW_NONE) {
              this.minDistanceToBase[this.lineLength - 1].below += this.view.opts.padding;
              this.minDimensions[this.lineLength - 1].height = this.minDistanceToBase[this.lineLength - 1].above + this.minDistanceToBase[this.lineLength - 1].below;
              break;
            }
          }
          return null;
        };

        ContainerViewNode.prototype.computeBoundingBoxX = function(left, line) {
          var childLeft, childLine, childMargins, childView, i, j, len1, lineChild, ref, ref1, ref2, ref3;
          if (this.computedVersion === this.model.version && left === ((ref = this.bounds[line]) != null ? ref.x : void 0) && !this.changedBoundingBox) {
            return this.bounds[line];
          }
          if (!(((ref1 = this.bounds[line]) != null ? ref1.x : void 0) === left && ((ref2 = this.bounds[line]) != null ? ref2.width : void 0) === this.dimensions[line].width)) {
            if (this.bounds[line] != null) {
              this.bounds[line].x = left;
              this.bounds[line].width = this.dimensions[line].width;
            } else {
              this.bounds[line] = new this.view.draw.Rectangle(left, 0, this.dimensions[line].width, 0);
            }
            this.changedBoundingBox = true;
          }
          childLeft = left;
          ref3 = this.lineChildren[line];
          for (i = j = 0, len1 = ref3.length; j < len1; i = ++j) {
            lineChild = ref3[i];
            childView = this.view.getViewNodeFor(lineChild.child);
            childLine = line - lineChild.startLine;
            childMargins = childView.getMargins(childLine);
            childLeft += childMargins.left;
            childView.computeBoundingBoxX(childLeft, childLine);
            childLeft += childView.dimensions[childLine].width + childMargins.right;
          }
          return this.bounds[line];
        };

        ContainerViewNode.prototype.computeGlue = function() {
          var box, childLine, childObj, childView, j, l, len1, len2, len3, line, lineChild, m, overlap, ref, ref1, ref2, ref3;
          if (this.computedVersion === this.model.version && !this.changedBoundingBox) {
            return this.glue;
          }
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).computeGlue();
          }
          this.glue = {};
          ref1 = this.bounds;
          for (line = l = 0, len2 = ref1.length; l < len2; line = ++l) {
            box = ref1[line];
            if (!(line < this.bounds.length - 1)) {
              continue;
            }
            this.glue[line] = {
              type: 'normal',
              height: 0,
              draw: false
            };
            ref2 = this.lineChildren[line];
            for (m = 0, len3 = ref2.length; m < len3; m++) {
              lineChild = ref2[m];
              childView = this.view.getViewNodeFor(lineChild.child);
              childLine = line - lineChild.startLine;
              if (childLine in childView.glue) {
                this.glue[line].height = Math.max(this.glue[line].height, childView.glue[childLine].height);
              }
              if (childView.carriageArrow !== CARRIAGE_ARROW_NONE) {
                this.glue[line].height = Math.max(this.glue[line].height, this.view.opts.padding);
              }
            }
            if (!(this.multilineChildrenData[line] === MULTILINE_MIDDLE || this.model.type === 'segment')) {
              overlap = Math.min(this.bounds[line].right() - this.bounds[line + 1].x, this.bounds[line + 1].right() - this.bounds[line].x);
              if ((ref3 = this.multilineChildrenData[line]) === MULTILINE_START || ref3 === MULTILINE_END_START) {
                overlap = Math.min(overlap, this.bounds[line + 1].x + this.view.opts.indentWidth - this.bounds[line].x);
              }
              if (overlap < this.view.opts.padding && this.model.type !== 'indent') {
                this.glue[line].height += this.view.opts.padding;
                this.glue[line].draw = true;
              }
            }
          }
          return this.glue;
        };

        ContainerViewNode.prototype.computeBoundingBoxY = function(top, line) {
          var above, childAbove, childLine, childView, i, j, len1, lineChild, ref, ref1, ref2, ref3;
          if (this.computedVersion === this.model.version && top === ((ref = this.bounds[line]) != null ? ref.y : void 0) && !this.changedBoundingBox) {
            return this.bounds[line];
          }
          if (!(((ref1 = this.bounds[line]) != null ? ref1.y : void 0) === top && ((ref2 = this.bounds[line]) != null ? ref2.height : void 0) === this.dimensions[line].height)) {
            this.bounds[line].y = top;
            this.bounds[line].height = this.dimensions[line].height;
            this.changedBoundingBox = true;
          }
          above = this.distanceToBase[line].above;
          ref3 = this.lineChildren[line];
          for (i = j = 0, len1 = ref3.length; j < len1; i = ++j) {
            lineChild = ref3[i];
            childView = this.view.getViewNodeFor(lineChild.child);
            childLine = line - lineChild.startLine;
            childAbove = childView.distanceToBase[childLine].above;
            childView.computeBoundingBoxY(top + above - childAbove, childLine);
          }
          return this.bounds[line];
        };

        ContainerViewNode.prototype.layout = function(left, top) {
          var changedBoundingBox;
          if (left == null) {
            left = 0;
          }
          if (top == null) {
            top = 0;
          }
          this.computeChildren();
          this.computeCarriageArrow(true);
          this.computeMargins();
          this.computeBevels();
          this.computeMinDimensions();
          this.computeDimensions(0, false, true);
          this.computeAllBoundingBoxX(left);
          this.computeGlue();
          this.computeAllBoundingBoxY(top);
          this.computePath();
          this.computeDropAreas();
          changedBoundingBox = this.changedBoundingBox;
          this.computeNewVersionNumber();
          return changedBoundingBox;
        };

        ContainerViewNode.prototype.computeOwnPath = function() {
          var bounds, destinationBounds, el, glueTop, i, innerLeft, innerRight, j, l, left, leftmost, len1, len2, len3, line, m, multilineBounds, multilineChild, multilineNode, multilineView, newPath, next, parentViewNode, path, point, prev, ref, ref1, ref2, ref3, ref4, ref5, ref6, right, rightmost;
          left = [];
          right = [];
          if (this.shouldAddTab() && this.model.isFirstOnLine() && this.carriageArrow !== CARRIAGE_ARROW_SIDEALONG) {
            this.addTabReverse(right, new this.view.draw.Point(this.bounds[0].x + this.view.opts.tabOffset, this.bounds[0].y));
          }
          ref = this.bounds;
          for (line = j = 0, len1 = ref.length; j < len1; line = ++j) {
            bounds = ref[line];
            if (this.multilineChildrenData[line] === NO_MULTILINE) {
              left.push(new this.view.draw.Point(bounds.x, bounds.y));
              left.push(new this.view.draw.Point(bounds.x, bounds.bottom()));
              right.push(new this.view.draw.Point(bounds.right(), bounds.y));
              right.push(new this.view.draw.Point(bounds.right(), bounds.bottom()));
            }
            if (this.multilineChildrenData[line] === MULTILINE_START) {
              left.push(new this.view.draw.Point(bounds.x, bounds.y));
              left.push(new this.view.draw.Point(bounds.x, bounds.bottom()));
              multilineChild = this.lineChildren[line][this.lineChildren[line].length - 1];
              multilineView = this.view.getViewNodeFor(multilineChild.child);
              multilineBounds = multilineView.bounds[line - multilineChild.startLine];
              if (multilineBounds.width === 0) {
                right.push(new this.view.draw.Point(bounds.right(), bounds.y));
              } else {
                right.push(new this.view.draw.Point(bounds.right(), bounds.y));
                right.push(new this.view.draw.Point(bounds.right(), multilineBounds.y));
                if (multilineChild.child.type === 'indent') {
                  this.addTab(right, new this.view.draw.Point(multilineBounds.x + this.view.opts.tabOffset, multilineBounds.y));
                }
                right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.y));
                right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.bottom()));
              }
            }
            if (this.multilineChildrenData[line] === MULTILINE_MIDDLE) {
              multilineChild = this.lineChildren[line][0];
              multilineBounds = this.view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine];
              left.push(new this.view.draw.Point(bounds.x, bounds.y));
              left.push(new this.view.draw.Point(bounds.x, bounds.bottom()));
              if (!(((ref1 = this.multilineChildrenData[line - 1]) === MULTILINE_START || ref1 === MULTILINE_END_START) && multilineChild.child.type === 'indent')) {
                right.push(new this.view.draw.Point(multilineBounds.x, bounds.y));
              }
              right.push(new this.view.draw.Point(multilineBounds.x, bounds.bottom()));
            }
            if ((ref2 = this.multilineChildrenData[line]) === MULTILINE_END || ref2 === MULTILINE_END_START) {
              left.push(new this.view.draw.Point(bounds.x, bounds.y));
              left.push(new this.view.draw.Point(bounds.x, bounds.bottom()));
              multilineChild = this.lineChildren[line][0];
              multilineBounds = this.view.getViewNodeFor(multilineChild.child).bounds[line - multilineChild.startLine];
              if (!(((ref3 = this.multilineChildrenData[line - 1]) === MULTILINE_START || ref3 === MULTILINE_END_START) && multilineChild.child.type === 'indent')) {
                right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.y));
              }
              right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.bottom()));
              if (multilineChild.child.type === 'indent') {
                this.addTabReverse(right, new this.view.draw.Point(multilineBounds.x + this.view.opts.tabOffset, multilineBounds.bottom()));
              }
              right.push(new this.view.draw.Point(multilineBounds.right(), multilineBounds.bottom()));
              if (this.lineChildren[line].length > 1) {
                right.push(new this.view.draw.Point(multilineBounds.right(), multilineBounds.y));
                if (this.multilineChildrenData[line] === MULTILINE_END) {
                  right.push(new this.view.draw.Point(bounds.right(), bounds.y));
                  right.push(new this.view.draw.Point(bounds.right(), bounds.bottom()));
                } else {
                  multilineChild = this.lineChildren[line][this.lineChildren[line].length - 1];
                  multilineView = this.view.getViewNodeFor(multilineChild.child);
                  multilineBounds = multilineView.bounds[line - multilineChild.startLine];
                  right.push(new this.view.draw.Point(bounds.right(), bounds.y));
                  if (multilineBounds.width === 0) {
                    right.push(new this.view.draw.Point(bounds.right(), bounds.y));
                    right.push(new this.view.draw.Point(bounds.right(), bounds.bottom()));
                  } else {
                    right.push(new this.view.draw.Point(bounds.right(), multilineBounds.y));
                    right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.y));
                    right.push(new this.view.draw.Point(multilineBounds.x, multilineBounds.bottom()));
                  }
                }
              } else {
                right.push(new this.view.draw.Point(bounds.right(), multilineBounds.bottom()));
                right.push(new this.view.draw.Point(bounds.right(), bounds.bottom()));
              }
            }
            if (line < this.lineLength - 1 && line in this.glue && this.glue[line].draw) {
              glueTop = this.bounds[line + 1].y - this.glue[line].height;
              leftmost = Math.min(this.bounds[line + 1].x, this.bounds[line].x);
              rightmost = Math.max(this.bounds[line + 1].right(), this.bounds[line].right());
              left.push(new this.view.draw.Point(this.bounds[line].x, glueTop));
              left.push(new this.view.draw.Point(leftmost, glueTop));
              left.push(new this.view.draw.Point(leftmost, glueTop + this.view.opts.padding));
              if (this.multilineChildrenData[line] !== MULTILINE_START) {
                right.push(new this.view.draw.Point(this.bounds[line].right(), glueTop));
                right.push(new this.view.draw.Point(rightmost, glueTop));
                right.push(new this.view.draw.Point(rightmost, glueTop + this.view.opts.padding));
              }
            } else if ((this.bounds[line + 1] != null) && this.multilineChildrenData[line] !== MULTILINE_MIDDLE) {
              innerLeft = Math.max(this.bounds[line + 1].x, this.bounds[line].x);
              innerRight = Math.min(this.bounds[line + 1].right(), this.bounds[line].right());
              left.push(new this.view.draw.Point(innerLeft, this.bounds[line].bottom()));
              left.push(new this.view.draw.Point(innerLeft, this.bounds[line + 1].y));
              if ((ref4 = this.multilineChildrenData[line]) !== MULTILINE_START && ref4 !== MULTILINE_END_START) {
                right.push(new this.view.draw.Point(innerRight, this.bounds[line].bottom()));
                right.push(new this.view.draw.Point(innerRight, this.bounds[line + 1].y));
              }
            } else if (this.carriageArrow === CARRIAGE_GROW_DOWN) {
              parentViewNode = this.view.getViewNodeFor(this.model.visParent());
              destinationBounds = parentViewNode.bounds[1];
              right.push(new this.view.draw.Point(this.bounds[line].right(), destinationBounds.y - this.view.opts.padding));
              left.push(new this.view.draw.Point(this.bounds[line].x, destinationBounds.y - this.view.opts.padding));
            } else if (this.carriageArrow === CARRIAGE_ARROW_INDENT) {
              parentViewNode = this.view.getViewNodeFor(this.model.visParent());
              destinationBounds = parentViewNode.bounds[1];
              right.push(new this.view.draw.Point(this.bounds[line].right(), destinationBounds.y));
              right.push(new this.view.draw.Point(destinationBounds.x + this.view.opts.tabOffset + this.view.opts.tabWidth, destinationBounds.y));
              left.push(new this.view.draw.Point(this.bounds[line].x, destinationBounds.y - this.view.opts.padding));
              left.push(new this.view.draw.Point(destinationBounds.x, destinationBounds.y - this.view.opts.padding));
              left.push(new this.view.draw.Point(destinationBounds.x, destinationBounds.y));
              this.addTab(right, new this.view.draw.Point(destinationBounds.x + this.view.opts.tabOffset, destinationBounds.y));
            } else if (this.carriageArrow === CARRIAGE_ARROW_SIDEALONG && this.model.isLastOnLine()) {
              parentViewNode = this.view.getViewNodeFor(this.model.visParent());
              destinationBounds = parentViewNode.bounds[this.model.getLinesToParent()];
              right.push(new this.view.draw.Point(this.bounds[line].right(), destinationBounds.bottom() + this.view.opts.padding));
              right.push(new this.view.draw.Point(destinationBounds.x + this.view.opts.tabOffset + this.view.opts.tabWidth, destinationBounds.bottom() + this.view.opts.padding));
              left.push(new this.view.draw.Point(this.bounds[line].x, destinationBounds.bottom()));
              left.push(new this.view.draw.Point(destinationBounds.x, destinationBounds.bottom()));
              left.push(new this.view.draw.Point(destinationBounds.x, destinationBounds.bottom() + this.view.opts.padding));
              this.addTab(right, new this.view.draw.Point(destinationBounds.x + this.view.opts.tabOffset, destinationBounds.bottom() + this.view.opts.padding));
            }
            if ((ref5 = this.multilineChildrenData[line]) === MULTILINE_START || ref5 === MULTILINE_END_START) {
              multilineChild = this.lineChildren[line][this.lineChildren[line].length - 1];
              multilineNode = this.view.getViewNodeFor(multilineChild.child);
              multilineBounds = multilineNode.bounds[line - multilineChild.startLine];
              if ((ref6 = this.glue[line]) != null ? ref6.draw : void 0) {
                glueTop = this.bounds[line + 1].y - this.glue[line].height + this.view.opts.padding;
              } else {
                glueTop = this.bounds[line].bottom();
              }
              if (multilineChild.child.type === 'indent' && multilineChild.child.start.next.type === 'newline') {
                right.push(new this.view.draw.Point(this.bounds[line].right(), glueTop));
                this.addTab(right, new this.view.draw.Point(this.bounds[line + 1].x + this.view.opts.indentWidth + this.view.opts.tabOffset, glueTop), true);
              } else {
                right.push(new this.view.draw.Point(multilineBounds.x, glueTop));
              }
              if (glueTop !== this.bounds[line + 1].y) {
                right.push(new this.view.draw.Point(multilineNode.bounds[line - multilineChild.startLine + 1].x, glueTop));
              }
              right.push(new this.view.draw.Point(multilineNode.bounds[line - multilineChild.startLine + 1].x, this.bounds[line + 1].y));
            }
          }
          if (this.shouldAddTab() && this.model.isLastOnLine() && this.carriageArrow === CARRIAGE_ARROW_NONE) {
            this.addTab(right, new this.view.draw.Point(this.bounds[this.lineLength - 1].x + this.view.opts.tabOffset, this.bounds[this.lineLength - 1].bottom()));
          }
          path = left.reverse().concat(right);
          newPath = [];
          for (i = l = 0, len2 = path.length; l < len2; i = ++l) {
            point = path[i];
            if (i === 0 && !this.bevels.bottom) {
              newPath.push(point);
              continue;
            }
            if (i === (left.length - 1) && !this.bevels.top) {
              newPath.push(point);
              continue;
            }
            next = path[modulo(i + 1, path.length)];
            prev = path[modulo(i - 1, path.length)];
            if ((point.x === next.x) !== (point.y === next.y) && (point.x === prev.x) !== (point.y === prev.y)) {
              newPath.push(point.plus(point.from(prev).toMagnitude(-this.view.opts.bevelClip)));
              newPath.push(point.plus(point.from(next).toMagnitude(-this.view.opts.bevelClip)));
            } else {
              newPath.push(point);
            }
          }
          this.path = new this.view.draw.Path();
          for (m = 0, len3 = newPath.length; m < len3; m++) {
            el = newPath[m];
            this.path.push(el);
          }
          return this.path;
        };

        ContainerViewNode.prototype.addTab = function(array, point) {
          array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth, point.y));
          array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth * (1 - this.view.opts.tabSideWidth), point.y + this.view.opts.tabHeight));
          array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth * this.view.opts.tabSideWidth, point.y + this.view.opts.tabHeight));
          array.push(new this.view.draw.Point(point.x, point.y));
          return array.push(point);
        };

        ContainerViewNode.prototype.addTabReverse = function(array, point) {
          array.push(point);
          array.push(new this.view.draw.Point(point.x, point.y));
          array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth * this.view.opts.tabSideWidth, point.y + this.view.opts.tabHeight));
          array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth * (1 - this.view.opts.tabSideWidth), point.y + this.view.opts.tabHeight));
          return array.push(new this.view.draw.Point(point.x + this.view.opts.tabWidth, point.y));
        };

        ContainerViewNode.prototype.computeOwnDropArea = function() {
          return this.dropArea = this.highlightArea = null;
        };

        ContainerViewNode.prototype.shouldAddTab = NO;

        ContainerViewNode.prototype.drawSelf = function(ctx, style) {
          var oldFill, oldStroke;
          oldFill = this.path.style.fillColor;
          oldStroke = this.path.style.strokeColor;
          if (style.grayscale > 0) {
            this.path.style.fillColor = avgColor(this.path.style.fillColor, 0.5, '#888');
            this.path.style.strokeColor = avgColor(this.path.style.strokeColor, 0.5, '#888');
          }
          if (style.selected > 0) {
            this.path.style.fillColor = avgColor(this.path.style.fillColor, 0.7, '#00F');
            this.path.style.strokeColor = avgColor(this.path.style.strokeColor, 0.7, '#00F');
          }
          this.path.draw(ctx);
          this.path.style.fillColor = oldFill;
          this.path.style.strokeColor = oldStroke;
          return null;
        };

        ContainerViewNode.prototype.drawShadow = function(ctx, x, y) {
          var childObj, j, len1, ref;
          this.path.drawShadow(ctx, x, y, this.view.opts.shadowBlur);
          ref = this.children;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            childObj = ref[j];
            this.view.getViewNodeFor(childObj.child).drawShadow(ctx, x, y);
          }
          return null;
        };

        return ContainerViewNode;

      })(GenericViewNode);

      BlockViewNode = (function(superClass) {
        extend(BlockViewNode, superClass);

        function BlockViewNode() {
          BlockViewNode.__super__.constructor.apply(this, arguments);
        }

        BlockViewNode.prototype.computeMinDimensions = function() {
          var i, j, len1, ref, size;
          if (this.computedVersion === this.model.version) {
            return null;
          }
          BlockViewNode.__super__.computeMinDimensions.apply(this, arguments);
          this.extraWidth = 0;
          if (indexOf.call(this.model.classes, 'add-button') >= 0) {
            this.extraWidth += this.view.opts.buttonWidth + this.view.opts.buttonPadding;
          }
          if (indexOf.call(this.model.classes, 'subtract-button') >= 0) {
            this.extraWidth += this.view.opts.buttonWidth + this.view.opts.buttonPadding;
          }
          ref = this.minDimensions;
          for (i = j = 0, len1 = ref.length; j < len1; i = ++j) {
            size = ref[i];
            size.width = Math.max(size.width, this.view.opts.tabWidth + this.view.opts.tabOffset);
            size.width += this.extraWidth;
          }
          return null;
        };

        BlockViewNode.prototype.drawSelf = function(ctx, style) {
          var start;
          BlockViewNode.__super__.drawSelf.apply(this, arguments);
          start = this.totalBounds.x + this.totalBounds.width - this.extraWidth;
          ctx.textBaseline = 'top';
          ctx.font = this.view.opts.textHeight + 'px ';
          ctx.fillStyle = '#000';
          if (indexOf.call(this.model.classes, 'add-button') >= 0) {
            this.addButtonRect.stroke(ctx, '#000');
            ctx.fillText('+', this.addButtonRect.x + 2, this.addButtonRect.y);
            start += this.view.opts.buttonWidth + this.view.opts.buttonPadding;
          }
          if (indexOf.call(this.model.classes, 'subtract-button') >= 0) {
            this.subtractButtonRect.stroke(ctx, '#000');
            return ctx.fillText('-', this.subtractButtonRect.x + 2, this.subtractButtonRect.y);
          }
        };

        BlockViewNode.prototype.shouldAddTab = function() {
          var parent;
          if (this.model.parent != null) {
            parent = this.model.visParent();
            return (parent != null ? parent.type : void 0) !== 'socket';
          } else {
            return !(indexOf.call(this.model.classes, 'mostly-value') >= 0 || indexOf.call(this.model.classes, 'value-only') >= 0);
          }
        };

        BlockViewNode.prototype.computePath = function() {
          var start;
          BlockViewNode.__super__.computePath.apply(this, arguments);
          start = this.totalBounds.x + this.totalBounds.width - this.extraWidth;
          if (indexOf.call(this.model.classes, 'add-button') >= 0) {
            this.addButtonRect = new this.view.draw.Rectangle(start + this.view.opts.buttonOffset, this.totalBounds.y + this.view.opts.padding, this.view.opts.buttonWidth, this.view.opts.buttonHeight);
            start += this.view.opts.buttonWidth + this.view.opts.buttonPadding;
          }
          if (indexOf.call(this.model.classes, 'subtract-button') >= 0) {
            return this.subtractButtonRect = new this.view.draw.Rectangle(start + this.view.opts.buttonOffset, this.totalBounds.y + this.view.opts.padding, this.view.opts.buttonWidth, this.view.opts.buttonHeight);
          }
        };

        BlockViewNode.prototype.computeOwnPath = function() {
          BlockViewNode.__super__.computeOwnPath.apply(this, arguments);
          this.path.style.fillColor = this.view.getColor(this.model.color);
          this.path.style.strokeColor = '#888';
          this.path.bevel = true;
          return this.path;
        };

        BlockViewNode.prototype.computeOwnDropArea = function() {
          var destinationBounds, highlightAreaPoints, j, lastBoundsLeft, lastBoundsRight, len1, parentViewNode, point;
          if (this.carriageArrow === CARRIAGE_ARROW_INDENT) {
            parentViewNode = this.view.getViewNodeFor(this.model.visParent());
            destinationBounds = parentViewNode.bounds[1];
            this.dropPoint = new this.view.draw.Point(destinationBounds.x, destinationBounds.y);
            lastBoundsLeft = destinationBounds.x;
            lastBoundsRight = destinationBounds.right();
          } else if (this.carriageArrow === CARRIAGE_ARROW_SIDEALONG) {
            parentViewNode = this.view.getViewNodeFor(this.model.visParent());
            destinationBounds = parentViewNode.bounds[1];
            this.dropPoint = new this.view.draw.Point(destinationBounds.x, this.bounds[this.lineLength - 1].bottom() + this.view.opts.padding);
            lastBoundsLeft = destinationBounds.x;
            lastBoundsRight = this.bounds[this.lineLength - 1].right();
          } else {
            this.dropPoint = new this.view.draw.Point(this.bounds[this.lineLength - 1].x, this.bounds[this.lineLength - 1].bottom());
            lastBoundsLeft = this.bounds[this.lineLength - 1].x;
            lastBoundsRight = this.bounds[this.lineLength - 1].right();
          }
          this.highlightArea = new this.view.draw.Path();
          highlightAreaPoints = [];
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsLeft, this.dropPoint.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsLeft + this.view.opts.bevelClip, this.dropPoint.y - this.view.opts.highlightAreaHeight / 2));
          this.addTabReverse(highlightAreaPoints, new this.view.draw.Point(lastBoundsLeft + this.view.opts.tabOffset, this.dropPoint.y - this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsRight - this.view.opts.bevelClip, this.dropPoint.y - this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsRight, this.dropPoint.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsRight, this.dropPoint.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsRight - this.view.opts.bevelClip, this.dropPoint.y + this.view.opts.highlightAreaHeight / 2));
          this.addTab(highlightAreaPoints, new this.view.draw.Point(lastBoundsLeft + this.view.opts.tabOffset, this.dropPoint.y + this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsLeft + this.view.opts.bevelClip, this.dropPoint.y + this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBoundsLeft, this.dropPoint.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
          for (j = 0, len1 = highlightAreaPoints.length; j < len1; j++) {
            point = highlightAreaPoints[j];
            this.highlightArea.push(point);
          }
          this.highlightArea.style.lineWidth = 1;
          this.highlightArea.style.strokeColor = '#ff0';
          return this.highlightArea.style.fillColor = '#ff0';
        };

        return BlockViewNode;

      })(ContainerViewNode);

      SocketViewNode = (function(superClass) {
        extend(SocketViewNode, superClass);

        function SocketViewNode() {
          SocketViewNode.__super__.constructor.apply(this, arguments);
        }

        SocketViewNode.prototype.shouldAddTab = NO;

        SocketViewNode.prototype.computeMinDimensions = function() {
          var dimension, j, len1, ref;
          if (this.computedVersion === this.model.version) {
            return null;
          }
          SocketViewNode.__super__.computeMinDimensions.apply(this, arguments);
          this.minDistanceToBase[0].above = Math.max(this.minDistanceToBase[0].above, this.view.opts.textHeight + this.view.opts.textPadding);
          this.minDistanceToBase[0].below = Math.max(this.minDistanceToBase[0].below, this.view.opts.textPadding);
          this.minDimensions[0].height = this.minDistanceToBase[0].above + this.minDistanceToBase[0].below;
          ref = this.minDimensions;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            dimension = ref[j];
            dimension.width = Math.max(dimension.width, this.view.opts.minSocketWidth);
          }
          return null;
        };

        SocketViewNode.prototype.computeGlue = function() {
          var view;
          if (this.computedVersion === this.model.version && !this.changedBoundingBox) {
            return this.glue;
          }
          if (this.model.start.nextVisibleToken().type === 'blockStart') {
            view = this.view.getViewNodeFor(this.model.start.next.container);
            return this.glue = view.computeGlue();
          } else {
            return SocketViewNode.__super__.computeGlue.apply(this, arguments);
          }
        };

        SocketViewNode.prototype.computeOwnPath = function() {
          var view;
          if (this.computedVersion === this.model.version && !this.changedBoundingBox) {
            return this.path;
          }
          if (this.model.start.next.type === 'blockStart') {
            view = this.view.getViewNodeFor(this.model.start.next.container);
            this.path = view.computeOwnPath().clone();
          } else {
            SocketViewNode.__super__.computeOwnPath.apply(this, arguments);
          }
          this.path.style.fillColor = '#FFF';
          this.path.style.strokeColor = '#FFF';
          return this.path;
        };

        SocketViewNode.prototype.computeOwnDropArea = function() {
          if (this.model.start.next.type === 'blockStart') {
            return this.dropArea = this.highlightArea = null;
          } else {
            this.dropPoint = this.bounds[0].upperLeftCorner();
            this.highlightArea = this.path.clone();
            this.highlightArea.noclip = true;
            this.highlightArea.style.strokeColor = '#FF0';
            return this.highlightArea.style.lineWidth = this.view.opts.padding;
          }
        };

        return SocketViewNode;

      })(ContainerViewNode);

      IndentViewNode = (function(superClass) {
        extend(IndentViewNode, superClass);

        function IndentViewNode() {
          IndentViewNode.__super__.constructor.apply(this, arguments);
          this.lastFirstChildren = [];
          this.lastLastChildren = [];
        }

        IndentViewNode.prototype.computeOwnPath = function() {
          return this.path = new this.view.draw.Path();
        };

        IndentViewNode.prototype.computeChildren = function() {
          var childObj, childRef, childView, j, l, len1, len2, len3, m, ref, ref1, ref2;
          IndentViewNode.__super__.computeChildren.apply(this, arguments);
          if (!(arrayEq(this.lineChildren[0], this.lastFirstChildren) && arrayEq(this.lineChildren[this.lineLength - 1], this.lastLastChildren))) {
            ref = this.children;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              childObj = ref[j];
              childView = this.view.getViewNodeFor(childObj.child);
              if (childView.topLineSticksToBottom || childView.bottomLineSticksToTop) {
                childView.invalidate = true;
              }
              if (childView.lineLength === 1) {
                childView.topLineSticksToBottom = childView.bottomLineSticksToTop = false;
              }
            }
          }
          ref1 = this.lineChildren[0];
          for (l = 0, len2 = ref1.length; l < len2; l++) {
            childRef = ref1[l];
            childView = this.view.getViewNodeFor(childRef.child);
            if (!childView.topLineSticksToBottom) {
              childView.invalidate = true;
            }
            childView.topLineSticksToBottom = true;
          }
          ref2 = this.lineChildren[this.lineChildren.length - 1];
          for (m = 0, len3 = ref2.length; m < len3; m++) {
            childRef = ref2[m];
            childView = this.view.getViewNodeFor(childRef.child);
            if (!childView.bottomLineSticksToTop) {
              childView.invalidate = true;
            }
            childView.bottomLineSticksToTop = true;
          }
          return this.lineLength;
        };

        IndentViewNode.prototype.computeMinDimensions = function() {
          var j, len1, line, ref, results, size;
          IndentViewNode.__super__.computeMinDimensions.apply(this, arguments);
          ref = this.minDimensions.slice(1);
          results = [];
          for (line = j = 0, len1 = ref.length; j < len1; line = ++j) {
            size = ref[line];
            if (size.width === 0) {
              results.push(size.width = this.view.opts.emptyLineWidth);
            }
          }
          return results;
        };

        IndentViewNode.prototype.drawSelf = function() {
          return null;
        };

        IndentViewNode.prototype.computeOwnDropArea = function() {
          var highlightAreaPoints, j, lastBounds, len1, point;
          lastBounds = new this.view.draw.NoRectangle();
          if (this.model.start.next.type === 'newline') {
            this.dropPoint = this.bounds[1].upperLeftCorner();
            lastBounds.copy(this.bounds[1]);
          } else {
            this.dropPoint = this.bounds[0].upperLeftCorner();
            lastBounds.copy(this.bounds[0]);
          }
          lastBounds.width = Math.max(lastBounds.width, this.view.opts.indentDropAreaMinWidth);
          this.highlightArea = new this.view.draw.Path();
          highlightAreaPoints = [];
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x, lastBounds.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x + this.view.opts.bevelClip, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
          this.addTabReverse(highlightAreaPoints, new this.view.draw.Point(lastBounds.x + this.view.opts.tabOffset, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right() - this.view.opts.bevelClip, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right(), lastBounds.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right(), lastBounds.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right() - this.view.opts.bevelClip, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
          this.addTab(highlightAreaPoints, new this.view.draw.Point(lastBounds.x + this.view.opts.tabOffset, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x + this.view.opts.bevelClip, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
          highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x, lastBounds.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
          for (j = 0, len1 = highlightAreaPoints.length; j < len1; j++) {
            point = highlightAreaPoints[j];
            this.highlightArea.push(point);
          }
          this.highlightArea.style.lineWidth = 1;
          this.highlightArea.style.strokeColor = '#ff0';
          return this.highlightArea.style.fillColor = '#ff0';
        };

        return IndentViewNode;

      })(ContainerViewNode);

      SegmentViewNode = (function(superClass) {
        extend(SegmentViewNode, superClass);

        function SegmentViewNode() {
          SegmentViewNode.__super__.constructor.apply(this, arguments);
        }

        SegmentViewNode.prototype.computeOwnPath = function() {
          return this.path = new this.view.draw.Path();
        };

        SegmentViewNode.prototype.computeOwnDropArea = function() {
          var highlightAreaPoints, j, lastBounds, len1, point;
          if (this.model.isLassoSegment) {
            return this.dropArea = null;
          } else {
            this.dropPoint = this.bounds[0].upperLeftCorner();
            this.highlightArea = new this.view.draw.Path();
            highlightAreaPoints = [];
            lastBounds = new this.view.draw.NoRectangle();
            lastBounds.copy(this.bounds[0]);
            lastBounds.width = Math.max(lastBounds.width, this.view.opts.indentDropAreaMinWidth);
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x, lastBounds.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x + this.view.opts.bevelClip, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
            this.addTabReverse(highlightAreaPoints, new this.view.draw.Point(lastBounds.x + this.view.opts.tabOffset, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right() - this.view.opts.bevelClip, lastBounds.y - this.view.opts.highlightAreaHeight / 2));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right(), lastBounds.y - this.view.opts.highlightAreaHeight / 2 + this.view.opts.bevelClip));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right(), lastBounds.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.right() - this.view.opts.bevelClip, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
            this.addTab(highlightAreaPoints, new this.view.draw.Point(lastBounds.x + this.view.opts.tabOffset, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x + this.view.opts.bevelClip, lastBounds.y + this.view.opts.highlightAreaHeight / 2));
            highlightAreaPoints.push(new this.view.draw.Point(lastBounds.x, lastBounds.y + this.view.opts.highlightAreaHeight / 2 - this.view.opts.bevelClip));
            for (j = 0, len1 = highlightAreaPoints.length; j < len1; j++) {
              point = highlightAreaPoints[j];
              this.highlightArea.push(point);
            }
            this.highlightArea.style.fillColor = '#ff0';
            this.highlightArea.style.strokeColor = '#ff0';
            return null;
          }
        };

        SegmentViewNode.prototype.drawSelf = function(ctx, style) {
          return null;
        };

        SegmentViewNode.prototype.draw = function(ctx, boundingRect, style) {
          if (style == null) {
            style = defaultStyleObject();
          }
          if (this.model.isLassoSegment) {
            style.selected++;
          }
          SegmentViewNode.__super__.draw.apply(this, arguments);
          if (this.model.isLassoSegment) {
            return style.selected--;
          }
        };

        return SegmentViewNode;

      })(ContainerViewNode);

      TextViewNode = (function(superClass) {
        extend(TextViewNode, superClass);

        function TextViewNode(model1, view1) {
          this.model = model1;
          this.view = view1;
          TextViewNode.__super__.constructor.apply(this, arguments);
        }

        TextViewNode.prototype.computeChildren = function() {
          this.multilineChildrenData = [NO_MULTILINE];
          return this.lineLength = 1;
        };

        TextViewNode.prototype.computeMinDimensions = function() {
          var height;
          if (this.computedVersion === this.model.version) {
            return null;
          }
          this.textElement = new this.view.draw.Text(new this.view.draw.Point(0, 0), this.model.value);
          height = this.view.opts.textHeight;
          this.minDimensions[0] = new this.view.draw.Size(this.textElement.bounds().width, height);
          this.minDistanceToBase[0] = {
            above: height,
            below: 0
          };
          return null;
        };

        TextViewNode.prototype.computeBoundingBoxX = function(left, line) {
          this.textElement.point.x = left;
          return TextViewNode.__super__.computeBoundingBoxX.apply(this, arguments);
        };

        TextViewNode.prototype.computeBoundingBoxY = function(top, line) {
          this.textElement.point.y = top;
          return TextViewNode.__super__.computeBoundingBoxY.apply(this, arguments);
        };

        TextViewNode.prototype.drawSelf = function(ctx, style) {
          if (!style.noText) {
            this.textElement.draw(ctx);
          }
          return null;
        };

        TextViewNode.prototype.debugDimensions = function(x, y, line, ctx) {
          var oldPoint;
          ctx.globalAlpha = 1;
          oldPoint = this.textElement.point;
          this.textElement.point = new this.view.draw.Point(x, y);
          this.textElement.draw(ctx);
          this.textElement.point = oldPoint;
          return ctx.globalAlpha = 0.1;
        };

        TextViewNode.prototype.debugAllBoundingBoxes = function(ctx) {
          ctx.globalAlpha = 1;
          this.computeOwnPath();
          this.textElement.draw(ctx);
          return ctx.globalAlpha = 0.1;
        };

        return TextViewNode;

      })(GenericViewNode);

      CursorViewNode = (function(superClass) {
        extend(CursorViewNode, superClass);

        function CursorViewNode(model1, view1) {
          this.model = model1;
          this.view = view1;
          CursorViewNode.__super__.constructor.apply(this, arguments);
        }

        CursorViewNode.prototype.computeChildren = function() {
          this.multilineChildrenData = [0];
          return 1;
        };

        CursorViewNode.prototype.computeBoundingBox = function() {};

        return CursorViewNode;

      })(GenericViewNode);

      return View;

    })();
    toRGB = function(hex) {
      var b, c, g, r;
      if (hex.length === 4) {
        hex = ((function() {
          var j, len1, results;
          results = [];
          for (j = 0, len1 = hex.length; j < len1; j++) {
            c = hex[j];
            results.push(c + c);
          }
          return results;
        })()).join('').slice(1);
      }
      r = parseInt(hex.slice(1, 3), 16);
      g = parseInt(hex.slice(3, 5), 16);
      b = parseInt(hex.slice(5, 7), 16);
      return [r, g, b];
    };
    zeroPad = function(str, len) {
      if (str.length < len) {
        return ((function() {
          var j, ref, ref1, results;
          results = [];
          for (j = ref = str.length, ref1 = len; ref <= ref1 ? j < ref1 : j > ref1; ref <= ref1 ? j++ : j--) {
            results.push('0');
          }
          return results;
        })()).join('') + str;
      } else {
        return str;
      }
    };
    twoDigitHex = function(n) {
      return zeroPad(Math.round(n).toString(16), 2);
    };
    toHex = function(rgb) {
      var k;
      return '#' + ((function() {
        var j, len1, results;
        results = [];
        for (j = 0, len1 = rgb.length; j < len1; j++) {
          k = rgb[j];
          results.push(twoDigitHex(k));
        }
        return results;
      })()).join('');
    };
    avgColor = function(a, factor, b) {
      var i, k, newRGB;
      a = toRGB(a);
      b = toRGB(b);
      newRGB = (function() {
        var j, len1, results;
        results = [];
        for (i = j = 0, len1 = a.length; j < len1; i = ++j) {
          k = a[i];
          results.push(a[i] * factor + b[i] * (1 - factor));
        }
        return results;
      })();
      return toHex(newRGB);
    };
    return exports;
  });

}).call(this);

//# sourceMappingURL=view.js.map
