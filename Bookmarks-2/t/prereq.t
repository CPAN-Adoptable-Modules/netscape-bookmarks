#$Id: prereq.t,v 1.3 2004/09/02 05:15:41 comdog Exp $
use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok();
