<html>

	<head>
 		<title>Quorum DB</title>
	</head>

	<body>
		<?php echo '<p>Welcome on Quorum DB</p>'; ?>

		<div>
		<table border=2 width=40%>
			<tr>
				<td> Home </td>
				<td> Browse </td>
				<td> Search </td>
				<td> Pre-computed queries </td>
				<td> Help </td>
			</tr>
		<table>

		<div>
			<p>
			Select the table you want to display
			<form method="post">
				<select id="formTable" name="formTable">
					<option value="gene">Gene</option>
					<option value="reference">Reference</option>
					<option value="signal">Signal</option>
					<option value="sequence">Sequence</option>
					<option value="species">Species</option>
				</select>
			</form>
			</p>

		</div>

 		<div>
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

			echo('toto');
			echo($table_name);

		?>
		</div>


	</body>

</html>
