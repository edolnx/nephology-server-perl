package NephologyServer::Boot;

use Mojo::Base 'Mojolicious::Controller';

# Find the boot script, right now only returns the default or rescue iPXE script
sub lookup_machine {
	my $self = shift;
	my $machine = $self->stash("machine");
	$self->stash("srvip" => $config->{'server_addr'});
	if ($machine eq "rescue") {
		$self->render(template => "boot/rescue.ipxe", format => 'txt');
	} else {
		require NephologyServer::DB;
		my $Db = NephologyServer::DB->new();
		my $Dbh = $Db->dbh();
		my $db_node_info = $Dbh->selectrow_hashref("SELECT * FROM node WHERE boot_mac='$machine'");
		if (!defined($db_node_info)) {
		    $self->render(template => "boot/bootstrap.ipxe", format => 'txt');
		}
	} elsif ($db_node_info->{'status_id'} == 1000) {
	    $self->render(template => "boot/localboot.ipxe", format => 'txt');
	} else {
	    $self->render(template => "boot/bootstrap.ipxe", format => 'txt');
	}
}


1;
