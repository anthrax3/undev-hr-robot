#! /usr/bin/perl
use uni::perl;
use autodie;

# see http://m.friendfeed-media.com/b9c8d58fd830d87e6be7ddf3107e7c5a3773ae4c
#
# abcd ef aghij

open my $base, '<:encoding(koi8-r)', '/home/kappa/work/russian/base.koi';

my @words = map { s#(?:/.*)?\n##s; lc } <$base>;   # fix syn hl

#say for @words[0..10];

my @pos;
sub next_n {
    my $n = shift;

    while ($pos[$n] < @words && length($words[$pos[$n]]) != $n) {
    	++$pos[$n];
    }

    return $pos[$n] == @words ? $pos[$n] = 0 : $words[$pos[$n]++];
}

sub is_diff {
    scalar keys %{{map { $_ => 1 } split '', $_[0]}} == length($_[0])
}

sub next_diff {
    my $str;
    
    do {
        $str = next_n($_[0]) or return undef;
    } until (is_diff($str));

    return $str;
}

#say next_diff(4) for 0 .. 4;

$|++;

L4:
while(4) {
    my $s4 = next_diff(4) or die;
    L2:
    while (2) {
        my $s2 = next_diff(2) or next L4;
        next unless is_diff("$s4$s2");
        while (5) {
            my $s5 = next_diff(5) or next L2;
            my $s54 = substr($s5, 1);
            next unless is_diff("$s4$s2$s54");

            #print ".";
            say "$s4 $s2 $s5" if substr($s4, 0, 1) eq substr($s5, 0, 1);
        }
    }
}
