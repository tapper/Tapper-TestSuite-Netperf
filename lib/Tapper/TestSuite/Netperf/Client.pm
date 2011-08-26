use MooseX::Declare;

class Tapper::TestSuite::Netperf::Client extends Tapper::TestSuite::Netperf {

        use IO::Socket::INET;
        use YAML;

        our $netperf_desc = "benchmarks-netperf";

=head1 NAME

Tapper::TestSuite::Netperf::Server - Tapper - Network performance measurements - Client

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

=head1 METHODS

=cut

=head2 tap_report_away

Actually send the tap report to receiver.

@param string - report to be sent

@return success - (0, report id)
@return error   - (1, error string)

=cut

        method tap_report_away($tap)
        {
                my $reportid;
                if (my $sock = IO::Socket::INET->new(PeerAddr => $ENV{TAPPER_REPORT_SERVER},
                                                     PeerPort => $ENV{TAPPER_REPORT_PORT},
                                                     Proto    => 'tcp')) {
                        eval{
                                my $timeout = 100;
                                local $SIG{ALRM}=sub{die("timeout for sending tap report ($timeout seconds) reached.");};
                                alarm($timeout);
                                ($reportid) = <$sock> =~m/(\d+)$/g;
                                $sock->print($tap);
                        };
                        alarm(0);
                        $self->log->error($@) if $@;
                        close $sock;
                } else {
                        return(1,"Can not connect to report server: $!");
                }
                return (0,$reportid);

        }

=head2 tap_report_send

Send information of current test run status to report framework using TAP
protocol.

@param array -  report array

@return success - (0, report id)
@return error   - (1, error string)

=cut

        method tap_report_send($report)
        {
                my $tap = $self->tap_report_create($report);
                $self->log->debug($tap);
                return $self->tap_report_away($tap);
        }


=head2 tap_report_create

Create a report string from a report in array form. Since the function only
does data transformation, no error should ever occur.

@param int   - test run id
@param array -  report array

@return report string

=cut

        method tap_report_create($report)

        {
                my @report   = @$report;
                my $hostname = $ENV{TAPPER_HOSTNAME};
                my $testrun  = $ENV{TAPPER_TESTRUN};
                $hostname = $hostname // 'No hostname set';
                my $message;
                $message .= "1..".scalar @report."\n";
                $message .= "# Tapper-reportgroup-testrun: $testrun\n";
                $message .= "# Tapper-suite-name: Netperf\n";
                $message .= "# Tapper-suite-version: $Tapper::TestSuite::Netperf::VERSION\n";
                $message .= "# Tapper-machine-name: $hostname\n";

                # @report starts with 0, reports start with 1
                for (my $i=0; $i<=$#report; $i++) {
                        chomp($report[$i]);
                        $message .="$report[$i]\n";
                }
                return ($message);
        }


=head2 get_bandwidth

Get network bandwidth on network to server given as network socket.

@param socket  - connected to server

@return string - report message string

=cut

        method get_bandwidth($socket)
        {
                my ($buf1, $buf2, $start_time, $end_time, $msg, $size);
                my $offset=0; # get rid of warning

                $size           = 1024*1024*32;
                $buf1           = 'U'x($size);
                $start_time     = time();
                my $tmpbuf;
                while ($offset < length($buf1)) {
                        $offset += $socket->syswrite($buf1, 1024, $offset);
                        $socket->sysread($tmpbuf, 1024);
                        $buf2  .= $tmpbuf;
                }
                $end_time = time();
                $end_time++ if not $end_time > $start_time;
                $msg      = 'not ' unless $buf1 eq $buf2;
                $msg     .= "ok - benchmarks-custom";
                $msg     .= "\n   ---";
                $msg     .= "\n   bytes_per_second: "; $msg .= ($size)/(($end_time-$start_time)*1.0);
                $msg     .= "\n   length_send_buffer: "; $msg .= length($buf1);
                $msg     .= "\n   length_receive_buffer: "; $msg .= length($buf2);
                $msg     .= "\n   ...\n";
                return $msg;
        }

=head2 parse_netperf

Parse output of netperf command.

=cut

        method parse_netperf($server, $netperf_file)
        {
                my $output = `$netperf_file -P0 $server`;
                if ($output !~ m/^[0-9. ]+$/) {
                        $output =~ s/\n/\n#/gx;
                        return "not ok - $netperf_desc\n#$output";
                
                }
                $output=~s|^\s*(\S)|$1|;
                my @output = split /\s+/,$output;

                return "ok - $netperf_desc
   ---
   recv_socket_size_bytes: $output[0]
   send_socket_size_bytes: $output[1]
   send_message_size_bytes: $output[2]
   time: $output[3]
   throughput: $output[4]
   ...
";
        }


=head2

Run the netperf client.

@param

@return success - 0
@return error   - error string

=cut

        method run
        {
                my $config_file = $ENV{TAPPER_SYNC_FILE};
                return "Config file is not set" if not $config_file;

                my @report;
                my $peers = YAML::LoadFile($config_file);
                # even though, server and client are synced by PRC, the
                # server may take a little more time to set up than the
                # client so give it some extra time
                sleep(2); 
                my $socket = IO::Socket::INET->new(PeerHost => $peers->[0], PeerPort => 5000);
                my $msg;
                $msg  = 'not ' if not $socket;
                $msg .= "ok - Connect to peer";
                push @report, $msg;

                $msg = $self->get_bandwidth($socket);
                push @report, $msg;

                my $netperf_file = `which netperf`;
                chomp($netperf_file);
                if (-e $netperf_file) {
                        $msg = $self->parse_netperf($peers->[0], $netperf_file);
                        push @report, $msg;
                }
                else {
                        push @report, 'not ok - $netperf_desc # SKIP no netperf available in PATH';
                }

                my ($fail, $retval) = $self->tap_report_send(\@report);
                return $retval if $fail;
                return 0;
        }
}

1;

__END__

=head1 NAME

Tapper::TestSuite::Netperf::Server - Tapper - Wrapper for Network performance measurements - Server

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

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
