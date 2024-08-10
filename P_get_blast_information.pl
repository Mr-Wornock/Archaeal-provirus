#!/usr/bin/perl
use strict;
use warnings;

#######对blast+中blasp结果做处理，提取比对信息#########
die "perl $0 <blast_out_file> <out_put>" if @ARGV<2;
my($in,$out) = @ARGV;

open IN,"$in" || die $!;
open OUT,">$out" || die $!;

print OUT "Query_ID\tQuery_len\tSbjct\tSbjct_len\tBitscore\tEvalue\tIdentity\tAlign_len\tQ_start\tQ_end\tS_start\tS_end\n";
my($query_id,$query_len,$sbjct,$sbjct_length,$Score,$E_value,$match,$all_len,$identity,$pos_len,$positives,$gap_num);
my($query_start,$query_end,$sbjct_start,$sbjct_end);
my $n;
my $str;
while (<IN>) {
	chomp;
	if (/Query=\s+(\S+)/) {
		$query_id = $1;
		while (1) {
			my $query_len_info = <IN>;
			chomp($query_len_info);
			$query_len_info =~s/,//g;
			if ($query_len_info =~ /Length=(\d+)/) {
				$query_len = $1;
				last;
			}
		}
		#<IN>;
		#my $query_len_info = <IN>;
		#chomp($query_len_info);
		#$query_len_info =~s/,//g;
		#if ($query_len_info =~ /Length=(\d+)/) {
		#	$query_len = $1;
		#}
	}
	if (/^>(.+)/) {
		$sbjct  = $1;
		$sbjct =~ s/^\s+//;
		my $sbjct_info = <IN>;
		while(!($sbjct_info =~/Length=(\d+)/)) {
			chomp($sbjct_info);
			$sbjct .= " $sbjct_info";
			$sbjct_info = <IN>;
		}
		$sbjct_info =~s/\s+/ /g;
		if ($sbjct_info =~/Length=(\d+)/) {
			$sbjct_length = $1;
		}
	}
	if (/Score =\s+(.+)\s+bits.+,\s+Expect.*?\s+=\s+(\S+)/) {
		$n = 0;
		($Score,$E_value) = ($1,$2);
		$E_value =~s/,//;
		#print OUT "$Score\t$E_value\n";
		my $line= <IN>;
		if ($line =~/Identities\s+=\s+(\d+)\/(\d+)\s+\((\d+\%)\),\s+Positives\s+=\s+(\d+)\/(\d+)\s+\((\d+\%)\)/) {
			($match,$all_len,$identity,$pos_len,$positives) = ($1,$2,$3,$4,$6);
			if ($line =~ /,\s+Gaps\s+=\s+(\d+)\/(\d+)/) {
				$gap_num = $1;
			}
			else{$gap_num = 0;}
			if ($query_start) {
				print OUT join "\t",($query_start,$query_end,$sbjct_start,$sbjct_end);
				print OUT "\n";
			}
			$str = join "\t",($query_id,$query_len,$sbjct,$sbjct_length,$Score,$E_value,$identity,$all_len);
			print OUT "$str\t";
		}
	}
	if (/^Query\s+(\d+)\s+\S+\s+(\d+)/) {
		$n++;
		$query_end = $2;
		if ($n == 1) {
			$query_start = $1;
		}
	}
	if (/^Sbjct\s+(\d+)\s+\S+\s+(\d+)/) {
		$sbjct_end = $2;
		if ($n == 1) {
			$sbjct_start = $1;
		}
	}
}
close IN;
print OUT join "\t",($query_start,$query_end,$sbjct_start,$sbjct_end);
print OUT "\n";
