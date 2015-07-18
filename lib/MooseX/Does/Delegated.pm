package MooseX::Does::Delegated;

use 5.008;
use strict;
use warnings;
use if $] < 5.010, 'UNIVERSAL::DOES';

BEGIN {
	$MooseX::Does::Delegated::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::Does::Delegated::VERSION   = '0.004';
}


use Moose::Exporter;
use MooseX::Does::Delegated::Meta::Attribute::Trait;

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        attribute => ['MooseX::Does::Delegates::Meta::Attribute::Trait'],
    },
);

__PACKAGE__
__END__

=head1 NAME

MooseX::Does::Delegated - allow your class's DOES method to respond the affirmative to delegated roles

=head1 SYNOPSIS

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
      package WoollySpider;
      use Moose;
      use MooseX::Does::Delegated
      has ua => (
         is         => 'ro',
         does       => 'HttpGet',
         handles    => 'HttpGet',
         lazy_build => 1,
      );
      sub _build_ua { UserAgent->new };
   };

   my $woolly = Spider->new;

   ok( $woolly->DOES('Spider') );
   ok( $woolly->DOES('HttpGet') );

   done_testing;

=head1 DESCRIPTION

According to L<UNIVERSAL> the point of C<DOES> is that it allows you
to check whether an object does a role without caring about I<how>
it does the role.

This module tells Moose that after setting up the delegation to a Role
it needs to also declare that the class now performs that role.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=MooseX-Does-Delegated>.

=head1 SEE ALSO

L<Moose::Manual::Delegation>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

