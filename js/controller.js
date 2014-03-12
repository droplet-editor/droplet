(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['ice-coffee', 'ice-draw', 'ice-model'], function(coffee, draw, model) {
    var ANIMATION_FRAME_RATE, AnimatedColor, Editor, FONT_SIZE, INDENT_SPACES, INPUT_LINE_HEIGHT, IceEditorChangeEvent, MIN_DRAG_DISTANCE, PADDING, PALETTE_MARGIN, PALETTE_WIDTH, SCROLL_INTERVAL, exports, findPosLeft, findPosTop;
    PADDING = 5;
    INDENT_SPACES = 2;
    INPUT_LINE_HEIGHT = 15;
    PALETTE_MARGIN = 10;
    PALETTE_WIDTH = 300;
    MIN_DRAG_DISTANCE = 5;
    FONT_SIZE = 15;
    ANIMATION_FRAME_RATE = 50;
    SCROLL_INTERVAL = 50;
    exports = {};
    findPosTop = function(obj) {
      var top;
      top = 0;
      while (true) {
        top += obj.offsetTop;
        if ((obj = obj.offsetParent) == null) {
          break;
        }
      }
      return top;
    };
    findPosLeft = function(obj) {
      var left;
      left = 0;
      while (true) {
        left += obj.offsetLeft;
        if ((obj = obj.offsetParent) == null) {
          break;
        }
      }
      return left;
    };
    AnimatedColor = (function() {
      function AnimatedColor(start, end, time) {
        this.start = start;
        this.end = end;
        this.time = time;
        this.currentRGB = [parseInt(this.start.slice(1, 3), 16), parseInt(this.start.slice(3, 5), 16), parseInt(this.start.slice(5, 7), 16)];
        this.step = [(parseInt(this.end.slice(1, 3), 16) - this.currentRGB[0]) / this.time, (parseInt(this.end.slice(3, 5), 16) - this.currentRGB[1]) / this.time, (parseInt(this.end.slice(5, 7), 16) - this.currentRGB[2]) / this.time];
      }

      AnimatedColor.prototype.advance = function() {
        var i, item, _i, _len, _ref;
        _ref = this.currentRGB;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          item = _ref[i];
          this.currentRGB[i] += this.step[i];
        }
        return "rgb(" + (Math.round(this.currentRGB[0])) + "," + (Math.round(this.currentRGB[1])) + "," + (Math.round(this.currentRGB[2])) + ")";
      };

      return AnimatedColor;

    })();
    exports.IceEditorChangeEvent = IceEditorChangeEvent = (function() {
      function IceEditorChangeEvent(block, target) {
        this.block = block;
        this.target = target;
      }

      return IceEditorChangeEvent;

    })();
    exports.Editor = Editor = (function() {
      function Editor(wrapper, paletteBlocks) {
        var child, deleteFromCursor, drag, eventName, getPointFromEvent, getRectFromPoints, highlight, hitTest, hitTestFloating, hitTestFocus, hitTestLasso, hitTestPalette, hitTestRoot, insertHandwrittenBlock, moveBlockTo, moveCursorBefore, moveCursorDown, moveCursorTo, moveCursorUp, offset, paletteBlock, performNormalMouseDown, performNormalMouseMove, performNormalMouseUp, redrawTextInput, scrollCursorIntoView, setTextInputAnchor, setTextInputFocus, setTextInputHead, textInputAnchor, textInputHead, textInputSelecting, track, _editedInputLine, _i, _j, _len, _len1, _ref, _ref1,
          _this = this;
        this.paletteBlocks = paletteBlocks;
        this.aceEl = document.createElement('div');
        this.aceEl.className = 'ice_ace';
        wrapper.appendChild(this.aceEl);
        this.ace = ace.edit(this.aceEl);
        this.ace.setTheme('ace/theme/chrome');
        this.ace.getSession().setMode('ace/mode/coffee');
        this.ace.getSession().setTabSize(2);
        this.ace.setFontSize(15);
        this.el = document.createElement('div');
        this.el.className = 'ice_editor';
        wrapper.appendChild(this.el);
        if (this.paletteBlocks == null) {
          this.paletteBlocks = [];
        }
        this.paletteBlocks = (function() {
          var _i, _len, _ref, _results;
          _ref = this.paletteBlocks;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            paletteBlock = _ref[_i];
            _results.push(paletteBlock.clone());
          }
          return _results;
        }).call(this);
        this.tree = null;
        this.floatingBlocks = [];
        this.focus = null;
        this.editedText = null;
        this.handwritten = false;
        this.hiddenInput = null;
        this.ephemeralOldFocusValue = null;
        this.isEditingText = function() {
          return (_this.focus != null) && _this.hiddenInput === document.activeElement;
        };
        textInputAnchor = textInputHead = null;
        textInputSelecting = false;
        _editedInputLine = -1;
        this.selection = null;
        this.lassoSegment = null;
        this._lassoBounds = null;
        this.cursor = new model.CursorToken();
        this.undoStack = [];
        this.scrollOffset = new draw.Point(0, 0);
        this.touchScrollAnchor = null;
        offset = null;
        highlight = null;
        this.currentlyAnimating = false;
        this.main = document.createElement('canvas');
        this.main.className = 'canvas';
        this.main.height = this.el.offsetHeight;
        this.main.width = this.el.offsetWidth - PALETTE_WIDTH;
        this.palette = document.createElement('canvas');
        this.palette.className = 'palette';
        this.palette.height = this.el.offsetHeight;
        this.palette.width = PALETTE_WIDTH;
        drag = document.createElement('canvas');
        drag.className = 'drag';
        drag.height = this.el.offsetHeight;
        drag.width = this.el.offsetWidth - PALETTE_WIDTH;
        this.hiddenInput = document.createElement('input');
        this.hiddenInput.className = 'hidden_input';
        track = document.createElement('div');
        track.className = 'trackArea';
        _ref = [this.main, this.palette, drag, track, this.hiddenInput];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          this.el.appendChild(child);
        }
        this.mainCtx = this.main.getContext('2d');
        this.dragCtx = drag.getContext('2d');
        this.paletteCtx = this.palette.getContext('2d');
        draw._setCTX(this.mainCtx);
        this.clear = function() {
          return _this.mainCtx.clearRect(_this.scrollOffset.x, _this.scrollOffset.y, _this.main.width, _this.main.height);
        };
        this.redraw = function() {
          var float, view, _j, _k, _len1, _len2, _ref1, _ref2, _results;
          _this.clear();
          _this.tree.view.compute();
          _this.tree.view.draw(_this.mainCtx);
          if (_this.lassoSegment != null) {
            _this._lassoBounds = _this.lassoSegment.view.getBounds();
            _ref1 = _this.floatingBlocks;
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              float = _ref1[_j];
              if (_this.lassoSegment === float.block) {
                _this._lassoBounds.translate(float.position);
              }
            }
            if (_this.lassoSegment !== _this.selection) {
              _this._lassoBounds.stroke(_this.mainCtx, '#000');
              _this._lassoBounds.fill(_this.mainCtx, 'rgba(0, 0, 256, 0.3)');
            }
          }
          _ref2 = _this.floatingBlocks;
          _results = [];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            float = _ref2[_k];
            view = float.block.view;
            view.compute();
            view.translate(float.position);
            _results.push(view.draw(_this.mainCtx));
          }
          return _results;
        };
        this.attemptReparse = function() {
          var element, excludes, handwrittenBlock, head, newBlock, parent, reparseQueue, stack, _j, _k, _len1, _len2;
          head = _this.tree.start;
          stack = [];
          excludes = [];
          reparseQueue = [];
          while (head !== _this.tree.end) {
            switch (head.type) {
              case 'blockStart':
                stack.push(head.block);
                break;
              case 'indentStart':
                stack.push(head.indent);
                break;
              case 'socketStart':
                if (head.socket.handwritten && stack[stack.length - 1].type === 'block' && head.socket !== _this.focus) {
                  reparseQueue.push(stack[stack.length - 1]);
                }
                stack.push(head.socket);
                break;
              case 'cursor':
                for (_j = 0, _len1 = stack.length; _j < _len1; _j++) {
                  element = stack[_j];
                  excludes.push(element);
                }
                break;
              case 'blockEnd':
              case 'socketEnd':
              case 'indentEnd':
                stack.pop();
            }
            head = head.next;
          }
          for (_k = 0, _len2 = reparseQueue.length; _k < _len2; _k++) {
            handwrittenBlock = reparseQueue[_k];
            if (__indexOf.call(excludes, handwrittenBlock) < 0) {
              try {
                parent = handwrittenBlock.start.prev;
                newBlock = (coffee.parse(handwrittenBlock.toString())).segment;
                handwrittenBlock.start.prev.append(handwrittenBlock.end.next);
                handwrittenBlock.start.prev = null;
                handwrittenBlock.end.next = null;
                newBlock.moveTo(parent);
                newBlock.remove();
              } catch (_error) {}
            }
          }
          return _this.redraw();
        };
        moveBlockTo = function(block, target) {
          var float, parent, _j, _len1, _ref1;
          parent = block.start.prev;
          while ((parent != null) && (parent.type === 'newline' || (parent.type === 'segmentStart' && parent.segment !== _this.tree) || parent.type === 'cursor')) {
            parent = parent.prev;
          }
          _ref1 = _this.floatingBlocks;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            float = _ref1[_j];
            if (block === float.block) {
              _this.undoStack.push({
                type: 'floatingBlockMove',
                block: block,
                position: float.position
              });
            }
            block.moveTo(target);
            if (_this.onChange != null) {
              _this.onChange(new IceEditorChangeEvent(block, target));
            }
            return;
          }
          _this.undoStack.push({
            type: 'blockMove',
            block: block,
            target: parent != null ? ((function() {
              switch (parent.type) {
                case 'indentStart':
                case 'indentEnd':
                  return parent.indent;
                case 'blockStart':
                case 'blockEnd':
                  return parent.block;
                case 'socketStart':
                case 'socketEnd':
                  return parent.socket;
                case 'segmentStart':
                case 'segmentEnd':
                  return parent.segment;
                default:
                  return parent;
              }
            })()) : null
          });
          block.moveTo(target);
          if (_this.onChange != null) {
            return _this.onChange(new IceEditorChangeEvent(block, target));
          }
        };
        this.undo = function() {
          var float, head, i, lastOperation, operation, _j, _k, _len1, _len2, _ref1, _ref2;
          if (!(_this.undoStack.length > 0)) {
            return;
          }
          operation = lastOperation = _this.undoStack.pop();
          if (operation.type === 'blockMove') {
            _ref1 = _this.floatingBlocks;
            for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
              float = _ref1[i];
              if (operation.block === float.block) {
                _this.floatingBlocks.splice(i, 1);
              }
            }
            while (true) {
              if (operation == null) {
                break;
              }
              if (operation.target != null) {
                switch (operation.target.type) {
                  case 'indent':
                    head = operation.target.end.prev;
                    while (head.type === 'segmentEnd' || head.type === 'segmentStart' || head.type === 'cursor') {
                      head = head.prev;
                    }
                    if (head.type === 'newline') {
                      operation.block.moveTo(operation.target.start.next);
                    } else {
                      operation.block.moveTo(operation.target.start.insert(new model.NewlineToken()));
                    }
                    break;
                  case 'block':
                    operation.block.moveTo(operation.target.end.insert(new model.NewlineToken()));
                    break;
                  case 'socket':
                    if (operation.target.content() != null) {
                      operation.target.content().remove();
                    }
                    operation.block.moveTo(operation.target.start);
                    break;
                  default:
                    if (operation.target === _this.tree) {
                      operation.block.moveTo(_this.tree.start);
                      if (operation.block.end.next !== _this.tree.end) {
                        operation.block.end.insert(new model.NewlineToken());
                      }
                    }
                }
              } else {
                operation.block.moveTo(operation.target);
              }
              if (operation.type === 'floatingBlockMove') {
                operation.block.moveTo(null);
                _this.floatingBlocks.push({
                  position: operation.position,
                  block: operation.block
                });
              }
              if ((operation.target != null) || operation.type !== 'blockMove' || operation.block !== lastOperation.block) {
                break;
              }
              operation = _this.undoStack.pop();
            }
          } else if (operation.type === 'socketTextChange') {
            operation.socket.content().value = operation.value;
          } else if (operation.type === 'floatingBlockMove') {
            _ref2 = _this.floatingBlocks;
            for (i = _k = 0, _len2 = _ref2.length; _k < _len2; i = ++_k) {
              float = _ref2[i];
              if (operation.block === float.block) {
                _this.floatingBlocks.splice(i, 1);
              }
            }
            operation.block.moveTo(null);
            _this.floatingBlocks.push({
              position: operation.position,
              block: operation.block
            });
          }
          _this.redraw();
          if (_this.onChange != null) {
            return _this.onChange(new IceEditorChangeEvent(operation.block, operation.target));
          }
        };
        this.redrawPalette = function() {
          var lastBottomEdge, _j, _len1, _ref1, _results;
          lastBottomEdge = 0;
          _ref1 = _this.paletteBlocks;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            paletteBlock = _ref1[_j];
            paletteBlock.view.compute();
            paletteBlock.view.translate(new draw.Point(0, lastBottomEdge));
            lastBottomEdge = paletteBlock.view.bounds[paletteBlock.view.lineEnd].bottom() + PALETTE_MARGIN;
            _results.push(paletteBlock.view.draw(_this.paletteCtx));
          }
          return _results;
        };
        this.redrawPalette();
        insertHandwrittenBlock = function() {
          var newBlock, newSocket;
          newBlock = new model.Block([]);
          newSocket = new model.Socket([]);
          newSocket.handwritten = true;
          newBlock.start.insert(newSocket.start);
          newBlock.end.prev.insert(newSocket.end);
          if (_this.cursor.next.type === 'newline' || _this.cursor.next.type === 'indentEnd' || _this.cursor.next.type === 'segmentEnd') {
            if (_this.cursor.next.type === 'indentEnd' && _this.cursor.prev.type === 'newline') {
              moveBlockTo(newBlock, _this.cursor.prev);
            } else {
              moveBlockTo(newBlock, _this.cursor.prev.insert(new model.NewlineToken()));
            }
            _this.redraw();
            setTextInputFocus(newSocket);
          } else if (_this.cursor.prev.type === 'newline' || _this.cursor.prev === _this.tree.start) {
            moveBlockTo(newBlock, _this.cursor.prev);
            newBlock.end.insert(new model.NewlineToken());
            _this.redraw();
            setTextInputFocus(newSocket);
          }
          return scrollCursorIntoView();
        };
        scrollCursorIntoView = function() {
          _this.redraw();
          if (_this.cursor.view.point.y < _this.scrollOffset.y) {
            _this.mainCtx.translate(0, _this.scrollOffset.y - _this.cursor.view.point.y);
            _this.scrollOffset.y = _this.cursor.view.point.y;
            return _this.redraw();
          } else if (_this.cursor.view.point.y > (_this.scrollOffset.y + _this.main.height)) {
            _this.mainCtx.translate(0, (_this.scrollOffset.y + _this.main.height) - _this.cursor.view.point.y);
            _this.scrollOffset.y = _this.cursor.view.point.y - _this.main.height;
            return _this.redraw();
          }
        };
        moveCursorTo = function(token) {
          var head, _ref1;
          _this.cursor.remove();
          head = token;
          if (head !== _this.tree.start) {
            while (!((head == null) || ((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd' || _ref1 === 'segmentEnd'))) {
              head = head.next;
            }
          }
          if (head == null) {
            return;
          }
          if (head.type === 'newline' || head === _this.tree.start) {
            head.insert(_this.cursor);
          } else {
            head.insertBefore(_this.cursor);
          }
          _this.attemptReparse();
          return scrollCursorIntoView();
        };
        moveCursorBefore = function(token) {
          _this.cursor.remove();
          token.insertBefore(_this.cursor);
          _this.attemptReparse();
          return scrollCursorIntoView();
        };
        deleteFromCursor = function() {
          var head, nextVisibleElement, _ref1;
          head = _this.cursor.prev;
          while (head !== null && head.type !== 'indentStart' && head.type !== 'blockEnd') {
            head = head.prev;
          }
          if (head === null) {
            return;
          }
          if (head.type === 'blockEnd') {
            moveBlockTo(head.block, null);
            _this.redraw();
          }
          console.log(head.type);
          if (head.type === 'indentStart') {
            nextVisibleElement = head.next;
            while ((_ref1 = nextVisibleElement.type) === 'newline' || _ref1 === 'cursor' || _ref1 === 'segmentStart' || _ref1 === 'segmentEnd') {
              nextVisibleElement = nextVisibleElement.next;
            }
            console.log(nextVisibleElement);
            if (nextVisibleElement === head.indent.end) {
              moveCursorDown();
              head.prev.append(head.indent.end.next);
              _this.redraw();
            }
          }
          return scrollCursorIntoView();
        };
        moveCursorUp = function() {
          var depth, head, _ref1, _ref2;
          head = _this.cursor.prev.prev;
          while (head !== null && !(((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd') || head === _this.tree.start)) {
            head = head.prev;
          }
          if (head === null) {
            return;
          }
          if (head.type === 'indentEnd') {
            moveCursorBefore(head);
          } else {
            moveCursorTo(head);
          }
          head = _this.cursor;
          depth = 0;
          while (!((((_ref2 = head.type) === 'blockEnd' || _ref2 === 'indentEnd') || head === _this.tree.end) && depth === 0)) {
            switch (head.type) {
              case 'blockStart':
              case 'indentStart':
              case 'socketStart':
                depth += 1;
                break;
              case 'blockEnd':
              case 'indentEnd':
              case 'socketEnd':
                depth -= 1;
            }
            head = head.next;
          }
          if (head.type === 'blockEnd') {
            return moveCursorUp();
          }
        };
        moveCursorDown = function() {
          var depth, head, _ref1, _ref2;
          head = _this.cursor.next.next;
          while (head !== null && !(((_ref1 = head.type) === 'newline' || _ref1 === 'indentEnd') || head === _this.tree.end)) {
            head = head.next;
          }
          if (head === null) {
            return;
          }
          if (head.type === 'indentEnd' || head.type === 'segmentEnd') {
            moveCursorBefore(head);
          } else {
            moveCursorTo(head);
          }
          head = _this.cursor;
          depth = 0;
          while (!((((_ref2 = head.type) === 'blockEnd' || _ref2 === 'indentEnd') || head === _this.tree.end) && depth === 0)) {
            switch (head.type) {
              case 'blockStart':
              case 'indentStart':
              case 'socketStart':
                depth += 1;
                break;
              case 'blockEnd':
              case 'indentEnd':
              case 'socketEnd':
                depth -= 1;
            }
            head = head.next;
          }
          if (head.type === 'blockEnd') {
            return moveCursorDown();
          }
        };
        _ref1 = ['input', 'keydown', 'keyup', 'keypress'];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          eventName = _ref1[_j];
          this.hiddenInput.addEventListener(eventName, function(event) {
            if (!_this.isEditingText()) {
              return true;
            }
            return redrawTextInput();
          });
        }
        this.hiddenInput.addEventListener('keydown', function(event) {
          var head, newIndent, _ref2, _ref3, _ref4, _ref5;
          if (!_this.isEditingText()) {
            return true;
          }
          switch (event.keyCode) {
            case 13:
              if (_this.handwritten) {
                return insertHandwrittenBlock();
              } else {
                setTextInputFocus(null);
                _this.hiddenInput.blur();
                return _this.redraw();
              }
              break;
            case 8:
              if (_this.handwritten && _this.hiddenInput.value.length === 0) {
                deleteFromCursor();
                setTextInputFocus(null);
                return _this.hiddenInput.blur();
              }
              break;
            case 9:
              if (_this.handwritten) {
                head = _this.focus.start.prev.prev;
                while (head !== null && head.type !== 'blockEnd' && head.type !== 'blockStart') {
                  head = head.prev;
                }
                if (head.type === 'blockStart') {

                } else if (head.prev.type === 'indentEnd') {
                  moveBlockTo(_this.focus.start.prev.block, head.prev.prev.insert(new model.NewlineToken()));
                  moveCursorTo(_this.focus.start.prev.block.end);
                  _this.redraw();
                  event.preventDefault();
                  return false;
                } else {
                  newIndent = new model.Indent([], INDENT_SPACES);
                  head.prev.insert(newIndent.start);
                  head.prev.insert(newIndent.end);
                  moveBlockTo(_this.focus.start.prev.block, newIndent.start.insert(new model.NewlineToken()));
                  moveCursorTo(_this.focus.start.prev.block.end);
                  _this.redraw();
                  event.preventDefault();
                  return false;
                }
              }
              break;
            case 38:
              setTextInputFocus(null);
              _this.hiddenInput.blur();
              moveCursorUp();
              return _this.redraw();
            case 40:
              setTextInputFocus(null);
              _this.hiddenInput.blur();
              moveCursorDown();
              return _this.redraw();
            case 37:
              if (_this.hiddenInput.selectionStart === _this.hiddenInput.selectionEnd && _this.hiddenInput.selectionStart === 0) {
                head = _this.focus.start;
                while (!((head == null) || head.type === 'socketEnd' && !((_ref2 = (_ref3 = head.socket.content()) != null ? _ref3.type : void 0) === 'block' || _ref2 === 'socket'))) {
                  head = head.prev;
                }
                if (head == null) {
                  return;
                }
                return setTextInputFocus(head.socket);
              }
              break;
            case 39:
              if (_this.hiddenInput.selectionStart === _this.hiddenInput.selectionEnd && _this.hiddenInput.selectionStart === _this.hiddenInput.value.length) {
                head = _this.focus.end;
                while (!((head == null) || head.type === 'socketStart' && !((_ref4 = (_ref5 = head.socket.content()) != null ? _ref5.type : void 0) === 'block' || _ref4 === 'socket'))) {
                  head = head.next;
                }
                if (head == null) {
                  return;
                }
                return setTextInputFocus(head.socket);
              }
          }
        });
        this.hiddenInput.addEventListener('blur', function(event) {
          if (event.target !== document.activeElement) {
            return setTextInputFocus(null);
          }
        });
        document.body.addEventListener('keydown', function(event) {
          var head, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
          if ((_ref2 = event.target.tagName) === 'INPUT' || _ref2 === 'TEXTAREA') {
            return;
          }
          switch (event.keyCode) {
            case 13:
              if (!_this.isEditingText()) {
                insertHandwrittenBlock();
              }
              break;
            case 38:
              if (_this.cursor != null) {
                moveCursorUp();
              }
              break;
            case 40:
              if (_this.cursor != null) {
                moveCursorDown();
              }
              break;
            case 8:
              if (_this.cursor != null) {
                deleteFromCursor();
              }
              break;
            case 37:
              if (_this.cursor != null) {
                head = _this.cursor;
                while (!((head == null) || head.type === 'socketEnd' && !((_ref3 = (_ref4 = head.socket.content()) != null ? _ref4.type : void 0) === 'block' || _ref3 === 'socket'))) {
                  head = head.prev;
                }
                if (head == null) {
                  return;
                }
                setTextInputFocus(head.socket);
              }
              break;
            case 39:
              if (_this.cursor != null) {
                head = _this.cursor;
                while (!((head == null) || head.type === 'socketStart' && !((_ref5 = (_ref6 = head.socket.content()) != null ? _ref6.type : void 0) === 'block' || _ref5 === 'socket'))) {
                  head = head.next;
                }
                if (head == null) {
                  return;
                }
                setTextInputFocus(head.socket);
              }
          }
          if ((_ref7 = event.keyCode) === 13 || _ref7 === 38 || _ref7 === 40 || _ref7 === 8) {
            _this.redraw();
          }
          if ((_ref8 = event.keyCode) === 13 || _ref8 === 38 || _ref8 === 40 || _ref8 === 8 || _ref8 === 37) {
            return event.preventDefault();
          }
        });
        hitTest = function(point, root) {
          var head, seek;
          head = root;
          seek = null;
          while (head !== seek) {
            if (head.type === 'blockStart' && head.block.view.path.contains(point)) {
              seek = head.block.end;
            }
            head = head.next;
          }
          if (seek != null) {
            return seek.block;
          } else {
            return null;
          }
        };
        hitTestRoot = function(point) {
          return hitTest(point, _this.tree.start);
        };
        hitTestFloating = function(point) {
          var float, _k, _ref2;
          _ref2 = _this.floatingBlocks;
          for (_k = _ref2.length - 1; _k >= 0; _k += -1) {
            float = _ref2[_k];
            if (hitTest(point, float.block.start) !== null) {
              return float.block;
            }
          }
          return null;
        };
        hitTestFocus = function(point) {
          var head;
          head = _this.tree.start;
          while (head !== null) {
            if (head.type === 'socketStart' && (head.next.type === 'text' || head.next.type === 'socketEnd') && head.socket.view.bounds[head.socket.view.lineStart].contains(point)) {
              return head.socket;
            }
            head = head.next;
          }
          return null;
        };
        hitTestLasso = function(point) {
          if ((_this.lassoSegment != null) && _this._lassoBounds.contains(point)) {
            return _this.lassoSegment;
          } else {
            return null;
          }
        };
        hitTestPalette = function(point) {
          var block, _k, _len2, _ref2;
          point = new draw.Point(point.x + PALETTE_WIDTH, point.y - _this.scrollOffset.y);
          _ref2 = _this.paletteBlocks;
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            block = _ref2[_k];
            if (hitTest(point, block.start) != null) {
              return block;
            }
          }
          return null;
        };
        getPointFromEvent = function(event) {
          switch (false) {
            case event.offsetX == null:
              return new draw.Point(event.offsetX - PALETTE_WIDTH, event.offsetY + _this.scrollOffset.y);
            case !event.layerX:
              return new draw.Point(event.layerX - PALETTE_WIDTH, event.layerY + _this.scrollOffset.y);
          }
        };
        performNormalMouseDown = function(point, isTouchEvent) {
          var flag, float, _k, _len2, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
          _this.ephemeralSelection = (_ref2 = (_ref3 = (_ref4 = (_ref5 = hitTestFloating(point)) != null ? _ref5 : hitTestLasso(point)) != null ? _ref4 : hitTestFocus(point)) != null ? _ref3 : hitTestRoot(point)) != null ? _ref2 : hitTestPalette(point);
          if (_this.ephemeralSelection == null) {
            if (isTouchEvent) {
              return _this.touchScrollAnchor = point;
            } else {
              if (_this.lassoSegment != null) {
                flag = false;
                _ref6 = _this.floatingBlocks;
                for (_k = 0, _len2 = _ref6.length; _k < _len2; _k++) {
                  float = _ref6[_k];
                  if (float.block === _this.lassoSegment) {
                    flag = true;
                    break;
                  }
                }
                if (!flag) {
                  _this.lassoSegment.remove();
                }
                _this.lassoSegment = null;
                _this.redraw();
              }
              return _this.lassoAnchor = point;
            }
          } else if (_this.ephemeralSelection.type === 'socket') {
            setTextInputFocus(_this.ephemeralSelection);
            _this.ephemeralSelection = null;
            return setTimeout((function() {
              setTextInputAnchor(point);
              redrawTextInput();
              return textInputSelecting = true;
            }), 0);
          } else {
            if (_ref7 = _this.ephemeralSelection, __indexOf.call(_this.paletteBlocks, _ref7) >= 0) {
              _this.ephemeralPoint = new draw.Point(point.x - _this.scrollOffset.x, point.y - _this.scrollOffset.y);
            } else {
              _this.ephemeralPoint = new draw.Point(point.x, point.y);
            }
            return moveCursorTo(_this.ephemeralSelection.end);
          }
        };
        track.addEventListener('mousedown', function(event) {
          if (event.button !== 0) {
            return;
          }
          _this.hiddenInput.blur();
          return performNormalMouseDown(getPointFromEvent(event), false);
        });
        track.addEventListener('touchstart', function(event) {
          event.preventDefault();
          _this.hiddenInput.blur();
          event.changedTouches[0].offsetX = event.changedTouches[0].clientX - findPosLeft(track);
          event.changedTouches[0].offsetY = event.changedTouches[0].clientY - findPosTop(track);
          console.log(event.changedTouches[0].clientX, findPosLeft(track));
          console.log(event.changedTouches[0].clientY, findPosTop(track));
          return performNormalMouseDown(getPointFromEvent(event.changedTouches[0]), true);
        });
        performNormalMouseMove = function(event) {
          var dest, fixedDest, float, head, i, next_head, old_highlight, point, rect, selectionInPalette, _k, _len2, _ref2, _ref3;
          if (_this.ephemeralSelection != null) {
            point = getPointFromEvent(event);
            if (point.from(_this.ephemeralPoint).magnitude() > MIN_DRAG_DISTANCE) {
              _this.selection = _this.ephemeralSelection;
              _this.ephemeralSelection = null;
              head = _this.selection.start;
              while (head !== _this.selection.end) {
                next_head = head.next;
                if (head.type === 'cursor') {
                  head.remove();
                }
                head = next_head;
              }
              if (_ref2 = _this.selection, __indexOf.call(_this.paletteBlocks, _ref2) >= 0) {
                _this.ephemeralPoint.add(PALETTE_WIDTH, 0);
                selectionInPalette = true;
              }
              rect = _this.selection.view.bounds[_this.selection.view.lineStart];
              offset = _this.ephemeralPoint.from(new draw.Point(rect.x, rect.y));
              if (selectionInPalette) {
                _this.selection = _this.selection.clone();
              }
              moveBlockTo(_this.selection, null);
              _ref3 = _this.floatingBlocks;
              for (i = _k = 0, _len2 = _ref3.length; _k < _len2; i = ++_k) {
                float = _ref3[i];
                if (float.block === _this.selection) {
                  _this.floatingBlocks.splice(i, 1);
                  break;
                }
              }
              _this.selection.view.compute();
              _this.selection.view.draw(_this.dragCtx);
              if (selectionInPalette) {
                fixedDest = new draw.Point(rect.x - PALETTE_WIDTH, rect.y);
              } else {
                fixedDest = new draw.Point(rect.x - _this.scrollOffset.x, rect.y - _this.scrollOffset.y);
              }
              drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
              _this.redraw();
            }
          }
          if (_this.selection != null) {
            point = getPointFromEvent(event);
            point.add(-_this.scrollOffset.x, -_this.scrollOffset.y);
            fixedDest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
            point.translate(_this.scrollOffset);
            dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
            old_highlight = highlight;
            highlight = _this.tree.find(function(block) {
              var _ref4;
              return (!((_ref4 = typeof block.inSocket === "function" ? block.inSocket() : void 0) != null ? _ref4 : false)) && (block.view.dropArea != null) && block.view.dropArea.contains(dest);
            });
            if (old_highlight !== highlight) {
              _this.redraw();
            }
            if (highlight != null) {
              highlight.view.dropHighlightReigon.fill(_this.mainCtx, '#fff');
            }
            return drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(" + fixedDest.x + "px, " + fixedDest.y + "px)";
          } else if (_this.touchScrollAnchor != null) {
            point = new draw.Point(event.offsetX, event.offsetY);
            _this.scrollOffset.y = Math.max(0, _this.touchScrollAnchor.from(point).y);
            _this.mainCtx.setTransform(1, 0, 0, 1, 0, -_this.scrollOffset.y);
            return _this.redraw();
          }
        };
        track.addEventListener('mousemove', function(event) {
          return performNormalMouseMove(event);
        });
        track.addEventListener('touchmove', function(event) {
          event.preventDefault();
          if (!(event.changedTouches.length > 0)) {
            return;
          }
          event.changedTouches[0].offsetX = event.changedTouches[0].clientX - findPosLeft(track);
          event.changedTouches[0].offsetY = event.changedTouches[0].clientY - findPosTop(track);
          return performNormalMouseMove(event.changedTouches[0]);
        });
        performNormalMouseUp = function(event) {
          var dest, head, point;
          if (_this.ephemeralSelection != null) {
            _this.ephemeralSelection = null;
            _this.ephemeralPoint = null;
          }
          if (_this.selection != null) {
            point = getPointFromEvent(event);
            dest = new draw.Point(-offset.x + point.x, -offset.y + point.y);
            if (highlight != null) {
              switch (highlight.type) {
                case 'indent':
                  head = highlight.end.prev;
                  while (head.type === 'segmentEnd' || head.type === 'segmentStart' || head.type === 'cursor') {
                    head = head.prev;
                  }
                  if (head.type === 'newline') {
                    moveBlockTo(_this.selection, highlight.start.next);
                  } else {
                    moveBlockTo(_this.selection, highlight.start.insert(new model.NewlineToken()));
                  }
                  break;
                case 'block':
                  moveBlockTo(_this.selection, highlight.end.insert(new model.NewlineToken()));
                  break;
                case 'socket':
                  if (highlight.content() != null) {
                    highlight.content().remove();
                  }
                  moveBlockTo(_this.selection, highlight.start);
                  break;
                default:
                  if (highlight === _this.tree) {
                    moveBlockTo(_this.selection, _this.tree.start);
                    if (_this.selection.end.next !== _this.tree.end) {
                      _this.selection.end.insert(new model.NewlineToken());
                    }
                  }
              }
              if (_this.selection === _this.lassoSegment && _this.lassoSegment.start.next.type === 'blockStart') {
                _this.lassoSegment.start.next.block.checkParenWrap();
              }
            } else {
              if (dest.x > 0) {
                _this.floatingBlocks.push({
                  position: dest,
                  block: _this.selection
                });
              } else if (_this.selection === _this.lassoSegment) {
                _this.lassoSegment = null;
              }
            }
            drag.style.webkitTransform = drag.style.mozTransform = drag.style.transform = "translate(0px, 0px)";
            _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
            if (highlight != null) {
              moveCursorTo(_this.selection.end);
            }
            _this.selection = null;
            return _this.redraw();
          }
        };
        track.addEventListener('mouseup', function(event) {
          return performNormalMouseUp(event);
        });
        track.addEventListener('touchend', function(event) {
          event.preventDefault();
          _this.touchScrollAnchor = null;
          event.changedTouches[0].offsetX = event.changedTouches[0].clientX - findPosLeft(track);
          event.changedTouches[0].offsetY = event.changedTouches[0].clientY - findPosTop(track);
          return performNormalMouseUp(event.changedTouches[0]);
        });
        getRectFromPoints = function(a, b) {
          return new draw.Rectangle(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(a.x - b.x), Math.abs(a.y - b.y));
        };
        track.addEventListener('mousemove', function(event) {
          var point, rect;
          if (_this.lassoAnchor != null) {
            point = getPointFromEvent(event);
            point.add(-_this.scrollOffset.x, -_this.scrollOffset.y);
            rect = getRectFromPoints(new draw.Point(_this.lassoAnchor.x - _this.scrollOffset.x, _this.lassoAnchor.y - _this.scrollOffset.y), point);
            _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
            _this.dragCtx.strokeStyle = '#00f';
            return _this.dragCtx.strokeRect(rect.x, rect.y, rect.width, rect.height);
          }
        });
        track.addEventListener('mouseup', function(event) {
          var depth, firstLassoed, head, lastLassoed, point, rect, tokensToInclude;
          if (_this.lassoAnchor != null) {
            point = getPointFromEvent(event);
            rect = getRectFromPoints(_this.lassoAnchor, point);
            head = _this.tree.start;
            firstLassoed = null;
            while (head !== _this.tree.end) {
              if (head.type === 'blockStart' && head.block.view.path.intersects(rect)) {
                firstLassoed = head;
                break;
              }
              head = head.next;
            }
            head = _this.tree.end;
            lastLassoed = null;
            while (head !== _this.tree.start) {
              if (head.type === 'blockEnd' && head.block.view.path.intersects(rect)) {
                lastLassoed = head;
                break;
              }
              head = head.prev;
            }
            if ((firstLassoed != null) && (lastLassoed != null)) {
              tokensToInclude = [];
              head = firstLassoed;
              while (head !== lastLassoed) {
                switch (head.type) {
                  case 'blockStart':
                  case 'blockEnd':
                    tokensToInclude.push(head.block.start);
                    tokensToInclude.push(head.block.end);
                    break;
                  case 'indentStart':
                  case 'indentEnd':
                    tokensToInclude.push(head.indent.start);
                    tokensToInclude.push(head.indent.end);
                    break;
                  case 'segmentStart':
                  case 'segmentEnd':
                    tokensToInclude.push(head.segment.start);
                    tokensToInclude.push(head.segment.end);
                }
                head = head.next;
              }
              head = _this.tree.start;
              while (head !== _this.tree.end) {
                if (__indexOf.call(tokensToInclude, head) >= 0) {
                  firstLassoed = head;
                  break;
                }
                head = head.next;
              }
              head = _this.tree.end;
              lastLassoed = null;
              while (head !== _this.tree.start) {
                if (__indexOf.call(tokensToInclude, head) >= 0) {
                  lastLassoed = head;
                  break;
                }
                head = head.prev;
              }
              if (firstLassoed.type === 'indentStart') {
                depth = 0;
                while (depth > 0 || head.type !== 'blockStart') {
                  if (firstLassoed.type === 'blockStart') {
                    depth -= 1;
                  } else if (firstLassoed.type === 'blockEnd') {
                    depth += 1;
                  }
                  firstLassoed = firstLassoed.prev;
                }
                lastLassoed = firstLassoed.block.end;
              }
              if (firstLassoed.type === 'indentStart') {
                depth = 0;
                while (depth > 0 || head.type !== 'blockEnd') {
                  if (lastLassoed.type === 'blockEnd') {
                    depth -= 1;
                  } else if (lastLassoed.type === 'blockStart') {
                    depth += 1;
                  }
                }
                firstLassoed = lastLassoed.block.start;
              }
              _this.lassoSegment = new model.Segment([]);
              firstLassoed.insertBefore(_this.lassoSegment.start);
              lastLassoed.insert(_this.lassoSegment.end);
              _this.redraw();
            }
            _this.dragCtx.clearRect(0, 0, drag.width, drag.height);
            if (_this.lassoSegment != null) {
              moveCursorTo(_this.lassoSegment.end);
            }
            _this.lassoAnchor = null;
            return _this.redraw();
          }
        });
        redrawTextInput = function() {
          var end, start;
          _this.editedText.value = _this.hiddenInput.value;
          _this.redraw();
          start = _this.editedText.view.bounds[_editedInputLine].x + _this.mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionStart)).width;
          end = _this.editedText.view.bounds[_editedInputLine].x + _this.mainCtx.measureText(_this.hiddenInput.value.slice(0, _this.hiddenInput.selectionEnd)).width;
          if (start === end) {
            return _this.mainCtx.strokeRect(start, _this.editedText.view.bounds[_editedInputLine].y, 0, INPUT_LINE_HEIGHT);
          } else {
            _this.mainCtx.fillStyle = 'rgba(0, 0, 256, 0.3';
            return _this.mainCtx.fillRect(start, _this.editedText.view.bounds[_editedInputLine].y, end - start, INPUT_LINE_HEIGHT);
          }
        };
        setTextInputFocus = function(focus) {
          var depth, head, newParse, _ref2, _ref3;
          if (_this.focus != null) {
            try {
              newParse = coffee.parse(_this.focus.toString()).next;
              if (newParse.type === 'blockStart') {
                if (_this.focus.handwritten) {
                  newParse.block.moveTo(_this.focus.start.prev.block.start.prev);
                  _this.focus.start.prev.block.moveTo(null);
                } else {
                  if (((_ref2 = _this.focus.content()) != null ? _ref2.type : void 0) === 'text') {
                    _this.focus.content().remove();
                  } else if (((_ref3 = _this.focus.content()) != null ? _ref3.type : void 0) === 'block') {
                    _this.focus.content().moveTo(null);
                  }
                  newParse.block.moveTo(_this.focus.start);
                }
              }
            } catch (_error) {}
            if (_this.onChange != null) {
              _this.onChange(new IceEditorChangeEvent(_this.focus, focus));
            }
            if (_this.ephemeralOldFocusValue !== _this.focus.toString()) {
              _this.undoStack.push({
                type: 'socketTextChange',
                socket: _this.focus,
                value: _this.ephemeralOldFocusValue
              });
            }
          }
          _this.focus = focus;
          if (_this.focus != null) {
            _this.ephemeralOldFocusValue = _this.focus.toString();
          } else {
            _this.ephemeralOldFocusValue = null;
          }
          if (_this.focus === null) {
            return;
          }
          _editedInputLine = _this.focus.view.lineStart;
          _this.handwritten = _this.focus.handwritten;
          if (!_this.focus.content()) {
            _this.editedText = new model.TextToken('');
            _this.focus.start.insert(_this.editedText);
          } else if (_this.focus.content().type === 'text') {
            _this.editedText = _this.focus.content();
          } else {
            throw 'Cannot edit occupied socket.';
          }
          head = _this.focus.end;
          depth = 0;
          while (head.type !== 'newline' && head.type !== 'indentEnd' && head.type !== 'segmentEnd') {
            head = head.next;
          }
          if (head.type === 'newline') {
            moveCursorTo(head);
          } else {
            moveCursorBefore(head);
          }
          _this.hiddenInput.value = _this.editedText.value;
          return setTimeout((function() {
            return _this.hiddenInput.focus();
          }), 0);
        };
        setTextInputHead = function(point) {
          textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x) / _this.mainCtx.measureText(' ').width);
          return _this.hiddenInput.setSelectionRange(Math.min(textInputAnchor, textInputHead), Math.max(textInputAnchor, textInputHead));
        };
        setTextInputAnchor = function(point) {
          textInputAnchor = textInputHead = Math.round((point.x - _this.focus.view.bounds[_editedInputLine].x - PADDING) / _this.mainCtx.measureText(' ').width);
          return _this.hiddenInput.setSelectionRange(textInputAnchor, textInputHead);
        };
        track.addEventListener('mousemove', function(event) {
          var point;
          if (_this.isEditingText() && textInputSelecting) {
            point = getPointFromEvent(event);
            setTextInputHead(point);
            return redrawTextInput();
          }
        });
        track.addEventListener('mouseup', function(event) {
          if (_this.isEditingText()) {
            return textInputSelecting = false;
          }
        });
        track.addEventListener('mousewheel', function(event) {
          _this.clear();
          if (event.wheelDelta > 0) {
            if (_this.scrollOffset.y >= SCROLL_INTERVAL) {
              _this.scrollOffset.add(0, -SCROLL_INTERVAL);
              _this.mainCtx.translate(0, SCROLL_INTERVAL);
            } else {
              _this.mainCtx.translate(0, _this.scrollOffset.y);
              _this.scrollOffset.y = 0;
            }
          } else {
            _this.scrollOffset.add(0, SCROLL_INTERVAL);
            _this.mainCtx.translate(0, -SCROLL_INTERVAL);
          }
          return _this.redraw();
        });
      }

      Editor.prototype.setValue = function(value) {
        this.tree = coffee.parse(value).segment;
        return this.redraw();
      };

      Editor.prototype.getValue = function() {
        return this.tree.toString();
      };

      Editor.prototype.performMeltAnimation = function() {
        var acePollingInterval,
          _this = this;
        if (this.currentlyAnimating) {
          return;
        } else {
          this.currentlyAnimating = true;
        }
        this.redraw();
        this.ace.setValue(this.getValue());
        this.aceEl.style.top = -9999;
        this.aceEl.style.left = -9999;
        this.aceEl.style.display = 'block';
        return acePollingInterval = setInterval((function() {
          var animatedColor, count, head, state, textElements, tick, translationVectors;
          if (!(_this.ace.renderer.layerConfig.lineHeight > 0)) {
            return;
          }
          clearInterval(acePollingInterval);
          textElements = [];
          translationVectors = [];
          head = _this.tree.start;
          state = {
            x: _this.ace.container.getBoundingClientRect().left - findPosLeft(_this.aceEl) + _this.ace.renderer.$gutterLayer.gutterWidth,
            y: _this.ace.container.getBoundingClientRect().top - findPosTop(_this.aceEl),
            indent: 0,
            lineHeight: _this.ace.renderer.layerConfig.lineHeight,
            leftEdge: _this.ace.container.getBoundingClientRect().left - findPosLeft(_this.aceEl) + _this.ace.renderer.$gutterLayer.gutterWidth
          };
          console.log(_this.ace.container.getBoundingClientRect(), _this.aceEl.offsetLeft, _this.aceEl.offsetTop);
          console.log(_this.ace.renderer.layerConfig.offset, _this.ace.renderer.scrollLeft);
          while (head !== _this.tree.end) {
            if (head.type === 'text') {
              translationVectors.push(head.view.computePlaintextTranslationVector(state, _this.mainCtx));
              textElements.push(head);
            } else if (head.type === 'newline') {
              state.y += state.lineHeight;
              state.x = state.indent * _this.mainCtx.measureText(' ').width + state.leftEdge;
            } else if (head.type === 'indentStart') {
              state.indent += head.indent.depth;
            } else if (head.type === 'indentEnd') {
              state.indent -= head.indent.depth;
            }
            head = head.next;
          }
          count = 0;
          animatedColor = new AnimatedColor('#EEEEEE', '#FFFFFF', ANIMATION_FRAME_RATE);
          tick = function() {
            var element, i, _i, _len;
            count += 1;
            if (count < ANIMATION_FRAME_RATE) {
              setTimeout(tick, 1000 / ANIMATION_FRAME_RATE);
            }
            _this.main.style.left = PALETTE_WIDTH * (1 - count / ANIMATION_FRAME_RATE);
            _this.main.style.backgroundColor = animatedColor.advance();
            _this.palette.style.opacity = Math.max(0, 1 - 2 * (count / ANIMATION_FRAME_RATE));
            _this.clear();
            _this.mainCtx.globalAlpha = Math.max(0, 1 - 2 * count / ANIMATION_FRAME_RATE);
            _this.tree.view.draw(_this.mainCtx);
            _this.mainCtx.globalAlpha = 1;
            for (i = _i = 0, _len = textElements.length; _i < _len; i = ++_i) {
              element = textElements[i];
              element.view.textElement.draw(_this.mainCtx);
              element.view.translate(new draw.Point(translationVectors[i].x / ANIMATION_FRAME_RATE, translationVectors[i].y / ANIMATION_FRAME_RATE));
            }
            if (count >= ANIMATION_FRAME_RATE) {
              _this.ace.clearSelection();
              _this.el.style.display = 'none';
              _this.aceEl.style.top = 0;
              _this.aceEl.style.left = 0;
              _this.aceEl.style.display = 'block';
              return _this.currentlyAnimating = false;
            }
          };
          return tick();
        }), 1);
      };

      Editor.prototype.performFreezeAnimation = function() {
        var animatedColor, count, head, state, textElements, tick, translationVectors,
          _this = this;
        if (this.currentlyAnimating) {
          return;
        } else {
          this.currentlyAnimating = true;
        }
        this.setValue(this.ace.getValue());
        this.redraw();
        textElements = [];
        translationVectors = [];
        head = this.tree.start;
        state = {
          x: this.ace.container.getBoundingClientRect().left - findPosLeft(this.aceEl) + this.ace.renderer.$gutterLayer.gutterWidth,
          y: this.ace.container.getBoundingClientRect().top - findPosTop(this.aceEl),
          indent: 0,
          lineHeight: this.ace.renderer.layerConfig.lineHeight,
          leftEdge: this.ace.container.getBoundingClientRect().left - findPosLeft(this.aceEl) + this.ace.renderer.$gutterLayer.gutterWidth
        };
        while (head !== this.tree.end) {
          if (head.type === 'text') {
            translationVectors.push(head.view.computePlaintextTranslationVector(state, this.mainCtx));
            head.view.translate(translationVectors[translationVectors.length - 1]);
            textElements.push(head);
          } else if (head.type === 'newline') {
            state.y += state.lineHeight;
            state.x = state.indent * this.mainCtx.measureText(' ').width + state.leftEdge;
          } else if (head.type === 'indentStart') {
            state.indent += head.indent.depth;
          } else if (head.type === 'indentEnd') {
            state.indent -= head.indent.depth;
          }
          head = head.next;
        }
        this.aceEl.style.display = 'none';
        this.el.style.display = 'block';
        count = 0;
        animatedColor = new AnimatedColor('#FFFFFF', '#EEEEEE', ANIMATION_FRAME_RATE);
        tick = function() {
          var element, i, _i, _len;
          count += 1;
          if (count < ANIMATION_FRAME_RATE) {
            setTimeout(tick, 1000 / ANIMATION_FRAME_RATE);
          }
          _this.main.style.left = PALETTE_WIDTH * (count / ANIMATION_FRAME_RATE);
          _this.main.style.backgroundColor = animatedColor.advance();
          _this.palette.style.opacity = Math.max(0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE));
          _this.clear();
          _this.mainCtx.globalAlpha = Math.max(0, 1 - 2 * (1 - count / ANIMATION_FRAME_RATE));
          _this.tree.view.draw(_this.mainCtx);
          _this.mainCtx.globalAlpha = 1;
          for (i = _i = 0, _len = textElements.length; _i < _len; i = ++_i) {
            element = textElements[i];
            element.view.textElement.draw(_this.mainCtx);
            element.view.translate(new draw.Point(-translationVectors[i].x / ANIMATION_FRAME_RATE, -translationVectors[i].y / ANIMATION_FRAME_RATE));
          }
          if (count === ANIMATION_FRAME_RATE) {
            _this.redraw();
            return _this.currentlyAnimating = false;
          }
        };
        return tick();
      };

      return Editor;

    })();
    return exports;
  });

}).call(this);

/*
//@ sourceMappingURL=controller.js.map
*/