# Running Plack on Android using ASE
# Originally written by Stevan Little (minor cleanups by Sawyer X)
# Copied here with explicit permission
# (thank you Stevan :)

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

