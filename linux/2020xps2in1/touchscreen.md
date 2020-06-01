# Touchscreens

* Touchscreens have a kernel driver, which passes input data to `libinput`. `libinput` standardizes the format and option settings, and passes the data to XWindows/Wayland. In XWindows, it's up to the individual application to implement touchscreen gestures.
  * eg Firefox has gesture support
* You can run an application like Touchegg or Easystroke, which will intercept all strokes and try to match them with global gestures. This prevents the gesture from going any "further", eg into an application. 
* My touchscreen is a Wacom device, so libwacom provides the kernel interface to it.
  * libwacom can optionally interpret gestures, but it's limited to up to two fingers. Gestures recognized this way are received as software "button" clicks. It is recommended to leave these Gestures disabled, and let libinput do it's damn job.
* Handy tools for libinput: https://people.freedesktop.org/~whot/libinput-rtd/tools.html
* libinput debug-gui shows me that everything works and is properly detected on my touchscreen. I just need an interpreter.
  * Easystroke only seems to register one finger at a time. That's no good.
  * 

## Editor options

### Okular

* Button navigation for prev/next page is OK
* No touchscreen navigation (only pinch/zoom)
* No stylus support - acts like mouse
* No freehand drawing

## Xournalpp

* pinch/zoom is unusably buggy
* scroll only works with flicks, not stroke
* no prev/next page by swipe, only by button

## Xournal

* Good pen support, option for "touchscreen as hand tool"
* No pinch/zoom
* No prev/next page by swipe, only by button

