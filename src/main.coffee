define ['ice-draw', 'ice-view', 'ice-model', 'ice-coffee', 'ice-controller', 'ice-parser'], (draw, view, model, coffee, controller, parser) ->
  return {
    view: view,
    draw: draw,
    model: model,
    parse: coffee.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
