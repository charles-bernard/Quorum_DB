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
ASSEMBLY_DIR="$WORKING_DIR"/"sequences"/"publi_reference"/"assembly";
create_dir "$SEQ_CDS_DIR";
create_dir "$SEQ_PROT_DIR";
create_dir "$ASSEMBLY_DIR";

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
	if [[ "${GENE_COORD[$i]}" != "" ]]; then
		ASSEMBLY[$i]="$ASSEMBLY_DIR"/"${GENE_ID[$i]}""__""$STD_SPECIES_NAME"".fasta";
	else
		ASSEMBLY[$i]="";
	fi
	CDS_FA[$i]="$SEQ_CDS_DIR"/"${GENE_NAME[$i]}""__""$STD_SPECIES_NAME"".fasta";
	PROT_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $6; }' "$GENE_TABLE"`;
	DB_PROT_ID[$i]=`awk -F "\t" -v i=$((i+2)) 'NR == i { print $7; }' "$GENE_TABLE"`;
	PROT_FA[$i]="$SEQ_PROT_DIR"/"${GENE_NAME[$i]}""__""$STD_SPECIES_NAME"".fasta";
done

# FETCH SEQUENCES
function fetch_seq {
	local STDERR="$1";
	local SEQ_FASTA="$2";
	local SEQ_TYPE="$3";
	local SEQ_ID="$4";
	local SEQ_DB="$5";
	local SEQ_COORD="$6";
	local ASSEMBLY_FASTA="$7";
	local DOWNLOAD_ASSEMBLY="$8";
	> "$STDERR";
	
	# TO DO: Handle the case where cds is a concatenation
	# of several regions (Key letter "j" for join)
	# regions to be concanated together are separated with
	# "++" string
	
	# TO DO: enable downloading protein from uniprot


	if [ ! -f "$SEQ_FASTA" ]; then

		if [[ "$SEQ_TYPE" == "cds" ]]; then

			if [[ "$SEQ_DB" == "Nucleotide" ]]; then

				if [[ "$SEQ_COORD" != "" ]]; then

					if [[ "$DOWNLOAD_ASSEMBLY" == true ]]; then
						esearch -db nucleotide -query "$SEQ_ID" 2>>"$STDERR" \
						| efetch -format fasta > "$ASSEMBLY_FASTA" 2>>"$STDERR";

						if [ -s "$STDERR" ]; then
							echo "   * Unable to fetch the sequence (check internet connexion or ""$SEQ_TYPE"" id)";
							rm "$ASSEMBLY_FASTA";
							return;
						fi	
					fi

					if [ ! -f "$ASSEMBLY_FASTA" ]; then
						echo "   * Unable to fetch the sequence (check internet connexion or ""$SEQ_TYPE"" id)";
						echo "Assembly Not Available!" >> "$STDERR";
						return;
					fi			

					awk -v coord="$SEQ_COORD" -f "subscripts/3_substr_assembly.awk" "$ASSEMBLY_FASTA" > "$SEQ_FASTA";

				else

					esearch -db nucleotide -query "$SEQ_ID" 2>>"$STDERR" \
					| efetch -format fasta > "$SEQ_FASTA" 2>>"$STDERR";

				fi

			fi
		elif [[ "$SEQ_TYPE" == "protein" ]]; then

			if [[ "$SEQ_DB" == "Protein" ]]; then

				esearch -db protein -query "$SEQ_ID" 2>>"$STDERR" \
				| efetch -format fasta > "$SEQ_FASTA" 2>>"$STDERR";

			fi

		fi

		if [ -s "$STDERR" ]; then
			echo "   * Unable to fetch the sequence (check internet connexion or ""$SEQ_TYPE"" id)";
			rm "$SEQ_FASTA";
			return
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
				print $1 "\t" $2 "\t" $3 "\t" seq_fasta;
			}
		}' "$INPUT_SEQ_TABLE" >> "$OUTPUT_SEQ_TABLE";
}

declare -A ASSEMBLY_DICT
FETCH_STDERR=`mktemp`;

for(( i=0; i<$NB_GENES; i++ )); do
	echo "fetch entry n°""$((i+1))""/""$NB_GENES"": ""${GENE_NAME[$i]}"" gene" "[ ""${SPECIES_NAME[$i]}" "]";

	DOWNLOAD_ASSEMBLY=false;
	if [[ "${GENE_COORD[$i]}" != "" ]]; then
		if [[ "${ASSEMBLY_DICT[${GENE_ID[$i]}]}" == "" ]]; then
			DOWNLOAD_ASSEMBLY=true;
			ASSEMBLY_DICT[${GENE_ID[$i]}]=1;
		fi
	fi

	if [[ "${GENE_ID[$i]}" != "" ]]; then
		fetch_seq "$FETCH_STDERR" "${CDS_FA[$i]}" "cds" "${GENE_ID[$i]}" "${DB_GENE_ID[$i]}" \
			"${GENE_COORD[$i]}" "${ASSEMBLY[$i]}" "$DOWNLOAD_ASSEMBLY";
		if [ ! -s "$FETCH_STDERR" ]; then
			fill_seq "$INPUT_SEQ_TABLE" "$OUTPUT_SEQ_TABLE" \
			"${SPECIES_NAME[$i]}" "${GENE_NAME[$i]}" "cds" "${CDS_FA[$i]}";
		fi
	fi

	if [[ "${PROT_ID[$i]}" != "" ]]; then
		fetch_seq "$FETCH_STDERR" "${PROT_FA[$i]}" "protein" "${PROT_ID[$i]}" "${DB_PROT_ID[$i]}" "";
		if [ ! -s "$FETCH_STDERR" ]; then
			fill_seq "$INPUT_SEQ_TABLE" "$OUTPUT_SEQ_TABLE" \
			"${SPECIES_NAME[$i]}" "${GENE_NAME[$i]}" "protein" "${PROT_FA[$i]}";		
		fi
	fi
done

rm "$INPUT_SEQ_TABLE";
rm "$FETCH_STDERR";
rm -r "$ASSEMBLY_DIR";
