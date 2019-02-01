#!/bin/bash

# SETUP
WORKING_DIR="$1";
cd "$WORKING_DIR";


INPUT_SPECIES_TABLE="species.csv";
INPUT_GENE_TABLE="gene.csv";
INPUT_SEQ_TABLE="UNCOMPLETE_sequence.csv";
INPUT_FUNCTION_TABLE="function.csv";


mv "$INPUT_GENE_TABLE" "$INPUT_GENE_TABLE""_old";
mv "$INPUT_SEQ_TABLE" "$INPUT_SEQ_TABLE""_old";
mv "$INPUT_FUNCTION_TABLE" "$INPUT_FUNCTION_TABLE""_old";


awk -F "\t" \
	'BEGIN {
		out_gene_table="gene.csv";
		out_seq_table="UNCOMPLETE_sequence.csv";
		out_function_table="function.csv";

		file_index = 0;
	}

	FNR == 1 {
		file_index++;
	}

	file_index == 1 {
		tax_id = $2;
		species_name = $2;
		taxid_2_names[$2] = $1;
	}

	# gene
	file_index == 2 {
		outfile = out_gene_table;
	}
	# seq
	file_index == 3 {
		outfile = out_seq_table;
	}
	# function
	file_index == 4 {
		outfile = out_function_table;
	}

	file_index > 1 {
		if(FNR == 1) {
			curr_species_name= "species_name";
		} else {
			curr_species_name = taxid_2_names[$1];
		}
		line = curr_species_name;
		n = NF;
		for(i = 2; i <= n; i++) {
			line = line "\t" $i;
		}
		print line > outfile;
	}' \
	"$INPUT_SPECIES_TABLE" \
	"$INPUT_GENE_TABLE""_old" \
	"$INPUT_SEQ_TABLE""_old" \
	"$INPUT_FUNCTION_TABLE""_old"

rm "$INPUT_GENE_TABLE""_old"
rm "$INPUT_SEQ_TABLE""_old"
rm "$INPUT_FUNCTION_TABLE""_old"
