#!/usr/bin/perl

use strict;
use warnings;
use Database;

use Time::HiRes qw(gettimeofday);
use Mojolicious::Lite;
use Mojo::JSON qw(encode_json decode_json);

use Data::Dumper;

app->static->paths->[0] = './site';

any '/' => sub {
    $_[0]->reply->static('index.html')
};

###load Database
my $file = 'books.txt';
my $book_db = Database->new();
if ( $book_db->load_db($file) ) {
    print "\nLoaded file $file. " . scalar ( keys %{$book_db->get_books} ) . " book(s) in total\n\n";
}
###

any [qw(GET POST)] => '/api/is_db' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my $result = 0;

    if ( $book_db ) {
        $result = 1;
    }

    $self->render(
        json => {
            success   => $result,
        }
    );
};

any [qw(GET POST)] => '/api/save_db' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my $result = 0;

    if ( $book_db && $book_db->save_db($file) ) {
        $result = 1;
    }
    $self->render(
        json => {
            success   => $result,
        }
    );
};

any [qw(GET POST)] => '/api/delete_books' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my @books = split( /\s/, $body->{books} );
    my $result = 0;
    #if DB exists delete books and save DB back to file
    if ( $book_db ) {
        for my $book (@books) {
            $book_db->delete_book($book);
        }
        if ( $book_db->save_db($file) ) {
            $result = 1;
        }
    }
    $self->render(
        json => {
            success   => $result,
        }
    );
};


###
any [qw(GET POST)] => '/api/load_db' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );

    print "Content Received:\n";
    print Dumper $body;
    print Dumper $self;

    $self->render(
        json => {
            success   => 1,
            localtime => int(gettimeofday),
        }
    );
};
###

my $port = $ENV{PORT} || 3000;
app->start( 'daemon', '-l', "http://*:$port" );
