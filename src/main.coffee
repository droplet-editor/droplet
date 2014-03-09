define ['ice-coffee', 'ice-controller'], (coffee, controller) ->
  return {
    parse: coffee.parse,
    Editor: controller.Editor
  }
