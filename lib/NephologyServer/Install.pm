package NephologyServer::Install;

use strict;
use File::Temp;
use YAML;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::Config;
use NephologyServer::DB;
use NephologyServer::Validate;
use Node::Manager;
use MapCasteRule::Manager;


my @salt = ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );


sub set_rule {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");
	my $rule = $self->stash("rule");

	my $Config = NephologyServer::Config::config($self);
        my $Node = NephologyServer::Validate::validate($self,$boot_mac);

        if($Node == '0') {
                return $self->render(
                        text => "Couldn't find $boot_mac",
                        status => "404"
                );
        }


	$self->stash("srv_addr" => $Config->{'server_addr'});
	$self->stash("mirror_addr" => $Config->{'mirror_addr'});
	$Node->admin_password(crypt($Node->{'admin_password'}, _gen_salt(2)));
	# Make sure the requested rule is mapped to this machine before returning it


	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => $Node->caste_id,
			caste_rule_id => $rule,
		],
		limit => 1,
	);
	my $CasteRule = @$MapCasteRules[0]->caste_rule;
	if (ref $CasteRule) {
		if ($CasteRule->type_id == 1 or $CasteRule->type_id == 4) {
			# Client script or client root script
			# If there is a template, render it.  Otherwise, redirect to URL
			if ($CasteRule->template) {
				$self->stash("db_rule_info" => $CasteRule);
				$self->stash("db_node_info" => $Node);
				return $self->render(
					template => $CasteRule->template,
					format   => 'txt'
				);
			} else {
				$self->redirect_to("http://" . $Config->{'server_addr'} . $CasteRule->url);
			}
		} elsif ($CasteRule->type_id == 3) {
			unless ($CasteRule->template) {
				return $self->render(
					text   => "Rule [$rule] for [$boot_mac] template not specified",
					status => 404
				);
			}

			my $tmp = File::Temp->new();
			my $tmp_fn = $tmp->filename;
			my $mt = Mojo::Template->new();
			if (! -f "templates/" . $CasteRule->template) {
				return $self->render(
					text   => "Rule [$rule] for [$boot_mac] template not found",
					status => 404
				);
			}

			my $data = $mt->render(
					'templates/' . $CasteRule->template, $Node, $CasteRule
			);
			return $self->render(text => $data);
		} elsif ($CasteRule->type_id == 2) {
			$Node->status_id($CasteRule->template);
			$Node->save() ||
				return $self->render(
					text   => "Unable to update node [$boot_mac]",
					status => 500
				);
			return $self->render(
				text => "Reboot rule [$rule] for [$boot_mac] success!"
			);
		} else {
			return $self->render(
				text   => "OMGWTFBBQ",
				status => 500
			);
		}
	} else {
		return $self->render(
			text   => "Rule [$rule] not valid for [$boot_mac]",
			status => 403
		);
	}
}

sub install_machine {
	my $self = shift;
	my $boot_mac = $self->stash("boot_mac");

        my $Node = NephologyServer::Validate::validate($self,$boot_mac);

        if($Node == '0') {
                return $self->render(
                        text => "Couldn't find $boot_mac",
                        status => "404"
                );
        }

	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => $Node->caste_id,
		],
		sort_by => 't1.priority, t1.caste_rule_id'
	);

	my @columns = qw(id description url template type_id);
	my @rule_list;

	for my $MapCasteRule (@$MapCasteRules) {	
		my $rule_item;
		for my $c (@columns) {
			$rule_item->{$c} = $MapCasteRule->caste_rule->{$c};
		}
		push @rule_list, $rule_item;
	}

	my $install_list = {
		'version_required' => 2,
		'runlist'          => \@rule_list,
	};

	$self->render(json => $install_list);
}

# uses global @salt to construct salt string of requested length
sub _gen_salt {
	my $count = shift;

	my $salt;
	for (1..$count) {
		$salt .= (@salt)[rand @salt];
	}

	return $salt;
}

1;
