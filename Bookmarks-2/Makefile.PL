# $Id: Makefile.PL,v 1.7 2002/09/24 01:34:09 comdog Exp $
use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw(t/test_manifest);
	my $data = join " ", map {chomp; "t/$_" } <>;
	};

WriteMakefile(
    'NAME'	  => 'Netscape::Bookmarks',
    'VERSION' => '2.2_01',
    
    'PM'     => {
    	'lib/Bookmarks.pm'     => '$(INST_LIBDIR)/Bookmarks.pm',
    	'lib/Category.pm'      => '$(INST_LIBDIR)/Bookmarks/Category.pm',
    	'lib/Alias.pm'         => '$(INST_LIBDIR)/Bookmarks/Alias.pm',
    	'lib/Separator.pm'     => '$(INST_LIBDIR)/Bookmarks/Separator.pm',
    	'lib/Link.pm'          => '$(INST_LIBDIR)/Bookmarks/Link.pm',
		'lib/AcceptVisitor.pm' => '$(INST_LIBDIR)/Bookmarks/AcceptVisitor.pm',
    	},
    	
    'PREREQ_PM'    => { 	
		'HTML::Parser'     => '3.26',
		'HTML::Entities'   => '0',
		'URI::URL'         => '0',
		'Test::More'       => '0',
		'Test::Pod'        => '0',
		'Test::Prereq'     => '0.05',
		'File::Find::Rule' => '0',
		'Test::File'       => '0',
		'Text::Diff'       => '0',
		
	 },

    'dist'          => {
                       'COMPRESS'        => 'gzip -9f',
                       'SUFFIX'          => 'gz',
                        },

	test   => { TESTS      => $tests },
	depend => { 'Makefile' => 't/test_manifest' },

	MYEXTLIB		=> undef,

);
