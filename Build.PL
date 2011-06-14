use Module::Build;

my $class = Module::Build->subclass(code => <<'EOF');

sub ACTION_build
{
	my $self = shift;
	$self->SUPER::ACTION_build(@_);
	$self->run_perl_script('scripts/copy.config.pl');
}
EOF

$class -> new
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
 configure_requires =>
 {
 	 Module::Build => 0.3800,
 },
 requires =>
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
	 File::Copy                  => 2.14,
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
 },
) -> create_build_script();

