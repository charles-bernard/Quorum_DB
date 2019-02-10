#!/usr/bin/awk

function get_complementary_seq(seq) {
	rev_seq = "";

	# The sequence is read from the end to the start
	for(i = length(seq); i > 0; i--) {
		# Then each nt will be reversed
		# and concatenated to the previous
		nt = substr(seq, i, 1);

		# Check if nt is A,C,T or G 
		if(nt ~ /[ATCG]/) {
			rev_seq = rev_seq rev[nt];
		# A gap character "-" will be use if not
		} else {
			rev_seq = rev_seq "-";
		}
	}
	return rev_seq;
}

BEGIN { 
	# The variable coord is sent to this script
	l = 70;

	rev["A"] = "T";
	rev["T"] = "A";
	rev["C"] = "G";
	rev["G"] = "C";

	split(coord, coord_fields, "[:_]");
	strand = coord_fields[1];
	if(strand == "+") {
		start = coord_fields[2];
		end = coord_fields[3];
	} else if(strand == "C") {
		start = coord_fields[3];
		end = coord_fields[2];
	}
}

# print header
NR == 1 { print $0 "strand: " strand " (" start "-" end ")"; }

# concatenate genome or whatsoever sequence
NR > 1 { s = s $0; }

# substr portion of interest and print it as fasta
END { 
	seq = substr(s, start, end-start+1);

	if(strand == "-") {
		seq = get_complementary_seq(seq)
	}

	for(k = 1; k < end-start+1; k += l) {
		print substr(seq, k, l);
	}
}
