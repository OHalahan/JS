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
        while ( $decision !~ /^(y|n)$/i ) {
            print "\n> Choose Y or N: ";
            chomp( $decision = <STDIN> );
        }
        if ( $decision =~ /y/i ) {
            $book_db = Database->new();
        }
        elsif ( $decision =~ /n/i ) {
            print "\nOK. New file will append to existing database\n";
        }
    }

    if ( $book_db->load_db($file) ) {
        print "\nDone. Loaded file $file. " . scalar ( keys %{$book_db->get_books} ) . " book(s) in total\n";
        return $book_db;
    }
    else {
        return undef;
    }
}

sub validate_field {
    my ( $f_name ) = @_;
    chomp( my $choise = <STDIN> );
    while ( $choise =~ /^\s+$/ || !$choise ) {
        print "\n> $f_name cannot be empty: ";
        chomp( $choise = <STDIN> );
    }
    return $choise || undef;
}

sub add_book {
    my $book_db = shift;
    if ( !$book_db ) {
        $book_db = Database->new();
    }
    my ( $title, $author, $section, $shelf, $taken ) = ( '', '', '', '', '' );
    print "\n\n> Enter the book title: ";
    $title = validate_field('Title');
    print "> Enter the book's author: ";
    $author = validate_field('Author');
    print "> Enter a section: ";
    $section = validate_field('Section');
    print "> Enter a shelf: ";
    $shelf = validate_field('Shelf');;
    print "> Enter name of the reader if any: ";
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
    @matched ? return @matched : return undef;
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
    @result ? return @result : return undef;
}

sub search_book {
    my ( $book_db, $row )  = ( @_ );
    my ( $pattern, $strategy, @matched, @passed, @total ) = ( '', '', (), (), () );
    $row ? ( @passed = parse_pattern($row) ) : ( @passed = get_pattern );

    if (@passed) {
        ( $strategy, $pattern ) = @{ shift @passed };
        $pattern =~ s/\*/\.*/;
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
    while ( $decision !~ /^(y|n)$/i ) {
        print "\n> Choose Y or N: ";
        chomp( $decision = <STDIN> );
    }
    if ( $decision =~ /y/i ) {
        if ( !$file ) {
            print "> Enter path to the file for saving: ";
            chomp( $file = <STDIN> );
        }
        if ($book_db->save_db($file)) {
            print "\nBooks saved!\n\n";
            return 1;
        }
    }
    elsif ( $decision =~ /n/i  ) {
        print "\nOK. Returning to main menu\n";
    }
    return undef;
}

sub delete_book {
    my ( $book_db, $pattern ) = @_;
    my @books_to_delete = search_book( $book_db, $pattern );
    if (@books_to_delete) {
        my $decision = '';
        for my $book ( sort { $a <=> $b } @books_to_delete ) {
            if ( $decision !~ /a/i ) {
                print "====\n";
                print_book( $book_db, $book );
                print "> Delete this book?\nChoose (Y)es, (N)o, (C)ancel or (A)ll: ";
                chomp( $decision = <STDIN> );
                while ( $decision !~ /^(y|n|a|c)$/i ) {
                    print "\n> Choose Y, N, C or A:";
                    chomp( $decision = <STDIN> );
                }
                if ( $decision =~ /n/i ) {
                    print "\nSkipping this one\n";
                    next;
                }
                elsif ( $decision =~ /c/i ) {
                    return undef;
                }
            }
            $book_db->delete_book($book);
        }
        print "\nMatched books were processed. " . scalar ( keys %{$book_db->get_books} ) . " books left\n";
        save_books($book_db);
        return 1;
    }
    else {
        print "Nothing to delete\n";
    }
    return undef;
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
