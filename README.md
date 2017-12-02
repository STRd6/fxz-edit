fxz-edit
========

A web based editor for fxz data, like jsfxr.

Notes
-----

For next version of data format we can see what it's like if we humanize the
units. Since floats have a fairly good range of numbers they can represent it
would be interesting to see what things look like if we measure envelope params
in seconds, freq in hz, etc.

We can even use the sign bits to sneak in extra booleans.

TODO
----

Download a .js that embeds the synth, the sounds (base64), and a mapping api for easy use in games / standalone.
Remove entry from "Collection"
Editing the effect should be reflected in the history items (update data re-render).
'Duplicate' button on history entries so people can fork and mutate effects they like.
Re-render spectrums on page resize.
Download buttons on history entries.
Download a 'whole pack' of fxz. Just 100 byte fxz with name metadata.
Rename items in history, auto-sort by name.
Maybe change "History" to "Collection"
Undo/Redo
Load and save collections

TOMAYBE
-------
Render spectrums from web workers?
