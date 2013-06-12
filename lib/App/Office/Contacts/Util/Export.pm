package App::Office::Contacts::Util::Export;

use strict;
use utf8;
use warnings;
use warnings  qw(FATAL utf8);    # Fatalize encoding glitches.
use open      qw(:std :utf8);    # Undeclared streams in UTF-8.
use charnames qw(:full :short);  # Unneeded in v5.16.

use App::Office::Contacts::Database;

use CGI;

use Encode; # For decode().

use Moo;

use Text::Xslate 'mark_raw';

extends qw/App::Office::Contacts::Util::Logger App::Office::Contacts::Database::Base/;

has whole_page =>
(
	default  => 0,
	is       => 'rw',
	isa      => 'Any',
	required => 0,
);

our $VERSION = '2.01';

# -----------------------------------------------

sub BUILD
{
	my($self) = @_;

	$self -> db
	(
		App::Office::Contacts::Database -> new
		(
			logger        => $self -> logger,
			module_config => $self -> module_config,
			query         => CGI -> new,
		)
	);

}	# End of BUILD.

# -----------------------------------------------

sub as_csv
{
	my($self) = @_;

	my(@row);

	push @row,
	[
		'Name', 'Upper name',
	];

	for my $person (@{$self -> read_people_table})
	{
		push @row,
		[
			$$person{name},
			$$person{upper_name},
		];
	}

	for (@row)
	{
		print '"', join('","', @$_), '"', "\n";
	}

}	# End of as_csv.

# -----------------------------------------------

sub as_html
{
	my($self) = @_;

	return 'TODO';

} # End of as_html.

# -----------------------------------------------

sub read_people_table
{
	my($self)   = @_;
	my(@people) = $self -> db -> simple -> query('select name, upper_name from people order by name') -> hashes;

	my(@person);

	for my $person (@people)
	{
		push @person,
		{
			name       => decode('utf8', $$person{name}),
			upper_name => decode('utf8', $$person{upper_name}),
		};
	}

	return [sort{$$a{name} cmp $$b{name} } @person];

} # End of read_people_table.

# -----------------------------------------------

1;

=head1 NAME

App::Office::Contacts::Util::Export - A web-based contacts manager

=head1 Synopsis

See L<App::Office::Contacts/Synopsis>.

=head1 Description

L<App::Office::Contacts> implements a utf8-aware, web-based, private and group contacts manager.

=head1 Distributions

See L<App::Office::Contacts/Distributions>.

=head1 Installation

See L<App::Office::Contacts/Installation>.

=head1 Object attributes

Extends both L<App::Office::Contacts::Util::Logger> and L<App::Office::Contacts::Database::Base>, and
has these attributes:

=over 4

=item o whole_page

Is a Boolean.

Specifies whether or not as_html() outputs a web page or just a HTML table.

Default: 0.

=back

Further, each attribute name is also a method name.

=head1 Methods

=head2 as_csv()

Prints 2 columns (name, upper_name) of the I<people> table, in CSV format.

=head2 as_html()

Not implemented.

=head2 read_people_table()

Reads 2 columns (name, upper_name) from the I<people> table.

=head2 whole_page()

Returns a Boolean, which specifies whether or not as_html() outputs a web page or just a HTML table.

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
