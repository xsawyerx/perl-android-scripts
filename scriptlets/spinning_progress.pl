
use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();

my $max = 32;

$d->dialogCreateSpinnerProgress(
   "title",
   "message",
   $max,  # maximum progress (shows a number 0/$max)
   0,   # boolean, cancellable (Bug: I don't see any difference if I set it to 1)
);
dd($d->dialogShow);
my $n = 0;
while ($n < $max) {
	sleep 1;
	$n += int rand 7;
	$n = $n > $max ? $max : $n;
	$d->dialogSetCurrentProgress($n);
}

dd($d->dialogDismiss);


