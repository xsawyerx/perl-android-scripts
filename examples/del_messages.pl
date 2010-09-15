#!/usr/bin/perl
use strict; use warnings;

#######################################################################
# LICENSE AND COPYRIGHT
# --------------------- 
#
# Copyright (c) 2010 Rohan Almeida <rohan@almeida.in>
# All rights reserved.
#######################################################################

use Android;
use Carp;
use Data::Dumper;

my $droid  = Android->new();
my $unread_messages = $droid->smsGetMessages(1, 'inbox', ['body', '_id', 'thread_id',
    'read']);
croak "Unable to retreive SMS messages" if defined $unread_messages->{error};

#print Dumper $droid->smsGetAttributes();

my @unread_msgs = @{ $unread_messages->{result} };
my %unread_map;
for (my $i = 0; $i < scalar @unread_msgs; $i++) {
    $unread_map{$i} = $unread_msgs[$i]->{_id};
}
#die Dumper \%unread_map;

$droid->dialogCreateAlert('Unread Messages');
$droid->dialogSetPositiveButtonText('Delete');
$droid->dialogSetNegativeButtonText('Cancel');
$droid->dialogSetMultiChoiceItems( [ map { $_->{body} } @unread_msgs ] );
$droid->dialogShow();

if ($droid->dialogGetResponse()->{result}{which} eq 'positive') {
    my %sel_ids
        = map { $_ => 1 } @{ $droid->dialogGetSelectedItems()->{result} };
    #die Dumper \%sel_ids;

    for (keys %sel_ids) {
        #my $msg = $droid->smsGetMessageById($unread_map{$_}, ['body', '_id', 'thread_id',
            #'read', 'status', 'subject']);
        my $val = $droid->smsDeleteMessage($unread_map{$_});
        if ($val->{result}) {
            print "Message with ID $_ deleted.\n";
        }
    }
}

