\prompt	'Type in the signal_id you want to display the sequences of \n-> ' QUERY_SIGNAL_ID

SELECT DISTINCT ON (species.species_name)
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
LEFT JOIN
	function
ON
	species.species_name = function.species_name
WHERE
	bio_process_id = 1
	AND signal_id = :QUERY_SIGNAL_ID
