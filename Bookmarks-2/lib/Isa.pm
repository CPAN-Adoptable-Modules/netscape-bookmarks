package Netscape::Bookmarks::Isa;
# $Id: Isa.pm,v 1.4 2007/10/02 08:04:29 comdog Exp $

=head1 NAME

Netscape::Bookmarks::Isa - mixin methods for object identity

=head1 SYNOPSIS

	use base qw( Netscape::Bookmarks::Isa );

	my $bookmarks = Netscape::Bookmarks->new( $bookmarks_file );

	foreach my $element ( $bookmarks->elements )
		{
		print "Found category!\n" if $element->is_category;
		}

=head1 DESCRIPTION

This module is a base class for Netscape::Bookmarks modules. Each
object can respond to queries about its identity.  Use this module
as a mixin class.

=head2 METHODS

Methods return false unless otherwise noted.

=over 4

=item is_category

Returns true if the object is a Category.

=item is_link

Returns true if the object is a Link or alias to a Link.

=item is_alias

Returns true if the object is an Alias.

=item is_separator

Returns true if the object is a Separator.

=item is_collection

Returns true if the object is a Category.

=back

=head1 AUTHOR

brian d foy C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2002-2007 brian d foy.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Netscape::Bookmarks::Category>,
L<Netscape::Bookmarks::Link>,
L<Netscape::Bookmarks::Alias>,
L<Netscape::Bookmarks::Separator>.

=cut

use strict;
use vars qw( $VERSION );

use Exporter;

$VERSION = sprintf "%d.%02d", q$Revision: 1.4 $ =~ m/(\d+) \. (\d+)/xg;

my $Category  = 'Netscape::Bookmarks::Category';
my $Link      = 'Netscape::Bookmarks::Link';
my $Alias     = 'Netscape::Bookmarks::Alias';
my $Separator = 'Netscape::Bookmarks::Separator';

sub is_category
	{
	$_[0]->is_something( $Category );
	}
	
sub is_link
	{
	$_[0]->is_something( $Link, $Alias );
	}
	
sub is_alias
	{
	$_[0]->is_something( $Alias );
	}
	
sub is_separator
	{
	$_[0]->is_something( $Separator );
	}
	
sub is_collection
	{
	$_[0]->is_something( $Category );
	}

sub is_something
	{
	my $self = shift;
	
	foreach my $something ( @_ )
		{
		return 1 if UNIVERSAL::isa( $self, $something );
		}
		
	return 0;
	}
	
1;
