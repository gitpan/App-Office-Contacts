package App::Office::Contacts::Controller::Notes;

use parent 'App::Office::Contacts::Controller';
use common::sense;

use App::Office::Contacts::Controller::Exporter::Notes qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.13';

# -----------------------------------------------

1;
