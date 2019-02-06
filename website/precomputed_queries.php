<!DOCTYPE html>

<html>

	<head>
 		<title>Quorum DB</title>
		<meta charset="utf-8" />
	</head>

	<body>
		<?php include 'includes/layout_nav_menu.php' ?>

 		<div>
		<?php
			include 'includes/display_query.php';
			include 'includes/queries.php';

			// Connect DB
			$dbconn = pg_connect('host=localhost dbname=quorum_db user=visitor password=toto');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}
		?>

		<div>
			<ul>
				<li> 
					<form action="#" method="post">
						<button name="do_query_1">List all signal families</button>
					</form>
				</li>
	<!-- 			<li>
					<form action="#" method="post">
						Type in Signal id:<input type="text" name="query_signal_id">
						<button name="do_query_2">Signal id to gene sequences</button>
					</form>
				</li> -->
			</ul>
		</div>

		<?php
			if(isset($_POST['do_query_1'])){
 				$result = list_all_signal_families($dbconn);
 			}
			// } elseif(isset($_POST['do_query_2'])) {
			// 	if(isset($_POST['query_signal_id'])) {
			// 		$result = signal_id_to_gene_sequences($dbconn, $_POST['query_signal_id']);
			// 	}
			// }
			print_table($result);
			pg_free_result($result);
		?>
		</div>


	</body>

</html>
