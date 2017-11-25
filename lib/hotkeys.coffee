module.exports =
  # Add a global hotkey that won't trigger inside input element types
  # TODO: Handle modifier keys
  # TODO: Some modifier and special keys will trigger inside text input, like
  # ctrl + s and F6
  add: (hotkey, fn) ->
    window.addEventListener "keydown", (e) ->
      {key, defaultPrevented} = e
      return if defaultPrevented
  
      if key is hotkey
        types = ["text", "password", "file", "search", "email", "number", "date", "color", "datetime", "datetime-local", "month", "range", "search", "tel", "time", "url", "week"]
        source = event.srcElement or event.target
        disabled = source.getAttribute("readonly") or source.getAttribute("disabled")
        abort = false
  
        unless disabled
          if source.isContentEditable
            abort = true
          else if source.tagName is "INPUT"
            type = source.type?.toLowerCase()
  
            if types.indexOf(type) > -1
              abort = true
  
          else if source.tagName is "TEXTAREA"
            abort = true
  
        unless abort
          e.preventDefault()
          fn()
