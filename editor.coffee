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
    fxxBuffer: ->
      collectionView.fxxBuffer()
    loadFile: (file) ->
      file.readAsArrayBuffer()
      .then (buffer) ->
        dataView = new DataView(buffer)
        header = dataView.getUint32(0, true)

        if header is 24672358 # fxx v1 magic number
          self.loadFXX buffer
        else if header is 24803430 # fxz v1 magic number
          self.loadFXZ buffer, file.name.replace(/\.s?fxz$/, "")
    loadFXX: (buffer) ->
      collectionView.clear()

      n = 8
      l = buffer.byteLength
      while n < l
        s = n + 16
        e = s + 100
        nameBuffer = new Uint8Array(buffer.slice(n, s))
        lastNull = nameBuffer.indexOf(0)

        if lastNull >= 0
          nameBuffer = nameBuffer.slice(0, lastNull)

        name = new TextDecoder("utf-8").decode(nameBuffer)
        self.loadFXZ(buffer.slice(s, e), name)
        n = e

      return

    loadFXZ: (buffer, name="unknown") ->
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
