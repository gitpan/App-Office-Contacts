package App::Office::Contacts::Controller;

use parent 'App::Office::Contacts';
use common::sense;

use App::Office::Contacts::Database;
use App::Office::Contacts::Util::Config;
use App::Office::Contacts::View;

use Log::Dispatch;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.09';

# -----------------------------------------------

sub cgiapp_prerun
{
	my($self, $rm) = @_;

	# Can't call, since logger not yet set up.
	#$self -> log(debug => 'Entered cgiapp_prerun');

	$self -> param(config => App::Office::Contacts::Util::Config -> new -> config);

	# Set up half the logger, but don't use it until the dbh is available.

	$self -> param(logger => Log::Dispatch -> new);

	# Set up the database.

	$self -> param(db => App::Office::Contacts::Database -> new);

	# Set up the things shared by:
	# o App::Office::Contacts
	# o App::Office::Contacts::Donations
	# o App::Office::Contacts::Import::vCards

	$self -> global_prerun;

	# Set up the view.

	$self -> param(view => App::Office::Contacts::View -> new
	(
		db          => $self -> param('db'),
		script_name => $self -> script_name,
		session     => $self -> param('session'),
		tmpl_path   => $self -> tmpl_path,
	) );

} # End of cgiapp_prerun.

# -----------------------------------------------

1;
