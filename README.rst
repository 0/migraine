migraine
========

Transform boring monochrome bitmaps into dazzling monochrome graphics!

Usage
=====

The two components work as follows::

    ./bitmap2ascii.pl input.bmp > output.txt
    ./stripes.pl config.yml < input.txt > output.png

They can naturally be combined by means of a pipe::

    ./bitmap2ascii.pl input.bmp | ./stripes.pl config.yml > output.png

Configuration
=============

The image configuration files are YAML documents with the following keys:

* ``width``, ``height``: The dimensions (in pixels) of the resulting image.
* ``block``: The length of side of each block (in pixels) in the resulting image, corresponding to the pixels of the original image. Effectively, the linear magnification factor.
* ``left``, ``top``: The offsets (in pixels) of the original image within the resulting image.

Examples
========

Sources for the following images are included.

Infinity
--------

.. image:: http://0.github.com/migraine/examples/infinity.png

Pi
--

.. image:: http://0.github.com/migraine/examples/pi.png

License
=======

This software is released under the FreeBSD (2-clause BSD) license. See the LICENSE file for details.
