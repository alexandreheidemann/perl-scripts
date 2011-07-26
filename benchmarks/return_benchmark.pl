#!/usr/bin/env perl

use strict;
use warnings;

use Benchmark qw(:all);

return_scalar();
return_array();
return_list();

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