-- MUST WRITE THE DATABASE DIRECTORY
\cd :dir

/* LEVEL O TABLES */
\COPY bio_process (bio_process_id, bio_process) FROM 'input_tables/bio_process.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
\COPY reference (reference_id, pubmed_id, doi, isbn, publi_date, journal, authors) FROM 'input_tables/reference.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
\COPY species (species_name, ncbi_tax_id, superkingdom, phylum, class, order_, full_lineage, full_lineage_ranks) FROM 'input_tables/species.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;

/* LEVEL 1 TABLES */
\COPY gene (species_name, gene_name, gene_id, db_gene_id, gene_coordinates, prot_id, db_prot_id) FROM 'input_tables/gene.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
\COPY signal (signal_id, signal_supercategory, signal_family, signal_trivial_name, signal_systematic_name, signal_chemical_formula, peptide_sequence, structure_img, signal_info, qs_system) FROM 'input_tables/signal.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;

/* LEVEL 2 TABLES */
\copy function (species_name, gene_name, bio_process_id, signal_id, function, info, retrieval_status, reference_id) FROM 'input_tables/function.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
\copy sequence (species_name, gene_name, seq_type, fa_path) FROM 'input_tables/sequence.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
