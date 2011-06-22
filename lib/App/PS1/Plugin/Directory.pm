package App::PS1::Plugin::Directory;

# Created on: 2011-06-21 09:48:32
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp;
use Scalar::Util;
use List::Util;
#use List::MoreUtils;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Path::Class;
use base qw/App::PS1::Plugin/;

our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();
#our @EXPORT      = qw//;

sub directory {
    my ($self) = @_;

    my $dir  = dir('.')->absolute;
    my $home = dir($ENV{HOME});
    my $dir_display = "$dir";

    if ($home->subsumes($dir) ) {
        $dir_display =~ s/$home/~/xms;
    }

    my $len = length $dir_display;

    my @details = ( $len, $self->colour('blue','blue') . $dir_display );

    my @children = $dir->children;
    my $dir_count  = 0;
    my $file_count = 0;
    my $size       = 0;
    for my $file (@children) {
        if ( -d $file ) {
            $dir_count++;
        }
        else {
            $file_count++;
            $size += -s $file || 0;
        }
    }
    $size
        = $size > 10_000_000_000 ? sprintf "%dGiB"  , $size / 2**30
        : $size >    900_000_000 ? sprintf "%.1dGiB", $size / 2**30
        : $size >     10_000_000 ? sprintf "%dMiB"  , $size / 2**20
        : $size >        900_000 ? sprintf "%.1dMiB", $size / 2**20
        : $size >         10_000 ? sprintf "%dKiB"  , $size / 2**10
        : $size >            900 ? sprintf "%.1dKiB", $size / 2**10
        :                          $size;
    my $dir_length  = 6 + length $dir_count;
    my $file_length = 7 + length $file_count;
    my $size_length = 1 + length $size;
    $dir_count  = $self->colour('black','black') . " dir:"  . $self->colour('cyan','cyan') . "$dir_count,";
    $file_count = $self->colour('black','black') . " file:" . $self->colour('cyan','cyan') . "$file_count,";
    $size       = $self->colour('black','black') . " "      . $self->colour('cyan','cyan') . $size;

    my $arb = @{$self->parts} + $self->parts_size;
    if ( $details[0] + $dir_length + $file_length + $size_length + $arb < $self->cols ) {
        $details[0] += $dir_length + $file_length + $size_length;
        $details[1] .= $dir_count . $file_count . $size;
    }
    elsif ( $details[0] + $file_length + $size_length + $arb < $self->cols ) {
        $details[0] += $file_length + $size_length;
        $details[1] .= $file_count . $size;
    }
    elsif ( $details[0] + $size_length + $arb - 5 < $self->cols ) {
        $details[0] += $size_length;
        $details[1] .= $size;
    }

    return $self->surround(@details);
}

1;

__END__

=head1 NAME

App::PS1::Plugin::Directory - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::PS1::Plugin::Directory version 0.1.


=head1 SYNOPSIS

   use App::PS1::Plugin::Directory;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.

These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module
provides.

Name the section accordingly.

In an object-oriented module, this section should begin with a sentence (of the
form "An object of this class represents ...") to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: App::PS1::Plugin::Directory -

Description:

=cut


=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)
<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011 Optus (1 Lyon Park Rd, Macquarie Park, NSW, Australia).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
