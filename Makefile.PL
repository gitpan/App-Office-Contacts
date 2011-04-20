use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
 ($] ge '5.005') ?
 (
  AUTHOR   => 'Ron Savage (ron@savage.net.au)',
  ABSTRACT => 'A web-based contacts manager',
 ) : (),
 clean =>
 {
	 FILES => 'blib/* Makefile MANIFEST App-Office-Contacts-*'
 },
 dist =>
 {
	 COMPRESS => 'gzip',
	 SUFFIX   => 'gz'
 },
 DISTNAME  => 'App-Office-Contacts',
 NAME      => 'App::Office::Contacts',
# Next line runs copy.config.pl when user runs 'make'.
# Warning: '...' => 0 is OK but => '' or undef are ignored.
 PL_FILES  => {'scripts/copy.config.pl' => 'Copying...'},
 PREREQ_PM =>
 {
	 CGI::Application            => 4.31,
	 CGI::Application::Dispatch  => 2.17,
	 CGI::Session                => 4.42,
	 Config::Tiny                => 2.12,
	 Data::UUID                  => 1.203,
	 Data::Verifier              => 0.31,
	 DateTime                    => 0.55,
	 DBD::SQLite                 => 1.29,
	 DBI                         => 1.611,
	 DBIx::Admin::CreateTable    => 2.04,
	 Digest::SHA                 => 5.48,
	 File::Copy                  => 2.18,
	 File::HomeDir               => 0.97,
	 FindBin                     => 1.49,
	 HTML::Template              => 2.9,
	 JSON::XS                    => 2.29,
	 Log::Dispatch               => 2.26,
	 Log::Dispatch::Configurator => 1.00,
	 Log::Dispatch::DBI          => 0.02,
	 Moose                       => 0.98,
	 Moose::Role                 => 1.21,
	 MooseX::LogDispatch         => 1.2000,
	 namespace::autoclean        => 0.09,
	 parent                      => 0.218,
	 Path::Class                 => 0.23,
	 Perl6::Slurp                => 0.03,
	 Sub::Exporter               => 0.982,
	 Test::Simple                => 0.94,
	 Test::Pod                   => 1.41,
 },
 VERSION_FROM => 'lib/App/Office/Contacts.pm',
);
