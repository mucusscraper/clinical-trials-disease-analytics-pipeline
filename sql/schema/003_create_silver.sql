-- +goose Up
CREATE TABLE silver.studies (
    id UUID PRIMARY KEY,
    nct_id TEXT UNIQUE NOT NULL,
    condition TEXT NOT NULL,
    title TEXT,
    study_type TEXT,
    phase TEXT,
    enrollment INT,
    overall_status TEXT,
    start_date DATE,
    completion_date DATE,
    has_results BOOLEAN,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE silver.sponsors (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    name TEXT NOT NULL,
    class TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_sponsor_per_study
    UNIQUE (study_id, name)
);

CREATE TABLE silver.collaborators (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    name TEXT NOT NULL,
    class TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_collaborators_per_study
    UNIQUE (study_id, name)
);

CREATE TABLE silver.locations (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    city TEXT,
    state TEXT,
    country TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_location_per_study
    UNIQUE (study_id, city,state,country)
);

CREATE TABLE silver.interventions (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    type TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_intervention_per_study
    UNIQUE (study_id, name, type)
);

CREATE TABLE silver.outcomes (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    measure TEXT NOT NULL,
    timeframe TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_outcome_per_study
    UNIQUE (
        study_id,
        measure,
        timeframe
    )
);

CREATE TABLE silver.references (
    id UUID PRIMARY KEY,
    study_id UUID NOT NULL REFERENCES silver.studies(id),
    pmid TEXT,
    type TEXT,
    citation TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_reference_per_study
    UNIQUE (study_id, citation)
);

-- +goose Down
DROP TABLE IF EXISTS silver.sponsors;
DROP TABLE IF EXISTS silver.collaborators;
DROP TABLE IF EXISTS silver.locations;
DROP TABLE IF EXISTS silver.interventions;
DROP TABLE IF EXISTS silver.outcomes;
DROP TABLE IF EXISTS silver.references;
DROP TABLE IF EXISTS silver.studies;