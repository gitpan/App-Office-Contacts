package App::Office::Contacts::Controller::Person;

use parent 'App::Office::Contacts::Controller';
use common::sense;

use App::Office::Contacts::Controller::Exporter::Person qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.07';

# -----------------------------------------------

1;
