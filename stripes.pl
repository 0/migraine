#!/usr/bin/perl

use strict;
use warnings;

use GD;
use YAML::Any qw(LoadFile);


if (@ARGV < 1) {
	die "usage: $0 config.yml < input.txt > output.png";
}

# Load the settings.
my %s = %{LoadFile($ARGV[0])};

# Create a new image, the colours, and brush we'll be using.
my $img = GD::Image->new($s{width}, $s{height});

my %color;
$color{black} = $img->colorAllocate(0, 0, 0);
$color{white} = $img->colorAllocate(255, 255, 255);

$img->setThickness(1);

my $diagonal_brush = new GD::Image(2, 2);
$diagonal_brush->transparent($color{white});
$diagonal_brush->rectangle(0, 2, 0, 2, $color{black});
$img->setBrush($diagonal_brush);

# Generate stripes over the given rectangle.
sub stripify {
	my ($img, $x1, $y1, $x2, $y2, $rev) = @_;

	my ($width, $height) = ($x2 - $x1, $y2 - $y1);
	my ($down, $right, $dist);
	my ($x_start, $x_end, $y_start, $y_end);

	$img->filledRectangle($x1, $y1, $x2, $y2, $color{white});

	foreach (0 .. $width / 7) {
		$right = $width - $_ * 7;
		$dist = $right > $height ? $height : $right;

		$x_start = $x1 + $_ * 7;
		$y_start = $rev ? $y1 : $y2;
		$x_end = $x_start + $dist;
		$y_end = $y_start + $dist * ($rev ? 1 : -1);

		$img->line($x_start, $y_start, $x_end, $y_end, gdBrushed);
	}

	foreach (0 .. $height / 7) {
		$down = $height - $_ * 7;
		$dist = $width > $down ? $down : $width;

		$x_start = $x1;
		$y_start = $rev ? $y1 + $_ * 7 : $y2 - $_ * 7;
		$x_end = $x_start + $dist;
		$y_end = $y_start + $dist * ($rev ? 1 : -1);

		$img->line($x_start, $y_start, $x_end, $y_end, gdBrushed);
	}
}

# Draw reverse stripes over the entire image.
stripify($img, 0, 0, $s{width} - 1, $s{height} - 1, 1);

# Map each input character to an output block.
my ($x, $y) = (0, 0);
foreach (<STDIN>) {
	chomp;

	foreach (split //) {
		if ($_ ne ' ') {
			my $x1 = $s{block} * ($s{left} + $x);
			my $y1 = $s{block} * ($s{top} + $y);
			my $x2 = $s{block} * ($s{left} + $x + 1) - 1;
			my $y2 = $s{block} * ($s{top} + $y + 1) - 1;

			# Draw forward stripes over the block.
			stripify($img, $x1, $y1, $x2, $y2, 0);
		}

		++$x;
	}

	++$y, $x = 0;
}

# Attack the eyes.
print $img->png;
