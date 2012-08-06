package NephologyServer::DB;

use strict;
use Rose::DB;
use NephologyServer::Config;
our @ISA = qw(Rose::DB);

# Get the config options
my $Config = NephologyServer::Config::config();

# Use a private registry for this class
__PACKAGE__->use_private_registry;

# Register your lone data source using the default type and domain
__PACKAGE__->register_db(
	domain   => NephologyServer::DB->default_domain,
	type     => NephologyServer::DB->default_type,
	driver   => $Config->{'db_type'},
	database => $Config->{'db_name'},
	host     => $Config->{'db_host'},
	username => $Config->{'db_username'},
	password => $Config->{'db_password'},
);

1;
