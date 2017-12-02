{Observable} = require "/lib/jadelet-runtime"

Item = require "./collection-item"

CollectionTemplate = require "../templates/collection"

module.exports = ->
  items = Observable []

  self =
    activeItem: Observable null

    add: (name, effect) ->
      items.push Item(name, effect, self.activeItem)
      self.activeItem(effect)

    itemElements: ->
      items.map (item) -> item.element

    element: null

  element = CollectionTemplate self
  self.element = element

  return self
