{Params, Serializer} = FXZ = require "fxz"

Spectrum = require "./spectrum"

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
ControlsPresenter = require "./presenters/controls"
CollectionView = require "./views/collection"

module.exports = ->
  collectionView = CollectionView()
  controlsElement = ControlsPresenter collectionView.activeItem

  global.audioContext = new AudioContext

  createAndPlay = (type) ->
    effect = Effect()
    effect.randomOfType(type)
    effect.play()

    collectionView.add(effect)

  element = ApplicationTemplate
    controlsElement: controlsElement
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
      self.play()

  self =
    activeEffect: ->
      collectionView.activeItem()
    createAndPlay: createAndPlay
    loadFXZ: (file) ->
      file.readAsArrayBuffer()
      .then (buffer) ->
        self.loadBuffer buffer, file.name.replace(/\.s?fxz$/, "")
    loadBuffer: (buffer, name="unknown") ->
      effect = Effect()
      effect.fromFXZ(buffer)
      effect.name name

      collectionView.add(effect)
    element: element
    play: ->
      self.activeEffect()?.play()

  timeDomainCanvas = element.querySelector "canvas"
  repaint = (effect) ->
    Spectrum(effect.samples(), timeDomainCanvas, timeDomainCanvas.clientWidth)

  collectionView.activeItem.observe repaint
  controlsElement.on "update", ->
    repaint(collectionView.activeItem())

  return self
