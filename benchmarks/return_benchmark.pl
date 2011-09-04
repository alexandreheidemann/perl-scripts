#!/usr/bin/env perl

use strict;
use warnings;

use Benchmark qw(:all);

return_scalar();
return_array();
return_list();

=pod

=head1 Benchmark for returning from functions

You should not care about the result. It's just an interesting fact.

Inspired by https://gist.github.com/1035329 and https://gist.github.com/1037210.

These benchmarks comparing the same functions. The difference between the functions of each benchmark is, that one uses
explicit return. The other one does not.

=cut

sub return_scalar {
    print "Return a scalar\n\n";

    cmpthese(
        10_000_000,
        {
            'with_return'       => sub {
                my $a = shift;

                return $a;
            },
            'without_return'    => sub {
                my $a = shift;

                $a;
            }
        }
    );

    print "\n";
}

sub return_array {
    print "Return an array\n\n";

    cmpthese(
        10_000_000,
        {
            'with_return'       => sub {
                my @a = ( 1, 2 );

                return @a;
            },
            'without_return'    => sub {
                my @a = ( 1, 2 );

                @a;
            }
        }
    );

    print "\n";
}

sub return_list {
    print "Return a list\n\n";

    cmpthese(
        10_000_000,
        {
            'with_return'       => sub {
                my ( $a, $b ) = ( 1, 2 );

                return ( $a, $b );
            },
            'without_return'    => sub {
                my ( $a, $b ) = ( 1, 2 );

                ( $a, $b );
            }
        }
    );

    print "\n";
}