
use strict;
use warnings;

use GD::Simple;
use Math::Geometry::Voronoi;
use Getopt::ArgParse;

my $argparse = Getopt::ArgParse->new_parser(
	prog 		=> 'Perlonoi',
	description => 'Generates a voronoi diagram');

$argparse->add_arg('space_width', required => 1, help => "generation area width");
$argparse->add_arg('space_height', required => 1, help => "generation area height");
$argparse->add_arg('num_points', required => 1, help => "number of points to generate");
$argparse->add_arg('output_path', required => 1, help => "path where to write the png file");
$argparse->add_arg('--bin', '-b', required => 0,
	help => "if used, the program will output the polygons to a binary file");

my $args = $argparse->parse_args();

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

@points = generate_points($args->space_width, $args->space_height, $args->num_points);

my $geo = Math::Geometry::Voronoi->new(points => \@points);
$geo->compute;

my $lines = $geo->lines;
my $edges = $geo->edges;
my $vertices = $geo->vertices;

my @polygons = $geo->polygons;

my $img = GD::Simple->new(4096, 4096);
$img->bgcolor('red');
$img->fgcolor('blue');

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

foreach my $polygon (@polygons)
{
	draw_polygon($polygon);
}

open my $out, '>', $args->output_path or die;
binmode $out;
print $out $img->png;
