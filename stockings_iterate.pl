#!/usr/bin/perl

use Data::Dumper;
$/ = "\r\n";

#Array of arrays
my @Nuclears = ();
my @Master = ();

#Hash
my %MATCHES = ();

#slurp list of nuclears
open(NUCLEARS,"/home/Douglas/files/families.txt") or die $!;

#slurp list of predetermineds
open(PREDETERMINED,"/home/Douglas/files/predetermined.txt") or die $!;


while (<NUCLEARS>) {
	chomp($_);	
	my @line = split(",",$_);
	push(@Nuclears,[@line]);
	foreach (@line) {
		push (@Master,$_);
	}
}

#print Dumper(@Nuclears);

while (<PREDETERMINED>) {
	chomp($_);
	my @line = split(",",$_);
	$MATCHES{$line[0]} = $line[1];
}


#print Dumper(\%MATCHES);
#print Dumper(keys %MATCHES);
my $num_failures = 0;
foreach $currNuc (@Nuclears) {
	undef my %is_nuclear;
	for (@{$currNuc}) { $is_nuclear{$_} = 1 }
	foreach $currPerson (@{$currNuc}) {
		my $i = 1;
		my $fail = 0;
		undef my %is_assigned;
		for (values %MATCHES) { $is_assigned{$_} = 1 }
		if (not exists $MATCHES{$currPerson}) {
			my $currPick = $Master[rand @Master];
			my @grep = grep(/^$currPick$/,(values %MATCHES));

			while (($currPerson eq $currPick) || $is_assigned{$currPick} == 1 || $is_nuclear{$currPick}) {
				$currPick = $Master[rand @Master];
				if (++$i > @Master ) {
					#print "NO POSSIBLE MATCHES FOUND FOR $currPerson\n\n";
					$num_failures++;
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

#print Dumper(\%MATCHES);
print "$num_failures \t\t";
print "$_ => $MATCHES{$_}; " for (keys %MATCHES);
print "\n\n";


