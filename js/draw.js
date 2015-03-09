(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  define(['droplet-helper'], function(helper) {
    var Draw, _area, _intersects, avgColor, exports, max, memoizedAvgColor, min, toHex, toRGB, twoDigitHex, zeroPad;
    exports = {};
    _area = function(a, b, c) {
      return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
    };
    _intersects = function(a, b, c, d) {
      return ((_area(a, b, c) > 0) !== (_area(a, b, d) > 0)) && ((_area(c, d, a) > 0) !== (_area(c, d, b) > 0));
    };
    max = function(a, b) {
      return (a > b ? a : b);
    };
    min = function(a, b) {
      return (b > a ? a : b);
    };
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
    memoizedAvgColor = {};
    avgColor = function(a, factor, b) {
      var c, i, k, newRGB;
      c = a + ',' + factor + ',' + b;
      if (c in memoizedAvgColor) {
        return memoizedAvgColor[c];
      }
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
      return memoizedAvgColor[c] = toHex(newRGB);
    };
    exports.Draw = Draw = (function() {
      function Draw() {
        var NoRectangle, Path, Point, Rectangle, Size, Text, self;
        this.ctx = null;
        this.fontSize = 15;
        this.fontFamily = 'Courier New, monospace';
        this.fontAscent = 2;
        self = this;
        this.Point = Point = (function() {
          function Point(x1, y1) {
            this.x = x1;
            this.y = y1;
          }

          Point.prototype.clone = function() {
            return new Point(this.x, this.y);
          };

          Point.prototype.magnitude = function() {
            return Math.sqrt(this.x * this.x + this.y * this.y);
          };

          Point.prototype.translate = function(vector) {
            this.x += vector.x;
            return this.y += vector.y;
          };

          Point.prototype.add = function(x, y) {
            this.x += x;
            return this.y += y;
          };

          Point.prototype.plus = function(arg) {
            var x, y;
            x = arg.x, y = arg.y;
            return new Point(this.x + x, this.y + y);
          };

          Point.prototype.toMagnitude = function(mag) {
            var r;
            r = mag / this.magnitude();
            return new Point(this.x * r, this.y * r);
          };

          Point.prototype.copy = function(point) {
            this.x = point.x;
            return this.y = point.y;
          };

          Point.prototype.from = function(point) {
            return new Point(this.x - point.x, this.y - point.y);
          };

          Point.prototype.clear = function() {
            return this.x = this.y = 0;
          };

          Point.prototype.equals = function(point) {
            return point.x === this.x && point.y === this.y;
          };

          return Point;

        })();
        this.Size = Size = (function() {
          function Size(width, height) {
            this.width = width;
            this.height = height;
          }

          Size.prototype.equals = function(size) {
            return this.width === size.width && this.height === size.height;
          };

          Size.copy = function(size) {
            return new Size(size.width, size.height);
          };

          return Size;

        })();
        this.Rectangle = Rectangle = (function() {
          function Rectangle(x1, y1, width, height) {
            this.x = x1;
            this.y = y1;
            this.width = width;
            this.height = height;
          }

          Rectangle.prototype.contains = function(point) {
            return (this.x != null) && (this.y != null) && !((point.x < this.x) || (point.x > this.x + this.width) || (point.y < this.y) || (point.y > this.y + this.height));
          };

          Rectangle.prototype.identical = function(other) {
            return this.x === other.x && this.y === other.y && this.width === other.width && this.height === other.height;
          };

          Rectangle.prototype.copy = function(rect) {
            this.x = rect.x;
            this.y = rect.y;
            this.width = rect.width;
            return this.height = rect.height;
          };

          Rectangle.prototype.clip = function(ctx) {
            ctx.rect(this.x, this.y, this.width, this.height);
            return ctx.clip();
          };

          Rectangle.prototype.clone = function() {
            var rect;
            rect = new Rectangle(0, 0, 0, 0);
            rect.copy(this);
            return rect;
          };

          Rectangle.prototype.clear = function() {
            this.width = this.height = 0;
            return this.x = this.y = null;
          };

          Rectangle.prototype.bottom = function() {
            return this.y + this.height;
          };

          Rectangle.prototype.right = function() {
            return this.x + this.width;
          };

          Rectangle.prototype.fill = function(ctx, style) {
            ctx.fillStyle = style;
            return ctx.fillRect(this.x, this.y, this.width, this.height);
          };

          Rectangle.prototype.unite = function(rectangle) {
            if (!((this.x != null) && (this.y != null))) {
              return this.copy(rectangle);
            } else if (!((rectangle.x != null) && (rectangle.y != null))) {

            } else {
              this.width = max(this.right(), rectangle.right()) - (this.x = min(this.x, rectangle.x));
              return this.height = max(this.bottom(), rectangle.bottom()) - (this.y = min(this.y, rectangle.y));
            }
          };

          Rectangle.prototype.swallow = function(point) {
            if (!((this.x != null) && (this.y != null))) {
              return this.copy(new Rectangle(point.x, point.y, 0, 0));
            } else {
              this.width = max(this.right(), point.x) - (this.x = min(this.x, point.x));
              return this.height = max(this.bottom(), point.y) - (this.y = min(this.y, point.y));
            }
          };

          Rectangle.prototype.overlap = function(rectangle) {
            return (this.x != null) && (this.y != null) && !((rectangle.right()) < this.x || (rectangle.bottom() < this.y) || (rectangle.x > this.right()) || (rectangle.y > this.bottom()));
          };

          Rectangle.prototype.translate = function(vector) {
            this.x += vector.x;
            return this.y += vector.y;
          };

          Rectangle.prototype.stroke = function(ctx, style) {
            ctx.strokeStyle = style;
            return ctx.strokeRect(this.x, this.y, this.width, this.height);
          };

          Rectangle.prototype.fill = function(ctx, style) {
            ctx.fillStyle = style;
            return ctx.fillRect(this.x, this.y, this.width, this.height);
          };

          Rectangle.prototype.upperLeftCorner = function() {
            return new Point(this.x, this.y);
          };

          Rectangle.prototype.toPath = function() {
            var j, len1, path, point, ref;
            path = new Path();
            ref = [[this.x, this.y], [this.x, this.bottom()], [this.right(), this.bottom()], [this.right(), this.y]];
            for (j = 0, len1 = ref.length; j < len1; j++) {
              point = ref[j];
              path.push(new Point(point[0], point[1]));
            }
            return path;
          };

          return Rectangle;

        })();
        this.NoRectangle = NoRectangle = (function(superClass) {
          extend(NoRectangle, superClass);

          function NoRectangle() {
            NoRectangle.__super__.constructor.call(this, null, null, 0, 0);
          }

          return NoRectangle;

        })(Rectangle);
        this.Path = Path = (function() {
          function Path() {
            this._points = [];
            this._cachedTranslation = new Point(0, 0);
            this._cacheFlag = false;
            this._bounds = new NoRectangle();
            this.style = {
              'strokeColor': '#000',
              'lineWidth': 1,
              'fillColor': null
            };
          }

          Path.prototype._clearCache = function() {
            var j, len1, maxX, maxY, minX, minY, point, ref;
            if (this._cacheFlag) {
              minX = minY = Infinity;
              maxX = maxY = 0;
              ref = this._points;
              for (j = 0, len1 = ref.length; j < len1; j++) {
                point = ref[j];
                minX = min(minX, point.x);
                maxX = max(maxX, point.x);
                minY = min(minY, point.y);
                maxY = max(maxY, point.y);
              }
              this._bounds.x = minX;
              this._bounds.y = minY;
              this._bounds.width = maxX - minX;
              this._bounds.height = maxY - minY;
              return this._cacheFlag = false;
            }
          };

          Path.prototype.push = function(point) {
            this._points.push(point);
            return this._cacheFlag = true;
          };

          Path.prototype.unshift = function(point) {
            this._points.unshift(point);
            return this._cacheFlag = true;
          };

          Path.prototype.contains = function(point) {
            var count, dest, end, j, last, len1, ref;
            this._clearCache();
            if (this._points.length === 0) {
              return false;
            }
            if (!this._bounds.contains(point)) {
              return false;
            }
            dest = new Point(this._bounds.x - 10, point.y);
            count = 0;
            last = this._points[this._points.length - 1];
            ref = this._points;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              end = ref[j];
              if (_intersects(last, end, point, dest)) {
                count += 1;
              }
              last = end;
            }
            return count % 2 === 1;
          };

          Path.prototype.intersects = function(rectangle) {
            var end, j, l, last, lastSide, len1, len2, rectSides, ref, side;
            this._clearCache();
            if (this._points.length === 0) {
              return false;
            }
            if (!rectangle.overlap(this._bounds)) {
              return false;
            } else {
              last = this._points[this._points.length - 1];
              rectSides = [new Point(rectangle.x, rectangle.y), new Point(rectangle.right(), rectangle.y), new Point(rectangle.right(), rectangle.bottom()), new Point(rectangle.x, rectangle.bottom())];
              ref = this._points;
              for (j = 0, len1 = ref.length; j < len1; j++) {
                end = ref[j];
                lastSide = rectSides[rectSides.length - 1];
                for (l = 0, len2 = rectSides.length; l < len2; l++) {
                  side = rectSides[l];
                  if (_intersects(last, end, lastSide, side)) {
                    return true;
                  }
                  lastSide = side;
                }
                last = end;
              }
              if (this.contains(rectSides[0])) {
                return true;
              }
              if (rectangle.contains(this._points[0])) {
                return true;
              }
              return false;
            }
          };

          Path.prototype.bounds = function() {
            this._clearCache();
            return this._bounds;
          };

          Path.prototype.translate = function(vector) {
            this._cachedTranslation.translate(vector);
            return this._cacheFlag = true;
          };

          Path.prototype.draw = function(ctx) {
            var i, j, l, len1, len2, len3, m, point, ref, ref1, ref2;
            this._clearCache();
            if (this._points.length === 0) {
              return;
            }
            ctx.strokeStyle = this.style.strokeColor;
            ctx.lineWidth = this.style.lineWidth;
            if (this.style.fillColor != null) {
              ctx.fillStyle = this.style.fillColor;
            }
            ctx.beginPath();
            ctx.moveTo(this._points[0].x, this._points[0].y);
            ref = this._points;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              point = ref[j];
              ctx.lineTo(point.x, point.y);
            }
            ctx.lineTo(this._points[0].x, this._points[0].y);
            if (this._points.length > 1) {
              ctx.lineTo(this._points[1].x, this._points[1].y);
            }
            if (this.style.fillColor != null) {
              ctx.fill();
            }
            ctx.save();
            if (!this.noclip) {
              ctx.clip();
            }
            if (this.bevel) {
              ctx.beginPath();
              ctx.moveTo(this._points[0].x, this._points[0].y);
              ref1 = this._points.slice(1);
              for (i = l = 0, len2 = ref1.length; l < len2; i = ++l) {
                point = ref1[i];
                if ((point.x < this._points[i].x && point.y >= this._points[i].y) || (point.y > this._points[i].y && point.x <= this._points[i].x)) {
                  ctx.lineTo(point.x, point.y);
                } else if (!point.equals(this._points[i])) {
                  ctx.moveTo(point.x, point.y);
                }
              }
              if (!(this._points[0].x > this._points[this._points.length - 1].x || this._points[0].y < this._points[this._points.length - 1].y)) {
                ctx.lineTo(this._points[0].x, this._points[0].y);
              }
              ctx.lineWidth = 4;
              ctx.strokeStyle = avgColor(this.style.fillColor, 0.85, '#000');
              ctx.stroke();
              ctx.lineWidth = 2;
              ctx.strokeStyle = avgColor(this.style.fillColor, 0.7, '#000');
              ctx.stroke();
              ctx.beginPath();
              ctx.moveTo(this._points[0].x, this._points[0].y);
              ref2 = this._points.slice(1);
              for (i = m = 0, len3 = ref2.length; m < len3; i = ++m) {
                point = ref2[i];
                if ((point.x > this._points[i].x && point.y <= this._points[i].y) || (point.y < this._points[i].y && point.x >= this._points[i].x)) {
                  ctx.lineTo(point.x, point.y);
                } else if (!point.equals(this._points[i])) {
                  ctx.moveTo(point.x, point.y);
                }
              }
              if (this._points[0].x > this._points[this._points.length - 1].x || this._points[0].y < this._points[this._points.length - 1].y) {
                ctx.lineTo(this._points[0].x, this._points[0].y);
              }
              ctx.lineWidth = 4;
              ctx.strokeStyle = avgColor(this.style.fillColor, 0.85, '#FFF');
              ctx.stroke();
              ctx.lineWidth = 2;
              ctx.strokeStyle = avgColor(this.style.fillColor, 0.7, '#FFF');
              ctx.stroke();
            } else {
              ctx.stroke();
            }
            return ctx.restore();
          };

          Path.prototype.clone = function() {
            var clone, el, j, len1, ref;
            clone = new Path();
            ref = this._points;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              el = ref[j];
              clone.push(el);
            }
            return clone;
          };

          Path.prototype.drawShadow = function(ctx, offsetX, offsetY, blur) {
            var j, key, len1, oldValues, point, ref, results, value;
            this._clearCache();
            ctx.fillStyle = this.style.fillColor;
            if (this._points.length === 0) {
              return;
            }
            oldValues = {
              shadowColor: ctx.shadowColor,
              shadowBlur: ctx.shadowBlur,
              shadowOffsetY: ctx.shadowOffsetY,
              shadowOffsetX: ctx.shadowOffsetX,
              globalAlpha: ctx.globalAlpha
            };
            ctx.globalAlpha = 0.5;
            ctx.shadowColor = '#000';
            ctx.shadowBlur = blur;
            ctx.shadowOffsetX = offsetX;
            ctx.shadowOffsetY = offsetY;
            ctx.beginPath();
            ctx.moveTo(this._points[0].x, this._points[0].y);
            ref = this._points;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              point = ref[j];
              ctx.lineTo(point.x, point.y);
            }
            ctx.lineTo(this._points[0].x, this._points[0].y);
            ctx.fill();
            results = [];
            for (key in oldValues) {
              if (!hasProp.call(oldValues, key)) continue;
              value = oldValues[key];
              results.push(ctx[key] = value);
            }
            return results;
          };

          return Path;

        })();
        this.Text = Text = (function() {
          function Text(point1, value1) {
            this.point = point1;
            this.value = value1;
            this.wantedFont = self.fontSize + 'px ' + self.fontFamily;
            if (self.ctx.font !== this.wantedFont) {
              self.ctx.font = self.fontSize + 'px ' + self.fontFamily;
            }
            this._bounds = new Rectangle(this.point.x, this.point.y, self.ctx.measureText(this.value).width, self.fontSize);
          }

          Text.prototype.bounds = function() {
            return this._bounds;
          };

          Text.prototype.contains = function(point) {
            return this._bounds.contains(point);
          };

          Text.prototype.translate = function(vector) {
            this.point.translate(vector);
            return this._bounds.translate(vector);
          };

          Text.prototype.setPosition = function(point) {
            return this.translate(point.from(this.point));
          };

          Text.prototype.draw = function(ctx) {
            ctx.textBaseline = 'top';
            ctx.font = self.fontSize + 'px ' + self.fontFamily;
            ctx.fillStyle = '#000';
            return ctx.fillText(this.value, this.point.x, this.point.y - self.fontAscent);
          };

          return Text;

        })();
      }

      Draw.prototype.refreshFontCapital = function() {
        return this.fontAscent = helper.fontMetrics(this.fontFamily, this.fontSize).prettytop;
      };

      Draw.prototype.setCtx = function(ctx) {
        return this.ctx = ctx;
      };

      Draw.prototype.setGlobalFontSize = function(size) {
        this.fontSize = size;
        return this.refreshFontCapital();
      };

      Draw.prototype.setGlobalFontFamily = function(family) {
        this.fontFamily = family;
        return this.refreshFontCapital();
      };

      Draw.prototype.getGlobalFontSize = function() {
        return this.fontSize;
      };

      return Draw;

    })();
    return exports;
  });

}).call(this);

//# sourceMappingURL=draw.js.map
