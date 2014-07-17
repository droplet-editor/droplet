require.config
  paths:
    'ice': '../js/main'
    'ice-coffee': '../js/coffee'
    'ice-model': '../js/model'
    'ice-view': '../js/view'
    'ice-parser': '../js/parser'
    'ice-draw': '../js/draw'
    'ice-controller': '../js/controller'
    'coffee-script': '../vendor/coffee-script'

require ['ice'], (ice) ->
  resize = ->
    canvas = document.getElementById 'main'
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    canvas.style.position = 'absolute'
    canvas.style.top = '0px'
    canvas.style.left = '0px'
    ctx = canvas.getContext '2d'

  window.addEventListener 'resize', resize

  resize()

  model = ice.parse '''
  handle = ((a, b) ->
    if a
      b {
        state: null
      }
    else
      fd 10
      b 0) 5, 5

  class Handler
    constructor: (@handle) ->
      fd 10
      bk 10
      fd 10
      bk 10

  b = new Handler handle
  '''

  model.correctParentTree()

  view = new ice.view.View
    padding: 5
    indentWidth: 10
    indentTongueHeight: 10
    tabOffset: 10
    tabWidth: 15
    tabHeight: 5
    tabSideWidth: 0.125
    dropAreaHeight: 20
    indentDropAreaMinWidth: 50
    emptySocketWidth: 20
    emptySocketHeight: 25
    emptyLineHeight: 25
    highlightAreaHeight: 10
    shadowBlur: 5
    ctx: document.querySelector('canvas').getContext '2d'

  modelView = view.getViewNodeFor(model)

  pos = 0
  
  document.body.addEventListener 'keydown', (event) ->
    if event.which in [37, 38, 39, 40, 74, 75, 76]
      modelView.layout()
      view.opts.ctx.clearRect(0, 0,
        document.querySelector('canvas').width,
        document.querySelector('canvas').height
      )

      if event.which in [74, 75, 76]
        view.opts.ctx.globalAlpha = 0.2
        modelView.draw view.opts.ctx, new ice.draw.Rectangle(
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
          modelView.draw view.opts.ctx, new ice.draw.Rectangle(
            0, 0,
            document.querySelector('canvas').width,
            document.querySelector('canvas').height
          )
          view.opts.ctx.globalAlpha = 1
        when 38
          view.clearCache()
          modelView = view.getViewFor model
        when 74
          pos--
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            view.getViewFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
        when 75
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            view.getViewFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
        when 76
          pos++
          head = model.getTokenAtLocation(pos)
          if head.type in ['indentStart', 'blockStart', 'segmentStart', 'socketStart', 'indentEnd', 'blockEnd', 'segmentEnd', 'socketEnd']
            view.getViewFor(head.container).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}
          else unless head.type is 'newline'
            view.getViewFor(head).drawSelf view.opts.ctx, {selected: 0, grayscale: 0}

  shown = false
  document.querySelector('#changebutton').addEventListener 'click', (event) ->
    model = ice.parse document.querySelector('#editor').value
    model.correctParentTree()
    modelView = view.getViewFor(model)

    if shown
      shown = false
      document.querySelector('#editor').style.display = 'none'
    else
      shown = true
      document.querySelector('#editor').style.display = 'block'
