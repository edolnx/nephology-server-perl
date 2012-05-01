#!/usr/bin/perl

use strict;
use Mojolicious::Lite;

get '/' => sub {
    my $self = shift;
    $self->render(text => 'Hello World');
};

# Find the boot script, right now only returns the default or rescue iPXE script
get '/boot/:machine' => sub {
    my $self = shift;
    my $machine = $self->stash('machine');
    $self->stash(srvip => '192.168.57.1');
    if ($machine eq 'rescue') {
        $self->render(template => 'boot/rescue.ipxe', format => 'txt');
    } else {
        $self->render(template => 'boot/bootstrap.ipxe', format => 'txt');
    }
};

app->start;

