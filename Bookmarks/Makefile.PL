use ExtUtils::MakeMaker;

eval "use Test::Manifest";

unless( $@ )
	{
	* ExtUtils::MM_Any::test_via_harness = sub
		{
		my($self, $perl, $tests) = @_;
		
		return qq|\t$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		}
	}

WriteMakefile(
	'NAME'         => 'Netscape::Bookmarks',
	'VERSION_FROM' => 'lib/Bookmarks.pm', # finds $VERSION

	'PREREQ_PM'    => { 	
		'HTML::Parser'   => '0',
		'HTML::Entities' => '0',
		'URI::URL'       => '0',
	 },

	'PM'           => { 
		'lib/Bookmarks.pm' => '$(INST_LIBDIR)/Bookmarks.pm',

		'lib/Alias.pm'     => '$(INST_LIBDIR)/Bookmarks/Alias.pm',
		'lib/Category.pm'  => '$(INST_LIBDIR)/Bookmarks/Category.pm',
		'lib/Link.pm'      => '$(INST_LIBDIR)/Bookmarks/Link.pm',
		'lib/Separator.pm' => '$(INST_LIBDIR)/Bookmarks/Separator.pm',
		},

	'MAN3PODS'     => {
		'lib/Bookmarks.pm' => '$(INST_MAN3DIR)/Netscape::Bookmarks.3',
		'lib/Alias.pm'     => '$(INST_MAN3DIR)/Netscape::Bookmarks::Alias.3',
		'lib/Category.pm'  => '$(INST_MAN3DIR)/Netscape::Bookmarks::Category.3',
		'lib/Link.pm'      => '$(INST_MAN3DIR)/Netscape::Bookmarks::Link.3',
		'lib/Separator.pm' => '$(INST_MAN3DIR)/Netscape::Bookmarks::Separator.3',
		},

	clean => { FILES => 'Netscape-* Bookmarks_tmp.html bookmark_files/Bookmarks_tmp.html' }
);
