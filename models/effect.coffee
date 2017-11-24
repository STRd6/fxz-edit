# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

Wav = require "../lib/wav"

{Params, Serializer} = SFXZ = require "sfxz"

Mutator = require "../mutator"

module.exports = ->
  params = new Params

  audioBuffer = null
  sfxzBlob = null

  updateSfxzURL = ->
    oldURL = self.sfxzURL()

    if oldURL
      URL.revokeObjectURL(oldURL)

    sfxzBuffer = Serializer.serialize(params)
    sfxzBlob = new Blob [sfxzBuffer],
      type: "application/sfxz"

    self.sfxzURL URL.createObjectURL(sfxzBlob)
  
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
      audioBuffer = SFXZ(params, audioContext)

      updateSfxzURL()
      updateWavURL()

      self.trigger "update"

    randomOfType: (type) ->
      params = Mutator[type](Mutator.reset(params))

      self.regenerate()

    params: ->
      params

    samples: ->
      audioBuffer.getChannelData(0)

    wavFilename: "sound.wav"
    wavURL: Observable null

    sfxzFilename: "sound.sfxz"
    sfxzURL: Observable null

    play: ->
      # Play buffer
      node = new AudioBufferSourceNode audioContext,
        buffer: audioBuffer
      node.connect audioContext.destination
      node.start()

    on: (type, listener) ->
      listeners[type] ?= []
      listeners[type].push listener

      return self

    trigger: (type, args...) ->
      listeners[type]?.forEach (listener) ->
        listener.apply(self, args...)

  return self
