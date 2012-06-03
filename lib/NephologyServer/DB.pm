package NephologyServer::DB;

use strict;
use Rose::DB;
our @ISA = qw(Rose::DB);

# Use a private registry for this class
__PACKAGE__->use_private_registry;

# Register your lone data source using the default type and domain
__PACKAGE__->register_db(
	domain   => Nephology::DB->default_domain,
	type     => Nephology::DB->default_type,
	driver   => 'mysql',
	database => 'nephology2',
	host     => 'localhost',
	username => 'nephology',
	password => 'vaporware',
);

1;
