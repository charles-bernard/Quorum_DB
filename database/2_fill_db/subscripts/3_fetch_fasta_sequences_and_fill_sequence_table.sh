#!/bin/bash

# SETUP
WORKING_DIR="$1";

function create_dir {
	local DIR=$1;
	if [ ! -d "$DIR" ]; then
		mkdir -p "$DIR";
	fi
}
SEQ_CDS_DIR="$WORKING_DIR"/"sequences"/"publi_reference"/"cds";
SEQ_PROT_DIR="$WORKING_DIR"/"sequences"/"publi_reference"/"proteins";
create_dir "$SEQ_CDS_DIR";
create_dir "$SEQ_PROT_DIR";

function check_file {
	local FILE="$1";
	if [ ! -f "$FILE" ]; then
		echo "Error: The file \"$FILE\" does not exist!";
		exit
	fi
}
GENE_TABLE="$WORKING_DIR"/"input_tables"/"gene.csv";
INPUT_SEQ_TABLE="$WORKING_DIR"/"input_tables"/"UNCOMPLETE_sequence.csv";
OUTPUT_SEQ_TABLE="$WORKING_DIR"/"input_tables"/"sequence.csv";
awk 'NR == 1 { print $0 "\t" "fa_path"; }' "$INPUT_SEQ_TABLE" > "$OUTPUT_SEQ_TABLE";
check_file "$GENE_TABLE"; 
check_file "$INPUT_SEQ_TABLE";


# GET PRIMARY KEY OF GENES (tax_id + gene_name)
# AND ALL OTHER INFO TO FETCH THE SEQUENCE
NB_GENES=`awk 'END { print NR-1; }' "$GENE_TABLE"`;
for(( i=0; i<$NB_GENES; i++ )); do
	SPECIES_NAME[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $1; }' "$GENE_TABLE"`;
	GENE_NAME[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $2; }' "$GENE_TABLE"`;
	STD_SPECIES_NAME=`echo "${SPECIES_NAME[$i]}" | sed 's/[^A-Za-z0-9]\+/_/g; s/_$//'`;
	GENE_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $3; }' "$GENE_TABLE"`;
	DB_GENE_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $4; }' "$GENE_TABLE"`;
	GENE_COORD[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $5; }' "$GENE_TABLE"`;
	CDS_FA[$i]="$SEQ_CDS_DIR"/"${GENE_NAME[$i]}""__""$STD_SPECIES_NAME"".fasta";
	PROT_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $6; }' "$GENE_TABLE"`;
	DB_PROT_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $7; }' "$GENE_TABLE"`;
	PROT_FA[$i]="$SEQ_PROT_DIR"/"${GENE_NAME[$i]}""__""$STD_SPECIES_NAME"".fasta";
done

# FETCH SEQUENCES
function fetch_seq {
	local SEQ_FASTA="$1";
	local SEQ_TYPE="$2";
	local SEQ_ID="$3";
	local SEQ_DB="$4";
	local SEQ_COORD="$5";

	if [ ! -f "$SEQ_FASTA" ]; then

		if [[ "$SEQ_TYPE" == "cds" ]]; then

			if [[ "$SEQ_DB" == "Nucleotide" ]]; then

				esearch -db nucleotide -query "$SEQ_ID" \
				| efetch -format fasta > "$SEQ_FASTA";

				if [[ "$SEQ_COORD" != "" ]]; then

					START=`echo "$SEQ_COORD" | awk -F "__" '{ print $1; }'`;
					END=`echo "$SEQ_COORD" | awk -F "__" '{ print $2; }'`;

					awk -v start=$START -v end=$END '
						BEGIN { l = 70; }

						# print header
						NR == 1 { print $0 " (" start "-" end ")"; }

						# concatenate genome or whatsoever sequence
						NR > 1 { s = s $0; }

						# substr portion of interest and print it as fasta
						END { 
							seq = substr(s, start, end-start+1);
							for(k = 1; k < end-start+1; k += l) {
								print substr(seq, k, l);
							}
						}
					' "$SEQ_FASTA" > "$SEQ_FASTA""_tmp";

					mv "$SEQ_FASTA""_tmp" "$SEQ_FASTA";

				fi
			fi
		elif [[ "$SEQ_TYPE" == "protein" ]]; then

			if [[ "$SEQ_DB" == "Protein" ]]; then

				esearch -db protein -query "$SEQ_ID" \
				| efetch -format fasta > "$SEQ_FASTA";

			fi

		fi
	fi
}

# FILL SEQUENCE TABLE
function fill_seq {
	local INPUT_SEQ_TABLE="$1";
	local OUTPUT_SEQ_TABLE="$2";
	local SPECIES_NAME="$3";
	local GENE_NAME="$4";
	local SEQ_TYPE="$5";
	local SEQ_FASTA="$6";

	awk -F "\t" \
		-v species_name="$SPECIES_NAME" \
		-v gene_name="$GENE_NAME" \
		-v seq_type="$SEQ_TYPE" \
		-v seq_fasta="$SEQ_FASTA" \ '

		NR > 1 {
			if($1 == species_name && $2 == gene_name && $3 == seq_type) {
				print $1 "\t" $2 "\t" $3 "\t" seq_fasta "\t" fa_content;
			}
		}' "$INPUT_SEQ_TABLE" >> "$OUTPUT_SEQ_TABLE";
}


for(( i=0; i<$NB_GENES; i++ )); do
	echo -ne "fetch entry n°""$((i+1))""/""$NB_GENES"": ""${GENE_NAME[$i]}"" gene" \\r

	if [[ "${GENE_ID[$i]}" != "" ]]; then
		fetch_seq "${CDS_FA[$i]}" "cds" "${GENE_ID[$i]}" "${DB_GENE_ID[$i]}" "${GENE_COORD[$i]}";
		fill_seq "$INPUT_SEQ_TABLE" "$OUTPUT_SEQ_TABLE" \
		"${SPECIES_NAME[$i]}" "${GENE_NAME[$i]}" "cds" "${CDS_FA[$i]}";
	fi

	if [[ "${PROT_ID[$i]}" != "" ]]; then
		fetch_seq "${PROT_FA[$i]}" "protein" "${PROT_ID[$i]}" "${DB_PROT_ID[$i]}" "";
		fill_seq "$INPUT_SEQ_TABLE" "$OUTPUT_SEQ_TABLE" \
		"${SPECIES_NAME[$i]}" "${GENE_NAME[$i]}" "protein" "${PROT_FA[$i]}";
	fi
done

rm "$INPUT_SEQ_TABLE";
