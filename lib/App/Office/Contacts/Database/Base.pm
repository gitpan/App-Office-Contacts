package App::Office::Contacts::Database::Base;

use Moose;

extends 'App::Office::Contacts::Base';

has db => (is => 'ro', isa => 'Any', required => 1);

use namespace::autoclean;

our $VERSION = '1.17';

# -----------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
