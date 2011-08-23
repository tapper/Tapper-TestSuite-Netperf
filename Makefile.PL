use inc::Module::Install;

name     'Tapper-TestSuite-Netperf';
all_from 'lib/Tapper/TestSuite/Netperf.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More';

requires 'MooseX::Declare';
requires 'IO::Socket::INET';
requires 'YAML';
requires 'IO::Socket::INET';
requires 'IO::Handle';
requires 'Moose';
requires 'MooseX::Log::Log4perl';

auto_install;

install_script glob('bin/*');

WriteAll;


