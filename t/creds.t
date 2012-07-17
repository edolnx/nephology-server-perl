use strict;

use Test::More tests => 9;
use Test::Mojo;
use Test::MockObject;

my $t = Test::Mojo->new('NephologyServer');

#
# Test no node found by hostname
#
my $mock = Test::MockObject->new();
$mock->fake_module('Node::Manager',
	get_nodes => sub { undef });

print "\n===============================================================\n";
print "Test getting a 404 using a hostname that doesn't match any node\n";
print "===============================================================\n";
$t->get_ok('/creds/foo')
  ->status_is(404)
  ->content_is('Node [foo] not found');


print "\n===============================================================\n";
print "Test successfully looking up a node by hostname\n";
print "===============================================================\n";
my $expected_nodes = [bless({
		ctime          => 'null',
		primary_ip     => '127.0.0.1',
		mtime          => 'null',
		boot_mac       => '8:2b:cb:5f:6c:7b',
		caste_id       => '16',
		domain         => 'foo.dhcompute.net',
		ipmi_password  => 'secret',
		asset_tag      => '6860',
		hostname       => 'peon6860',
		admin_user     => 'root',
		id             => '1',
		admin_password => 'another_secret',
		ipmi_user      => 'root',
		status_id      => '1000',
	}, 'Node')
];

my $expected_json = '{"ctime":"null","primary_ip":"127.0.0.1","mtime":"null","boot_mac":"8:2b:cb:5f:6c:7b","caste_id":"16","hostname":"peon6860","domain":"foo.dhcompute.net","ipmi_password":"secret","asset_tag":"6860","admin_user":"root","id":"1","ipmi_user":"root","status_id":"1000","admin_password":"another_secret"}';

$mock->fake_module('Node::Manager',
	get_nodes => sub { $expected_nodes });

$t->get_ok('/creds/peon6860')
  ->status_is(200)
  ->content_is($expected_json, 'got node by hostname');


print "\n===============================================================\n";
print "Test successfully looking up a node by mac address\n";
print "===============================================================\n";
my $expected_nodes = [bless({
		ctime          => 'null',
		primary_ip     => '127.0.0.1',
		mtime          => 'null',
		boot_mac       => '8:2b:cb:5f:6c:7b',
		caste_id       => '16',
		domain         => 'foo.dhcompute.net',
		ipmi_password  => 'secret',
		asset_tag      => '7869',
		hostname       => 'peon7869',
		admin_user     => 'root',
		id             => '1',
		admin_password => 'another_secret',
		ipmi_user      => 'root',
		status_id      => '1000',
	}, 'Node')
];

my $expected_json = '{"ctime":"null","primary_ip":"127.0.0.1","mtime":"null","boot_mac":"8:2b:cb:5f:6c:7b","caste_id":"16","hostname":"peon7869","domain":"foo.dhcompute.net","ipmi_password":"secret","asset_tag":"7869","admin_user":"root","id":"1","ipmi_user":"root","status_id":"1000","admin_password":"another_secret"}';

$mock->fake_module('Node::Manager',
	get_nodes => sub { $expected_nodes });

$t->get_ok('/creds/8:2b:cb:5f:6c:7b')
  ->status_is(200)
  ->content_is($expected_json);
