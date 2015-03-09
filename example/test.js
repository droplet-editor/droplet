(function() {
  var readFile;

  readFile = function(name) {
    var q;
    q = new XMLHttpRequest();
    q.open('GET', name, false);
    q.send();
    return q.responseText;
  };

  require.config({
    baseUrl: '../js',
    paths: JSON.parse(readFile('../requirejs-paths.json'))
  });

  require(['droplet'], function(droplet) {
    var model, modelView, out, pos, ref, resize, shown, view;
    resize = function() {
      var canvas, ctx;
      canvas = document.getElementById('main');
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
      canvas.style.position = 'absolute';
      canvas.style.top = '0px';
      canvas.style.left = '0px';
      return ctx = canvas.getContext('2d');
    };
    window.addEventListener('resize', resize);
    out = document.querySelector('#out');
    resize();
    model = droplet.js_parse((ref = localStorage.getItem('testProgram')) != null ? ref : 'if (a) {if (b) {fd(10);\n    a + b;}fd(10);\n  1 + 1;\n}');
    model.correctParentTree();
    view = new droplet.view.View({
      padding: 5,
      indentWidth: 20,
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
      ctx: document.getElementById('main').getContext('2d')
    });
    modelView = view.getViewNodeFor(model);
    pos = 0;
    document.body.addEventListener('keydown', function(event) {
      var head, ref1, ref2, ref3, ref4, ref5, ref6;
      if (((ref1 = event.which) === 37 || ref1 === 38 || ref1 === 39 || ref1 === 40 || ref1 === 74 || ref1 === 75 || ref1 === 76 || ref1 === 8) && document.activeElement === document.body) {
        modelView.layout();
        view.opts.ctx.clearRect(0, 0, document.querySelector('canvas').width, document.querySelector('canvas').height);
        event.preventDefault();
        if ((ref2 = event.which) === 74 || ref2 === 75 || ref2 === 76) {
          view.opts.ctx.globalAlpha = 0.2;
          modelView.draw(view.opts.ctx, new view.draw.Rectangle(0, 0, document.querySelector('canvas').width, document.querySelector('canvas').height));
          view.opts.ctx.globalAlpha = 1;
        }
        switch (event.which) {
          case 37:
            return modelView.debugAllDimensions(view.opts.ctx);
          case 40:
            return modelView.debugAllBoundingBoxes(view.opts.ctx);
          case 39:
            view.opts.ctx.globalAlpha = 0.5;
            modelView.draw(view.opts.ctx, new view.draw.Rectangle(0, 0, document.querySelector('canvas').width, document.querySelector('canvas').height));
            return view.opts.ctx.globalAlpha = 1;
          case 38:
            view.clearCache();
            return modelView = view.getViewNodeFor(model);
          case 74:
            pos--;
            head = model.getTokenAtLocation(pos);
            if ((ref3 = head.type) === 'indentStart' || ref3 === 'blockStart' || ref3 === 'segmentStart' || ref3 === 'socketStart' || ref3 === 'indentEnd' || ref3 === 'blockEnd' || ref3 === 'segmentEnd' || ref3 === 'socketEnd') {
              out.innerText = view.getViewNodeFor(head.container).serialize();
              return view.getViewNodeFor(head.container).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            } else if (head.type !== 'newline') {
              return view.getViewNodeFor(head).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            }
            break;
          case 75:
            head = model.getTokenAtLocation(pos);
            if ((ref4 = head.type) === 'indentStart' || ref4 === 'blockStart' || ref4 === 'segmentStart' || ref4 === 'socketStart' || ref4 === 'indentEnd' || ref4 === 'blockEnd' || ref4 === 'segmentEnd' || ref4 === 'socketEnd') {
              out.innerText = view.getViewNodeFor(head.container).serialize();
              return view.getViewNodeFor(head.container).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            } else if (head.type !== 'newline') {
              return view.getViewNodeFor(head).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            }
            break;
          case 76:
            pos++;
            head = model.getTokenAtLocation(pos);
            if ((ref5 = head.type) === 'indentStart' || ref5 === 'blockStart' || ref5 === 'segmentStart' || ref5 === 'socketStart' || ref5 === 'indentEnd' || ref5 === 'blockEnd' || ref5 === 'segmentEnd' || ref5 === 'socketEnd') {
              out.innerText = view.getViewNodeFor(head.container).serialize();
              return view.getViewNodeFor(head.container).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            } else if (head.type !== 'newline') {
              return view.getViewNodeFor(head).drawSelf(view.opts.ctx, {
                selected: 0,
                grayscale: 0
              });
            }
            break;
          case 8:
            head = model.getTokenAtLocation(pos);
            if ((ref6 = head.type) === 'indentStart' || ref6 === 'blockStart' || ref6 === 'segmentStart' || ref6 === 'socketStart' || ref6 === 'indentEnd' || ref6 === 'blockEnd' || ref6 === 'segmentEnd' || ref6 === 'socketEnd') {
              head.container.spliceOut();
            } else {
              head.remove();
            }
            return modelView.layout();
        }
      }
    });
    shown = false;
    return document.querySelector('#changebutton').addEventListener('click', function(event) {
      model = droplet.js_parse(document.querySelector('#editor').value);
      model.correctParentTree();
      modelView = view.getViewNodeFor(model);
      if (shown) {
        shown = false;
        document.querySelector('#editor').style.display = 'none';
      } else {
        shown = true;
        document.querySelector('#editor').style.display = 'block';
      }
      return localStorage.setItem('testProgram', document.querySelector('#editor').value);
    });
  });

}).call(this);

//# sourceMappingURL=test.js.map
