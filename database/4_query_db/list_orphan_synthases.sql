WITH synthase AS
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
		AND function.function = 'synthase'
		AND (gene.gene_id IS NOT NULL OR gene.prot_id IS NOT NULL)),
receptor AS
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
		AND function.function = 'receptor'
		AND (gene.gene_id IS NOT NULL OR gene.prot_id IS NOT NULL))
SELECT 
	DISTINCT ON(qs_summary.id, qs_summary.species_name)
	qs_summary.id,
	qs_summary.species_name,
	qs_summary.genes,
	qs_summary.functions
FROM synthase
	LEFT OUTER JOIN receptor
	ON (synthase.signal_id = receptor.signal_id
		AND synthase.species_name = receptor.species_name)
	LEFT JOIN qs_summary
	ON (synthase.signal_id = qs_summary.id
		AND synthase.species_name = qs_summary.species_name)
WHERE receptor.function IS NULL
GROUP BY 
	qs_summary.id,
	qs_summary.species_name,
	qs_summary.genes,
	qs_summary.functions;
