=head1 PURPOSE

Test the example from the L<MooseX::Does::Delegated> SYNOPSIS section.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

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
	sub get { 1; };  # Changed from SYNOPSIS to get it to compile
};                  # in Perl before 5.12.

{
	package Spider;
	use Moose;
    use MooseX::Does::Delegated;
	has ua => (
		is         => 'ro',
		does       => 'HttpGet',
		handles    => 'HttpGet',
		lazy_build => 1,
	);
	sub _build_ua { UserAgent->new };
};

my $spider = Spider->new;

ok( $spider->DOES('Spider') );
ok( $spider->DOES('HttpGet') );

done_testing;
