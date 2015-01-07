use strict;
use warnings;

eval "use Test::Manifest 1.21";
	
my $github    = 'https://github.com/briandfoy/';
my $main_file = 'lib/Netscape/Bookmarks.pm';

my %WriteMakefile = (
	'NAME'          => 'Netscape::Bookmarks',
	'ABSTRACT_FROM' => $main_file,
	'VERSION_FROM'  => $main_file,
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',
		
	'PREREQ_PM'    => {
		'HTML::Entities'          => '0',
		'HTML::Parser'            => '3.26',
		'HTTP::SimpleLinkChecker' => '0',
		'Text::Diff'              => '0',
		'URI'                     => '0',
		 },

	'TEST_REQUIRES' => {
		'Test::File'              => '0',
		'Test::More'              => '0',
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
			resources => {
				repository => {
					type => 'git',
					url  => 'https://github.com/briandfoy/netscape-bookmarks.git',
					web  => 'https://github.com/briandfoy/netscape-bookmarks',
				},
			},
		},
		
	clean => { FILES => 'Netscape-Bookmarks-*' },
	);

sub arguments { \%WriteMakefile }

do_it() unless caller;
sub do_it {
	require File::Spec;
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			//
		"$MM 6.64";
	eval "use $MM_version" || die "Could not load $MM_version: $@";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
