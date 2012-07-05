package NephologyServer::Creds;

use strict;
use Node::Manager;

use Mojo::Base 'Mojolicious::Controller';


sub machine_creds {
	my $self = shift;
	my $boot_mac = lc($self->stash("boot_mac"));

	my $Nodes = Node::Manager->get_nodes(
		query => [
			boot_mac => $boot_mac,
		],
		limit => 1,
	);

	my $Node = @$Nodes[0];
	if (!ref $Node) {
		my $Nodes = Node::Manager->get_nodes(
			query => [
				asset_tag => $boot_mac,
			],
			limit => 1,
		);

		$Node = @$Nodes[0];
		if (!ref $Node) {
			my $Nodes = Node::Manager->get_nodes(
				query => [
					hostname => $boot_mac,
				],
				limit => 1,
			);

			$Node = @$Nodes[0];
			if (!ref $Node) {
				return $self->render(
					text   => "Node [$boot_mac] not found",
					status => 404,
				);
			}
		}
	}

	$self->render(json => $Node);
}

1;
