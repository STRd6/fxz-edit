# TODO: WIP Collection item view to make adding and interacting with effect
# items easier

HistoryItemTemplate = require "../templates/history-item"
Spectrum = require "../spectrum"

module.exports = (name, effect) ->
  element = HistoryTemplate()

  waveformCanvas = document.createElement "canvas"

  element = HistoryItemTemplate
    name: name
    waveform: waveformCanvas
    click: ->
      load(buffer)

  self =
    buffer: ->
      buffer
    dispose: ->
      # Don't leak listeners
      effect.off "update", update
    element: element

  update = ->
    buffer = effect.sfxzBuffer()
    # TODO: Resize canvas to be full width
    Spectrum effect.samples(), waveformCanvas, 200, 32

  effect.on "update", update

  update()

  return self
