package App::Office::Contacts::Controller::Report;

use parent 'App::Office::Contacts::Controller';
use common::sense;

use App::Office::Contacts::Controller::Exporter::Report qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.09';

# -----------------------------------------------

1;
