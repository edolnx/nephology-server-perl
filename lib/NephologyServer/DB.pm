package NephologyServer::DB;

use strict;
use Rose::DB;
our @ISA = qw(Rose::DB);

# Use a private registry for this class
__PACKAGE__->use_private_registry;

# Register your lone data source using the default type and domain
__PACKAGE__->register_db(
	domain   => NephologyServer::DB->default_domain,
	type     => NephologyServer::DB->default_type,
	driver   => '',
	database => '',
	host     => '',
	username => '',
	password => '',
);

1;
