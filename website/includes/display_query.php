<?php

	function print_table($query_result, $curr_table) {
		echo('<table border=1 frame=void rules=all>');

		$n_fields = pg_num_fields($query_result);

		// TABLE HEADER
		echo('<tr>');
		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);
			echo('<td>' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
		}
		echo('</tr>');

		// FILTER ROW
		if(basename($_SERVER['PHP_SELF']) == "index.php" || basename($_SERVER['PHP_SELF']) == "index.php#") {
			echo('<tr>');
			echo('<td bgcolor="Cornsilk">filter by</td>');
			for($i=1;$i < $n_fields;$i++) {
				$column_name = pg_field_name($query_result, $i);
				if($column_name != "functions" and $column_name != "pubmed_id" and $column_name != "ncbi_tax_id") {
					echo('<td bgcolor="Cornsilk">');
					echo('<form action="" method="post">');
					echo('<input type="hidden" name="filtered_col" value="' . $column_name .'">');
					echo('<input type="hidden" name="chosen_table" value="' . $curr_table .'">');
					echo('<input type="text" name="filter_val" style="width:110px"><br>');
					echo('<button name="filter" style="width:125px">Filter</button>');
					echo('</form>');
					echo('</td>');
				} else {
					echo('<td bgcolor="Cornsilk"></td>');
				}
			}
			echo('</tr>');
		}


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
					echo('<a href="signal_report.php?val=' . $record[$i] . '" target="_blank">');
					echo('browse id ' . $record[$i] . '</a>');
				} else if($ref_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/pubmed/' . $record[$i] . '" target="_blank">');
					echo($record[$i] . '</a>');
				} else if($species_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?name=' . $record[$i] . '" target="_blank">');
					echo($record[$i] . '</a>');
				} else if($fapath_link[$i]) {
					if($record[$i]) {
						$fa_file = basename($record[$i]).PHP_EOL;
						echo('<a href=data/sequences/publi_reference/' . $record[$i-1] . '/' . $fa_file . ' target="_blank"> Open Fasta </a>');
					}
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

		echo('</table>');
  }
?>
