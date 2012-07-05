package Node;

use strict;
use Rose::DB::Object;
use NephologyServer::DB;

our @ISA = qw(Rose::DB::Object);


__PACKAGE__->meta->setup
(
	table => 'node',
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
		asset_tag => {
			type     => 'varchar',
			length   => 10,
			not_null => 1,
		},
		hostname => {
			type     => 'varchar',
			length   => '50',
			not_null => 1,
		},
		boot_mac => {
			type     => 'varchar',
			length   => '20',
			not_null => 1,
		},
		admin_user => {
			type     => 'varchar',
			length   => '20',
			not_null => 1,
		},
		admin_password => {
			type     => 'varchar',
			length   => '100',
			not_null => 1,
		},
		ipmi_user => {
			type     => 'varchar',
			length   => '20',
			not_null => 1,
		},
		ipmi_password => {
			type     => 'varchar',
			length   => '100',
			not_null => 1,
		},
		caste_id => {
			type     => 'int',
			length   => 11,
			not_null => 1,
		},
		status_id => {
			type     => 'int',
			length   => 11,
			default  => 1,
		},
		domain => {
			type     => 'varchar',
			length   => 50,
			not_null => 1,
		},
		primary_ip => {
			type     => 'varchar',
			length   => 50,
			not_null => 1,
		},
	],

	foreign_keys => [
		category => {
		    class => 'Category',
		    key_columns => {
			caste_id => 'id',
		    }
		},
	],
);


sub init_db { NephologyServer::DB->new }
