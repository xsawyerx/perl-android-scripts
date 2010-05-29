use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();
dd($d->startLocating("fine", 600, 30)); #coarse
#dd($d->startSensing);
for (1..20) {

	my $loc;
    print "READ LOCATION:\n";
    dd($d->readLocation); 
    print "LAST_KNOWN_LOCATION:\n";
    dd($d->getLastKnownLocation());
#$d->readSensors;
	#say("Long $loc->{result}->{longitude}  Lat: $loc->{result}->{latitude}");
	sleep 2;
}

