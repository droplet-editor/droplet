
/*
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['droplet-helper', 'droplet-parser', 'droplet-model'], function(helper, parser, model) {
    var CLASSES, COLORS, CSVParser, exports;
    exports = {};
    COLORS = {
      'Default': 'cyan'
    };
    CLASSES = ['mostly-value', 'no-drop'];
    exports.CSVParser = CSVParser = (function(superClass) {
      extend(CSVParser, superClass);

      function CSVParser(text1, opts) {
        this.text = text1;
        this.opts = opts != null ? opts : {};
        CSVParser.__super__.constructor.apply(this, arguments);
        this.lines = this.text.split('\n');
      }

      CSVParser.prototype.getAcceptsRule = function(node) {
        return {
          "default": helper.NORMAL
        };
      };

      CSVParser.prototype.getPrecedence = function(node) {
        return 1;
      };

      CSVParser.prototype.getClasses = function(node) {
        return CLASSES;
      };

      CSVParser.prototype.getColor = function(node) {
        return COLORS['Default'];
      };

      CSVParser.prototype.getBounds = function(node) {
        var bounds;
        return bounds = {
          start: {
            line: node.index,
            column: node.start
          },
          end: {
            line: node.index,
            column: node.end
          }
        };
      };

      CSVParser.prototype.getSocketLevel = function(node) {
        return helper.ANY_DROP;
      };

      CSVParser.prototype.csvBlock = function(node) {
        return this.addBlock({
          bounds: this.getBounds(node),
          depth: 0,
          precedence: this.getPrecedence(node),
          color: this.getColor(node),
          socketLevel: this.getSocketLevel(node)
        });
      };

      CSVParser.prototype.csvSocket = function(node) {
        return this.addSocket({
          bounds: this.getBounds(node),
          depth: 1,
          precedence: this.getPrecedence(node),
          classes: this.getClasses(node),
          acccepts: this.getAcceptsRule(node)
        });
      };

      CSVParser.prototype.markRoot = function() {
        var root;
        root = this.CSVtree(this.text);
        return this.mark(root);
      };

      CSVParser.prototype.mark = function(node) {
        var child, j, len, ref, results;
        if (node.type === 'Statement') {
          this.csvBlock(node);
        } else if (node.type === 'Value') {
          this.csvSocket(node);
        }
        ref = node.children;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          child = ref[j];
          results.push(this.mark(child));
        }
        return results;
      };

      CSVParser.prototype.CSVtree = function(text) {

        /*
          Structure of node:
          node->index = line number
          node->type = Tree/Statement/Value/Comment
          node->start = starting character
          node->end = ending character
          node->children = children
         */
        return this.getNode(text, 'Tree');
      };

      CSVParser.prototype.isComment = function(text) {
        return text.match(/^\s*\/\/.*$/);
      };

      CSVParser.prototype.getNode = function(text, type, index, start, end) {
        var i, inside_quotes, j, k, last, len, len1, node, row, substr, val;
        node = {};
        node.index = index;
        node.type = type;
        node.start = start;
        node.end = end;
        node.children = [];
        if (type === 'Tree') {
          text = text.split('\n');
          for (i = j = 0, len = text.length; j < len; i = ++j) {
            row = text[i];
            if ((row.length === 0) || (this.isComment(row))) {
              node.children.push(this.getNode(row, 'Comment', i, 0, row.length));
            } else {
              node.children.push(this.getNode(row, 'Statement', i, 0, row.length));
            }
          }
        } else if (type === 'Statement') {
          inside_quotes = false;
          last = 0;
          text = text.concat(',');
          for (i = k = 0, len1 = text.length; k < len1; i = ++k) {
            val = text[i];
            if (val === ',' && inside_quotes === false) {
              node.children.push(this.getNode(text.substring(last, i), 'Value', index, last, i));
              last = i + 1;
            } else if (val === '"' && inside_quotes === false) {
              inside_quotes = true;
            } else if (val === '"' && inside_quotes === true) {
              inside_quotes = false;
            }
          }
          if (inside_quotes === true) {
            throw new Error('Odd number of quotes');
          }
        } else if (type === 'Value') {
          substr = text.trim();
          node.start += text.indexOf(substr);
          node.end = node.start + substr.length;
        }
        return node;
      };

      return CSVParser;

    })(parser.Parser);
    CSVParser.parens = function(leading, trailing, node, context) {
      return [leading, trailing];
    };
    CSVParser.drop = function(block, context, preceding) {
      if ((context.type === 'socket') || (indexOf.call(context.classes, 'no-drop') >= 0)) {
        return helper.FORBID;
      } else {
        return helper.ENCOURAGE;
      }
    };
    CSVParser.normalString = function(str) {
      var has_quotes, needs_quotes, newstr, ref, tmp;
      has_quotes = (str[0] === str.slice(-1)) && ((ref = str[0]) === '"' || ref === '\'');
      if (has_quotes) {
        tmp = str.match(/\"+/g);
        has_quotes = Math.min(tmp[0].length, tmp.slice(-1)[0].length) % 2 === 1;
      }
      if (has_quotes && str.length > 1) {
        newstr = str.slice(1, -1);
      } else {
        newstr = str;
      }
      needs_quotes = (newstr[0] === ' ') || (newstr.slice(-1) === ' ') || (newstr.match(',') != null) || (newstr.match('"') != null);
      if (needs_quotes) {
        newstr = newstr.replace(/\"\"/g, '\"').replace(/\"/g, '\"\"');
        newstr = '"' + newstr + '"';
      }
      str = newstr;
      return str;

      /*
      
      if has_quotes is needs_quotes
        return str
      else if has_quotes and not needs_quotes
        if str.length > 1
          return str[1...-1]
        else
          return str
      else
        return '"' + str + '"'
       */

      /*
      console.log start, str, end
      tmp = str.replace(/([^\"]+)(\")([^\"]+)/g, '$1$2$2$3')
      while tmp isnt str
        str = tmp
        tmp = str.replace(/([^\"]+)(\")([^\"]+)/g, '$1$2$2$3')
      console.log start, str, end
      tmp = str.replace(/([^\']+)(\')([^\']+)/g, '$1$2$2$3')
      while tmp isnt str
        str = tmp
        tmp = str.replace(/([^\']+)(\')([^\']+)/g, '$1$2$2$3')
      console.log start, str, end
       */
    };
    return parser.wrapParser(CSVParser);
  });

}).call(this);

//# sourceMappingURL=csv.js.map
