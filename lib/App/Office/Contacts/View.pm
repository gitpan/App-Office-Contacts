package App::Office::Contacts::View;

use App::Office::Contacts::View::Notes;
use App::Office::Contacts::View::Organization;
use App::Office::Contacts::View::Person;
use App::Office::Contacts::View::Report;

use Moose;

extends 'App::Office::Contacts::View::Base';

has notes        => (is => 'rw', isa => 'App::Office::Contacts::View::Notes');
has organization => (is => 'rw', isa => 'App::Office::Contacts::View::Organization');
has person       => (is => 'rw', isa => 'App::Office::Contacts::View::Person');
has report       => (is => 'rw', isa => 'Any');

use namespace::autoclean;

our $VERSION = '1.05';

# -----------------------------------------------

sub BUILD
{
	my($self) = @_;

	# init is called in this way so that both this module and
	# App::Office::Contacts::Donations::View will use the
	# appropriate config and db parameters to initialize their
	# attributes.

	$self -> init;

}	# End of BUILD.

# -----------------------------------------------

sub build_display_detail_js
{
	my($self) = @_;

	$self -> log(debug => 'Entered build_display_detail_js');

	my($js) = $self -> load_tmpl('display.detail.js');

	$js -> param(form_action => $self -> script_name);
	$js -> param(sid         => $self -> session -> id);

	return $js -> output;

} # End of build_display_detail_js.

# --------------------------------------------------

sub init
{
	my($self) = @_;

	$self -> log(debug => 'Entered init');

	$self -> notes(App::Office::Contacts::View::Notes -> new
	(
		db          => $self -> db,
		script_name => $self -> script_name,
		session     => $self -> session,
		tmpl_path   => $self -> tmpl_path,
	) );

	$self -> organization(App::Office::Contacts::View::Organization -> new
	(
		db          => $self -> db,
		script_name => $self -> script_name,
		session     => $self -> session,
		tmpl_path   => $self -> tmpl_path,
	) );

	$self -> person(App::Office::Contacts::View::Person -> new
	(
		db          => $self -> db,
		script_name => $self -> script_name,
		session     => $self -> session,
		tmpl_path   => $self -> tmpl_path,
	) );

	$self -> report(App::Office::Contacts::View::Report -> new
	(
		db          => $self -> db,
		script_name => $self -> script_name,
		session     => $self -> session,
		tmpl_path   => $self -> tmpl_path,
	) );

} # End of init.

# --------------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
