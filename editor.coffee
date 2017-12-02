{Params, Serializer} = FXZ = require "fxz"

Spectrum = require "./spectrum"

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
EffectActionsTemplate = require "./templates/effect-actions"
ControlsPresenter = require "./presenters/controls"
CollectionView = require "./views/collection"

module.exports = ->
  effect = Effect()

  effectActionsElement = EffectActionsTemplate effect

  collectionView = CollectionView()
  controlsElement = ControlsPresenter collectionView.activeItem

  global.audioContext = new AudioContext

  createAndPlay = (type) ->
    effect = Effect()
    effect.randomOfType(type)
    effect.play()

    collectionView.add(type, effect)

  element = ApplicationTemplate
    controlsElement: controlsElement
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

  timeDomainCanvas = element.querySelector "canvas"
  repaint = (effect) ->
    Spectrum(effect.samples(), timeDomainCanvas, timeDomainCanvas.clientWidth)

  collectionView.activeItem.observe repaint
  controlsElement.on "update", ->
    repaint(collectionView.activeItem())

  return self
