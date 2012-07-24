package NephologyWebUI;

use strict;

use Mojo::Base 'Mojolicious';

sub startup {
	my $self = shift;
	my $r = $self->routes;

	$r->get('/')->to(
		controller => 'example',
		action     => 'welcome',
                        );


}

1;
