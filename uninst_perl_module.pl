#!/usr/bin/env perl

use strict;
use warnings;
use ExtUtils::Installed;
use Getopt::Std;

my %opts;

getopts( 'd', \%opts );

my @modules = @ARGV;

unless ( scalar( @modules ) ) {
    print 'No argument given!' . "\n";
    exit;
}

my $installed = ExtUtils::Installed->new();

foreach my $module ( @modules ) {
    # Find all the installed packages
    print( "Try to find module $module\n" );

    if ( grep( /^\Q$module\E$/, $installed->modules() ) ) {
        print("Do you want to delete $module? [n] ");

        my $r = <STDIN>;
        chomp( $r );

        if ( $r && $r =~ /^y(es)?$/i ) {
            foreach my $file ( sort( $installed->files( $module ) ) ) {
                print( "rm $file\n" );
                unlink( $file ) unless ( $opts{d} );
            }

            my $pf = $installed->packlist( $module )->packlist_file();

            print( "rm $pf\n" );

            unlink( $pf ) unless ( $opts{d} );

            $pf =~ s/\/[^\/]*$//;

            while ( remove_dir( $pf ) ) {
                $pf =~ s/\/[^\/]*$//;
            }

            foreach my $dir ( sort( $installed->directory_tree( $module ) ) ) {
                remove_dir( $dir );
            }
        }
    }
    else {
        print 'Module ' . $module . ' not found!' . "\n";
    }
}

sub remove_dir {
    my ( $dir ) = @_;

    if ( emptydir( $dir ) ) {

        print( "rmdir $dir\n" );

        rmdir( $dir ) unless ( $opts{d} );

        return 1;
    }
}

sub emptydir {
    my ( $dir ) = @_;

    opendir( DIR, $dir ) || return 0;

    my @count = readdir( DIR );

    closedir( DIR );

    return ( scalar( @count ) == 2 ) ? 1 : 0;
}
