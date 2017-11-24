styleNode = document.createElement("style")
styleNode.innerHTML = require('./style')
document.head.appendChild(styleNode)

Drop = require "./lib/drop"

Drop document, (e) ->
  return if e.defaultPrevented

  files = e.dataTransfer.files

  if files.length
    e.preventDefault()

    # Load all valid sfxz files
    Array.from(files).forEach (file) ->
      editor.loadSFXZ file

Editor = require "./editor"
editor = Editor()

document.body.appendChild editor.element

editor.createAndPlay("laserShoot")

Blob::readAsArrayBuffer = ->
  file = this

  new Promise (resolve, reject) ->
    reader = new FileReader
    reader.onload = ->
      resolve reader.result
    reader.onerror = reject
    reader.readAsArrayBuffer(file)