(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(['droplet-helper', 'droplet-model', 'droplet-parser', 'acorn'], function(helper, model, parser, acorn) {
    var COLORS, STATEMENT_NODE_TYPES, csv;
    COLORS = {
      'SequenceExpression': 'command'
    };
    STATEMENT_NODE_TYPES = ['ExpressionStatement'];
    csv = (function(superClass) {
      extend(csv, superClass);

      function csv(text, opts) {
        this.text = text;
        this.opts = opts != null ? opts : {};
        csv.__super__.constructor.apply(this, arguments);
        this.lines = this.text.split('\n');
      }

      csv.prototype.markRoot = function() {
        var tree;
        tree = acorn.parse(this.text, {
          locations: true,
          line: 0,
          allowReturnOutsideFunction: true
        });
        return this.mark(0, tree, 0, null);
      };

      csv.prototype.getBounds = function(node) {
        return {
          start: {
            line: node.loc.start.line,
            column: node.loc.start.column
          },
          end: {
            line: node.loc.end.line,
            column: node.loc.end.column
          }
        };
      };

      csv.prototype.getColor = function(node) {
        return 'command';
      };

      csv.prototype.getSocketLevel = function(node) {
        return helper.ANY_DROP;
      };

      csv.prototype.getAcceptsRule = function(node) {
        return {
          "default": helper.NORMAL
        };
      };

      csv.prototype.getClasses = function(node) {
        if (node.type.match(/Expression$/) != null) {
          return [node.type, 'mostly-value'];
        } else if (node.type.match(/(Statement|Declaration)$/) != null) {
          return [node.type, 'mostly-block'];
        } else {
          return [node.type, 'any-drop'];
        }
      };

      csv.prototype.mark = function(indentDepth, node, depth, bounds) {
        var expression, i, j, len, len1, ref, ref1, results, results1, statement;
        console.log(node.type, node, bounds);
        switch (node.type) {
          case 'Program':
            ref = node.body;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              statement = ref[i];
              results.push(this.mark(indentDepth, statement, depth + 1, null));
            }
            return results;
            break;
          case 'ExpressionStatement':
            return this.mark(indentDepth, node.expression, depth + 1, this.getBounds(node));
          case 'SequenceExpression':
            this.csvBlock(node, depth, bounds);
            ref1 = node.expressions;
            results1 = [];
            for (j = 0, len1 = ref1.length; j < len1; j++) {
              expression = ref1[j];
              results1.push(this.csvSocketAndMark(indentDepth, expression, depth + 1, null));
            }
            return results1;
        }
      };

      csv.prototype.isComment = function(str) {
        return str.match(/^\s*#.*$/) != null;
      };

      csv.prototype.csvBlock = function(node, depth, bounds) {
        return this.addBlock({
          bounds: bounds != null ? bounds : this.getBounds(node),
          depth: depth,
          precedence: 0,
          color: this.getColor(node),
          classes: this.getClasses(node),
          socketLevel: this.getSocketLevel(node)
        });
      };

      csv.prototype.csvSocketAndMark = function(indentDepth, node, depth, precedence, bounds, classes) {
        if (node.type !== 'BlockStatement') {
          this.addSocket({
            bounds: bounds != null ? bounds : this.getBounds(node),
            depth: depth,
            precedence: 0,
            classes: classes != null ? classes : [],
            accepts: this.getAcceptsRule(node)
          });
        }
        return this.mark(indentDepth, node, depth + 1, bounds);
      };

      return csv;

    })(parser.Parser);
    return parser.wrapParser(csv);
  });

}).call(this);

//# sourceMappingURL=random_csv.js.map
