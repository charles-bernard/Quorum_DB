/* LEVEL 0 TABLES */

CREATE TABLE taxonomy (
	tax_id INT PRIMARY KEY,
	is_NCBI BOOLEAN NOT NULL,
	taxon_name VARCHAR,
	lineage VARCHAR,
	ranks VARCHAR 
)

