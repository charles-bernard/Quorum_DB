<!DOCTYPE html>

<html>

	<?php include 'includes/head.php' ?>

	<body>
		<?php include 'includes/banner_and_menu.php' ?>

		<div>

			<table border=0>
				<tr>
					<td>
						<form action="#" method="post">
							<button name="do_query_1" style="width:300px">List all signal families</button>
						</form>
					</td>
					<td>
						<form action="#" method="post">
							<button name="do_query_2" style="width:300px">List entries with interspecies QS</button>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<form action="#" method="post">
							<button name="do_query_3" style="width:300px">List QS systems with a synthase and no characterized or no present receptor</button>
						</form>
					</td>
					<td>
						<form action="#" method="post">
							<button name="do_query_4" style="width:300px">List QS systems with a receptor and no characterized or no present synthase</button>
						</form>
					</td>
				</tr>
			</table>					
			
		</div>

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
				if(isset($_POST['do_query_1'])){
					echo('<hr>');
					echo('<h3>Signal Families </h3>');
	 				$result = list_all_signal_families($dbconn);
				} elseif(isset($_POST['do_query_2'])) {
					echo('<hr>');
					echo('<h3>Entries with interspecies QS </h3>');
	 				$result = list_interspecies_qs($dbconn);
				} elseif(isset($_POST['do_query_3'])) {
					echo('<hr>');
					echo('<h3>QS system with a synthase and no characterized or no present receptor in the species</h3>');
					$result = list_orphan_module($dbconn, 'synthase');
				} elseif(isset($_POST['do_query_4'])) {
					echo('<hr>');
					echo('<h3>QS system with a receptor and no characterized or no present synthase(s) in the species</h3>');
					$result = list_orphan_module($dbconn, 'receptor');
				}
				print_table($result);
				pg_free_result($result);
			?>
		</div>

	<br>
	</body>

</html>
