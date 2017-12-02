# TODO: WIP Collection item view to make adding and interacting with effect
# items easier

ItemTemplate = require "../templates/fxz-item"
Spectrum = require "../spectrum"

module.exports = (name, effect, select) ->
  element = ItemTemplate
    name: name
    click: ->
      select(effect)

  waveformCanvas = element.querySelector('canvas')

  self =
    buffer: ->
      buffer
    dispose: ->
      # Don't leak listeners
      effect.off "update", update
    element: element

  update = ->
    buffer = effect.fxzBuffer()
    Spectrum effect.samples(), waveformCanvas, waveformCanvas.clientWidth, 32

  effect.on "update", update

  # TODO: This is because we need to wait until we're added to the dom before
  # contentWidth exists
  setTimeout ->
    update()

  return self
