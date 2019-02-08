WITH unique_signal AS
	(SELECT 
		DISTINCT ON (species_name, signal_id) 
		species_name, signal_id
	FROM function
	WHERE bio_process_id = 1)
SELECT 
	DISTINCT ON (unique_signal.signal_id, qs_summary.genes)
	unique_signal.signal_id,
	qs_summary.species_name,
	qs_summary.genes,
	qs_summary.functions
FROM
	unique_signal
LEFT JOIN
	qs_summary
	ON unique_signal.signal_id = qs_summary.id
GROUP BY 
	unique_signal.signal_id, 
	qs_summary.species_name, 
	qs_summary.genes,
	qs_summary.functions
HAVING COUNT(unique_signal.signal_id) > 1
ORDER BY unique_signal.signal_id
