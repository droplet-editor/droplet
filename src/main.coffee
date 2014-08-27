define ['droplet-draw', 'droplet-view', 'droplet-model', 'droplet-coffee', 'droplet-controller', 'droplet-parser'], (draw, view, model, coffee, controller, parser) ->
  return {
    view: view,
    draw: draw,
    model: model,
    parse: coffee.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
