{Observable} = require "/lib/jadelet-runtime"

Item = require "./collection-item"

CollectionTemplate = require "../templates/collection"
Exporter = require('../export')

module.exports = ->
  items = Observable []

  selectAndPlay = (effect) ->
    self.activeItem effect
    effect.play()

  duplicate = (effect) ->
    self.add(effect.duplicate())

  self =
    activeItem: Observable null

    add: (effect) ->
      items.push Item effect, selectAndPlay, items.remove, duplicate

      self.activeItem(effect)

    clear: ->
      items.forEach (item) ->
        item.dispose()

      items []

    itemElements: ->
      items.map (item) -> item.element

    element: null

    download: (blob, name) ->
      url = window.URL.createObjectURL(blob)
      a = document.createElement("a")
      a.href = url
      a.download = name
      a.click()
      window.URL.revokeObjectURL(url)

    downloadJS: ->
      self.download self.JSBlob(), "fxz.js"

    JSBlob: ->
      new Blob [Exporter(self.FXXBuffer())], type: "application/javascript"

    downloadFXX: ->
      self.download self.FXXBlob(), "sounds.fxx"

    FXXBuffer: ->
      entries = items().length

      arrayBuffer = new ArrayBuffer(8 + 116 * entries)
      uint8Array = new Uint8Array(arrayBuffer)

      dataView = new DataView(arrayBuffer)
      # Header data "fxx\x01"
      [0x66, 0x78, 0x78, 0x01].forEach (n, i) -> 
        dataView.setUint8 i, n
      # Number of entries
      dataView.setUint32(4, entries, true)

      items.forEach (item, i) ->
        encodedName = new TextEncoder("utf-8").encode(item.name())

        # Limit names to exactly 16 bytes
        nameBuffer = new Uint8Array(16)
        nameBuffer.forEach (_, i) ->
          nameBuffer[i] = encodedName[i] or 0

        uint8Array.set nameBuffer, 8 + 116 * i
        uint8Array.set new Uint8Array(item.fxzBuffer()), 24 + 116 * i

      return arrayBuffer

    FXXBlob: ->
      new Blob [self.FXXBuffer()], type: "application/fxx"

  element = CollectionTemplate self
  self.element = element

  return self
