package NephologyWebUI::Example;

use strict;
use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;
    $self->render(template => 'webui/index');
    return 1;
}

1;
