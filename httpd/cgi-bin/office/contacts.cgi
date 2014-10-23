#!/usr/bin/env perl
#
# Name:
# contacts.cgi.

use strict;
use warnings;

use CGI;
use CGI::Application::Dispatch;

# ---------------------

CGI::Application::Dispatch -> dispatch
(
 args_to_new => {QUERY => CGI -> new},
 prefix      => 'App::Office::Contacts::Controller',
 table       =>
 [
  ''              => {app => 'Initialize', rm => 'display'},
  ':app'          => {rm => 'display'},
  ':app/:rm/:id?' => {},
 ],
);
