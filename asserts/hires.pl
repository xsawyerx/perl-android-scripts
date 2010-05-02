use strict;
use warnings;

use Time::HiRes 'sleep';

eval {
    local $SIG{'ALRM'} = sub { die "alarm\n" };
    alarm 1;
    print 'Sleep test... ';
    sleep 0.1;
    alarm 0;
};

if ($@) {
    if ( $@ eq "alarm\n" ) {
        print "FAIL\n";
    }
} else {
    print "PASS\n";
}
