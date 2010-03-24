package App::Office::Contacts::View::Report;

use Moose;

extends 'App::Office::Contacts::View::Base';

with 'App::Office::Contacts::View::Role::Report';

use namespace::autoclean;

our $VERSION = '1.05';

# -----------------------------------------------

sub generate_report
{
	my($self, $input, $report_name) = @_;

	# There is only one possible report for Contacts.
	# See also App::Office::Contacts::Donations::View::Report.

	return $self -> generate_record_report($input);

} # End of generate_report.

# -----------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
