package Node::Manager;

use Rose::DB::Object::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Node' }
__PACKAGE__->make_manager_methods('nodes');

1;
