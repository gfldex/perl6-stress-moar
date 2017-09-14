#! /usr/bin/env perl6

use v6.c;

my $line-source = Proc::Async.new("perl6", "bin/uni-directional-source.p6", :w);

$line-source.stdout.tap(-> $l is copy {
    $line-source.put: $l++;
    # say $l.chop;
    if (1..1000).pick > 999 {
        say $l.chop;
        # sleep 2;
    }
});

signal(SIGINT).tap({ $line-source.close-stdin; exit 0 });

await $line-source.start, Promise.in(2).then: { $line-source.put: 1 };
