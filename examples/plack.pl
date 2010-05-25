# Running Plack on Android using ASE
# Originally written by Stevan Little (minor cleanups by Sawyer X)
# Copied here with explicit permission
# (thank you Stevan :)

# Stevan also notes that he had to make the following modules available
# in order to make this work:
# - Devel-StackTrace-1.22.tar.gz
# - Devel-StackTrace-AsHTML-0.09.tar.gz
# - FileHandle.pm
# - HTTP-Body-1.07.tar.gz
# - HTTP-Server-Simple-0.42.tar.gz
# - Hash-MultiValue-0.08.tar.gz
# - PathTools-3.31.tar.gz
# - PerlIO.pm
# - Plack-0.9929.tar.gz
# - Pod-Parser-1.38.tar.gz
# - Time-Local-1.1901.tar.gz
# - Try-Tiny-0.04.tar.gz
# - URI-1.54.tar.gz
# - integer.pm
# - libwww-perl-5.834.tar.gz
# - parent-0.223.tar.gz

use strict;
use warnings;

use Android;
use Plack::Runner;
use Plack::Request;

my $droid  = Android->new();
my $runner = Plack::Runner->new();

$runner->parse_options( qw(
    --server HTTP::Server::PSGI
    --port   8888
) );

$runner->run( sub {
    my $env = shift;
    my $req = Plack::Request->new( $env );

    if ( my $phone_number = $req->param('phone_number') ) {
        $a->callNumber( $phone_number );

        return [
            200,
            [ 'Content-Type' => 'text/html' ],
            [ qq(
                <html>
                    <head>
                        <title>Plack On Droid</title>
                    </head>
                    <body>
                        <p>Calling $phone_number ...</p>
                    </body>
                </html>
            ) ],
        ];
    } else {
        return [
            200,
            [ 'Content-Type' => 'text/html' ],
            [ q(
                <html>
                    <head>
                        <title>Plack On Droid</title>
                    </head>
                    <body>
                        <form>
                            Enter a phone number to call<br/>
                            <input type="text" name="phone_number" />
                            <input type="submit" value="Go" />
                        </form>
                    </body>
                </html>
            ) ],
        ];
    }
} );

