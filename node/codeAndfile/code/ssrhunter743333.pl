#!/usr/bin/perl

#Search for simple sequence repeats in 
#FASTA-formatted DNA sequences. 
#EX:  ssr_net.pl *.con

my $start_time = times();

open IN1, "$ARGV[0]";

open OUT, ">$ARGV[0].ssr";
open OUTPUT, ">$ARGV[0].tab";

my $seqcount;
#motif-repeat parameters:
#specify motif length, minimum number of repeats.
#modify according to researcher's preferences
my @specs = ( [1,7],[2,4],[3,3],[4,3],[5,3],[6,3] ); 

my $sequence = "";

open OUT1, ">$ARGV[0].temp";
while(<IN1>)
{
	if(/^>/)
	{		
		if($sequence ne "")
		{
			print OUT1 $sequence."\n";
		}		
		print OUT1 ">>".$_;
		$sequence = "";
	}	
	else
   	{
   	 	chomp;
   	 	$sequence .= $_;
   	}
   	if(eof)
	{
		print OUT1 $sequence."\n";
	}				  
}
close IN1;
close OUT1;



$/ = ">>>";
open IN, "$ARGV[0].temp"; #FASTA formatted sequences as input
my %hash = ();
my $Mark = 0;
my $sequence = "";
while(<IN>)
{               
    s/>>>$//;
	@array = split(/\n/, $_);
	@array0 = split(/\s/, $array[0]);
	$FastaName = $array0[0];
	print OUT ">".$array[0]."\n" if($Mark != 0);
#	print $Mark."  ".$FastaName."\n" if($Mark != 0);
	$Mark++;
    $sequence = $array[1];
   	study($sequence);     #is this necessary?
    my $seqlength = length($sequence);
   	my $ssr_number = 1;   #track multiple ssrs within a single sequence
   	my %locations;        #track location of SSRs as detected
   	my $i;
    $sequence = uc($sequence);
    for($i=0; $i<scalar(@specs); $i++)
    {                                               #test each spec against sequence
	    my $motiflength = $specs[$i]->[0];
	    my $minreps = $specs[$i]->[1] - 1;
	    my $regexp = "(([gatc]{$motiflength})\\2{$minreps,})";
	    while ($sequence =~ /$regexp/ig)
	    {
	    	my $motif = uc($2);
	    	my $ssr = $1;
#	    	next if &homopolymer($motif,$motiflength); #comment out this line to report monomers
	    	my $ssrlength = length($ssr);          #overall SSR length
	        my $repeats = $ssrlength/$motiflength; #number of rep units
	    	my $end = pos($sequence);
	    	#print "first pos:   $end\n";             #where SSR ends
	    	pos($sequence) = $end - $motiflength;  
	    	
	    	my $start = $end - $ssrlength + 1;     #where SSR starts
	    	#print STDOUT join("\t",$motiflength, $motif, $repeats), "\n" if (&novel($start, \%locations));  #count SSR only once
	    	if (&novel($start, \%locations))
	    	{
	    		$endlen = $seqlength - $end;
	    				
	    		print OUT $motif."\t".$repeats."\t".$FastaName."\t".$start."\t".$end."\t".$seqlength."\t"."\n";
	    
	    		$motrep = $motif."\t".$repeats;
	    		if(exists $hash{$motrep})
	    		{
	    			$hash{$motrep}++;
	    		}
	    		else
	    		{
	    			$hash{$motrep} =1;
	    		}
	    	}			
	    }   	
   	}   	
}
close IN;
close OUT;
#system("rm $head.temp");

%hashm = ();
%hashl = ();
foreach $key (keys %hash)
{
	@line = split(/\t/,$key);
	if(length($line[0]) == 1)
	{
		$hashl{$key}->[0] = $line[0];
		$hashl{$key}->[1] = $line[1];
		$hashl{$key}->[2] = $hash{$key};	
		
	}
	else
	{
		$hashm{$key}->[0] = $line[0];
		$hashm{$key}->[1] = $line[1];
		$hashm{$key}->[2] = $hash{$key};
	}
}

foreach my $key ( sort{"$hashl{$a}->[0]" <=> "$hashl{$b}->[0]"||$hashl{$a}->[1] <=> $hashl{$b}->[1]} keys %hashl)
{
	print OUTPUT $key."\t$hashl{$key}->[2]\n";
}

foreach my $key ( sort{length($hashm{$a}->[0]) <=> length($hashm{$b}->[0]) || $hashm{$a}->[1] <=> $hashm{$b}->[1]} keys %hashm)
{
	print OUTPUT $key."\t$hashm{$key}->[2]\n";
}	

close OUTPUT;

my $end_time = times();
my $total_time = $end_time - $start_time + 1;
print "time:  $total_time";

#sub homopolymer 
#{
#    #return true if motif is repeat of single nucleotide
#    my ($motif,$motiflength) = @_;
#    my ($reps) = $motiflength - 1;
#    return 1 if ($motif =~ /([gatc])\1{$reps}/);
#    return 0;
#}

sub novel
{
    my($position, $locationsref) = @_;
    if(defined $locationsref->{$position}) 
    {
       return undef;
    } 
    else 
    {
       $locationsref->{$position} = 1;
       return 1;
    }
}
