-- +goose Up
create table bronze.studies (
    id UUID PRIMARY KEY,
    nct_id TEXT NOT NULL,
    condition TEXT NOT NULL,
    raw_json JSON,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- +goose Down
DROP TABLE IF EXISTS bronze.studies;