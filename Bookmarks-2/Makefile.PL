use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# $Revision: 1.4 $
# $Id: Makefile.PL,v 1.4 2002/05/27 01:25:28 comdog Exp $

WriteMakefile(
    'NAME'	  => 'Netscape::Bookmarks',
    'VERSION' => '2.1_01', # finds $VERSION
    
    'PM'     => {
    	'lib/Bookmarks.pm'     => '$(INST_LIBDIR)/Bookmarks.pm',
    	'lib/Category.pm'      => '$(INST_LIBDIR)/Bookmarks/Category.pm',
    	'lib/Alias.pm'         => '$(INST_LIBDIR)/Bookmarks/Alias.pm',
    	'lib/Separator.pm'     => '$(INST_LIBDIR)/Bookmarks/Separator.pm',
    	'lib/Link.pm'          => '$(INST_LIBDIR)/Bookmarks/Link.pm',
		'lib/AcceptVisitor.pm' => '$(INST_LIBDIR)/Bookmarks/AcceptVisitor.pm',
    	},
    	
    'PREREQ_PM'    => { 	
		'HTML::Parser'   => 3.26,
		'HTML::Entities' => undef,
		'URI::URL'       => undef,
	 },

    'dist'          => {
                       'COMPRESS'        => 'gzip -9f',
                       'SUFFIX'          => 'gz',
                        },

	MYEXTLIB		=> undef,

);
