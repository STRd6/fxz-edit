# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

Trigger = require "./trigger"
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

  self =
    name: Observable "unknown"
    regenerate: ->
      # Generate audio data
      audioBuffer = FXZ(params, audioContext)

      updateFxzURL()
      updateWavURL()

      self.trigger "update"

    randomOfType: (type) ->
      Mutator[type](Mutator.reset(params))

      self.name(type)

      self.regenerate()

    fromFXZ: (buffer) ->
      Serializer.deserialize(buffer, params)
      self.regenerate()

    params: ->
      params

    samples: ->
      audioBuffer.getChannelData(0)

    wavFilename: ->
      "#{self.name()}.wav"
    wavURL: Observable null

    fxzBuffer: ->
      fxzBuffer
    fxzFilename: ->
      "#{self.name()}.fxz"
    fxzURL: Observable null

    playing: Observable false

    play: ->
      # Play buffer
      node = new AudioBufferSourceNode audioContext,
        buffer: audioBuffer
      node.connect audioContext.destination
      node.addEventListener "ended", (e) ->
        self.playing(false)

      self.playing true
      node.start()

  Trigger(self)

  return self

# Array util remove
remove = (array, item) ->
  index = array.indexOf item

  if index >= 0
    return array.splice(index, 1)[0]
