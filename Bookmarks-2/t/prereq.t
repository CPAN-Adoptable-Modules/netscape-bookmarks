# $Id: prereq.t,v 1.2 2002/09/23 21:33:34 comdog Exp $

use Test::More tests => 1;
use Test::Prereq;

prereq_ok( undef, undef, [ qw(examples/Visitor.pm) ] );
