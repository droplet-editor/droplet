define ['melt-draw', 'melt-view', 'melt-model', 'melt-coffee', 'melt-controller', 'melt-parser'], (draw, view, model, coffee, controller, parser) ->
  return {
    view: view,
    draw: draw,
    model: model,
    parse: coffee.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
