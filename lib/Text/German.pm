#!/usr/local/ls6/bin/perl
#                              -*- Mode: Perl -*- 
# Word.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Thu Feb  1 13:57:42 1996
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Mon Jun  3 16:45:47 1996
# Language        : Perl
# Update Count    : 67
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1996, Universität Dortmund, all rights reserved.
# 
# $Locker:  $
# $Log: German.pm,v $
# Revision 0.03  1996/07/02 09:39:11  pfeifer
# *** empty log message ***
#
# Revision 0.02  1996/05/13 10:07:46  pfeifer
# Added rudimentary cache support.
#
# Revision 1.1  1996/02/01 15:19:36  pfeifer
# Initial revision
#
# 

package Text::German;

$VERSION = $VERSION = substr(q$Revision: 0.03 $,10);
use Text::German::Util;
require Text::German::Adjektiv;
require Text::German::Ausnahme;
require Text::German::Endung;
require Text::German::Regel;
require Text::German::Verb;
require Text::German::Vorsilbe;
require Text::German::Cache;

sub partition {
    my $word = shift;
    my $vorsilbe = Text::German::Vorsilbe::max_vorsilbe($word);
    my $vl       = length($vorsilbe||'');
    my $endung   = Text::German::Endung::max_endung(substr($word,$vl));
    my $el       = length($endung||'');
    my $l        = length($word);

    return ($vorsilbe, substr($word, $vl, $l-$vl-$el), $endung);
}

sub reduce {
    my $word        = shift;
    my $satz_anfang = shift;
    my @word = partition($word);
    my @tmp;

    printf "INIT %s\n", join ':', @word if $debug;
    $word[0] ||= '';
    $word[2] ||= '';

    my $a = Text::German::Ausnahme::reduce(@word);
    return($a) if defined $a;

    my $c = wordclass($word, $satz_anfang);

    unless ($c&$FUNNY || $word[2]) {
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
    #return join ':', @word;
    return $word[0].$word[1]; # vorsilbe wieder anhaengen
}

# Do not use this! 
my $cache;

sub cache_reduce {
  unless ($cache) {
    $cache = Text::German::Cache->new(Verbose  => 0,
                                      Function => sub {reduce($_[0], 1); },
                                      Gc       => 1000,
                                      Hold     => 600,
                                     );
  }
  $cache->get(@_);
}

# This is a hoax!
sub stem {
  my $word        = shift;
  my $gf          = reduce($word, @_);
  my @word = partition($gf);

  return $word[1];
}

1;
