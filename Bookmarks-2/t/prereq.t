#$Id: prereq.t,v 1.4 2007/10/02 08:04:33 comdog Exp $
use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok( 5.008005, "Testing PREREQ_PM", [qw(examples/Visitor.pm)] );
