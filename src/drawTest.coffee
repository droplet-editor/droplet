window.onload = ->
  canvas = document.getElementById('test')
  ctx = canvas.getContext('2d')

  paths = []
  velocities = []
  group = new draw.Group()
  
  for [1..1000]
    path = new draw.Path()
    center = new draw.Point Math.random() * 1000, Math.random() * 1000
    for [1..Math.floor(Math.random() * 4)+3]
      path.push new draw.Point center.x + Math.random() * 100, center.y + Math.random() * 100
    path.style.fillColor = '#fff'
    paths.push path
    if (Math.random() < 0.01)
      path.style.fillColor = '#000'
      group.push path
  
  for x in [1..1000]
    velocities.push new draw.Point Math.random() * 2 - 1, Math.random() * 2 - 1
    (->
      i = x
      tick = (-> setTimeout (->
        velocities[i-1] = new draw.Point Math.random() * 2 - 1, Math.random() * 2 - 1
        tick()
      ), Math.random() * 10000)
      tick()
    )()


  ctx.strokeRect path.bounds().x, path.bounds().y, path.bounds().width, path.bounds().height

  selections = []
  
  point = new draw.Point(0, 0)
  down = false
  canvas.onmousemove = (event) ->
    new_point = new draw.Point event.pageX, event.pageY
    if down
      for selection in selections
        selection.translate new_point.from point
    point = new_point

  canvas.onmousedown = -> down = true
  canvas.onmouseup = -> down = false

  setInterval (->
    ctx.clearRect 0, 0, canvas.width, canvas.height
    selections.length = 0
    for path, i in paths
      if path.contains point
        path.style.strokeColor = '#f00'
        ctx.strokeRect path.bounds().x, path.bounds().y, path.bounds().width, path.bounds().height
        selections.push path
      else
        path.translate velocities[i]
        path.style.strokeColor = '#000'
      path.draw(ctx)
    group.recompute()
    ctx.strokeRect group.bounds().x, group.bounds().y, group.bounds().width, group.bounds().height
  ), 30
