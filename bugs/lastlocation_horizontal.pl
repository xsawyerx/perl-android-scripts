# this script shows how getLastKnownLocation disables the
# horizontal progress bar.
use strict;
use warnings;

use Android;

my $droid = Android->new();
$droid->getLastKnownLocation();

eval {
    local $SIG{'ALRM'} = sub { die "alarm\n" };
    alarm 12;
    print 'Sleep test... ';

    my $title   = 'Horizontal';
    my $message = 'This tests shows a bug with this progress bar';
    $droid->dialogCreateHorizontalProgress( $title, $message, 10 );
    $droid->dialogShow();
    for my $x ( 0 .. 10 ) {
      sleep 1;
      $droid->dialogSetCurrentProgress($x);
    }

    $droid->dialogDismiss();

    alarm 0;
};


if ($@) {
    if ( $@ eq "alarm\n" ) {
        print "FAIL\n";
    }
} else {
    print "PASS\n";
}
