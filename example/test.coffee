readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText

require.config
  baseUrl: '../js'
  paths: JSON.parse readFile '../requirejs-paths.json'

require ['droplet'], (droplet) ->
  resize = ->
    canvas = document.getElementById 'main'
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    canvas.style.position = 'absolute'
    canvas.style.top = '0px'
    canvas.style.left = '0px'
    ctx = canvas.getContext '2d'

  window.addEventListener 'resize', resize
  out = document.querySelector '#out'

  resize()

  model = droplet.js_parse localStorage.getItem('testProgram') ? '''
  if (a) {if (b) {fd(10);
      a + b;}fd(10);
    1 + 1;
  }
  '''

  model.correctParentTree()

  view = new droplet.view.View ctx: document.getElementById('main').getContext '2d'

  modelView = view.getViewNodeFor(model)

  pos = 0

  document.body.addEventListener 'keydown', (event) ->
    if event.which in [37, 38, 39, 40, 74, 75, 76, 8] and document.activeElement is document.body
      modelView.layout()
      view.opts.ctx.clearRect(0, 0,
        document.querySelector('canvas').width,
        document.querySelector('canvas').height
      )

      event.preventDefault()

      if event.which in [74, 75, 76]
        view.opts.ctx.globalAlpha = 0.2
        modelView.draw view.opts.ctx, new view.draw.Rectangle(
          0, 0,
          document.querySelector('canvas').width,
          document.querySelector('canvas').height
        )
        view.opts.ctx.globalAlpha = 1

      switch event.which
        when 37
          modelView.debugAllDimensions view.opts.ctx
        when 40
          modelView.debugAllBoundingBoxes view.opts.ctx
        when 39
          view.opts.ctx.globalAlpha = 0.5
          modelView.draw view.opts.ctx, new view.draw.Rectangle(
            0, 0,
            document.querySelector('canvas').width,
            document.querySelector('canvas').height
          )
          view.opts.ctx.globalAlpha = 1
        when 38
          view.clearCache()
          modelView = view.getViewNodeFor model
        when 74
          pos--
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            out.innerText = view.getViewNodeFor(head.container).serialize()
            view.getViewNodeFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewNodeFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
        when 75
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            out.innerText = view.getViewNodeFor(head.container).serialize()
            view.getViewNodeFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewNodeFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
        when 76
          pos++
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            out.innerText = view.getViewNodeFor(head.container).serialize()
            view.getViewNodeFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewNodeFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
        when 8
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            head.container.spliceOut()
          else
            head.remove()

          modelView.layout()


  shown = false
  document.querySelector('#changebutton').addEventListener 'click', (event) ->
    model = droplet.js_parse document.querySelector('#editor').value
    model.correctParentTree()
    modelView = view.getViewNodeFor(model)

    if shown
      shown = false
      document.querySelector('#editor').style.display = 'none'
    else
      shown = true
      document.querySelector('#editor').style.display = 'block'

    localStorage.setItem 'testProgram', document.querySelector('#editor').value
