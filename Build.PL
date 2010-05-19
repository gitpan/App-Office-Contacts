use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'App::Office::Contacts',
	license        => 'artistic',
	dist_abstract  => 'A web-based contacts manager',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		Test::Simple => 0.94,
		Test::Pod    => 1.41,
	},
	requires =>
	{
		CGI                        => 3.49,
		CGI::Application           => 4.31,
		CGI::Application::Dispatch => 2.17,
		CGI::Session               => 4.42,
		common::sense              => 3.0,
		Config::Tiny               => 2.12,
		Data::UUID                 => 1.203,
		Data::Verifier             => 0.31,
		DateTime                   => 0.55,
		Date::Simple               => 3.03,
		DBD::SQLite                => 1.29,
		DBI                        => 1.611,
		DBIx::Admin::CreateTable   => 2.04,
		Digest::SHA                => 5.48,
		FindBin::Real              => 1.05,
		HTML::Template             => 2.9,
		JSON::XS                   => 2.29,
		Log::Dispatch              => 2.26,
		Log::Dispatch::Config      => 1.03,
		Log::Dispatch::DBI         => 0.02,
		Moose                      => 0.98,
		MooseX::LogDispatch        => 1.2000,
		namespace::autoclean       => 0.09,
		parent                     => 0.218,
		Path::Class                => 0.18,
		Sub::Exporter              => 0.982,
},
);

$builder -> add_build_element('conf');
$builder -> create_build_script();

