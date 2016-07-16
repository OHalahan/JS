package Database;

use strict;
use warnings;
use Keeper;
use English qw( -no_match_vars );

{
    my $id_counter = 0;
    sub increase_id {
        return ++$id_counter;
    }
}

sub new {
    my $class = shift;
    my $self = { books => {}, file => undef };
    bless( $self, $class );
    return $self;
}

sub load_db {
    my ( $book_db, $file ) = @_;
    eval {
        open( my $database, '<', $file ) or die "Cannot open a file $file: $OS_ERROR\n";
        $book_db->set_file($file);
        my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
        while (<$database>) {
            chomp;
            if (/^Title/) {
                $title = s/^Title:\s//r;
            }
            elsif (/^Author/) {
                $author = s/^Author:\s//r;
            }
            elsif (/^Section/) {
                $section = s/^Section:\s//r;
            }
            elsif (/^Shelf/) {
                $shelf = s/^Shelf:\s//r;
            }
            elsif (/^On Hands/) {
                $taken = s/^On Hands:\s//r;
            }
            elsif ( /^$/ && $title && $author ) {
                my $id = increase_id;
                $book_db->{books}{$id} = Keeper->new( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
                ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
            }
        }
        close $database;
    };
    if ($EVAL_ERROR) {
        warn $EVAL_ERROR;
        return undef;
    }
    else {
        return $book_db;
    }
}

sub add_book {
    my $book_db = shift;
    my $id      = increase_id;
    $book_db->{books}{$id} = Keeper->add_book(@_);
    return $book_db->{books}{$id};
}

sub search_book {
    my ( $book_db, $strategy, $pattern, @ids ) = @_;
    my ( $expression, @matched, @books ) = ( '', (), () );
    @ids ? ( @books = @ids ) : ( @books = ( keys %{ $book_db->{books} } ) );
    if ( $pattern =~ s/^"([^"]+)"$/$1/ ) {
        $expression = qr/^$pattern$/;
    }

    else {
        $expression = qr/$pattern/;
    }
    for my $book (@books) {
        my $method   = 'get_' . $strategy;
        my $matching = $book_db->{books}{$book}->$method;
        if ( $matching =~ $expression ) {
            push @matched, $book;
        }
    }
    @matched ? return @matched : return;
}

sub delete_book {
    my ( $book_db, $book ) = @_;
    if ( $book_db->{books}{$book} ) {
        delete $book_db->{books}{$book};
        return 1;
    }
    else {
        return undef;
    }
}

sub save_db {
    my ( $book_db, $file ) = @_;
    eval {
        open( my $fh, '>', $file ) or die "Cannot create a file $file: $OS_ERROR\n";

        for my $book ( sort { $a <=> $b } ( keys %{ $book_db->get_books } ) ) {
            print {$fh} "\n";
            print {$fh} "Title: " . $book_db->get_books->{$book}->get_title . "\n";
            print {$fh} "Author: " . $book_db->get_books->{$book}->get_author . "\n";
            print {$fh} "Section: " . $book_db->get_books->{$book}->get_section . "\n";
            print {$fh} "Shelf: " . $book_db->get_books->{$book}->get_shelf . "\n";
            print {$fh} "On Hands: " . $book_db->get_books->{$book}->get_taken . "\n";
            print {$fh} "\n";
        }
    };
    if ($EVAL_ERROR) {
        warn $EVAL_ERROR;
        return undef;
    }
    else {
        return 1;
    }
}

our $AUTOLOAD;

sub AUTOLOAD {
    my ( $self,   $arg )  = @_;
    my ( $prefix, $attr ) = $AUTOLOAD =~ /.*::(set|get)_(.*)/;
    if ( $prefix eq 'get' ) {
        return $self->{$attr};
    }
    else {
        $self->{$attr} = $arg;
    }
}

1;
