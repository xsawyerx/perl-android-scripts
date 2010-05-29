use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";

use IO::Socket;

use Android;
my $d = Android->new();


my $site  = 'http://perl.org/';

dd($d->getInput("URL", "Default: $site"));
say(get($site));


sub get {
	my ($url) = @_;

	my $host = $url;
	$host =~ s{http://}{};
	$host =~ s{/.*}{};
	#print "$host\n";
	
	my $port = 80;
	my $CRLF = "\015\012";
	my $SIZE = 100;
	my $data = '';
	
	my $socket = IO::Socket::INET->new(
	   PeerAddr => $host,
	   PeerPort => $port,
	   Proto    => 'tcp',
	) or die $!;
	
	
	$socket->send("GET $url$CRLF") or die $!;
	#print "sent\n";
	
	while ($socket->read($data, $SIZE, length($data)) == $SIZE) {
	}

	return $data;
}

