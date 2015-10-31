#!/usr/bin/perl

use v5.10;
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

$/ = "\n";
while (<PREDETERMINED>) {
    chomp($_);
	next if (/^#/);
	my @line = split(",",$_);
	$MATCHES{$line[0]} = $line[1];
}

$/ = "\r\n";

foreach $currNuc (@Nuclears) {
	undef my %is_nuclear;
	for (@{$currNuc}) { $is_nuclear{$_} = 1 }
	foreach $currGiver (@{$currNuc}) {
        next if defined $MATCHES{$currGiver};
		my $i = 1;
		my $fail = 0;
		undef my %is_giving;
        undef my %is_receiving;
        for (values %MATCHES) { $is_receiving{$_} = 1; }
		for (keys %MATCHES) { $is_giving{$_} = 1; }
		if (not exists $MATCHES{$currGiver}) {
			my $proposedReceiver = $Master[rand @Master];
            
			while ( ($currGiver eq $proposedReceiver) or $is_giving{$currGiver} or $is_nuclear{$proposedReceiver} or $is_receiving{$proposedReceiver} ) {
				$proposedReceiver = $Master[rand @Master];

           #     print Dumper(\%MATCHES);
           #     say "Giver:$currGiver, proposedreceiver:$proposedReceiver, giver already giving?:$is_giving{$currGiver}, receiver already receiving?:$is_receiving{$proposedReceiver}, isNuclear?:$is_nuclear{$proposedReceiver}\n"; 

				if (++$i > @Master ) {
					print "NO POSSIBLE MATCHES FOUND FOR $currGiver\n\n";
				    $fail = 1;
				    last;
				}
			}
			if ($fail == 0) {
				$MATCHES{$currGiver} = $proposedReceiver;
			}
		}
		
	}	
}

foreach (sort keys %MATCHES) {
	print "$_\t=>\t$MATCHES{$_}\n";
}


