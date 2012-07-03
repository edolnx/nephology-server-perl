package NephologyServer::Boot;

use strict;
use Mojo::Base 'Mojolicious::Controller';
use YAML;

use Node::Manager;
use NodeStatus::Manager;


# Find the boot script, right now only returns the default or rescue iPXE script
sub lookup_machine {
	my $self = shift;
	my $machine = $self->stash('machine');

	my $Config = YAML::LoadFile('../nephology.yaml') ||
		return $self->render(
			text   => 'Unable to find config file',
			format => 'txt',
		);

	$self->stash("srvip" => $Config->{'server_addr'});
	if ($machine eq "rescue") {
		return $self->render(
			template => "boot/rescue.ipxe",
			format   => 'txt',
		);
	} else {
		my $Nodes = Node::Manager->get_nodes(
			query => [
				boot_mac => $machine,
			],
			limit => 1,
		);

		my $Node = @$Nodes[0];
		if (!ref $Node) {
			# If the node does not exist, go into bootstrap mode
			return $self->render(
				template => "boot/bootstrap.ipxe",
				format   => 'txt',
			);
		} else {
			# Since the node exists, check it's status for for what action to perform
			my $NodeStatus = NodeStatus::Manager->get_node_status(
				query => [
					id => $Node->status_id,
				]
			);
			if ($NodeStatus && $NodeStatus->next_status) {
				# Change node status
				$Node->status_id($NodeStatus->next_status);
				$Node->save() ||
					return $self->render(
						text   => "Unable to update node [$machine]",
						status => 500,
					);

				$self->render(
					template => 'boot/' . $NodeStatus->template,
					format   => 'txt',
				);
			} else {
				# There was no status information found, so abort
				$self->render(
					text   => "Unable to find information for this node status",
					status => 404
				);
			}
		}
	}
}

1;
