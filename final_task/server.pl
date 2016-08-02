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
    $_[0]->reply->static('index.html');
};

###load Database
my $file    = 'books.txt';
my $book_db = Database->new();
if ( $book_db->load_db($file) ) {
    print "\nLoaded file $file. "
      . scalar( keys %{ $book_db->get_books } )
      . " book(s) in total\n\n";
}
else {
    print "Cannot not load a file: $file\n";
    exit;
}
###

any [qw(GET POST)] => '/api/search_books' => sub {
    my $self   = shift;
    my $body   = decode_json( $self->req->body || "{}" );
    my %passed = %{ $body->{queries} };
    my ($final, @result) = ( {}, () );

    for my $strategy (keys %passed) {
        my $pattern = $passed{$strategy};
        $pattern =~ s/^\*/\.*/;
        @result = $book_db->search_book( $strategy, $pattern, @result );
        if (!@result) {
            $final->{success} = 0;
            last;
        }
        $final->{success} = 1;
    }

    for my $book (@result) {
        push @{ $final->{books} },
          {
            "id"      => $book,
            "title"   => $book_db->get_books->{$book}->get_title,
            "author"  => $book_db->get_books->{$book}->get_author,
            "section" => $book_db->get_books->{$book}->get_section,
            "shelf"   => $book_db->get_books->{$book}->get_shelf,
            "taken"   => $book_db->get_books->{$book}->get_taken,
          };
    }

    $self->render( json => $final );
};

any [qw(GET POST)] => '/api/add_book' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    my ( $result, $valid ) = ( 0, 1 );

    $title   = $body->{title};
    $author  = $body->{author};
    $section = $body->{section};
    $shelf   = $body->{shelf};
    $taken   = $body->{taken};

    #check whether all mandatory fields are present
    for my $option ( $title, $author, $section, $shelf ) {
        if ( $option =~ /^\s+$/ || !$option ) {
            $valid = 0;
            last;
        }
    }
    my $new_book = $book_db->add_book(
        title   => $title,
        author  => $author,
        section => $section,
        shelf   => $shelf,
        taken   => $taken
    );

    if ( $valid && $new_book ) {
        $result = 1;
    }

    $self->render(
        json => {
            success => $result,
            id => $new_book
        }
    );
};

any [qw(GET POST)] => '/api/save_db' => sub {
    my $self   = shift;
    my $body   = decode_json( $self->req->body || "{}" );
    my $result = 0;

    if ( $book_db->save_db($file) ) {
        $result = 1;
    }
    $self->render(
        json => {
            success => $result,
        }
    );
};

any [qw(GET POST)] => '/api/delete_books' => sub {
    my $self  = shift;
    my $body  = decode_json( $self->req->body || "{}" );
    my $reference = $body->{books} || [-1];

    my @books = @{ $reference };
    my ( $result, $failed ) = ( 1, () );

    for my $book (@books) {
        if ( !$book_db->delete_book($book) ) {
            push @{$failed}, $book;
            $result = 0;
        }
    }

    $self->render(
        json => {
            success => $result,
            failed  => $failed,
        }
    );
};

my $port = $ENV{PORT} || 3000;
app->start( 'daemon', '-l', "http://*:$port" );
