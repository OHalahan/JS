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
###

sub merge_results {
    my ($anon_arrays) = @_;
    my %count         = ();
    my @result        = ();
    for my $array ( @{$anon_arrays} ) {
        for my $book ( @{$array} ) {
            $count{$book}++;
        }
    }
    for my $elem ( keys %count ) {
        if ( $count{$elem} >= 4 ) {
            push @result, $elem;
        }
    }
    @result ? return @result : return undef;
}

any [qw(GET POST)] => '/api/search' => sub {
    my $self   = shift;
    my $body   = decode_json( $self->req->body || "{}" );
    my @passed = @{ $body->{queries} };

    my $result  = 1;
    my @matched = ();
    my $final   = {};

    if ($book_db) {
        $final->{success} = 0;

        my ( $strategy, $pattern ) = ( @{ shift @passed } );
        $pattern =~ s/\*/\.*/;
        my @first_found = $book_db->search_book( $strategy, $pattern );
        if (@first_found) {

            #perform search within books which were found at first iteration
            #in order not to check whole book database again
            while (@passed) {
                ( $strategy, $pattern ) = @{ shift @passed };
                my @intermediate =
                  $book_db->search_book( $strategy, $pattern, @first_found );
                if ( !@intermediate ) {
                    $final->{success} = 0;
                    @matched = ();
                    last;
                }
                else {
                    push @matched, ( [@intermediate] );
                }
            }
            if (@matched) {
                @matched = merge_results( \@matched );
                for my $book (@matched) {
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
                $final->{success} = 1;
            }
        }
    }
    $self->render( json => $final );
};

any [qw(GET POST)] => '/api/add' => sub {
    my $self = shift;
    my $body = decode_json( $self->req->body || "{}" );
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    my ( $result, $counter ) = ( 0, 0 );

    $title   = $body->{title};
    $author  = $body->{author};
    $section = $body->{section};
    $shelf   = $body->{shelf};
    $taken   = $body->{taken};

    #check whether all mandatory fields are present
    for my $option ( $title, $author, $section, $shelf ) {
        if ( $option !~ /^\s+$/ && $option ) {
            $counter++;
        }
    }

    if (
           $counter == 4
        && $book_db
        && $book_db->add_book(
            title   => $title,
            author  => $author,
            section => $section,
            shelf   => $shelf,
            taken   => $taken
        )
      )
    {
        $result = 1;
    }

    $self->render(
        json => {
            success => $result,
        }
    );
};

any [qw(GET POST)] => '/api/save_db' => sub {
    my $self   = shift;
    my $body   = decode_json( $self->req->body || "{}" );
    my $result = 0;

    if ( $book_db && $book_db->save_db($file) ) {
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
    my @books = ( @{ $body->{books} } );
    my ( $result, $failed ) = ( 1, () );

    #if DB exists delete books
    if ($book_db) {
        for my $book (@books) {
            if ( !$book_db->delete_book($book) ) {
                push @{$failed}, $book;
                my $result = 0;
            }
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
