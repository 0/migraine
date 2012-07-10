#!/usr/bin/perl

use strict;
use warnings;

use GD;
use YAML::Any qw(LoadFile);


if (@ARGV < 1) {
	die "usage: $0 config.yml < input.txt > output.png";
}

my %settings = %{LoadFile($ARGV[0])};

my ($width, $height, $block, $top, $left) = map { $settings{$_} } qw(width height block top left);

my $img = GD::Image->new($width, $height);

my $black = $img->colorAllocate(0, 0, 0);
my $white = $img->colorAllocate(255, 255, 255);

$img->setThickness(1);

my $diagonal_brush = new GD::Image(2, 2);
$diagonal_brush->transparent($white);
$diagonal_brush->rectangle(0, 2, 0, 2, $black);
$img->setBrush($diagonal_brush);

sub stripe {
	my ($img, $x1, $y1, $x2, $y2, $rev) = @_;

	my ($width, $height) = ($x2 - $x1, $y2 - $y1);
	my ($down, $right, $dist);

	($x1, $y1, $x2, $y2) = map { $_ - 1 } ($x1, $y1, $x2, $y2);

	$img->filledRectangle($x1, $y1, $x2, $y2, $white);

	$rev = defined $rev && $rev;

	foreach (0 .. $width / 7) {
		$right = $width - $_ * 7;
		$dist = $right > $height ? $height : $right;

		$img->line($x1 + $_ * 7, ($rev ? $y1 : $y2), $x1 + $_ * 7 + $dist, ($rev ? $y1 + $dist: $y2 - $dist), gdBrushed);
	}

	foreach (0 .. $height / 7) {
		$down = $height - $_ * 7;
		$dist = $width > $down ? $down : $width;

		$img->line($x1, ($rev ? $y1 + $_ * 7 : $y2 - $_ * 7), $x1 + $dist, ($rev ? $y1 + $dist + $_ * 7 : $y2 - $dist - $_ * 7), gdBrushed);
	}
}

stripe($img, 1, 1, $width, $height, 1);

my ($x, $y) = (0, 0);
foreach (<STDIN>) {
	chomp;

	foreach (split //) {
		if ($_ ne ' ') {
			stripe($img, $block * ($left + $x) + 1, $block * ($top + $y) + 1, $block * ($left + $x + 1), $block * ($top + $y + 1));
		}

		++$x;
	}

	++$y, $x = 0;
}

print $img->png;
