styleNode = document.createElement("style")
styleNode.innerHTML = require('./style')
document.head.appendChild(styleNode)

ApplicationTemplate = require "./templates/application"
ControlsPresenter = require "./presenters/controls"

global.require = require

{Params, Serializer} = SFXZ = require "sfxz"

Mutator = require "./mutator"

params = new Params
controlsElement = ControlsPresenter params

audioContext = new AudioContext

createAndPlay = (type) ->
  params = Mutator[type](Mutator.reset(params))

  controlsElement.resync()

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
  controlsElement: controlsElement
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
