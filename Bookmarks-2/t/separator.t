# $Id: separator.t,v 1.2 2002/07/10 04:01:11 comdog Exp $
BEGIN { $| = 1; print "1..2\n"; }
END {print "not ok 1\n" unless $loaded;}
use Netscape::Bookmarks::Separator;
$loaded = 1;
print "ok 1\n";

my $sep1 = Netscape::Bookmarks::Separator->new();
my $sep2 = Netscape::Bookmarks::Separator->new();

print $sep1 ne $sep2 ? 'not ' : '', "ok\n"; 

