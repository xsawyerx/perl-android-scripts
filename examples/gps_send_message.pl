#!/data/data/com.google.ase/perl/perl
#
# Copyright 2010 Alex Elder (http://www.alexelder.co.uk)
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.
#
# A simple Perl script designed to run under the Android Scripting Environment:
# http://code.google.com/p/android-scripting. Designed to dispatch a text
# message when the phone's position matches the position entered by the user.
# For best results, start this program as a service.
#
# Text messages support 'tags' which are substituted for values before the
# message is sent. Currently supported tags are: 
#
#   admin_area 
#   country_code
#   country_name 
#   feature_name 
#   locality
#   postal_code
#   thoroughfare
#   sub_admin_area
#   map_link
#
# All tags must start and end with a '%' (percentage) sign. For example,
# if you would like to send a message as soon as you entered Cheshire to a
# chosen contact, and within that message you'd like to embed your current
# county and a Google Maps link, you could enter something similar to:
#
#   "Hi, I'm just entering %admin_area% now; link: %map_link%. See you soon!" 
#
# The tags in the above example would be substituted for their actual values:
# 
#   "Hi, I'm just entering Cheshire now; link:
#   http://maps.google.com/maps?q=53.800651,-4.064941. See you soon!"
#
use strict; 
use warnings;

use Android;
use Carp;

use constant {
    LOOP_DELAY    => 180, # seconds to sleep between checking GPS position
    MAX_ATTEMPTS  => 250, # number of match-loop iterations before giving up
    SPEAK_ON_SEND => 1,   # speak using TTS when the message is sent
    MAP_LINK      => 'http://maps.google.com/maps?q=%s,%s', # map link (message 'tag')
};

my $droid = Android->new();

$droid->makeToast('Select a contact');

my $contact;

# Select a contact
$contact = $droid->pickPhone();

if ( ! defined $contact->{result} ) {

    $droid->makeToast('Please select a contact');
    $contact = $droid->pickPhone();

    exit if defined $contact->{error};
}

$contact = $contact->{result};

# Enter a message for the chosen contact
my $message_to_contact = $droid->getInput('Message', 'Message to selected contact');

if ( defined $message_to_contact->{error} || ! defined $message_to_contact->{result} ) {

    $droid->makeToast('No message entered. Please enter a message.');
    $message_to_contact = $droid->getInput('Message', 'Message to be sent to contact upon arrival');

    exit if defined $message_to_contact->{error} || ! defined $message_to_contact->{result};
}

$message_to_contact = $message_to_contact->{result};

# Message authors can embed 'tags' that are substituted before a message is sent
# to the chosen contact. The tag start and end markers are '%' and '%'
# respectively.
my @gps_keys = qw/ 
    admin_area 
    country_code 
    country_name 
    feature_name 
    locality
    postal_code
    thoroughfare
    sub_admin_area
/;

# Create a dialog and present it to the user. They need to select which area
# they'd like their location matched against. This is a potential 'non-slick' as
# it'd be much nicer to use a Maps instance and geocode a screen tap, rather
# than asking for someone to enter text. However, seems the Map application
# starts itself in a new task when launched, making is *very* hard to get the
# return value. For more information, please read: http://bit.ly/a7krNU.

# Create a UI component and force the user to select a GPS zone to match on:
$droid->dialogCreateAlert('Match location using...');
$droid->dialogSetItems(\@gps_keys);
$droid->dialogShow();

my $match_key = $droid->dialogGetResponse();

exit if ! defined $match_key->{result}->{item};

if ( $match_key->{result}->{item} >= 0 && $match_key->{result}->{item} <= scalar @gps_keys ) {
    $match_key = $gps_keys[$match_key->{result}->{item}];
}
else {
    # use the first element in the allowed tags list as the default matching method
    $match_key = $gps_keys[0];
}

# Add the 'map_link' here, rather than above because the map link isn't a GPS
# result - however it is a valid substitution tag, used for inserting a Google
# Maps URI.
push @gps_keys, 'map_link';

# Enter destination
my $destination = $droid->getInput('Destination', 'Please enter your destination');

if ( defined $destination->{error} || ! defined $destination->{result} ) {

    $droid->makeToast('No destination entered. Please enter a destination.');
    $destination = $droid->getInput('Destination', 'Please enter your destination');

    exit if defined $destination->{error} || ! defined $destination->{result};
}

$destination = $destination->{result};

# When using the selected text input, the input keyboard will often suggest a
# word and add a space after the selected word, so remove any trailing whitespace
# here for convenience.
$destination =~ s/\s+$//;

# Keep a count of how many times the script's looped around while attempting to
# find a match.
my $attempts = 0;

my ($location, $longitude, $latitude, $geocode);

$droid->startLocating();

# give the GPS sensor a chance to wake up
sleep 15;

CHECK_LOCATION:
while ( $attempts++ <= MAX_ATTEMPTS ) {

    $location = $droid->readLocation() || $droid->getLastKnownLocation();

    if ( defined $location->{error} ) {

        print STDERR "location error: $location->{error}\n";
        next CHECK_LOCATION;
    }

    $longitude = $location->{result}->{network}->{longitude};
    $latitude  = $location->{result}->{network}->{latitude};

    $geocode = $droid->geocode($latitude, $longitude);

    if ( defined $geocode->{error} ) {

        print STDERR "geocode error: $geocode->{error}\n";
        next CHECK_LOCATION;
    }

    foreach my $address ( @{ $geocode->{result} } ) {

        if ( $address->{$match_key} =~ /$destination/i ) {

            # add a maps link to the address hash
            my $map_link = sprintf(MAP_LINK, $latitude, $longitude);
            $address->{map_link} = $map_link;

            # replace special tags in the input messages
            $message_to_contact =~ s/%*$_*%/$address->{$_}/g for @gps_keys;

            print "successfully matched $address->{$match_key} against $destination\n";
            print "sending: '$message_to_contact' to contact $contact\n";

            $droid->smsSend($contact, $message_to_contact);
            $droid->speak("Message sent to contact after $attempts attempts.") if SPEAK_ON_SEND == 1;

            last CHECK_LOCATION;
        }
    }

    sleep LOOP_DELAY;
}

exit;
