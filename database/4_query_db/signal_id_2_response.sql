\prompt	'Type in the signal_id you want to display the sequences of \n-> ' QUERY_SIGNAL_ID

SELECT DISTINCT ON (bio_process.bio_process_id)
	bio_process.bio_process_id,
	bio_process.bio_process,
	function.species_name AS "in"
FROM
	bio_process
	LEFT JOIN
		function
	ON
		bio_process.bio_process_id = function.bio_process_id
WHERE
	function.bio_process_id != 1
	AND function.signal_id = :QUERY_SIGNAL_ID
