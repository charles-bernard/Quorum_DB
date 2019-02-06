\prompt	'Type in the signal_id you want to display the sequences of \n-> ' QUERY_SIGNAL_ID

SELECT DISTINCT ON (reference.reference_id)
	reference.reference_id,
	reference.pubmed_id,
	reference.doi
FROM
	reference
LEFT JOIN
	function
ON
	function.reference_id = reference.reference_id
WHERE
	bio_process_id = 1
	AND signal_id = :QUERY_SIGNAL_ID
