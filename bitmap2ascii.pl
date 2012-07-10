#!/usr/bin/perl

use strict;
use warnings;

use Image::BMP;


if (@ARGV < 1) {
	die "usage: $0 input.bmp > output.txt"
}

my $img = new Image::BMP(file => $ARGV[0]);
$img->view_ascii;
