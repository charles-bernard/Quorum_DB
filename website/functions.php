<?php
	function print_table($query_result) {
		$n_fields = pg_num_fields($query_result);

		// TABLE HEADER
		echo('<tr>');
		for($i=0;$i < $n_fields;$i++) {
			$column_name = pg_field_name($query_result, $i);
			echo('<td>' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
		}
		echo('</tr>');

		// TABLE CONTENT
		$k = 1;
		while ($record = pg_fetch_row($query_result)) {
			if ($k % 2 == 0) {
				echo('<tr>');
			} else {
				echo('<tr bgcolor="WhiteSmoke">');
			}
			for($i=0;$i<$n_fields;$i++) {
				echo('<td>' . $record[$i] . '&nbsp;&nbsp;' . '</td>');
			}
			echo('</tr>');
			++$k;
		}
  }
?>
