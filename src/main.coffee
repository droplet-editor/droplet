define ['ice-view', 'ice-model', 'ice-coffee', 'ice-controller', 'ice-parser'], (view, model, coffee, controller, parser) ->
  return {
    view: view,
    model: model,
    parse: coffee.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
