use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use Android;
my $d = Android->new();


dd($d->dialogCreateAlert("the title", "text"));
dd($d->dialogShow);

say("Still running");
sleep(3);

dd($d->dialogDismiss); #forcibly eliminate the dialog even if it was not clicked on

dd($d->dialogGetResponse);


