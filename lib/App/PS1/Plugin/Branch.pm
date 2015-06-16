package App::PS1::Plugin::Branch;

# Created on: 2011-06-21 09:48:47
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use English qw/ -no_match_vars /;
use Path::Tiny;

our $VERSION = 0.003;

sub branch {
    my ($self) = @_;
    my ($type, $branch);
    my $dir = eval { path('.')->realpath };
    my $git = git();
    my $cvs = cvs();
    while ( $dir ne $dir->parent ) {
        if ( -f $dir->child('.git', 'HEAD') ) {
            $type = 'git';
            $branch = $dir->child('.git')->child('HEAD')->slurp;
            chomp $branch;
            $branch =~ s/^ref: \s+ refs\/heads\/(.*)/$1/xms;
            if ( length $branch == 40 && $branch =~ /^[\da-f]+$/ ) {
                my ($ans) = map {/^[*] [(]detached from (.*)[)]$/; $1} grep {/^[*]\s/} `$git branch --contains $branch`;
                $branch = "[$ans]" if $ans;
            }
        }
        elsif (-f $dir->child('CVS', 'Tag')) {
            $type = 'cvs';
            $branch = $dir->child('CVS', 'Tag')->slurp;
            chomp $branch;
            $branch =~ s/^N//;
            $branch = "($branch)";
        }
        elsif (-f $dir->child('CVS', 'Root')) {
            $type   = 'cvs';
            $branch = 'master';
        }

        last if $type;
        $dir = $dir->parent;
    }

    return if !$type;

    $type = $self->cols && $self->cols > 40 ? "$type " : '';

    my $max_branch_width = ( $self->cols || 80 ) / 3;
    if ($max_branch_width > 60) {
        $max_branch_width = 60;
    }
    if ( length $branch > $max_branch_width ) {
        $branch = substr $branch, 0, $max_branch_width;
        $branch .= '...';
    }

    return $self->surround(
        length $type . $branch,
        $self->colour('branch_label') . $type
        . $self->colour('branch') . $branch
    );
}

sub git {
    for (split /:/, $ENV{PATH}) {
        return "$_/git" if -x "$_/git";
    }
    return 'git';
}

sub cvs {
    for (split /:/, $ENV{PATH}) {
        return "$_/cvs" if -x "$_/cvs";
    }
    return 'cvs';
}

1;

__END__

=head1 NAME

App::PS1::Plugin::Branch - Adds the current branch to prompt

=head1 VERSION

This documentation refers to App::PS1::Plugin::Branch version 0.003.

=head1 SYNOPSIS

   use App::PS1::Plugin::Branch;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head3 C<branch ()>

If the current is under source code control returns the current branch etc

=head3 C<git ()>

Returns the full path for the git executable

=head3 C<cvs ()>

Returns the full path for the cvs executable

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
