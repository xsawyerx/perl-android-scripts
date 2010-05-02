use strict;
use warnings;

use Android;
use Time::HiRes 'sleep';

my $droid  = Android->new();
my $result = $droid->getLastKnownLocation();

eval {
    local $SIG{'ALRM'} = sub { die "alarm\n" };
    alarm 10;
    print 'Sleep test... ';

    my $title   = 'Time::HiRes on horizontal';
    my $message = 'This tests whether Time::HiRes works with this progress bar';
    $droid->dialogCreateHorizontalProgress( $title, $message, 10 );
    $droid->dialogShow();
    for my $x ( 0 .. 50 ) {
      sleep 0.1;
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
