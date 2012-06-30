package NephologyServer::Creds;

use strict;
use Node::Manager;

use Mojo::Base 'Mojolicious::Controller';


sub machine_creds {
	my $self = shift;
	my $machine = lc($self->stash("machine"));

	my $Node = Node::Manager->get_nodes(
		query => [
			boot_mac => $machine,
		],
	);
	if (!ref $Node) {
		my $Node = Node::Manager->get_nodes(
			query => [
				asset_tag => $machine,
			],
		);
		if (!ref $Node) {
			my $Node = Node::Manager->get_nodes(
				query => [
					hostname => $machine,
				],
			);
			if (!ref $Node) {
				$self->render(
					text   => "Node [$machine] not found",
					status => 404,
				);
			}
		}
	}

	$self->render(json => $Node);
}

1;
