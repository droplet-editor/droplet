# Base class for all animals.
#
# @example How to subclass an animal
#   class Lion extends Animal
#     move: (direction, speed): ->
#
class Example.Animal

  # The Answer to the Ultimate Question of Life, the Universe, and Everything
  @ANSWER = 42

  # Construct a new animal.
  #
  # @param [String] name the name of the animal
  # @param [Date] birthDate when the animal was born
  #
  constructor: (@name, @birthDate = new Date()) ->

  # Move the animal.
  #
  # @example Move an animal
  #   new Lion('Simba').move(direction: 'south', speed: 12)
  #
  # @param [Object] options the moving options
  # @option options [String] direction the moving direction
  # @option options [Number] speed the speed in mph
  #
  move: (options = {}) ->
