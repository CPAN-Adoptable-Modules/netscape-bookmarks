use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile(
	'NAME'         => 'Netscape::Bookmarks',
	'VERSION'      => '1.94',
	'LICENSE'       => 'perl',

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
