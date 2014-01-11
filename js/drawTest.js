(function() {
  window.onload = function() {
    var canvas, center, ctx, down, group, path, paths, point, selections, velocities, x, _fn, _i, _j, _k, _ref;
    canvas = document.getElementById('test');
    ctx = canvas.getContext('2d');
    paths = [];
    velocities = [];
    group = new draw.Group();
    for (_i = 1; _i <= 1000; _i++) {
      path = new draw.Path();
      center = new draw.Point(Math.random() * 1000, Math.random() * 1000);
      for (_j = 1, _ref = Math.floor(Math.random() * 4) + 3; 1 <= _ref ? _j <= _ref : _j >= _ref; 1 <= _ref ? _j++ : _j--) {
        path.push(new draw.Point(center.x + Math.random() * 100, center.y + Math.random() * 100));
      }
      path.style.fillColor = '#fff';
      paths.push(path);
      if (Math.random() < 0.01) {
        path.style.fillColor = '#000';
        group.push(path);
      }
    }
    _fn = function() {
      var i, tick;
      i = x;
      tick = (function() {
        return setTimeout((function() {
          velocities[i - 1] = new draw.Point(Math.random() * 2 - 1, Math.random() * 2 - 1);
          return tick();
        }), Math.random() * 10000);
      });
      return tick();
    };
    for (x = _k = 1; _k <= 1000; x = ++_k) {
      velocities.push(new draw.Point(Math.random() * 2 - 1, Math.random() * 2 - 1));
      _fn();
    }
    ctx.strokeRect(path.bounds().x, path.bounds().y, path.bounds().width, path.bounds().height);
    selections = [];
    point = new draw.Point(0, 0);
    down = false;
    canvas.onmousemove = function(event) {
      var new_point, selection, _l, _len;
      new_point = new draw.Point(event.pageX, event.pageY);
      if (down) {
        for (_l = 0, _len = selections.length; _l < _len; _l++) {
          selection = selections[_l];
          selection.translate(new_point.from(point));
        }
      }
      return point = new_point;
    };
    canvas.onmousedown = function() {
      return down = true;
    };
    canvas.onmouseup = function() {
      return down = false;
    };
    return setInterval((function() {
      var i, _l, _len;
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      selections.length = 0;
      for (i = _l = 0, _len = paths.length; _l < _len; i = ++_l) {
        path = paths[i];
        if (path.contains(point)) {
          path.style.strokeColor = '#f00';
          ctx.strokeRect(path.bounds().x, path.bounds().y, path.bounds().width, path.bounds().height);
          selections.push(path);
        } else {
          path.translate(velocities[i]);
          path.style.strokeColor = '#000';
        }
        path.draw(ctx);
      }
      group.recompute();
      return ctx.strokeRect(group.bounds().x, group.bounds().y, group.bounds().width, group.bounds().height);
    }), 30);
  };

}).call(this);

/*
//@ sourceMappingURL=drawTest.js.map
*/