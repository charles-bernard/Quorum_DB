WITH hsl_signal AS
(SELECT DISTINCT ON (signal_supercategory, signal_family, signal_trivial_name)
	signal_supercategory,
	signal_family,
	signal_trivial_name AS "hsl_subfamily"
FROM signal
WHERE signal_trivial_name ~ 'HSL')
SELECT DISTINCT ON (signal.signal_supercategory, signal.signal_family, hsl_signal.hsl_subfamily)
	signal.signal_supercategory,
	signal.signal_family,
	hsl_signal.hsl_subfamily
FROM signal
LEFT JOIN
	hsl_signal
	ON signal.signal_trivial_name = hsl_signal.hsl_subfamily
WHERE signal.signal_id != 0
ORDER BY signal.signal_supercategory, signal.signal_family, hsl_signal.hsl_subfamily;