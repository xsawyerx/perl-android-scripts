use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;

my $d = Android->new();
say($d);      # HASH()
dd($d);        # Android object { conn => Symbol::GEN, IO::Socket::INET, id => 0 }

