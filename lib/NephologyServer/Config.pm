package NephologyServer::Config;

use strict;
use Mojo::Base 'Mojolicious::Controller';

use YAML;
use Try::Tiny;

sub config {
	my $self = shift;
	my $yaml;
	
	try { 
		$yaml = YAML::LoadFile('etc/config.yaml');
	} catch {
		return $self->render(
			text   => "Unable to find nephology.yaml",
			status => 500,
		);
	};

	return $yaml;
}

1;
