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

	my $Node = shift @{$Nodes};
	if (!ref $Node) {
		my $Nodes = Node::Manager->get_nodes(
			query => [
				asset_tag => $boot_mac,
			],
			limit => 1,
		);

		$Node = shift @{$Nodes};
		if (!ref $Node) {
			my $Nodes = Node::Manager->get_nodes(
				query => [
					hostname => $boot_mac,
				],
				limit => 1,
			);

			$Node = shift @{$Nodes};
			if (!ref $Node) {
				return $self->render(
					text   => "Node [$boot_mac] not found",
					status => 404,
				);
			}
		}
	}

	my @columns = qw(id ctime mtime asset_tag hostname boot_mac admin_user
	admin_password ipmi_user ipmi_password caste_id status_id domain
	primary_ip);

	$self->render(
		json => {
		         map {$_ => $Node->{$_}} @columns,
	});
}

1;
