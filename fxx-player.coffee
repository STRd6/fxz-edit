module.exports = (fxxBase64, context) ->
  context ?= new AudioContext

  parseName = (nameBuffer) ->
    lastNull = nameBuffer.indexOf(0)

    if lastNull >= 0
      nameBuffer = nameBuffer.slice(0, lastNull)

    name = new TextDecoder("utf-8").decode(nameBuffer)

  s = atob(fxxBase64).split("")

  l = s.length
  fxxData = new Uint8Array(l)

  n = 0
  while n < l
    fxxData[n] = s.charCodeAt(n)
    n += 1

  numEntries = Math.floor (l - 8) / 116

  # Populate data entries
  data = {}
  n = 0
  while n < numEntries
    # Parse Name
    p = n * 116 + 8
    name = parseName fxxData.slice(p, p + 16)

    # Synthesize Waveform
    buffer = fxxData.slice(p + 16, p + 116)
    data[name] = FXZ buffer.buffer, context
    n += 1

  FXZ.play = (name) ->
    audioBuffer = data[name]

    node = new AudioBufferSourceNode context,
      buffer: audioBuffer
    node.connect context.destination

    node.start()
