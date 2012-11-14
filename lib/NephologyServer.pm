package NephologyServer;

use strict;

use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Mount;

sub startup {
	my $self = shift;
	my $r = $self->routes;

	$r->get('/')->to(
		controller => 'example',
		action     => 'welcome',
        );

	# Boot
	$r->get('/boot/:boot_mac')->to(
		controller => 'boot',
		action     => 'lookup_machine',
	);

	# Install
	$r->get('/install/:boot_mac/:rule')->to(
		controller => 'install',
		action     => 'get_rule',
	);
	$r->get('/install/:boot_mac')->to(
		controller => 'install',
		action     => 'install_machine',
	);

	# Node
	$r->post('/node/:boot_mac')->to(
	                                controller => 'node',
	                                action => 'upsert_machine',
	                               );

	# Creds
	$r->get('/creds/:boot_mac')->to(
		controller => 'creds',
		action     => 'machine_creds',
	);

	# Notify
	$r->post('/notify/:boot_mac')->to(
		controller => 'notify',
		action     => 'notify',
	);

	# Discovery
	$r->post('/install/:boot_mac')->to(
		controller => 'install',
		action 	   => 'discovery',
	);

        $self->plugin(Mount => {'/webui' => 'bin/nephology-webui'});
}

1;
