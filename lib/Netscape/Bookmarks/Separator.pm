package Netscape::Bookmarks::Separator;

=encoding utf8

=head1 NAME

Netscape::Bookmarks::Separator	- manipulate, or create Netscape Bookmarks files

=head1 SYNOPSIS

	use Netscape::Bookmarks::Category;
	use Netscape::Bookmarks::Separator;

	#add a separator to a category listing
	my $category  = new Netscape::Bookmarks::Category { ... };
	my $separator = new Netscape::Bookmarks::Separator;
	my $category->add($separator);

	#print the separator
	#note that Netscape::Category::as_string does this for you
	print $separator->as_string;

=head1 DESCRIPTION

Store a Netscape bookmark separator object.

=head1 METHODS

=over 4

=cut

use strict;

use base qw( Netscape::Bookmarks::AcceptVisitor Netscape::Bookmarks::Isa );
use subs qw();
use vars qw( $VERSION );

use Exporter;

$VERSION = sprintf "%d.%02d", q$Revision: 1.8 $ =~ m/(\d+) \. (\d+)/xg;

my $singleton = undef;

=item Netscape::Bookmarks::Separator->new

Creates a new Separator object.  This method takes no arguments.
This object represents a Singleton object.  The module only
makes on instance which everybody else shares.

=cut

sub new
	{
	return $singleton if defined $singleton;

	my $class  = shift;

	my $n = '';
	my $self = \$n;

	bless $self, $class;

	$singleton = $self;

	$singleton;
	}

=item $obj->as_string

Prints the separator object in the Netscape bookmark format.  One should
not have to do this as Netscape::Bookmarks::Category will take care of it.

=cut

sub as_string { "<HR>" }

=item $obj->title

Prints a string to represent a separator.  This method exists to
round out polymorphism among the  Netscape::* classes.  The
string does not have a trailing newline.

=cut

sub title
	{
	return "-" x 50;
	}

=item $obj->remove

Performs any clean up necessary to remove this object from the
Bookmarks tree.

=cut

sub remove
	{
	return 1;
	}

"if you want to believe everything you read, so be it.";

=back

=head1 AUTHOR

brian d foy C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2002-2015, brian d foy <bdfoy@cpan.org>. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut
