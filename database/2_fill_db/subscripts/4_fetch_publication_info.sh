#!/bin/bash

# SETUP
WORKING_DIR="$1";
cd "$WORKING_DIR";

INPUT_REF_TABLE="UNCOMPLETE_reference.csv";
OUTPUT_REF_TABLE="reference.csv";
MEDLINE_FILE=`mktemp`;
printf "reference_id\tpubmed_id\tdoi\tisbn\tpubli_date\tjournal\tauthors\n" > "$OUTPUT_REF_TABLE";

NB_REF=`awk 'END { print NR-1; }' "$INPUT_REF_TABLE"`;
echo "FETCH PUBLICATION INFORMATIONS";

for(( i=0; i<$NB_REF; i++ )); do 
	REF_ID[$i]=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $1; }' "$INPUT_REF_TABLE"`;
	PUBMID[$i]=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $2; }' "$INPUT_REF_TABLE"`;
	DOI[$i]=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $3; }' "$INPUT_REF_TABLE"`;
	echo "fetch entry n°""$((i+1))""/""$NB_REF"": PUBMID ""${PUBMID[$i]}";
	if [[ "${PUBMID[$i]}" != "" ]]; then
		esearch -db pubmed -query ${PUBMID[$i]} | efetch -format medline > "$MEDLINE_FILE";
		awk -F "- " -v ref="${REF_ID[$i]}" -v pubmid="${PUBMID[$i]}" '
			BEGIN {
				a = 0;
			}
			$1 ~ /^AU / {
				if(a == 0) {
					authors = $2
				} else {
					authors = authors " ; " $2;
				}
				a++;
			}
			$1 ~ /^JT/ {
				journal = $2;
			}
			$1 ~ /^LID/ {
				doi = $2;
			}
			$1 ~ /^DP/ {
				publi_date = $2;
			}
			END {
				print ref "\t" pubmid "\t" doi "\t\t" publi_date "\t" journal "\t" authors
			}' "$MEDLINE_FILE" >> "$OUTPUT_REF_TABLE";
	else
		printf "${REF_ID[$i]}""\t\t""${DOI[$i]}""\t\t\t\t\n" >> "$OUTPUT_REF_TABLE";
	fi
done

rm "$MEDLINE_FILE";
rm "$INPUT_REF_TABLE";
