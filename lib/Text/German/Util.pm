#!/usr/local/ls6/bin/perl
#                              -*- Mode: Perl -*- 
# Util.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Thu Feb  1 16:08:41 1996
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Tue Feb  6 17:25:32 1996
# Language        : Perl
# Update Count    : 3
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1996, Universität Dortmund, all rights reserved.
# 
# $Locker: pfeifer $
# $Log: Util.pm,v $
# Revision 1.1  1996/02/01 15:17:04  pfeifer
# Initial revision
#
# 

package Text::German::Util;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(bit_to_int wordclass $CAPITAL $LOWER $ADJEKTIV $UMLAUTR 
	     $VERB $FUNNY $ADJEKTIV);

sub bit_to_int {
    my $bitvec = shift;

    unpack('I', pack('b*', $bitvec)."\0\0\0\0");
}

$CAPITAL  = bit_to_int('01000');
$LOWER    = bit_to_int('01111');
$ADJEKTIV = bit_to_int('00100');
$VERB     = bit_to_int('01000');
$FUNNY    = bit_to_int('01001');

$UMLAUTR  = "[äöü]";
sub wordclass {
    if ($_[0] =~ /^[A-ZÄÖÜ]/) {
        $CAPITAL;
    } else {
        $LOWER;
    }
}
