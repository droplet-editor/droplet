
/*
  Written by SAKSHAM AGGARWAL
  Do not copy. Think something new and innovative instead
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(['droplet-helper', 'droplet-parser', 'css'], function(helper, parser, css) {
    var COLORS, CSSParser, MOSTLY_VALUE, exports;
    exports = {};
    COLORS = {
      'Default': 'violet'
    };
    MOSTLY_VALUE = ['mostly-value'];
    exports.CSSParser = CSSParser = (function(superClass) {
      extend(CSSParser, superClass);

      function CSSParser(text1, opts) {
        this.text = text1;
        this.opts = opts != null ? opts : {};
        CSSParser.__super__.constructor.apply(this, arguments);
        this.lines = this.text.split('\n');
        this.text = this.text;
      }

      CSSParser.prototype.getAcceptsRule = function(node) {
        return {
          "default": helper.NORMAL
        };
      };

      CSSParser.prototype.getPrecedence = function(node) {
        return 1;
      };

      CSSParser.prototype.getClasses = function(node) {
        return MOSTLY_VALUE;
      };

      CSSParser.prototype.getColor = function(node) {
        return COLORS['Default'];
      };

      CSSParser.prototype.getBounds = function(node, end) {
        var bounds;
        return bounds = {
          start: {
            line: node.position.start.line - 1,
            column: node.position.start.column - 1
          },
          end: {
            line: node.position.end.line - 1,
            column: end != null ? end : node.position.end.column - 1
          }
        };
      };

      CSSParser.prototype.getSocketLevel = function(node) {
        return helper.ANY_DROP;
      };

      CSSParser.prototype.cssBlock = function(node, depth) {
        if (depth == null) {
          depth = 1;
        }
        return this.addBlock({
          bounds: this.getBounds(node),
          depth: depth,
          precedence: this.getPrecedence(node),
          color: this.getColor(node),
          socketLevel: this.getSocketLevel(node)
        });
      };

      CSSParser.prototype.cssSocket = function(node, end) {
        return this.addSocket({
          bounds: this.getBounds(node, end),
          depth: 1,
          precedence: this.getPrecedence(node),
          classes: this.getClasses(node),
          acccepts: this.getAcceptsRule(node)
        });
      };

      CSSParser.prototype.markRoot = function() {
        var root;
        root = css.parse(this.text);
        console.log(root);
        return this.mark(root);
      };

      CSSParser.prototype.mark = function(node) {
        var declaration, i, j, len, len1, ref, ref1, results, results1, rule;
        switch (node.type) {
          case 'stylesheet':
            ref = node.stylesheet.rules;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              rule = ref[i];
              results.push(this.mark(rule));
            }
            return results;
            break;
          case 'rule':
            this.cssBlock(node);
            ref1 = node.declarations;
            results1 = [];
            for (j = 0, len1 = ref1.length; j < len1; j++) {
              declaration = ref1[j];
              results1.push(this.mark(declaration));
            }
            return results1;
            break;
          case 'declaration':
            return this.cssSocket(node);
        }
      };

      CSSParser.prototype.isComment = function(text) {
        return text.match(/^\s*\/\/.*$/);
      };

      return CSSParser;

    })(parser.Parser);
    CSSParser.parens = function(leading, trainling, node, context) {
      return [leading, trainling];
    };
    return parser.wrapParser(CSSParser);
  });

}).call(this);

//# sourceMappingURL=css.js.map
