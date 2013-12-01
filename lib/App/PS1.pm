package App::PS1;

# Created on: 2011-06-21 09:47:36
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp qw/cluck/;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Term::ANSIColor;
use base qw/Class::Accessor::Fast/;

eval { require Term::Colour256 };
my $t256 = !$EVAL_ERROR;

our $VERSION = version->new('0.0.1');

__PACKAGE__->mk_accessors(qw/ ps1 cols plugins bw low exit parts safe theme/);

my %theme = (
    default => {
        # name          Low Colour  Hi Colour
        background   => [ 'black' , 'on_52'  ],
        marker       => [ 'black' , 246      ],
        up_time      => [ 'yellow', 'yellow' ],
        up_label     => [ 'black' , 'black'  ],
        branch       => [ 'cyan'  , 'cyan'   ],
        branch_label => [ 'black' , 'black'  ],
        date         => [ 'red'   , 'red'    ],
        face_happy   => [ 'green' , 46       ],
        face_sad     => [ 'red'   , 202      ],
        dir_name     => [ 'blue'  , 'blue'   ],
        dir_label    => [ 'black' , 'black'  ],
        dir_size     => [ 'cyan'  , 'cyan'   ],
    },
);

sub new {
    my ($class, $params) = @_;
    my $self = $class->SUPER::new($params);

    $self->safe( $ENV{UNICODE_UNSAFE} ) if !defined $self->safe;
    $self->theme("default")             if !defined $self->theme;

    $theme{ $self->theme } ||= {};
    for my $name ( keys %{ $theme{ $self->theme } } ) {
        if ( my $env = $ENV{ 'APP_PS1_' . uc $name } ) {
            $theme{ $self->theme }{$name} = [ ( $env ) x 2 ];
        }
    }

    return $self;
}

sub sum(@) { ## no critic
    my $i = 0;
    $i += $_ || 0 for (@_);
    return $i;
}

sub cmd_prompt {
    my ($self) = @_;
    my $out = '';
    $self->parts([]);

    for my $param ( split /;/, $self->ps1 ) {
        my ( $plugin, $options ) = split /(?=[{])/, $param;
        next if $plugin !~ /^[a-z]+$/;
        next if !$self->load($plugin);

        $options = $options ? eval $options : {}; ## no critic
        my ($text, $size) = $self->$plugin($options);

        if ($size) {
            push @{$self->parts}, [ $text, $size ];
        }
    }

    my $total = $self->parts_size;
    my $spare = $self->cols - $total;
    my $spare_size = $spare / ( @{$self->parts} - 1 );
    if ( $total <= $self->cols ) {
        my $line = '';
        my $extra = 0;
        for my $i ( 0 .. @{$self->parts} - 2 ) {
            my $div_first  = $i ? 2 : 1;
            my $div_second = $i == @{$self->parts} - 2 ? 1 : 2;
            my $spaces;
            if ( $total < $self->cols / 2 ) {
                $spaces = ( $self->cols / ( @{$self->parts} - 1 ) - $self->parts->[$i][0] / $div_first - $self->parts->[$i + 1][0] / $div_second );
            }
            else {
                $spaces = $spare_size;
                $spare -= $spare_size - ( $spaces - int $spaces );
            }
            $extra += $spaces - int $spaces;

            $line .= $self->parts->[$i][1];
            $line .= ' ' x $spaces;
            if ( $extra > 1 ) {
                $line .= ' ' x $extra;
                $spare -= int $extra;
                $extra = $extra - int $extra;
            }
        }
        if ( $extra > 0.1 ) {
            $line .= ' ';
        }
        $line .= $self->parts->[-1][1];

        my $colour = $ENV{APP_PS1_BACKGROUND} || 52;
        $out = $self->colour('background') . $line . "\e[0m\n";
    }

    return $out;
}

sub parts_size {
    my ($self) = @_;
    return sum map { $_->[0] } @{$self->parts};
}

sub load {
    my ($self, $plugin) = @_;

    $self->plugins({}) if !$self->plugins;

    return 1 if $self->plugins->{$plugin};

    my $module = 'App::PS1::Plugin::' . ucfirst $plugin;
    my $file   = 'App/PS1/Plugin/' . ( ucfirst $plugin ) . '.pm';
    eval { require $file };
    warn $@ if $@;
    return 0 if $@;

    push @App::PS1::ISA, $module;

    return $self->plugins->{$plugin} = 1;
}

sub surround {
    my ($self, $count, $text) = @_;

    return if !defined $text;

    my $left  = $self->safe ? '≺' : '<';
    my $right = $self->safe ? '≻' : '>';

    $count += 2;
    $text = $self->colour('marker') . "$left$text" . $self->colour('marker') . $right;
    return ($count, $text);
}

sub colour {
    my ($self, $name) = @_;
    my $colour = $theme{$self->theme}{$name} || [];
    return
          $self->bw || !$colour ? ''
        : $t256 && !$self->low  ? Term::Colour256::color($colour->[1])
        :                         Term::ANSIColor::color($colour->[0]);
}


1;

__END__

=head1 NAME

App::PS1 - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::PS1 version 0.1.


=head1 SYNOPSIS

   use App::PS1;

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

Return: App::PS1 -

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

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW, Australia 2077)
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
