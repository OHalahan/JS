#!/usr/bin/perl

use strict;
use warnings;
use Database;
use English qw( -no_match_vars );

sub greeting {
    print "\nPossible actions:\nl\tload <file>\na\tadd book\nd\tdelete book <pattern>\nf\tfind book <pattern>\np\tprint books\ns\tsave books\nh\thelp\ne\texit\n";
    print "\n> Type a required action and press ENTER: ";
    return;
}

sub print_help {
    print "\n============\n";
    print "\nExample of search pattern:\nf shelf=2 section=Java|XML title=2nd edition\n";
    print "\nType request in double quotes for exact match\n";
    print "\nIf a pattern is not specified, you will be prompted to choose a search strategy\n";
    print "\n============\n";
    return;
}

sub remind {
    print "Warning!: You have to load database first\n";
    return;
}

sub load_database {
    my ( $book_db, $file ) = @_;
    if ( !$file ) {
        print "> Enter path to the file: ";
        chomp( $file = <STDIN> );
    }

    if ( !$book_db ) {
        $book_db = Database->new();
    }
    else {
        print "\n\nWarning!: Database is not empty.\n\nWould you like to reload database from scratch?\n";
        print "Note! previous changes will be lost\n\n";
        print "> Your decision (Y/N): ";
        chomp( my $decision = <STDIN> );
        while ( $decision !~ /^(y|Y|n|N)$/ ) {
            print "\n> Choose Y or N: ";
            chomp( $decision = <STDIN> );
        }
        if ( $decision =~ 'y|Y' ) {
            $book_db = Database->new();
        }
        elsif ( $decision =~ 'n|N' ) {
            print "\nOK. New file will append to existing database\n";
        }
    }

    $book_db->load_db($file);
    if ($EVAL_ERROR) {
        print "\n$EVAL_ERROR\n";
    }
    else {
        print "\nDone. Loaded file $file. " . scalar ( keys %{$book_db->get_books} ) . " book(s) in total\n";
        return $book_db;
    }
    return;
}

sub add_book {
    my $book_db = shift;
    if ( !$book_db ) {
        $book_db = Database->new();
    }
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    print "\n\n> Enter the book title: ";
    chomp( $title = <STDIN> );
    print "> Enter the book's author: ";
    chomp( $author = <STDIN> );
    print "> Enter a section: ";
    chomp( $section = <STDIN> );
    print "> Enter a shelf: ";
    chomp( $shelf = <STDIN> );
    print "> Enter name of the reader: ";
    chomp( $taken = <STDIN> );
    $book_db->add_book( title => $title, author => $author, section => $section, shelf => $shelf, taken => $taken );
    print "Book has been added to the database\n".  scalar ( keys %{$book_db->get_books} ) ." book(s) in total\n";
    save_books($book_db);
    return $book_db;
}

sub print_book {
    my ( $book_db, @books ) = @_;
    if ( !@books ) {
        @books = keys %{ $book_db->get_books };
    }
    for my $book ( sort { $a <=> $b } @books ) {
        print "\n";
        print "Title: " . $book_db->get_books->{$book}->get_title . "\n";
        print "Author: " . $book_db->get_books->{$book}->get_author . "\n";
        print "Section: " . $book_db->get_books->{$book}->get_section . "\n";
        print "Shelf: " . $book_db->get_books->{$book}->get_shelf . "\n";
        print "On Hands: " . $book_db->get_books->{$book}->get_taken . "\n";
        print "\n";
    }
    return;
}

sub get_pattern {
    my ( $strategy, $pattern, $choise ) = ( '', '', '' );
    my %strategies                      = ( 1 => 'title', 2 => 'author', 3 => 'section', 4 => 'shelf', 5 => 'taken' );
    print "\n\nSearch strategies:\n1 - by title\n2 - by author\n3 - by section\n4 - by shelf\n5 - by person\n";
    print "> Strategy: ";
    chomp( $choise = <STDIN> );
    while ( $choise !~ /^(1|2|3|4|5)$/ ) {
        print "\n> Choose between 1-5: ";
        chomp( $choise = <STDIN> );
    }
    $strategy = $strategies{$choise};
    print "\n> Enter a search pattern: ";
    chomp( $pattern = <STDIN> );
    return ( [ $strategy, $pattern ] );
}

sub parse_pattern {
    my $row = shift;
    my ( $strategy, $pattern, @matched ) = ( '', '', () );
    my @patterns = ( split /\s/, $row );
    for my $current_strategy (@patterns) {
        if ( $current_strategy =~ /^\w+\s*=\s*.+/ ) {
            $strategy = $current_strategy =~ s/\s*=.*//r;
            $pattern  = $current_strategy =~ s/^\w+\s*=\s*//r;
            if ( $strategy =~ /^(title|author|reader|shelf|section)$/ ) {
                push @matched, ( [ $strategy, $pattern ] );
            }
            else {
                print "No such strategy: $strategy\n";
            }
        }
    }
    @matched ? return @matched : return;
}

sub merge_results {
    my ($anon_arrays) = @_;
    my ( @result, %count ) = ( () );
    for my $array ( @{$anon_arrays} ) {
        for my $book ( @{$array} ) {
            $count{$book}++;
        }
    }
    for my $elem ( keys %count ) {
        if ( $count{$elem} > 1 ) {
            push @result, $elem;
        }
    }
    @result ? return @result : return;
}

sub search_book {
    my ( $book_db, $row, $pattern, $strategy, @matched, @passed, @total )  = ( @_, '', '', (), (), () );
    $row ? ( @passed = parse_pattern($row) ) : ( @passed = get_pattern );

    if (@passed) {
        ( $strategy, $pattern ) = @{ shift @passed };
        my @first_found = $book_db->search_book( $strategy, $pattern );
        #other patterns? perform search within books which were found at first iteration
        #in order not to check whole book database again
        while (@passed) {
            ( $strategy, $pattern ) = @{ shift @passed };
            my @intermediate = $book_db->search_book( $strategy, $pattern, @first_found );
            push @matched, ( [@intermediate] );
        }
        ( @matched > 1 ) ? @matched = merge_results( \@matched ) : ( @matched = @first_found );
        if (@matched) {
            print "Found books:\n";
            print_book( $book_db, @matched );
            print "Found " . @matched . " book(s)\n";
            return @matched;
        }
        else {
            print "No books found using pattern: " . ( $row ? $row : ( $strategy . "=" . $pattern ) ) . "\n";
        }
    }
    else {
        print "Incorrect search request\n";
    }
    return;
}

sub save_books {
    my ( $book_db, $file ) = @_;

    print "\n> Would you like to save changes? (Y/N): ";
    chomp( my $decision = <STDIN> );
    while ( $decision !~ /^(y|Y|n|N)$/ ) {
        print "\n> Choose Y or N: ";
        chomp( $decision = <STDIN> );
    }
    if ( $decision =~ 'y|Y' ) {
        if ( !$file ) {
            print "> Enter path to the file for saving: ";
            chomp( $file = <STDIN> );
        }
        $book_db->save_db($file);
        if ($EVAL_ERROR) {
            print "$EVAL_ERROR\n";
        }
        else {
            print "\nBooks saved!\n\n";
        }
    }
    elsif ( $decision =~ 'n|N' ) {
        print "\nOK. Returning to main menu\n";
    }
    return;
}

sub delete_book {
    my ( $book_db, $pattern ) = @_;
    my @books_to_delete = search_book( $book_db, $pattern );
    if (@books_to_delete) {
        my $decision = '';
        for my $book ( sort { $a <=> $b } @books_to_delete ) {
            if ( $decision !~ /a|A/ ) {
                print "====\n";
                print_book( $book_db, $book );
                print "> Delete this book?\nChoose (Y)es, (N)o or (A)ll: ";
                chomp( $decision = <STDIN> );
                while ( $decision !~ /^(y|Y|n|N|a|A)$/ ) {
                    print "\n> Choose Y, N or A: ";
                    chomp( $decision = <STDIN> );
                }
                if ( $decision =~ 'n|N' ) {
                    print "\nSkipping this one\n";
                    next;
                }
            }
            $book_db->delete_book($book);
        }
        print "\nMatched books were processed. " . scalar ( keys %{$book_db->get_books} ) . " books left\n";
        save_books($book_db);
    }
    else {
        print "Nothing to delete\n";
    }
    return;
}

my $database_obj = undef;
for ( greeting ; <STDIN> ; greeting ) {
    chomp;
    if (/^l\b/) {
        s/^l\s*//;
        my $path = s/^\w+\s+//r;
        $database_obj = load_database( $database_obj, $path );
    }
    elsif (/^a\b/) {
        $database_obj = add_book($database_obj);
    }
    elsif (/^p\b/) {
        !$database_obj ? remind : print_book($database_obj);
    }
    elsif (/^d\b/) {
        s/^d\s*//;
        my $pattern = s/^\w+\s+//r;
        !$database_obj ? remind : delete_book( $database_obj, $pattern );
    }
    elsif (/^f\b/) {
        s/^f\s*//;
        my $pattern = s/^\w+\s+//r;
        !$database_obj ? remind : search_book( $database_obj, $pattern );
    }
    elsif (/^s\b/) {
        s/^s\s*//;
        my $path = s/^\w+\s+//r;
        !$database_obj ? remind : save_books( $database_obj, $path );
    }
    elsif (/^h\b/) {
        print_help;
    }
    elsif (/^e\b/) {
        print "Bye\n";
        exit;
    }
    else {
        print "\nYou have not entered correct pattern\nTry again...\n\n";
    }
}
