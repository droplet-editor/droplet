(function() {
  var hasProp = {}.hasOwnProperty,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['droplet-helper', 'droplet-coffee', 'droplet-javascript', 'droplet-csv', 'droplet-css', 'droplet-draw', 'droplet-model', 'droplet-view'], function(helper, coffee, javascript, csv, css, draw, model, view) {
    var ANIMATION_FRAME_RATE, ANY_DROP, AnimatedColor, BACKSPACE_KEY, BLOCK_ONLY, CONTROL_KEYS, CURSOR_HEIGHT_DECREASE, CURSOR_UNFOCUSED_OPACITY, CURSOR_WIDTH_DECREASE, CreateSegmentOperation, DEBUG_FLAG, DEFAULT_INDENT_DEPTH, DISCOURAGE_DROP_TIMEOUT, DOWN_ARROW_KEY, DestroySegmentOperation, DropOperation, ENTER_KEY, Editor, FloatingBlockRecord, FromFloatingOperation, LEFT_ARROW_KEY, MAX_DROP_DISTANCE, META_KEYS, MIN_DRAG_DISTANCE, MOSTLY_BLOCK, MOSTLY_VALUE, PALETTE_LEFT_MARGIN, PALETTE_MARGIN, PALETTE_TOP_MARGIN, PickUpOperation, RIGHT_ARROW_KEY, ReparseOperation, SetValueOperation, TAB_KEY, TOUCH_SELECTION_TIMEOUT, TextChangeOperation, TextReparseOperation, ToFloatingOperation, UP_ARROW_KEY, UndoOperation, VALUE_ONLY, Z_KEY, binding, command_modifiers, command_pressed, containsCursor, deepCopy, deepEquals, editorBindings, escapeString, exports, extend_, getAtChar, getCharactersTo, getOffsetLeft, getOffsetTop, getSocketAtChar, hook, isOSX, isValidCursorPosition, j, key, last_, len, modes, ref, ref1, touchEvents, unsortedEditorBindings, userAgent, validateLassoSelection;
    modes = {
      'coffeescript': coffee,
      'coffee': coffee,
      'javascript': javascript,
      'csv': csv,
      'css': css
    };
    PALETTE_TOP_MARGIN = 5;
    PALETTE_MARGIN = 5;
    MIN_DRAG_DISTANCE = 1;
    PALETTE_LEFT_MARGIN = 5;
    DEFAULT_INDENT_DEPTH = '  ';
    ANIMATION_FRAME_RATE = 60;
    DISCOURAGE_DROP_TIMEOUT = 1000;
    MAX_DROP_DISTANCE = 100;
    CURSOR_WIDTH_DECREASE = 3;
    CURSOR_HEIGHT_DECREASE = 2;
    CURSOR_UNFOCUSED_OPACITY = 0.5;
    DEBUG_FLAG = false;
    ANY_DROP = helper.ANY_DROP;
    BLOCK_ONLY = helper.BLOCK_ONLY;
    MOSTLY_BLOCK = helper.MOSTLY_BLOCK;
    MOSTLY_VALUE = helper.MOSTLY_VALUE;
    VALUE_ONLY = helper.VALUE_ONLY;
    BACKSPACE_KEY = 8;
    TAB_KEY = 9;
    ENTER_KEY = 13;
    LEFT_ARROW_KEY = 37;
    UP_ARROW_KEY = 38;
    RIGHT_ARROW_KEY = 39;
    DOWN_ARROW_KEY = 40;
    Z_KEY = 90;
    META_KEYS = [91, 92, 93, 223, 224];
    CONTROL_KEYS = [17, 162, 163];
    userAgent = '';
    if (typeof window !== 'undefined' && ((ref = window.navigator) != null ? ref.userAgent : void 0)) {
      userAgent = window.navigator.userAgent;
    }
    isOSX = /OS X/.test(userAgent);
    command_modifiers = isOSX ? META_KEYS : CONTROL_KEYS;
    command_pressed = function(e) {
      if (isOSX) {
        return e.metaKey;
      } else {
        return e.ctrlKey;
      }
    };
    exports = {};
    extend_ = function(a, b) {
      var key, obj, value;
      obj = {};
      for (key in a) {
        value = a[key];
        obj[key] = value;
      }
      for (key in b) {
        value = b[key];
        obj[key] = value;
      }
      return obj;
    };
    deepCopy = function(a) {
      var key, newObject, val;
      if (a instanceof Object) {
        newObject = {};
        for (key in a) {
          val = a[key];
          newObject[key] = deepCopy(val);
        }
        return newObject;
      } else {
        return a;
      }
    };
    deepEquals = function(a, b) {
      var key, val;
      if (a instanceof Object) {
        for (key in a) {
          if (!hasProp.call(a, key)) continue;
          val = a[key];
          if (!deepEquals(b[key], val)) {
            return false;
          }
        }
        for (key in b) {
          if (!hasProp.call(b, key)) continue;
          val = b[key];
          if (!key in a) {
            if (!deepEquals(a[key], val)) {
              return false;
            }
          }
        }
        return true;
      } else {
        return a === b;
      }
    };
    unsortedEditorBindings = {
      'populate': [],
      'resize': [],
      'resize_palette': [],
      'redraw_main': [],
      'redraw_palette': [],
      'rebuild_palette': [],
      'mousedown': [],
      'mousemove': [],
      'mouseup': [],
      'dblclick': [],
      'keydown': [],
      'keyup': []
    };
    editorBindings = {};
    hook = function(event, priority, fn) {
      return unsortedEditorBindings[event].push({
        priority: priority,
        fn: fn
      });
    };
    exports.Editor = Editor = (function() {
      function Editor(wrapperElement, options) {
        var binding, boundListeners, dispatchKeyEvent, dispatchMouseEvent, elements, eventName, fn1, j, len, ref1, ref2;
        this.wrapperElement = wrapperElement;
        this.options = options;
        this.paletteGroups = this.options.palette;
        this.options.mode = this.options.mode.replace(/$\/ace\/mode\//, '');
        if (this.options.mode in modes) {
          this.mode = new modes[this.options.mode](this.options.modeOptions);
        } else {
          this.mode = new coffee(this.options.modeOptions);
        }
        this.draw = new draw.Draw();
        this.debugging = true;
        this.dropletElement = document.createElement('div');
        this.dropletElement.className = 'droplet-wrapper-div';
        this.dropletElement.tabIndex = 0;
        this.wrapperElement.appendChild(this.dropletElement);
        this.wrapperElement.style.backgroundColor = '#FFF';
        this.mainCanvas = document.createElement('canvas');
        this.mainCanvas.className = 'droplet-main-canvas';
        this.mainCanvas.width = this.mainCanvas.height = 0;
        this.mainCtx = this.mainCanvas.getContext('2d');
        this.dropletElement.appendChild(this.mainCanvas);
        this.paletteWrapper = this.paletteElement = document.createElement('div');
        this.paletteWrapper.className = 'droplet-palette-wrapper';
        this.paletteCanvas = document.createElement('canvas');
        this.paletteCanvas.className = 'droplet-palette-canvas';
        this.paletteCanvas.height = this.paletteCanvas.width = 0;
        this.paletteCtx = this.paletteCanvas.getContext('2d');
        this.paletteWrapper.appendChild(this.paletteCanvas);
        this.paletteElement.style.position = 'absolute';
        this.paletteElement.style.left = '0px';
        this.paletteElement.style.top = '0px';
        this.paletteElement.style.bottom = '0px';
        this.paletteElement.style.width = '270px';
        this.dropletElement.style.left = this.paletteElement.offsetWidth + 'px';
        this.wrapperElement.appendChild(this.paletteElement);
        this.draw.refreshFontCapital();
        this.standardViewSettings = {
          padding: 5,
          indentWidth: 20,
          textHeight: helper.getFontHeight('Courier New', 15),
          indentTongueHeight: 20,
          tabOffset: 10,
          tabWidth: 15,
          tabHeight: 4,
          tabSideWidth: 1 / 4,
          dropAreaHeight: 20,
          indentDropAreaMinWidth: 50,
          emptySocketWidth: 20,
          emptyLineHeight: 25,
          highlightAreaHeight: 10,
          shadowBlur: 5,
          ctx: this.mainCtx,
          draw: this.draw
        };
        this.bindings = {};
        this.view = new view.View(extend_(this.standardViewSettings, {
          respectEphemeral: true
        }));
        this.dragView = new view.View(extend_(this.standardViewSettings, {
          respectEphemeral: false
        }));
        boundListeners = [];
        ref1 = editorBindings.populate;
        for (j = 0, len = ref1.length; j < len; j++) {
          binding = ref1[j];
          binding.call(this);
        }
        window.addEventListener('resize', (function(_this) {
          return function() {
            return _this.resizeBlockMode();
          };
        })(this));
        dispatchMouseEvent = (function(_this) {
          return function(event) {
            var handler, k, len1, ref2, state, trackPoint;
            if (event.type !== 'mousemove' && event.which !== 1) {
              return;
            }
            trackPoint = new _this.draw.Point(event.clientX, event.clientY);
            state = {};
            ref2 = editorBindings[event.type];
            for (k = 0, len1 = ref2.length; k < len1; k++) {
              handler = ref2[k];
              handler.call(_this, trackPoint, event, state);
            }
            if (event.type === 'mousedown') {
              if (typeof event.stopPropagation === "function") {
                event.stopPropagation();
              }
              if (typeof event.preventDefault === "function") {
                event.preventDefault();
              }
              event.cancelBubble = true;
              event.returnValue = false;
              return false;
            }
          };
        })(this);
        dispatchKeyEvent = (function(_this) {
          return function(event) {
            var handler, k, len1, ref2, results, state;
            state = {};
            ref2 = editorBindings[event.type];
            results = [];
            for (k = 0, len1 = ref2.length; k < len1; k++) {
              handler = ref2[k];
              results.push(handler.call(_this, event, state));
            }
            return results;
          };
        })(this);
        ref2 = {
          keydown: [this.dropletElement, this.paletteElement],
          keyup: [this.dropletElement, this.paletteElement],
          mousedown: [this.dropletElement, this.paletteElement, this.dragCover],
          dblclick: [this.dropletElement, this.paletteElement, this.dragCover],
          mouseup: [window],
          mousemove: [window]
        };
        fn1 = (function(_this) {
          return function(eventName, elements) {
            var element, k, len1, results;
            results = [];
            for (k = 0, len1 = elements.length; k < len1; k++) {
              element = elements[k];
              if (/^key/.test(eventName)) {
                results.push(element.addEventListener(eventName, dispatchKeyEvent));
              } else {
                results.push(element.addEventListener(eventName, dispatchMouseEvent));
              }
            }
            return results;
          };
        })(this);
        for (eventName in ref2) {
          elements = ref2[eventName];
          fn1(eventName, elements);
        }
        this.tree = new model.Segment();
        this.tree.start.insert(this.cursor);
        this.resizeBlockMode();
        this.redrawMain();
        this.rebuildPalette();
        if (this.mode == null) {
          this.setEditorState(false);
        }
        return this;
      }

      Editor.prototype.setMode = function(mode, modeOptions) {
        var modeClass;
        modeClass = modes[mode];
        if (modeClass) {
          this.options.mode = mode;
          this.mode = new modeClass(modeOptions);
        } else {
          this.options.mode = null;
          this.mode = null;
        }
        return this.setValue(this.getValue());
      };

      Editor.prototype.getMode = function() {
        return this.options.mode;
      };

      Editor.prototype.resizeTextMode = function() {
        this.resizeAceElement();
        return this.aceEditor.resize(true);
      };

      Editor.prototype.resizeBlockMode = function() {
        this.resizeTextMode();
        this.dropletElement.style.left = this.paletteElement.offsetWidth + "px";
        this.dropletElement.style.height = this.wrapperElement.offsetHeight + "px";
        this.dropletElement.style.width = (this.wrapperElement.offsetWidth - this.paletteWrapper.offsetWidth) + "px";
        this.resizeGutter();
        this.mainCanvas.height = this.dropletElement.offsetHeight;
        this.mainCanvas.width = this.dropletElement.offsetWidth - this.gutter.offsetWidth;
        this.mainCanvas.style.height = this.mainCanvas.height + "px";
        this.mainCanvas.style.width = this.mainCanvas.width + "px";
        this.mainCanvas.style.left = this.gutter.offsetWidth + "px";
        this.transitionContainer.style.left = this.gutter.offsetWidth + "px";
        this.resizePalette();
        this.resizePaletteHighlight();
        this.resizeNubby();
        this.resizeMainScroller();
        this.resizeLassoCanvas();
        this.resizeCursorCanvas();
        this.resizeDragCanvas();
        this.scrollOffsets.main.y = this.mainScroller.scrollTop;
        this.scrollOffsets.main.x = this.mainScroller.scrollLeft;
        this.mainCtx.setTransform(1, 0, 0, 1, -this.scrollOffsets.main.x, -this.scrollOffsets.main.y);
        this.highlightCtx.setTransform(1, 0, 0, 1, -this.scrollOffsets.main.x, -this.scrollOffsets.main.y);
        this.cursorCtx.setTransform(1, 0, 0, 1, -this.scrollOffsets.main.x, -this.scrollOffsets.main.y);
        return this.redrawMain();
      };

      Editor.prototype.resizePalette = function() {

        /*
        @paletteWrapper.style.height = "#{@paletteElement.offsetHeight}px"
        @paletteWrapper.style.width = "#{@paletteElement.offsetWidth}px"
         */
        var binding, j, len, ref1;
        this.paletteCanvas.style.top = this.paletteHeader.offsetHeight + "px";
        this.paletteCanvas.height = this.paletteWrapper.offsetHeight - this.paletteHeader.offsetHeight;
        this.paletteCanvas.width = this.paletteWrapper.offsetWidth;
        this.paletteCanvas.style.height = this.paletteCanvas.height + "px";
        this.paletteCanvas.style.width = this.paletteCanvas.width + "px";
        ref1 = editorBindings.resize_palette;
        for (j = 0, len = ref1.length; j < len; j++) {
          binding = ref1[j];
          binding.call(this);
        }
        this.paletteCtx.setTransform(1, 0, 0, 1, -this.scrollOffsets.palette.x, -this.scrollOffsets.palette.y);
        this.paletteHighlightCtx.setTransform(1, 0, 0, 1, -this.scrollOffsets.palette.x, -this.scrollOffsets.palette.y);
        return this.rebuildPalette();
      };

      return Editor;

    })();
    Editor.prototype.resize = function() {
      if (this.currentlyUsingBlocks) {
        return this.resizeBlockMode();
      } else {
        return this.resizeTextMode();
      }
    };
    Editor.prototype.clearMain = function(opts) {
      if (opts.boundingRectangle != null) {
        return this.mainCtx.clearRect(opts.boundingRectangle.x, opts.boundingRectangle.y, opts.boundingRectangle.width, opts.boundingRectangle.height);
      } else {
        return this.mainCtx.clearRect(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.mainCanvas.width, this.mainCanvas.height);
      }
    };
    Editor.prototype.setTopNubbyStyle = function(height, color) {
      if (height == null) {
        height = 10;
      }
      if (color == null) {
        color = '#EBEBEB';
      }
      this.nubbyHeight = Math.max(0, height);
      this.nubbyColor = color;
      this.topNubbyPath = new this.draw.Path();
      if (height >= 0) {
        this.topNubbyPath.bevel = true;
        this.topNubbyPath.push(new this.draw.Point(this.mainCanvas.width, -5));
        this.topNubbyPath.push(new this.draw.Point(this.mainCanvas.width, height));
        this.topNubbyPath.push(new this.draw.Point(this.view.opts.tabOffset + this.view.opts.tabWidth, height));
        this.topNubbyPath.push(new this.draw.Point(this.view.opts.tabOffset + this.view.opts.tabWidth * (1 - this.view.opts.tabSideWidth), this.view.opts.tabHeight + height));
        this.topNubbyPath.push(new this.draw.Point(this.view.opts.tabOffset + this.view.opts.tabWidth * this.view.opts.tabSideWidth, this.view.opts.tabHeight + height));
        this.topNubbyPath.push(new this.draw.Point(this.view.opts.tabOffset, height));
        this.topNubbyPath.push(new this.draw.Point(-5, height));
        this.topNubbyPath.push(new this.draw.Point(-5, -5));
        this.topNubbyPath.style.fillColor = color;
      }
      return this.redrawMain();
    };
    Editor.prototype.resizeNubby = function() {
      return this.setTopNubbyStyle(this.nubbyHeight, this.nubbyColor);
    };
    Editor.prototype.redrawMain = function(opts) {
      var binding, j, layoutResult, len, oldScroll, ref1, ref2, ref3;
      if (opts == null) {
        opts = {};
      }
      if (!this.currentlyAnimating_suprressRedraw) {
        this.draw.setGlobalFontSize(this.fontSize);
        this.draw.setCtx(this.mainCtx);
        this.clearMain(opts);
        this.topNubbyPath.draw(this.mainCtx);
        if (opts.boundingRectangle != null) {
          this.mainCtx.save();
          opts.boundingRectangle.clip(this.mainCtx);
        }
        layoutResult = this.view.getViewNodeFor(this.tree).layout(0, this.nubbyHeight);
        this.view.getViewNodeFor(this.tree).draw(this.mainCtx, (ref1 = opts.boundingRectangle) != null ? ref1 : new this.draw.Rectangle(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.mainCanvas.width, this.mainCanvas.height), {
          grayscale: 0,
          selected: 0,
          noText: (ref2 = opts.noText) != null ? ref2 : false
        });
        this.redrawCursors();
        this.redrawHighlights();
        if (opts.boundingRectangle != null) {
          this.mainCtx.restore();
        }
        ref3 = editorBindings.redraw_main;
        for (j = 0, len = ref3.length; j < len; j++) {
          binding = ref3[j];
          binding.call(this, layoutResult);
        }
        if (this.changeEventVersion !== this.tree.version) {
          this.changeEventVersion = this.tree.version;
          this.suppressAceChangeEvent = true;
          oldScroll = this.aceEditor.session.getScrollTop();
          this.setAceValue(this.getValue());
          this.suppressAceChangeEvent = false;
          this.aceEditor.session.setScrollTop(oldScroll);
          this.fireEvent('change', []);
        }
        return null;
      }
    };
    Editor.prototype.redrawHighlights = function() {
      var id, info, line, path, ref1, ref2, ref3;
      this.clearHighlightCanvas();
      ref1 = this.markedLines;
      for (line in ref1) {
        info = ref1[line];
        if (this.inTree(info.model)) {
          path = this.getHighlightPath(info.model, info.style);
          path.draw(this.highlightCtx);
        } else {
          delete this.markedLines[line];
        }
      }
      ref2 = this.markedBlocks;
      for (id in ref2) {
        info = ref2[id];
        if (this.inTree(info.model)) {
          path = this.getHighlightPath(info.model, info.style);
          path.draw(this.highlightCtx);
        } else {
          delete this.markedLines[id];
        }
      }
      ref3 = this.extraMarks;
      for (id in ref3) {
        info = ref3[id];
        if (this.inTree(info.model)) {
          path = this.getHighlightPath(info.model, info.style);
          path.draw(this.highlightCtx);
        } else {
          delete this.extraMarks[id];
        }
      }
      return this.redrawCursors();
    };
    Editor.prototype.clearCursorCanvas = function() {
      return this.cursorCtx.clearRect(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.cursorCanvas.width, this.cursorCanvas.height);
    };
    Editor.prototype.redrawCursors = function() {
      this.clearCursorCanvas();
      if (this.textFocus != null) {
        return this.redrawTextHighlights();
      } else if (this.lassoSegment == null) {
        return this.drawCursor();
      }
    };
    Editor.prototype.drawCursor = function() {
      return this.strokeCursor(this.determineCursorPosition());
    };
    Editor.prototype.clearPalette = function() {
      return this.paletteCtx.clearRect(this.scrollOffsets.palette.x, this.scrollOffsets.palette.y, this.paletteCanvas.width, this.paletteCanvas.height);
    };
    Editor.prototype.clearPaletteHighlightCanvas = function() {
      return this.paletteHighlightCtx.clearRect(this.scrollOffsets.palette.x, this.scrollOffsets.palette.y, this.paletteHighlightCanvas.width, this.paletteHighlightCanvas.height);
    };
    Editor.prototype.redrawPalette = function() {
      var binding, boundingRect, entry, j, k, lastBottomEdge, len, len1, paletteBlockView, ref1, ref2, results;
      this.clearPalette();
      lastBottomEdge = PALETTE_TOP_MARGIN;
      boundingRect = new this.draw.Rectangle(this.scrollOffsets.palette.x, this.scrollOffsets.palette.y, this.paletteCanvas.width, this.paletteCanvas.height);
      ref1 = this.currentPaletteBlocks;
      for (j = 0, len = ref1.length; j < len; j++) {
        entry = ref1[j];
        paletteBlockView = this.view.getViewNodeFor(entry.block);
        paletteBlockView.layout(PALETTE_LEFT_MARGIN, lastBottomEdge);
        paletteBlockView.draw(this.paletteCtx, boundingRect);
        lastBottomEdge = paletteBlockView.getBounds().bottom() + PALETTE_MARGIN;
      }
      ref2 = editorBindings.redraw_palette;
      results = [];
      for (k = 0, len1 = ref2.length; k < len1; k++) {
        binding = ref2[k];
        results.push(binding.call(this));
      }
      return results;
    };
    Editor.prototype.rebuildPalette = function() {
      var binding, j, len, ref1, results;
      this.redrawPalette();
      ref1 = editorBindings.rebuild_palette;
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        binding = ref1[j];
        results.push(binding.call(this));
      }
      return results;
    };
    Editor.prototype.absoluteOffset = function(el) {
      var point;
      point = new this.draw.Point(el.offsetLeft, el.offsetTop);
      el = el.offsetParent;
      while (!(el === document.body || (el == null))) {
        point.x += el.offsetLeft - el.scrollLeft;
        point.y += el.offsetTop - el.scrollTop;
        el = el.offsetParent;
      }
      return point;
    };
    Editor.prototype.trackerPointToMain = function(point) {
      var gbr;
      if (this.mainCanvas.offsetParent == null) {
        return new this.draw.Point(NaN, NaN);
      }
      gbr = this.mainCanvas.getBoundingClientRect();
      return new this.draw.Point(point.x - gbr.left + this.scrollOffsets.main.x, point.y - gbr.top + this.scrollOffsets.main.y);
    };
    Editor.prototype.trackerPointToPalette = function(point) {
      var gbr;
      if (this.paletteCanvas.offsetParent == null) {
        return new this.draw.Point(NaN, NaN);
      }
      gbr = this.paletteCanvas.getBoundingClientRect();
      return new this.draw.Point(point.x - gbr.left + this.scrollOffsets.palette.x, point.y - gbr.top + this.scrollOffsets.palette.y);
    };
    Editor.prototype.trackerPointIsInMain = function(point) {
      var gbr;
      if (this.mainCanvas.offsetParent == null) {
        return false;
      }
      gbr = this.mainCanvas.getBoundingClientRect();
      return point.x >= gbr.left && point.x < gbr.right && point.y >= gbr.top && point.y < gbr.bottom;
    };
    Editor.prototype.trackerPointIsInMainScroller = function(point) {
      var gbr;
      if (this.mainScroller.offsetParent == null) {
        return false;
      }
      gbr = this.mainScroller.getBoundingClientRect();
      return point.x >= gbr.left && point.x < gbr.right && point.y >= gbr.top && point.y < gbr.bottom;
    };
    Editor.prototype.trackerPointIsInPalette = function(point) {
      var gbr;
      if (this.paletteCanvas.offsetParent == null) {
        return false;
      }
      gbr = this.paletteCanvas.getBoundingClientRect();
      return point.x >= gbr.left && point.x < gbr.right && point.y >= gbr.top && point.y < gbr.bottom;
    };
    Editor.prototype.hitTest = function(point, block) {
      var head, seek;
      head = block.start;
      seek = block.end;
      while (head !== seek) {
        if (head.type === 'blockStart' && this.view.getViewNodeFor(head.container).path.contains(point)) {
          seek = head.container.end;
        }
        head = head.next;
      }
      if (head !== block.end) {
        return head.container;
      } else if (block.type === 'block' && this.view.getViewNodeFor(block).path.contains(point)) {
        return block;
      } else {
        return null;
      }
    };
    hook('mousedown', 10, function() {
      var x, y;
      x = document.body.scrollLeft;
      y = document.body.scrollTop;
      this.dropletElement.focus();
      return window.scrollTo(x, y);
    });
    hook('populate', 0, function() {
      this.undoStack = [];
      return this.changeEventVersion = 0;
    });
    UndoOperation = (function() {
      function UndoOperation() {}

      UndoOperation.prototype.undo = function(editor) {
        return editor.tree.start;
      };

      UndoOperation.prototype.redo = function(editor) {
        return editor.tree.start;
      };

      return UndoOperation;

    })();
    Editor.prototype.removeBlankLines = function() {
      var head, next, results;
      head = this.tree.end.previousVisibleToken();
      results = [];
      while ((head != null ? head.type : void 0) === 'newline') {
        next = head.previousVisibleToken();
        head.remove();
        results.push(head = next);
      }
      return results;
    };
    Editor.prototype.addMicroUndoOperation = function(operation) {
      this.undoStack.push(operation);
      return this.removeBlankLines();
    };
    Editor.prototype.undo = function() {
      var operation;
      if (this.undoStack.length === 0) {
        return;
      }
      operation = this.undoStack.pop();
      if (operation === 'CAPTURE_POINT') {
        return;
      } else {
        this.moveCursorTo(operation.undo(this));
        this.undo();
      }
      return this.redrawMain();
    };
    Editor.prototype.clearUndoStack = function() {
      return this.undoStack.length = 0;
    };
    hook('keydown', 0, function(event, state) {
      if (event.which === Z_KEY && command_pressed(event)) {
        return this.undo();
      }
    });
    PickUpOperation = (function(superClass) {
      extend(PickUpOperation, superClass);

      function PickUpOperation(block) {
        var beforeToken, ref1, ref2;
        this.block = block.clone();
        beforeToken = block.start.prev;
        while (((beforeToken != null ? beforeToken.prev : void 0) != null) && ((ref1 = beforeToken.type) === 'newline' || ref1 === 'segmentStart' || ref1 === 'cursor')) {
          beforeToken = beforeToken.prev;
        }
        this.before = (ref2 = beforeToken != null ? beforeToken.getSerializedLocation() : void 0) != null ? ref2 : null;
      }

      PickUpOperation.prototype.undo = function(editor) {
        var clone;
        if (this.before == null) {
          return;
        }
        editor.spliceIn((clone = this.block.clone()), editor.tree.getTokenAtLocation(this.before));
        if (this.block.type === 'segment' && this.block.isLassoSegment) {
          editor.lassoSegment = this.block;
        }
        return clone.end;
      };

      PickUpOperation.prototype.redo = function(editor) {
        var blockStart;
        if (this.before == null) {
          return;
        }
        blockStart = editor.tree.getTokenAtLocation(this.before);
        while (blockStart.type !== this.block.start.type) {
          blockStart = blockStart.next;
        }
        if (this.block.start.type === 'segment') {
          editor.spliceOut(blockStart.container);
        } else {
          editor.spliceOut(blockStart.container);
        }
        return editor.tree.getTokenAtLocation(this.before);
      };

      return PickUpOperation;

    })(UndoOperation);
    DropOperation = (function(superClass) {
      extend(DropOperation, superClass);

      function DropOperation(block, dest) {
        var ref1;
        this.block = block.clone();
        this.dest = (ref1 = dest != null ? dest.getSerializedLocation() : void 0) != null ? ref1 : null;
        if ((dest != null ? dest.type : void 0) === 'socketStart') {
          this.displacedSocketText = dest.container.contents();
        } else {
          this.displacedSocketText = null;
        }
      }

      DropOperation.prototype.undo = function(editor) {
        var blockStart;
        if (this.dest == null) {
          return;
        }
        blockStart = editor.tree.getTokenAtLocation(this.dest);
        while (blockStart.type !== this.block.start.type) {
          blockStart = blockStart.next;
        }
        editor.spliceOut(blockStart.container);
        if (this.displacedSocketText != null) {
          editor.tree.getTokenAtLocation(this.dest).insert(this.displacedSocketText.clone());
        }
        return editor.tree.getTokenAtLocation(this.dest);
      };

      DropOperation.prototype.redo = function(editor) {
        var clone;
        if (this.dest == null) {
          return;
        }
        editor.spliceIn((clone = this.block.clone()), editor.tree.getTokenAtLocation(this.dest));
        return clone.end;
      };

      return DropOperation;

    })(UndoOperation);
    Editor.prototype.spliceOut = function(node) {
      var leading, ref1, trailing;
      leading = node.getLeadingText();
      if (node.start.next === node.end.prev) {
        trailing = null;
      } else {
        trailing = node.getTrailingText();
      }
      ref1 = this.mode.parens(leading, trailing, node.getReader(), null), leading = ref1[0], trailing = ref1[1];
      node.setLeadingText(leading);
      node.setTrailingText(trailing);
      return node.spliceOut();
    };
    Editor.prototype.spliceIn = function(node, location) {
      var container, leading, ref1, ref2, ref3, ref4, trailing;
      leading = node.getLeadingText();
      if (node.start.next === node.end.prev) {
        trailing = null;
      } else {
        trailing = node.getTrailingText();
      }
      container = (ref1 = location.container) != null ? ref1 : location.visParent();
      ref4 = this.mode.parens(leading, trailing, node.getReader(), (ref2 = (ref3 = (container.type === 'block' ? container.visParent() : container)) != null ? typeof ref3.getReader === "function" ? ref3.getReader() : void 0 : void 0) != null ? ref2 : null), leading = ref4[0], trailing = ref4[1];
      node.setLeadingText(leading);
      node.setTrailingText(trailing);
      return node.spliceIn(location);
    };
    hook('populate', 0, function() {
      this.clickedPoint = null;
      this.clickedBlock = null;
      this.clickedBlockIsPaletteBlock = false;
      this.draggingBlock = null;
      this.draggingOffset = null;
      this.lastHighlight = null;
      this.dragCanvas = document.createElement('canvas');
      this.dragCanvas.className = 'droplet-drag-canvas';
      this.dragCanvas.style.left = '-9999px';
      this.dragCanvas.style.top = '-9999px';
      this.dragCtx = this.dragCanvas.getContext('2d');
      this.highlightCanvas = document.createElement('canvas');
      this.highlightCanvas.className = 'droplet-highlight-canvas';
      this.highlightCtx = this.highlightCanvas.getContext('2d');
      this.wrapperElement.appendChild(this.dragCanvas);
      return this.dropletElement.appendChild(this.highlightCanvas);
    });
    Editor.prototype.clearHighlightCanvas = function() {
      return this.highlightCtx.clearRect(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.highlightCanvas.width, this.highlightCanvas.height);
    };
    Editor.prototype.clearDrag = function() {
      return this.dragCtx.clearRect(0, 0, this.dragCanvas.width, this.dragCanvas.height);
    };
    Editor.prototype.resizeDragCanvas = function() {
      this.dragCanvas.width = 0;
      this.dragCanvas.height = 0;
      this.highlightCanvas.width = this.dropletElement.offsetWidth;
      this.highlightCanvas.style.width = this.highlightCanvas.width + "px";
      this.highlightCanvas.height = this.dropletElement.offsetHeight;
      this.highlightCanvas.style.height = this.highlightCanvas.height + "px";
      return this.highlightCanvas.style.left = this.mainCanvas.offsetLeft + "px";
    };
    hook('mousedown', 1, function(point, event, state) {
      var box, hitTestResult, i, j, len, line, mainPoint, node, ref1;
      if (state.consumedHitTest) {
        return;
      }
      if (!this.trackerPointIsInMain(point)) {
        return;
      }
      mainPoint = this.trackerPointToMain(point);
      hitTestResult = this.hitTest(mainPoint, this.tree);
      if (this.debugging && event.shiftKey) {
        line = null;
        node = this.view.getViewNodeFor(hitTestResult);
        ref1 = node.bounds;
        for (i = j = 0, len = ref1.length; j < len; i = ++j) {
          box = ref1[i];
          if (box.contains(mainPoint)) {
            line = i;
            break;
          }
        }
        this.dumpNodeForDebug(hitTestResult, line);
      }
      if (hitTestResult != null) {
        this.setTextInputFocus(null);
        this.clickedBlock = hitTestResult;
        this.clickedBlockIsPaletteBlock = false;
        this.moveCursorTo(this.clickedBlock.start.next);
        this.clickedPoint = point;
        return state.consumedHitTest = true;
      }
    });
    hook('mouseup', 0, function(point, event, state) {
      if (this.clickedBlock != null) {
        this.clickedBlock = null;
        return this.clickedPoint = null;
      }
    });
    Editor.prototype.wouldDelete = function(position) {
      var mainPoint, palettePoint, ref1, ref2, ref3, ref4;
      mainPoint = this.trackerPointToMain(position);
      palettePoint = this.trackerPointToPalette(position);
      return !this.lastHighlight && !((this.mainCanvas.width + this.scrollOffsets.main.x > (ref1 = mainPoint.x) && ref1 > this.scrollOffsets.main.x) && (this.mainCanvas.height + this.scrollOffsets.main.y > (ref2 = mainPoint.y) && ref2 > this.scrollOffsets.main.y)) || ((this.paletteCanvas.width + this.scrollOffsets.palette.x > (ref3 = palettePoint.x) && ref3 > this.scrollOffsets.palette.x) && (this.paletteCanvas.height + this.scrollOffsets.palette.y > (ref4 = palettePoint.y) && ref4 > this.scrollOffsets.palette.y));
    };
    hook('mousemove', 1, function(point, event, state) {
      var acceptLevel, bound, draggingBlockView, dropPoint, head, j, len, line, mainPoint, position, ref1, viewNode;
      if (!state.capturedPickup && (this.clickedBlock != null) && point.from(this.clickedPoint).magnitude() > MIN_DRAG_DISTANCE) {
        this.draggingBlock = this.clickedBlock;
        if (this.clickedBlockIsPaletteBlock) {
          this.draggingOffset = this.view.getViewNodeFor(this.draggingBlock).bounds[0].upperLeftCorner().from(this.trackerPointToPalette(this.clickedPoint));
          this.draggingBlock = this.draggingBlock.clone();
        } else {
          mainPoint = this.trackerPointToMain(this.clickedPoint);
          viewNode = this.view.getViewNodeFor(this.draggingBlock);
          this.draggingOffset = null;
          ref1 = viewNode.bounds;
          for (line = j = 0, len = ref1.length; j < len; line = ++j) {
            bound = ref1[line];
            if (bound.contains(mainPoint)) {
              this.draggingOffset = bound.upperLeftCorner().from(mainPoint);
              this.draggingOffset.y += viewNode.bounds[0].y - bound.y;
              break;
            }
          }
          if (this.draggingOffset == null) {
            this.draggingOffset = viewNode.bounds[0].upperLeftCorner().from(mainPoint);
          }
        }
        this.draggingBlock.ephemeral = true;
        this.draggingBlock.clearLineMarks();
        draggingBlockView = this.dragView.getViewNodeFor(this.draggingBlock);
        draggingBlockView.layout(1, 1);
        this.dragCanvas.width = Math.min(draggingBlockView.totalBounds.width + 10, window.screen.width);
        this.dragCanvas.height = Math.min(draggingBlockView.totalBounds.height + 10, window.screen.height);
        draggingBlockView.drawShadow(this.dragCtx, 5, 5);
        draggingBlockView.draw(this.dragCtx, new this.draw.Rectangle(0, 0, this.dragCanvas.width, this.dragCanvas.height));
        position = new this.draw.Point(point.x + this.draggingOffset.x, point.y + this.draggingOffset.y);
        this.dropPointQuadTree = QUAD.init({
          x: this.scrollOffsets.main.x,
          y: this.scrollOffsets.main.y,
          w: this.mainCanvas.width,
          h: this.mainCanvas.height
        });
        head = this.tree.start;
        while (head !== this.tree.end) {
          if (head === this.draggingBlock.start) {
            head = this.draggingBlock.end;
          }
          if (head instanceof model.StartToken) {
            acceptLevel = this.getAcceptLevel(this.draggingBlock, head.container);
            if (acceptLevel !== helper.FORBID) {
              dropPoint = this.view.getViewNodeFor(head.container).dropPoint;
              if (dropPoint != null) {
                this.dropPointQuadTree.insert({
                  x: dropPoint.x,
                  y: dropPoint.y,
                  w: 0,
                  h: 0,
                  acceptLevel: acceptLevel,
                  _ice_node: head.container
                });
              }
            }
          }
          head = head.next;
        }
        this.dragCanvas.style.top = (position.y + getOffsetTop(this.dropletElement)) + "px";
        this.dragCanvas.style.left = (position.x + getOffsetLeft(this.dropletElement)) + "px";
        this.clickedPoint = this.clickedBlock = null;
        this.clickedBlockIsPaletteBlock = false;
        this.begunTrash = this.wouldDelete(position);
        return this.redrawMain();
      }
    });
    Editor.prototype.getAcceptLevel = function(drag, drop) {
      if (drop.type === 'socket') {
        if (drag.type === 'segment') {
          return helper.FORBID;
        } else {
          return this.mode.drop(drag.getReader(), drop.getReader(), null);
        }
      } else if (drop.type === 'block') {
        if (drop.visParent().type === 'socket') {
          return helper.FORBID;
        } else {
          return this.mode.drop(drag.getReader(), drop.visParent().getReader(), drop);
        }
      } else {
        return this.mode.drop(drag.getReader(), drop.getReader(), drop.getReader());
      }
    };
    hook('mousemove', 0, function(point, event, state) {
      var best, head, mainPoint, min, palettePoint, position, rect, ref1, ref2, ref3, testPoints;
      if (this.draggingBlock != null) {
        position = new this.draw.Point(point.x + this.draggingOffset.x, point.y + this.draggingOffset.y);
        rect = this.wrapperElement.getBoundingClientRect();
        this.dragCanvas.style.top = (position.y - rect.top) + "px";
        this.dragCanvas.style.left = (position.x - rect.left) + "px";
        mainPoint = this.trackerPointToMain(position);
        best = null;
        min = Infinity;
        head = this.tree.start.next;
        while (((ref1 = head.type) === 'newline' || ref1 === 'cursor') || head.type === 'text' && head.value === '') {
          head = head.next;
        }
        if (head === this.tree.end && (this.mainCanvas.width + this.scrollOffsets.main.x > (ref2 = mainPoint.x) && ref2 > this.scrollOffsets.main.x - this.gutter.offsetWidth) && (this.mainCanvas.height + this.scrollOffsets.main.y > (ref3 = mainPoint.y) && ref3 > this.scrollOffsets.main.y)) {
          this.view.getViewNodeFor(this.tree).highlightArea.draw(this.highlightCtx);
          this.lastHighlight = this.tree;
        } else {
          testPoints = this.dropPointQuadTree.retrieve({
            x: mainPoint.x - MAX_DROP_DISTANCE,
            y: mainPoint.y - MAX_DROP_DISTANCE,
            w: MAX_DROP_DISTANCE * 2,
            h: MAX_DROP_DISTANCE * 2
          }, (function(_this) {
            return function(point) {
              var distance;
              if (!((point.acceptLevel === helper.DISCOURAGE) && !event.shiftKey)) {
                distance = mainPoint.from(point);
                distance.y *= 2;
                distance = distance.magnitude();
                if (distance < min && mainPoint.from(point).magnitude() < MAX_DROP_DISTANCE && (_this.view.getViewNodeFor(point._ice_node).highlightArea != null)) {
                  best = point._ice_node;
                  return min = distance;
                }
              }
            };
          })(this));
          if (best !== this.lastHighlight) {
            this.clearHighlightCanvas();
            if (best != null) {
              this.view.getViewNodeFor(best).highlightArea.draw(this.highlightCtx);
            }
            this.lastHighlight = best;
          }
        }
        palettePoint = this.trackerPointToPalette(position);
        if (this.wouldDelete(position)) {
          if (this.begunTrash) {
            return this.dragCanvas.style.opacity = 0.85;
          } else {
            return this.dragCanvas.style.opacity = 0.3;
          }
        } else {
          this.dragCanvas.style.opacity = 0.85;
          return this.begunTrash = false;
        }
      }
    });
    hook('mouseup', 0, function() {
      clearTimeout(this.discourageDropTimeout);
      return this.discourageDropTimeout = null;
    });
    hook('mouseup', 1, function(point, event, state) {
      var head;
      if ((this.draggingBlock != null) && (this.lastHighlight != null)) {
        if (this.inTree(this.draggingBlock)) {
          this.addMicroUndoOperation('CAPTURE_POINT');
          this.addMicroUndoOperation(new PickUpOperation(this.draggingBlock));
          this.spliceOut(this.draggingBlock);
        }
        this.clearHighlightCanvas();
        switch (this.lastHighlight.type) {
          case 'indent':
          case 'socket':
            this.addMicroUndoOperation(new DropOperation(this.draggingBlock, this.lastHighlight.start));
            this.spliceIn(this.draggingBlock, this.lastHighlight.start);
            break;
          case 'block':
            this.addMicroUndoOperation(new DropOperation(this.draggingBlock, this.lastHighlight.end));
            this.spliceIn(this.draggingBlock, this.lastHighlight.end);
            break;
          default:
            if (this.lastHighlight === this.tree) {
              this.addMicroUndoOperation(new DropOperation(this.draggingBlock, this.tree.start));
              this.spliceIn(this.draggingBlock, this.tree.start);
            }
        }
        this.moveCursorTo(this.draggingBlock.end, true);
        if (this.lastHighlight.type === 'socket') {
          this.reparseRawReplace(this.draggingBlock.parent.parent);
        } else {
          head = this.draggingBlock.start;
          while (!(head.type === 'socketStart' && head.container.isDroppable() || head === this.draggingBlock.end)) {
            head = head.next;
          }
          if (head.type === 'socketStart') {
            this.setTextInputFocus(null);
            this.setTextInputFocus(head.container);
          }
        }
        return this.endDrag();
      }
    });
    Editor.prototype.reparseRawReplace = function(oldBlock) {
      var e, newBlock, newParse, pos;
      try {
        newParse = this.mode.parse(oldBlock.stringify(this.mode.empty), {
          wrapAtRoot: true
        });
        newBlock = newParse.start.next.container;
        if (newParse.start.next.container.end === newParse.end.prev && (newBlock != null ? newBlock.type : void 0) === 'block') {
          this.addMicroUndoOperation(new ReparseOperation(oldBlock, newBlock));
          if (this.cursor.hasParent(oldBlock)) {
            pos = this.getRecoverableCursorPosition();
            newBlock.rawReplace(oldBlock);
            return this.recoverCursorPosition(pos);
          } else {
            return newBlock.rawReplace(oldBlock);
          }
        }
      } catch (_error) {
        e = _error;
        throw e;
        return false;
      }
    };
    Editor.prototype.findForReal = function(token) {
      var head, i;
      head = this.tree.start;
      i = 0;
      while (!(head === token || head === this.tree.end || (head == null))) {
        head = head.next;
        i++;
      }
      if (head === token) {
        return i;
      } else {
        return null;
      }
    };
    hook('populate', 0, function() {
      return this.floatingBlocks = [];
    });
    FloatingBlockRecord = (function() {
      function FloatingBlockRecord(block1, position1) {
        this.block = block1;
        this.position = position1;
      }

      return FloatingBlockRecord;

    })();
    ToFloatingOperation = (function(superClass) {
      extend(ToFloatingOperation, superClass);

      function ToFloatingOperation(block, position, editor) {
        this.position = new editor.draw.Point(position.x, position.y);
        ToFloatingOperation.__super__.constructor.call(this, block, null);
      }

      ToFloatingOperation.prototype.undo = function(editor) {
        editor.floatingBlocks.pop();
        return ToFloatingOperation.__super__.undo.apply(this, arguments);
      };

      ToFloatingOperation.prototype.redo = function(editor) {
        editor.floatingBlocks.push(new FloatingBlockRecord(this.block.clone(), this.position));
        return ToFloatingOperation.__super__.redo.apply(this, arguments);
      };

      return ToFloatingOperation;

    })(DropOperation);
    FromFloatingOperation = (function() {
      function FromFloatingOperation(record, editor) {
        this.position = new editor.draw.Point(record.position.x, record.position.y);
        this.block = record.block.clone();
      }

      FromFloatingOperation.prototype.undo = function(editor) {
        editor.floatingBlocks.push(new FloatingBlockRecord(this.block.clone(), this.position));
        return null;
      };

      FromFloatingOperation.prototype.redo = function(editor) {
        editor.floatingBlocks.pop();
        return null;
      };

      return FromFloatingOperation;

    })();
    Editor.prototype.inTree = function(block) {
      if (block.container != null) {
        block = block.container;
      }
      while (!(block === this.tree || (block == null))) {
        block = block.parent;
      }
      return block === this.tree;
    };
    hook('mouseup', 0, function(point, event, state) {
      var palettePoint, ref1, ref2, ref3, ref4, renderPoint, trackPoint;
      if ((this.draggingBlock != null) && (this.lastHighlight == null)) {
        trackPoint = new this.draw.Point(point.x + this.draggingOffset.x, point.y + this.draggingOffset.y);
        renderPoint = this.trackerPointToMain(trackPoint);
        palettePoint = this.trackerPointToPalette(trackPoint);
        if (this.inTree(this.draggingBlock)) {
          this.moveCursorTo(this.draggingBlock.end);
          this.addMicroUndoOperation('CAPTURE_POINT');
          this.addMicroUndoOperation(new PickUpOperation(this.draggingBlock));
          this.spliceOut(this.draggingBlock);
        }
        palettePoint = this.trackerPointToPalette(point);
        if ((0 < (ref1 = palettePoint.x - this.scrollOffsets.palette.x) && ref1 < this.paletteCanvas.width) && (0 < (ref2 = palettePoint.y - this.scrollOffsets.palette.y) && ref2 < this.paletteCanvas.height) || !((-this.gutter.offsetWidth < (ref3 = renderPoint.x - this.scrollOffsets.main.x) && ref3 < this.mainCanvas.width) && (0 < (ref4 = renderPoint.y - this.scrollOffsets.main.y) && ref4 < this.mainCanvas.height))) {
          if (this.draggingBlock === this.lassoSegment) {
            this.lassoSegment = null;
          }
          this.endDrag();
          return;
        } else if (renderPoint.x - this.scrollOffsets.main.x < 0) {
          renderPoint.x = this.scrollOffsets.main.x;
        }
        this.addMicroUndoOperation(new ToFloatingOperation(this.draggingBlock, renderPoint, this));
        this.floatingBlocks.push(new FloatingBlockRecord(this.draggingBlock, renderPoint));
        this.draggingBlock = null;
        this.draggingOffset = null;
        this.lastHighlight = null;
        this.clearDrag();
        this.redrawMain();
        return this.redrawHighlights();
      }
    });
    hook('mousedown', 5, function(point, event, state) {
      var hitTestResult, i, j, len, record, ref1, results;
      if (state.consumedHitTest) {
        return;
      }
      if (!this.trackerPointIsInMain(point)) {
        return;
      }
      ref1 = this.floatingBlocks;
      results = [];
      for (i = j = 0, len = ref1.length; j < len; i = ++j) {
        record = ref1[i];
        hitTestResult = this.hitTest(this.trackerPointToMain(point), record.block);
        if (hitTestResult != null) {
          this.setTextInputFocus(null);
          this.clickedBlock = record.block;
          this.clickedPoint = point;
          state.consumedHitTest = true;
          results.push(this.redrawMain());
        } else {
          results.push(void 0);
        }
      }
      return results;
    });
    hook('mousemove', 7, function(point, event, state) {
      var i, j, len, record, ref1;
      if ((this.clickedBlock != null) && point.from(this.clickedPoint).magnitude() > MIN_DRAG_DISTANCE) {
        ref1 = this.floatingBlocks;
        for (i = j = 0, len = ref1.length; j < len; i = ++j) {
          record = ref1[i];
          if (record.block === this.clickedBlock) {
            if (!state.addedCapturePoint) {
              this.addMicroUndoOperation('CAPTURE_POINT');
              state.addedCapturePoint = true;
            }
            this.addMicroUndoOperation(new FromFloatingOperation(record, this));
            this.floatingBlocks.splice(i, 1);
            this.redrawMain();
            return;
          }
        }
      }
    });
    hook('redraw_main', 7, function() {
      var blockView, boundingRect, j, len, record, ref1, results;
      boundingRect = new this.draw.Rectangle(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.mainCanvas.width, this.mainCanvas.height);
      ref1 = this.floatingBlocks;
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        record = ref1[j];
        blockView = this.view.getViewNodeFor(record.block);
        blockView.layout(record.position.x, record.position.y);
        results.push(blockView.draw(this.mainCtx, boundingRect));
      }
      return results;
    });
    hook('populate', 0, function() {
      this.paletteHeader = document.createElement('div');
      this.paletteHeader.className = 'droplet-palette-header';
      this.paletteWrapper.appendChild(this.paletteHeader);
      return this.setPalette(this.paletteGroups);
    });
    Editor.prototype.setPalette = function(paletteGroups) {
      var fn1, i, j, len, paletteGroup, paletteHeaderRow, ref1;
      this.paletteHeader.innerHTML = '';
      this.paletteGroups = paletteGroups;
      this.currentPaletteBlocks = [];
      this.currentPaletteMetadata = [];
      paletteHeaderRow = null;
      ref1 = this.paletteGroups;
      fn1 = (function(_this) {
        return function(paletteGroup, i) {
          var clickHandler, data, k, len1, newBlock, newPaletteBlocks, paletteGroupBlocks, paletteGroupHeader, ref2, updatePalette;
          if (i % 2 === 0) {
            paletteHeaderRow = document.createElement('div');
            paletteHeaderRow.className = 'droplet-palette-header-row';
            _this.paletteHeader.appendChild(paletteHeaderRow);
          }
          paletteGroupHeader = document.createElement('div');
          paletteGroupHeader.className = 'droplet-palette-group-header';
          paletteGroupHeader.innerText = paletteGroupHeader.textContent = paletteGroupHeader.textContent = paletteGroup.name;
          if (paletteGroup.color) {
            paletteGroupHeader.className += ' ' + paletteGroup.color;
          }
          paletteHeaderRow.appendChild(paletteGroupHeader);
          newPaletteBlocks = [];
          ref2 = paletteGroup.blocks;
          for (k = 0, len1 = ref2.length; k < len1; k++) {
            data = ref2[k];
            newBlock = _this.mode.parse(data.block).start.next.container;
            newBlock.spliceOut();
            newBlock.parent = null;
            newPaletteBlocks.push({
              block: newBlock,
              title: data.title,
              id: data.id
            });
          }
          paletteGroupBlocks = newPaletteBlocks;
          updatePalette = function() {
            var ref3;
            _this.currentPaletteGroup = paletteGroup.name;
            _this.currentPaletteBlocks = paletteGroupBlocks;
            _this.currentPaletteMetadata = paletteGroupBlocks;
            if ((ref3 = _this.currentPaletteGroupHeader) != null) {
              ref3.className = _this.currentPaletteGroupHeader.className.replace(/\s[-\w]*-selected\b/, '');
            }
            _this.currentPaletteGroupHeader = paletteGroupHeader;
            _this.currentPaletteIndex = i;
            _this.currentPaletteGroupHeader.className += ' droplet-palette-group-header-selected';
            _this.rebuildPalette();
            return _this.fireEvent('selectpalette', [paletteGroup.name]);
          };
          clickHandler = function() {
            return updatePalette();
          };
          paletteGroupHeader.addEventListener('click', clickHandler);
          paletteGroupHeader.addEventListener('touchstart', clickHandler);
          if (i === 0) {
            return updatePalette();
          }
        };
      })(this);
      for (i = j = 0, len = ref1.length; j < len; i = ++j) {
        paletteGroup = ref1[i];
        fn1(paletteGroup, i);
      }
      return this.resizePalette();
    };
    hook('mousedown', 6, function(point, event, state) {
      var entry, hitTestResult, j, len, palettePoint, ref1, ref2, ref3;
      if (state.consumedHitTest) {
        return;
      }
      if (!this.trackerPointIsInPalette(point)) {
        return;
      }
      palettePoint = this.trackerPointToPalette(point);
      if ((this.scrollOffsets.palette.y < (ref1 = palettePoint.y) && ref1 < this.scrollOffsets.palette.y + this.paletteCanvas.height) && (this.scrollOffsets.palette.x < (ref2 = palettePoint.x) && ref2 < this.scrollOffsets.palette.x + this.paletteCanvas.width)) {
        ref3 = this.currentPaletteBlocks;
        for (j = 0, len = ref3.length; j < len; j++) {
          entry = ref3[j];
          hitTestResult = this.hitTest(palettePoint, entry.block);
          if (hitTestResult != null) {
            this.setTextInputFocus(null);
            this.clickedBlock = entry.block;
            this.clickedPoint = point;
            this.clickedBlockIsPaletteBlock = true;
            state.consumedHitTest = true;
            this.fireEvent('pickblock', [entry.id]);
            return;
          }
        }
      }
      return this.clickedBlockIsPaletteBlock = false;
    });
    hook('populate', 1, function() {
      this.paletteHighlightCanvas = document.createElement('canvas');
      this.paletteHighlightCanvas.className = 'droplet-palette-highlight-canvas';
      this.paletteHighlightCtx = this.paletteHighlightCanvas.getContext('2d');
      this.paletteHighlightPath = null;
      this.currentHighlightedPaletteBlock = null;
      return this.paletteWrapper.appendChild(this.paletteHighlightCanvas);
    });
    Editor.prototype.resizePaletteHighlight = function() {
      this.paletteHighlightCanvas.style.top = this.paletteHeader.offsetHeight + 'px';
      this.paletteHighlightCanvas.width = this.paletteCanvas.width;
      return this.paletteHighlightCanvas.height = this.paletteCanvas.height;
    };
    hook('redraw_palette', 0, function() {
      this.clearPaletteHighlightCanvas();
      if (this.currentHighlightedPaletteBlock != null) {
        return this.paletteHighlightPath.draw(this.paletteHighlightCtx);
      }
    });
    hook('rebuild_palette', 1, function() {
      var block, bounds, data, fn1, hoverDiv, j, len, ref1, ref2, results;
      this.paletteScrollerStuffing.innerHTML = '';
      this.currentHighlightedPaletteBlock = null;
      ref1 = this.currentPaletteMetadata;
      fn1 = (function(_this) {
        return function(block) {
          hoverDiv.addEventListener('mousemove', function(event) {
            var palettePoint;
            palettePoint = _this.trackerPointToPalette(new _this.draw.Point(event.clientX, event.clientY));
            if (_this.mainViewOrChildrenContains(block, palettePoint)) {
              if (block !== _this.currentHighlightedPaletteBlock) {
                _this.clearPaletteHighlightCanvas();
                _this.paletteHighlightPath = _this.getHighlightPath(block, {
                  color: '#FF0'
                });
                _this.paletteHighlightPath.draw(_this.paletteHighlightCtx);
                return _this.currentHighlightedPaletteBlock = block;
              }
            } else if (block === _this.currentHighlightedPaletteBlock) {
              _this.currentHighlightedPaletteBlock = null;
              return _this.clearPaletteHighlightCanvas();
            }
          });
          return hoverDiv.addEventListener('mouseout', function(event) {
            if (block === _this.currentHighlightedPaletteBlock) {
              _this.currentHighlightedPaletteBlock = null;
              return _this.paletteHighlightCtx.clearRect(_this.scrollOffsets.palette.x, _this.scrollOffsets.palette.y, _this.paletteHighlightCanvas.width + _this.scrollOffsets.palette.x, _this.paletteHighlightCanvas.height + _this.scrollOffsets.palette.y);
            }
          });
        };
      })(this);
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        data = ref1[j];
        block = data.block;
        hoverDiv = document.createElement('div');
        hoverDiv.className = 'droplet-hover-div';
        hoverDiv.title = (ref2 = data.title) != null ? ref2 : block.stringify(this.mode.empty);
        bounds = this.view.getViewNodeFor(block).totalBounds;
        hoverDiv.style.top = bounds.y + "px";
        hoverDiv.style.left = bounds.x + "px";
        hoverDiv.style.width = (Math.min(bounds.width, Infinity)) + "px";
        hoverDiv.style.height = bounds.height + "px";
        fn1(block);
        results.push(this.paletteScrollerStuffing.appendChild(hoverDiv));
      }
      return results;
    });
    TextChangeOperation = (function(superClass) {
      extend(TextChangeOperation, superClass);

      function TextChangeOperation(socket, before1, editor) {
        this.before = before1;
        this.after = socket.stringify(editor.mode.empty);
        this.socket = socket.start.getSerializedLocation();
      }

      TextChangeOperation.prototype.undo = function(editor) {
        var socket;
        socket = editor.tree.getTokenAtLocation(this.socket).container;
        return editor.populateSocket(socket, this.before);
      };

      TextChangeOperation.prototype.redo = function(editor) {
        var socket;
        socket = editor.tree.getTokenAtLocation(this.socket).container;
        return editor.populateSocket(this.socket, this.after);
      };

      return TextChangeOperation;

    })(UndoOperation);
    TextReparseOperation = (function(superClass) {
      extend(TextReparseOperation, superClass);

      function TextReparseOperation(socket, before1) {
        this.before = before1;
        this.after = socket.start.next.container;
        this.socket = socket.start.getSerializedLocation();
      }

      TextReparseOperation.prototype.undo = function(editor) {
        var socket;
        socket = editor.tree.getTokenAtLocation(this.socket).container;
        editor.spliceOut(socket.start.next.container);
        return socket.start.insert(new model.TextToken(this.before));
      };

      TextReparseOperation.prototype.redo = function(editor) {
        var socket;
        socket = editor.tree.getTokenAtLocation(this.socket).container;
        socket.start.append(socket.end);
        socket.notifyChange();
        return editor.spliceIn(this.after.clone(), socket);
      };

      return TextReparseOperation;

    })(UndoOperation);
    hook('populate', 1, function() {
      var event, j, len, ref1, results;
      this.hiddenInput = document.createElement('textarea');
      this.hiddenInput.className = 'droplet-hidden-input';
      this.hiddenInput.addEventListener('focus', (function(_this) {
        return function() {
          var bounds;
          if (_this.textFocus != null) {
            bounds = _this.view.getViewNodeFor(_this.textFocus).bounds[0];
            _this.hiddenInput.style.left = (bounds.x + _this.mainCanvas.offsetLeft) + 'px';
            return _this.hiddenInput.style.top = bounds.y + 'px';
          }
        };
      })(this));
      this.dropletElement.appendChild(this.hiddenInput);
      this.textFocus = null;
      this.textInputAnchor = null;
      this.textInputSelecting = false;
      this.oldFocusValue = null;
      this.hiddenInput.addEventListener('keydown', (function(_this) {
        return function(event) {
          var ref1;
          if (event.keyCode === 8 && _this.hiddenInput.value.length > 1 && _this.hiddenInput.value[0] === _this.hiddenInput.value[_this.hiddenInput.value.length - 1] && ((ref1 = _this.hiddenInput.value[0]) === '\'' || ref1 === '\"') && _this.hiddenInput.selectionEnd === 1) {
            return event.preventDefault();
          }
        };
      })(this));
      ref1 = ['input', 'keyup', 'keydown', 'select'];
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        event = ref1[j];
        results.push(this.hiddenInput.addEventListener(event, (function(_this) {
          return function() {
            _this.highlightFlashShow();
            if (_this.textFocus != null) {
              _this.populateSocket(_this.textFocus, _this.hiddenInput.value);
              return _this.redrawTextInput();
            }
          };
        })(this)));
      }
      return results;
    });
    Editor.prototype.resizeAceElement = function() {
      this.aceElement.style.width = this.wrapperElement.offsetWidth + "px";
      return this.aceElement.style.height = this.wrapperElement.offsetHeight + "px";
    };
    last_ = function(array) {
      return array[array.length - 1];
    };
    Editor.prototype.redrawTextInput = function() {
      var endRow, head, line, newp, oldp, rect, sameLength, startRow, textFocusView, treeView;
      sameLength = this.textFocus.stringify(this.mode.empty).split('\n').length === this.hiddenInput.value.split('\n').length;
      this.populateSocket(this.textFocus, this.hiddenInput.value);
      textFocusView = this.view.getViewNodeFor(this.textFocus);
      startRow = this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionStart).split('\n').length - 1;
      endRow = this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionEnd).split('\n').length - 1;
      if (sameLength && startRow === endRow) {
        line = endRow;
        head = this.textFocus.start;
        while (head !== this.tree.start) {
          head = head.prev;
          if (head.type === 'newline') {
            line++;
          }
        }
        treeView = this.view.getViewNodeFor(this.tree);
        oldp = deepCopy([treeView.glue[line - 1], treeView.glue[line], treeView.bounds[line].height]);
        treeView.layout(0, this.nubbyHeight);
        newp = deepCopy([treeView.glue[line - 1], treeView.glue[line], treeView.bounds[line].height]);
        if (deepEquals(newp, oldp)) {
          rect = new this.draw.NoRectangle();
          if (line > 0) {
            rect.unite(treeView.bounds[line - 1]);
          }
          rect.unite(treeView.bounds[line]);
          if (line + 1 < treeView.bounds.length) {
            rect.unite(treeView.bounds[line + 1]);
          }
          rect.width = Math.max(rect.width, this.mainCanvas.width);
          return this.redrawMain({
            boundingRectangle: rect
          });
        } else {
          return this.redrawMain();
        }
      } else {
        return this.redrawMain();
      }
    };
    Editor.prototype.redrawTextHighlights = function(scrollIntoView) {
      var endPosition, endRow, i, j, lines, ref1, ref2, startPosition, startRow, textFocusView;
      if (scrollIntoView == null) {
        scrollIntoView = false;
      }
      textFocusView = this.view.getViewNodeFor(this.textFocus);
      startRow = this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionStart).split('\n').length - 1;
      endRow = this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionEnd).split('\n').length - 1;
      lines = this.textFocus.stringify(this.mode.empty).split('\n');
      startPosition = textFocusView.bounds[startRow].x + this.view.opts.textPadding + this.mainCtx.measureText(last_(this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionStart).split('\n'))).width;
      endPosition = textFocusView.bounds[endRow].x + this.view.opts.textPadding + this.mainCtx.measureText(last_(this.textFocus.stringify(this.mode.empty).slice(0, this.hiddenInput.selectionEnd).split('\n'))).width;
      if (this.hiddenInput.selectionStart === this.hiddenInput.selectionEnd) {
        this.cursorCtx.lineWidth = 1;
        this.cursorCtx.strokeStyle = '#000';
        this.cursorCtx.strokeRect(startPosition, textFocusView.bounds[startRow].y, 0, this.view.opts.textHeight);
        this.textInputHighlighted = false;
      } else {
        this.textInputHighlighted = true;
        this.cursorCtx.fillStyle = 'rgba(0, 0, 256, 0.3)';
        if (startRow === endRow) {
          this.cursorCtx.fillRect(startPosition, textFocusView.bounds[startRow].y + this.view.opts.textPadding, endPosition - startPosition, this.view.opts.textHeight);
        } else {
          this.cursorCtx.fillRect(startPosition, textFocusView.bounds[startRow].y + this.view.opts.textPadding, textFocusView.bounds[startRow].right() - this.view.opts.textPadding - startPosition, this.view.opts.textHeight);
          for (i = j = ref1 = startRow + 1, ref2 = endRow; ref1 <= ref2 ? j < ref2 : j > ref2; i = ref1 <= ref2 ? ++j : --j) {
            this.cursorCtx.fillRect(textFocusView.bounds[i].x, textFocusView.bounds[i].y + this.view.opts.textPadding, textFocusView.bounds[i].width, this.view.opts.textHeight);
          }
          this.cursorCtx.fillRect(textFocusView.bounds[endRow].x, textFocusView.bounds[endRow].y + this.view.opts.textPadding, endPosition - textFocusView.bounds[endRow].x, this.view.opts.textHeight);
        }
      }
      if (scrollIntoView && endPosition > this.scrollOffsets.main.x + this.mainCanvas.width) {
        return this.mainScroller.scrollLeft = endPosition - this.mainCanvas.width + this.view.opts.padding;
      }
    };
    escapeString = function(str) {
      return str[0] + str.slice(1, -1).replace(/(\'|\"|\n)/g, '\\$1') + str[str.length - 1];
    };
    Editor.prototype.setTextInputFocus = function(focus, selectionStart, selectionEnd) {
      var cursorParent, cursorPosition, newParse, originalText, ref1, ref2, shouldPop, shouldRecoverCursor, string, unparsedValue;
      if (selectionStart == null) {
        selectionStart = null;
      }
      if (selectionEnd == null) {
        selectionEnd = null;
      }
      if ((focus != null ? focus.id : void 0) in this.extraMarks) {
        delete this.extraMarks[focus != null ? focus.id : void 0];
      }
      if ((this.textFocus != null) && this.textFocus !== focus) {
        this.addMicroUndoOperation('CAPTURE_POINT');
        this.addMicroUndoOperation(new TextChangeOperation(this.textFocus, this.oldFocusValue, this));
        this.oldFocusValue = null;
        originalText = this.textFocus.stringify(this.mode.empty);
        shouldPop = false;
        shouldRecoverCursor = false;
        cursorPosition = cursorParent = null;
        if (this.cursor.hasParent(this.textFocus.parent)) {
          shouldRecoverCursor = true;
          cursorPosition = this.getRecoverableCursorPosition();
        }
        if (!this.textFocus.handwritten) {
          newParse = null;
          string = this.mode.normalString(this.textFocus.stringify(this.mode.empty));
          try {
            newParse = this.mode.parse(unparsedValue = string, {
              wrapAtRoot: false
            });
          } catch (_error) {
            if (string[0] === string[string.length - 1] && ((ref1 = string[0]) === '"' || ref1 === '\'')) {
              try {
                string = this.mode.escapeString(string);
                newParse = this.mode.parse(unparsedValue = string, {
                  wrapAtRoot: false
                });
                this.populateSocket(this.textFocus, string);
              } catch (_error) {}
            }
          }
          if ((newParse != null) && newParse.start.next.type === 'blockStart' && newParse.start.next.container.end.next === newParse.end) {
            this.textFocus.start.append(this.textFocus.end);
            this.spliceIn(newParse.start.next.container, this.textFocus.start);
            this.addMicroUndoOperation(new TextReparseOperation(this.textFocus, unparsedValue));
            shouldPop = true;
          }
        }
        if (!this.reparseRawReplace(this.textFocus.parent)) {
          this.populateSocket(this.textFocus, originalText);
          if (shouldPop) {
            this.undoStack.pop();
          }
          this.redrawMain();
        }
      }
      if (shouldRecoverCursor) {
        this.recoverCursorPosition(cursorPosition);
      }
      if (focus == null) {
        this.textFocus = null;
        this.redrawMain();
        this.hiddenInput.blur();
        this.dropletElement.focus();
        return;
      }
      this.oldFocusValue = focus.stringify(this.mode.empty);
      this.textFocus = focus;
      this.populateSocket(focus, focus.stringify(this.mode.empty));
      this.textFocus.notifyChange();
      this.moveCursorTo(focus.end);
      this.hiddenInput.value = this.textFocus.stringify(this.mode.empty);
      if ((selectionStart != null) && (selectionEnd == null)) {
        selectionEnd = selectionStart;
      }
      if (this.textFocus != null) {
        this.hiddenInput.focus();
        if ((selectionStart != null) && (selectionEnd != null)) {
          this.hiddenInput.setSelectionRange(selectionStart, selectionEnd);
        } else if (this.hiddenInput.value[0] === this.hiddenInput.value[this.hiddenInput.value.length - 1] && ((ref2 = this.hiddenInput.value[0]) === '\'' || ref2 === '"')) {
          this.hiddenInput.setSelectionRange(1, this.hiddenInput.value.length - 1);
        } else {
          this.hiddenInput.setSelectionRange(0, this.hiddenInput.value.length);
        }
        this.redrawTextInput();
      }
      this.redrawMain();
      return this.redrawTextInput();
    };
    Editor.prototype.populateSocket = function(socket, string) {
      var head, i, j, len, line, lines;
      lines = string.split('\n');
      socket.start.append(socket.end);
      head = socket.start;
      for (i = j = 0, len = lines.length; j < len; i = ++j) {
        line = lines[i];
        head = head.insert(new model.TextToken(line));
        if (i + 1 !== lines.length) {
          head = head.insert(new model.NewlineToken());
        }
      }
      return socket.notifyChange();
    };
    Editor.prototype.hitTestTextInput = function(point, block) {
      var head, ref1;
      head = block.start;
      while (head != null) {
        if (head.type === 'socketStart' && ((ref1 = head.next.type) === 'text' || ref1 === 'socketEnd') && this.view.getViewNodeFor(head.container).path.contains(point)) {
          return head.container;
        }
        head = head.next;
      }
      return null;
    };
    Editor.prototype.getTextPosition = function(point) {
      var column, lines, row, textFocusView;
      textFocusView = this.view.getViewNodeFor(this.textFocus);
      row = Math.floor((point.y - textFocusView.bounds[0].y) / (this.fontSize + 2 * this.view.opts.padding));
      row = Math.max(row, 0);
      row = Math.min(row, textFocusView.lineLength - 1);
      column = Math.max(0, Math.round((point.x - textFocusView.bounds[row].x - this.view.opts.textPadding) / this.mainCtx.measureText(' ').width));
      lines = this.textFocus.stringify(this.mode.empty).split('\n').slice(0, +row + 1 || 9e9);
      lines[lines.length - 1] = lines[lines.length - 1].slice(0, column);
      return lines.join('\n').length;
    };
    Editor.prototype.setTextInputAnchor = function(point) {
      this.textInputAnchor = this.textInputHead = this.getTextPosition(point);
      return this.hiddenInput.setSelectionRange(this.textInputAnchor, this.textInputHead);
    };
    Editor.prototype.selectDoubleClick = function(point) {
      var after, before, position, ref1, ref2, ref3, ref4;
      position = this.getTextPosition(point);
      before = (ref1 = (ref2 = this.textFocus.stringify(this.mode.empty).slice(0, position).match(/\w*$/)[0]) != null ? ref2.length : void 0) != null ? ref1 : 0;
      after = (ref3 = (ref4 = this.textFocus.stringify(this.mode.empty).slice(position).match(/^\w*/)[0]) != null ? ref4.length : void 0) != null ? ref3 : 0;
      this.textInputAnchor = position - before;
      this.textInputHead = position + after;
      return this.hiddenInput.setSelectionRange(this.textInputAnchor, this.textInputHead);
    };
    Editor.prototype.setTextInputHead = function(point) {
      this.textInputHead = this.getTextPosition(point);
      return this.hiddenInput.setSelectionRange(Math.min(this.textInputAnchor, this.textInputHead), Math.max(this.textInputAnchor, this.textInputHead));
    };
    hook('mousedown', 2, function(point, event, state) {
      var hitTestResult, mainPoint;
      if (state.consumedHitTest) {
        return;
      }
      mainPoint = this.trackerPointToMain(point);
      hitTestResult = this.hitTestTextInput(mainPoint, this.tree);
      if (hitTestResult !== this.textFocus) {
        this.setTextInputFocus(null);
        this.redrawMain();
        hitTestResult = this.hitTestTextInput(mainPoint, this.tree);
      }
      if (hitTestResult != null) {
        if (hitTestResult !== this.textFocus) {
          this.setTextInputFocus(hitTestResult);
          this.redrawMain();
          this.textInputSelecting = false;
        } else {
          this.setTextInputAnchor(mainPoint);
          this.redrawTextInput();
          this.textInputSelecting = true;
        }
        this.hiddenInput.focus();
        return state.consumedHitTest = true;
      }
    });
    hook('dblclick', 0, function(point, event, state) {
      var hitTestResult, mainPoint;
      if (state.consumedHitTest) {
        return;
      }
      mainPoint = this.trackerPointToMain(point);
      hitTestResult = this.hitTestTextInput(mainPoint, this.tree);
      if (hitTestResult !== this.textFocus) {
        this.setTextInputFocus(null);
        this.redrawMain();
        hitTestResult = this.hitTestTextInput(mainPoint, this.tree);
      }
      if (hitTestResult != null) {
        this.setTextInputFocus(hitTestResult);
        this.redrawMain();
        setTimeout(((function(_this) {
          return function() {
            _this.selectDoubleClick(mainPoint);
            _this.redrawTextInput();
            return _this.textInputSelecting = false;
          };
        })(this)), 0);
        return state.consumedHitTest = true;
      }
    });
    hook('mousemove', 0, function(point, event, state) {
      var mainPoint;
      if (this.textInputSelecting) {
        if (this.textFocus == null) {
          this.textInputSelecting = false;
          return;
        }
        mainPoint = this.trackerPointToMain(point);
        this.setTextInputHead(mainPoint);
        return this.redrawTextInput();
      }
    });
    hook('mouseup', 0, function(point, event, state) {
      var mainPoint;
      if (this.textInputSelecting) {
        mainPoint = this.trackerPointToMain(point);
        this.setTextInputHead(mainPoint);
        this.redrawTextInput();
        return this.textInputSelecting = false;
      }
    });
    CreateSegmentOperation = (function(superClass) {
      extend(CreateSegmentOperation, superClass);

      function CreateSegmentOperation(segment) {
        this.first = segment.start.getSerializedLocation();
        this.last = segment.end.getSerializedLocation() - 2;
        this.lassoSelect = segment.isLassoSegment;
      }

      CreateSegmentOperation.prototype.undo = function(editor) {
        editor.tree.getTokenAtLocation(this.first).container.unwrap();
        return editor.tree.getTokenAtLocation(this.first);
      };

      CreateSegmentOperation.prototype.redo = function(editor) {
        var segment;
        segment = new model.Segment();
        segment.isLassoSegment = this.lassoSelect;
        segment.wrap(editor.tree.getTokenAtLocation(this.first), editor.tree.getTokenAtLocation(this.last));
        return segment.end;
      };

      return CreateSegmentOperation;

    })(UndoOperation);
    DestroySegmentOperation = (function(superClass) {
      extend(DestroySegmentOperation, superClass);

      function DestroySegmentOperation(segment) {
        this.first = segment.start.getSerializedLocation();
        this.last = segment.end.getSerializedLocation() - 2;
        this.lassoSelect = segment.isLassoSegment;
      }

      DestroySegmentOperation.prototype.undo = function(editor) {
        var segment;
        segment = new model.Segment();
        segment.isLassoSegment = this.lassoSelect;
        segment.wrap(editor.tree.getTokenAtLocation(this.first), editor.tree.getTokenAtLocation(this.last));
        if (this.lassoSelect) {
          editor.lassoSegment = segment;
        }
        return segment.end;
      };

      DestroySegmentOperation.prototype.redo = function(editor) {
        editor.tree.getTokenAtLocation(this.first).container.unwrap();
        return editor.tree.getTokenAtLocation(this.first);
      };

      return DestroySegmentOperation;

    })(UndoOperation);
    hook('populate', 0, function() {
      this.lassoSelectCanvas = document.createElement('canvas');
      this.lassoSelectCanvas.className = 'droplet-lasso-select-canvas';
      this.lassoSelectCtx = this.lassoSelectCanvas.getContext('2d');
      this.lassoSelectAnchor = null;
      this.lassoSegment = null;
      return this.dropletElement.appendChild(this.lassoSelectCanvas);
    });
    Editor.prototype.clearLassoSelectCanvas = function() {
      return this.lassoSelectCtx.clearRect(0, 0, this.lassoSelectCanvas.width, this.lassoSelectCanvas.height);
    };
    Editor.prototype.resizeLassoCanvas = function() {
      this.lassoSelectCanvas.width = this.dropletElement.offsetWidth;
      this.lassoSelectCanvas.style.width = this.lassoSelectCanvas.width + "px";
      this.lassoSelectCanvas.height = this.dropletElement.offsetHeight;
      this.lassoSelectCanvas.style.height = this.lassoSelectCanvas.height + "px";
      return this.lassoSelectCanvas.style.left = this.mainCanvas.offsetLeft + "px";
    };
    Editor.prototype.clearLassoSelection = function() {
      var head, needToRedraw, next;
      this.lassoSegment = null;
      head = this.tree.start;
      needToRedraw = false;
      while (head !== this.tree.end) {
        if (head.type === 'segmentStart' && head.container.isLassoSegment) {
          next = head.next;
          this.addMicroUndoOperation(new DestroySegmentOperation(head.container));
          head.container.unwrap();
          needToRedraw = true;
          head = next;
        } else {
          head = head.next;
        }
      }
      if (needToRedraw) {
        return this.redrawMain();
      }
    };
    hook('mousedown', 0, function(point, event, state) {
      var mainPoint, palettePoint;
      if (!state.clickedLassoSegment) {
        this.clearLassoSelection();
      }
      if (state.consumedHitTest || state.suppressLassoSelect) {
        return;
      }
      if (!this.trackerPointIsInMain(point)) {
        return;
      }
      if (this.trackerPointIsInPalette(point)) {
        return;
      }
      mainPoint = this.trackerPointToMain(point).from(this.scrollOffsets.main);
      palettePoint = this.trackerPointToPalette(point).from(this.scrollOffsets.palette);
      return this.lassoSelectAnchor = this.trackerPointToMain(point);
    });
    hook('mousemove', 0, function(point, event, state) {
      var first, lassoRectangle, last, mainPoint, ref1;
      if (this.lassoSelectAnchor != null) {
        mainPoint = this.trackerPointToMain(point);
        this.clearLassoSelectCanvas();
        lassoRectangle = new this.draw.Rectangle(Math.min(this.lassoSelectAnchor.x, mainPoint.x), Math.min(this.lassoSelectAnchor.y, mainPoint.y), Math.abs(this.lassoSelectAnchor.x - mainPoint.x), Math.abs(this.lassoSelectAnchor.y - mainPoint.y));
        first = this.tree.start;
        while (!((first == null) || first.type === 'blockStart' && this.view.getViewNodeFor(first.container).path.intersects(lassoRectangle))) {
          first = first.next;
        }
        last = this.tree.end;
        while (!((last == null) || last.type === 'blockEnd' && this.view.getViewNodeFor(last.container).path.intersects(lassoRectangle))) {
          last = last.prev;
        }
        this.clearLassoSelectCanvas();
        this.clearHighlightCanvas();
        this.lassoSelectCtx.strokeStyle = '#00f';
        this.lassoSelectCtx.strokeRect(lassoRectangle.x - this.scrollOffsets.main.x, lassoRectangle.y - this.scrollOffsets.main.y, lassoRectangle.width, lassoRectangle.height);
        if (first && (last != null)) {
          ref1 = validateLassoSelection(this.tree, first, last), first = ref1[0], last = ref1[1];
          return this.drawTemporaryLasso(first, last);
        }
      }
    });
    Editor.prototype.drawTemporaryLasso = function(first, last) {
      var head, mainCanvasRectangle, results;
      mainCanvasRectangle = new this.draw.Rectangle(this.scrollOffsets.main.x, this.scrollOffsets.main.y, this.mainCanvas.width, this.mainCanvas.height);
      head = first;
      results = [];
      while (head !== last) {
        if (head instanceof model.StartToken) {
          this.view.getViewNodeFor(head.container).draw(this.highlightCtx, mainCanvasRectangle, {
            selected: Infinity
          });
          results.push(head = head.container.end);
        } else {
          results.push(head = head.next);
        }
      }
      return results;
    };
    validateLassoSelection = function(tree, first, last) {
      var head, tokensToInclude;
      tokensToInclude = [];
      head = first;
      while (head !== last.next) {
        if (head instanceof model.StartToken || head instanceof model.EndToken) {
          tokensToInclude.push(head.container.start);
          tokensToInclude.push(head.container.end);
        }
        head = head.next;
      }
      first = tree.start;
      while (indexOf.call(tokensToInclude, first) < 0) {
        first = first.next;
      }
      last = tree.end;
      while (indexOf.call(tokensToInclude, last) < 0) {
        last = last.prev;
      }
      while (first.type !== 'blockStart') {
        first = first.prev;
        if (first.type === 'blockEnd') {
          first = first.container.start.prev;
        }
      }
      while (last.type !== 'blockEnd') {
        last = last.next;
        if (last.type === 'blockStart') {
          last = last.container.end.next;
        }
      }
      return [first, last];
    };
    hook('mouseup', 0, function(point, event, state) {
      var first, lassoRectangle, last, mainPoint, ref1;
      if (this.lassoSelectAnchor != null) {
        mainPoint = this.trackerPointToMain(point);
        lassoRectangle = new this.draw.Rectangle(Math.min(this.lassoSelectAnchor.x, mainPoint.x), Math.min(this.lassoSelectAnchor.y, mainPoint.y), Math.abs(this.lassoSelectAnchor.x - mainPoint.x), Math.abs(this.lassoSelectAnchor.y - mainPoint.y));
        this.lassoSelectAnchor = null;
        this.clearLassoSelectCanvas();
        first = this.tree.start;
        while (!((first == null) || first.type === 'blockStart' && this.view.getViewNodeFor(first.container).path.intersects(lassoRectangle))) {
          first = first.next;
        }
        last = this.tree.end;
        while (!((last == null) || last.type === 'blockEnd' && this.view.getViewNodeFor(last.container).path.intersects(lassoRectangle))) {
          last = last.prev;
        }
        if (!((first != null) && (last != null))) {
          return;
        }
        ref1 = validateLassoSelection(this.tree, first, last), first = ref1[0], last = ref1[1];
        this.lassoSegment = new model.Segment();
        this.lassoSegment.isLassoSegment = true;
        this.lassoSegment.wrap(first, last);
        this.addMicroUndoOperation(new CreateSegmentOperation(this.lassoSegment));
        this.moveCursorTo(this.lassoSegment.end.nextVisibleToken(), true);
        return this.redrawMain();
      }
    });
    hook('mousedown', 3, function(point, event, state) {
      if (state.consumedHitTest) {
        return;
      }
      if ((this.lassoSegment != null) && (this.hitTest(this.trackerPointToMain(point), this.lassoSegment) != null)) {
        this.setTextInputFocus(null);
        this.clickedBlock = this.lassoSegment;
        this.clickedBlockIsPaletteBlock = false;
        this.clickedPoint = point;
        state.consumedHitTest = true;
        return state.clickedLassoSegment = true;
      }
    });
    hook('populate', 0, function() {
      return this.cursor = new model.CursorToken();
    });
    isValidCursorPosition = function(pos) {
      var ref1;
      return (ref1 = pos.parent.type) === 'indent' || ref1 === 'segment';
    };
    Editor.prototype.moveCursorTo = function(destination, attemptReparse) {
      var head, ref1;
      if (attemptReparse == null) {
        attemptReparse = false;
      }
      this.redrawMain();
      if (destination == null) {
        if (DEBUG_FLAG) {
          throw new Error('Cannot move cursor to null');
        }
        return null;
      }
      if (!this.inTree(destination)) {
        if (DEBUG_FLAG) {
          throw new Error('Cannot move cursor to a place not in the main tree');
        }
        return null;
      }
      this.highlightFlashShow();
      this.cursor.remove();
      if (destination === this.tree.start) {
        destination.insert(this.cursor);
      } else {
        head = destination;
        while (!(((ref1 = head.type) === 'newline' || ref1 === 'indentEnd') || head === this.tree.end)) {
          head = head.next;
        }
        if (head.type === 'newline') {
          head.insert(this.cursor);
        } else {
          head.insertBefore(this.cursor);
        }
      }
      if (!isValidCursorPosition(this.cursor)) {
        this.moveCursorTo(this.cursor.next);
      }
      return this.redrawHighlights();
    };
    Editor.prototype.moveCursorUp = function() {
      var head, ref1, ref2;
      if (this.cursor.prev == null) {
        return;
      }
      head = (ref1 = this.cursor.prev) != null ? ref1.prev : void 0;
      this.highlightFlashShow();
      if (head == null) {
        return;
      }
      while (!(((ref2 = head.type) === 'newline' || ref2 === 'indentEnd') || head === this.tree.start)) {
        head = head.prev;
      }
      this.cursor.remove();
      if (head.type === 'newline' || head === this.tree.start) {
        head.insert(this.cursor);
      } else {
        head.insertBefore(this.cursor);
      }
      if (!isValidCursorPosition(this.cursor)) {
        this.moveCursorUp();
      }
      this.redrawHighlights();
      return this.scrollCursorIntoPosition();
    };
    Editor.prototype.getRecoverableCursorPosition = function() {
      var head, pos;
      pos = {
        lines: 0,
        indents: 0
      };
      head = this.cursor;
      while (!(head.type === 'newline' || head === this.tree.start)) {
        if (head.type === 'indentEnd') {
          pos.indents++;
        }
        head = head.prev;
      }
      while (head !== this.tree.start) {
        if (head.type === 'newline') {
          pos.lines++;
        }
        head = head.prev;
      }
      return pos;
    };
    getAtChar = function(parent, chars) {
      var charsCounted, head;
      head = parent.start;
      charsCounted = 0;
      while (!(charsCounted >= chars)) {
        if (head.type === 'text') {
          charsCounted += head.value.length;
        }
        head = head.next;
      }
      return head;
    };
    Editor.prototype.recoverCursorPosition = function(pos) {
      var head, testPos;
      head = this.tree.start;
      testPos = {
        lines: 0,
        indents: 0
      };
      while (!(head === this.tree.end || testPos.lines === pos.lines)) {
        head = head.next;
        if (head.type === 'newline') {
          testPos.lines++;
        }
      }
      while (!(head === this.tree.end || testPos.indents === pos.indents)) {
        head = head.next;
        if (head.type === 'indentEnd') {
          testPos.indents++;
        }
      }
      this.cursor.remove();
      if (head.type === 'newline') {
        return head.insert(this.cursor);
      } else {
        return head.insertBefore(this.cursor);
      }
    };
    Editor.prototype.moveCursorHorizontally = function(direction) {
      var chars, head, persistentParent, position, ref1, socket;
      if (this.textFocus != null) {
        if (direction === 'right') {
          head = this.textFocus.end.next;
        } else {
          head = this.textFocus.start.prev;
        }
      } else if (!(this.cursor.prev === this.tree.start && direction === 'left' || this.cursor.next === this.tree.end && direction === 'right')) {
        if (direction === 'right') {
          head = this.cursor.next.next;
        } else {
          head = this.cursor.prev.prev;
        }
      } else {
        return;
      }
      while (true) {
        if (((ref1 = head.type) === 'newline' || ref1 === 'indentEnd') || head.container === this.tree) {
          this.cursor.remove();
          if (head === this.tree.start || head.type === 'newline') {
            head.insert(this.cursor);
          } else {
            head.insertBefore(this.cursor);
          }
          this.setTextInputFocus(null);
          if (!this.inTree(this.cursor)) {
            debugger;
          }
          if (isValidCursorPosition(this.cursor)) {
            break;
          }
        }
        if (head.type === 'socketStart' && (head.next.type === 'text' || head.next === head.container.end)) {
          if ((this.textFocus != null) && head.container.hasParent(this.textFocus.parent)) {
            persistentParent = this.textFocus.getCommonParent(head.container).parent;
            chars = getCharactersTo(persistentParent, head.container.start);
            this.setTextInputFocus(null);
            socket = getSocketAtChar(persistentParent, chars);
          } else {
            socket = head.container;
            this.setTextInputFocus(null);
          }
          position = (direction === 'right' ? 0 : -1);
          this.setTextInputFocus(socket, position, position);
          break;
        }
        if (direction === 'right') {
          head = head.next;
        } else {
          head = head.prev;
        }
      }
      return this.redrawMain();
    };
    hook('keydown', 0, function(event, state) {
      if (event.which !== RIGHT_ARROW_KEY) {
        return;
      }
      if ((this.textFocus == null) || this.hiddenInput.selectionStart === this.hiddenInput.value.length) {
        this.moveCursorHorizontally('right');
        return event.preventDefault();
      }
    });
    hook('keydown', 0, function(event, state) {
      if (event.which !== LEFT_ARROW_KEY) {
        return;
      }
      if ((this.textFocus == null) || this.hiddenInput.selectionEnd === 0) {
        this.moveCursorHorizontally('left');
        return event.preventDefault();
      }
    });
    Editor.prototype.determineCursorPosition = function() {
      var bound, head, line, ref1, ref2;
      if ((this.cursor != null) && (this.cursor.parent != null)) {
        this.view.getViewNodeFor(this.tree).layout(0, this.nubbyHeight);
        head = this.cursor;
        line = 0;
        while (head !== this.cursor.parent.start) {
          head = head.prev;
          if (head.type === 'newline') {
            line++;
          }
        }
        bound = this.view.getViewNodeFor(this.cursor.parent).bounds[line];
        if (((ref1 = this.cursor.nextVisibleToken()) != null ? ref1.type : void 0) === 'indentEnd' && ((ref2 = this.cursor.prev) != null ? ref2.prev.type : void 0) !== 'indentStart' || (this.cursor.next === this.tree.end && this.cursor.prev !== this.tree.start)) {
          return new this.draw.Point(bound.x, bound.bottom());
        } else {
          return new this.draw.Point(bound.x, bound.y);
        }
      }
    };
    Editor.prototype.scrollCursorIntoPosition = function() {
      var axis;
      axis = this.determineCursorPosition().y;
      if (axis - this.scrollOffsets.main.y < 0) {
        this.mainScroller.scrollTop = axis;
      } else if (axis - this.scrollOffsets.main.y > this.mainCanvas.height) {
        this.mainScroller.scrollTop = axis - this.mainCanvas.height;
      }
      return this.mainScroller.scrollLeft = 0;
    };
    hook('keydown', 0, function(event, state) {
      if (event.which !== UP_ARROW_KEY) {
        return;
      }
      this.clearLassoSelection();
      this.setTextInputFocus(null);
      return this.moveCursorUp();
    });
    hook('keydown', 0, function(event, state) {
      if (event.which !== DOWN_ARROW_KEY) {
        return;
      }
      if (this.textFocus == null) {
        this.moveCursorTo(this.cursor.next.next);
      }
      this.clearLassoSelection();
      this.setTextInputFocus(null);
      return this.scrollCursorIntoPosition();
    });
    getCharactersTo = function(parent, token) {
      var chars, head;
      head = token;
      chars = 0;
      while (head !== parent.start) {
        if (head.type === 'text') {
          chars += head.value.length;
        }
        head = head.prev;
      }
      return chars;
    };
    getSocketAtChar = function(parent, chars) {
      var charsCounted, head;
      head = parent.start;
      charsCounted = 0;
      while (!(charsCounted >= chars && head.type === 'socketStart' && (head.next.type === 'text' || head.next === head.container.end))) {
        if (head.type === 'text') {
          charsCounted += head.value.length;
        }
        head = head.next;
      }
      return head.container;
    };
    hook('keydown', 0, function(event, state) {
      var chars, head, persistentParent, socket;
      if (event.which !== TAB_KEY) {
        return;
      }
      if (event.shiftKey) {
        if (this.textFocus != null) {
          head = this.textFocus.start;
        } else {
          head = this.cursor;
        }
        while (!((head == null) || head.type === 'socketEnd' && (head.container.start.next.type === 'text' || head.container.start.next === head.container.end))) {
          head = head.prev;
        }
        if (head != null) {
          if ((this.textFocus != null) && head.container.hasParent(this.textFocus.parent)) {
            persistentParent = this.textFocus.getCommonParent(head.container).parent;
            chars = getCharactersTo(persistentParent, head.container.start);
            this.setTextInputFocus(null);
            socket = getSocketAtChar(persistentParent, chars);
          } else {
            socket = head.container;
            this.setTextInputFocus(null);
          }
          this.setTextInputFocus(socket);
        }
        return event.preventDefault();
      } else {
        if (this.textFocus != null) {
          head = this.textFocus.end;
        } else {
          head = this.cursor;
        }
        while (!((head == null) || head.type === 'socketStart' && (head.container.start.next.type === 'text' || head.container.start.next === head.container.end))) {
          head = head.next;
        }
        if (head != null) {
          if ((this.textFocus != null) && head.container.hasParent(this.textFocus.parent)) {
            persistentParent = this.textFocus.getCommonParent(head.container).parent;
            chars = getCharactersTo(persistentParent, head.container.start);
            this.setTextInputFocus(null);
            socket = getSocketAtChar(persistentParent, chars);
          } else {
            socket = head.container;
            this.setTextInputFocus(null);
          }
          this.setTextInputFocus(socket);
        }
        return event.preventDefault();
      }
    });
    Editor.prototype.deleteAtCursor = function() {
      var before, blockEnd, ref1, ref2, start;
      this.setTextInputFocus(null);
      blockEnd = this.cursor.prev;
      while ((ref1 = blockEnd != null ? blockEnd.type : void 0) !== 'blockEnd' && ref1 !== 'indentStart' && ref1 !== (void 0)) {
        blockEnd = blockEnd.prev;
      }
      if (blockEnd == null) {
        return;
      }
      if (blockEnd.type === 'blockEnd') {
        this.addMicroUndoOperation(new PickUpOperation(blockEnd.container));
        this.spliceOut(blockEnd.container);
        return this.redrawMain();
      } else if (blockEnd.type === 'indentStart') {
        start = blockEnd.container.start.nextVisibleToken();
        while (start.type === 'newline') {
          start = start.nextVisibleToken();
        }
        if (start !== start.container.end) {
          return;
        }
        before = blockEnd.container.parent.start;
        while ((ref2 = before.type) !== 'blockEnd' && ref2 !== 'indentStart' && ref2 !== 'segmentStart') {
          before = before.previousVisibleToken();
        }
        this.addMicroUndoOperation(new PickUpOperation(blockEnd.container.parent));
        this.spliceOut(blockEnd.container.parent);
        this.moveCursorTo(before);
        return this.redrawMain();
      }
    };
    hook('keydown', 0, function(event, state) {
      if (event.which !== BACKSPACE_KEY) {
        return;
      }
      if (state.capturedBackspace) {
        return;
      }
      if (this.lassoSegment != null) {
        this.addMicroUndoOperation('CAPTURE_POINT');
        this.deleteLassoSegment();
        event.preventDefault();
        return false;
      } else if ((this.textFocus == null) || (this.hiddenInput.value.length === 0 && this.textFocus.handwritten)) {
        this.addMicroUndoOperation('CAPTURE_POINT');
        this.deleteAtCursor();
        state.capturedBackspace = true;
        event.preventDefault();
        return false;
      }
      return true;
    });
    Editor.prototype.deleteLassoSegment = function() {
      if (this.lassoSegment == null) {
        if (DEBUG_FLAG) {
          throw new Error('Cannot delete nonexistent lasso segment');
        }
        return null;
      }
      this.addMicroUndoOperation(new PickUpOperation(this.lassoSegment));
      this.spliceOut(this.lassoSegment);
      this.lassoSegment = null;
      return this.redrawMain();
    };
    hook('populate', 0, function() {
      return this.handwrittenBlocks = [];
    });
    hook('keydown', 0, function(event, state) {
      var head, newBlock, newSocket, ref1;
      if (event.which === ENTER_KEY) {
        if ((this.textFocus == null) && !event.shiftKey) {
          this.setTextInputFocus(null);
          newBlock = new model.Block();
          newSocket = new model.Socket(-Infinity);
          newSocket.spliceIn(newBlock.start);
          newSocket.handwritten = true;
          this.handwrittenBlocks.push(newBlock);
          head = this.cursor.prev;
          while (((ref1 = head.type) === 'newline' || ref1 === 'cursor' || ref1 === 'segmentStart' || ref1 === 'segmentEnd') && head !== this.tree.start) {
            head = head.prev;
          }
          this.addMicroUndoOperation('CAPTURE_POINT');
          this.addMicroUndoOperation(new DropOperation(newBlock, head));
          this.spliceIn(newBlock, head);
          this.redrawMain();
          return this.newHandwrittenSocket = newSocket;
        } else if ((this.textFocus != null) && !event.shiftKey) {
          this.setTextInputFocus(null);
          return this.redrawMain();
        }
      }
    });
    hook('keyup', 0, function(event, state) {
      if (event.which === ENTER_KEY) {
        if (this.newHandwrittenSocket != null) {
          this.setTextInputFocus(this.newHandwrittenSocket);
          return this.newHandwrittenSocket = null;
        }
      }
    });
    containsCursor = function(block) {
      var head;
      head = block.start;
      while (head !== block.end) {
        if (head.type === 'cursor') {
          return true;
        }
        head = head.next;
      }
      return false;
    };
    ReparseOperation = (function(superClass) {
      extend(ReparseOperation, superClass);

      function ReparseOperation(block, parse) {
        this.before = block.clone();
        this.location = block.start.getSerializedLocation();
        this.after = parse.clone();
      }

      ReparseOperation.prototype.undo = function(editor) {
        var block, newBlock;
        block = editor.tree.getTokenAtLocation(this.location).container;
        newBlock = this.before.clone();
        return newBlock.rawReplace(block);
      };

      ReparseOperation.prototype.redo = function(editor) {
        var block, newBlock;
        block = editor.tree.getTokenAtLocation(this.location).container;
        newBlock = this.after.clone();
        newBlock.rawReplace(block);
        return newBlock.notifyChange();
      };

      return ReparseOperation;

    })(UndoOperation);
    Editor.prototype.copyAceEditor = function() {
      clearTimeout(this.changeFromAceTimer);
      this.changeFromAceTimer = null;
      this.gutter.style.width = this.aceEditor.renderer.$gutterLayer.gutterWidth + 'px';
      this.resizeBlockMode();
      return this.setValue_raw(this.getAceValue());
    };
    Editor.prototype.changeFromAceEditor = function() {
      if (this.changeFromAceTimer) {
        return;
      }
      return this.changeFromAceTimer = setTimeout(((function(_this) {
        return function() {
          var result;
          result = _this.copyAceEditor();
          if (!result.success && result.error) {
            return _this.fireEvent('parseerror', [result.error]);
          }
        };
      })(this)), 0);
    };
    hook('populate', 0, function() {
      var acemode;
      this.aceElement = document.createElement('div');
      this.aceElement.className = 'droplet-ace';
      this.wrapperElement.appendChild(this.aceElement);
      this.aceEditor = ace.edit(this.aceElement);
      this.aceEditor.setTheme('ace/theme/chrome');
      this.aceEditor.setFontSize(15);
      acemode = this.options.mode;
      if (acemode === 'coffeescript') {
        acemode = 'coffee';
      }
      this.aceEditor.getSession().setMode('ace/mode/' + acemode);
      this.aceEditor.getSession().setTabSize(2);
      this.aceEditor.on('change', (function(_this) {
        return function() {
          if (_this.suppressAceChangeEvent) {
            return;
          }
          if (_this.currentlyUsingBlocks) {
            return _this.changeFromAceEditor();
          } else {
            return _this.fireEvent('change', []);
          }
        };
      })(this));
      this.currentlyUsingBlocks = true;
      this.currentlyAnimating = false;
      this.transitionContainer = document.createElement('div');
      this.transitionContainer.className = 'droplet-transition-container';
      return this.dropletElement.appendChild(this.transitionContainer);
    });
    getOffsetTop = function(element) {
      var top;
      top = element.offsetTop;
      while ((element = element.offsetParent) != null) {
        top += element.offsetTop;
      }
      return top;
    };
    getOffsetLeft = function(element) {
      var left;
      left = element.offsetLeft;
      while ((element = element.offsetParent) != null) {
        left += element.offsetLeft;
      }
      return left;
    };
    Editor.prototype.computePlaintextTranslationVectors = function() {
      var aceSession, corner, head, rownum, state, textElements, translationVectors, wrappedlines;
      textElements = [];
      translationVectors = [];
      head = this.tree.start;
      aceSession = this.aceEditor.session;
      state = {
        x: (this.aceEditor.container.getBoundingClientRect().left - this.aceElement.getBoundingClientRect().left + this.aceEditor.renderer.$gutterLayer.gutterWidth) - this.gutter.offsetWidth + 5,
        y: (this.aceEditor.container.getBoundingClientRect().top - this.aceElement.getBoundingClientRect().top) - aceSession.getScrollTop(),
        indent: 0,
        lineHeight: this.aceEditor.renderer.layerConfig.lineHeight,
        leftEdge: (this.aceEditor.container.getBoundingClientRect().left - getOffsetLeft(this.aceElement) + this.aceEditor.renderer.$gutterLayer.gutterWidth) - this.gutter.offsetWidth + 5
      };
      this.mainCtx.font = this.aceFontSize() + ' ' + this.fontFamily;
      rownum = 0;
      while (head !== this.tree.end) {
        switch (head.type) {
          case 'text':
            corner = this.view.getViewNodeFor(head).bounds[0].upperLeftCorner();
            corner.x -= this.scrollOffsets.main.x;
            corner.y -= this.scrollOffsets.main.y;
            translationVectors.push((new this.draw.Point(state.x, state.y)).from(corner));
            textElements.push(this.view.getViewNodeFor(head));
            state.x += this.mainCtx.measureText(head.value).width;
            break;
          case 'newline':
            wrappedlines = Math.max(1, aceSession.documentToScreenRow(rownum + 1, 0) - aceSession.documentToScreenRow(rownum, 0));
            rownum += 1;
            state.y += state.lineHeight * wrappedlines;
            if (head.specialIndent != null) {
              state.x = state.leftEdge + this.mainCtx.measureText(head.specialIndent).width;
            } else {
              state.x = state.leftEdge + state.indent * this.mainCtx.measureText(' ').width;
            }
            break;
          case 'indentStart':
            state.indent += head.container.depth;
            break;
          case 'indentEnd':
            state.indent -= head.container.depth;
        }
        head = head.next;
      }
      return {
        textElements: textElements,
        translationVectors: translationVectors
      };
    };
    AnimatedColor = (function() {
      function AnimatedColor(start1, end1, time) {
        this.start = start1;
        this.end = end1;
        this.time = time;
        this.currentRGB = [parseInt(this.start.slice(1, 3), 16), parseInt(this.start.slice(3, 5), 16), parseInt(this.start.slice(5, 7), 16)];
        this.step = [(parseInt(this.end.slice(1, 3), 16) - this.currentRGB[0]) / this.time, (parseInt(this.end.slice(3, 5), 16) - this.currentRGB[1]) / this.time, (parseInt(this.end.slice(5, 7), 16) - this.currentRGB[2]) / this.time];
      }

      AnimatedColor.prototype.advance = function() {
        var i, item, j, len, ref1;
        ref1 = this.currentRGB;
        for (i = j = 0, len = ref1.length; j < len; i = ++j) {
          item = ref1[i];
          this.currentRGB[i] += this.step[i];
        }
        return "rgb(" + (Math.round(this.currentRGB[0])) + "," + (Math.round(this.currentRGB[1])) + "," + (Math.round(this.currentRGB[2])) + ")";
      };

      return AnimatedColor;

    })();
    Editor.prototype.performMeltAnimation = function(fadeTime, translateTime, cb) {
      var aceScrollTop, bottom, div, fn1, fn2, i, j, k, len, line, lineHeight, ref1, ref2, ref3, textElement, textElements, top, translatingElements, translationVectors, treeView;
      if (fadeTime == null) {
        fadeTime = 500;
      }
      if (translateTime == null) {
        translateTime = 1000;
      }
      if (cb == null) {
        cb = function() {};
      }
      if (this.currentlyUsingBlocks && !this.currentlyAnimating) {
        this.fireEvent('statechange', [false]);
        this.setAceValue(this.getValue());
        top = this.findLineNumberAtCoordinate(this.scrollOffsets.main.y);
        this.aceEditor.scrollToLine(top);
        this.aceEditor.resize(true);
        this.redrawMain({
          noText: true
        });
        this.textFocus = this.lassoAnchor = null;
        if (this.mainScroller.scrollWidth > this.mainScroller.offsetWidth) {
          this.mainScroller.style.overflowX = 'scroll';
        } else {
          this.mainScroller.style.overflowX = 'hidden';
        }
        this.mainScroller.style.overflowY = 'hidden';
        this.dropletElement.style.width = this.wrapperElement.offsetWidth + 'px';
        this.currentlyUsingBlocks = false;
        this.currentlyAnimating = this.currentlyAnimating_suppressRedraw = true;
        this.paletteHeader.style.zIndex = 0;
        ref1 = this.computePlaintextTranslationVectors(), textElements = ref1.textElements, translationVectors = ref1.translationVectors;
        translatingElements = [];
        fn1 = (function(_this) {
          return function(div, textElement, translationVectors, i) {
            return setTimeout((function() {
              div.style.left = (textElement.bounds[0].x - _this.scrollOffsets.main.x + translationVectors[i].x) + 'px';
              div.style.top = (textElement.bounds[0].y - _this.scrollOffsets.main.y + translationVectors[i].y) + 'px';
              return div.style.fontSize = _this.aceFontSize();
            }), fadeTime);
          };
        })(this);
        for (i = j = 0, len = textElements.length; j < len; i = ++j) {
          textElement = textElements[i];
          if (!(0 < textElement.bounds[0].bottom() - this.scrollOffsets.main.y + translationVectors[i].y && textElement.bounds[0].y - this.scrollOffsets.main.y + translationVectors[i].y < this.mainCanvas.height)) {
            continue;
          }
          div = document.createElement('div');
          div.style.whiteSpace = 'pre';
          div.innerText = div.textContent = textElement.model.value;
          div.style.font = this.fontSize + 'px ' + this.fontFamily;
          div.style.left = (textElement.bounds[0].x - this.scrollOffsets.main.x) + "px";
          div.style.top = (textElement.bounds[0].y - this.scrollOffsets.main.y - this.fontAscent) + "px";
          div.className = 'droplet-transitioning-element';
          div.style.transition = "left " + translateTime + "ms, top " + translateTime + "ms, font-size " + translateTime + "ms";
          translatingElements.push(div);
          this.transitionContainer.appendChild(div);
          fn1(div, textElement, translationVectors, i);
        }
        top = Math.max(this.aceEditor.getFirstVisibleRow(), 0);
        bottom = Math.min(this.aceEditor.getLastVisibleRow(), this.view.getViewNodeFor(this.tree).lineLength - 1);
        aceScrollTop = this.aceEditor.session.getScrollTop();
        treeView = this.view.getViewNodeFor(this.tree);
        lineHeight = this.aceEditor.renderer.layerConfig.lineHeight;
        fn2 = (function(_this) {
          return function(div, line) {
            return setTimeout((function() {
              div.style.left = '0px';
              div.style.top = (_this.aceEditor.session.documentToScreenRow(line, 0) * lineHeight - aceScrollTop) + 'px';
              return div.style.fontSize = _this.aceFontSize();
            }), fadeTime);
          };
        })(this);
        for (line = k = ref2 = top, ref3 = bottom; ref2 <= ref3 ? k <= ref3 : k >= ref3; line = ref2 <= ref3 ? ++k : --k) {
          div = document.createElement('div');
          div.style.whiteSpace = 'pre';
          div.innerText = div.textContent = line + 1;
          div.style.left = 0;
          div.style.top = (treeView.bounds[line].y + treeView.distanceToBase[line].above - this.view.opts.textHeight - this.fontAscent - this.scrollOffsets.main.y) + "px";
          div.style.font = this.fontSize + 'px ' + this.fontFamily;
          div.style.width = this.gutter.offsetWidth + "px";
          translatingElements.push(div);
          div.className = 'droplet-transitioning-element droplet-transitioning-gutter';
          div.style.transition = "left " + translateTime + "ms, top " + translateTime + "ms, font-size " + translateTime + "ms";
          this.dropletElement.appendChild(div);
          fn2(div, line);
        }
        this.lineNumberWrapper.style.display = 'none';
        this.mainCanvas.style.transition = this.highlightCanvas.style.transition = this.cursorCanvas.style.opacity = "opacity " + fadeTime + "ms linear";
        this.mainCanvas.style.opacity = this.highlightCanvas.style.opacity = this.cursorCanvas.style.opacity = 0;
        setTimeout(((function(_this) {
          return function() {
            _this.dropletElement.style.transition = _this.paletteWrapper.style.transition = "left " + translateTime + "ms";
            _this.dropletElement.style.left = '0px';
            return _this.paletteWrapper.style.left = (-_this.paletteWrapper.offsetWidth) + "px";
          };
        })(this)), fadeTime);
        setTimeout(((function(_this) {
          return function() {
            var l, len1;
            _this.dropletElement.style.transition = _this.paletteWrapper.style.transition = '';
            _this.dropletElement.style.top = '-9999px';
            _this.dropletElement.style.left = '-9999px';
            _this.paletteWrapper.style.top = '-9999px';
            _this.paletteWrapper.style.left = '-9999px';
            _this.aceElement.style.top = "0px";
            _this.aceElement.style.left = "0px";
            _this.currentlyAnimating = false;
            _this.mainScroller.style.overflow = 'auto';
            for (l = 0, len1 = translatingElements.length; l < len1; l++) {
              div = translatingElements[l];
              div.parentNode.removeChild(div);
            }
            _this.fireEvent('toggledone', [_this.currentlyUsingBlocks]);
            if (cb != null) {
              return cb();
            }
          };
        })(this)), fadeTime + translateTime);
        return {
          success: true
        };
      }
    };
    Editor.prototype.aceFontSize = function() {
      return parseFloat(this.aceEditor.getFontSize()) + 'px';
    };
    Editor.prototype.performFreezeAnimation = function(fadeTime, translateTime, cb) {
      var setValueResult;
      if (fadeTime == null) {
        fadeTime = 500;
      }
      if (translateTime == null) {
        translateTime = 500;
      }
      if (cb == null) {
        cb = function() {};
      }
      if (!this.currentlyUsingBlocks && !this.currentlyAnimating) {
        setValueResult = this.copyAceEditor();
        if (!setValueResult.success) {
          if (setValueResult.error) {
            this.fireEvent('parseerror', [setValueResult.error]);
          }
          return setValueResult;
        }
        if (this.aceEditor.getFirstVisibleRow() === 0) {
          this.mainScroller.scrollTop = 0;
        } else {
          this.mainScroller.scrollTop = this.view.getViewNodeFor(this.tree).bounds[this.aceEditor.getFirstVisibleRow()].y;
        }
        this.currentlyUsingBlocks = true;
        this.currentlyAnimating = true;
        this.fireEvent('statechange', [true]);
        setTimeout(((function(_this) {
          return function() {
            var aceScrollTop, bottom, div, el, fn1, fn2, i, j, k, l, len, len1, line, lineHeight, ref1, ref2, ref3, ref4, textElement, textElements, top, translatingElements, translationVectors, treeView;
            _this.mainScroller.style.overflow = 'hidden';
            _this.dropletElement.style.width = _this.wrapperElement.offsetWidth + 'px';
            _this.redrawMain({
              noText: true
            });
            _this.currentlyAnimating_suppressRedraw = true;
            _this.aceElement.style.top = "-9999px";
            _this.aceElement.style.left = "-9999px";
            _this.paletteWrapper.style.top = '0px';
            _this.paletteWrapper.style.left = (-_this.paletteWrapper.offsetWidth) + "px";
            _this.dropletElement.style.top = "0px";
            _this.dropletElement.style.left = "0px";
            _this.paletteHeader.style.zIndex = 0;
            ref1 = _this.computePlaintextTranslationVectors(), textElements = ref1.textElements, translationVectors = ref1.translationVectors;
            translatingElements = [];
            fn1 = function(div, textElement) {
              return setTimeout((function() {
                div.style.left = (textElement.bounds[0].x - _this.scrollOffsets.main.x) + "px";
                div.style.top = (textElement.bounds[0].y - _this.scrollOffsets.main.y - _this.fontAscent) + "px";
                return div.style.fontSize = _this.fontSize + 'px';
              }), 0);
            };
            for (i = j = 0, len = textElements.length; j < len; i = ++j) {
              textElement = textElements[i];
              if (!(0 < textElement.bounds[0].bottom() - _this.scrollOffsets.main.y + translationVectors[i].y && textElement.bounds[0].y - _this.scrollOffsets.main.y + translationVectors[i].y < _this.mainCanvas.height)) {
                continue;
              }
              div = document.createElement('div');
              div.style.whiteSpace = 'pre';
              div.innerText = div.textContent = textElement.model.value;
              div.style.font = _this.aceFontSize() + ' ' + _this.fontFamily;
              div.style.position = 'absolute';
              div.style.left = (textElement.bounds[0].x - _this.scrollOffsets.main.x + translationVectors[i].x) + "px";
              div.style.top = (textElement.bounds[0].y - _this.scrollOffsets.main.y + translationVectors[i].y) + "px";
              div.className = 'droplet-transitioning-element';
              div.style.transition = "left " + translateTime + "ms, top " + translateTime + "ms, font-size " + translateTime + "ms";
              translatingElements.push(div);
              _this.transitionContainer.appendChild(div);
              fn1(div, textElement);
            }
            top = Math.max(_this.aceEditor.getFirstVisibleRow(), 0);
            bottom = Math.min(_this.aceEditor.getLastVisibleRow(), _this.view.getViewNodeFor(_this.tree).lineLength - 1);
            treeView = _this.view.getViewNodeFor(_this.tree);
            lineHeight = _this.aceEditor.renderer.layerConfig.lineHeight;
            aceScrollTop = _this.aceEditor.session.getScrollTop();
            fn2 = function(div, line) {
              return setTimeout((function() {
                div.style.left = 0;
                div.style.top = (treeView.bounds[line].y + treeView.distanceToBase[line].above - _this.view.opts.textHeight - _this.fontAscent - _this.scrollOffsets.main.y) + "px";
                return div.style.fontSize = _this.fontSize + 'px';
              }), 0);
            };
            for (line = k = ref2 = top, ref3 = bottom; ref2 <= ref3 ? k <= ref3 : k >= ref3; line = ref2 <= ref3 ? ++k : --k) {
              div = document.createElement('div');
              div.style.whiteSpace = 'pre';
              div.innerText = div.textContent = line + 1;
              div.style.font = _this.aceFontSize() + ' ' + _this.fontFamily;
              div.style.width = _this.aceEditor.renderer.$gutter.offsetWidth + "px";
              div.style.left = 0;
              div.style.top = (_this.aceEditor.session.documentToScreenRow(line, 0) * lineHeight - aceScrollTop) + "px";
              div.className = 'droplet-transitioning-element droplet-transitioning-gutter';
              div.style.transition = "left " + translateTime + "ms, top " + translateTime + "ms, font-size " + translateTime + "ms";
              translatingElements.push(div);
              _this.dropletElement.appendChild(div);
              fn2(div, line);
            }
            ref4 = [_this.mainCanvas, _this.highlightCanvas, _this.cursorCanvas];
            for (l = 0, len1 = ref4.length; l < len1; l++) {
              el = ref4[l];
              el.style.opacity = 0;
            }
            setTimeout((function() {
              var len2, m, ref5;
              ref5 = [_this.mainCanvas, _this.highlightCanvas, _this.cursorCanvas];
              for (m = 0, len2 = ref5.length; m < len2; m++) {
                el = ref5[m];
                el.style.transition = "opacity " + fadeTime + "ms linear";
              }
              _this.mainCanvas.style.opacity = 1;
              _this.highlightCanvas.style.opacity = 1;
              if (_this.editorHasFocus()) {
                return _this.cursorCanvas.style.opacity = 1;
              } else {
                return _this.cursorCanvas.style.opacity = CURSOR_UNFOCUSED_OPACITY;
              }
            }), translateTime);
            _this.dropletElement.style.transition = _this.paletteWrapper.style.transition = "left " + fadeTime + "ms";
            _this.dropletElement.style.left = _this.paletteWrapper.offsetWidth + "px";
            _this.paletteWrapper.style.left = '0px';
            return setTimeout((function() {
              var len2, m;
              _this.dropletElement.style.transition = _this.paletteWrapper.style.transition = '';
              _this.mainScroller.style.overflow = 'auto';
              _this.currentlyAnimating = false;
              _this.lineNumberWrapper.style.display = 'block';
              _this.redrawMain();
              _this.paletteHeader.style.zIndex = 257;
              for (m = 0, len2 = translatingElements.length; m < len2; m++) {
                div = translatingElements[m];
                div.parentNode.removeChild(div);
              }
              _this.resizeBlockMode();
              _this.fireEvent('toggledone', [_this.currentlyUsingBlocks]);
              if (cb != null) {
                return cb();
              }
            }), translateTime + fadeTime);
          };
        })(this)), 0);
        return {
          success: true
        };
      }
    };
    Editor.prototype.toggleBlocks = function(cb) {
      if (this.currentlyUsingBlocks) {
        return this.performMeltAnimation(500, 1000, cb);
      } else {
        return this.performFreezeAnimation(500, 500, cb);
      }
    };
    hook('populate', 2, function() {
      this.scrollOffsets = {
        main: new this.draw.Point(0, 0),
        palette: new this.draw.Point(0, 0)
      };
      this.mainScroller = document.createElement('div');
      this.mainScroller.className = 'droplet-main-scroller';
      this.mainScrollerStuffing = document.createElement('div');
      this.mainScrollerStuffing.className = 'droplet-main-scroller-stuffing';
      this.mainScroller.appendChild(this.mainScrollerStuffing);
      this.dropletElement.appendChild(this.mainScroller);
      this.wrapperElement.addEventListener('scroll', (function(_this) {
        return function() {
          return _this.wrapperElement.scrollTop = _this.wrapperElement.scrollLeft = 0;
        };
      })(this));
      this.mainScroller.addEventListener('scroll', (function(_this) {
        return function() {
          _this.scrollOffsets.main.y = _this.mainScroller.scrollTop;
          _this.scrollOffsets.main.x = _this.mainScroller.scrollLeft;
          _this.mainCtx.setTransform(1, 0, 0, 1, -_this.scrollOffsets.main.x, -_this.scrollOffsets.main.y);
          _this.highlightCtx.setTransform(1, 0, 0, 1, -_this.scrollOffsets.main.x, -_this.scrollOffsets.main.y);
          _this.cursorCtx.setTransform(1, 0, 0, 1, -_this.scrollOffsets.main.x, -_this.scrollOffsets.main.y);
          return _this.redrawMain();
        };
      })(this));
      this.paletteScroller = document.createElement('div');
      this.paletteScroller.className = 'droplet-palette-scroller';
      this.paletteScrollerStuffing = document.createElement('div');
      this.paletteScrollerStuffing.className = 'droplet-palette-scroller-stuffing';
      this.paletteScroller.appendChild(this.paletteScrollerStuffing);
      this.paletteWrapper.appendChild(this.paletteScroller);
      return this.paletteScroller.addEventListener('scroll', (function(_this) {
        return function() {
          _this.scrollOffsets.palette.y = _this.paletteScroller.scrollTop;
          _this.paletteCtx.setTransform(1, 0, 0, 1, -_this.scrollOffsets.palette.x, -_this.scrollOffsets.palette.y);
          _this.paletteHighlightCtx.setTransform(1, 0, 0, 1, -_this.scrollOffsets.palette.x, -_this.scrollOffsets.palette.y);
          return _this.redrawPalette();
        };
      })(this));
    });
    Editor.prototype.resizeMainScroller = function() {
      this.mainScroller.style.width = this.dropletElement.offsetWidth + "px";
      return this.mainScroller.style.height = this.dropletElement.offsetHeight + "px";
    };
    hook('resize_palette', 0, function() {
      this.paletteScroller.style.top = this.paletteHeader.offsetHeight + "px";
      this.paletteScroller.style.width = this.paletteCanvas.offsetWidth + "px";
      return this.paletteScroller.style.height = this.paletteCanvas.offsetHeight + "px";
    });
    hook('redraw_main', 1, function() {
      var bounds, j, len, record, ref1;
      bounds = this.view.getViewNodeFor(this.tree).getBounds();
      ref1 = this.floatingBlocks;
      for (j = 0, len = ref1.length; j < len; j++) {
        record = ref1[j];
        bounds.unite(this.view.getViewNodeFor(record.block).getBounds());
      }
      this.mainScrollerStuffing.style.width = (bounds.right()) + "px";
      return this.mainScrollerStuffing.style.height = (bounds.bottom()) + "px";
    });
    hook('redraw_palette', 0, function() {
      var bounds, entry, j, len, ref1;
      bounds = new this.draw.NoRectangle();
      ref1 = this.currentPaletteBlocks;
      for (j = 0, len = ref1.length; j < len; j++) {
        entry = ref1[j];
        bounds.unite(this.view.getViewNodeFor(entry.block).getBounds());
      }
      return this.paletteScrollerStuffing.style.height = (bounds.bottom()) + "px";
    });
    hook('populate', 0, function() {
      this.fontSize = 15;
      this.fontFamily = 'Courier New';
      return this.fontAscent = helper.fontMetrics(this.fontFamily, this.fontSize).prettytop;
    });
    Editor.prototype.setFontSize_raw = function(fontSize) {
      if (this.fontSize !== fontSize) {
        this.fontSize = fontSize;
        this.paletteHeader.style.fontSize = fontSize + "px";
        this.gutter.style.fontSize = fontSize + "px";
        this.view.opts.textHeight = this.dragView.opts.textHeight = helper.getFontHeight(this.fontFamily, this.fontSize);
        this.fontAscent = helper.fontMetrics(this.fontFamily, this.fontSize).prettytop;
        this.view.clearCache();
        this.dragView.clearCache();
        this.gutter.style.width = this.aceEditor.renderer.$gutterLayer.gutterWidth + 'px';
        this.redrawMain();
        return this.rebuildPalette();
      }
    };
    Editor.prototype.setFontFamily = function(fontFamily) {
      this.draw.setGlobalFontFamily(fontFamily);
      this.fontFamily = fontFamily;
      this.view.opts.textHeight = helper.getFontHeight(this.fontFamily, this.fontSize);
      this.fontAscent = helper.fontMetrics(this.fontFamily, this.fontSize).prettytop;
      this.view.clearCache();
      this.dragView.clearCache();
      this.gutter.style.fontFamily = fontFamily;
      this.redrawMain();
      return this.rebuildPalette();
    };
    Editor.prototype.setFontSize = function(fontSize) {
      this.setFontSize_raw(fontSize);
      return this.resizeBlockMode();
    };
    hook('populate', 0, function() {
      this.markedLines = {};
      this.markedBlocks = {};
      this.nextMarkedBlockId = 0;
      return this.extraMarks = {};
    });
    Editor.prototype.getHighlightPath = function(model, style) {
      var path;
      path = this.view.getViewNodeFor(model).path.clone();
      path.style.fillColor = null;
      path.style.strokeColor = style.color;
      path.style.lineWidth = 3;
      path.noclip = true;
      path.bevel = false;
      return path;
    };
    Editor.prototype.markLine = function(line, style) {
      var block;
      block = this.tree.getBlockOnLine(line);
      if (block != null) {
        this.markedLines[line] = {
          model: block,
          style: style
        };
      }
      return this.redrawHighlights();
    };
    Editor.prototype.mark = function(line, col, style) {
      var chars, head, key, lineStart, parent;
      lineStart = this.tree.getNewlineBefore(line);
      chars = 0;
      parent = lineStart.parent;
      while (parent !== this.tree) {
        if (parent.type === 'indent') {
          chars += parent.prefix.length;
        }
        parent = parent.parent;
      }
      head = lineStart.next;
      while (!((chars >= col && head.type === 'blockStart') || head.type === 'newline')) {
        chars += head.stringify().length;
        head = head.next;
      }
      if (head.type === 'newline') {
        return false;
      }
      key = this.nextMarkedBlockId++;
      this.markedBlocks[key] = {
        model: head.container,
        style: style
      };
      this.redrawHighlights();
      return key;
    };
    Editor.prototype.unmark = function(key) {
      delete this.markedBlocks[key];
      return true;
    };
    Editor.prototype.unmarkLine = function(line) {
      delete this.markedLines[line];
      return this.redrawMain();
    };
    Editor.prototype.clearLineMarks = function() {
      this.markedLines = this.markedBlocks = {};
      return this.redrawMain();
    };
    hook('populate', 0, function() {
      return this.lastHoveredLine = null;
    });
    hook('mousemove', 0, function(point, event, state) {
      var hoveredLine, mainPoint, treeView;
      if ((this.draggingBlock == null) && (this.clickedBlock == null) && this.hasEvent('linehover')) {
        if (!this.trackerPointIsInMainScroller(point)) {
          return;
        }
        mainPoint = this.trackerPointToMain(point);
        treeView = this.view.getViewNodeFor(this.tree);
        if ((this.lastHoveredLine != null) && (treeView.bounds[this.lastHoveredLine] != null) && treeView.bounds[this.lastHoveredLine].contains(mainPoint)) {
          return;
        }
        hoveredLine = this.findLineNumberAtCoordinate(mainPoint.y);
        if (!treeView.bounds[hoveredLine].contains(mainPoint)) {
          hoveredLine = null;
        }
        if (hoveredLine !== this.lastHoveredLine) {
          return this.fireEvent('linehover', [
            {
              line: this.lastHoveredLine = hoveredLine
            }
          ]);
        }
      }
    });
    SetValueOperation = (function(superClass) {
      extend(SetValueOperation, superClass);

      function SetValueOperation(oldValue, newValue) {
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.oldValue = this.oldValue.clone();
        this.newValue = this.newValue.clone();
      }

      SetValueOperation.prototype.undo = function(editor) {
        editor.tree = this.oldValue.clone();
        return editor.tree.start;
      };

      SetValueOperation.prototype.redo = function(editor) {
        editor.tree = this.newValue.clone();
        return editor.tree.start;
      };

      return SetValueOperation;

    })(UndoOperation);
    hook('populate', 0, function() {
      return this.trimWhitespace = false;
    });
    Editor.prototype.setTrimWhitespace = function(trimWhitespace) {
      return this.trimWhitespace = trimWhitespace;
    };
    Editor.prototype.setValue_raw = function(value) {
      var e, newParse;
      try {
        if (this.trimWhitespace) {
          value = value.trim();
        }
        newParse = this.mode.parse(value, {
          wrapAtRoot: true
        });
        if (value !== this.tree.stringify(this.mode.empty)) {
          this.addMicroUndoOperation('CAPTURE_POINT');
        }
        this.addMicroUndoOperation(new SetValueOperation(this.tree, newParse));
        this.tree = newParse;
        this.gutterVersion = -1;
        this.tree.start.insert(this.cursor);
        this.removeBlankLines();
        this.redrawMain();
        return {
          success: true
        };
      } catch (_error) {
        e = _error;
        return {
          success: false,
          error: e
        };
      }
    };
    Editor.prototype.setValue = function(value) {
      var oldScrollTop, result;
      oldScrollTop = this.aceEditor.session.getScrollTop();
      this.setAceValue(value);
      this.resizeTextMode();
      this.aceEditor.session.setScrollTop(oldScrollTop);
      if (this.currentlyUsingBlocks) {
        result = this.setValue_raw(value);
        if (result.success === false) {
          this.setEditorState(false);
          this.aceEditor.setValue(value);
          if (result.error) {
            return this.fireEvent('parseerror', [result.error]);
          }
        }
      }
    };
    Editor.prototype.addEmptyLine = function(str) {
      if (str.length === 0 || str[str.length - 1] === '\n') {
        return str;
      } else {
        return str + '\n';
      }
    };
    Editor.prototype.getValue = function() {
      if (this.currentlyUsingBlocks) {
        return this.addEmptyLine(this.tree.stringify(this.mode.empty));
      } else {
        return this.getAceValue();
      }
    };
    Editor.prototype.getAceValue = function() {
      var value;
      value = this.aceEditor.getValue();
      return this.lastAceSeenValue = value;
    };
    Editor.prototype.setAceValue = function(value) {
      if (value !== this.lastAceSeenValue) {
        this.aceEditor.setValue(value, 1);
        return this.lastAceSeenValue = value;
      }
    };
    Editor.prototype.on = function(event, handler) {
      return this.bindings[event] = handler;
    };
    Editor.prototype.once = function(event, handler) {
      return this.bindings[event] = function() {
        handler.apply(this, arguments);
        return this.bindings[event] = null;
      };
    };
    Editor.prototype.fireEvent = function(event, args) {
      if (event in this.bindings) {
        return this.bindings[event].apply(this, args);
      }
    };
    Editor.prototype.hasEvent = function(event) {
      return event in this.bindings && (this.bindings[event] != null);
    };
    Editor.prototype.setEditorState = function(useBlocks) {
      var oldScrollTop;
      if (useBlocks) {
        this.setValue(this.getAceValue());
        this.dropletElement.style.top = this.paletteWrapper.style.top = this.paletteWrapper.style.left = '0px';
        this.dropletElement.style.left = this.paletteWrapper.offsetWidth + "px";
        this.aceElement.style.top = this.aceElement.style.left = '-9999px';
        this.currentlyUsingBlocks = true;
        this.lineNumberWrapper.style.display = 'block';
        this.mainCanvas.opacity = this.paletteWrapper.opacity = this.highlightCanvas.opacity = 1;
        this.resizeBlockMode();
        return this.redrawMain();
      } else {
        oldScrollTop = this.aceEditor.session.getScrollTop();
        this.setAceValue(this.getValue());
        this.aceEditor.resize(true);
        this.aceEditor.session.setScrollTop(oldScrollTop);
        this.dropletElement.style.top = this.dropletElement.style.left = this.paletteWrapper.style.top = this.paletteWrapper.style.left = '-9999px';
        this.aceElement.style.top = this.aceElement.style.left = '0px';
        this.currentlyUsingBlocks = false;
        this.lineNumberWrapper.style.display = 'none';
        this.mainCanvas.opacity = this.highlightCanvas.opacity = 0;
        return this.resizeBlockMode();
      }
    };
    hook('populate', 0, function() {
      this.dragCover = document.createElement('div');
      this.dragCover.className = 'droplet-drag-cover';
      this.dragCover.style.display = 'none';
      return document.body.appendChild(this.dragCover);
    });
    hook('mousedown', -1, function() {
      if (this.clickedBlock != null) {
        return this.dragCover.style.display = 'block';
      }
    });
    hook('mouseup', 0, function() {
      this.dragCanvas.style.top = this.dragCanvas.style.left = '-9999px';
      return this.dragCover.style.display = 'none';
    });
    hook('mousedown', 10, function() {
      if (this.draggingBlock != null) {
        return this.endDrag();
      }
    });
    Editor.prototype.endDrag = function() {
      this.draggingBlock = null;
      this.draggingOffset = null;
      this.lastHighlight = null;
      this.clearDrag();
      this.redrawMain();
    };
    hook('rebuild_palette', 0, function() {
      return this.fireEvent('changepalette', []);
    });
    touchEvents = {
      'touchstart': 'mousedown',
      'touchmove': 'mousemove',
      'touchend': 'mouseup'
    };
    TOUCH_SELECTION_TIMEOUT = 1000;
    Editor.prototype.touchEventToPoint = function(event, index) {
      var absolutePoint;
      absolutePoint = new this.draw.Point(event.changedTouches[index].clientX, event.changedTouches[index].clientY);
      return absolutePoint;
    };
    Editor.prototype.queueLassoMousedown = function(trackPoint, event) {
      return this.lassoSelectStartTimeout = setTimeout(((function(_this) {
        return function() {
          var handler, j, len, ref1, results, state;
          state = {};
          ref1 = editorBindings.mousedown;
          results = [];
          for (j = 0, len = ref1.length; j < len; j++) {
            handler = ref1[j];
            results.push(handler.call(_this, trackPoint, event, state));
          }
          return results;
        };
      })(this)), TOUCH_SELECTION_TIMEOUT);
    };
    hook('populate', 0, function() {
      this.touchScrollAnchor = new this.draw.Point(0, 0);
      this.lassoSelectStartTimeout = null;
      this.wrapperElement.addEventListener('touchstart', (function(_this) {
        return function(event) {
          var handler, j, len, ref1, state, trackPoint;
          clearTimeout(_this.lassoSelectStartTimeout);
          trackPoint = _this.touchEventToPoint(event, 0);
          state = {
            suppressLassoSelect: true
          };
          ref1 = editorBindings.mousedown;
          for (j = 0, len = ref1.length; j < len; j++) {
            handler = ref1[j];
            handler.call(_this, trackPoint, event, state);
          }
          if (state.consumedHitTest) {
            return event.preventDefault();
          } else {
            return _this.queueLassoMousedown(trackPoint, event);
          }
        };
      })(this));
      this.wrapperElement.addEventListener('touchmove', (function(_this) {
        return function(event) {
          var handler, j, len, ref1, state, trackPoint;
          clearTimeout(_this.lassoSelectStartTimeout);
          trackPoint = _this.touchEventToPoint(event, 0);
          if (!((_this.clickedBlock != null) || (_this.draggingBlock != null))) {
            _this.queueLassoMousedown(trackPoint, event);
          }
          state = {};
          ref1 = editorBindings.mousemove;
          for (j = 0, len = ref1.length; j < len; j++) {
            handler = ref1[j];
            handler.call(_this, trackPoint, event, state);
          }
          if ((_this.clickedBlock != null) || (_this.draggingBlock != null) || (_this.lassoSelectAnchor != null) || _this.textInputSelecting) {
            return event.preventDefault();
          }
        };
      })(this));
      return this.wrapperElement.addEventListener('touchend', (function(_this) {
        return function(event) {
          var handler, j, len, ref1, state, trackPoint;
          clearTimeout(_this.lassoSelectStartTimeout);
          trackPoint = _this.touchEventToPoint(event, 0);
          state = {};
          ref1 = editorBindings.mouseup;
          for (j = 0, len = ref1.length; j < len; j++) {
            handler = ref1[j];
            handler.call(_this, trackPoint, event, state);
          }
          return event.preventDefault();
        };
      })(this));
    });
    hook('populate', 0, function() {
      this.cursorCanvas = document.createElement('canvas');
      this.cursorCanvas.className = 'droplet-highlight-canvas droplet-cursor-canvas';
      this.cursorCtx = this.cursorCanvas.getContext('2d');
      return this.dropletElement.appendChild(this.cursorCanvas);
    });
    Editor.prototype.resizeCursorCanvas = function() {
      this.cursorCanvas.width = this.dropletElement.offsetWidth;
      this.cursorCanvas.style.width = this.cursorCanvas.width + "px";
      this.cursorCanvas.height = this.dropletElement.offsetHeight;
      this.cursorCanvas.style.height = this.cursorCanvas.height + "px";
      return this.cursorCanvas.style.left = this.mainCanvas.offsetLeft + "px";
    };
    Editor.prototype.strokeCursor = function(point) {
      var arcAngle, arcCenter, endAngle, h, startAngle, w;
      if (point == null) {
        return;
      }
      this.cursorCtx.beginPath();
      this.cursorCtx.fillStyle = this.cursorCtx.strokeStyle = '#000';
      this.cursorCtx.lineCap = 'round';
      this.cursorCtx.lineWidth = 3;
      w = this.view.opts.tabWidth / 2 - CURSOR_WIDTH_DECREASE;
      h = this.view.opts.tabHeight - CURSOR_HEIGHT_DECREASE;
      arcCenter = new this.draw.Point(point.x + this.view.opts.tabOffset + w + CURSOR_WIDTH_DECREASE, point.y - (w * w + h * h) / (2 * h) + h + CURSOR_HEIGHT_DECREASE / 2);
      arcAngle = Math.atan2(w, (w * w + h * h) / (2 * h) - h);
      startAngle = 0.5 * Math.PI - arcAngle;
      endAngle = 0.5 * Math.PI + arcAngle;
      this.cursorCtx.arc(arcCenter.x, arcCenter.y, (w * w + h * h) / (2 * h), startAngle, endAngle);
      return this.cursorCtx.stroke();
    };
    Editor.prototype.highlightFlashShow = function() {
      if (this.flashTimeout != null) {
        clearTimeout(this.flashTimeout);
      }
      this.cursorCanvas.style.display = 'block';
      this.highlightsCurrentlyShown = true;
      return this.flashTimeout = setTimeout(((function(_this) {
        return function() {
          return _this.flash();
        };
      })(this)), 500);
    };
    Editor.prototype.highlightFlashHide = function() {
      if (this.flashTimeout != null) {
        clearTimeout(this.flashTimeout);
      }
      this.cursorCanvas.style.display = 'none';
      this.highlightsCurrentlyShown = false;
      return this.flashTimeout = setTimeout(((function(_this) {
        return function() {
          return _this.flash();
        };
      })(this)), 500);
    };
    Editor.prototype.editorHasFocus = function() {
      var ref1;
      return ((ref1 = document.activeElement) === this.dropletElement || ref1 === this.hiddenInput || ref1 === this.copyPasteInput) && document.hasFocus();
    };
    Editor.prototype.flash = function() {
      if ((this.lassoSegment != null) || (this.draggingBlock != null) || ((this.textFocus != null) && this.textInputHighlighted) || !this.highlightsCurrentlyShown || !this.editorHasFocus()) {
        return this.highlightFlashShow();
      } else {
        return this.highlightFlashHide();
      }
    };
    hook('populate', 0, function() {
      var blurCursors, focusCursors;
      this.highlightsCurrentlyShown = false;
      blurCursors = (function(_this) {
        return function() {
          _this.highlightFlashShow();
          _this.cursorCanvas.style.transition = '';
          return _this.cursorCanvas.style.opacity = CURSOR_UNFOCUSED_OPACITY;
        };
      })(this);
      this.dropletElement.addEventListener('blur', blurCursors);
      this.hiddenInput.addEventListener('blur', blurCursors);
      this.copyPasteInput.addEventListener('blur', blurCursors);
      focusCursors = (function(_this) {
        return function() {
          _this.highlightFlashShow();
          _this.cursorCanvas.style.transition = '';
          return _this.cursorCanvas.style.opacity = 1;
        };
      })(this);
      this.dropletElement.addEventListener('focus', focusCursors);
      this.hiddenInput.addEventListener('focus', focusCursors);
      this.copyPasteInput.addEventListener('focus', focusCursors);
      return this.flashTimeout = setTimeout(((function(_this) {
        return function() {
          return _this.flash();
        };
      })(this)), 0);
    });
    Editor.prototype.mainViewOrChildrenContains = function(model, point) {
      var childObj, j, len, modelView, ref1;
      modelView = this.view.getViewNodeFor(model);
      if (modelView.path.contains(point)) {
        return true;
      }
      ref1 = modelView.children;
      for (j = 0, len = ref1.length; j < len; j++) {
        childObj = ref1[j];
        if (this.mainViewOrChildrenContains(childObj.child, point)) {
          return true;
        }
      }
      return false;
    };
    hook('mouseup', 0.5, function(point, event) {
      var renderPoint, trackPoint;
      if (this.draggingBlock != null) {
        trackPoint = new this.draw.Point(point.x + this.draggingOffset.x, point.y + this.draggingOffset.y);
        renderPoint = this.trackerPointToMain(trackPoint);
        if (this.inTree(this.draggingBlock) && this.mainViewOrChildrenContains(this.draggingBlock, renderPoint)) {
          this.draggingBlock.ephemeral = false;
          return this.endDrag();
        }
      }
    });
    hook('populate', 0, function() {
      this.gutter = document.createElement('div');
      this.gutter.className = 'droplet-gutter';
      this.lineNumberWrapper = document.createElement('div');
      this.gutter.appendChild(this.lineNumberWrapper);
      this.gutterVersion = -1;
      this.lineNumberTags = {};
      return this.dropletElement.appendChild(this.gutter);
    });
    Editor.prototype.resizeGutter = function() {
      var ref1, ref2;
      this.gutter.style.width = this.aceEditor.renderer.$gutterLayer.gutterWidth + 'px';
      return this.gutter.style.height = (Math.max(this.dropletElement.offsetHeight, (ref1 = (ref2 = this.view.getViewNodeFor(this.tree).totalBounds) != null ? ref2.height : void 0) != null ? ref1 : 0)) + "px";
    };
    Editor.prototype.addLineNumberForLine = function(line) {
      var lineDiv, treeView;
      treeView = this.view.getViewNodeFor(this.tree);
      if (line in this.lineNumberTags) {
        lineDiv = this.lineNumberTags[line];
      } else {
        lineDiv = document.createElement('div');
        lineDiv.className = 'droplet-gutter-line';
        lineDiv.innerText = lineDiv.textContent = line + 1;
        this.lineNumberTags[line] = lineDiv;
      }
      lineDiv.style.top = (treeView.bounds[line].y + treeView.distanceToBase[line].above - this.view.opts.textHeight - this.fontAscent - this.scrollOffsets.main.y) + "px";
      lineDiv.style.height = treeView.bounds[line].height + 'px';
      lineDiv.style.fontSize = this.fontSize + 'px';
      return this.lineNumberWrapper.appendChild(lineDiv);
    };
    Editor.prototype.findLineNumberAtCoordinate = function(coord) {
      var end, pivot, start, treeView;
      treeView = this.view.getViewNodeFor(this.tree);
      start = 0;
      end = treeView.bounds.length;
      pivot = Math.floor((start + end) / 2);
      while (treeView.bounds[pivot].y !== coord && start < end) {
        if (start === pivot || end === pivot) {
          return pivot;
        }
        if (treeView.bounds[pivot].y > coord) {
          end = pivot;
        } else {
          start = pivot;
        }
        if (end < 0) {
          return 0;
        }
        if (start >= treeView.bounds.length) {
          return treeView.bounds.length - 1;
        }
        pivot = Math.floor((start + end) / 2);
      }
      return pivot;
    };
    hook('redraw_main', 0, function(changedBox) {
      var bottom, j, line, ref1, ref2, ref3, tag, top, treeView;
      treeView = this.view.getViewNodeFor(this.tree);
      top = this.findLineNumberAtCoordinate(this.scrollOffsets.main.y);
      bottom = this.findLineNumberAtCoordinate(this.scrollOffsets.main.y + this.mainCanvas.height);
      for (line = j = ref1 = top, ref2 = bottom; ref1 <= ref2 ? j <= ref2 : j >= ref2; line = ref1 <= ref2 ? ++j : --j) {
        this.addLineNumberForLine(line);
      }
      ref3 = this.lineNumberTags;
      for (line in ref3) {
        tag = ref3[line];
        if (line < top || line > bottom) {
          this.lineNumberTags[line].parentNode.removeChild(this.lineNumberTags[line]);
          delete this.lineNumberTags[line];
        }
      }
      if (changedBox) {
        return this.gutter.style.height = (Math.max(this.mainScroller.offsetHeight, treeView.totalBounds.height)) + "px";
      }
    });
    Editor.prototype.setPaletteWidth = function(width) {
      this.paletteWrapper.style.width = width + 'px';
      return this.resizeBlockMode();
    };
    hook('populate', 1, function() {
      var pressedVKey, pressedXKey;
      this.copyPasteInput = document.createElement('textarea');
      this.copyPasteInput.style.position = 'absolute';
      this.copyPasteInput.style.left = this.copyPasteInput.style.top = '-9999px';
      this.dropletElement.appendChild(this.copyPasteInput);
      pressedVKey = false;
      pressedXKey = false;
      this.copyPasteInput.addEventListener('keydown', function(event) {
        if (event.keyCode === 86) {
          return pressedVKey = true;
        } else if (event.keyCode === 88) {
          return pressedXKey = true;
        }
      });
      this.copyPasteInput.addEventListener('keyup', function(event) {
        if (event.keyCode === 86) {
          return pressedVKey = false;
        } else if (event.keyCode === 88) {
          return pressedXKey = false;
        }
      });
      return this.copyPasteInput.addEventListener('input', (function(_this) {
        return function() {
          var blocks, e, j, len, line, minIndent, ref1, ref2, str;
          if (pressedVKey) {
            try {
              str = _this.copyPasteInput.value;
              minIndent = Infinity;
              ref1 = str.split('\n');
              for (j = 0, len = ref1.length; j < len; j++) {
                line = ref1[j];
                minIndent = Math.min(minIndent, str.length - str.trimLeft().length);
              }
              str = ((function() {
                var k, len1, ref2, results;
                ref2 = str.split('\n');
                results = [];
                for (k = 0, len1 = ref2.length; k < len1; k++) {
                  line = ref2[k];
                  results.push(line.slice(minIndent));
                }
                return results;
              })()).join('\n');
              str = str.replace(/^\n*|\n*$/g, '');
              blocks = _this.mode.parse(str);
              _this.addMicroUndoOperation('CAPTURE_POINT');
              if (_this.lassoSegment != null) {
                _this.addMicroUndoOperation(new PickUpOperation(_this.lassoSegment));
                _this.spliceOut(_this.lassoSegment);
                _this.lassoSegment = null;
              }
              _this.addMicroUndoOperation(new DropOperation(blocks, _this.cursor.previousVisibleToken()));
              _this.spliceIn(blocks, _this.cursor);
              if ((ref2 = blocks.end.nextVisibleToken().type) !== 'newline' && ref2 !== 'indentEnd') {
                blocks.end.insert(new model.NewlineToken());
              }
              _this.addMicroUndoOperation(new DestroySegmentOperation(blocks));
              blocks.unwrap();
              _this.redrawMain();
            } catch (_error) {
              e = _error;
              console.log(e.stack);
            }
            return _this.copyPasteInput.setSelectionRange(0, _this.copyPasteInput.value.length);
          } else if (pressedXKey && (_this.lassoSegment != null)) {
            _this.addMicroUndoOperation('CAPTURE_POINT');
            _this.addMicroUndoOperation(new PickUpOperation(_this.lassoSegment));
            _this.spliceOut(_this.lassoSegment);
            _this.lassoSegment = null;
            return _this.redrawMain();
          }
        };
      })(this));
    });
    hook('keydown', 0, function(event, state) {
      var ref1, x, y;
      if (ref1 = event.which, indexOf.call(command_modifiers, ref1) >= 0) {
        if (this.textFocus == null) {
          x = document.body.scrollLeft;
          y = document.body.scrollTop;
          this.copyPasteInput.focus();
          window.scrollTo(x, y);
          if (this.lassoSegment != null) {
            this.copyPasteInput.value = this.lassoSegment.stringify(this.mode.empty);
          }
          return this.copyPasteInput.setSelectionRange(0, this.copyPasteInput.value.length);
        }
      }
    });
    hook('keyup', 0, function(point, event, state) {
      var ref1;
      if (ref1 = event.which, indexOf.call(command_modifiers, ref1) >= 0) {
        if (this.textFocus != null) {
          return this.hiddenInput.focus();
        } else {
          return this.dropletElement.focus();
        }
      }
    });
    hook('populate', 0, function() {
      return setTimeout(((function(_this) {
        return function() {
          return _this.cursor.parent = _this.tree;
        };
      })(this)), 0);
    });
    Editor.prototype.overflowsX = function() {
      return this.documentDimensions().width > this.viewportDimensions().width;
    };
    Editor.prototype.overflowsY = function() {
      return this.documentDimensions().height > this.viewportDimensions().height;
    };
    Editor.prototype.documentDimensions = function() {
      var bounds;
      bounds = this.view.getViewNodeFor(this.tree).totalBounds;
      return {
        width: bounds.width,
        height: bounds.height
      };
    };
    Editor.prototype.viewportDimensions = function() {
      return {
        width: this.mainCanvas.width,
        height: this.mainCanvas.height
      };
    };
    Editor.prototype.dumpNodeForDebug = function(hitTestResult, line) {
      console.log('Model node:');
      console.log(hitTestResult.serialize());
      console.log('View node:');
      return console.log(this.view.getViewNodeFor(hitTestResult).serialize(line));
    };
    for (key in unsortedEditorBindings) {
      unsortedEditorBindings[key].sort(function(a, b) {
        if (a.priority > b.priority) {
          return -1;
        } else {
          return 1;
        }
      });
      editorBindings[key] = [];
      ref1 = unsortedEditorBindings[key];
      for (j = 0, len = ref1.length; j < len; j++) {
        binding = ref1[j];
        editorBindings[key].push(binding.fn);
      }
    }
    return exports;
  });

}).call(this);

//# sourceMappingURL=controller.js.map
