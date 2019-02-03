<html>

	<head>
 		<title>Quorum DB</title>
	</head>

	<body>
 		<?php echo '<p>Welcome on Quorum DB</p>'; ?>

 		<div><table border=0>

		<?php
			include 'functions.php';

			$dbconn = pg_connect('host=localhost dbname=quorum_db user=charles password=openit');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}

			$result = pg_query($dbconn, 'select * from sequence');
			print_table($result);
			pg_free_result($result);

		?>

		</table></div>
	</body>

</html>
