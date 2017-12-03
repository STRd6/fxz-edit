{Observable} = require "/lib/jadelet-runtime"

Item = require "./collection-item"

CollectionTemplate = require "../templates/collection"

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

    itemElements: ->
      items.map (item) -> item.element

    element: null

    download: ->
      blob = self.fxxBlob()

      url = window.URL.createObjectURL(blob)
      a = document.createElement("a")
      a.href = url
      a.download = "sounds.fxx"
      a.click()
      window.URL.revokeObjectURL(url)

    fxxBlob: ->
      data = []

      sizeEntry = new ArrayBuffer(4)
      dataView = new DataView(sizeEntry)
      dataView.setUint32(0, items().length, true)

      # Header data "fxx\x01"
      data.push Uint8Array.from [0x66, 0x78, 0x78, 0x01]
      data.push sizeEntry

      items.forEach (item) ->
        encodedName = new TextEncoder("utf-8").encode(item.name())

        # Limit names to exactly 16 bytes
        nameBuffer = new Uint8Array(16)
        nameBuffer.forEach (_, i) ->
          nameBuffer[i] = encodedName[i] or 0

        data.push nameBuffer
        data.push item.fxzBuffer()

      new Blob data, type: "application/fxx"

  element = CollectionTemplate self
  self.element = element

  return self
