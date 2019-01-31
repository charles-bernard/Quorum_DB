
/* LEVEL O TABLES */

\COPY bio_process (bio_process_id, bio_process) FROM 'input_tables/bioprocess.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;
\COPY reference (pubmed_id, doi, isbn) FROM 'input_tables/reference.csv' WITH DELIMITER E'\t' NULL AS '' CSV HEADER;


/*
\COPY genre FROM 'tables_csv/genre.csv' WITH DELIMITER E'\t' NULL AS '';

\COPY pays FROM 'tables_csv/pays.csv' WITH DELIMITER E'\t' NULL AS '';

\COPY groupe FROM 'tables_csv/groupe.csv' WITH DELIMITER E'\t' NULL AS '';

BEGIN;

\COPY album FROM 'tables_csv/album.csv' WITH DELIMITER E'\t' NULL AS '';

\COPY internaute FROM 'tables_csv/internaute.csv' WITH DELIMITER E'\t' NULL AS ''; 

COMMIT;

\COPY artiste FROM 'tables_csv/artiste.csv' WITH DELIMITER E'\t' NULL AS '';

\COPY note FROM 'tables_csv/note.csv' WITH DELIMITER E'\t' NULL AS '';

\COPY enregistre FROM 'tables_csv/enregistre.csv' WITH DELIMITER E'\t' NULL AS '';
*/