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
Feedback
About
Help/Tips
Remove entry from "Collection"
Download buttons on history entries.
'Duplicate' button on history entries so people can fork and mutate effects they like.
Load and save collections as fxp files.
Rename items in collection, auto-sort by name.
Undo/Redo

TODONE
------
Editing the effect should be reflected in the collection items (update data re-render).

TOMAYBE
-------
Render spectrums from web workers?
Re-render spectrums on page resize.
