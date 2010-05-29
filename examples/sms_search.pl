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
# A simplistic example, demonstrating how to implement a simple search tool
# using ASE and Perl.
#
use strict; 
use warnings;

use Android;
use Carp;
use Data::Dumper;

use constant {
    INPUT_TITLE   => 'Search String',
    INPUT_MESSAGE => 'Enter a search string or Perl regex:',
};

my $droid    = Android->new();
my $messages = $droid->smsGetMessages(0, 'inbox', ['body', 'thread_id']);

croak "Unable to retreive SMS messages" if defined $messages->{error};

my $search_string = $droid->getInput(INPUT_TITLE, INPUT_MESSAGE);

if ( defined $search_string->{error} ) {

    $droid->makeToast('No search string entered; try again...');
    $search_string = $droid->getInput(INPUT_TITLE, INPUT_MESSAGE);

    exit if defined $search_string->{error};
}

$search_string = qr/$search_string->{result}/;

my @matches;

foreach my $message ( @{ $messages->{result} } ) {

    if ( $message->{body} =~ $search_string ) {

        push @matches, $message;
    }
}

if ( ! @matches ) {

    $droid->makeToast("No matches found for '$search_string'");
    exit;
}
else {

    $droid->makeToast("Found " . scalar @matches . " matches!");
}

# Extract just the body part from each message and display it on the UI using
# the index within @matches as the return ID from the UI component:
$droid->dialogCreateAlert('Search Results');
$droid->dialogSetItems([ map { $_->{body} } @matches ] );
$droid->dialogShow();

my $selected_search_result = $droid->dialogGetResponse();

if ( defined $selected_search_result->{error} ) {

    $droid->makeToast('Invalid choice; exiting');
    $droid->exit();
}
else {
    $selected_search_result = $selected_search_result->{result}->{item};
}

my $sms_thread_id = $matches[$selected_search_result]->{thread_id};

# FIXME: This needs addressing. Currently, the below URI will navigate to the
# correct message thread, however it will not navigate to the correct message
# *within* the given thread. I'm not too sure how to do this, and it doesn't
# seem to be too well documented.
$droid->startActivity('android.intent.action.VIEW', "sms://view/conversations/$sms_thread_id");

$droid->exit();
