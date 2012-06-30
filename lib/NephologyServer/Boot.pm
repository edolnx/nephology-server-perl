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
	$self->render(text => $machine);

	my $Config = YAML::LoadFile('nephology.yaml') ||
		$self->render(
			text   => 'Unable to find config file',
			format => 'txt',
		)

	$self->stash("srvip" => $Config->{'server_addr'});
	if ($machine eq "rescue") {
		$self->render(
			template => "boot/rescue.ipxe",
			format   => 'txt',
		);
	} else {
		my $Node = Node::Manager->get_nodes(
			query => [
				boot_mac => $machine,
			]
		);

		if (!$Nodes) {
			# If the node does not exist, go into bootstrap mode
			$self->render(
				template => "boot/bootstrap.ipxe",
				format   => 'txt',
			);
		} else {
			# Since the node exists, check it's status for for what action to perform
			my $NodeStatus = NodeStatus::Manager->get_node_status(
				query => [
					status_id => $Node->status_id,
				]
			);
			if ($NodeStatus && $NodeStatus->next_status) {
				# Change node status
				$Node->status_id($NodeStatus->next_status)
				$Node->save() ||
					$self->render(
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
