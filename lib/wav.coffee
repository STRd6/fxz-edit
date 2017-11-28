RIFFWAVE = require "./riffwav"

createWavData = (samples, eightBit=false) ->
  if eightBit
    bitsPerSample = 8
    buffer = new Uint8Array(samples.length)
  else
    bitsPerSample = 16
    buffer = new Uint8Array(samples.length * 2)

  clipCount = 0

  samples.forEach (sample, i) ->
    if eightBit
      # Rescale [-1, 1) to [0, 256)
      sample = Math.floor((sample + 1) * 128)
      if sample > 255
        sample = 255
        ++clipCount
      else if sample < 0
        sample = 0
        ++clipCount

      buffer[i] = sample
    else
      # Rescale [-1, 1) to [-32768, 32768)
      sample = Math.floor(sample * (1<<15))
      if sample >= (1<<15)
        sample = (1 << 15)-1
        ++clipCount
      else if sample < -(1<<15)
        sample = -(1 << 15)
        ++clipCount

      buffer[2 * i] = sample & 0xFF
      buffer[2 * i + 1] = (sample >> 8) & 0xFF

  buffer: buffer
  clipCount: clipCount
  bitsPerSample: bitsPerSample

module.exports = (samples, sampleRate=44100) ->
  {buffer, clipCount, bitsPerSample} = createWavData(samples)

  wave = new RIFFWAVE()
  wave.header.sampleRate = sampleRate
  wave.header.bitsPerSample = bitsPerSample

  return wave.Make(buffer)
