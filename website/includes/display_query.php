<?php

	function print_table($query_result, $curr_table) {
		echo('<table border=2 frame=box rules=groups>');

		// this return the number of fields in the queried table
		$n_fields = pg_num_fields($query_result);

		// TABLE HEADER
		// Print each column of the table in bold
		echo('<tr>');
		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);
			echo('<td>' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
		}
		echo('</tr>');

		// FILTER ROW
		// For each field, this will consist in:
		//   1) an entry typing button (sending 'filter_val') 
		//   2) a submit button (sending 'do_filter')
		//   3) a submit button (sending 'do_sort_asc')
		//   4) a submit button (sending 'do_sort_desc')
		// Column names whose values are numbers are not considered
		// because the filter query is based on string regexp
		if(basename($_SERVER['PHP_SELF']) == "index.php" || basename($_SERVER['PHP_SELF']) == "index.php#") {
			$bgcol = "Teal";
			// first column filtering and sorting is only enabled for table species
			if($curr_table == "species") {
				$i = 0;
			} else {
				echo('<tr>');
				echo('<td bgcolor="' . $bgcol . '"><font color="White">filter by</font></td>');
				$i = 1;
			}
			for($i=$i;$i < $n_fields;$i++) {
				$column_name = pg_field_name($query_result, $i);
				if($column_name != "pubmed_id" and $column_name != "ncbi_tax_id") {
					echo('<td bgcolor="' . $bgcol . '">');
					echo('<form action="" method="post">');
					echo('<input type="hidden" name="filtered_col" value="' . $column_name .'">');
					echo('<input type="hidden" name="chosen_table" value="' . $curr_table .'">');
					echo('<table><tr>');
					echo('<td><input type="text" name="filter_val" style="width:90px"></td>');
					echo('<td><button name="do_sort_desc">&#8593;</button></td>');
					echo('</tr><tr>');
					echo('<td><button name="do_filter" style="width:105px">Filter</button></td>');
					echo('<td><button name="do_sort_asc">&#8595;</button></td>');
					echo('</tr></table>');
					echo('</form>');
					echo('</td>');
				} else {
					echo('<td bgcolor="' . $bgcol . '"></td>');
				}
			}
			echo('</tr>');
		}


		// FIELD DISPLAY SPECIFICITIES
		// This will link some field names to relevant internal or external resources such as NCBI taxonomy
		// $font_array = array();
		$signal_link = array();
		$ref_link = array();
		$species_link = array();
		$fapath_link = array();

		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);

			// if($column_name == "fa_seq") {
			// 	array_push($font_array, "Courier");
			// } else {
			// 	array_push($font_array, "\"\"");
			// }

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
				echo('<tr bgcolor="White">');
			} else {
				echo('<tr bgcolor="#E8E8E8">');
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
