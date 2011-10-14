#!/usr/bin/env perl

use strict;
use warnings;

use Benchmark qw(:all);
use Data::Dumper;

my $file = <<EOI;
HEADLINE 23

attribute1: 23value1
attribute2: 23value2
attribute3: 23value3

HEADLINE 345

attribute1: 345value1
attribute2: 345value2
attribute3: 345value3

HEADLINE 354

attribute1: 354value1
attribute2: 354value2
attribute3: 354value3

HEADLINE 9791

attribute1: 9791value1
attribute2: 9791value2
attribute3: 9791value3
EOI

split_vs_regexp_string();
split_vs_regexp_complex_string();
group_vs_lookahead();

sub with_regexp {
    my $str = $file;

    my ( %headlines ) = $str =~ /HEADLINE\s+(\d+)\s+((?:(?:\S+)\s*:\s*(?:\S+)(?:\s|$))+)/gs;

    my $ret;

    foreach my $key ( keys( %headlines ) ) {
        my ( %attributes ) = $headlines{$key} =~ /(\S+)\s*:\s*(\S+)(?:\s|$)/g;

        $ret->{$key} = \%attributes;
    }

    return $ret;
}

sub with_split {
    my $str = $file;

    my @lines = split( "\n", $str );

    my $ret = {};

    my $current;

    foreach my $line ( @lines ) {
        chomp( $line );
        if ( $line =~ /^HEADLINE (\d+)$/ ) {
            $current = $1;
        }
        elsif ( $line =~ /^(\S+)\s*:\s*(\S+)$/ ) {
            $ret->{$current}->{$1} = $2;
        }
    }

    return $ret;
}

sub split_vs_regexp_complex_string {
    print "Given an string:\n\n";
    print $file . "\n";
    print "Create an hashref:\n\n";
    print Dumper( with_regexp() ) . "\n";

    cmpthese(
        100_000,
        {
            'split'  => \&with_split,
            'regexp' => \&with_regexp,
        }
    );

    print "\n";
}

sub split_vs_regexp_string {
    print "Given an string \"abc\"\n";
    print "Create an array with the characters of the string\n";
    print "( 'a', 'b', 'c' )\n\n";

    cmpthese(
        1_000_000,
        {
            'split' => sub {
                my $a = 'abc';

                my @b = split( //, $a );

                return @b;
            },
            'regexp' => sub {
                my $a = 'abc';

                my ( @b ) = $a =~ /^(.)(.)(.)$/g;

                $a;
            },
        }
    );

    print "\n";
}

sub group_vs_lookahead {
    print "Given an string:\n\n";
    print $file . "\n";
    print "Create an hashref:\n\n";
    my ( %hash ) = $file =~ /HEADLINE\s+(\d+)\s+((?:(?:\S+)\s*:\s*(?:\S+)(?:\s|$))+)/gs;
    print Dumper( \%hash ) . "\n";

    cmpthese(
        1_000_000,
        {
            'group' => sub {
                my ( %headlines ) = $file =~ /HEADLINE\s+(\d+)\s+((?:(?:\S+)\s*:\s*(?:\S+)(?:\s|$))+)/gs;
            },
            'lookahead' => sub {
                my ( %headlines ) = $file =~ /HEADLINE\s+(\d+)\s+(.+?)(?=HEADLINE|$)/gs;
            },
        }
    );
}
