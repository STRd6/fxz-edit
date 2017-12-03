module.exports = (self) ->
  listeners = {}

  Object.assign self,
    on: (type, listener) ->
      listeners[type] ?= []
      listeners[type].push listener

      return self

    off: (type, listener) ->
      activeListeners = listeners[type]

      if activeListeners
        remove(activeListeners, listener)

    trigger: (type, args...) ->
      listeners[type]?.forEach (listener) ->
        listener.apply(self, args...)

# Array util remove
remove = (array, item) ->
  index = array.indexOf item

  if index >= 0
    return array.splice(index, 1)[0]
