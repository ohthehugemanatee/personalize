#!/usr/bin/perl
use warnings;
use warnings 'FATAL' => 'all';
use strict;
my $prog = '';
my $places = $ENV{XDG_DATA_DIRS} =~ s/:/ /gr;
while (@ARGV)
{
    $prog .= ' ' . shift(@ARGV);
}
$prog =~ s/^ //;
open(FIND, "find $places -type f -name '*.desktop' -exec grep -l 'Name=$prog' {} + 2>/dev/null |");
while (my $file = <FIND>)
{
    print $file;
    chomp $file;
    system "grep ^Exec= $file";
}
close FIND;
