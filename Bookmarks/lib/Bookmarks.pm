package Netscape::Bookmarks;
# $Id: Bookmarks.pm,v 1.6 2004/09/16 01:53:11 comdog Exp $

=head1 NAME

Netscape::Bookmarks	- parse, manipulate, or create Netscape Bookmarks files

=head1 SYNOPSIS

  use Netscape::Bookmarks;

  # parse an existing file
  my $bookmarks = Netscape::Bookmarks->new( $bookmarks_file );

  # -- OR --
  # start a new Bookmarks structure
  my $bookmarks = Netscape::Bookmarks->new;

  # print a Netscape compatible file
  print $bookmarks->as_string;


=head1 DESCRIPTION

[ Note: I wrote this a long time ago.  Although this should still
work with "Netscape" browsers, Mozilla browsers do the same
thing.  When the docs say "Netscape", I mean either branch
of browsers. ]

The Netscape bookmarks file has several basic components:

	title
	folders (henceforth called categories)
	links
	aliases
	separators

On disk, Netscape browsers store this information in HTML. In the
browser, it is displayed under the "Bookmarks" menu. The data can be
manipulated through the browser interface.

This module allows one to manipulate the bookmarks file
programmatically.  One can parse an existing bookmarks file, manipulate
the information, and write it as a bookmarks file again.  Furthermore,
one can skip the parsing step to create a new bookmarks file and write
it in the proper format to be used by a Netscape browser.

The Bookmarks module simply parses the bookmarks file passed to it as
the only argument to the constructor:

	my $bookmarks = Netscape::Bookmarks->new( $bookmarks_file );

The returned object is a C<Netscape::Bookmarks::Category> object, since
the bookmark file is simply a collection of categories that
contain any of the components listed above.  The top level
(i.e. root) category is treated specially and defines the
title of the bookmarks file.

C<HTML::Parser> is used behind the scenes to build the data structure (a
simple list of lists (of lists ...)). C<Netscape::Bookmarks::Category>,
C<Netscape::Bookmarks::Link>, C<Netscape::Bookmarks::Alias>, or
C<Netscape::Bookmarks::Separator> objects can be stored in a
C<Netscape::Bookmarks::Category> object.  C<Netscape::Bookmarks::Alias>
objects are treated as references to C<Netscape::Bookmarks::Link>
objects, so changes to one affect the other.

Methods for manipulating this object are in the
C<Netscape::Bookmarks::Category> module.  Methods for dealing with the
objects contained in a C<Netscape::Bookmarks::Category> object are in
their appropriate modules.

=over 4

=cut

use strict;

use subs qw();
use vars qw(@ISA
	$DEBUG
	$VERSION
	@category_stack
	$flag
	%link_data
	%category_data
	$netscape
	$state
	$current_link
	$ID
	$text_flag
	);

use HTML::Entities;
use HTML::Parser;

use Netscape::Bookmarks::Alias;
use Netscape::Bookmarks::Category;
use Netscape::Bookmarks::Link;
use Netscape::Bookmarks::Separator;

($VERSION) = q$Revision: 1.6 $ =~ m/(\d+\.\d+)\s*$/;
@ISA=qw(HTML::Parser);

$ID = 0;
$DEBUG = $ENV{NS_DEBUG} || 0;

=item new( [filename] )

The constructor takes a filename as its single (optional) argument.
If you do not give C<new> an argument, an empty
C<Netscape::Bookmarks::Category> object is returned so that
you can start to build up your new Bookmarks file.  If the file
that you name does not exist, C<undef> is returned in scalar
context and an empty list is returned in list context. If the
file does exist it is parsed with C<HTML::Parser> with the
internal parser subclass defined in the same package as C<new>.
If the parsing finishes without error a C<Netscape::Bookmarks::Category>
object is returned.

=cut

sub new
	{
	my($class, $file) = @_;

	unless( $file )
		{
		my $cat = new Netscape::Bookmarks::Category;
		return $cat;
		}

	return unless (-e $file or ref $file);

	my $self = new HTML::Parser;

	bless $self, $class;

	$self->parse_file($file);

	return $netscape;
	}

sub parse_string
	{
	my $ref = shift;

	my $self = new HTML::Parser;
	bless $self, "Netscape::Bookmarks";

	my $length = length $$ref;
	my $pos    = 0;

	while( $pos < $length )
		{
		#512 bytes seems to be the magic number
		#to make this work efficiently. don't know
		#why really - its an HTML::Parser thing
		$self->parse( substr( $$ref, $pos, 512 ) );
		$pos += 512;
		}

	$self->eof;

	return $netscape;
	}

sub start
	{
    my($self, $tag, $attr) = @_;

    $text_flag = 0;

    if( $tag eq 'a' )
    	{
		$state = 'anchor';
    	%link_data = %$attr;
     	}
    elsif( $tag eq 'h3' or $tag eq 'h1' )
    	{
    	$state = 'category';
    	%category_data = %$attr;
    	}
    elsif( $tag eq 'hr' )
    	{
    	my $item = new Netscape::Bookmarks::Separator;
    	print "Found Separator: $item\n" if $DEBUG;
    	${$category_stack[-1]}->add(\$item);
    	}

    $flag = $tag
	}

sub text
	{
	my($self, $text) = @_;

	if($text_flag)
		{
		if( $flag eq 'h1' or $flag eq 'h3' )
			{
			${$category_stack[-1]}->append_title($text);
			}
		elsif( $flag eq 'a' and not exists $link_data{'aliasof'} )
			{
			${$current_link}->append_title($text);
			}
		elsif( $flag eq 'dd' )
			{
			print STDERR "Grabbing DD text - state is $state\n" if $DEBUG;
            if( $state eq 'category' )
                {
                ${$category_stack[-1]}->append_description( $text );
                }
            elsif( $state eq 'anchor' )
                {
                ${$$current_link}{'DESCRIPTION'} .= $text;
                }

			${$category_stack[-1]}->append_description($text);
			}

		}
	else
		{
		$flag ||= ''; # to get rid of uninit variable warnings
		
		if( $flag eq 'h1' )
			{
			$netscape = new Netscape::Bookmarks::Category
				{
				title    => $text,
				folded   => 0,
				add_date => $category_data{'add_date'},
				id       => $ID++,
				};

			push @category_stack, \$netscape;
			}
		elsif( $flag eq 'h3' )
			{
			my $cat = new Netscape::Bookmarks::Category
				{
				title    => $text,
				folded   => exists $category_data{'folded'},
				add_date => $category_data{'add_date'},
				id       => $ID++,
				};

			${$category_stack[-1]}->add(\$cat);
			push @category_stack, \$cat;
			}
		elsif( $flag eq 'a' and not exists $link_data{'aliasof'} )
			{
			my $item = new Netscape::Bookmarks::Link {
	    		HREF			=> $link_data{'href'},
	    		ADD_DATE 		=> $link_data{'add_date'},
	    		LAST_MODIFIED 	=> $link_data{'last_modified'},
	    		LAST_VISIT    	=> $link_data{'last_visit'},
	    		ALIASID         => $link_data{'aliasid'},
	    		TITLE           => $text,
	    		};
	    	unless( ref $item )
	    		{
	    		print "ERROR: $Netscape::Bookmarks::Link::ERROR\n" if $DEBUG;
	    		return;
	    		}

			if( defined $link_data{'aliasid'} )
				{
				&Netscape::Bookmarks::Alias::add_target(
					\$item, $link_data{'aliasid'})
				}

			print "Link title is ", $item->title, "\n" if $DEBUG;

			${$category_stack[-1]}->add(\$item);
			$current_link = \$item;
			}
		elsif( $flag eq 'a' and defined $link_data{'aliasof'} )
			{
			my $item = new Netscape::Bookmarks::Alias $link_data{'aliasof'};
			print "Bookmarks[", __LINE__, "]: [$item]\n" if $DEBUG;
	    	unless( ref $item )
	    		{
	    		print "ERROR: $Netscape::Bookmarks::Alias::ERROR\n" if $DEBUG;
	    		return;
	    		}

			${$category_stack[-1]}->add(\$item);
			$current_link = \$item;
			}
		elsif( $flag eq 'dd' )
			{
			print STDERR "Grabbing DD text and adding - state is $state\n"
				if $DEBUG;
			if( $state eq 'category' )
				{
				${$category_stack[-1]}->add_desc($text);
				}
			elsif( $state eq 'anchor' )
				{
	     		${$$current_link}{'DESCRIPTION'} = $text;
				}
			}
		}

	$text_flag = 1;
	}

sub end
    {
    my($self, $tag, $attr) = @_;

    $text_flag = 0;
    pop @category_stack   if $tag eq 'dl';
	# what does the next line do and why?
	# if it is there then the <dd> part of a link is discarded
	# not having this line doesn't seem to break things.
	# bug identified by Daniel Hottinger <TheHotti@gnx.net>
    #$current_link = undef if $tag eq 'a';
    $flag = undef;
    }

sub my_init {}

"Seeing is believing";

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

=head1 SEE ALSO

L<HTML::Parser>,
L<Netscape::Bookmarks::Category>,
L<Netscape::Bookmarks::Link>,
L<Netscape::Bookmarks::Alias>,
L<Netscape::Bookmarks::Separator>.

=cut
