define ['droplet-draw', 'droplet-view', 'droplet-model', 'droplet-coffee', 'droplet-javascript', 'droplet-controller', 'droplet-parser'], (draw, view, model, coffee, javascript, controller, parser) ->
  return {
    view: view,
    draw: draw,
    model: model,
    parse: coffee.parse,
    js_parse: javascript.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
