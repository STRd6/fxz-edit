module.exports = (buffer, canvas) ->
  sampleRate = 44100
  xScale = 0.1
  width = buffer.length * xScale
  height = 200

  canvas.width = width
  canvas.height = height

  context = canvas.getContext('2d')

  context.fillStyle = "black"
  context.fillRect(0, 0, width, height)

  # Plot time markers
  context.lineWidth = 1
  context.fillStyle = "#FFF"

  numberOfMarks = buffer.length / (sampleRate / 4)
  n = 0
  while n < numberOfMarks
    n += 1
    x = n * xScale * sampleRate / 4
    context.fillRect(x, 0, 1, height)

  context.lineWidth = 2
  context.strokeStyle = "#F00"

  # Plot time domain
  buffer.forEach (value, index) ->
    x = index * xScale
    y = height * (value + 1) / 2

    if index is 0
      context.beginPath()
      context.moveTo x, y
    else
      context.lineTo x, y

  context.stroke()

  return canvas
