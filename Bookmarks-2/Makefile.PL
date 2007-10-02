# $Id: Makefile.PL,v 1.9 2007/10/02 07:30:14 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";
	
WriteMakefile(
	'NAME'         => 'Netscape::Bookmarks',
	'ABSTRACT'     => 'Parse or create Mozilla bookmark files',
	'VERSION_FROM' => 'lib/Bookmarks.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',

	'PM'     => {
		'lib/AcceptVisitor.pm' => '$(INST_LIBDIR)/Bookmarks/AcceptVisitor.pm',
		'lib/Alias.pm'         => '$(INST_LIBDIR)/Bookmarks/Alias.pm',
		'lib/Bookmarks.pm'     => '$(INST_LIBDIR)/Bookmarks.pm',
		'lib/Category.pm'      => '$(INST_LIBDIR)/Bookmarks/Category.pm',
		'lib/Isa.pm'           => '$(INST_LIBDIR)/Bookmarks/Isa.pm',
		'lib/Link.pm'          => '$(INST_LIBDIR)/Bookmarks/Link.pm',
		'lib/Separator.pm'     => '$(INST_LIBDIR)/Bookmarks/Separator.pm',
		},
		
	'PREREQ_PM'    => {
		'HTML::Entities'          => '0',
		'HTML::Parser'            => '3.26',
		'HTTP::SimpleLinkChecker' => '0',
		'Test::File'              => '0',
		'Test::More'              => '0',
		'Text::Diff'              => '0',
		'URI'                     => '0',
		 },

	'MAN3PODS' => {
		'lib/AcceptVisitor.pm' => '$(INST_MAN3DIR)/Netscape::Bookmarks::AcceptVisitor.3',
		'lib/Alias.pm'         => '$(INST_MAN3DIR)/Netscape::Bookmarks::Alias.3',
		'lib/Bookmarks.pm'     => '$(INST_MAN3DIR)/Netscape::Bookmarks.3',
		'lib/Category.pm'      => '$(INST_MAN3DIR)/Netscape::Bookmarks::Category.3',
		'lib/Isa.pm'           => '$(INST_MAN3DIR)/Netscape::Bookmarks::Isa.3',
		'lib/Link.pm'          => '$(INST_MAN3DIR)/Netscape::Bookmarks::Link.3',
		'lib/Separator.pm'     => '$(INST_MAN3DIR)/Netscape::Bookmarks::Separator.3',
		},
		
	clean => { FILES => 'Netscape-Bookmarks-*' },

	);
