#! /usr/bin/env perl6

use v6.c;

my $line-source = Proc::Async.new("perl6", "bin/line-source.p6", :w);

signal(SIGINT).tap({ $line-source.close-stdin; exit 0 });

react {
    whenever $line-source.stdout -> $l is copy {
        $line-source.put: $l++;
        if (1..1000).pick > 999 {
            say $l.chop;
            # sleep 2;
        }

    }
    
    whenever Promise.in(2) { $line-source.put: 1 }
}

$line-source.start;
