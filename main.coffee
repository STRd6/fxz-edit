{UI} = SystemClient = require "sys"

styleNode = document.createElement("style")
styleNode.innerHTML = require('./style')
document.head.appendChild(styleNode)

Drop = require "./lib/drop"

Drop document, (e) ->
  return if e.defaultPrevented

  files = e.dataTransfer.files

  if files.length
    e.preventDefault()

    # Load all valid fxx and fxz files
    Array.from(files).forEach (file) ->
      editor.loadFile file

Hotkeys = require "./lib/hotkeys"

Editor = require "./editor"
editor = Editor()

document.body.appendChild editor.element

{application, system} = SystemClient()

system.ready()
.then ->
  # Do ZineOS Stuff
  application.setSignal "fxx", editor.fxxBuffer()
.catch ->
  ; # No ZineOS

Hotkeys.add " ", ->
  editor.play()

editor.createAndPlay("laserShoot")

Blob::readAsArrayBuffer = ->
  file = this

  new Promise (resolve, reject) ->
    reader = new FileReader
    reader.onload = ->
      resolve reader.result
    reader.onerror = reject
    reader.readAsArrayBuffer(file)
