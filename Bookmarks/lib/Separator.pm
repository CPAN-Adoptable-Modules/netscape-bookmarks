package Netscape::Bookmarks::Separator;
# $Revision: 1.5 $
# $Id: Separator.pm,v 1.5 2007/01/10 05:42:44 comdog Exp $

=head1 NAME

Netscape::Bookmarks::Separator	- manipulate, or create Netscape Bookmarks files

=head1 SYNOPSIS

	use Netscape::Bookmarks::Category;
	use Netscape::Bookmarks::Separator;

	#add a separator to a category listing
	my $category  = Netscape::Bookmarks::Category->new( { ... } );
	my $separator = Netscape::Bookmarks::Separator->new();
	my $category->add( $separator );

	#print the separator
	#note that Netscape::Category::as_string does this for you
	print $separator->as_string;

=head1 DESCRIPTION

Store a Netscape bookmark separator object.

=head2 Methods

=over 4

=cut

use strict;

use subs qw();
use vars qw($VERSION $ERROR @EXPORT @EXPORT_OK @ISA);

use Exporter;

use URI::URL;

($VERSION) = q$Revision: 1.5 $ =~ m/(\d+\.\d+)\s*$/;

@EXPORT    = qw();
@EXPORT_OK = qw();
@ISA       = qw();

=item Netscape::Bookmarks::Separator->new

Creates a new Separator object.  This method takes no arguments.

=cut

sub new
	{
	my $class  = shift;

	my $n = '';
	my $self = \$n;

	bless $self, $class;

	$self;
	}

=item $obj->as_string

Prints the separator object in the Netscape bookmark format.  One should
not have to do this as Netscape::Bookmarks::Category will take care of it.

=cut

sub as_string
	{
	return "<HR>";
	}

"if you want to believe everything you read, so be it."

__END__

=back

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/nsbookmarks/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2002-2007 brian d foy.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut
