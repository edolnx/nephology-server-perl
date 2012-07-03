package NodeStatus::Manager;

use strict;
use Rose::DB::Object::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'MapCasteRule' }
__PACKAGE__->make_manager_methods('node_status');

1;
