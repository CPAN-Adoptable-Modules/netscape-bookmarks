# $Id: visitor.t,v 1.2 2002/09/23 21:33:34 comdog Exp $
use strict;

use Test::More tests => 3;

use Netscape::Bookmarks;

require "examples/Visitor.pm";

my $visitor = Visitor->new();
isa_ok( $visitor, 'Visitor' );

my $netscape = Netscape::Bookmarks->new( "bookmark_files/Bookmarks.html" );
isa_ok( $netscape, 'Netscape::Bookmarks::Category' );

$netscape->introduce( $visitor );

pass();
