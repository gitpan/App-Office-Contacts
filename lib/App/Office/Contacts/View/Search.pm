package App::Office::Contacts::View::Search;

use Moose;

extends 'App::Office::Contacts::View::Base';

use namespace::autoclean;

our $VERSION = '1.17';

# -----------------------------------------------

sub build_search_tab
{
	my($self) = @_;

	$self -> log(debug => 'Entered build_search_tab');

	my($search_js)   = $self -> load_tmpl('search.js');
	my($search_html) = $self -> load_tmpl('search.tmpl');

	$search_js -> param(form_action => $self -> form_action);
	$search_js -> param(sid         => $self -> session -> id);
	$search_html -> param(sid       => $self -> session -> id);

	# Make YUI happy by turning the HTML into 1 long line.

	$search_html = $search_html -> output;
	$search_html =~ s/\n//g;

	return ($search_js -> output, $search_html);

} # End of build_search_tab.

# -----------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
