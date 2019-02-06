\prompt	'Type in the signal_id you want to display the sequences of \n-> ' QUERY_SIGNAL_ID

SELECT 
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
WHERE function.signal_id = :QUERY_SIGNAL_ID AND bio_process_id = 1
ORDER BY 
	array_position(
		ARRAY['synthase', 'modifier_transporter', 'receptor', 'response_regulator']::VARCHAR[], 
		function.function),
	function.gene_name, 
	sequence.seq_type;
