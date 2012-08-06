package NephologyServer::Config;

use strict;
use Mojo::Base 'Mojolicious::Controller';

use Cwd;
use File::Basename 'dirname';
use YAML;
use Try::Tiny;

sub config {
	my $yaml;
	my $yaml_path = dirname(Cwd::abs_path(__FILE__)) . '/../../etc/config.yaml';

	try {
		$yaml = YAML::LoadFile($yaml_path);
	} catch {
		die "Unable to load $yaml_path : " . $_;
	};

	return $yaml;
}

1;
