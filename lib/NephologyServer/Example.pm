package NephologyServer::Example;

use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;
    $self->render(text => 'hi')
}
