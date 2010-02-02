package App::Office::Contacts::Controller::Person;

use base 'App::Office::Contacts::Controller';
use strict;
use warnings;

use App::Office::Contacts::Controller::Exporter::Person qw/-all/;

# We don't use Moose because we isa CGI::Application.

our $VERSION = '1.02';

# -----------------------------------------------

1;
