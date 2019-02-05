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

function signal_id_to_gene_sequences($dbconn, $query_signal_id) {
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

?>
