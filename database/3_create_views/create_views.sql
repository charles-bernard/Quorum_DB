DROP VIEW qs_summary;
CREATE VIEW qs_summary AS
	WITH qs_unsorted_summary AS
		(WITH response AS
			(SELECT 
				function.signal_id,
				string_agg(DISTINCT bio_process, E'\n') AS response
			FROM function
				LEFT JOIN bio_process
				ON function.bio_process_id = bio_process.bio_process_id
			WHERE bio_process.bio_process_id != 1
				AND function.signal_id != 0
			GROUP BY function.signal_id)
		SELECT
			DISTINCT ON (function.species_name, function.signal_id, genes)
			function.signal_id AS "id",
			species.superkingdom,
			species.phylum,
			function.species_name,
			signal.signal_supercategory,
			signal.signal_family,
			signal.signal_trivial_name,
			string_agg(function.gene_name, E'\n') AS "genes",
			string_agg(function.function, E'\n') AS "functions",
			response.response
		FROM function
			LEFT JOIN response
				ON function.signal_id = response.signal_id
			LEFT JOIN species
				ON function.species_name = species.species_name
			RIGHT JOIN signal
				ON function.signal_id = signal.signal_id
		WHERE 
			function.signal_id != 0 AND 
			function.bio_process_id = 1
		GROUP BY 
			species.superkingdom,
			species.phylum,
			function.species_name,
			function.signal_id,
			response.response,
			signal.signal_supercategory,
			signal.signal_family,
			signal.signal_trivial_name)
	SELECT 
		*
	FROM qs_unsorted_summary
	ORDER BY
		superkingdom, 
		phylum, 
		species_name;


