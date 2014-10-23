package App::Office::Contacts::View::Report;

use strict;
use utf8;
use warnings;
use warnings  qw(FATAL utf8);    # Fatalize encoding glitches.
use open      qw(:std :utf8);    # Undeclared streams in UTF-8.
use charnames qw(:full :short);  # Unneeded in v5.16.

use Moo;

extends 'App::Office::Contacts::View::Base';

with 'App::Office::Contacts::View::Role::Report';

our $VERSION = '2.00';

# -----------------------------------------------

sub generate_report
{
	my($self, $result) = @_;

	# There is only one possible report for Contacts.
	# See also App::Office::Contacts::Donations::View::Report.

	return $self -> generate_record_report($result);

} # End of generate_report.

# -----------------------------------------------

1;

=head1 NAME

App::Office::Contacts::View::Report - A web-based contacts manager

=head1 Synopsis

See L<App::Office::Contacts/Synopsis>.

=head1 Description

L<App::Office::Contacts> implements a utf8-aware, web-based, private and group contacts manager.

=head1 Distributions

See L<App::Office::Contacts/Distributions>.

=head1 Installation

See L<App::Office::Contacts/Installation>.

=head1 Object attributes

Each instance of this class extends L<App::Office::Contacts::View::Base>, with these attributes:

=over 4

=item o (None)

=back

=head1 Methods

=head2 generate_report($result)

Calls L<App::Office::Contacts::View::Role::Report/generate_record_report($result)>.

=head1 FAQ

See L<App::Office::Contacts/FAQ>.

=head1 Support

See L<App::Office::Contacts/Support>.

=head1 Author

C<App::Office::Contacts> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2013.

L<Home page|http://savage.net.au/index.html>.

=head1 Copyright

Australian copyright (c) 2013, Ron Savage.
	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License V 2, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
