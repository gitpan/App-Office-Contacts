package App::Office::Contacts::Util::Config;

use strict;
use warnings;

use Config::Tiny;

use File::HomeDir;

use Moose;

use Path::Class;

has config =>
(
 is       => 'rw',
 isa      => 'Any',
 required => 0,
);

has config_file_path =>
(
 is       => 'rw',
 isa      => 'Path::Class::File',
 required => 0,
);

has config_name =>
(
 default  => '.htoffice.contacts.conf',
 is       => 'rw',
 isa      => 'Str',
 required => 0,
);

has section =>
(
 is       => 'rw',
 isa      => 'Str',
 required => 0,
);

use namespace::autoclean;

our $VERSION = '1.16';

# -----------------------------------------------

sub BUILD
{
	my($self) = @_;
	my($path) = Path::Class::file(File::HomeDir -> my_dist_config('App-Office-Contacts'), $self -> config_name);

	$self -> init($path);

} # End of BUILD.

# -----------------------------------------------

sub init
{
	my($self, $path) = @_;

	$self -> config_file_path($path);

	# Check [global].

	$self -> config(Config::Tiny -> read($path) );

	if (Config::Tiny -> errstr)
	{
		die Config::Tiny -> errstr;
	}

	$self -> section('global');

	if (! ${$self -> config}{$self -> section})
	{
		die "Config file '$path' does not contain the section [@{[$self -> section]}]";
	}

	# Check [x] where x is host=x within [global].

	$self -> section(${$self -> config}{$self -> section}{'host'});

	if (! ${$self -> config}{$self -> section})
	{
		die "Config file '$path' does not contain the section [@{[$self -> section]}]";
	}

	# Move desired section into config, so caller can just use $self -> config to get a hashref.

	$self -> config(${$self -> config}{$self -> section});

}	# End of init.

# --------------------------------------------------

__PACKAGE__ -> meta -> make_immutable;

1;
