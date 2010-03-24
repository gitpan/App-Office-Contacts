#!/usr/bin/perl
#
# Run with:
# 1)
# Edit .htoffice.contacts.conf to change tmpl_path to /dev/shm...
# 2) One of:
# start_server --port=127.0.0.1:5003 -- starman --workers 2 httpd/cgi-bin/office/contacts.psgi &
# or
# plackup --host 127.0.0.1 --port 5003 httpd/cgi-bin/office/contacts.psgi

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
