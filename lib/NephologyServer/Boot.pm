package NephologyServer::Boot;

use strict;
use Mojo::Base 'Mojolicious::Controller';
use YAML;

use Node::Manager;
use NephologyServer::Config;
use NephologyServer::Validate;
use NodeStatus::Manager;

# Find the boot script, right now only returns the default or rescue iPXE script
sub lookup_machine {
	my $self = shift;
	my $boot_mac = $self->stash('boot_mac');

	my $Config = NephologyServer::Config::config($self);
	my $Node = NephologyServer::Validate::validate($self,$boot_mac);

	if($Node == '0') {
		return $self->render(
			text => "Couldn't find $boot_mac",
			status => "404"
		);
	}	

	$self->stash("srvip" => $Config->{'server_addr'});
	if ($boot_mac eq "rescue") {
		return $self->render(
			template => "boot/rescue.ipxe",
			format   => 'txt',
		);
	} else {
		# Since the node exists, check it's status for for what action to perform
		my $NodeStatuses = NodeStatus::Manager->get_node_status(
		query => [
			status_id => $Node->status_id,
			]
		);

		my $NodeStatus = @$NodeStatuses[0];
		if ($NodeStatus && $NodeStatus->next_status) {
			# Verify template exists then change node status
			if ($self->render(template => 'boot/' . $NodeStatus->template, format => 'txt')) {
				$Node->status_id($NodeStatus->next_status);
				$Node->save() ||
					$self->render(
						text   => "Unable to update node [$boot_mac]",
						status => 500,
					);
			} else {
				$self->render(
					text => "Couldn't find " . $NodeStatus->template . " for [$boot_mac], verify that template exists",
					status => 500,
				);
			}
		} else {
			# There was no status information found, so abort
			$self->render(
				text   => "Unable to find information for this node status",
				status => 404
			);
		}
	}
}

1;
