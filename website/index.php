<!DOCTYPE html>

<?php    
if(isset($_POST['chosen_table'])){
 	$curr_table = $_POST['chosen_table'];
} else if((!$curr_table)) {
	echo('toto');
	$curr_table = "qs_summary";
}
if(isset($_POST['filtered_col'])){
	$filtered_col = $_POST['filtered_col'];
} else {
	$filtered_col = false;
}
if(isset($_POST['filter_val'])){
	$filter_val = $_POST['filter_val'];
} else {
	$filter_val = false;
}
?>

<html>

	<head>
 		<title>Quorum DB</title>
		<meta charset="utf-8" />
	</head>

	<body>
		<?php include 'includes/layout_nav_menu.php' ?>

		<?php echo($curr_table) ?>

		<div>
			<p>
			Select the table you want to display
			<form action="" method="post">
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

		<form action="" method="post">
			<input type="hidden" name="chosen_table" value="<?php echo($curr_table); ?>">
		</form>

 		<div>
		<?php
			include 'includes/display_query.php';

			// Connect DB
			$dbconn = pg_connect('host=localhost dbname=quorum_db user=visitor password=toto');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}

			if($filter_val) {
				if($curr_table == "qs_summary") {
					$result = pg_query($dbconn, 
						"SELECT * FROM {$curr_table}
						WHERE {$filtered_col} ~ '{$filter_val}'");
				} else {
					$result = pg_query($dbconn, 
						"SELECT * FROM {$curr_table} 
						WHERE {$filtered_col} ~ '{$filter_val}'
						ORDER BY 1, 2");
				}
			} else {
				if($curr_table == "qs_summary") {
					$result = pg_query($dbconn, "SELECT * FROM {$curr_table}");
				} else {
					$result = pg_query($dbconn, 
						"SELECT * FROM {$curr_table} ORDER BY 1, 2");
				}
			}

			print_table($result);
			pg_free_result($result);

		?>
		</div>





	</body>

</html>
