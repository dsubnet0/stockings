#!/usr/bin/perl

use Data::Dumper;
$/ = "\r\n";

#Array of arrays
my @Nuclears = ();
my @Master = ();

#Hash
my %MATCHES = ();

#slurp list of nuclears
open(NUCLEARS,"./families.txt") or die $!;

#slurp list of predetermineds
open(PREDETERMINED,"./predetermined.txt") or die $!;


while (<NUCLEARS>) {
	chomp($_);	
	my @line = split(",",$_);
	push(@Nuclears,[@line]);
	foreach (@line) {
		push (@Master,$_);
	}
}

while (<PREDETERMINED>) {
	chomp($_);
	next if (/^#/);
	my @line = split(",",$_);
	$MATCHES{$line[0]} = $line[1];
}


foreach $currNuc (@Nuclears) {
	undef my %is_nuclear;
	for (@{$currNuc}) { $is_nuclear{$_} = 1 }
	foreach $currPerson (@{$currNuc}) {
		my $i = 1;
		my $fail = 0;
		undef my %is_assigned;
		for (values %MATCHES) { $is_assigned{$_} = 1; }
		if (not exists $MATCHES{$currPerson}) {
			my $currPick = $Master[rand @Master];
			my @grep = grep(/^$currPick$/,(values %MATCHES));

			while ( ($currPerson eq $currPick) or $is_assigned{$currPick} or $is_nuclear{$currPick}) {
				$currPick = $Master[rand @Master];
				if (++$i > @Master ) {
					print "NO POSSIBLE MATCHES FOUND FOR $currPerson\n\n";
				$fail = 1;
				last;
				}
			}
			if ($fail == 0) {
				$MATCHES{$currPerson} = $currPick;
			}
		}
		
	}	
}

foreach (sort keys %MATCHES) {
	print "$_\t=>\t$MATCHES{$_}\n";
}


