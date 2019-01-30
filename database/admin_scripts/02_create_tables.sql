/* LEVEL 0 TABLES */
CREATE TABLE bio_process (
	bio_process_id INT PRIMARY KEY,
	bio_process VARCHAR
);

CREATE TABLE domain (
	domain_id INT PRIMARY KEY,
	db_domain_id VARCHAR,
	domain_name VARCHAR
);

CREATE TABLE environment (
	env_id INT PRIMARY KEY,
	db_env_id VARCHAR,
	location VARCHAR,
	sampling_project VARCHAR,
	properties VARCHAR
);

CREATE TABLE omics (
	dataset_id INT PRIMARY KEY,
	omics_type VARCHAR
);

CREATE TABLE pathway (
	pathway_id INT PRIMARY KEY,
	db_pathway_id VARCHAR,
	pathway_name VARCHAR
);

CREATE TABLE reference (
	reference_id INT PRIMARY KEY,
	pubmed_id INT,
	isbn VARCHAR
);

CREATE TABLE signal (
	signal_id INT PRIMARY KEY,
	signal_supercategory VARCHAR,
	signal_family VARCHAR,
	signal_trivial_name VARCHAR,
	signal_systematic_name VARCHAR,
	signal_chemical_formula VARCHAR,
	structure_img BYTEA
);

CREATE TABLE taxonomy (
	tax_id VARCHAR PRIMARY KEY,
	ncbi_id INT,
	taxon_name VARCHAR,
	lineage VARCHAR,
	ranks VARCHAR 
);



/* LEVEL 1 TABLES */
CREATE TABLE analysed_taxons (
	dataset_id INT REFERENCES omics ON DELETE CASCADE ON UPDATE CASCADE,
	tax_id CHAR(30) REFERENCES taxonomy ON UPDATE CASCADE,
	PRIMARY KEY (dataset_id, tax_id)
);

CREATE TABLE environment_members (
	env_id INT REFERENCES environment ON DELETE CASCADE ON UPDATE CASCADE,
	tax_id CHAR(30) REFERENCES taxonomy ON UPDATE CASCADE,
	PRIMARY KEY (env_id, tax_id)
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


CREATE TABLE ref_signal (
	reference_id INT REFERENCES reference ON DELETE CASCADE ON UPDATE CASCADE,
	signal_id INT REFERENCES signal ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (reference_id, signal_id)
);

CREATE TABLE ref_omics (
	reference_id INT REFERENCES reference ON DELETE CASCADE ON UPDATE CASCADE,
	dataset_id INT REFERENCES omics ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (reference_id, dataset_id)
);


/* LEVEL 2 TABLES */
CREATE TABLE composite_gene (
	domain_id INT,
	tax_id VARCHAR,
	gene_name VARCHAR,
	domain_order INT,
	FOREIGN KEY (domain_id) REFERENCES domain(domain_id),
	FOREIGN KEY (tax_id, gene_name) REFERENCES gene (tax_id, gene_name),
	PRIMARY KEY(domain_id, tax_id, gene_name)
);

CREATE TABLE pathway_genes (
	pathway_id INT REFERENCES pathway ON DELETE CASCADE ON UPDATE CASCADE,
	tax_id VARCHAR REFERENCES taxonomy ON DELETE CASCADE ON UPDATE CASCADE,
	pathway_name VARCHAR,
	PRIMARY KEY(pathway_id, tax_id)
);
