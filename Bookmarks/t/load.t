# $Id: load.t,v 1.1 2004/09/16 00:46:35 comdog Exp $
BEGIN {
	@classes = map { join "::", 'Netscape::Bookmarks' }
		qw( Alias Category Link Separator );
		
	unshift @classes, 'Netscape::Bookmarks';
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile\n" unless use_ok( $class );
	}
