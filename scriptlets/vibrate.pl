
use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();

dd($d->vibrate(10000));

say("done");

