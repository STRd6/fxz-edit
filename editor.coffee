{Params, Serializer} = FXZ = require "fxz"

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
EffectActionsTemplate = require "./templates/effect-actions"
ControlsPresenter = require "./presenters/controls"
EffectPresenter = require "./presenters/effect"
CollectionView = require "./views/collection"

module.exports = ->
  effect = Effect()

  controlsElement = ControlsPresenter effect
  effectElement = EffectPresenter effect
  effectActionsElement = EffectActionsTemplate effect

  collectionView = CollectionView()

  global.audioContext = new AudioContext

  createAndPlay = (type) ->
    effect.randomOfType(type)
    effect.play()

    collectionView.add(type, effect)

  element = ApplicationTemplate
    controlsElement: controlsElement
    effectElement: effectElement
    effectActionsElement: effectActionsElement
    collectionElement: collectionView.element
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
    loadFXZ: (file) ->
      file.readAsArrayBuffer()
      .then self.loadBuffer
    loadBuffer: (buffer) ->
      effect.fromFXZ(buffer)
    element: element
    play: ->
      effect.play()

  return self
