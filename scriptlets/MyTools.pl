use strict;
use warnings;

use Data::Dumper;

sub dd {
    print Dumper shift;
}
sub say {
	print @_, "\n";
}

1;

