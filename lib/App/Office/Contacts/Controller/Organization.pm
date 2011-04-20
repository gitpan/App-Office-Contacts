package App::Office::Contacts::Controller::Organization;

use parent 'App::Office::Contacts::Controller';
use strict;
use warnings;

use App::Office::Contacts::Controller::Exporter::Organization qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.16';

# -----------------------------------------------

1;
