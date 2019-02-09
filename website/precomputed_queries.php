<!DOCTYPE html>

<html>

	<head>
 		<title>Quorum DB</title>
		<meta charset="utf-8" />
	</head>

	<body>
		<?php include 'includes/layout_head.php' ?>

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
						<button name="do_query_1" style="width:300px">List all signal families</button>
					</form>
				</li>
				<li> 
					<form action="#" method="post">
						<button name="do_query_2" style="width:300px">List entries with interspecies QS</button>
					</form>
				</li>
				<li> 
					<form action="#" method="post">
						<button name="do_query_3" style="width:300px">List orphan synthases and receptors</button>
					</form>
				</li>
			</ul>
		</div>

		<?php
			if(isset($_POST['do_query_1'])){
				echo('<hr>');
				echo('<h3> Signal Families </h3>');
 				$result = list_all_signal_families($dbconn);
			} elseif(isset($_POST['do_query_2'])) {
				echo('<hr>');
				echo('<h3> Entries with interspecies QS </h3>');
 				$result = list_interspecies_qs($dbconn);
			} elseif(isset($_POST['do_query_3'])) {
				echo('<hr>');
				echo('<h3> Entries with synthase(s) whose signal cognate receptor is not present or not yet characterized in the species</h3>');
				$result = list_orphan_module($dbconn, 'synthase');
				print_table($result);
				pg_free_result($result);
				echo('<hr>');
				echo('<h3> Entries with receptor whose signal cognate synthase(s) are not present or not yet characterized in the species</h3>');
				$result = list_orphan_module($dbconn, 'receptor');
			}
			print_table($result);
			pg_free_result($result);
		?>
		</div>

	<hr><br>
	</body>

</html>
