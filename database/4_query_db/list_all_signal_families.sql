SELECT DISTINCT ON (signal_supercategory, signal_family)
	signal_supercategory,
	signal_family 
FROM signal
WHERE signal_id != 0
ORDER BY signal_supercategory;
