package App::Office::Contacts;

use parent 'CGI::Application';
use common::sense;

use CGI::Session;

use Data::UUID;

use Digest::SHA;

use Log::Dispatch::DBI;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.13';

# -----------------------------------------------

sub build_about_html
{
	my($self, $user_id) = @_;

	$self -> log(debug => 'Entered build_about_html');

	my($config)   = $self -> param('config');
	my($template) = $self -> load_tmpl('table.even.odd.tmpl', loop_context_vars => 1);
	my($user)     = $user_id ? $self -> param('db') -> person -> get_person($user_id, $user_id) : [{name => 'N/A'}];
	$user         = $$user[0]{'name'} ? $$user[0]{'name'} : 'No-one is logged on';

	my(@tr);

	push @tr, {left_td => 'Program', right_td => "$$config{'program_name'} $$config{'program_version'}"};
	push @tr, {left_td => 'Author',  right_td => $$config{'program_author'} };
	push @tr, {left_td => 'Help',    right_td => qq|<a href="$$config{'program_faq_url'}">FAQ</a>|};
	#push @tr, {left_td => 'Current user', right_td => $user_id};

	$template -> param(tr_loop => \@tr);

	# Make YUI happy by turning the HTML into 1 long line.

	$template = $template -> output;
	$template =~ s/\n//g;

	return $template;

} # End of build_about_html.

# -----------------------------------------------

sub build_head_init
{
	my($self, $search_html) = @_;

	$self -> log(debug => 'Entered build_head_init');

	my($about_html)        = $self -> build_about_html;
	my($organization_html) = $self -> param('view') -> organization -> build_add_organization_html;
	my($person_html)       = $self -> param('view') -> person -> build_add_person_html;
	my($report_html)       = $self -> param('view') -> report -> build_report_html;

	# These things are called by YAHOO.util.Event.onDOMReady(init).

	my($head_init) = <<EJS;

// Outer tabs.

search_tab = new YAHOO.widget.Tab
({
	label: "Search",
	content: '$search_html',
	active: true
});
tab_set.addTab(search_tab);
search_tab.addListener('click', make_search_name_focus);

add_tab = new YAHOO.widget.Tab
({
	label: "Add",
	content: '<div id="add_tab"></div>'
});
tab_set.addTab(add_tab);

report_tab = new YAHOO.widget.Tab
({
	label: "Report",
	content: '$report_html'
});
tab_set.addTab(report_tab);

about_tab = new YAHOO.widget.Tab
({
	label: "About",
	content: '$about_html'
});
tab_set.addTab(about_tab);

// Inner tabs.

add_person_tab = new YAHOO.widget.Tab
({
	label: "Add Person",
	content: '$person_html',
	active: true
});
inner_tab_set.addTab(add_person_tab);

add_organization_tab = new YAHOO.widget.Tab
({
	label: "Add Organization",
	content: '$organization_html'
});
inner_tab_set.addTab(add_organization_tab);

// Add outer tab set to document.

tab_set.appendTo("container");

// Add inner tab set to outer tab.
// WTF: Must do the above /before/ adding inner tabs to outer tab.

inner_tab_set.appendTo("add_tab");

make_search_name_focus();

// Sigh: The calendars default to not having a current date.

var calendar_element = YAHOO.util.Dom.get("from_calendar_div");

if (calendar_element !== null)
{
	var today = new Date();
	today = today.toLocaleDateString();
	from_calendar = new YAHOO.widget.Calendar("from_calendar_div", {navigator: {}, selected: today, start_weekday: 1});
	from_calendar.render();
	to_calendar = new YAHOO.widget.Calendar("to_calendar_div", {navigator: {}, selected: today, start_weekday: 1});
	to_calendar.render();
}

EJS

	return $head_init;

} # End of build_head_init.

# -----------------------------------------------

sub build_search_tab
{
	my($self) = @_;

	$self -> log(debug => 'Entered build_search_tab');

	my($search_js)   = $self -> load_tmpl('search.js');
	my($search_html) = $self -> load_tmpl('search.tmpl');

	$search_js -> param(form_action => $self -> script_name);
	$search_js -> param(sid         => $self -> param('session') -> id);
	$search_html -> param(sid       => $self -> param('session') -> id);

	# Make YUI happy by turning the HTML into 1 long line.

	$search_html = $search_html -> output;
	$search_html =~ s/\n//g;

	return ($search_js -> output, $search_html);

} # End of build_search_tab.

# -----------------------------------------------

sub build_web_page
{
	my($self) = @_;

	$self -> log(debug => 'Entered build_web_page');

	# Generate the web page itself. This is not loaded by sub cgiapp_init(),
	# because, with AJAX, we only need it the first time the script is run.

	my($page)       = $self -> load_tmpl('web.page.tmpl');
	my(@search_tab) = $self -> build_search_tab;

	$page -> param(css_url   => ${$self -> param('config')}{'css_url'});
	$page -> param(head_init => $self -> build_head_init($search_tab[1]) );
	$page -> param(head_js   => $self -> build_head_js($search_tab[0]) );
	$page -> param(yui_url   => ${$self -> param('config')}{'yui_url'});

	return $page -> output;

} # End of build_web_page.

# -----------------------------------------------

sub generate_cookie
{
	my($self, $cookie_name) = @_;

	return; # Rig.

	$self -> log(debug => "Entered generate_cookie: $cookie_name");

	# Ensure the Initialize run mode outputs a cookie.

	if ($self -> param('app') eq '')
	{
		my($cookie) = $self -> query -> cookie(-name => $cookie_name, -value => $self -> generate_digest($cookie_name) );

		$self -> header_add(-cookie => $cookie);
	}

} # End of generate_cookie.

# -----------------------------------------------

sub generate_digest
{
	my($self, $cookie_name) = @_;
	my($digest) = Digest::SHA -> new(256);
	my($uuid)   = Data::UUID -> new -> create_str;

	$digest -> add($uuid);

	$digest = $digest -> hexdigest;

	$self -> log(debug => "UUID:   $uuid");
	$self -> log(debug => "Digest: $digest");

	$self -> param('session') -> param($cookie_name => $digest);

	return $digest;

} # End of generate_digest.

# -----------------------------------------------

sub global_prerun
{
	my($self) = @_;

	# Outputs nothing, since logger not yet set up.
	#$self -> log(debug => 'Entered global_prerun');

	# Set up the 2nd part of the logger. The 1st part was set up in
	# App::Office::Contacts::Controller.cgiapp_prerun().

	$self -> param('logger') -> add
	(
		Log::Dispatch::DBI -> new
		(
			dbh       => $self -> param('db') -> dbh,
			min_level => ${$self -> param('config')}{'min_log_level'},
			name      => __PACKAGE__,
		)
	);

	# Set up a few more things.

	$self -> param('db') -> util -> set_table_map;
	$self -> param(user_id => 0);      # 0 means we don't have anyone logged on.
	$self -> run_modes([qw/display/]); # Other controllers add their own run modes.
	$self -> tmpl_path(${$self -> param('config')}{'tmpl_path'});

	# Log the CGI form parameters.

	my($q) = $self -> query;

	$self -> log(info => '');
	$self -> log(info => $q -> url(-full => 1, -path => 1) );
	$self -> log(debug => 'Request method: ' . $q -> request_method);
	$self -> log(debug => "Param: $_: " . $q -> param($_) ) for $q -> param;

	# Set up the session.

	$self -> param(session =>
	CGI::Session -> new
	(
		${$self -> param('config')}{'session_driver'},
		$q,
		{
			Handle    => $self -> param('db') -> dbh,
			TableName => ${$self -> param('config')}{'session_table_name'},
		},
		{
			name => 'sid',
		}
	) );

	$self -> log(info => 'Session id: ' . $self -> param('session') -> id);
 	$self -> log(debug => 'tmpl_path: ' . $self -> tmpl_path);

}	# End of global_prerun.

# -----------------------------------------------
# This sub is copied from App::Office::Contacts::Base.
# This version is for CGI::Application-based modules.
# Moose-based modules have their own version.

sub log
{
	my($self, $level, $s) = @_;
	$level ||= 'info';

	if ($s)
	{
		$s = (caller)[0] . ". $s";
		$s =~ s/^App::Office::Contacts/\*/;
	}

	$self -> param('logger') -> $level($s || '');

} # End of log.

# -----------------------------------------------

sub script_name
{
	my($self) = @_;

	my($env);
	my($script_name);

	# Are we running under Plack?

	if ($env = $self -> query -> can('env') )
	{
		# Yes.

		$env         = $self -> query -> env;
		$script_name = $$env{SCRIPT_NAME};
	}
	else
	{
		# No.

		$script_name = $ENV{SCRIPT_NAME};
	}

	return $script_name;

} # End of script_name.

# -----------------------------------------------

sub teardown
{
	my($self) = @_;

	$self -> log(debug => 'Entered teardown');

} # End of teardown.

# -----------------------------------------------
# http://www.freedom-to-tinker.com/blog/wzeller/popular-websites-vulnerable-cross-site-request-forgery-attacks

sub validate_post
{
	my($self, $cookie_name)  = @_;
	my($q)     = $self -> query;
	my(@p)     = $q -> param;
	my($valid) = 1; # Valid.

	return $valid; # Rig.

	$self -> log(debug => "Entered validate_post: $cookie_name");

	# Ensure CGI params are only submitted with POST requests.

	if ( ($#p >= 0) && ($q -> request_method ne 'POST') )
	{
		$self -> log(warning => 'Request method not POST but CGI parameters (i.e. ' . join(', ', @p) . ') present');

		$valid = 0; # Invalid.
	}

	# Ensure the digest param matches the cookie.

	if ($valid && ($#p >= 0) )
	{
		my($cookie_digest)  = $q -> cookie($cookie_name);
		my($session_digest) = $self -> param('session') -> param($cookie_name);

		if ($cookie_digest ne $session_digest)
		{
			$self -> log(warning => 'Cookie digest does not match session digest');
			$self -> log(warning => "Cookie:  $cookie_digest");
			$self -> log(warning => "Session: $session_digest");

			$valid = 0; # Invalid.
		}
	}

	if ($valid == 0)
	{
		$self -> log(warning => 'Redirecting to ' . $q -> url);
		$self -> header_type('redirect');
		$self -> header_props(-url => $q -> url);
	}

	return $valid;

} # End of validate_post.

# -----------------------------------------------

1;

=head1 NAME

C<App::Office::Contacts> - A web-based contacts manager

=head1 Synopsis

The scripts discussed here, I<contacts.cgi> and I<contacts.psgi>, are shipped with this module.

A classic CGI script, I<contacts.cgi>:

	#!/usr/bin/perl

	use strict;
	use warnings;

	use CGI;
	use CGI::Application::Dispatch;

	# ---------------------

	my($cgi) = CGI -> new;

	CGI::Application::Dispatch -> dispatch
	(
		args_to_new => {QUERY => $cgi},
		prefix      => 'App::Office::Contacts::Controller',
		table       =>
		[
		''              => {app => 'Initialize', rm => 'display'},
		':app'          => {rm => 'display'},
		':app/:rm/:id?' => {},
		],
	);

A L<Plack> script, I<contacts.psgi>:

	#!/usr/bin/perl

	use strict;
	use warnings;

	use CGI::Application::Dispatch::PSGI;

	use Plack::Builder;

	# ---------------------

	my($app) = CGI::Application::Dispatch -> as_psgi
	(
		prefix => 'App::Office::Contacts::Controller',
		table  =>
		[
		''              => {app => 'Initialize', rm => 'display'},
		':app'          => {rm => 'display'},
		':app/:rm/:id?' => {},
		],
	);

	builder
{
		enable "Plack::Middleware::Static",
		path => qr!^/(assets|favicon|yui)/!,
		root => '/var/www';
		$app;
	};

For more on Plack, see L<My intro to Plack|http://savage.net.au/Perl/html/plack.for.beginners.html>.

=head1 Description

C<App::Office::Contacts> implements a web-based, private and group, contacts manager.

C<App::Office::Contacts> uses C<Moose>.

Once such a structure is in place, then we can have multiple sites per organization,
or multiple occupations per person, or multiple donations per entity (person or
organization).

For the latter, see C<App::Office::Contacts::Donations>.

=head1 Distributions

This module is available as a Unix-style distro (*.tgz).

See http://savage.net.au/Perl-modules/html/installing-a-module.html for
help on unpacking and installing distros.

=head1 Installation Pre-requisites

=head2 A note to beginners

At various places I refer to a file, lib/App/Office/Contacts/.htoffice.contacts.conf,
shipped in this distro.

Please realize that if you edit this file, you must ensure the copy you are editing
is the one used by the code at run-time.

After a module such as this is installed, the code will look for that file
in the directory where I<Build.PL> or I<Makefile.PL> has installed the code.

The module which reads the file is C<App::Office::Contacts::Util::Config>.

Both I<Build.PL> or I<Makefile.PL> install .htoffice.contacts.conf along with the Perl modules.

So, if you unpack the distro and edit the file within the unpacked code, you'll still need
to copy the patched version into the installed code's directory structure.

There is no need to restart your web server after updating this file.

=head2 The Yahoo User Interface (YUI)

This module does not ship with YUI. You can get it from:

	http://developer.yahoo.com/yui

Most development was done using V 2.8.0r4. The original work was done with an earlier version
of YUI.

Currently, I have no plans to port this code to V 3 of YUI.

See lib/App/Office/Contacts/.htoffice.contacts.conf, around line 70, where it specifies the
URL used by the code to access the YUI.

=head2 The database server

I use Postgres.

So, I create a user and a database, via psql, using:

	shell>psql -U postgres
	psql>create role contact login password 'contact';
	psql>create database contacts owner contact encoding 'UTF8';
	psql>\q

Then, to view the database after using the shipped Perl scripts to create and populate it:

	shell>psql -U contact contacts
	(password...)
	psql>...

If you use another server, patch lib/App/Office/Contacts/.htoffice.contacts.conf,
around lines 22 and 36, where it specifies the database DSN and the CGI::Session driver.

=head1 Installing the module

Install C<App::Office::Contacts> as you would for any C<Perl> module:

Run:

	cpanm App::Office::Contacts

or run

	sudo cpan App::Office::Contacts

or unpack the distro, and then either:

	perl Build.PL
	./Build
	./Build test
	sudo ./Build install

or:

	perl Makefile.PL
	make (or dmake)
	make test
	make install

Either way, you need to install all the other files which are shipped in the distro.

=head2 Install the C<HTML::Template> files

Copy the distro's htdocs/assets/ directory to your web server's doc root.

Specifically, my doc root is /var/www/, so I end up with /var/www/assets/.

=head2 Install the FAQ web page

In lib/App/Office/Contacts/.htoffice.contacts.conf there is a line:

	program_faq_url=/contacts.faq.html

This page is displayed when the user clicks FAQ on the About tab.

A sample page is shipped in docs/html/contacts.faq.html. It has been built from
docs/pod/contacts.faq.pod.

So, copy the latter into your web server's doc root, or generate another version
of the page, using docs/pod/contacts.faq.pod as input.

=head2 Install the trivial CGI script and the Plack script

Copy the distro's httpd/cgi-bin/office/ directory to your web server's cgi-bin/ directory,
and make I<contacts.cgi> executable.

My cgi-bin/ dir is /usr/lib/cgi-bin/, so I end up with /usr/lib/cgi-bin/office/contacts.cgi.

Now I can run http://127.0.0.1/cgi-bin/office/contacts.cgi (but not yet!).

=head2 Creating and populating the database

The distro contains a set of text files which are used to populate constant tables.
All such data is in the data/ directory.

This data is loaded into the 'contacts' database using programs in the distro.
All such programs are in the scripts/ directory.

After unpacking the distro, create and populate the database:

	shell>cd App-Office-Contacts-1.00
	# Naturally, you only drop /pre-existing/ tables :-),
	# so use drop.tables.pl later, when re-building the db.
	#shell>perl -Ilib scripts/drop.tables.pl -v
	shell>perl -Ilib scripts/create.tables.pl -v
	shell>perl -Ilib scripts/populate.tables.pl -v
	shell>perl -Ilib scripts/populate.fake.data.pl -v
	shell>perl -Ilib scripts/report.tables.pl -v

Note: The '-Ilib' means 2 things:

=over 4

=item Perl looks in the current directory structure for the modules

That is, Perl does not use the installed version of the code, if any.

=item The code looks in the current directory structure for .htoffice.contacts.conf

That is, it does not use the installed version of this file, if any.

=back

So, if you leave out the '-Ilib', Perl will use the version of the code which has been
formally installed, and then the code will look in the same place for .htoffice.contacts.conf.

=head2 Start testing

Point your broswer at http://127.0.0.1/cgi-bin/contacts.cgi.

Your first search can then be just 'a', without the quotes.

=head1 Files not shipped with this distro

=over 4

=item C<App::Office::Contacts::Donations>

This code has been written, and runs in a private module, C<Local::Contacts>.

C<Local::Contacts> actually contains all of App::Office::Contacts, including donations,
importing vCards, occupations, sites and a start to sticky label printing.

C<Local::Contacts> has been re-written to split it into several modules,
which are being released one at a time, and to remove the Apache-specific code,
and to start using REST [1] as a way of structuring path infos.

[1] http://en.wikipedia.org/wiki/Representational_State_Transfer

C<App::Office::Contacts::Donations> will be released shortly.

=item C<App::Office::Contacts::Export::StickyLabels>

Much of this code has already been written, but is not yet grafted in from C<Local::Contacts>.

See scripts/mail.labels.pl (not yet shipped) for details. This program creates
data/label_brands.txt and data/label_codes.txt.

These text files are then imported when running scripts/populate.tables.pl.

C<App::Office::Contacts::Export::StickyLabels> will be released shortly.

=item C<App::Office::Contacts::Import::vCards>

This code has also been written, but is not yet grafted in from C<Local::Contacts>.

C<App::Office::Contacts::Import::vCards> will be released shortly.

=item C<App::Office::Contacts::Sites>

This code has also been written, but is not yet grafted in from C<Local::Contacts>.

The country/state/locality/postcode (zipcode) data will be shipped in SQLite format,
as part of C<App::Office::Contacts::Sites>.

Data for Australia and America with be included in the distro.

Note: The country/etc data is imported into whatever database you choose to use for
your contacts database, even if that's another SQLite database.

C<App::Office::Contacts::Sites> will be released shortly.

=back

Lastly, the occupations per person code is not being shipped yet.

=head1 FAQ

=over 4

=item I found a bug! Some subs are called twice! See the log!

Nope, wrong again. These subs are meant to be called twice.

	ron@zoe:~/perl.modules/App-Office-Contacts$ ack build_notes_js
	lib/App/Office/Contacts/Controller/Initialize.pm
	104: my($organization_notes_js)  = $self -> param('view') -> notes -> build_notes_js('organization');
	105: my($person_notes_js)        = $self -> param('view') -> notes -> build_notes_js('person');

This applies to build_donations_js and build_notes_js, at lease.

=item The Report Type menu contains the wrong entries

Perhaps you have not dropped and created the tables properly.

You should edit these files (all in the C<App::Office::Contacts::Donations> scripts/
directory), to suit yourself, and then run them in this order:

=over 4

=item drop.all

=item create.all

=item populate.all

=item populate.fake.data

This last one is for testing only, of course.

=back

The thing to note is that scripts/populate.all, when processing the reports table,
only adds records which are not there already. It can do this because data/reports.txt
for C<App::Office::Contacts> contains 1 record ('Records'), but data/reports.txt for
C<App::Office::Contacts::Donations> only contains records pertaining to donations.

This still means that the entries in the reports table must be names exactly as expected
by the if statement in report.js, function report_onsubmit(). You have been warned.

The corresponding Perl code is in C<App::Office::Contacts::View::Report> and
C<App::Office::Contacts::Donations::View::Report>.

=item Yes, but Contacts can now see the Donations report types

Ahh, yes. That is a design fault.

=item How is the code structured?

MVC (Model-View-Controller).

The sample scripts I<contacts.cgi> and I<contacts> use

	prefix => 'App::Office::Contacts::Controller'

so the files in lib/App/Office/Contacts/Controller are the modules which are run to respond
to http requests.

Files in lib/App/Office/Contacts/View implement views, and those in lib/App/Office/Contacts/Database
implement the model.

Files in lib/App/Office/Contacts/Util are a mixture:

=over 4

=item Config.pm

This is used by all code.

=item Create.pm

This is just used to create tables, populate them, and drop them.

Hence it won't be used by C<CGI> scripts, unless you write such a script yourself.

=item Validator.pm

This is used to validate CGI form data.

=back

=item Why did you use Sub::Exporter?

The way I wrote the code, various pairs of classes, e.g.
C<App::Office::Contacts::Controller::Notes> and
C<App::Office::Contacts::Donations::Controller::Notes>, could share a lot of code,
but they had incompatible parents. Sub::Exporter solved this problem.

It may happen that one day the code is restructured to solve this differently.

=item It seems you use singular words for the names of arrays and array refs.

Yes I do. I think in terms of the nature of each element, not the storage mechanism.

I have switched to plurals for the names of database tables though.

=item What's the database schema?

See docs/contacts.schema.png.

The file was created with dbigraph.pl.

dbigraph.pl ships with C<GraphViz::DBI>. I patched it to use C<GraphViz::DBI::General>.

=item Does the database server have pre-requisites?

The code is DBI-based, of course.

Also, the code assumes the database server supports $dbh -> last_insert_id(undef, undef, $table_name, undef).

=item How do I add tables to the schema?

Do all of these things:

=over 4

=item Choose a new name which does not conflict with names used by Ron's add-on packages!

=item Add the table's name to data/table_names.txt

The table names in this file are stored in the table called I<table_names>,
in the order read in from this file.

Do not change the order of records in this file if you are going to update the
I<table_names> table without recreating the database.

The code has to know which table has which id in that table (I<table_names>), so that
donations, notes and sites can be associated with the correct table, and with the correct
id within that table.

=item Add the table's initialization code to C<App::Office::Contacts::Util::Create>

You'll need code to create, drop and (perhaps) populate your new table.

There are many examples already in that module.

=item Add the table's name to the table called table_names

Do this with a one-off SQL statement, or by following the instructions above about creating and populating the database.

=item Add your code to utilize the new table

=back

=item Please explain the program, text file, and database table names

Programs are shipped in scripts/, and data files in data/.

I prefer to use '.' to separate words in the names of programs.

However, for database table names, I use '_' in case '.' would case problems.

Programs such as mail.labels.pl and populate.tables.pl, use table names for their data files'
names. Hence the '_' in the names of their data files.

=item What do I need to know about the Close tab/Delete/Notes/Sites/Update buttons?

These buttons are at the bottom of the detail forms for entities (i.e. People and Organizations).

They are deliberately in (English) alphabetical order, left-to-right.

So, if the Donations add-on is installed, the Donations button will be between the Delete and
Notes buttons.

=item Where do I get data for Localities and Postcodes?

In Australia, a list of localities and postcodes is available from
http://www1.auspost.com.au/postcodes/.

In America, you can buy a list from companies such as http://www.zipcodeworld.com/index.htm,
who are an official re-seller of US Mail's database.

=item Is printing supported?

Subsets of the entities can be selected for printing to sticky labels.

A huge range of labels is supported via PostScript::MailLabels.

Printing will be shipped as C<App::Office::Contacts::Export::StickyLabels>.

=item Will you re-write it to use a different Javascript library?

No, that would be an unproductive use of my time.

Other such libraries might do a good job, but I don't believe they'll do a better job.

I have published a review of various Javascript libraries [1],
and IMHO YUI is the best.

[1] http://use.perl.org/~Ron+Savage/journal/37726

=item What's with user_id and creator_id?

Ahhh, you've been reading the source code, eh? Well done!

Originally (i.e. in my home-use module Local::Contacts), users had to log on to use this code.

So, there was a known user at all times, and the modules used user_id to identify that user.

Then, when records in (some) tables were created, the value of user_id was stored in the creator_id field.

Now I take the view that you should implement Single Sign-on, meaning this set of modules is never
responsible to tracking who's logged on.

Hence this line in C<App::Office::Contacts::Controller>:

	$self -> param(user_id => 0); # 0 means we don't have anyone logged on.

That in turn means there is now no knowledge of the id of the user who is logged on, if any.

To match this, various table definitions have been changed, so that instead of C<App::Office::Contacts::Util::Create> using:

	creator_id integer not null, references people(id),

the code says:

	creator_id integer not null,

This allows a user_id of 0 to be stored in those tables.

Also, the transaction logging code (since deleted) could identify the user who made each edit.

=item What's special about Person id == 1?

Originally, I stored my own name in the people table, with an id of 1. Well, this was good
for testing, if nothing else.

And there was code in C<App::Office::Contacts::Database::Person>, sub get_people(),
to ensure searches would return my name, when it matched the search key.

In other places, updates and deletes of the person with id == 1 were forbidden.

Also, code in C<App::Office::Contacts::Database::Organization>, sub get_organizations(),
ensured that when I was logged on, my searches would return all organizations which
matched the search key.

The effect was to override the code which implemented private address books.
And this was for the purpose of providing support for users of the code.

Such code has been commented out. I did not delete it in case it needs to be
re-activated in certain circumstances.

I suggest, now, that the Help tab should point to a web page giving details of
whatever support you offer.

=item What about Organization id == 1?

In a similar manner (to Person id == 1), there is a special organization with id == 1, whose name is '-'.

Code relating to this organization has not been commented out.

Do I<not> delete this organization! It is needed.

You can search for all such special code with 'ack Special'. ack is part of App::Ack.

=item What data files have fake data in them?

=over 4

=item data/email_people.txt

=item data/people.txt

=item data/phone_people.txt

=back

=back

=head1 Support

Email the author, or log a bug on RT:

https://rt.cpan.org/Public/Dist/Display.html?Name=App-Office-Contacts

=head1 Author

C<App::Office::Contacts> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2009.

Home page: http://savage.net.au/index.html

=head1 Copyright

Australian copyright (c) 2009, Ron Savage.
	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
