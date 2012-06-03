package Nephology::Install;

use Nephology::Node;
use Mojo::Base 'Mojolicious::Controller';

sub main {
    my $self = shift;
    my $machine = $self->stash("machine");
    my $db_node_info = $dbh->selectrow_hashref("SELECT * FROM node WHERE boot_mac='$machine'");
    if (!defined($db_node_info)) {
        $self->render(text => "Node [$machine] not found", status => 404);
        return;
    }
    my $sth = $dbh->prepare("SELECT cr.* FROM caste_rule AS cr JOIN map_caste_rule AS mcr ON mcr.caste_rule_id=cr.id WHERE mcr.caste_id=" . $db_node_info->{'caste_id'} . " ORDER BY mcr.priority, mcr.caste_rule_id");
    $sth->execute;
    my @rule_list;
    my $install_list = {
        'version_required' => 2,
        'runlist' => \@rule_list,
    };
    while ( my $rule = $sth->fetchrow_hashref ) {
        push(@rule_list,$rule);
    }
    $self->render(json => $install_list);
}


get '/install/:machine/:rule' => sub {
sub 
    my $self = shift;
    my $machine = $self->stash("machine");
    my $rule = $self->stash("rule");
    $self->stash("srv_addr" => $config->{'server_addr'});
    $self->stash("mirror_addr" => $config->{'mirror_addr'});
    my $db_node_info = $dbh->selectrow_hashref("SELECT * FROM node WHERE boot_mac='$machine'");
    if (!defined($db_node_info)) {
        $self->render(text => "Node [$machine] not found", status => 404);
        return;
    }
    $db_node_info->{'admin_password_enc'} = crypt( $db_node_info->{'admin_password'}, gensalt(2) );
    # Make sure the requested rule is mapped to this machine before returning it
    my $query = "SELECT * FROM caste_rule WHERE id IN (SELECT caste_rule_id FROM map_caste_rule WHERE caste_id=" . $db_node_info->{'caste_id'} . " AND caste_rule_id=$rule)";
    my $db_rule_info = $dbh->selectrow_hashref($query);
    if (defined($db_rule_info->{'id'})) {
        if ($db_rule_info->{'type_id'} == 1 or $db_rule_info->{'type_id'} == 4) {
            # Client script or client root script
            # If there is a template, render it.  Otherwise, redirect to URL
            if ($db_rule_info->{'template'} ne "") {
                $self->stash("db_rule_info" => $db_rule_info);
                $self->stash("db_node_info" => $db_node_info);
                $self->render(template => $db_rule_info->{'template'}, format => 'txt');
            }
            else {
                $self->redirect_to("http://" . $config->{'server_addr'} . $db_rule_info->{'url'});
            }
        }
        elsif ($db_rule_info->{'type_id'} == 3) {
            if ($db_rule_info->{'template'} eq "") { 
                $self->render(text => "Rule [$rule] for [$machine] template not specified", status => 404);
            }
            my $tmp = File::Temp->new();
            my $tmp_fn = $tmp->filename;
            my $mt = Mojo::Template->new();
            if ( ! -f "templates/" . $db_rule_info->{'template'} ) {
                $self->render(text => "Rule [$rule] for [$machine] template not found", status => 404);
            }
            my $data = $mt->render('templates/' . $db_rule_info->{'template'}, $db_node_info, $db_rule_info);
            print $tmp $data;
            #if (system("perl $tmp_fn") > 0) {
            #    $self->render(text => "Server side script error!", status => 500);
            #}
            $self->render(text => $data);
        }
        elsif ($db_rule_info->{'type_id'} == 2) {
            my $sth = $dbh->prepare("UPDATE node SET status_id=1000 WHERE id=" . $db_node_info->{'id'});
            $sth->execute or $self->render(text => "Unable to update node [$machine]", status => 500);
            $self->render(text => "Reboot rule [$rule] for [$machine] success!");
        }
        else {
            $self->render(text => "OMGWTFBBQ", status => 500);
        }
    }
    else {
        $self->render(text => "Rule [$rule] not valid for [$machine]", status => 403);
    }
};


1;
