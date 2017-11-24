styleNode = document.createElement("style")
styleNode.innerHTML = require('./style')
document.head.appendChild(styleNode)

Effect = require  "./models/effect"

ApplicationTemplate = require "./templates/application"
ControlsPresenter = require "./presenters/controls"
EffectPresenter = require "./presenters/effect"

effect = Effect()

controlsElement = ControlsPresenter effect

global.audioContext = new AudioContext

createAndPlay = (type) ->
  effect.randomOfType(type)
  effect.play()

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

document.body.appendChild EffectPresenter effect
