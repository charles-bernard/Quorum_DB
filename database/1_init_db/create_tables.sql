/* LEVEL 0 TABLES */
CREATE TABLE bio_process (
	bio_process_id SERIAL PRIMARY KEY,
	bio_process VARCHAR NOT NULL,
	UNIQUE (bio_process)
);

-- FOR FUTURE ANALYSES
CREATE TABLE domain (
	interpro_id VARCHAR PRIMARY KEY,
	domain_name VARCHAR NOT NULL
);

-- FOR JEROME
CREATE TABLE pathway (
	pathway_id SERIAL PRIMARY KEY,
	pathway_name VARCHAR,
	db_pathway_id VARCHAR,
	db_name VARCHAR
);

CREATE TABLE reference (
	reference_id SERIAL PRIMARY KEY,
	pubmed_id INT,
	doi VARCHAR,
	isbn VARCHAR,
	publi_date VARCHAR,
	journal VARCHAR,
	authors TEXT
);

CREATE TABLE species (
	species_name VARCHAR PRIMARY KEY,
	ncbi_tax_id INT,
	superkingdom VARCHAR,
	phylum VARCHAR,
	class VARCHAR,
	order_ VARCHAR,
	full_lineage VARCHAR,
	full_lineage_ranks VARCHAR
);


/* LEVEL 1 TABLES */
-- FOR JEROME
CREATE TABLE bio_process_pathways (
	bio_process_id INT REFERENCES bio_process ON DELETE CASCADE ON UPDATE CASCADE,
	pathway_id INT REFERENCES pathway ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (bio_process_id, pathway_id)
);

-- FOR FUTURE ANALYSES
CREATE TABLE environment (
	env_id SERIAL PRIMARY KEY,
	location VARCHAR,
	sampling_project VARCHAR,
	reference_id INT REFERENCES reference ON UPDATE CASCADE
);

CREATE TABLE gene (
	species_name VARCHAR REFERENCES species ON UPDATE CASCADE,
	gene_name VARCHAR,
	prot_id VARCHAR,
	db_prot_id VARCHAR,
	gene_id VARCHAR,
	db_gene_id VARCHAR,
	gene_coordinates VARCHAR,
	PRIMARY KEY (species_name, gene_name),
	UNIQUE (species_name, gene_name)
);

-- FOR JEROME
CREATE TABLE omics (
	dataset_id INT PRIMARY KEY,
	omics_type VARCHAR,
	reference INT REFERENCES reference ON UPDATE CASCADE
);

CREATE TABLE signal (
	signal_id SERIAL PRIMARY KEY,
	signal_supercategory VARCHAR,
	CHECK (
		(signal_supercategory='autoinducer peptide') or
		(signal_supercategory='quorum sensing molecule')),
	signal_family VARCHAR,
	signal_trivial_name VARCHAR,
	qs_system VARCHAR,
	structure_img VARCHAR,
	peptide_sequence VARCHAR,
	signal_systematic_name VARCHAR,
	signal_info TEXT,
	quorum_peps_id VARCHAR,
	sigmol_id VARCHAR,
	smiles VARCHAR
		
);


/* LEVEL 2 TABLES */
-- FOR JEROME
CREATE TABLE analysed_taxons (
	dataset_id INT REFERENCES omics ON DELETE CASCADE ON UPDATE CASCADE,
	species_name CHAR(30) REFERENCES species ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (dataset_id, species_name)
);

-- FOR FUTURE ANALYSES
CREATE TABLE composite_gene (
	interpro_id VARCHAR,
	species_name VARCHAR,
	gene_name VARCHAR,
	domain_order INT,
	FOREIGN KEY (interpro_id) REFERENCES domain (interpro_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (species_name, gene_name) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(interpro_id, species_name, gene_name)
);

-- FOR FUTURE ANALYSES
CREATE TABLE environment_community (
	env_id INT REFERENCES environment ON DELETE CASCADE ON UPDATE CASCADE,
	species_name CHAR(30) REFERENCES species ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (env_id, species_name)
);

CREATE TABLE environment_properties (
	env_id INT REFERENCES environment ON DELETE CASCADE ON UPDATE CASCADE,
	env_property VARCHAR,
	PRIMARY KEY (env_id, env_property)
);

CREATE TABLE function (
	species_name VARCHAR,
	gene_name VARCHAR,
	bio_process_id INT,
	signal_id INT,
	function VARCHAR,
	info VARCHAR,
	retrieval_status VARCHAR CHECK (
		(retrieval_status='publi_reference') or 
		(retrieval_status='env_reference') or
		(retrieval_status='publi_homolog') or
		(retrieval_status='env_homolog')),
	reference_id INT REFERENCES reference ON UPDATE CASCADE,
	FOREIGN KEY (species_name, gene_name) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (bio_process_id) REFERENCES bio_process (bio_process_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (signal_id) REFERENCES signal(signal_id) ON UPDATE CASCADE,
	PRIMARY KEY (species_name, gene_name, bio_process_id, signal_id, function, retrieval_status, reference_id)
);

-- FOR FUTURE ANALYSES
CREATE TABLE gene_history (
	species_name VARCHAR,
	gene_name VARCHAR,
	under_selection BOOLEAN,
	transfered BOOLEAN,
	composite BOOLEAN,
	nb_dupli INT,
	quali_putative_age VARCHAR,
	quanti_patative_age VARCHAR,
	FOREIGN KEY (species_name, gene_name) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE
);

-- FOR JEROME
CREATE TABLE pathway_genes (
	pathway_id INT,
	species_name VARCHAR,
	gene_name VARCHAR,
	pathway_name VARCHAR,
	FOREIGN KEY (pathway_id) REFERENCES pathway (pathway_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (species_name, gene_name) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(pathway_id, species_name, gene_name)
);

CREATE TABLE regulated_by (
	target_species VARCHAR,
	target_gene VARCHAR,
	regulator_species VARCHAR,
	regulator_gene VARCHAR,
	regulation_type VARCHAR CHECK (
		(regulation_type='positive') or
		(regulation_type='negative')),
	FOREIGN KEY (target_species, target_gene) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (regulator_species, regulator_gene) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (target_species, target_gene, regulator_species, regulator_gene)
);

CREATE TABLE sequence (
	species_name VARCHAR,
	gene_name VARCHAR,
	seq_type VARCHAR,
	fa_path VARCHAR NOT NULL,
	fa_seq TEXT,
	FOREIGN KEY (species_name, gene_name) REFERENCES gene (species_name, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (species_name, gene_name, seq_type)
);

