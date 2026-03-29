-- name: CreateRowSilverUpsertStudies :one
INSERT INTO silver.studies (
    id,
    nct_id,
    condition,
    study_type,
    phase,
    enrollment,
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
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19)
ON CONFLICT (nct_id)
DO UPDATE SET
    study_type = EXCLUDED.study_type,
    phase = EXCLUDED.phase,
    enrollment = EXCLUDED.enrollment,

    start_date = EXCLUDED.start_date,
    start_date_precision = EXCLUDED.start_date_precision,

    primary_completion_date = EXCLUDED.primary_completion_date,
    primary_completion_date_precision = EXCLUDED.primary_completion_date_precision,

    completion_date = EXCLUDED.completion_date,
    completion_date_precision = EXCLUDED.completion_date_precision,

    first_submit_date = EXCLUDED.first_submit_date,
    first_submit_date_precision = EXCLUDED.first_submit_date_precision,

    last_update_submit_date = EXCLUDED.last_update_submit_date,
    last_update_submit_date_precision = EXCLUDED.last_update_submit_date_precision,

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
INSERT INTO silver.sponsors(study_id,
name,
class, 
created_at, 
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5
)
ON CONFLICT (study_id)
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
type,
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
    $6,
    $7
)
ON CONFLICT (study_id,type,measure)
DO UPDATE SET
    timeframe=EXCLUDED.timeframe,
    updated_at=now()
RETURNING *;


-- name: CreateRowSilverEligibility :one
INSERT INTO silver.eligibility(study_id,
sex,
std_ages,
created_at,
updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5
)
ON CONFLICT (study_id)
DO UPDATE SET 
    sex=EXCLUDED.sex,
    std_ages=EXCLUDED.std_ages,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverDesignDetails :one
INSERT INTO silver.design_details(study_id,
allocation,
intervention_model,
primary_purpose,
masking,
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
ON CONFLICT (study_id)
DO UPDATE SET 
    allocation=EXCLUDED.allocation,
    intervention_model=EXCLUDED.intervention_model,
    primary_purpose=EXCLUDED.primary_purpose,
    masking=EXCLUDED.masking,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverResponsibleParties :one
INSERT INTO silver.responsible_parties(study_id,
type,
investigator_name,
investigator_title,
investigator_affiliation,
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
ON CONFLICT (study_id)
DO UPDATE SET 
    type=EXCLUDED.type,
    investigator_name=EXCLUDED.investigator_name,
    investigator_title=EXCLUDED.investigator_title,
    investigator_affiliation=EXCLUDED.investigator_affiliation,
    updated_at=now()
RETURNING *;

-- name: CreateRowSilverStudyStatus :one
INSERT INTO silver.study_status_details(study_id,
overall_status,
why_stopped,
status_verified_date,
status_verified_date_precision,
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
ON CONFLICT (study_id)
DO UPDATE SET 
    overall_status=EXCLUDED.overall_status,
    why_stopped=EXCLUDED.why_stopped,
    status_verified_date=EXCLUDED.status_verified_date,
    status_verified_date_precision=EXCLUDED.status_verified_date_precision,
    updated_at=now()
RETURNING *;