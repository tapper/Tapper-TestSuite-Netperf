#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Tapper::TestSuite::Netperf' );
}

diag( "Testing Tapper::TestSuite::Netperf $Tapper::TestSuite::Netperf::VERSION, Perl $], $^X" );
