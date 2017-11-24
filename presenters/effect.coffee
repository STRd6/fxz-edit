EffectTemplate = require "../templates/effect"
Spectrum = require "../spectrum"

module.exports = (effect) ->
  effect.on "update", ->
    Spectrum(effect.samples(), timeDomainCanvas)

  timeDomainCanvas = document.createElement 'canvas'

  effect.canvas = timeDomainCanvas

  element = EffectTemplate effect
    

  return element