package NephologyServer::Example;

use strict;
use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;
    $self->redirect_to("index.html");
    return 1;
}

1;
