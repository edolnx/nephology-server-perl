package NephologyServer::Example;

use strict;
use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;
    $self->render(text => 'It works!');
    return 1;
}

1;
