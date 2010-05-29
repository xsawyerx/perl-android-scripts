use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();

dd($d->getInput("title", "text"));

# The 'result' will contain the string the user typed in
