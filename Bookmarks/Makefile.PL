use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# $Revision: 1.1 $
# $Id: Makefile.PL,v 1.1 2001/08/08 18:03:32 comdog Exp $

$dirs = [ qw(Alias Category Link Separator) ];

WriteMakefile(
    'NAME'	=> 'Netscape::Bookmarks',
    'VERSION_FROM' => 'Bookmarks.pm', # finds $VERSION
    'PREREQ_PM'    => { 	
		'HTML::Parser' => undef,
		'HTML::Entities' => undef,
		'URI::URL' => undef,
	 },

	'DIR'       => [ qw(Alias Category Link Separator) ],
    'PMLIBDIRS'     => [ qw(Alias Category Link Separator) ],

    'dist'          => {
                       'COMPRESS'        => 'gzip -9f',
                       'SUFFIX'          => 'gz',
                        },

	MYEXTLIB		=> undef,

);
