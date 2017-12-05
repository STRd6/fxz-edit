###
Convert an fxx file into a standalone JS that can be embedded in pages.

Returns a string representing a JS program that can be included in a script tag


###
module.exports = (fxxBuffer) ->
  fxzSrc = PACKAGE.dependencies.fxz.distribution.fxz.content
  serializerSrc = PACKAGE.dependencies.fxz.distribution.serializer.content

  src = fxzSrc.replace 'module.exports', "FXZ"
  .replace 'require("./serializer")', serializerSrc.replace("module.exports =", "return")

  fxxData = ""
  l = fxxBuffer.byteLength
  bytes = new Uint8Array fxxBuffer
  while n < l
    fxxData += String.fromCharCode(bytes[n])
    n += 1
  data = JSON.stringify(btoa(fxxData))

  # TODO: Add data
  program = PACKAGE.distribution["fxx-player"].content.replace("module.exports =", "return") + "(#{data})"

  src += program

  {code} = butternut.squash src,
    check: true
    sourceMap: false

  return code
