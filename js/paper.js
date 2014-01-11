(function() {
  var TextTokenPaper, drawLine, _iter;

  TextTokenPaper = (function() {
    function TextTokenPaper(block) {
      this.block = block;
      this.text = new paper.PointText({
        point: [0, 0],
        content: this.block.value,
        font: 'Courier New',
        fillColor: 'black'
      });
    }

    TextTokenPaper.prototype.draw = function(state) {
      this.text.bounds.point = state.point;
      return state.point.x += this.text.bounds.size.width;
    };

    return TextTokenPaper;

  })();

  _iter = function(start, end, f) {
    var _results;
    _results = [];
    while (start !== end) {
      f(start);
      _results.push(start = start.next);
    }
    return _results;
  };

  drawLine = function(start, end, state) {
    var padding;
    padding = state.padding;
    return _iter(start, end, function(block) {
      return block.paper.draw(state);
    });
  };

  window.ICE = _.extend(window.ICE, {
    TextTokenPaper: TextTokenPaper
  });

}).call(this);

/*
//@ sourceMappingURL=paper.js.map
*/