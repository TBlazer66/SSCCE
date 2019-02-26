#!/usr/bin/perl -w
use 5.011;
use Path::Tiny;
use lib "lib";
use Data::Dump;

my $path_to_file = path( "lib", "1.txt" );
my $guts = $path_to_file->slurp;
say "return1 is ";
say "$guts";
my @lines = $path_to_file->slurp;
say "return2 is ";
say "@lines";
my $ref_lines = \@lines;
my $width     = 6;
my $length    = 4;
my $ref_array = make_rectangular1( $guts, $width, $length );

#dd $ref_array;

sub make_rectangular1 {
  my ( $guts, $width, $length ) = @_;

  my $ref_array = "nothing yet";
  return $ref_array;
}

sub make_rectangular2 {
  my ( $ref_array, $width, $length ) = @_;
  my @new_array = @$ref_array;
  say "new array is ";
  say "@new_array";

  #my $ref_array = "nothing yet";
  return $ref_array;
}

__END__ 
