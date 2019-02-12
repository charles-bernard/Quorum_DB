#!/bin/bash

# SETUP
WORKING_DIR="$1";
cd "$WORKING_DIR";

INPUT_SIGNAL_TABLE="UNCOMPLETE_signal.csv";
OUTPUT_SIGNAL_TABLE="signal.csv";
awk 'NR == 1 {print $0 "\tstructure_img";}' "$INPUT_SIGNAL_TABLE" > "$OUTPUT_SIGNAL_TABLE";

IMG_DIR=`dirname "$WORKING_DIR"/"$INPUT_SIGNAL_TABLE"`/".."/"img";
mkdir -p "$IMG_DIR";

echo "$IMG_DIR"

NB_SIGNAL=`awk 'END { print NR-1; }' "$INPUT_SIGNAL_TABLE"`;
echo "CONVERT SMILES TO IMG";

for(( i=0; i<$NB_SIGNAL; i++ )); do 
	SIGNAL_ID=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $1; }' "$INPUT_SIGNAL_TABLE"`;
	SMILES=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $6; }' "$INPUT_SIGNAL_TABLE"`;
	QS=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $9; }' "$INPUT_SIGNAL_TABLE"`;
	PREFIX=`awk -v i=$((i+2)) -F "\t" 'NR == i { print $0; }' "$INPUT_SIGNAL_TABLE"`;
	echo "produce structure image of entry n°""$((i+1))""/""$NB_SIGNAL"": ""$QS";
	if [[ "$SMILES" != "" ]]; then
		IMG="$IMG_DIR""/""$SIGNAL_ID"".svg";
		obabel -:"$SMILES" -O "$IMG";
		echo "$IMG"
	else
		IMG="";
	fi
	LINE="$PREFIX""\t""$IMG";
	printf "$LINE""\n" >> "$OUTPUT_SIGNAL_TABLE";
done

rm "$INPUT_SIGNAL_TABLE";
