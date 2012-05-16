package Tapper::TestSuite::Netperf::Server;
# ABSTRACT: Tapper - Network performance measurements - Server

        use Moose;
        use IO::Handle;
        use IO::Socket::INET;

=head1 METHODS

=head2 run

Main function of Netperf::Server.

@return success - 0
@return error   - error string

=cut
        sub run {
                my ($self) = @_;

                my $srv = IO::Socket::INET->new( LocalPort => 5000, Listen => 5);
                return "Can not open server socket:$!" if not $srv;
                my $msg_sock = $srv->accept();
                my $buf;
                while ($msg_sock->sysread($buf, 1024)) {
                        $msg_sock->syswrite($buf, length($buf));
                }
                return 0;
        }

1;

__END__

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

=cut
