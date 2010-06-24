package App::Office::Contacts::Util::LogConfig;

use parent 'Log::Dispatch::Configurator';

use App::Office::Contacts::Util::Config;

use Moose;

has config => (is => 'rw', isa => 'HashRef', required => 0);

use namespace::autoclean;

our $VERSION = '1.13';

# -----------------------------------------------

sub get_attrs
{
	my($self)   = @_;
	my($config) = $self -> config;

	return
	{
		class      => 'Log::Dispatch::DBI',
		datasource => $$config{dsn},
		min_level  => $$config{min_log_level},
		name       => __PACKAGE__,
		password   => $$config{password},
		table      => 'log',
		username   => $$config{username},
	};

} # End of get_attrs.

# -----------------------------------------------

sub get_attrs_global
{
	my($self) = @_;

	return
	{
		dispatchers => ['db'],
		format      => undef,
	};

} # End of get_attrs_global.

# -----------------------------------------------

sub new
{
	my($class, %arg) = @_;
	my($self)        = bless({}, $class);

	$self -> config($self -> config || App::Office::Contacts::Util::Config -> new -> config);

	return $self;

}	# End of new.

# -----------------------------------------------

__PACKAGE__ -> meta -> make_immutable(inline_constructor => 0);

1;
