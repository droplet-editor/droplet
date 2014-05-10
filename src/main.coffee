define ['ice-coffee', 'ice-controller', 'ice-parser'], (coffee, controller, parser) ->
  return {
    parse: coffee.parse,
    parseObj: parser.parseObj,
    Editor: controller.Editor
  }
