package Netscape::Bookmarks::Separator;
# $Revision: 1.3 $
# $Id: Separator.pm,v 1.3 2002/05/27 01:19:09 comdog Exp $

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

use subs qw();
use vars qw($VERSION $ERROR @EXPORT @EXPORT_OK @ISA);

use Netscape::Bookmarks;
use Netscape::Bookmarks::AcceptVisitor;

use Exporter;

use URI::URL;

($VERSION) = q$Revision: 1.3 $ =~ m/(\d+\.\d+)\s*$/;

@EXPORT    = qw();
@EXPORT_OK = qw();
@ISA       = qw(Netscape::Bookmarks::AcceptVisitor);

=head2 Netscape::Bookmarks::Separator->new

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
	
=head2 $obj->as_string

Prints the separator object in the Netscape bookmark format.  One should
not have to do this as Netscape::Bookmarks::Category will take care of it.

=cut

sub as_string { "<HR>" }

=head2 $obj->title

Prints a string to represent a separator.  This method exists to
round out polymorphism among the  Netscape::* classes.  The
string does not have a trailing newline.

=cut

sub title
	{
	return "-" x 50;
	}

=head2 $obj->remove

Performs any clean up necessary to remove this object from the
Bookmarks tree.

=cut

sub remove
	{
	return 1;
	}
	
"if you want to believe everything you read, so be it.";
	
__END__

=back

=head1 AUTHOR

brian d foy E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

If you send me modifications or new features, I will do
my best to incorporate them into future versions.

=head1 SEE ALSO

L<Netscape::Bookmarks>

=cut
