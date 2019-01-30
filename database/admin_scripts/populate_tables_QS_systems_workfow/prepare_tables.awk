#!/usr/bin/awk

BEGIN {
	FS = "\t";
	
	bioprocess_table = "./input_tables/bioprocess.csv";
	signal_table = "./input_tables/signal.csv";
	taxonomy_table = "./input_tables/taxonomy.csv";
	gene_table = "./input_tables/gene.csv";
	function_table = "./input_tables/function.csv";
	reference_table = "./input_tables/reference.csv";
	sequence_table = "./input_tables/sequence.csv";
}



