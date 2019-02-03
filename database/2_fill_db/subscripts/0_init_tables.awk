#!/usr/bin/awk

BEGIN {
	FS = "\t";

	# variable <output_dir> must be sent to this script

	# THE DIFFERENT OUTPUT TABLES
	bioprocess_table = output_dir "/bio_process.csv";
	function_table = output_dir "/function.csv";
	gene_table = output_dir "/gene.csv";
	reference_table = output_dir "/reference.csv";
	sequence_table = output_dir "/UNCOMPLETE_sequence.csv";
	signal_table = output_dir "/signal.csv";
	species_table = output_dir "/UNCOMPLETE_species.csv";
	
	b = 1;
	bio_process_id["quorum sensing"] = b;
	r = 0;
}

{
	# FIELD NAMES
	signal_supercategory = $1;
	signal_family = $2.
	signal_trivial_name = $3;
	signal_systematic_name = $4;
	signal_chemical_formula = $5;
	peptide_sequence = $6;
	ncbi_tax_id = $7;
	taxon_name = $8;
	gene_name = $9;
	gene_id = $10;
	db_gene_id = $11;
	gene_coordinates = $12;
	prot_id = $13;
	db_prot_id = $14;
	gene_function = $15;
	response_bioprocess = $16;
	pubmed_id = $17;
	signal_id = $18;
	signal_info = $19;
}

NR == 1 {
	# HEADER DEFINITION
	print "bio_process_id" "\t" "bio_process" > bioprocess_table
	print ncbi_tax_id "\t" gene_name "\t" "bio_process_id" \
		"\t" "signal_id" "\t" gene_function "\t" "info" \
		"\t" "retrieval_status" "\t" "reference_id" > function_table;
	print ncbi_tax_id "\t" gene_name "\t" gene_id "\t" db_gene_id \
		"\t" gene_coordinates "\t" prot_id "\t" db_prot_id > gene_table;
	print "reference_id" "\t" pubmed_id "\t" "doi" "\t" "isbn" > reference_table;
	print ncbi_tax_id "\t" gene_name "\t" "seq_type" > sequence_table;
	print signal_id "\t" signal_supercategory "\t" signal_family \
		"\t" signal_trivial_name "\t" signal_systematic_name \
		"\t" signal_chemical_formula "\t" peptide_sequence \
		"\t" signal_info > signal_table;
	print ncbi_tax_id > species_table;


	# INIT LINES
	print bio_process_id["quorum sensing"] "\t" "quorum sensing" > bioprocess_table
	print "0\t\t\t" > reference_table;
	print "0\t\t\t\t\t\t\t" > signal_table;
}

NR > 1 {
	if(response_bioprocess) {
		split(response_bioprocess, response_bioprocesses, "|");
		for(i = 1; i <= length(response_bioprocesses); i++) {
			if(!bio_process_id[response_bioprocesses[i]]) {
				b++;
				bio_process_id[response_bioprocesses[i]] = b;
				print b "\t" response_bioprocesses[i] > bioprocess_table;
			}
		}
	} else {
		response_bioprocesses[1] = "";
	}

	if(pubmed_id) {
		split(pubmed_id, pubmed_ids, "|");
		for(i = 1; i <= length(pubmed_ids); i++) {
			if(!reference_id[pubmed_ids[i]]) {
				r++;
				reference_id[pubmed_ids[i]] = r;
				print r "\t" pubmed_ids[i] "\t\t" > reference_table;
			}
		}
	} else {
		pubmed_ids[1] = "0";
		reference_id[pubmed_ids[1]] = "0";
	}

	for(i = 1; i <= length(pubmed_ids); i++) {
		print ncbi_tax_id "\t" gene_name "\t" bio_process_id["quorum sensing"] \
			"\t" signal_id "\t" gene_function "\t\t" "publi_reference" \
			"\t" reference_id[pubmed_ids[i]] > function_table;
		if(response_bioprocess) {
			for(j = 1; j <= length(response_bioprocesses); j++) {
				print ncbi_tax_id "\t" gene_name "\t" bio_process_id[response_bioprocesses[j]] \
					"\t" signal_id "\t" gene_function "\t\t" "publi_reference" \
					"\t" reference_id[pubmed_ids[i]] > function_table;
			}
		}
	}

	print ncbi_tax_id "\t" gene_name "\t" gene_id "\t" db_gene_id \
		"\t" gene_coordinates "\t" prot_id "\t" db_prot_id > gene_table;

	if(gene_id) {
		print ncbi_tax_id "\t" gene_name "\t" "cds" > sequence_table;
	}
	if(prot_id) {
		print ncbi_tax_id "\t" gene_name "\t" "protein" > sequence_table;
	}

	if(signal_id) {
		if(!already_signal[signal_id]) {
			already_signal[signal_id] = 1;
			print signal_id "\t" signal_supercategory "\t" signal_family \
			"\t" signal_trivial_name "\t" signal_systematic_name \
			"\t" signal_chemical_formula "\t" peptide_sequence \
			"\t" signal_info > signal_table;
		}
	}

	if(ncbi_tax_id) {
		if(!already_tax[ncbi_tax_id]) {
			already_tax[ncbi_tax_id] = 1;
			print ncbi_tax_id > species_table;
		}
	}
}
