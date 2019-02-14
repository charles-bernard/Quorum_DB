<?php

	function print_table($query_result, $curr_table) {
		echo('<table border=2 frame=box rules=groups>');

		// this return the number of fields in the queried table
		$n_fields = pg_num_fields($query_result);

		// FIELD DISPLAY SPECIFICITIES
		// This will link some field names to relevant internal or external resources such as NCBI taxonomy
		$font_array = array();
		$signal_link = array();
		$ref_link = array();
		$species_link = array();
		$fapath_link = array();
		$align = array();
		$is_img = array();
		$is_coord = array();
		$is_gene_id = array();
		$is_prot_id = array();

		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);

			if($column_name == "fa_seq" or $column_name == "smiles" or $column_name == "peptide_sequence") {
				array_push($font_array, "Courier New");
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

			if($column_name == "fa_path" or $column_name == "fasta") {
				array_push($fapath_link, true);
			} else {
				array_push($fapath_link, false);
			}

			if($column_name == "genes" or $column_name == "full_lineage" 
				or $column_name == "full_lineage_ranks" or $column_name == "functions") {
				array_push($align, "left");
			} else {
				array_push($align, "center");
			}

			if($column_name == "structure_img") {
				array_push($is_img, true);
			} else {
				array_push($is_img, false);
			}

			if($column_name == "gene_coordinates") {
				array_push($is_coord, true);
			} else {
				array_push($is_coord, false);
			}

			if($column_name == "gene_id" or $column_name == "gene/assembly_id") {
				array_push($is_gene_id, true);
			} else {
				array_push($is_gene_id, false);
			}

			if($column_name == "prot_id") {
				array_push($is_prot_id, true);
			} else {
				array_push($is_prot_id, false);
			}
		}

		// TABLE HEADER
		// Print each column of the table in bold
		echo('<tr>');
		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);
			echo('<td align="' . $align[$i] . '">' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
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
			if($curr_table == "species" or $curr_table == "gene") {
				$i = 0;
			} else {
				echo('<tr>');
				echo('<td align="center" bgcolor="' . $bgcol . '"><font color="White">filter by</font></td>');
				$i = 1;
			}
			for($i=$i;$i < $n_fields;$i++) {
				$column_name = pg_field_name($query_result, $i);
				if($column_name != "pubmed_id" and $column_name != "ncbi_tax_id") {
					echo('<td align="' . $align[$i] . '" bgcolor="' . $bgcol . '">');
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


		// TABLE CONTENT
		$k = 1;
		while ($record = pg_fetch_row($query_result)) {
			if ($k % 2 == 0) {
				echo('<tr bgcolor="White">');
			} else {
				echo('<tr bgcolor="Gainsboro">');
			}
			for($i=0;$i<$n_fields;$i++) {
				echo('<td align="' . $align[$i] . '">');
				if($signal_link[$i]) {
					echo('<a href="signal_report.php?val=' . $record[$i] . '" target="_blank" title="look QS information">');
					echo('browse id ' . $record[$i] . '</a>');
				} else if($ref_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/pubmed/' . $record[$i]);
					echo('" target="_blank" title="look article">');
					echo($record[$i] . '</a>');
				} else if($species_link[$i]) {
					echo('<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?name=' . $record[$i]);
					echo('" target="_blank" title="look species taxonomy">');
					echo($record[$i] . '</a>');
				} else if($fapath_link[$i]) {
					if($record[$i]) {
						$fa_file = basename($record[$i]).PHP_EOL;
						echo('<a href=data/sequences/publi_reference/' . $record[$i-1] . '/' . $fa_file . ' target="_blank"> Open Fasta </a>');
					}
				} else if($is_img[$i]) {
					if($record[$i]) {
						$img_file = basename($record[$i]).PHP_EOL;
						if($curr_table == "") {
							echo('<img src="data/img/' . $img_file . '" height="500" width="500">');
						} else {
							echo('<img src="data/img/' . $img_file . '" height="150" width="150">');
						}
					} 
				} else if($is_coord[$i]) {
					if($record[$i]) {
						list($strand, $start, $end) = preg_split('/[_:]/', $record[$i]);
						if($strand == "-") {
							$tmp = $end;
							$end = $start;
							$start = $tmp;
						}
						echo('<a href="http://www.ncbi.nlm.nih.gov/nuccore/' . $record[$i-1] . '?report=graph&from=' . $start . '&to=' . $end);
						echo('" target="_blank" title="Look gene synteny">' . $record[$i] . '</a>');
					}
				} else if($is_gene_id[$i]) {
					if(!$record[$i+1]) {
						echo('<a href="http://www.ncbi.nlm.nih.gov/nuccore/' . $record[$i] . '?report=graph" target="_blank">' . $record[$i] . '</a>');
					} else {
						echo(nl2br($record[$i] . '&nbsp;&nbsp;'));
					}
				} else if($is_prot_id[$i]) {
					if($record[$i]) {
						echo('<a href="http://www.ncbi.nlm.nih.gov/nuccore/' . $record[$i] . '?report=graph"');
						echo(' target="_blank" title="Look protein domains">' . $record[$i] . '</a>');
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

  }
?>
