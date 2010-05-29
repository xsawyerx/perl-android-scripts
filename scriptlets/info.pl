use strict;
use warnings;

require "/sdcard/ase/scripts/MyTools.pl";


say("Perl version:  $]");  # reporting 5.010001
say("\$0 $0");             # /sdcard/ase/scripts/info.pl

use File::Basename qw(dirname);
say(dirname($0));   # /sdcard/ase/scripts

use Cwd;
say("cwd: " . cwd);  # /    (IMHO should be /sdcard/ase/scripts, question asked on list)

say("Path to perl: $^X");   # /data/data/com.google.ase/perl/perl

#print `ls -l`;
# works
#
#print "pwd: ", `pwd`;
# Can't exec "pwd": Permission denied

