# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN {print "1..15\n";}
END {print "not ok 1\n" unless $loaded;}
use Text::German;
$loaded = 1;
$i = 1;
print "ok 1\n";

######################### End of black magic.
$Text::German::Regel::debug = 0;
$Text::German::debug = 0;
$debug = 0;
#	gemachter testen h�uslich ��e verband verbarg verbi� fr�mmlich
#	vordersten hintersten geheiligt gem��igt wenn ich so wollte
#	wie ich k�nnte w�rde ich noch ganz anders als die anderen
#	qualifiziert �usserst fade findet das mein k�tzchen eure
#	heiserkeit heiterkeiten hoheitsvollerweise

@should = qw(

             infrastrukturell Verfall gesellschaftlich Organisation DDR
             f�hren verh�rten isolationistisch Politik reformerisch
             Anforderung Mitte Jahr Krisenpotential

             );
for $word 
    (qw(

        infrastrukturelle Verfall gesellschaftlichen Organisation DDR
        f�hrte verh�rteten isolationistischen Politik reformerische
        Anforderungen Mitte Jahre Krisenpotential
)) {
    #$x = join ':', Text::German::partition($word);
    print "=====$word=====\n" if $debug;
    $x = Text::German::reduce($word);
    $y = shift @should;
    print "$word => $x ($y)\n";
    $i++;
    ($x eq $y)? print "ok $i\n": print "not ok $i\n";
}
# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

