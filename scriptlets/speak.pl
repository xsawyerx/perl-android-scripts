
use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();

dd($d->speak("hello Android from Perl"));

say("done");

