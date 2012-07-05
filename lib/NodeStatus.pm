package NodeStatus;

use strict;
use Rose::DB::Object;
use NephologyServer::DB;

use base qw(Rose::DB::Object);


__PACKAGE__->meta->setup
(
	table => 'node_status',
	columns => [
		status_id => {
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

sub init_db { NephologyServer::DB->new }
