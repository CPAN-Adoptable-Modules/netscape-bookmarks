# $Id: bookmarks.t,v 1.3 2002/09/23 21:33:34 comdog Exp $
use strict;

use Test::More tests => 2;
use Test::File;

use Netscape::Bookmarks;

file_exists_ok( "bookmark_files/Bookmarks.html" );
my $netscape = Netscape::Bookmarks->new( "bookmark_files/Bookmarks.html" );
isa_ok( $netscape, 'Netscape::Bookmarks::Category' );

{
open FILE, "> bookmark_files/Bookmarks_tmp.html" 
	or print "bail out! Could not open tmp file: $!";
print FILE $netscape->as_string;
close FILE;
};

=pod

# what was this test for?  where is this file?

file_exists_ok( "bookmark_files/bookmarks.curtis.html" );
$netscape = Netscape::Bookmarks->new( "bookmark_files/bookmarks.curtis.html" );
isa_ok( $netscape, 'Netscape::Bookmarks::Category' );

=cut

END { unlink "bookmark_files/Bookmarks_tmp.html" }

