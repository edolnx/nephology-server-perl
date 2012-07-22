package NephologyServer::Validate;

use strict;
use File::Temp;
use YAML;
use Data::Dumper;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::DB;
use Node::Manager;

sub validate {
	my $self = shift || return;
	my $boot_mac = shift || return;
	
	my $Nodes = Node::Manager->get_nodes(
		query => [ boot_mac => $boot_mac,],
		limit => 1,
	);

	my $Node = @$Nodes[0];

	unless($Node) {
		return 0;
	}
	return $Node;
}
1;
