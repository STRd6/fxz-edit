# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

Wav = require "../lib/wav"

{Params, Serializer} = FXZ = require "fxz"

Mutator = require "../mutator"

module.exports = ->
  params = new Params

  audioBuffer = null
  fxzBlob = null
  fxzBuffer = null

  updateFxzURL = ->
    oldURL = self.fxzURL()

    if oldURL
      URL.revokeObjectURL(oldURL)

    fxzBuffer = Serializer.serialize(params)
    fxzBlob = new Blob [fxzBuffer],
      type: "application/fxz"

    self.fxzURL URL.createObjectURL(fxzBlob)

  updateWavURL = ->
    oldURL = self.wavURL()

    if oldURL
      URL.revokeObjectURL(oldURL)

    wavFile = Wav(self.samples())
    self.wavURL URL.createObjectURL(wavFile)

  listeners = {}

  self =
    regenerate: ->
      # Generate audio data
      audioBuffer = FXZ(params, audioContext)

      updateFxzURL()
      updateWavURL()

      self.trigger "update"

    randomOfType: (type) ->
      params = Mutator[type](Mutator.reset(params))

      self.wavFilename "#{type}.wav"
      self.fxzFilename "#{type}.fxz"

      self.regenerate()

    fromFXZ: (buffer) ->
      Serializer.deserialize(buffer, params)
      self.regenerate()

    params: ->
      params

    samples: ->
      audioBuffer.getChannelData(0)

    wavFilename: Observable "sound.wav"
    wavURL: Observable null

    fxzBuffer: ->
      fxzBuffer
    fxzFilename: Observable "sound.fxz"
    fxzURL: Observable null

    playing: Observable false

    play: ->
      # Play buffer
      node = new AudioBufferSourceNode audioContext,
        buffer: audioBuffer
      node.connect audioContext.destination
      node.addEventListener "ended", (e) ->
        console.log "Ended", e
        self.playing(false)

      self.playing true
      node.start()

    on: (type, listener) ->
      listeners[type] ?= []
      listeners[type].push listener

      return self

    off: (type, listener) ->
      activeListeners = listeners[type]

      if activeListeners
        remove(activeListeners, listener)

    trigger: (type, args...) ->
      listeners[type]?.forEach (listener) ->
        listener.apply(self, args...)

  return self

# Array util remove
remove = (array, item) ->
  index = array.indexOf item

  if index >= 0
    return array.splice(index, 1)[0]
