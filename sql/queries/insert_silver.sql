-- name: CreateRowSilverUpsertStudies :one
INSERT INTO silver.studies (
    id,
    nct_id,
    condition,
    title,
    study_type,
    phase,
    enrollment,
    overall_status,
    start_date,
    start_date_precision,
    primary_completion_date,
    primary_completion_date_precision,
    completion_date,
    completion_date_precision,
    first_submit_date,
    first_submit_date_precision,
    last_update_submit_date,
    last_update_submit_date_precision,
    has_results,
    created_at,
    updated_at
)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21)
ON CONFLICT (nct_id)
DO UPDATE SET
    title = EXCLUDED.title,
    study_type = EXCLUDED.study_type,
    phase = EXCLUDED.phase,
    enrollment = EXCLUDED.enrollment,
    overall_status = EXCLUDED.overall_status,
    start_date = EXCLUDED.start_date,
    completion_date = EXCLUDED.completion_date,
    has_results = EXCLUDED.has_results,
    updated_at = now()
RETURNING *;

-- name: GetRowFromSilverStudiesByCondition :one
SELECT * FROM silver.studies WHERE condition = $1;

-- name: GetRowFromSilverStudiesByNCTID :one
SELECT * FROM silver.studies WHERE nct_id = $1;

-- name: GetRowFromSilverStudiesByID :one
SELECT * FROM silver.studies WHERE id = $1;

-- name: CreateRowSilverSponsors :one
INSERT INTO silver.sponsors(id,
study_id,
name,
class, 
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6
)
ON CONFLICT (study_id,name)
DO UPDATE SET 
    class=EXCLUDED.class,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverCollaborators :one
INSERT INTO silver.collaborators(id,
study_id,
name,
class, 
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6
)
ON CONFLICT (study_id,name)
DO UPDATE SET 
    class=EXCLUDED.class,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverLocations :one
INSERT INTO silver.locations(id,
study_id,
city,
state,
country,
latitude,
longitude,
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9
)
ON CONFLICT (study_id, city,state,country)
DO UPDATE SET 
    latitude=EXCLUDED.latitude,
    longitude=EXCLUDED.longitude,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverInterventions :one
INSERT INTO silver.interventions(id,
study_id,
type,
name,
description,
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7
)
ON CONFLICT (study_id,name,type)
DO UPDATE SET 
    description=EXCLUDED.description,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverOutcomes :one
INSERT INTO silver.outcomes(id,
study_id,
measure,
timeframe,
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6
)
ON CONFLICT (study_id,measure)
DO UPDATE SET
    timeframe=EXCLUDED.timeframe,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverReferences :one
INSERT INTO silver.references(id,
study_id,
pmid,
type,
citation,
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7
)
ON CONFLICT (study_id, citation)
DO UPDATE SET 
    pmid=EXCLUDED.pmid,
    type=EXCLUDED.type,
    updated_at=now()
RETURNING *;