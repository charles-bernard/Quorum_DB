<?php

function list_all_signal_families($dbconn) {
	$results = pg_query($dbconn,
		"SELECT 
			DISTINCT ON (signal_supercategory, signal_family)
			signal_supercategory,
			signal_family
		FROM signal
		WHERE signal_id != 0
		ORDER BY signal_supercategory");

	return $results;
}

function signal_id_2_seq($dbconn, $query_signal_id) {
	$results = pg_query($dbconn, 
		"SELECT 
			function.species_name, 
			function.gene_name,
			function.function,
			sequence.seq_type,
			sequence.fa_seq 
		FROM 
			function
			LEFT JOIN sequence 
			ON
				function.gene_name = sequence.gene_name
				AND function.species_name = sequence.species_name 
		WHERE function.signal_id = '{$query_signal_id}' AND bio_process_id = 1
		ORDER BY 
			array_position(
			ARRAY['synthase', 'modifier_transporter', 'receptor', 'response_regulator']::VARCHAR[], 
			function.function),
			function.gene_name, 
			sequence.seq_type");

	return $results;
}

function signal_id_2_ref($dbconn, $query_signal_id) {
	$results = pg_query($dbconn, 
		"SELECT DISTINCT ON (reference.reference_id)
			reference.reference_id,
			reference.pubmed_id,
			reference.doi
		FROM
			reference
		LEFT JOIN function
		ON
			function.reference_id = reference.reference_id
		WHERE
			bio_process_id = 1
			AND signal_id = '{$query_signal_id}'");

	return $results;
}

function signal_id_2_species($dbconn, $query_signal_id) {
	$results = pg_query($dbconn,
		"SELECT DISTINCT ON (species.species_name)
			species.superkingdom,
			species.phylum,
			species.class,
			species.order_,
			species.species_name,
			species.ncbi_tax_id,
			species.full_lineage,
			species.full_lineage_ranks
		FROM
			species
		LEFT JOIN function
		ON
		species.species_name = function.species_name
		WHERE
			bio_process_id = 1
			AND signal_id = '{$query_signal_id}'");

	return $results;
}

function signal_id_2_response($dbconn, $query_signal_id) {
	$results = pg_query($dbconn,
		"SELECT DISTINCT ON (bio_process.bio_process_id)
			bio_process.bio_process_id,
			bio_process.bio_process
		FROM
			bio_process
		LEFT JOIN function
		ON
		bio_process.bio_process_id = function.bio_process_id
		WHERE
			function.bio_process_id != 1
			AND function.signal_id = '{$query_signal_id}'");

	return $results;
}


?>
