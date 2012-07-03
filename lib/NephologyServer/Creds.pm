package NephologyServer::Creds;

use strict;
use Node::Manager;

use Mojo::Base 'Mojolicious::Controller';


sub machine_creds {
	my $self = shift;
	my $machine = lc($self->stash("machine"));

	my $Nodes = Node::Manager->get_nodes(
		query => [
			boot_mac => $machine,
		],
		limit => 1,
	);

	my $Node = @$Nodes[0];
	if (!ref $Node) {
		my $Nodes = Node::Manager->get_nodes(
			query => [
				asset_tag => $machine,
			],
			limit => 1,
		);

		$Node = @$Nodes[0];
		if (!ref $Node) {
			my $Nodes = Node::Manager->get_nodes(
				query => [
					hostname => $machine,
				],
				limit => 1,
			);

			$Node = @$Nodes[0];
			if (!ref $Node) {
				return $self->render(
					text   => "Node [$machine] not found",
					status => 404,
				);
			}
		}
	}

	$self->render(json => $Node);
}

1;
