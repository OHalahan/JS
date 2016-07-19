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
    my ( $result, @ids ) = ( 0, () );

    if ( $book_db ) {
        $result = 1;
        @ids = keys %{$book_db->get_books};
    }

    $self->render(
        json => {
            success => $result,
            ids     => "@ids",
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
    my @books = ( @{$body->{books}} );
    my ( $result, $failed ) = ( 1, () );

    #if DB exists delete books
    if ( $book_db ) {
        for my $book (@books) {
            if (!$book_db->delete_book($book)) {
                push @{$failed}, $book;
                my $result = 0;
            }
        }
    }
    $self->render(
        json => {
            success   => $result,
            failed => $failed,
        }
    );
};

any [qw(GET POST)] => '/api/get_by_id' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my $book = $body->{book};
    my $result = 0;

    print "Content Received:\n";
    print Dumper $body;

    if ($book_db) {
        $result = 1;
        $self->render(
            json => {
                success   => $result,
                title => $book_db->get_books->{$book}->get_title,
                author => $book_db->get_books->{$book}->get_author,
                section => $book_db->get_books->{$book}->get_section,
                shelf => $book_db->get_books->{$book}->get_shelf,
                taken => $book_db->get_books->{$book}->get_taken,
            }
        );
    }
    else {
        $self->render(
            json => {
                success   => $result,
            }
        );
    }

};

any [qw(GET POST)] => '/api/get_books' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my $final = {};

    if ($book_db) {
        $final->{success} = 1;

        for my $book ( keys %{$book_db->{books}} ) {
            push @{$final->{books}}, {
                "id" => $book,
                "title" => $book_db->get_books->{$book}->get_title,
                "author" => $book_db->get_books->{$book}->get_author,
                "section" => $book_db->get_books->{$book}->get_section,
                "shelf" => $book_db->get_books->{$book}->get_shelf,
                "taken" => $book_db->get_books->{$book}->get_taken,
            }
        }
    }
    else {
        $final->{success} = 0;
    }
    $self->render(
        json => $final,
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
