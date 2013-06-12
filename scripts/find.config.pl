#!/usr/bin/env perl

use strict;
use warnings;

use File::ShareDir;

# --------------

my($app_name)    = 'App-Office-Contacts';
my($config_name) = '.htapp.office.contacts.conf';
my($path)        = File::ShareDir::dist_file($app_name, $config_name);

print "Using: File::ShareDir::dist_file('$app_name', '$config_name'): \n";
print "Found: $path\n";
