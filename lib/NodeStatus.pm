package Nephology::NodeStatus;

use strict;
use Rose::DB::Object;
use Nephology::DB;

use base qw(Rose::DB::Object);


__PACKAGE__->meta->setup
(
	table => 'node_status',
	columns => [
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
		template => {
			type     => 'varchar',
			length   => 45,
			not_null => 1,
		},
		next_status => {
			type => 'int',
			length => 11,
		}
	]
);

sub init_db { Nephology::DB->new }
