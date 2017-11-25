ControlTemplate = require "../templates/control"
WaveShapeTemplate = require "../templates/wave-shape"
# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

controlGroups =
  "Wave Shape":
    shape:
      name: "Shape"
  Envelope:
    attack:
      name: "Attack"
    sustain:
      name: "Sustain"
    punch:
      name: "Sustain Punch"
    decay:
      name: "Decay"
    repeatSpeed:
      name: "Retrigger Rate"
    vol:
      name: "Volume"
  Frequency:
    freq:
      name: "Frequency"
    freqLimit:
      name: "Min Freq Cutoff"
    freqSlide:
      name: "Frequency Slide"
      signed: true
    freqSlideDelta:
      name: "Frequency Slide Δ"
      signed: true
    arpMod:
      name: "Frequency Mult"
      signed: true
    arpSpeed:
      name: "Mult Time"
  FX:
    vibDepth:
      name: "Vibrato Depth"
    vibSpeed:
      name: "Vibrato Speed"
    duty:
      name: "Duty Cycle"
    dutySweep:
      name: "Duty Sweep"
      signed: true
    flangerOffset:
      name: "Flanger Offset"
      signed: true
    flangerSweep:
      name: "Flanger Sweep"
      signed: true
  Filter:
    lpf:
      name: "LPF Cutoff"
    lpfSweep:
      name: "LPF Cutoff Sweep"
      signed: true
    lpfResonance:
      name: "LPF Resonance"
    hpf:
      name: "HPF Cutoff"
    hpfSweep:
      name: "HPF Cutoff Sweep"
      signed: true

Section = (className) ->
  element = document.createElement "section"
  element.classList.add className

  return element

H2 = (text) ->
  h2 = document.createElement "h2"
  h2.innerText = text

  return h2

module.exports = (effect) ->
  element = Section("controls")

  params = effect.params()

  observableProps = {}
  
  alterAndPlay = ->
    effect.regenerate()
    unless effect.playing()
      effect.play()

  Object.keys(controlGroups).forEach (groupName) ->
    group = controlGroups[groupName]

    groupElement = Section("group")
    groupElement.appendChild H2 groupName
    element.appendChild groupElement

    Object.keys(group).forEach (property) ->
      {name, signed} = group[property]

      if signed
        min = -1
      else
        min = 0

      step = 0.001
      max = 1

      value = observableProps[property] = Observable params[property]
      value.observe (newValue) ->
        params[property] = newValue

      if groupName is "Wave Shape"
        groupElement.appendChild WaveShapeTemplate
          change: ({target}) ->
            value parseInt(target.value, 10)
            alterAndPlay()
          value: value

        return groupElement

      groupElement.appendChild ControlTemplate
        name: name
        value: value
        min: min
        max: max
        step: step
        input: ->
          alterAndPlay()

  effect.on "update", ->
    Object.keys(params).forEach (name) ->
      observableProps[name]?(params[name])

  return element
