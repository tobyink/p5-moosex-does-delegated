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
     package Foo::Bar;
     use Moose::Role;

     requires 'foo';
     requires 'bar';

     package Foo::Baz;
     use Moose;

     sub foo { 'Foo::Baz::FOO' }
     sub bar { 'Foo::Baz::BAR' }
     sub baz { 'Foo::Baz::BAZ' }

     package Foo::Thing;
     use Moose;
     use MooseX::Does::Delegated;

     has 'thing' => (
         is      => 'rw',
         isa     => 'Foo::Baz',
         handles => 'Foo::Bar',
     );

     package Foo::OtherThing;
     use Moose;
     use Moose::Util::TypeConstraints;
     use MooseX::Does::Delegated;

     has 'other_thing' => (
         is      => 'rw',
         isa     => 'Foo::Baz',
         handles => Moose::Util::TypeConstraints::find_type_constraint('Foo::Bar'),
     );
 }


{
    my $foo = Foo::Thing->new();
    ok($foo->does('Foo::Bar'));
    ok(not $foo->does('Foo::Baz'));
}

{
    my $foo = Foo::OtherThing->new();
    ok($foo->does('Foo::Bar'));
    ok(not $foo->does('Foo::Baz'));
}

{
    package Foo::Blub;
    use Moose::Role;
    requires 'glub';

    package Foo::Bonk;
    use Moose::Role;
    with qw(Foo::Bar Foo::Blub);
    sub foo {1}
    sub bar {1}
    sub glub {1}

    package Foo::YAThing;
    use Moose;
    use MooseX::Does::Delegated;
    has 'ya_thing' => (
        is      => 'rw',
        does    => 'Foo::Bonk',
        handles => 'Foo::Bonk',
    );
}

{
    my $foo = Foo::YAThing->new;
    ok($foo->does('Foo::Bonk'));
    ok($foo->does('Foo::Bar'));
    ok($foo->does('Foo::Blub'));
}


{

    package Foo::OneLessThing;
    use Moose;
    has 'thing' => (
         is      => 'rw',
         isa     => 'Foo::Baz',
         handles => 'Foo::Bar',
     );

    package Foo::OneMoreThing;
    use Moose;
    use MooseX::Does::Delegated;
    extends qw(Foo::OneLessThing);
}


{
    my $no_foo = Foo::OneLessThing->new();
    ok(not $no_foo->does('Foo::Bar'));
}
TODO: {
    local $TODO = "probably won't work until we're in core";
    my $foo = Foo::OneMoreThing->new();
    ok($foo->does('Foo::Bar'));
}

done_testing;
