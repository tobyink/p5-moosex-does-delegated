package MooseX::Does::Delegates::Meta::Attribute::Trait;
use Moose::Role;
Moose::Util::meta_attribute_alias('Delegated');

after install_delegation  => sub {
    my ($self) = @_;

    return unless $self->has_handles;

    my $handles = $self->handles;
    if (ref $handles) {
        return unless blessed($handles) && $handles->isa('Moose::Meta::TypeConstraint::Role');
        $handles = $handles->role;
    }

    Moose::Util::_load_user_class($handles);
    my $role_meta = Class::MOP::class_of($handles);
    $self->associated_class->add_role($role_meta);
};

1
__END__
