#!/usr/bin/env perl

use strict;
use warnings;

use Benchmark qw(:all);

my @a       = ( 1 .. 100 );
my @slice   = grep( $_ % 2, @a );

new_array();
new_hash();
new_even_array();

sub new_array {
    print "Given an array \@a = ( 1 .. 100 );\n";
    print "Create a new array each element increased by 1\n";
    print "( 2 .. 101 )\n\n";

    cmpthese(
        50_000,
        {
            'foreach'   => \&new_array_foreach,
            'map'       => \&new_array_map
        }
    );

    print "\n";
}

sub new_array_foreach {
    my @b;
    foreach ( @a ) {
        push( @b, $_ + 1 );
    }

    return @b;
}

sub new_array_map {
    my @b = map {
        $_ + 1;
    } @a;

    return @b;
}

sub new_hash {
    print "Given an array \@a = ( 1 .. 100 );\n";
    print "Create a hash each element is \$_ => \$_ + 1\n";
    print "( 1 => 2, 2 => 3, ...., 100 => 101 )\n\n";

    cmpthese(
        50_000,
        {
            'foreach'   => \&new_hash_foreach,
            'map'       => \&new_hash_map
        }
    );

    print "\n";
}

sub new_hash_foreach {
    my %b;
    foreach ( @a ) {
        $b{$_} = $_ + 1;
    }

    return %b;
}

sub new_hash_map {
    my %b = map {
        $_ => $_ + 1;
    } @a;

    return %b;
}

sub new_even_array {
    print "Given an array \@a = ( 1 .. 100 );\n";
    print "Create a new array with only even numbers\n";
    print "( 2, 4, 6, ..... , 98, 100 )\n\n";

    cmpthese(
        50_000,
        {
            'foreach'   => \&new_even_array_foreach,
            'map'       => \&new_even_array_map,
            'grep'      => \&new_even_array_grep,
            'slice'     => \&new_even_array_slice
        }
    );
}

sub new_even_array_slice {
    my @b = @a[ @slice ];

    return @b;
}

sub new_even_array_grep {
    my @b = grep( ! ( $_ % 2 ), @a );

    return @b;
}

sub new_even_array_map {
    my @b = map {
        ( $_ % 2 ) ? () : $_;
    } @a;

    return @b;
}

sub new_even_array_foreach {
    my @b;
    foreach ( @a ) {
        push( @b, $_ ) unless ( $_ % 2 );
    }

    return @b;
}
