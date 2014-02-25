(function() {
  var colors, execute, exports, parse;

  colors = {
    COMMAND: '#268bd2',
    CONTROL: '#daa520',
    VALUE: '#26cf3c',
    RETURN: '#dc322f'
  };

  exports = {};

  exports.mark = function(nodes, text) {
    var addMarkup, getBounds, id, mark, markup, node, operatorPrecedences, rootSegment, _i, _len;
    id = 1;
    rootSegment = new ICE.Segment([]);
    text = text.split('\n');
    operatorPrecedences = {
      '||': 1,
      '&&': 2,
      '===': 3,
      '!==': 3,
      '>': 3,
      '<': 3,
      '>=': 3,
      '<=': 3,
      '+': 4,
      '-': 4,
      '*': 5,
      '/': 5,
      '%': 6
    };
    markup = [
      {
        token: rootSegment.start,
        position: [0, 0],
        id: 0,
        start: true
      }, {
        token: rootSegment.end,
        position: [text.length - 1, text[text.length - 1].length + 1],
        id: 0,
        start: false
      }
    ];
    addMarkup = function(block, node, shouldParenWrap) {
      var bounds;
      bounds = getBounds(node);
      if (shouldParenWrap) {
        bounds.start[1]--;
        bounds.end[1]++;
      }
      markup.push({
        token: block.start,
        position: bounds.start,
        id: id,
        start: true
      });
      markup.push({
        token: block.end,
        position: bounds.end,
        id: id,
        start: false
      });
      return id += 1;
    };
    getBounds = function(node) {
      var end, start;
      switch (node.constructor.name) {
        case 'Block':
          start = node.locationData;
          end = getBounds(node.expressions[node.expressions.length - 1]).end;
          return {
            start: [start.first_line - 1, text[start.first_line - 1].length],
            end: end
          };
        case 'If':
          if (node.elseBody != null) {
            end = getBounds(node.elseBody).end;
          } else {
            end = [node.locationData.last_line, node.locationData.last_column + 1];
          }
          if (text[end[0]].slice(0, end[1]).trimLeft().length === 0) {
            end[0] -= 1;
            end[1] = text[end[0]].length;
          }
          return {
            start: [node.locationData.first_line, node.locationData.first_column],
            end: end
          };
        default:
          end = [node.locationData.last_line, node.locationData.last_column + 1];
          if (text[end[0]].slice(0, end[1]).trimLeft().length === 0) {
            end[0] -= 1;
            end[1] = text[end[0]].length;
          }
          return {
            start: [node.locationData.first_line, node.locationData.first_column],
            end: end
          };
      }
    };
    mark = function(node, precedence, shouldParenWrap) {
      var arg, block, end, expr, indent, object, param, property, socket, start, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      if (precedence == null) {
        precedence = 0;
      }
      if (shouldParenWrap == null) {
        shouldParenWrap = false;
      }
      switch (node.constructor.name) {
        case 'Block':
          indent = new ICE.Indent([], 2);
          addMarkup(indent, node, shouldParenWrap);
          _ref = node.expressions;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            expr = _ref[_i];
            mark(expr);
          }
          break;
        case 'Op':
          block = new ICE.Block([], operatorPrecedences[node.operator]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          mark(node.first, (_ref1 = operatorPrecedences[node.operator]) != null ? _ref1 : 0);
          if (node.second != null) {
            mark(node.second, (_ref2 = operatorPrecedences[node.operator]) != null ? _ref2 : 0);
          }
          break;
        case 'Value':
          mark(node.base, precedence);
          break;
        case 'Literal':
          socket = new ICE.Socket(null, precedence);
          addMarkup(socket, node, shouldParenWrap);
          break;
        case 'Call':
          block = new ICE.Block([], 0);
          block.color = colors.COMMAND;
          addMarkup(block, node, shouldParenWrap);
          _ref3 = node.args;
          for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
            arg = _ref3[_j];
            mark(arg);
          }
          break;
        case 'Code':
          block = new ICE.Block([]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          _ref4 = node.params;
          for (_k = 0, _len2 = _ref4.length; _k < _len2; _k++) {
            param = _ref4[_k];
            mark(param);
          }
          mark(node.body.unwrap());
          break;
        case 'Param':
          mark(node.name);
          break;
        case 'Assign':
          block = new ICE.Block([]);
          block.color = colors.COMMAND;
          addMarkup(block, node, shouldParenWrap);
          mark(node.variable);
          mark(node.value);
          break;
        case 'For':
          block = new ICE.Block([]);
          block.color = colors.CONTROL;
          addMarkup(block, node, shouldParenWrap);
          if (node.index != null) {
            mark(node.index);
          }
          if (node.source != null) {
            mark(node.source);
          }
          if (node.name != null) {
            mark(node.name);
          }
          if (node.from != null) {
            mark(node.from);
          }
          mark(node.body);
          break;
        case 'Range':
          block = new ICE.Block([]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          mark(node.from);
          mark(node.to);
          break;
        case 'If':
          block = new ICE.Block([]);
          block.color = colors.CONTROL;
          addMarkup(block, node, shouldParenWrap);
          mark(node.condition);
          mark(node.body);
          if (node.elseBody != null) {
            mark(node.elseBody);
          }
          break;
        case 'Arr':
          block = new ICE.Block([]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          _ref5 = node.objects;
          for (_l = 0, _len3 = _ref5.length; _l < _len3; _l++) {
            object = _ref5[_l];
            mark(object);
          }
          break;
        case 'Return':
          block = new ICE.Block([]);
          block.color = colors.RETURN;
          addMarkup(block, node, shouldParenWrap);
          if (node.expression != null) {
            mark(node.expression);
          }
          break;
        case 'Parens':
          /*
          block = new ICE.Block []
          block.color = colors.VALUE
          addMarkup block, node, shouldParenWrap
          */

          console.log('encountered parens');
          if (node.body != null) {
            mark(node.body.unwrap(), 0, true);
          }
          break;
        case 'Obj':
          block = new ICE.Block([]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          start = getBounds(node.properties[0]);
          end = getBounds(node.properties[node.properties.length - 1]);
          indent = new ICE.Indent([]);
          markup.push({
            token: indent.start,
            position: start.start,
            id: id,
            start: true
          });
          markup.push({
            token: indent.end,
            position: end.end,
            id: id,
            start: false
          });
          id += 1;
          _ref6 = node.properties;
          for (_m = 0, _len4 = _ref6.length; _m < _len4; _m++) {
            property = _ref6[_m];
            mark(property);
          }
          break;
        case 'Existence':
          block = new ICE.Block([]);
          block.color = colors.VALUE;
          addMarkup(block, node, shouldParenWrap);
          block.precedence = 7;
          mark(node.expression, 7);
      }
      if ((block != null) && shouldParenWrap) {
        return block.currentlyParenWrapped = true;
      }
    };
    for (_i = 0, _len = nodes.length; _i < _len; _i++) {
      node = nodes[_i];
      mark(node);
    }
    return markup;
  };

  exports.execute = execute = function(text, markup) {
    var first, head, i, id, lastMark, line, marks, newBlock, newSocket, stack, str, _i, _j, _k, _len, _len1, _len2, _mark, _ref, _socket;
    id = 0;
    marks = {};
    for (_i = 0, _len = markup.length; _i < _len; _i++) {
      _mark = markup[_i];
      if (marks[_mark.position[0]] == null) {
        marks[_mark.position[0]] = [];
      }
      marks[_mark.position[0]].push(_mark);
    }
    text = text.split('\n');
    first = head = new ICE.TextToken('');
    stack = [];
    for (i = _j = 0, _len1 = text.length; _j < _len1; i = ++_j) {
      line = text[i];
      head = head.append(new ICE.NewlineToken());
      if (line.trimLeft().length === 0) {
        newBlock = new ICE.Block([]);
        newSocket = new ICE.Socket([]);
        newSocket.handwritten = true;
        newBlock.start.insert(newSocket.start);
        newBlock.end.insertBefore(newSocket.end);
        head.append(newBlock.start);
        head = newBlock.end;
        continue;
      }
      lastMark = 0;
      if (marks[i] != null) {
        marks[i].sort(function(a, b) {
          if (a.position[1] !== b.position[1]) {
            if (a.position[1] > b.position[1]) {
              return 1;
            } else {
              return -1;
            }
          } else if (a.start && b.start) {
            if (a.id > b.id) {
              return 1;
            } else {
              return -1;
            }
          } else if ((!a.start) && (!b.start)) {
            if (b.id > a.id) {
              return 1;
            } else {
              return -1;
            }
          } else {
            if (a.start && (!b.start)) {
              return 1;
            } else {
              return -1;
            }
          }
        });
        _ref = marks[i];
        for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
          _mark = _ref[_k];
          str = line.slice(lastMark, _mark.position[1]);
          if (lastMark === 0) {
            str = str.trimLeft();
          }
          if (str.length !== 0) {
            head = head.append(new ICE.TextToken(str));
          }
          if (stack.length > 0 && stack[stack.length - 1].block.type === 'block' && _mark.token.type === 'blockStart') {
            stack.push({
              block: (_socket = new ICE.Socket()),
              implied: true
            });
            head = head.append(_socket.start);
          }
          switch (_mark.token.type) {
            case 'blockStart':
              stack.push({
                block: _mark.token.block
              });
              break;
            case 'socketStart':
              stack.push({
                block: _mark.token.socket
              });
              break;
            case 'indentStart':
              stack.push({
                block: _mark.token.indent
              });
              break;
            case 'blockEnd':
            case 'socketEnd':
            case 'indentEnd':
              stack.pop();
          }
          head = head.append(_mark.token);
          if (stack.length > 0 && (stack[stack.length - 1].implied != null)) {
            head = head.append(stack.pop().block.end);
          }
          lastMark = _mark.position[1];
        }
      }
      if (!(lastMark > line.length - 1)) {
        head = head.append(new ICE.TextToken(line.slice(lastMark)));
      }
    }
    first = first.next.next;
    first.prev = null;
    return first;
  };

  exports.parse = parse = function(text) {
    var markup;
    markup = exports.mark(CoffeeScript.nodes(text).expressions, text);
    return execute(text, markup);
  };

  window.coffee = exports;

}).call(this);

/*
//@ sourceMappingURL=coffee.js.map
*/