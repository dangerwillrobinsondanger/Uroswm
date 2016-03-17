Uroswm is a window manager written in objective-c on GNUstep,with Xlib.
===========

Goals: <br />

1) The first goal is to make Uroswm able to move a window on the screen <br />
2) Window resizing, minimizing; (fullscreen too?) <br />
3) Accomplish the first two before... <br />

===========

Build: <br />
======
To build uroswm you need to install: <br />

1) Xlib <br />

In the uroswm folder type: <br />

$ make <br />

===========

Test: <br />
=====
I test uroswm with Xephyr, so you need to install it.<br />

$ Xephyr -ac -screen 800x600 -reset :1 & <br />
$ DISPLAY=:1 <br />
$ cd obj <br />
$ ./uroswm & <br />

===========

How it works
============
To move a window: alt + left-click and drag the window. <br />
To resize a window: alt + right-click and drag for resizing <br />

============

Contribution: <br />
=============
Fork, write code, test it, report problems and do Pull Request or report Issues. <br />
Any help is welcome. <br />

Enjoy. <br />
