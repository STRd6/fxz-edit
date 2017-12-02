HistoryTemplate = require "../templates/history"
HistoryItemTemplate = require "../templates/fxz-item"
Spectrum = require "../spectrum"

module.exports = (load) ->
  element = HistoryTemplate()

  counts = {}

  element.add = (effect, name) ->
    counts[name] = (counts[name] or 0) + 1

    waveformCanvas = document.createElement "canvas"

    buffer = effect.fxzBuffer()
    Spectrum effect.samples(), waveformCanvas, 200, 32

    element.appendChild HistoryItemTemplate
      name: name + counts[name]
      waveform: waveformCanvas
      click: ->
        load(buffer)

  return element
