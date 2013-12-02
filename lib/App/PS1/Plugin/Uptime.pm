package App::PS1::Plugin::Uptime;

# Created on: 2011-06-21 09:49:08
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Term::ANSIColor;
use Path::Class;

our $VERSION = version->new('0.0.1');

sub uptime {
    my ($self) = @_;
    my ($uptime) = eval { split /\s+/, file('/proc/uptime')->slurp };

    return if !$uptime;

    my $days = int $uptime / 60 / 60 / 24;
    my $hours = int ( ( $uptime - $days * 60 * 60 * 24 ) / 60 / 60 );
    my $minutes = int ( ( $uptime - $days * 60 * 60 * 24 - $hours * 60 * 60 ) / 60 );

    my $up = sprintf "%dd%dh%dm", $days, $hours, $minutes;
    my $length = length $up;
    $up = $self->colour('up_time') . $up;

    return $self->surround( 4 + $length, $self->colour('up_label') . "up: $up" );
}

1;

__END__

=head1 NAME

App::PS1::Plugin::Uptime - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::PS1::Plugin::Uptime version 0.1.

=head1 SYNOPSIS

   use App::PS1::Plugin::Uptime;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: App::PS1::Plugin::Uptime -

Description:

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
