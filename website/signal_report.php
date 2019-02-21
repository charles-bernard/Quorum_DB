<!DOCTYPE html>

<?php    
if(isset($_GET['val'])){
 	$query_signal_id = $_GET['val'];
} else {
	$query_signal_id = 1;
} 
?>

<html>

	<?php include 'includes/head.php' ?>

	<body>
		<?php 
			include 'includes/banner_and_menu.php';
			include 'includes/display_query.php';
			include 'includes/queries.php';
		?>

		<?php
			// Connect DB
			$dbconn = pg_connect('host=localhost dbname=quorum_db user=visitor password=toto');
			if (!$dbconn) {
				echo('An error occurred.\n');
				exit;
			}
		?>


		<h2> Reference(s) </h2>
		<table border=0>
			<td>
			<?php
				$result = signal_id_2_ref($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br><br>
		<h2> Host Organism(s) </h2>
		<table border=0>
			<td>
			<?php
				$result = signal_id_2_species($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br><br>
		<h2> Triggered response(s) </h2>
		<table border=0>
			<td>
			<?php
				$result = signal_id_2_response($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br><br>
		<h2> Sequence of involved genes </h2>
		<table border=0>
			<td>
			<?php
				$result = signal_id_2_seq($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br><br>
		<h2> Signal Characteristics </h2>
		<table border=0 frame=box>
			<td>
			<?php
				$result = pg_query($dbconn, 
					"SELECT signal_id, signal_supercategory, signal_family, signal_trivial_name,  	
					signal_systematic_name
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result, "signal_characteristics");
				pg_free_result($result);
				echo("<br>");

				$result = pg_query($dbconn, 
					"SELECT structure_img, signal_info AS Additional_Information
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result, "signal_characteristics");
				pg_free_result($result);

				$result = pg_query($dbconn, 
					"SELECT peptide_sequence
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result, "signal_characteristics");
				pg_free_result($result);

				$result = pg_query($dbconn, 
					"SELECT smiles
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result, "signal_characteristics");
				pg_free_result($result);
			?>
			</td>
		</table>

		<br><br>
		<h2> External resources </h2>
		<table border=0>
			<td>
			<?php
				$result = pg_query($dbconn, 
					"SELECT quorum_peps_id, sigmol_id 
					FROM SIGNAL WHERE signal_id='{$query_signal_id}'");
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

	<br><br>
	<br>
	</body>

</html>
