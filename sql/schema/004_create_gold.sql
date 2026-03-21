-- +goose Up
CREATE OR REPLACE VIEW gold.studies_by_phase_over_time AS
WITH cleaned AS (
    SELECT
        condition,
        date_trunc('year', start_date) AS year,
        CASE 
            WHEN phase IS NULL 
              OR trim(phase) = '' 
              OR upper(phase) IN ('NA', 'N/A') 
            THEN 'UNKNOWN'
            ELSE phase
        END AS phase
    FROM silver.studies
    WHERE start_date IS NOT NULL
)
SELECT
    condition,
    year,
    phase,
    COUNT(*) AS study_count
FROM cleaned
GROUP BY condition, year, phase
ORDER BY condition, year, phase;
-- +goose Down
DROP VIEW IF EXISTS gold.studies_by_phase_over_time;