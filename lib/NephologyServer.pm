package NephologyServer;

use strict;

use Mojo::Base 'Mojolicious';

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
		action     => 'set_rule',
	);
	$r->get('/install/:boot_mac')->to(
		controller => 'install',
		action     => 'install_machine',
	);

	# Creds
	$r->get('/creds/:boot_mac')->to(
		controller => 'creds',
		action     => 'machine_creds',
	);
}

1;
