\set ON_ERROR_STOP on
\timing on
\echo '==============================';
\echo 'Loading the Bronze layer';
\echo '==============================';
BEGIN;
    \echo '-----------------------------------------';
    \echo 'Loading the bronze layer for multiple_sclerosis tables';
    \echo '-----------------------------------------';
    truncate table bronze.multiple_sclerosis;
    \copy bronze.multiple_sclerosis FROM '/home/samsung/workspace/github.com/mucusscraper/tests_and_previews/multiple_sclerosis_clinicaltrials/ctg-studies.csv' DELIMITER ',' CSV HEADER;
COMMIT;
\echo '-----------------------------------------';
\echo 'SUCCESS: Bronze layer loaded successfully';
\echo '-----------------------------------------';