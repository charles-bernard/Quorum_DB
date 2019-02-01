#!/usr/local/bin/python3.5

import argparse
import subprocess
import os

parser = argparse.ArgumentParser(
    description='This script takes a input a template tabular file and partition '
                'its content into appropriate tables. In addition, for any sequence '
                'with an ID provided, it will fetch the sequence and place it in '
                'a dedicated directory within the specified output_dir')
parser.add_argument('-o', '--output_dir', dest="out_dir", type=str,
                    help='specify the path to the output directory where tables '
                         'and sequences will be stored')
parser.add_argument('-i', '--input_tab', dest="input_tab", type=str,
                    help='specify path to initial tab of format like '
                         'initial_table.template.csv')
args = parser.parse_args()

# Step 1
# partition initial tab to db tables
input_tables_dir = os.path.join(args.out_dir, "input_tables")
if not os.path.exists(input_tables_dir):
    os.makedirs(input_tables_dir)

subprocess.call(['awk', '-v', 'output_dir=' + input_tables_dir,
                 '-f', 'subscripts/0_init_tables.awk', args.input_tab])
subprocess.call(['python3', 'subscripts/1_fill_species.py', input_tables_dir])
subprocess.call(['bash', 'subscripts/2_substitute_taxid_by_taxname.sh',
                 input_tables_dir])
subprocess.call(['bash', 'subscripts/3_fetch_fasta_sequences_and_fill_sequence_table.sh',
                 args.out_dir])
