#!/usr/bin/env python
# -*- coding: utf-8 -*-

from ete3 import *
import os
ncbi = NCBITaxa()


input_species_table = "./input_tables/UNCOMPLETE_species.csv"
output_species_table = "./input_tables/species.csv"
header = "species_name\tncbi_tax_id\trank\tlineage\tlineage_ranks"
line = list()
with open(input_species_table, "r") as f:
    next(f)
    for entry in f:
        taxon = entry.strip()
        try:
            # if taxon is an integer, then it might be a taxonomic id
            int(taxon)
            try:
                # if species entry is indeed a taxonomic id
                # use it to retrieve the species name
                species_name = list(ncbi.get_taxid_translator([taxon]).values())[0]
                ncbi_tax_id = taxon
            except:
                species_name = taxon
                ncbi_tax_id = ''
        except:
            # if taxon is a string, then it might be a species name
            try:
                translated_name = list(ncbi.get_name_translator([taxon]).values())
                species_name = taxon
                ncbi_tax_id = (translated_name[0][0])
            except:
                species_name = taxon
                ncbi_tax_id = ''
        # Use tax id to retrieve lineage and ranks
        if ncbi_tax_id:
            lineage_list = ncbi.get_lineage(ncbi_tax_id)
            lineage_ranks_dict = ncbi.get_rank(lineage_list)
            lineage = list(ncbi.get_taxid_translator([lineage_list[0]]).values())[0]
            lineage_ranks = lineage_ranks_dict[lineage_list[0]]
            for i in range(1, len(lineage_list)):
                curr_taxid = lineage_list[i]
                curr_name = list(ncbi.get_taxid_translator([curr_taxid]).values())[0]
                curr_rank = lineage_ranks_dict[curr_taxid]
                lineage = lineage + "; " + curr_name
                lineage_ranks = lineage_ranks + "; " + curr_rank
            rank = curr_rank
        else:
            lineage = ''
            lineage_ranks = ''
            rank = ''
        line.append(species_name + "\t" + ncbi_tax_id + "\t" + rank + "\t" + lineage + "\t" + lineage_ranks)
    f.close()


with open(output_species_table, "w") as f:
    _ = f.write("%s\n" % header)
    for i in range(0, len(line)):
        _ = f.write("%s\n" % line[i])
    f.close()


# os.remove(input_species_table)
