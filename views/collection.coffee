{Observable} = require "/lib/jadelet-runtime"

Item = require "./collection-item"

CollectionTemplate = require "../templates/collection"

module.exports = ->
  items = Observable []

  selectAndPlay = (effect) ->
    self.activeItem effect
    effect.play()

  duplicate = (effect) ->
    self.add(effect.duplicate())

  self =
    activeItem: Observable null

    add: (effect) ->
      items.push Item effect, selectAndPlay, items.remove, duplicate

      self.activeItem(effect)

    itemElements: ->
      items.map (item) -> item.element

    element: null

  element = CollectionTemplate self
  self.element = element

  return self
