package App::Office::Contacts::Controller::Exporter::Search;

use strict;
use warnings;

use JSON::XS;

use Sub::Exporter -setup =>
{
	exports =>
	[qw/
		display
	/],
};

our $VERSION = '1.16';

# -----------------------------------------------

sub display
{
	my($self) = @_;

	$self -> log(debug => 'Entered display');

	my($name)          = $self -> query -> param('target') || '';
	my($organizations) = $self -> param('db') -> organization -> get_organizations($self -> param('user_id'), $name);
	my($people)        = $self -> param('db') -> person -> get_people($self -> param('user_id'), $name);
	my($row)           =
	[
		# We put people before organizations. Do not use 'sort' here because
		# of the way we've formatted multiple entries for each person/org.

		@{$self -> param('view') -> person -> format_search_result($name, $people)},
		@{$self -> param('view') -> organization -> format_search_result($name, $organizations)},
	];

	my($result);

	if ($#$row >= 0)
	{
		$result = {results => [@$row]};
	}
	else
	{
		$result = {results => [{name => "No names match '$name'"}]};
	}

	return JSON::XS -> new -> utf8 -> encode($result);

} # End of display.

# -----------------------------------------------

1;
