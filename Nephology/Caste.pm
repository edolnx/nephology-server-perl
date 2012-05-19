package Nephology::Caste;

use strict;
use Nephology::DB;

use base qw(Rose::DB::Object);

__PACKAGE__->meta->setup
(
    table => 'caste',
    columns =>
    [
        id => {
            type        => 'int',
            length      => 11,
            primary_key => 1,
            not_null    => 1,
        },
        ctime => {
            type     => 'datetime',
            not_null => 1,
        },
        mtime => {
            type     => 'datetime',
            not_null => 1,
        },
        description => {
            type     => 'varchar',
            length   => 200,
            not_null => 1,
        },
    ]
);

sub init_db { Nephology::DB->new }
