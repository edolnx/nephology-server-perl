package MapCasteRule;

use strict;
use NephologyServer::DB;

use base qw(Rose::DB::Object);

__PACKAGE__->meta->setup
(
	table => 'map_caste_rule',
	columns => [
		caste_id => {
			type        => 'int',
			length      => 11,
			primary_key => 1,
			not_null    => 1,
		},
		caste_rule_id => {
			type        => 'int',
			length      => 11,
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
		priority => {
			type        => 'int',
			length      => 11,
			not_null    => 1,
		},
	],
	foreign_keys => [
		caste => {
			class => 'Caste',
			key_columns => {
				caste_id => 'id',
			},
		},
		caste_rule => {
			class => 'CasteRule',
			key_columns => {
				caste_rule_id => 'id',
			},
		},
	],
);

sub init_db { NephologyServer::DB->new }
