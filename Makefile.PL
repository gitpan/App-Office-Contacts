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
		FILES => 'blib/* Makefile MANIFEST CGI-Office-Contacts-*'
	},
	dist =>
	{
		COMPRESS => 'gzip',
		SUFFIX   => 'gz'
	},
	DISTNAME  => 'CGI-Office-Contacts',
	NAME      => 'App::Office::Contacts',
	PL_FILES  => {},
	PREREQ_PM =>
	{
		CGI                         => 0,
		CGI::Application            => 0,
		CGI::Session                => 0,
		common::sense               => 3.0,
		Config::Tiny                => 0,
		Data::UUID                  => 1.203,
		Data::Verifier              => 0,
		DateTime                    => 0,
		Date::Simple                => 0,
		DBD::Pg                     => 0,
		DBI                         => 0,
		DBIx::Admin::CreateTable    => 0,
		Digest::SHA                 => 5.48,
		FindBin::Real               => 0,
		HTML::Template              => 0,
		JSON::XS                    => 0,
		Log::Dispatch               => 0,
		Log::Dispatch::Configurator => 0,
		Log::Dispatch::DBI          => 0,
		Moose                       => 0.98,
		MooseX::LogDispatch         => 1.2000,
		namespace::autoclean        => 0.09,
		parent                      => 0.218,
		Path::Class                 => 0,
		Sub::Exporter               => 0,
	},
	VERSION_FROM => 'lib/CGI/Office/Contacts.pm',
);
