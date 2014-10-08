use ExtUtils::MakeMaker '6.64';

eval "use Test::Manifest 1.21";
	
WriteMakefile(
	'NAME'         => 'Netscape::Bookmarks',
	'ABSTRACT'     => 'Parse or create Mozilla bookmark files',
	'VERSION_FROM' => 'lib/Netscape/Bookmarks.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
		
	'PREREQ_PM'    => {
		'HTML::Entities'          => '0',
		'HTML::Parser'            => '3.26',
		'HTTP::SimpleLinkChecker' => '0',
		'Text::Diff'              => '0',
		'URI'                     => '0',
		 },

	'TESTING_REQUIRES' => {
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
