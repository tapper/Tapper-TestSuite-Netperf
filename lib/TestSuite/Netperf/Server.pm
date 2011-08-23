use MooseX::Declare;

class Tapper::TestSuite::Netperf::Server {

=head1 NAME

Tapper::TestSuite::Netperf::Server - Tapper - Network performance measurements - Server

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

=head1 METHODS

=cut

        use IO::Handle;
        use IO::Socket::INET;

=head2 run

Main function of Netperf::Server.

@return success - 0
@return error   - error string

=cut
        method run
        {
                my $srv = IO::Socket::INET->new( LocalPort => 5000, Listen => 5);
                return "Can not open server socket:$!" if not $srv;
                my $msg_sock = $srv->accept();
                my $buf;
                while ($msg_sock->sysread($buf, 1024)) {
                        $msg_sock->syswrite($buf, length($buf));
                }
                return 0;
        }
}

1;

__END__

=head1 BUGS

Please report any bugs or feature requests to
C<bug-tapper-testsuite-netperf at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-TestSuite-Netperf>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::TestSuite::Netperf


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tapper-TestSuite-Netperf>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tapper-TestSuite-Netperf>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tapper-TestSuite-Netperf>

=item * Search CPAN

L<http://search.cpan.org/dist/Tapper-TestSuite-Netperf/>

=back


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd


=cut
