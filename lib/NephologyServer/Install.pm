package NephologyServer::Install;

use File::Temp;
use YAML;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::DB;
use Node::Manager;


use constant SALT => ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );


sub set_rule {
	my $self = shift;
	my $machine = $self->stash("machine");
	my $rule = $self->stash("rule");

	$self->stash("srv_addr" => $Config->{'server_addr'});
	$self->stash("mirror_addr" => $Config->{'mirror_addr'});

	my $Config = YAML::LoadFile("../../nephology.yaml") ||
		$self->render(
			text   => 'Unable to load config file',
			format => 'txt',
		
		);

	my $Node = NephologyServer::Node::Manager->get_node(
		query => [
			boot_mac => $machine,
		],
	);

	unless (!$Node) {
		$self->render(
			text   => "Node [$machine] not found",
			status => 404,
		);
	}
	$Node->{'admin_password_enc'} = crypt($Node->{'admin_password'}, _gen_salt(2));
	# Make sure the requested rule is mapped to this machine before returning it


	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => $Node->caste_id,
			caste_rule_id => $rule,
		],
		limit => 1,
	);
	my $CasteRule = @$MapCasteRules[0]->caste_rule
	if (ref $CasteRule) {
		if ($CasteRule->type_id == 1 or $CasteRule->type_id == 4) {
			# Client script or client root script
			# If there is a template, render it.  Otherwise, redirect to URL
			if ($CasteRule->template) {
				$self->stash("db_rule_info" => $CasteRule);
				$self->stash("db_node_info" => $Node);
				$self->render(
					template => $CasteRule->template,
					format   => 'txt'
				);
			} else {
				$self->redirect_to("http://" . $config->{'server_addr'} . $CasteRule->url);
			}
		} elsif ($CasteRule->type_id == 3) {
			unless ($CasteRule->template) {
				$self->render(
					text   => "Rule [$rule] for [$machine] template not specified",
					status => 404
				);
			}

			my $tmp = File::Temp->new();
			my $tmp_fn = $tmp->filename;
			my $mt = Mojo::Template->new();
			if (! -f "templates/" . $CasteRule->template) {
				$self->render(
					text   => "Rule [$rule] for [$machine] template not found",
					status => 404
				);
			}

			my $data = $mt->render(
					'templates/' . $CasteRule->template, $db_node_info, $db_rule_info
			);
			$self->render(text => $data);
		} elsif ($CasteRule->type_id == 2) {
			$Node->status_id($CasteRule->template);
			$Node->save() ||
				$self->render(
					text   => "Unable to update node [$machine]",
					status => 500
				);
			$self->render(
				text => "Reboot rule [$rule] for [$machine] success!"
			);
		} else {
			$self->render(
				text   => "OMGWTFBBQ",
				status => 500
			);
		}
	} else {
		$self->render(
			text   => "Rule [$rule] not valid for [$machine]",
			status => 403
		);
	}
}

sub install_machine {
	my $self = shift;
	my $machine = $self->stash("machine");

	my $Node = NephologyServer::Node::Manager->get_node(
		query => [
			boot_mac => $machine,
		],
	);

	unless (ref $Node) {
		$self->render(
			text => "Node [$machine] not found",
			status => 404
		);
	}

	my $MapCasteRules = MapCasteRule::Manager->get_map_caste_rules(
		require_objects => ['caste_rule'],
		query => [
			caste_id => 1,
		],
		sort_by => 't1.priority, t1.caste_rule_id'
	);


	my @rule_list;
	for my $MapCasteRule (@$MapCasteRule) {
		push(@rule_list, $MapCasteRule->caste_rule);
	}

	my $install_list = {
		'version_required' => 2,
		'runlist'          => \@rule_list,
	};

	$self->render(json => $install_list);
};

# uses global @salt to construct salt string of requested length
sub _gen_salt {
	my $count = shift;

	my $salt;
	for (1..$count) {
		$salt .= (SALT)[rand @salt];
	}

	return $salt;
}

1;
