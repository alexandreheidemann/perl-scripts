#!/usr/bin/env perl

use strict;
use warnings;
use CPAN;
use ExtUtils::Installed;
use Getopt::Std;

BEGIN {
    @MyFrontend::ISA = 'CPAN::Shell';
    sub MyFrontend::myprint { 1 }
    sub MyFrontend::mywarn { 1 }
    $CPAN::Frontend = 'MyFrontend';
}

$ENV{FTP_PASSIVE} = 1;

my $MAILTO  = 'root';
my $MAIL    = '/bin/mail';

my %opts;

getopts( 'im', \%opts );

my $installed = ExtUtils::Installed->new();

my @module = grep( ! /^Perl$/, $installed->modules() );

my $subject;
my $message;

CPAN::Index->reload();

if ( $opts{i} ) {
    $subject = 'Install update for CPAN-Modules';

    foreach my $mod ( CPAN::Shell->expand( 'Module', @module ) ) {
        next if ( $mod->uptodate );
        $message .= '_' x 80 . "\n" . '-' x 80 . "\n";
        $message .= $mod->id . "\n";
        $message .= '-' x 80 . "\n";
        $message .= 'Install Modul' . "\n";

        my $old_version = $mod->inst_version;

        if ( $mod->install ) {
            $message .= 'Installation failed' . "\n";
        }
        else {
            $message .= 'Old version :' . "\t" . $old_version . "\n";
            $message .= 'New version :' . "\t" . $mod->cpan_version . "\n";
        }

        $message .= '_' x 80 . "\n\n";
    }

    unless ( $message ) {
        $message = 'No updates installed.';
    }
}
else {
    $subject = 'Update for CPAN-Modules available';

    foreach my $mod ( CPAN::Shell->expand( 'Module', @module ) ) {
        next if ( $mod->uptodate );
        $message .= '_' x 80 . "\n" . '-' x 80 . "\n";
        $message .= $mod->id . "\n";
        $message .= '-' x 80 . "\n";
        $message .= 'Installed version :' . "\t" . $mod->inst_version . "\n";
        $message .= 'CPAN version  :' . "\t" . $mod->cpan_version . "\n";

        $message .= '_' x 80 . "\n\n";
    }

    unless ( $message ) {
        $message = 'No updates available.';
    }
}

if ( $opts{m} ) {
    open( PIPE, "|$MAIL" .  ' -s "' . $subject . '" "' . $MAILTO . '"' );
    print PIPE $message;
    close( PIPE );
}
else {
    print $subject . "\n\n" . $message . "\n";
}