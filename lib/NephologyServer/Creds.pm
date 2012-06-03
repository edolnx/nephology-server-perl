package Nephology::Creds;

use Nephology::Node;
use Mojo::Base 'Mojolicious::Controller';

sub main {
    my $self = shift;
    my $machine = lc($self->stash("machine"));
    my $db_node_info;
    $db_node_info = $dbh->selectrow_hashref("SELECT * FROM node WHERE boot_mac='$machine'");
    if (!defined($db_node_info)) {
        $db_node_info = $dbh->selectrow_hashref("SELECT * FROM node WHERE asset_tag='$machine'");
        if (!defined($db_node_info)) {
            $db_node_info = $dbh->selectrow_hashref("SELECT * FROM node WHERE hostname='$machine'");
            if (!defined($db_node_info)) {
                $self->render(text => "Node [$machine] not found", status => 404);
                return;
            }
        }
    }

    $self->render(json => $db_node_info);
}

1;
