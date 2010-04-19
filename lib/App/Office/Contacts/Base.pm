package App::Office::Contacts::Base;

use App::Office::Contacts::Util::LogConfig;

use Moose;

with 'MooseX::LogDispatch';

has log_dispatch_conf =>
(
	is => 'ro',
	lazy => 1,
	default => sub{App::Office::Contacts::Util::LogConfig -> new},
);

use namespace::autoclean;

our $VERSION = '1.09';

# -----------------------------------------------
# This sub is copied from App::Office::Contacts.
# This version is for Moose-base modules.
# CGI::Application-based modules have their own version.

sub log
{
	my($self, $level, $s) = @_;
	$level ||= 'info';

	if ($s)
	{
		$s = (caller)[0] . ". $s";
		$s =~ s/^App::Office::Contacts/\*/;
	}

	$self -> logger -> $level($s || '');

} # End of log.

# --------------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
