#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1 + 1;
use Test::NoWarnings;

BEGIN {
	use_ok( 'App::PS1' );
}

diag( "Testing App::PS1 $App::PS1::VERSION, Perl $], $^X" );
