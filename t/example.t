use strict;

use Test::More tests => 3;
use Test::Mojo;

my $t = Test::Mojo->new('NephologyServer');

$t->get_ok('/')->status_is(200)->content_is('It works!');
