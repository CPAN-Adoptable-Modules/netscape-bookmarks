package Netscape::Bookmarks::Category;
# $Revision: 1.9 $
# $Id: Category.pm,v 1.9 2006/02/12 23:58:25 comdog Exp $

=head1 NAME

Netscape::Bookmarks::Category	- manipulate, or create Netscape Bookmarks files

=head1 SYNOPSIS

  use Netscape::Bookmarks;

  #parse an existing file
  my $bookmarks = Netscape::Bookmarks->new( $bookmarks_file );

  #print a Netscape compatible file
  print $bookmarks->as_string;

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

This module allows one to manipulate the bookmarks file programmatically.  One
can parse an existing bookmarks file, manipulate the information, and write it
as a bookmarks file again.  Furthermore, one can skip the parsing step to create
a new bookmarks file and write it in the proper format to be used by a Netscape
browser.

The Bookmarks.pm module simply parses the bookmarks file passed to it as the
only argument to the constructor:

	my $bookmarks = new Netscape::Bookmarks $bookmarks_file;

The returned object is a Netscape::Bookmarks::Category object, since the bookmark file is
simply a collection of categories that contain any of the components listed
above.  The top level (i.e. root) category is treated specially and defines the
title of the bookmarks file.

=head2 Methods

=over 4

=cut

use strict;
use subs qw();
use vars qw($VERSION $ERROR @EXPORT @EXPORT_OK @ISA $LAST_ID %IDS);

use Carp qw(carp);
use Exporter;

use URI::URL;

use constant START_LIST      => '<DL><p>';
use constant END_LIST        => '</DL><p>';
use constant START_LIST_ITEM => '<DT>';
use constant TAB             => '    ';
use constant FOLDED_TRUE     => 1;
use constant FOLDED_FALSE    => 0;

($VERSION) = q$Revision: 1.9 $ =~ m/(\d+\.\d+)\d*$/;
%IDS     = ();
$LAST_ID = -1;

@EXPORT    = qw();
@EXPORT_OK = qw();
@ISA       = qw();

=item Netscape::Bookmarks::Category-E<gt>new( \%hash )

The new method creates a Category.  It takes a hash reference
that specifies the properties of the category.  The valid keys
in that hash are

	folded			collapsed state of the category ( 1 or 0 )
	title
	add_date
	description

=cut

sub new
	{
	my $class  = shift;
	my $param  = shift;

	$param->{'folded'} = FOLDED_TRUE unless(
		defined $param->{'folded'} &&
		$param->{'folded'} == FOLDED_FALSE
		);

	{
	local $^W=0;
	unless( exists $IDS{$param->{'id'}} or $param->{'id'} =~ /\D/)
		{
		$param->{'id'} = ++$LAST_ID;
		$IDS{$LAST_ID}++;
		}
	}
	
	$param->{'add_date'} ||= 0; # get rid of uninit warnings
	
	if( $param->{'add_date'} =~ /\D/ or not $param->{'add_date'} =~ /^\d+$/ )
		{
		$param->{'add_date'} = 0;
		}

	$param->{'thingys'}     = [];

	bless $param, $class;
	}

=item $category-E<gt>add( $object )

The add() function adds an element to a category.  The element must be a Alias,
Link, Category, or Separator object.  Returns TRUE or FALSE.

=cut

sub add
	{
	my $self = shift;
	my $thingy = shift;

	return unless
		ref $thingy eq 'Netscape::Bookmarks::Link' or
		ref $thingy eq 'Netscape::Bookmarks::Category' or
		ref $thingy eq 'Netscape::Bookmarks::Separator' or
		ref $thingy eq 'Netscape::Bookmarks::Alias';

	push @{ $self->{'thingys'} }, $thingy;
	}

# append_title is used by the parser routines to add to a
# title as the HTML stream is parsed.  the title may fall
# across a chunk boundary so the first part is saved and
# the second part is added.
sub append_title
	{
	my $self = shift;
	my $text = shift;

	$self->{'title'} .= $text;
	}

# append_description is used by the parser routines to add to a
# title as the HTML stream is parsed.  the title may fall
# across a chunk boundary so the first part is saved and
# the second part is added.
sub append_description
	{
	my $self = shift;
	my $text = shift;

	$self->{'description'} .= $text;
	}

=item $category-E<gt>add_desc( $object )

Adds a description to the category.

=cut

sub add_desc
	{
	my $self = shift;
	my $text = shift;

	$self->{'description'} = $text;
	}

=item $category-E<gt>title()

Returns title to the category.

=cut

sub title
	{
	my $self = shift;

	$self->{'title'};
	}

=item $category-E<gt>id()

Returns the ID of the category. This is an arbitrary, unique number.

=cut

sub id
	{
	my $self = shift;

	$self->{'id'};
	}

=item $category-E<gt>description

Returns the description of the category

=cut

sub description
	{
	my $self = shift;

	$self->{description};
	}

=item $category-E<gt>folded( $object )

Returns the folded state of the category (TRUE or FALSE).  If the category is
"folded", Netscape shows a collapsed folder for this category.

=cut

sub folded
	{
	my $self = shift;

	return $self->{'folded'} ? 1 : 0;
	}

=item $category-E<gt>add_date()

Returns the ADD_DATE attribute of the category.

=cut

sub add_date
	{
	my $self = shift;

	return $self->{'add_date'};
	}

=item $category-E<gt>elements()

Returns an array reference to the elements in the category.

=cut

sub elements
	{
	my $self = shift;

	return \@{ $self->{'thingys'} };
	}

=item $category-E<gt>categories()

Returns a list of the Category objects in the category.

=cut

sub categories
	{
	my $self = shift;

	my @list = grep ref $_ eq 'Netscape::Bookmarks::Category', @{$self->elements};

	return @list;
	}

=item $category-E<gt>links()

Returns a list of the Link objects in the category.

=cut

sub links
	{
	my $self = shift;

	my @list = grep ref $_ eq 'Netscape::Bookmarks::Link', @{$self->elements};

	return @list;
	}

=item $category-E<gt>as_headline()

Returns an HTML string representation of the category, but not
the elements of the category.

=cut

sub as_headline
	{
	my $self = shift;
	
	my $folded   = $self->folded ? "FOLDED" : "";
	my $add_date = $self->add_date;
	my $title    = $self->title;
	my $desc     = $self->description;

	$desc = "\n<DD>$desc" if $desc ne '';

	$add_date = $add_date ? qq|ADD_DATE="$add_date"| : '';

	my $sp = ($folded and $add_date) ? ' ' : '';

	return qq|<H3 $folded$sp$add_date>$title</H3>$desc|
	}

=item $category-E<gt>as_string()

Returns an HTML string representation of the category as the
top level category, along with all of the elements of the
category and the Categories that it contains, recursively.

=cut

sub as_string
	{
	my $self = shift;

	my $title = $self->title;

	my $str = <<"HTML";
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
It will be read and overwritten.
Do Not Edit! -->
<TITLE>$title</TITLE>
<H1>$title</H1>\x0A
HTML

	$str .= START_LIST . "\n";

	foreach my $ref ( @{$self->elements} )
		{
		$str .= $self->_as_string( $ref, 1 );
		}

	$str .= END_LIST . "\n";

	return $str;
	}

# _as_string does most of the work that as_string would normally
# do.
sub _as_string
	{
	my $self  = shift;
	my $obj   = shift;
	my $level = shift;

	my $str;
	
	if( eval { $obj->isa( 'Netscape::Bookmarks::Category' ) } )
		{
		++$level;
		$str .= TAB x ($level - 1) . START_LIST_ITEM . $obj->as_headline() . "\n";
		$str .= TAB x ($level - 1) . START_LIST . "\n";

		foreach my $ref ( @{ $obj->elements } )
			{
			$str .= $self->_as_string( $ref, $level );
			}

		$str .= TAB x ($level - 1) . END_LIST . "\n";
		--$level;
		}
	elsif( eval { $obj->isa( 'Netscape::Bookmarks::Link' ) } )
		{
		my $title = $obj->title;
		my $url   = $obj->href;
		$str .= TAB x ($level) . START_LIST_ITEM . $obj->as_string . "\n"
		}
	elsif( eval { $obj->isa( 'Netscape::Bookmarks::Alias' ) } )
		{
		my $title = $obj->target->title;
		my $url   = $obj->target->href;
		my $s     = $obj->target->as_string;

		$s =~ s/ALIASID/ALIASOF/;
		$str .= TAB x ($level) . START_LIST_ITEM . $s . "\n"
		}
	elsif( eval { $obj->isa( 'Netscape::Bookmarks::Separator' ) } )
		{
		$str .= TAB x ($level) . $obj->as_string . "\n"
		}
	else
		{
		carp( "I don't know how to deal with an object of type [" 
			. ref( $obj ) . "]"
			);
		}

	return $str;
	}

"if you want to beleive everything you read, so be it.";

__END__

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
my best to incorporate them into future versions. You can
interact with the Sourceforge porject for this module at
http://sourceforge.net/projects/nsbookmarks/.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut
