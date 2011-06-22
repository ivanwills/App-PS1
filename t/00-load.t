#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1 + 1;
use Test::NoWarnings;

BEGIN {
	use_ok( 'PS1' );
}

diag( "Testing PS1 $PS1::VERSION, Perl $], $^X" );
