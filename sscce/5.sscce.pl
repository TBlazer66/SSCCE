#!/usr/bin/perl -w
use 5.011;
use Path::Tiny;
use lib "lib";
use Data::Dump;
binmode STDOUT, 'utf8';
use crossword2;    #available on github

my $path_to_file   = path( "mydata", "1.txt" );
my $path_to_output = path( "mydata", "1.out.txt" );

# moving forward with slurp method
my $input = $path_to_file->slurp;
$input =~ s/\t/ /g;
my @lines = split /\n/, $input;
my $out = make_rectangular( \@lines, 4, 6 );
say "before conversion";
dd $out;
$out = [ map { [ split // ] } @$out ];    #convert reference
say "after conversion";
dd $out;
## tests
use Test::More tests => 16;

# unchanged from haukex's tests
is_deeply rangeparse("R1"), [ 1,  1,  1,  -1 ];
is_deeply rangeparse("C1"), [ 1,  1,  -1, 1 ];
is_deeply rangeparse("Rn"), [ -1, 1,  -1, -1 ];
is_deeply rangeparse("Cn"), [ 1,  -1, -1, -1 ];

# new values
is_deeply rangeparse("C1:C3"),     [ 1, 1, -1, 3 ];
is_deeply rangeparse("R2:Rn"),     [ 2, 1, -1, -1 ];
is_deeply rangeparse("C3:Cn"),     [ 1, 3, -1, -1 ];
is_deeply rangeparse("R1C3:R1C5"), [ 1, 3, 1,  5 ];
is_deeply rangeparse("R4C1:R4C3"), [ 4, 1, 4,  3 ];

# initialize full block character
my $char = "\N{FULL BLOCK}";
say "char is $char";

{
  say "inside first anonymous block";
  my $subset = getsubset( $out, "R1" );
  is_deeply $subset, [ [ 'a' .. 'f' ] ];
  say "exiting first anonymous block";
}
say "----------";
dd $out;
say "----------";
{
  my $subset = getsubset( $out, "C1" );
  dd $subset;
  is_deeply $subset, [ ['a'], ['a'], ['a'], [' '] ];
  $subset->[3][0] = $char;
  dd $subset;
  say "exit 2nd";
}
say "----------";
dd $out;
say "----------";

is_deeply $out,
  [
  [ "a" .. "f" ],
  [ "a" .. "f" ],
  [ "a" .. "e", " " ],
  [ "\x{2588}", "b" .. "f" ],
  ];
say "----------";
{
  my $subset = getsubset( $out, "R2C2" );
  is_deeply $subset, [ ['b'] ];
  $subset->[0][0] = 'q';
}
say "----------";
is_deeply $out,
  [
  [ "a" .. "f" ],
  [ "a",        "q", "c" .. "f" ],
  [ "a" .. "e", " " ],
  [ "\x{2588}", "b" .. "f" ],
  ];

dd $out;
say "----------";
say "let's blacken the space in the last column";
{
  my $subset = getsubset( $out, "Cn" );
  dd $subset;
  is_deeply $subset, [ ['f'], ['f'], [' '], ['f'] ];
  $subset->[2][0] = $char;
  dd $subset;

}
say "----------";
say "let's see if it shows in row 3";
{

  my $subset = getsubset( $out, "R3" );
  is_deeply $subset, [ [ 'a' .. 'e', $char ] ];
  dd $subset;
}
say "----------";
print_aoa($out);
say "----------";
print_aoa_utf8($out);
done_testing();
# output
my $file_handle = $path_to_output->openw_utf8();

for my $row (@$out) {
  my $line = join( "", @{$row}, "\n" );
  dd unpack 'C*', $line;
  $file_handle->print($line);
}

__END__ 
