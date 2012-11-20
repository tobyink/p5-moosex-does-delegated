use strict;
use Test::More;

{
	package HttpGet;
	use Moose::Role;
	requires 'get';
};

{
	package UserAgent;
	use Moose;
	with qw( HttpGet );
	sub get { ... };
};

{
	package Spider;
	use Moose;
	has ua => (
		is         => 'ro',
		does       => 'HttpGet',
		handles    => 'HttpGet',
		lazy_build => 1,
	);
	sub _build_ua { UserAgent->new };
};

my $woolly = Spider->new;

# Note that the default Moose implementation of DOES
# ignores the fact that Spider has delegated the HttpGet
# role to its "ua" attribute.
#
ok(     $woolly->DOES('Spider') );
ok( not $woolly->DOES('HttpGet') );

Moose::Util::apply_all_roles(
	'Spider',
	'MooseX::Does::Delegated',
);

# Our reimplemented DOES pays attention to delegated roles.
#
ok( $woolly->DOES('Spider') );
ok( $woolly->DOES('HttpGet') );

done_testing;
