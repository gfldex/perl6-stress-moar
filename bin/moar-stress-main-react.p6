#! /usr/bin/env perl6

use v6.c;

my $line-source = Proc::Async.new("perl6", "bin/line-source.p6", :w);


react {
    whenever $line-source.stdout -> $l is copy {
        say $l;
        $line-source.put: $l++;
        # die "ouch!" if $++ > 100;
    }
    whenever $line-source.start {
        say "exitcode: ", .exitcode; done
    }
    whenever signal(SIGINT) { 
        say "sigint: $_";
        $line-source.close-stdin;
        exit 0
    }
    whenever Promise.in(5) {
        note "timeout";
        $line-source.kill;
    }
    whenever Promise.in(2) { $line-source.put: 1 }

    CONTROL { say "control: $_"; }
    CATCH { say .^name, ': ', .Str; }
    LEAVE { say "LEAVE"; }
    LAST { say "LAST"; }
    CLOSE { say "CLOSE"; }
}

