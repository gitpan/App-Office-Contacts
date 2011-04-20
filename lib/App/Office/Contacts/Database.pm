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

has dbh           => (is => 'rw', isa => 'Any');
has email_address => (is => 'rw', isa => 'App::Office::Contacts::Database::EmailAddress');
has notes         => (is => 'rw', isa => 'App::Office::Contacts::Database::Notes');
has occupation    => (is => 'rw', isa => 'App::Office::Contacts::Database::Occupation');
has organization  => (is => 'rw', isa => 'App::Office::Contacts::Database::Organization');
has person        => (is => 'rw', isa => 'App::Office::Contacts::Database::Person');
has phone_number  => (is => 'rw', isa => 'App::Office::Contacts::Database::PhoneNumber');
has util          => (is => 'rw', isa => 'Any');

use namespace::autoclean;

our $VERSION = '1.16';

# -----------------------------------------------

sub BUILD
{
	my($self)   = @_;
	my($config) = $self -> log_dispatch_conf -> config;
	my($attr)   =
	{
		AutoCommit => $$config{AutoCommit},
		RaiseError => $$config{RaiseError},
	};

	$self -> dbh(DBI -> connect($$config{dsn}, $$config{username}, $$config{password}, $attr) );

	if ( ($$config{dsn} =~ /SQLite/i) && $$config{sqlite_unicode})
	{
		my($dbh)              = $self -> dbh;
		$$dbh{sqlite_unicode} = 1;

		$self -> dbh($dbh);
	}

	$self -> email_address(App::Office::Contacts::Database::EmailAddress -> new
	(
		db => $self,
	) );

	$self -> notes(App::Office::Contacts::Database::Notes -> new
	(
		db => $self,
	) );

	$self -> occupation(App::Office::Contacts::Database::Occupation -> new
	(
		db => $self,
	) );

	$self -> organization(App::Office::Contacts::Database::Organization -> new
	(
		db => $self,
	) );

	$self -> person(App::Office::Contacts::Database::Person -> new
	(
		db => $self,
	) );

	$self -> phone_number(App::Office::Contacts::Database::PhoneNumber -> new
	(
		db => $self,
	) );

	$self -> init;

}	# End of BUILD.

# --------------------------------------------------

sub init
{
	my($self) = @_;

	$self -> util(App::Office::Contacts::Database::Util -> new
	(
		db => $self,
	) );

} # End of init.

# --------------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
