ControlTemplate = require "../templates/control"
# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

controlGroups =
  Wave:
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
  Vibrato:
    vibDepth:
      name: "Vibrato Depth"
    vibSpeed:
      name: "Vibrato Speed"
  Arpeggiation:
    arpMod:
      name: "Frequency Mult"
      signed: true
    arpSpeed:
      name: "Time"
  "Duty Cycle":
    duty:
      name: "Duty Cycle"
    dutySweep:
      name: "Sweep"
      signed: true
  Retrigger:
    repeatSpeed:
      name: "Rate"
  Flanger:
    flangerOffset:
      name: "Offset"
      signed: true
    flangerSweep:
      name: "Sweep"
      signed: true
  "Low-Pass Filter":
    lpf:
      name: "Cutoff Freq"
    lpfSweep:
      name: "Cutoff Sweep"
      signed: true
    lpfResonance:
      name: "Resonance"
  "High-Pass Filter":
    hpf:
      name: "Cutoff Freq"
    hpfSweep:
      name: "Cutoff Sweep"
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

  Object.keys(controlGroups).map (groupName) ->
    group = controlGroups[groupName]

    groupElement = Section("group")
    groupElement.appendChild H2 groupName
    element.appendChild groupElement

    Object.keys(group).map (property) ->
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

      groupElement.appendChild ControlTemplate
        name: name
        value: value
        min: min
        max: max
        step: step
        input: ->
          effect.regenerate()
          unless effect.playing()
            effect.play()

  effect.on "update", ->
    Object.keys(params).forEach (name) ->
      observableProps[name]?(params[name])

  return element
