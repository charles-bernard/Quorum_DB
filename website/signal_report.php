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

		<table border = 0>
			<td>
			<h2> Reference(s) </h2>
			<?php
				$result = signal_id_2_ref($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br>
		<table border = 0>
			<td>
			<h2> Host Organism(s) </h2>
			<?php
				$result = signal_id_2_species($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br>
		<table border = 0>
			<td>
			<h2> Triggered response(s) </h2>
			<?php
				$result = signal_id_2_response($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br>
		<table border = 0>
			<td>
			<h2> Sequence of involved genes </h2>
			<?php
				$result = signal_id_2_seq($dbconn, $query_signal_id);
				print_table($result);
				pg_free_result($result);
			?>
			</td>
		</table>

		<br>
		<table border = 0>
			<tr>
			<h2> Signal Characteristics </h2>
			<?php
				$result = pg_query($dbconn, 
					"SELECT signal_id, signal_supercategory, signal_family, signal_trivial_name,  	
					signal_systematic_name, peptide_sequence, smiles
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result);
				pg_free_result($result);
				echo('<br>');
			?>
			</tr>
			<tr>
			<?php
				$result = pg_query($dbconn, 
					"SELECT signal_info AS Additional_Information, structure_img
					FROM signal WHERE signal_id='{$query_signal_id}'");
				print_table($result);
				pg_free_result($result);
			?>
			</tr>
		</table>

	<br>
	</body>

</html>
