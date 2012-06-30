package MapCasteRule::Manager;

use Rose::DB::Object::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'MapCasteRule' }
__PACKAGE__->make_manager_methods('map_caste_rules');

1;
