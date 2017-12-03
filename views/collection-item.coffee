ItemTemplate = require "../templates/fxz-item"
Spectrum = require "../spectrum"

module.exports = (effect, select, remove, duplicate) ->
  element = ItemTemplate
    name: effect.name
    click: (e) ->
      select(effect)
    remove: ->
      self.dispose()
      remove(self)
    duplicate: ->
      duplicate(effect)

    fxzURL: effect.fxzURL
    fxzFilename: effect.fxzFilename
    wavURL: effect.wavURL
    wavFilename: effect.wavFilename

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
