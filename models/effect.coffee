# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

Wav = require "../lib/wav"

{Params, Serializer} = SFXZ = require "sfxz"

Mutator = require "../mutator"

module.exports = ->
  params = new Params

  audioBuffer = null
  sfxzBlob = null
  sfxzBuffer = null

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

      self.wavFilename "#{type}.wav"
      self.sfxzFilename "#{type}.sfxz"

      self.regenerate()

    fromSFXZ: (buffer) ->
      Serializer.deserialize(buffer, params)
      self.regenerate()

    params: ->
      params

    samples: ->
      audioBuffer.getChannelData(0)

    wavFilename: Observable "sound.wav"
    wavURL: Observable null

    sfxzBuffer: ->
      sfxzBuffer
    sfxzFilename: Observable "sound.sfxz"
    sfxzURL: Observable null

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
