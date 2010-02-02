package App::Office::Contacts::Database;

use App::Office::Contacts::Database::EmailAddress;
use App::Office::Contacts::Database::Notes;
use App::Office::Contacts::Database::Occupation;
use App::Office::Contacts::Database::Organization;
use App::Office::Contacts::Database::Person;
use App::Office::Contacts::Database::PhoneNumber;
use App::Office::Contacts::Database::Util;

use DBI;

use Moose;

extends 'App::Office::Contacts::Base';

has config        => (is => 'ro', isa => 'HashRef', required => 1);
has dbh           => (is => 'rw', isa => 'Any');
has email_address => (is => 'rw', isa => 'App::Office::Contacts::Database::EmailAddress');
has notes         => (is => 'rw', isa => 'App::Office::Contacts::Database::Notes');
has occupation    => (is => 'rw', isa => 'App::Office::Contacts::Database::Occupation');
has organization  => (is => 'rw', isa => 'App::Office::Contacts::Database::Organization');
has person        => (is => 'rw', isa => 'App::Office::Contacts::Database::Person');
has phone_number  => (is => 'rw', isa => 'App::Office::Contacts::Database::PhoneNumber');
has util          => (is => 'rw', isa => 'Any');

use namespace::autoclean;

our $VERSION = '1.02';

# -----------------------------------------------

sub BUILD
{
	my($self)   = @_;
	my($config) = $self -> config;
	my($attr)   =
	{
		AutoCommit => $$config{'AutoCommit'},
		RaiseError => $$config{'RaiseError'},
	};

	$self -> dbh(DBI -> connect($$config{'dsn'}, $$config{'username'}, $$config{'password'}, $attr) );

	$self -> email_address(App::Office::Contacts::Database::EmailAddress -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> notes(App::Office::Contacts::Database::Notes -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> occupation(App::Office::Contacts::Database::Occupation -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> organization(App::Office::Contacts::Database::Organization -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> person(App::Office::Contacts::Database::Person -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> phone_number(App::Office::Contacts::Database::PhoneNumber -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

	$self -> init;

}	# End of BUILD.

# --------------------------------------------------

sub init
{
	my($self) = @_;

	$self -> util(App::Office::Contacts::Database::Util -> new
	(
		db     => $self,
		logger => $self -> logger,
	) );

} # End of init.

# --------------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
