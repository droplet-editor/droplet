(function() {
  define(function() {
    var exports, fontMetrics, fontMetricsCache;
    exports = {};
    exports.ANY_DROP = 0;
    exports.BLOCK_ONLY = 1;
    exports.MOSTLY_BLOCK = 2;
    exports.MOSTLY_VALUE = 3;
    exports.VALUE_ONLY = 4;
    exports.ENCOURAGE = 1;
    exports.DISCOURAGE = 0;
    exports.FORBID = -1;
    if (typeof window !== "undefined" && window !== null) {
      window.String.prototype.trimLeft = function() {
        return this.replace(/^\s+/, '');
      };
      window.String.prototype.trimRight = function() {
        return this.replace(/\s+$/, '');
      };
    }
    exports.xmlPrettyPrint = function(str) {
      var result, xmlParser;
      result = '';
      xmlParser = sax.parser(true);
      xmlParser.ontext = function(text) {
        return result += exports.escapeXMLText(text);
      };
      xmlParser.onopentag = function(node) {
        var attr, ref, val;
        result += '<' + node.name;
        ref = node.attributes;
        for (attr in ref) {
          val = ref[attr];
          result += '\n  ' + attr + '=' + JSON.stringify(val);
        }
        return result += '>';
      };
      xmlParser.onclosetag = function(name) {
        return result += '</' + name + '>';
      };
      xmlParser.write(str).close();
      return result;
    };
    fontMetricsCache = {};
    exports.fontMetrics = fontMetrics = function(fontFamily, fontHeight) {
      var baseline, canvas, capital, ctx, ex, fontStyle, gp, height, lf, metrics, result, textTopAndBottom, width;
      fontStyle = fontHeight + "px " + fontFamily;
      result = fontMetricsCache[fontStyle];
      textTopAndBottom = function(testText) {
        var col, first, i, index, j, last, pixels, ref, ref1, right, row;
        ctx.fillStyle = 'black';
        ctx.fillRect(0, 0, width, height);
        ctx.textBaseline = 'top';
        ctx.fillStyle = 'white';
        ctx.fillText(testText, 0, 0);
        right = Math.ceil(ctx.measureText(testText).width);
        pixels = ctx.getImageData(0, 0, width, height).data;
        first = -1;
        last = height;
        for (row = i = 0, ref = height; 0 <= ref ? i < ref : i > ref; row = 0 <= ref ? ++i : --i) {
          for (col = j = 1, ref1 = right; 1 <= ref1 ? j < ref1 : j > ref1; col = 1 <= ref1 ? ++j : --j) {
            index = (row * width + col) * 4;
            if (pixels[index] !== 0) {
              if (first < 0) {
                first = row;
              }
              break;
            }
          }
          if (first >= 0 && col >= right) {
            last = row;
            break;
          }
        }
        return {
          top: first,
          bottom: last
        };
      };
      if (!result) {
        canvas = document.createElement('canvas');
        ctx = canvas.getContext('2d');
        ctx.font = fontStyle;
        metrics = ctx.measureText('Hg');
        if (canvas.height < fontHeight * 2 || canvas.width < metrics.width) {
          canvas.width = Math.ceil(metrics.width);
          canvas.height = fontHeight * 2;
          ctx = canvas.getContext('2d');
          ctx.font = fontStyle;
        }
        width = canvas.width;
        height = canvas.height;
        capital = textTopAndBottom('H');
        ex = textTopAndBottom('x');
        lf = textTopAndBottom('lf');
        gp = textTopAndBottom('g');
        baseline = capital.bottom;
        result = {
          ascent: lf.top,
          capital: capital.top,
          ex: ex.top,
          baseline: capital.bottom,
          descent: gp.bottom
        };
        result.prettytop = Math.max(0, Math.min(result.ascent, result.ex - (result.descent - result.baseline)));
        fontMetricsCache[fontStyle] = result;
      }
      return result;
    };
    exports.getFontHeight = function(family, size) {
      var metrics;
      metrics = fontMetrics(family, size);
      return metrics.descent - metrics.prettytop;
    };
    exports.escapeXMLText = function(str) {
      return str.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
    };
    exports.serializeShallowDict = function(dict) {
      var key, props, val;
      props = [];
      for (key in dict) {
        val = dict[key];
        props.push(key + ':' + val);
      }
      return props.join(';');
    };
    exports.deserializeShallowDict = function(str) {
      var dict, i, key, len, prop, props, ref, val;
      if (str == null) {
        return void 0;
      }
      dict = {};
      props = str.split(';');
      for (i = 0, len = props.length; i < len; i++) {
        prop = props[i];
        ref = prop.split(':'), key = ref[0], val = ref[1];
        dict[key] = val;
      }
      return dict;
    };
    return exports;
  });

}).call(this);

//# sourceMappingURL=helper.js.map
