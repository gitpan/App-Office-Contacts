#!/bin/bash

bu.perl.sh App-Office-Contacts

perl Makefile.PL

make

make install

make dist

scripts/populate.db.sh

mv App-Office-Contacts-2.00.tar.gz ~/savage.net.au/Perl-modules

gss
