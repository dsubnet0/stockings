#!/usr/bin/perl

my $ITERATIONS = 10000;

for (my $i=1;$i<=$ITERATIONS;$i++) {
	print "Running iteration $i...\r";
	my $number_of_failures = 0;
	my $result = `perl ./stockings.pl`;
	my @result = split('\n', $result);
	foreach (@result) {
		++$number_of_failures if (/^NO/);
	}

	if ($number_of_failures == 0) {
		print "DONE after $i iterations\n";
		print $result;
		last;
	}
}

print "SCRIPT FINISHED\n";
