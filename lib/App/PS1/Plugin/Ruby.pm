package App::PS1::Plugin::Ruby;

# Created on: 2011-06-21 09:48:47
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use English qw/ -no_match_vars /;
use Path::Class;
use base qw/App::PS1::Plugin/;

our $VERSION = 0.001;

sub ruby {
    my ($self) = @_;
    my $name = $ENV{RUBY_VERSION};
    return if !$name;

    my ($version) = $name =~ /^ruby-([\d.]+)/;

    return if !$version;

    return $self->surround( 5 + length $version, $self->colour('branch_label') . 'ruby ' . $self->colour('branch') . $version );
}

1;

__END__

=head1 NAME

App::PS1::Plugin::Ruby - Shows current version of ruby if using rvm

=head1 VERSION

This documentation refers to App::PS1::Plugin::Ruby version 0.001.

=head1 SYNOPSIS

   use App::PS1::Plugin::Ruby;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<ruby ()>

Determines the current version of Ruby if using C<rvm>.

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

Copyright (c) 2011 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
