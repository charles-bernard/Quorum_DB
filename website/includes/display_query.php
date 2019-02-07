<?php

	function print_table($query_result) {
		echo('<table border=1 frame=void rules=all>');

		$n_fields = pg_num_fields($query_result);

		// TABLE HEADER
		echo('<tr>');
		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);
			echo('<td>' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
		}
		echo('</tr>');


		// COLUMN DISPLAY SPECIFICITIES
		$font_array = array();
		$signal_link = array();
		$ref_link = array();
		$species_link = array();
		$fapath_link = array();

		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);

			if($column_name == "fa_seq") {
				array_push($font_array, "Courier");
			} else {
				array_push($font_array, "\"\"");
			}

			if($column_name == "signal_id" || $column_name == "id") {
				array_push($signal_link, true);
			} else {
				array_push($signal_link, false);
			}

			if($column_name == "pubmed_id") {
				array_push($ref_link, true);
			} else {
				array_push($ref_link, false);
			}

			if($column_name == "species_name") {
				array_push($species_link, true);
			} else {
				array_push($species_link, false);
			}

			if($column_name == "fa_path") {
				array_push($fapath_link, true);
			} else {
				array_push($fapath_link, false);
			}
		}
		// <a href="bonjour.php?nom=Dupont&amp;prenom=Jean">Dis-moi bonjour !</a>

		// TABLE CONTENT
		$k = 1;
		while ($record = pg_fetch_row($query_result)) {
			if ($k % 2 == 0) {
				echo('<tr>');
			} else {
				echo('<tr bgcolor="WhiteSmoke">');
			}
			for($i=0;$i<$n_fields;$i++) {
				echo('<td>');
				if($signal_link[$i]) {
					echo('<a href="signal_report.php?val=');
					echo($record[$i]);
					echo('">');
					echo($record[$i]);
					echo('</a>');
				} else if($ref_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/pubmed/');
					echo($record[$i]);
					echo('"target="_blank">');
					echo($record[$i]);
					echo('</a>');
				} else if($species_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?name=');
					echo($record[$i]);
					echo('" target="_blank">');
					echo($record[$i]);
					echo('</a>');
				} else if($fapath_link[$i]) {
					$fa_file = basename($record[$i]).PHP_EOL;
					echo('<a href=data/sequences/publi_reference/');
					echo($record[$i-1] . '/');
					echo($fa_file);
					echo('" target="_blank"> Open Fasta </a>');
				} else {
					echo('<font face=' . $font_array[$i] . '>');
					echo(nl2br($record[$i] . '&nbsp;&nbsp;'));
					echo('</font>');
				}
				echo('</td>');
			}
			echo('</tr>');
			++$k;
		}

		echo('</table');
  }
?>
