package Tapper::TestSuite::Netperf;
# ABSTRACT: Tapper - Network performance measurements

use Moose;

with 'MooseX::Log::Log4perl';

1; # End of Tapper::TestSuite::Netperf

__END__

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

=cut
