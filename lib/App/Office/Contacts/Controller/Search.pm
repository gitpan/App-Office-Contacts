package App::Office::Contacts::Controller::Search;

use parent 'App::Office::Contacts::Controller';
use strict;
use warnings;

use App::Office::Contacts::Controller::Exporter::Search qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.16';

# -----------------------------------------------

1;
