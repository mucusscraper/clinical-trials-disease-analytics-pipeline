-- name: CreateRowBronze :one
INSERT INTO bronze.studies(id,nct_id,condition,raw_json,created_at,updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6
)
RETURNING *;

-- name: GetRowByCondition :one
SELECT * FROM bronze.studies WHERE condition = $1;