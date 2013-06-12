#!/usr/bin/env perl

use App::Office::Contacts::Util::Export;

# -------------------------------

print App::Office::Contacts::Util::Export -> new -> as_csv;
