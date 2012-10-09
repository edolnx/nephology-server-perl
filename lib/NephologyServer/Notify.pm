package NephologyServer::Notify;

use strict;
use YAML;
use Mojo::Base 'Mojolicious::Controller';

use NephologyServer::Config;
use NephologyServer::Validate;
use Email::Simple;
use Email::Send;

sub notify {
        my $self = shift;
	my $boot_mac = $self->stash('boot_mac');

        my $Config = NephologyServer::Config::config($self);

	unless(NephologyServer::Validate::validate($self,$boot_mac)) {
		return 1;
	}

	# At a later time we may want to conditionalize this function call
	# based on a value from our config.yaml file. That way we can
	# turn on and off notification events.
	_email($self, $Config);

	return 1;	
}

sub _email {
	my $self = shift;
	my $Config = shift;

	my $email = Email::Simple->create(
		header => [
			To => $self->param('to'),
			From => $self->param('from'),
			Subject => $self->param('subject'),
		],
		body => $self->param('body'),
	);

	Email::Send->new({mailer => 'Sendmail'})->send($email);
}
1;
