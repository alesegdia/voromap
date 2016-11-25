
use strict;
use warnings;

use GD::Simple;
use Math::Geometry::Voronoi;
use Data::Dumper;

sub generate_points {
	my $width = $_[0];
	my $height = $_[1];
	my $num_points = $_[2];
	my @points = ();

	while( $num_points >= 0 )
	{
		unshift( @points, [ rand($width), rand($height) ] );
		$num_points--;
	}

	return @points;
}

my @points = (
	[10, 20],
	[10, 30],
	[20, 20],
	[40, 10],
	[50, 20],
	[20, 40]);

@points = generate_points(4096, 4096, 4096);

my $geo = Math::Geometry::Voronoi->new(points => \@points);
$geo->compute;

my $lines = $geo->lines;
my $edges = $geo->edges;
my $vertices = $geo->vertices;

my @polygons = $geo->polygons;

my $img = GD::Simple->new(4096, 4096);
$img->bgcolor('red');
$img->fgcolor('blue');


foreach my $polygon (@polygons)
{
	draw_polygon($polygon);
}

sub draw_polygon {
	my @polygon = $_[0];
	my $element = $polygon[0];
	shift($element);
	my $num_points = scalar(@$element);
	for( my $i = 0; $i < $num_points-1; $i++ )
	{
		my $from = @$element[$i];
		my $to = @$element[$i+1];
		$img->moveTo(@$from[0], @$from[1]);
		$img->lineTo(@$to[0], @$to[1]);
	}
}

open my $out, '>', 'img.png' or die;
binmode $out;
print $out $img->png;
