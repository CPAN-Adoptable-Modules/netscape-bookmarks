#!/usr/bin/perl

use warnings;
use strict;

use Test::More 'no_plan';

use File::Spec;

my $class = 'Netscape::Bookmarks';

use_ok( $class );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# open a file that should be there
{
my $file = File::Spec->catfile( qw(bookmark_files Bookmarks.html) );

ok( -e $file, "Test file [$file] is there" );

my $result = eval {
	my $netscape = $class->new( $file );
	isa_ok( $netscape, $class->top_class );
	
	open FILE, "> bookmark_files/Bookmarks_tmp.html" 
		or die "Could not open tmp file: $!";
	print FILE $netscape->as_string;
	close FILE;
	1;
	};

my $at = $@;

ok( $result );
diag($at) unless $result;
}

END { unlink "bookmark_files/Bookmarks_tmp.html" }

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# open a file that shouldn't be there
{
my $file = File::Spec->catfile( qw(bookmark_files foobarbaz.html) );

ok( ! -e $file, "Test file [$file] is not there (good)" );

my $result = eval {
	my $netscape = $class->new( $file );
	};

ok( ! defined $result );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# open no file (so, start with fresh in memory object)
{
my $result = eval {
	my $netscape = $class->new( );
	isa_ok( $netscape, $class->top_class );
	};

ok( $result );
my $at = $@;

ok( $result );
diag($at) unless $result;
}

