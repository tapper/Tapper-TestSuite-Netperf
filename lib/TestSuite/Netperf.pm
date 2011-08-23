package TestSuite::Netperf;

use Moose;

with 'MooseX::Log::Log4perl';

our $VERSION = '3.000001';

1; # End of Tapper::TestSuite::Netperf

__END__

=head1 NAME

Tapper::TestSuite::Netperf - Tapper - Network performance measurements

=head1 SYNOPSIS

You most likely want to run the frontend cmdline tool like this

  # host 1
  $ tapper-testsuite-netperf-server

  # host 2
  $ tapper-testsuite-netperf-client

=head1 BUGS

Please report any bugs or feature requests to
C<bug-tapper-testsuite-autotest at rt.cpan.org>, or through the web
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

