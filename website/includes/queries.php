<?php

function list_all_signal_families($dbconn) {
	$results = pg_query($dbconn, 
		"WITH hsl_signal AS
			(SELECT DISTINCT ON (signal_supercategory, signal_family, signal_trivial_name)
				signal_supercategory,
				signal_family,
				signal_trivial_name AS \"hsl_subfamily\"
			FROM signal
			WHERE signal_trivial_name ~ 'HSL')
		SELECT DISTINCT ON (signal.signal_supercategory, signal.signal_family, hsl_signal.hsl_subfamily)
			signal.signal_supercategory,
			signal.signal_family,
			hsl_signal.hsl_subfamily
		FROM signal
			LEFT JOIN hsl_signal
			ON 
				signal.signal_trivial_name = hsl_signal.hsl_subfamily
		WHERE signal.signal_id != 0
		ORDER BY signal.signal_supercategory, signal.signal_family, hsl_signal.hsl_subfamily");

	return $results;
}

function list_interspecies_qs($dbconn) {
	$results = pg_query($dbconn,
		"WITH unique_signal AS
			(SELECT 
				DISTINCT ON (species_name, signal_id) 
				species_name, signal_id
		FROM function
		WHERE bio_process_id = 1)
		SELECT 
			-- DISTINCT ON (unique_signal.signal_id, qs_summary.genes)
			unique_signal.signal_id,
			qs_summary.species_name,
			qs_summary.genes,
			qs_summary.functions
		FROM unique_signal
			LEFT JOIN qs_summary
			ON
				unique_signal.signal_id = qs_summary.id
		GROUP BY 
			unique_signal.signal_id, 
			qs_summary.species_name, 
			qs_summary.genes,
			qs_summary.functions
		HAVING COUNT(unique_signal.signal_id) > 1
		ORDER BY unique_signal.signal_id");

	return $results;
}

function list_orphan_module($dbconn, $query) {
	if($query == "synthase") {
		$target = "receptor";
	} else {
		$target = "synthase";
	}
	$results = pg_query($dbconn,
		"WITH {$query} AS
			(SELECT 
				function.signal_id,
				function.species_name,
				function.function
			FROM function
				LEFT JOIN gene
				ON (function.gene_name = gene.gene_name AND function.species_name = gene.species_name)
			WHERE
				function.bio_process_id = 1 
				AND function.reference_id = 0
				AND function.function = '{$query}'
				AND (gene.gene_id IS NOT NULL OR gene.prot_id IS NOT NULL)),
		{$target} AS
			(SELECT 
				function.signal_id,
				function.species_name,
				function.function
			FROM function
				LEFT JOIN gene
				ON (function.gene_name = gene.gene_name AND function.species_name = gene.species_name)
			WHERE
				function.bio_process_id = 1 
				AND reference_id = 0
				AND function.function = '{$target}'
				AND (gene.gene_id IS NOT NULL OR gene.prot_id IS NOT NULL))
		SELECT 
			DISTINCT ON(qs_summary.id, qs_summary.species_name)
			qs_summary.id,
			qs_summary.species_name,
			qs_summary.genes,
			qs_summary.functions
		FROM {$query}
			LEFT OUTER JOIN {$target}
				ON ({$query}.signal_id = {$target}.signal_id
				AND {$query}.species_name = {$target}.species_name)
			LEFT JOIN qs_summary
				ON ({$query}.signal_id = qs_summary.id
				AND {$query}.species_name = qs_summary.species_name)
		WHERE 
			{$target}.function IS NULL
		GROUP BY 
			qs_summary.id,
			qs_summary.species_name,
			qs_summary.genes,
			qs_summary.functions");
	return $results;
}

function signal_id_2_seq($dbconn, $query_signal_id) {
	$results = pg_query($dbconn, 
		"SELECT 
			function.species_name, 
			function.gene_name,
			function.function,
			gene.gene_id AS \"gene/assembly_id\",
			gene.gene_coordinates,
			sequence.seq_type,
			sequence.fa_path 
		FROM 
			function
			LEFT JOIN sequence 
			ON
				(function.gene_name = sequence.gene_name
				AND function.species_name = sequence.species_name)
			LEFT JOIN gene
			ON
				(function.gene_name = gene.gene_name
				AND function.species_name = gene.species_name)
		WHERE function.signal_id = '{$query_signal_id}' 
		AND bio_process_id = 1
		AND reference_id != 0
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
			reference.doi,
			reference.publi_date,
			reference.journal,
			reference.authors
		FROM
			reference
		LEFT JOIN function
		ON
			function.reference_id = reference.reference_id
		WHERE
			bio_process_id = 1 
			AND reference.reference_id != 0
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
			bio_process.bio_process,
			function.species_name AS \"in\"
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
