use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;

my $d = Android->new();
my $loc =  $d->getLastKnownLocation();
dd($loc);
say($loc->{result}->{longitude});
# fields  are provider, time, longitude, latitude, speed, accuracy, altitude
# the provider is a string -  I got 'network' the others are numbers
