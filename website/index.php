<!DOCTYPE html>

<?php   
// Examine arg values 
if(isset($_POST['chosen_table'])) {
 	$curr_table = $_POST['chosen_table'];
} else if((!$curr_table)) {
	// qs_summary view is the default table
	$curr_table = "qs_summary";
}

if(isset($_POST['filtered_col'])) {
	$filtered_col = $_POST['filtered_col'];
} else {
	$filtered_col = false;
}

if(isset($_POST['filter_val'])) {
	$filter_val = $_POST['filter_val'];
} else {
	$filter_val = false;
}

if(isset($_POST['do_sort_asc'])) {
	$sort = "ASC";
} elseif (isset($_POST['do_sort_desc'])) {
	$sort = "DESC";
} else {
	$sort = false;
}
?>

<html>

	<?php include 'includes/head.php' ?>

	<body>
		<?php include 'includes/banner_and_menu.php' ?>

		<div>
			<p>
				<form action="" method="post">
					<select id="chosen_table" name="chosen_table">
						<option value="qs_summary">QS_systems</option>
						<option value="gene">Gene</option>
						<option value="reference">Reference</option>
						<option value="signal">Signal</option>
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
				$dbconn = pg_connect('host=localhost dbname=quorum_db user=visitor password=toto');
				if (!$dbconn) {
					echo('An error occurred.\n');
					exit;
				}

				// Determine how to query the current table
				if($filter_val) {
					$where_statement = " WHERE {$filtered_col} ~ '(?i){$filter_val}'";
				} else {
					$where_statement = "";
				}
				if($sort) {
					$order_statement = " ORDER BY {$filtered_col} {$sort}";
				} else if($curr_table != "qs_summary") {
					$order_statement = " ORDER BY 1, 2";
				} else {
					$order_statement = "";
				}
				$query = ("SELECT * FROM " . $curr_table . $where_statement . $order_statement . ";");

				// Execute the query, display the result and free it.
				$result = pg_query($dbconn, $query);
				print_table($result, $curr_table);
				pg_free_result($result);
			?>
		</div>

	<br>
	</body>

</html>
