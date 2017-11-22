ApplicationTemplate = require "./templates/application"

{Params, Serializer} = SFXZ = require "sfxz"

Mutator = require "./mutator"

params = new Params

audioContext = new AudioContext

createAndPlay = (type) ->
  params = Mutator[type](new Params)

  # Generate audio data
  audioBuffer = SFXZ(params, audioContext)

  # Play buffer
  node = new AudioBufferSourceNode audioContext,
    buffer: audioBuffer
  node.connect audioContext.destination
  node.start()

  dat = JSON.stringify(params)
  console.log dat.length, dat

  buf = Serializer.serialize(params)
  console.log new Uint8Array(buf)

  console.log Serializer.deserialize(buf, new Params)


document.body.appendChild ApplicationTemplate
  coin: ->
    createAndPlay("pickupCoin")

  laser: ->
    createAndPlay("laserShoot")

  explosion: ->
    createAndPlay("explosion")

  powerUp: ->
    createAndPlay("powerUp")

  hit: ->
    createAndPlay("hitHurt")

  jump: ->
    createAndPlay("jump")

  blip: ->
    createAndPlay("blipSelect")

  tone: ->
    createAndPlay("tone")
