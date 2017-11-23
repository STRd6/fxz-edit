ControlTemplate = require "../templates/control"
# Pull in bundled Observable from editor
{Observable} = require "/lib/jadelet-runtime"

controlGroups =
  Envelope:
    attack:
      name: "Attack"
      signed: false
    sustain:
      name: "Sustain"
      signed: false
    punch:
      name: "Sustain Punch"
      signed: false
    decay:
      name: "Decay"
      signed: false
  Frequency:
    freq:
      name: "Frequency"
      signed: false

Section = (className) ->
  element = document.createElement "section"
  element.classList.add className

  return element

H2 = (text) ->
  h2 = document.createElement "h2"
  h2.innerText = text
  
  return h2

module.exports = (params) ->
  element = Section("controls")

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

      value = Observable params[property]

      groupElement.appendChild ControlTemplate
        name: name
        value: value
        min: min
        max: max
        step: step

  return element
  