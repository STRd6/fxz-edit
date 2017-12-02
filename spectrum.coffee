module.exports = (buffer, canvas, displayWidth, displayHeight=200) ->
  sampleRate = 44100
  xScale = displayWidth / buffer.length
  width = displayWidth
  height = displayHeight

  timeDomainColor = "#F00"
  backgroundColor = "black"

  canvas.width = width
  canvas.height = height

  context = canvas.getContext('2d')

  context.fillStyle = backgroundColor
  context.fillRect(0, 0, width, height)

  context.lineWidth = 2
  context.strokeStyle = timeDomainColor

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

  # Plot time markers
  context.lineWidth = 1
  context.fillStyle = "rgba(255, 255, 255, 0.75)"

  marksPerSecond = 16

  numberOfMarks = buffer.length / (sampleRate / marksPerSecond)
  n = 0
  while n < numberOfMarks
    n += 1
    t = n / marksPerSecond
    x = t * xScale * sampleRate
    context.fillRect(x, 0, 1, height)
    context.fillText("#{t}", x + 6, 12)

  return canvas
