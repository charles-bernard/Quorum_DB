#!/bin/bash

echo 'Type in database name';
read -p"-> " db_name;

echo 'Type in user name';
read -p"-> " username;

# STEP 1
# RETRIEVE FA_PATH WHOSE CONTENT HAS TO BE INSERTED
WORK_DIR=`mktemp -d`
PSQL_OUT=$(mktemp "$WORK_DIR"/"XXXX");
psql -U $username -d $db_name \
	-c 'SELECT fa_path FROM sequence WHERE fa_seq IS NULL;' > "$PSQL_OUT";

LIST_FA=$(mktemp "$WORK_DIR"/"XXXX");
egrep '^.*\.fa(a)?(sta)?$' "$PSQL_OUT" | sed 's/ //g' > "$LIST_FA";
rm "$PSQL_OUT";

N=`awk 'END { print NR; }' "$LIST_FA"`;
for(( i=0; i<$N; i++ )); do
	CURR_FA=`awk -v i=$((i+1)) 'NR == i { print $0; }' "$LIST_FA"`
	COMMAND_SQL1="\set content \`cat "$CURR_FA"\`;";
	COMMAND_SQL2="UPDATE sequence SET fa_seq = :'content' WHERE sequence.fa_path = '"$CURR_FA"';";
	COMMAND_SQL="$COMMAND_SQL1"" \n ""$COMMAND_SQL2";
	printf "$COMMAND_SQL" | psql -U $username -d $db_name
done
