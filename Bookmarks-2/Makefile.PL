use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# $Revision: 1.1 $
# $Id: Makefile.PL,v 1.1 2002/01/08 16:43:24 comdog Exp $

WriteMakefile(
    'NAME'	       => 'Netscape::Bookmarks',
    'VERSION_FROM' => 'lib/Bookmarks.pm', # finds $VERSION
    
    'PM'     => {
    	'lib/Bookmarks.pm' => '$(INST_LIBDIR)/Bookmarks.pm',
    	'lib/Category.pm'  => '$(INST_LIBDIR)/Bookmarks/Category.pm',
    	'lib/Alias.pm'     => '$(INST_LIBDIR)/Bookmarks/Alias.pm',
    	'lib/Separator.pm' => '$(INST_LIBDIR)/Bookmarks/Separator.pm',
    	'lib/Link.pm'      => '$(INST_LIBDIR)/Bookmarks/Link.pm',
    	},
    	
    'PREREQ_PM'    => { 	
		'HTML::Parser'   => undef,
		'HTML::Entities' => undef,
		'URI::URL'       => undef,
	 },

    'dist'          => {
                       'COMPRESS'        => 'gzip -9f',
                       'SUFFIX'          => 'gz',
                        },

	MYEXTLIB		=> undef,

);
