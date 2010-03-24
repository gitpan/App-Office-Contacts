use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'App::Office::Contacts',
	license        => 'artistic',
	dist_abstract  => 'A web-based contacts manager',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		Test::More => 0,
		Test::Pod  => 0,
	},
	requires =>
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
		Path::Class                 => 0,
		Sub::Exporter               => 0,
},
);

$builder -> add_build_element('conf');
$builder -> create_build_script();

