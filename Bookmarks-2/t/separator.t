# $Id: separator.t,v 1.3 2002/09/23 21:33:34 comdog Exp $
use strict;

use Test::More tests => 3;

use Netscape::Bookmarks::Separator;

my $sep1 = Netscape::Bookmarks::Separator->new();
isa_ok( $sep1, 'Netscape::Bookmarks::Separator' );

my $sep2 = Netscape::Bookmarks::Separator->new();
isa_ok( $sep2, 'Netscape::Bookmarks::Separator' );

is( $sep1, $sep2 );

