use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;

my $d = Android->new();
dd($d->startSensing);

my $l = $d->readLocation;
dd($l);

# this gives the hash- or arrayref expected (not a simple scalar, use allow_nonref to allow this)
dd($d->geocode(52.5, 13.5));

