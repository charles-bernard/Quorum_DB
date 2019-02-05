<!DOCTYPE html>

<?php    
if(isset($_POST['chosen_table'])){
 	$curr_table = $_POST['chosen_table'];
} else {
	$curr_table = "qs_summary";
}  
?>

<html>

	<head>
 		<title>Quorum DB</title>
		<meta charset="utf-8" />
	</head>

	<body>
		<?php include 'includes/layout_nav_menu.php' ?>

		<div>
			<p>
			Select the table you want to display
			<form action="#" method="post">
				<select id="chosen_table" name="chosen_table">
					<option value="qs_summary">QS_systems</option>
					<option value="gene">Gene</option>
					<option value="reference">Reference</option>
					<option value="signal">Signal</option>
					<!-- <option value="sequence">Sequence</option> -->
					<option value="species">Species</option>
				</select>
				<input type="submit" value="Display the table"/>
			</form>
			</p>

		</div>

 		<div>
		<?php
			include 'includes/display_query.php';

			// Connect DB
			$dbconn = pg_connect('host=localhost dbname=quorum_db user=charles password=openit');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}

			$result = pg_query($dbconn, 'select * from ' . $curr_table);
			print_table($result);
			pg_free_result($result);

		?>
		</div>


	</body>

</html>
