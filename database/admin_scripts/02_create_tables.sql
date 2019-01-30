/* LEVEL 0 TABLES */
CREATE TABLE bio_process (
	bio_process_id SERIAL PRIMARY KEY,
	bio_process VARCHAR NOT NULL
);

CREATE TABLE domain (
	domain_id SERIAL PRIMARY KEY,
	db_domain_id VARCHAR,
	domain_name VARCHAR NOT NULL
);

CREATE TABLE pathway (
	pathway_id SERIAL PRIMARY KEY,
	db_pathway_id VARCHAR,
	pathway_name VARCHAR
);

CREATE TABLE reference (
	reference_id SERIAL PRIMARY KEY,
	pubmed_id INT,
	doi VARCHAR,
	isbn VARCHAR
);

CREATE TABLE taxonomy (
	tax_id VARCHAR PRIMARY KEY,
	ncbi_id INT,
	taxon_name VARCHAR,
	rank VARCHAR,
	lineage VARCHAR,
	lineage_ranks VARCHAR
);


/* LEVEL 1 TABLES */
CREATE TABLE bio_process_pathways (
	bio_process_id INT REFERENCES bio_process ON DELETE CASCADE ON UPDATE CASCADE,
	pathway_id INT REFERENCES pathway ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (bio_process_id, pathway_id)

);

CREATE TABLE environment (
	env_id SERIAL PRIMARY KEY,
	location VARCHAR,
	sampling_project VARCHAR,
	properties VARCHAR,
	reference_id INT REFERENCES reference ON UPDATE CASCADE
);

CREATE TABLE gene (
	tax_id VARCHAR REFERENCES taxonomy ON UPDATE CASCADE,
	gene_name VARCHAR,
	gene_id VARCHAR,
	db_gene_id VARCHAR,
	gene_coordinates VARCHAR,
	prot_id VARCHAR,
	db_prot_id VARCHAR,
	putative_age VARCHAR,
	horizontally_transferred BOOLEAN,
	PRIMARY KEY (tax_id, gene_name),
	UNIQUE (tax_id, gene_name)
);

CREATE TABLE omics (
	dataset_id INT PRIMARY KEY,
	omics_type VARCHAR,
	reference INT REFERENCES reference ON UPDATE CASCADE
);

CREATE TABLE signal (
	signal_id SERIAL PRIMARY KEY,
	signal_supercategory VARCHAR NOT NULL,
	signal_family VARCHAR,
	signal_trivial_name VARCHAR,
	signal_systematic_name VARCHAR,
	signal_chemical_formula VARCHAR,
	reference_id INT REFERENCES reference ON UPDATE CASCADE,
	structure_img BYTEA
);


/* LEVEL 2 TABLES */
CREATE TABLE analysed_taxons (
	dataset_id INT REFERENCES omics ON DELETE CASCADE ON UPDATE CASCADE,
	tax_id CHAR(30) REFERENCES taxonomy ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (dataset_id, tax_id)
);

CREATE TABLE composite_gene (
	domain_id INT,
	tax_id VARCHAR,
	gene_name VARCHAR,
	domain_order INT,
	FOREIGN KEY (domain_id) REFERENCES domain (domain_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (tax_id, gene_name) REFERENCES gene (tax_id, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(domain_id, tax_id, gene_name)
);

CREATE TABLE environment_members (
	env_id INT REFERENCES environment ON DELETE CASCADE ON UPDATE CASCADE,
	tax_id CHAR(30) REFERENCES taxonomy ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (env_id, tax_id)
);

CREATE TABLE function (
	tax_id VARCHAR,
	gene_name VARCHAR,
	bio_process_id INT,
	function VARCHAR,
	reference_id INT REFERENCES reference ON UPDATE CASCADE,
	FOREIGN KEY (tax_id, gene_name) REFERENCES gene (tax_id, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (bio_process_id) REFERENCES bio_process (bio_process_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (tax_id, gene_name, bio_process_id, function)
);

CREATE TABLE pathway_genes (
	pathway_id INT,
	tax_id VARCHAR,
	gene_name VARCHAR,
	pathway_name VARCHAR,
	FOREIGN KEY (pathway_id) REFERENCES pathway (pathway_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (tax_id, gene_name) REFERENCES gene (tax_id, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(pathway_id, tax_id, gene_name)
);

CREATE TABLE sequence (
	tax_id INT,
	gene_name VARCHAR,
	seq_type VARCHAR,
	fa_path VARCHAR NOT NULL,
	fa_seq TEXT NOT NULL,
	FOREIGN KEY (tax_id, gene_name) REFERENCES gene (tax_id, gene_name) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (tax_id, gene_name, seq_type)
);
