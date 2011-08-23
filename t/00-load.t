#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'TestSuite::Netperf' );
}

diag( "Testing TestSuite::Netperf $TestSuite::Netperf::VERSION, Perl $], $^X" );
