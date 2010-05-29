use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();


dd($d->dialogCreateAlert("the title", "text"));
dd($d->dialogSetPositiveButtonText("good"));
dd($d->dialogSetNegativeButtonText("bad"));
dd($d->dialogSetNeutralButtonText("ugly"));
dd($d->dialogShow);

say("Still running");

dd($d->dialogGetResponse);

# This call waits for someone to press a button
# the result is a hash with one pair. The key is "which".
# The value is one of the following:
# "neutral", "negative", "positive"

