package NephologyServer::Node;

use strict;
use File::Temp;
use YAML;
use JSON;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::Config;
use NephologyServer::DB;
use NephologyServer::Validate;
use Node;
use Node::Manager;
use MapCasteRule::Manager;


my @salt = ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

sub upsert_machine {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");
	my $Config = NephologyServer::Config::config($self);

	unless($Config->{'discovery'} eq 'enable') {
		return $self->render(
                        text   => "Discovery mode is not enabled",
                        status => 403
                );
	}

	my $ohai = $self->req->body_params->param('ohai');

	open (OHAI, ">>$Config->{'discovery_path'}/$boot_mac");
	print OHAI $ohai;
	close (OHAI);

	# This eventually needs to check for the existance of a node and update as necessary
	my $NodeObject = Node->new(
		ctime => time,
		mtime => time,
		asset_tag => '',
		admin_user =>  'root',
		admin_password => _gen_salt(20),
		ipmi_user => 'root',
		ipmi_password => _gen_salt(8),
		caste_id => '1',
		status_id => '0',
		domain => '',
		primary_ip => $self->tx->{remote_address},
		hostname => '',
		boot_mac => $boot_mac,
	);
	$NodeObject->save;

	$self->render(
	              text => "Looks good!",
	              status => 200
	             );
}

# uses global @salt to construct salt string of requested length
sub _gen_salt {
	my $count = shift;

	my $salt;
	for (1..$count) {
		$salt .= (@salt)[rand @salt];
	}

	return $salt;
}

1;
