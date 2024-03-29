package App::PS1::Plugin::Env;

# Created on: 2011-06-21 09:48:15
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;

our $VERSION = 0.08;

sub env {
    my ($self, $options) = @_;
    my $out = '';
    for my $name (sort keys %$options) {
        next if !$ENV{$options->{$name}};

        $out .= ', ' if $out;
        $out .= "$name: $ENV{$options->{$name}}";
    }

    return $self->surround(
        length $out,
        $out,
    );
}

1;

__END__

=head1 NAME

App::PS1::Plugin::Env - Shows the value/state of requested environment variables for displaying on the prompt

=head1 VERSION

This documentation refers to App::PS1::Plugin::Env version 0.08.

=head1 SYNOPSIS

   use App::PS1::Plugin::Env;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

Allows the addition of environment variables on the prompt

=head1 SUBROUTINES/METHODS

=head3 C<env ()>

Returns requested environment variables for the prompt

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW, Australia 2077)
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
