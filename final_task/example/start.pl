#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw(gettimeofday);
use Mojolicious::Lite;
use Mojo::JSON qw(encode_json decode_json);

use Data::Dumper;

app->static->paths->[0] = './site';

any '/' => sub {
    $_[0]->reply->static('index.html')
};

any [qw(GET POST)] => '/api' => sub {
    my $self = shift;

    my $body = decode_json( $self->req->body || "{}" );

    print "Content Received:\n";
    print Dumper $body;

    $self->res->headers->cache_control('no-cache');
    $self->res->headers->access_control_allow_origin('*');

    if ( ( $body->{method} || '' ) eq 'get_owner_info' ) {
        # Do some backend magic for 'get_owner_info' method
        # ...
        # And respond success if it was successful
        $self->render(
            json => {
                success => 1,
            }
        );
    }

    # No method found
    $self->render(
        json => {
            success => 0,
        }
    );
};

# It's better when each 'destination' serves only one method
any [qw(GET POST)] => '/api/get_server_localtime' => sub {
    my $self = shift;

    $self->render(
        json => {
            success   => 1,
            localtime => int(gettimeofday),
        }
    );
};

my $port = $ENV{PORT} || 3000;
app->start( 'daemon', '-l', "http://*:$port" );
