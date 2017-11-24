{Params, Serializer} = SFXZ = require "sfxz"

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
ControlsPresenter = require "./presenters/controls"
EffectPresenter = require "./presenters/effect"

module.exports = ->
  effect = Effect()

  controlsElement = ControlsPresenter effect
  effectElement = EffectPresenter effect
  
  global.audioContext = new AudioContext
  
  createAndPlay = (type) ->
    effect.randomOfType(type)
    effect.play()
  
  element = ApplicationTemplate
    controlsElement: controlsElement
    effectElement: effectElement
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
  
    random: ->
      createAndPlay("random")

  self =
    createAndPlay: createAndPlay
    loadSFXZ: (file) ->
      file.readAsArrayBuffer()
      .then (buffer) ->
        effect.fromSFXZ(buffer)
    element: element
