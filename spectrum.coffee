module.exports = (buffer) ->
  width = buffer.length
  height = 200

  canvas = document.createElement "canvas"
  canvas.width = width
  canvas.height = height

  context = canvas.getContext('2d')

  context.lineWidth = 2
  context.strokeStyle = "#F00"

  # Plot time domain
  buffer.forEach (value, index) ->
    x = index
    y = height * (value + 1) / 2

    if index is 0
      context.beginPath()
      context.moveTo x, y
    else
      context.lineTo x, y

  context.stroke()

  return canvas
