package App::PS1::Plugin::Branch;

# Created on: 2011-06-21 09:48:47
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use English qw/ -no_match_vars /;
use Path::Class;

our $VERSION = 0.001;

sub branch {
    my ($self) = @_;
    my ($type, $branch);
    my $dir = dir('.')->resolve->absolute;
    my $git = git();
    my $cvs = cvs();
    while ( $dir ne $dir->parent ) {
        if ( -f $dir->file('.git', 'HEAD') ) {
            $type = 'git';
            $branch = $dir->subdir('.git')->file('HEAD')->slurp;
            chomp $branch;
            $branch =~ s/^ref: \s+ refs\/heads\/(.*)/$1/xms;
            if ( length $branch == 40 && $branch =~ /^[\da-f]+$/ ) {
                my ($ans) = map {/^[*] [(]detached from (.*)[)]$/; $1} grep {/^[*]\s/} `$git branch --contains $branch`;
                $branch = "[$ans]" if $ans;
            }
        }
        elsif (-f $dir->file('CVS', 'Tag')) {
            $type = 'cvs';
            $branch = $dir->file('CVS', 'Tag')->slurp;
            chomp $branch;
            $branch =~ s/^N//;
            $branch = "($branch)";
        }
        elsif (-d $dir->file('CVS')) {
            $type   = 'cvs';
            $branch = 'master';
        }
        last if $type;
        $dir = $dir->parent;
    }
    return if !$type;

    return $self->surround( 4 + length $branch, $self->colour('branch_label') . $type . ' ' . $self->colour('branch') . $branch );
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

This documentation refers to App::PS1::Plugin::Branch version 0.001.

=head1 SYNOPSIS

   use App::PS1::Plugin::Branch;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head3 C<branch ()>

If the current is under source code control returns the current branch etc

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
