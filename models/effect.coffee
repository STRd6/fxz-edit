{Params, Serializer} = SFXZ = require "sfxz"

Mutator = require "../mutator"

module.exports = ->
  params = new Params

  audioBuffer = null

  listeners = {}

  self =
    regenerate: ->
      # Generate audio data
      audioBuffer = SFXZ(params, audioContext)

      self.trigger "update"

    randomOfType: (type) ->
      params = Mutator[type](Mutator.reset(params))

      self.regenerate()

    params: ->
      params

    samples: ->
      audioBuffer.getChannelData(0)

    wavURL: ->
      
  
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
