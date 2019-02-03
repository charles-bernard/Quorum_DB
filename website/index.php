<html>

	<head>
 		<title>Quorum DB</title>
	</head>

	<body>
 		<?php echo '<p>Welcome on Quorum DB</p>'; ?>

 		<div><table border=0>

		<?php
			$dbconn = pg_connect('host=localhost dbname=quorum_db user=charles password=openit');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}

			$result = pg_query($dbconn, 'select * from gene');
			$n_fields = pg_num_fields($result);

			echo('<tr>');
			for($i=0;$i < $n_fields;$i++) {
				$column_name = pg_field_name($result, $i);
				echo('<td>' . '<b>' . $column_name . '&nbsp;&nbsp;' . '</b>' . '</td>');
			}
			echo('</tr>');

			$k = 1;
			while ($record = pg_fetch_row($result)) {
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

			pg_free_result($result);

		?>

		</table></div>
	</body>

</html>
