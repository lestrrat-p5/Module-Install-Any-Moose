
package Module::Install::Any::Moose;
use strict;
use Module::Install::Base;

use vars qw($VERSION @ISA $ISCORE);
BEGIN {
    $VERSION = '0.00001';
    $ISCORE  = 0;
    @ISA     = qw(Module::Install::Base);
}

sub any_moose_requires {
    my ($self, $module, $version, $other_version) = @_;
    $version ||= 0;
    $other_version ||= 0;

    $self->requires($module, $version);

    my $alt;
    if ($module =~ s/^(Mo[ou]se)?/
        if ($1 eq 'Moose') {
            $alt = 'Mouse';
        } else {
            $alt = 'Moose';
        }
        $alt;
    /ex) {
        my $default;
        if ($alt eq 'Mouse') { # This is more like a requirement
            $default = 'y';
        } else {
            $default = 'n';
        }

        print "[Any::Moose support for $module]\n",
              "- $module ... ";

        # ripped out of ExtUtils::MakeMaker
        my $file = "$module.pm";
        $file =~ s{::}{/}g;
        eval { require $file };

        my $pr_version = $module->VERSION || 0;
        $pr_version =~ s/(\d+)\.(\d+)_(\d+)/$1.$2$3/;

        if ($@) {
            print "missing\n";
            my $y_n = ExtUtils::MakeMaker::prompt("  Add $module to the prerequisites?", $default);
            if ($y_n =~ /^y(?:es)?$/i) {
                $self->requires($module, $other_version);
            }
        } else {
            print "loaded ($pr_version)\n";
        }
    }
}

1;

__END__

=head1 NAME

Module::Install::Any::Moose - Any::Moose Support For Module::Install

=head1 SYNOPSIS 

    use inc::Module::Install;

    # your usual stuff...

    # This will ask the user if MouseX::AttributeHelpers should be installed
    any_moose_requires 'MooseX::AttributeHelpers'; 

    WriteAll;

=head1 SPECIFYING VERSIONS

If you need specific versions, here's what you can do

    any_moose_requires 'MooseX::AttributeHelpers' => '0.13', '0.01';

The second version string is taken as the version of the other Mo[ou]se
counterpart.

=cut