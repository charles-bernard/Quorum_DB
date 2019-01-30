#!/usr/bin/awk

BEGIN {
	FS = "\t";

	bioprocess_table = "./input_tables/bioprocess.csv";
	signal_table = "./input_tables/UNCOMPLETE_signal.csv";
	species_table = "./input_tables/UNCOMPLETE_species.csv";
	gene_table = "./input_tables/gene.csv";
	function_table = "./input_tables/UNCOMPLETE_function.csv";
	reference_table = "./input_tables/UNCOMPLETE_reference.csv";
	sequence_table = "./input_tables/UNCOMPLETE_sequence.csv";

	k = 1
	print "bioprocess_tmp_id" "\t" "bioprocess" > bioprocess_table;
	tmp_bio_process_id["quorum_sensing"] = k;
	print k "\t" "quorum_sensing" > bioprocess_table;
}

{
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
	tmp_signal_id = $18;

	if(pubmed_id) {
		if(!already_pubmed[pubmed_id]) {
			already_pubmed[pubmed_id] = 1;
			print pubmed_id > reference_table;
		}
	}

	if(tmp_signal_id) {
		if(!already_signal[tmp_signal_id]) {
			already_signal[tmp_signal_id] = 1;
			print tmp_signal_id "\t" signal_supercategory "\t" signal_family \
			"\t" signal_trivial_name "\t" signal_systematic_name \
			"\t" signal_chemical_formula "\t" peptide_sequence > signal_table;
		}
	}

	if(ncbi_tax_id) {
		if(!already_tax[ncbi_tax_id]) {
			already_tax[ncbi_tax_id] = 1;
			print ncbi_tax_id > species_table;
		}
	}
	
	print gene_name "\t" gene_id "\t" db_gene_id "\t" gene_coordinates \
	"\t" prot_id "\t" db_prot_id "\t" tmp_signal_id > gene_table;

	if(NR == 1) {
		print ncbi_tax_id "\t" gene_name "\t" "seq_type" > sequence_table;
	} else {
		if(gene_id) {
			print ncbi_tax_id "\t" gene_name "\t" "cds" > sequence_table;
		}
		if(prot_id) {
			print ncbi_tax_id "\t" gene_name "\t" "protein" > sequence_table;
		}
	}

	if(response_bioprocess && NR > 1) {
		if(!already_filled[response_bioprocess]) {
			k++;
			tmp_bio_process_id[response_bioprocess] = k;
			print k "\t" response_bioprocess > bioprocess_table;
		}
	}

	if(NR == 1) {
		print ncbi_tax_id "\t" gene_name "\t" "tmp_bio_process_id" \
		"\t" gene_function > function_table;
	} else {
		print ncbi_tax_id "\t" gene_name "\t" tmp_bio_process_id["quorum_sensing"] \
		"\t" gene_function > function_table;
		if(response_bioprocess) {
			print ncbi_tax_id "\t" gene_name "\t" tmp_bio_process_id[response_bioprocess] \
			"\t" gene_function > function_table;
		}
	}
}
