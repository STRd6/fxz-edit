{Params, Serializer} = SFXZ = require "sfxz"

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
EffectActionsTemplate = require "./templates/effect-actions"
ControlsPresenter = require "./presenters/controls"
EffectPresenter = require "./presenters/effect"
HistoryPresenter = require "./presenters/history"

module.exports = ->
  effect = Effect()

  controlsElement = ControlsPresenter effect
  effectElement = EffectPresenter effect
  effectActionsElement = EffectActionsTemplate effect

  historyElement = HistoryPresenter (buffer) ->
    self.loadBuffer buffer
    effect.play()

  global.audioContext = new AudioContext

  createAndPlay = (type) ->
    effect.randomOfType(type)
    effect.play()

    historyElement.add(effect, type)
  
  element = ApplicationTemplate
    controlsElement: controlsElement
    effectElement: effectElement
    effectActionsElement: effectActionsElement
    historyElement: historyElement
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

    play: ->
      effect.play()

  self =
    createAndPlay: createAndPlay
    loadSFXZ: (file) ->
      file.readAsArrayBuffer()
      .then self.loadBuffer
    loadBuffer: (buffer) ->
      effect.fromSFXZ(buffer)
    element: element
    play: ->
      effect.play()

  return self