package Netscape::Bookmarks::Link;
# $Id: Link.pm,v 1.4 2002/09/23 21:33:34 comdog Exp $

=head1 NAME

Netscape::Bookmarks::Link	- manipulate, or create Netscape Bookmarks links

=head1 SYNOPSIS

  use Netscape::Bookmarks::Bookmarks;

  my $category = new Netscape::Bookmarks::Category { ... };
  my $link = new Netscape::Bookmarks::Link {
  		TITLE         => 'this is the title',
  		DESCRIPTION   => 'this is the description',
  		HREF          => 'http://www.perl.org',
  		ADD_DATE      => 937862073,
  		LAST_VISIT    => 937862073,
  		LAST_MODIFIED => 937862073,
  		ALIAS_ID      => 4,
  		}

  $category->add($link);


  #print a Netscape compatible file
  print $link->as_string;

=head1 DESCRIPTION

The Netscape bookmarks file has several basic components:

	title
	folders (henceforth called categories)
	links
	aliases
	separators

On disk, Netscape browsers store this information in HTML. In the browser,
it is displayed under the "Bookmarks" menu.  The data can be manipulated
through the browser interface.

This module allows one to manipulate the links in for a Netscape bookmarks
file.  A link has these attributes, only some of which may be present:

	title
	description
	HREF (i.e. URL)
	ADD_DATE
	LAST_MODIFIED
	LAST_VISIT
	ALIAS_OF
	ALIAS_ID

These are explained below.

=head1 METHODS

=over 4

=cut

use strict;

use subs qw();
use vars qw($DEBUG $VERSION $ERROR @EXPORT @EXPORT_OK @ISA);

use Netscape::Bookmarks;
use Netscape::Bookmarks::AcceptVisitor;

use Exporter;

use URI::URL;

($VERSION)   = q$Revision: 1.4 $ =~ m/(\d+\.\d+)\s*$/;

@EXPORT    = qw();
@EXPORT_OK = qw();
@ISA       = qw(Netscape::Bookmarks::AcceptVisitor);

=item Netscape::Bookmarks::Link-E<gt>new( \%hash )

Creates a new Link object. The hash reference argument
can have the following keys to set the properties of the
link:

	HREF
	ADD_DATE
	LAST_MODIFIED
	LAST_VISIT
	ALIASID
	ALIASOF

=cut

sub new
	{
	my $class  = shift;
	my $param  = shift;

	my $self = {};
	bless $self, $class;

	my $url = new URI::URL $param->{HREF};
	unless( ref $url )
		{
		$ERROR = "[$$param{HREF}] is not a valid URL";
		return -1;
		}
	$self->{HREF} = $url;

	foreach my $k ( qw(ADD_DATE LAST_MODIFIED LAST_VISIT ALIASID ALIASOF) )
		{
		if( defined $param->{$k} and $param->{$k} =~ /\D/ )
			{
			$ERROR = "[$$param{$k}] is not a valid $k";
			return -2;
			}
		$self->{$k} = $param->{$k};
		}

	unless( $param->{'TITLE'} )
		{
		$ERROR = "The TITLE cannot be null.";
		return -3;
		}

	$self->{'TITLE'} = $param->{'TITLE'};

	$self->{'DESCRIPTION'} = $param->{'DESCRIPTION'};

	$self;
	}


=item $obj->href

Returns the URL of the link.  The URL appears in the HREF attribute of
the anchor tag.

=cut

sub href
	{
	my $self = shift;

	$self->{'HREF'}->as_string
	}

=item $obj->add_date

Returns the date when the link was added, in Unix epoch time.

=cut

sub add_date
	{
	my $self = shift;

	$self->{'ADD_DATE'}
	}

=item $obj->last_modified

Returns the date when the link was last modified, in Unix epoch time.  Returns
zero if no information is available.

=cut

sub last_modified
	{
	my $self = shift;

	$self->{'LAST_MODIFIED'}
	}

=item $obj->last_visit

Returns the date when the link was last vistied, in Unix epoch time. Returns
zero if no information is available.

=cut

sub last_visit
	{
	my $self = shift;

	$self->{'LAST_VISIT'}
	}

=item $obj->title( [ TITLE ] )

Sets the link title with the given argument, and returns the link title.
If the argument is not defined (e.g. not specified), returns the current
link title.

=cut

sub title
	{
	my( $self, $title ) = @_;

	$self->{'TITLE'} = $title if defined $title;

	$self->{'TITLE'}
	}

=item $obj->description( [ DESCRIPTION ] )

Sets the link description with the given argument, and returns the link
description. If the argument is not defined (e.g. not specified),
returns the current link description.

=cut

sub description
	{
	my( $self, $description ) = @_;

	$self->{'DESCRIPTION'} = $description if defined $description;

	$self->{'DESCRIPTION'}
	}

=item $obj->alias_id

Returns the alias id of a link. Links with aliases are assigned an ALIAS_ID which
associates them with the alias.  The alias contains the same value in it's ALIAS_OF
field.  The Netscape::Bookmarks::Alias module handles aliases as references to
Netscape::Bookmarks::Link objects.

=cut

sub aliasid
	{
	my $self = shift;
	my $data = shift;

	$self->{'ALIASID'} = $data if defined $data;

	$self->{'ALIASID'}
	}

# =item $obj->alias_of
#
# Returns the target id of a link. Links with aliases are assigned an ALIAS_ID which
# associates them with the alias.  The alias contains the same value in it's ALIAS_OF
# field.  The Netscape::Bookmarks::Alias module handles aliases as references to
# Netscape::Bookmarks::Link objects.
#
# =cut

sub aliasof
	{
	my $self = shift;

	$self->{'ALIASOF'}
	}

# =item $obj->append_title
#
# Adds to the title - used mostly for the HTML parser, although it can
# be used to add a title if none exists (which is an error, though).
#
# =cut

sub append_title
	{
	my $self = shift;
	my $text = shift;

	$self->{'TITLE'} .= $text;
	}

# =item $obj->append_description
#
# Adds to the description - used mostly for the HTML parser, although
# it can be used to add a description if none exists.
#
# =cut
#
sub append_description
	{
	my $self = shift;
	my $text = shift;

	$self->{'DESCRIPTION'} .= $text;
	}

#  just show me what you think is in the link.  i use this for
#  debugging.
#
sub print_dump
	{
	my $self = shift;

	print <<"HERE";
$$self{TITLE}
@{[($$self{HREF})->as_string]}
	$$self{ADD_DATE}
	$$self{LAST_MODIFIED}
	$$self{LAST_VISIT}
	$$self{ALIASID}

HERE

	}

=item $obj->as_string

Returns a Netscape compatible bookmarks file based on the Bookmarks object.

=cut

sub as_string
	{
	my $self = shift;

	my $link          = $self->href;
	my $title         = $self->title;
	my $aliasid       = $self->aliasid;
	my $aliasof       = $self->aliasof;
	my $add_date      = $self->add_date;
	my $last_visit    = $self->last_visit;
	my $last_modified = $self->last_modified;

	$aliasid       = defined $aliasid ? qq|ALIASID="$aliasid" | : '';
	$aliasof       = defined $aliasof ? qq|ALIASOF="$aliasof" | : '';
	$add_date      = $add_date        ? qq|ADD_DATE="$add_date" |
		: qq|ADD_DATE="0" |;
	$last_visit    = $last_visit      ?
		qq|LAST_VISIT="$last_visit" | : qq|LAST_VISIT="0" |;
	$last_modified = $last_modified   ?
		qq|LAST_MODIFIED="$last_modified"| : qq|LAST_MODIFIED="0"|;

	my $desc = '';
	$desc  = "\n\t<DD>" . $self->description if $self->description;

	#XXX: when the parser gets the Link description, it also picks up
	#the incidental whitespace between the description and the
	#next item, so we need to remove this before we print it.
	#
	#this is just a kludge though, since we should solve the
	#actual problem as it happens.  however, since this is a
	#stream  parser and we don't know when the description ends
	#until the next thing starts (since there is no closing DD tag,
	#we don't know when to strip whitespace.
	$desc =~ s/\s+$//;

	return qq|<A HREF="$link" $aliasof$aliasid$add_date$last_visit| .
		qq|$last_modified>$title</A>$desc|;
	}

=item $obj->remove

Performs any clean up necessary to remove this object from the
Bookmarks tree. Although this method does not remove Alias objects
which point to the Link, it probably should.

=cut

sub remove
	{
	my $self = shift;

	return 1;
	}

"if you want to believe everything you read, so be it."

__END__

=back

=head1 TO DO

	* Add methods for manipulating attributes

=head1 AUTHOR

brian d foy E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, brian d foy, E<lt>bdfoy@cpan.orgE<gt>

This program is free software. You can redistribute it
and/or modify it under the same terms as Perl itself.

If you send me modifications or new features, I will do
my best to incorporate them into future versions.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut
