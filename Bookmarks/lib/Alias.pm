package Netscape::Bookmarks::Alias;
# $Revision: 1.3 $
# $Id: Alias.pm,v 1.3 2004/09/16 01:33:21 comdog Exp $

=head1 NAME

Netscape::Bookmarks::Alias - object for an Alias in a Netscape Bookmarks file

=head1 SYNOPSIS

	use Netscape::Bookmarks;
	use Netscape::Bookmarks::Alias;

	my $bookmarks = Netscape::Bookmarks->new();

	my $alias = Netscape::Bookmarks::Alias->new();

	$bookmarks->add( $alias );
	# ... and other Netscape::Bookmark::Category methods

=head1 DESCRIPTION

This module provides an abstraction for an Alias object in a Netscape
Bookmarks file. An alias is simply a reference to another link in the
Bookmarks file, henceforth called the target. If you change the alias,
the target link also changes.

=head2 Methods

=over 4

=cut

use strict;

use subs qw();
use vars qw($VERSION $ERROR @EXPORT @EXPORT_OK @ISA %aliases);

use Exporter;

use Netscape::Bookmarks::Link;

($VERSION) = q$Revision: 1.3 $ =~ m/(\d+\.\d+)\s*$/;

@EXPORT    = qw();
@EXPORT_OK = qw();
@ISA       = qw();

=item new( ALIASID )

=cut

sub new
	{
	my $class  = shift;
	my $param  = shift;

	my $self = {};

	bless $self, $class;

	$self->{'alias_of'} = $param;

	$self;
	}

=item $obj->alias_of()

Returns the alias key for this alias

=cut

sub alias_of
	{
	my $self = shift;

	return $self->{'alias_of'};
	}

=item $obj->target( ALIAS_KEY )

Returns the target Link of the given alias key.  The return value
is a C<Netscape::Bookmarks::Link> object if the target exists, or
undef in scalar context or the empty list in list context if the
target does not exist. If you want to simply check to see if a
target exists, use C<target_exists>.

=cut

sub target
	{
	my $self     = shift;

	return $aliases{$self->{'alias_of'}};
	}

=item add_target( $link_obj, ALIAS_KEY )

Adds a target link for the given ALIAS_KEY. You can add target
links before the Alias is created.

=cut

# this should really be in Link.pm right?
sub add_target
	{
	my $target   = shift; #link reference
	my $alias_id = shift;

	($$target)->aliasid($alias_id);
	$aliases{$alias_id} = $$target;
	}

=item target_exists( TARGET_KEY )

For the given target key returns TRUE or FALSE if the target
exists.

=cut

sub target_exists
	{
	my $target = shift;

	exists $aliases{$target} ? 1 : 0;
	}

"if you want to believe everything you read, so be it.";

=back

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/nsbookmarks/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

If you send me modifications or new features, I will do
my best to incorporate them into future versions.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut

__END__
