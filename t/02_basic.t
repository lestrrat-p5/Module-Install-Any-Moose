use Test::More tests => 7;
use File::Path qw(rmtree);

BEGIN {
    rmtree("t/inc", 0, 1);
}

use inc::Module::Install;

# Set it so that prompt() doesn't get stuc

$ENV{PERL_MM_USE_DEFAULT} = 1;
requires_any_moose;
requires_any_moose 'X::AttributeHelpers';

my $extensions = $Module::Install::MAIN->{extensions};
foreach my $ext (@$extensions) {
    next unless ref $ext && $ext->isa('Module::Install::Metadata');

    my %requires = map { @$_ } @{$ext->requires};
    is( $requires{'Any::Moose'}, '0.04' );
    is( $requires{'Mouse'}, '0' );
    is( $requires{'MouseX::AttributeHelpers'}, '0' );
    is( scalar keys %requires, 3 );

    my %recommends = map { @$_ } @{$ext->recommends};
    is( $recommends{'Moose'}, '0' );
    is( $recommends{'MooseX::AttributeHelpers'}, '0' );
    is( scalar keys %recommends, 2 );
    last;
}

END {
    rmtree("t/inc", 0, 1);
}
