#!/usr/bin/env perl

use strict;
use warnings;

use Benchmark qw(:all);

my @a       = ( 1 .. 100 );
my @slice   = grep( $_ % 2, @a );

new_array();
new_hash();
new_even_array();

=pod

=head1 Benchmarks for arrays

=head2 EXAMPLE 1

Create a new array each element increased by 1.
( 2 .. 101 )

=over 4

=item Given:

An array:

    @a = ( 1 .. 100 );

A function which increases each element of the given array by 1 using foreach:

    sub new_array_foreach {
        my @b;
        foreach ( @a ) {
            push( @b, $_ + 1 );
        }

        return @b;
    }

A function which increases each element of the given array by 1 using map:

    sub new_array_map {
        my @b = map {
            $_ + 1;
        } @a;

        return @b;
    }

=back

Comparing these functions with 50.000 iterations will result in something like this:

               Rate     map foreach
    map     37037/s      --    -33%
    foreach 55556/s     50%      --

=cut

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

=pod

=head2 EXAMPLE 2

Create a hash each element is $_ => $_ + 1.
( 1 => 2, 2 => 3, ...., 100 => 101 )

=over 4

=item Given:

An array:

    @a = ( 1 .. 100 );

A function which creates a hash using foreach:

    sub new_hash_foreach {
        my %b;
        foreach ( @a ) {
            $b{$_} = $_ + 1;
        }

        return %b;
    }

A function which creates a hash using map:

    sub new_hash_map {
        my %b = map {
            $_ => $_ + 1;
        } @a;

        return %b;
    }

=back

Comparing these functions with 50.000 iterations will result in something like this:

               Rate     map foreach
    map      8157/s      --    -62%
    foreach 21277/s    161%      --

=cut

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

=pod

=head2 EXAMPLE 3

Create a new array with only even numbers.
( 2, 4, 6, ..... , 98, 100 )

=over 4

=item Given:

An array:

    @a = ( 1 .. 100 );

A function which creates a new array with only even numbers using foreach:

    sub new_even_array_foreach {
        my @b;
        foreach ( @a ) {
            push( @b, $_ ) unless ( $_ % 2 );
        }

        return @b;
    }

A function which creates a new array with only even numbers using map:

    sub new_even_array_map {
        my @b = map {
            ( $_ % 2 ) ? () : $_;
        } @a;

        return @b;
    }

A function which creates a new array with only even numbers using grep:

    sub new_even_array_grep {
        my @b = grep( ! ( $_ % 2 ), @a );

        return @b;
    }

A function which creates a new array with only even numbers using slices:

    @slice = ( 2, 4, 6, ... , 98, 100 );

    sub new_even_array_slice {
        my @b = @a[ @slice ];

        return @b;
    }

Comparing these functions with 50.000 iterations will result in something like this:

               Rate     map    grep foreach   slice
    map     17422/s      --    -28%    -52%    -72%
    grep    24272/s     39%      --    -33%    -62%
    foreach 35971/s    106%     48%      --    -43%
    slice   63291/s    263%    161%     76%      --

=cut

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
