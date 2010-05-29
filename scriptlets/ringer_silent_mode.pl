use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();


dd($d->checkRingerSilentMode); # result is a JSON::PP::Boolean object that stringifies to "true" or "false"
say($d->checkRingerSilentMode->{result});

dd($d->toggleRingerSilentMode(1));
say($d->checkRingerSilentMode->{result});                   # true
say($d->checkRingerSilentMode->{result} ? 'ON' : 'OFF');    # ON

dd($d->toggleRingerSilentMode(0));
say($d->checkRingerSilentMode->{result});                   # false
say($d->checkRingerSilentMode->{result} ? 'ON' : 'OFF');    # OFF

