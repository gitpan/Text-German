#!/usr/local/ls6/bin/perl
#                              -*- Mode: Perl -*- 
# Word.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Thu Feb  1 13:57:42 1996
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Tue Feb  6 17:39:16 1996
# Language        : Perl
# Update Count    : 22
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1996, Universität Dortmund, all rights reserved.
# 
# $Locker: pfeifer $
# $Log: German.pm,v $
# Revision 1.1  1996/02/01 15:19:36  pfeifer
# Initial revision
#
# 

package Text::German;
use Text::German::Util;
use Text::German::Adjektiv;
use Text::German::Ausnahme;
use Text::German::Endung;
use Text::German::Regel;
use Text::German::Verb;
use Text::German::Vorsilbe;

sub partition {
    my $word = shift;
    my $vorsilbe = Text::German::Vorsilbe::max_vorsilbe($word);
    my $vl = length($vorsilbe||'');
    my $endung = Text::German::Endung::max_endung(substr($word,$vl));
    my $el = length($endung||'');
    my $l = length($word);

    return ($vorsilbe, substr($word, $vl, $l-$vl-$el), $endung);
}

sub reduce {
    my $word = shift;
    my @word = partition($word);
    my @tmp;

    printf "INIT %s\n", join ':', @word if $debug;
    $word[0] ||= '';
    $word[2] ||= '';
    my $a = Text::German::Ausnahme::reduce(@word);
    return($a) if defined $a;

    my $c = wordclass($word);

    unless (($c|$FUNNY || $word[2])) {
	return $word[1];
    }
    if ($c & $VERB) {
	@tmp = Text::German::Verb::reduce(@word);
	if ($#tmp) {
	    @word = @tmp;
	    printf "VERB %s\n", join ':', @word if $debug;
            return($word[1].'en');
	}
    }
    if ($c & $ADJEKTIV) {
	@tmp = Text::German::Adjektiv::reduce(@word);
	if ($#tmp) {
	    @word = @tmp;
	    printf "VERB %s\n", join ':', @word if $debug;
            return($word[1]);
	}
    }
    @tmp = Text::German::Regel::reduce(@word);
    if ($#tmp) {
	@word = @tmp;
	printf "REGEL %s\n", join ':', @word if $debug;
    }
    return $word[0].$word[1]; # vorsilbe wieder anhaengen
}

1;
