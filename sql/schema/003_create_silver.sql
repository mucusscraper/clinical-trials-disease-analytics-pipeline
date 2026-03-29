-- +goose Up
CREATE TABLE silver.studies (
    id UUID PRIMARY KEY,
    nct_id TEXT UNIQUE NOT NULL,
    condition TEXT NOT NULL,
    study_type TEXT,
    phase TEXT,
    enrollment INT,
    start_date DATE,
    start_date_precision TEXT,
    primary_completion_date DATE,
    primary_completion_date_precision TEXT,
    completion_date DATE,
    completion_date_precision TEXT,
    first_submit_date DATE,
    first_submit_date_precision TEXT,
    last_update_submit_date DATE,
    last_update_submit_date_precision TEXT,
    has_results BOOLEAN,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE silver.sponsors (
    study_id UUID PRIMARY KEY REFERENCES silver.studies(id),
    name TEXT NOT NULL,
    class TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
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
    type TEXT NOT NULL,
    measure TEXT NOT NULL,
    timeframe TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_outcome_per_study
    UNIQUE (
        study_id,
        type,
        measure
    )
);


CREATE TABLE silver.eligibility (
    study_id UUID PRIMARY KEY REFERENCES silver.studies(id),
    sex TEXT,
    std_ages TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE silver.design_details (
    study_id UUID PRIMARY KEY REFERENCES silver.studies(id),
    allocation TEXT,
    intervention_model TEXT,
    primary_purpose TEXT,
    masking TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE silver.responsible_parties (
    study_id UUID PRIMARY KEY REFERENCES silver.studies(id),
    type TEXT,
    investigator_name TEXT,
    investigator_title TEXT,
    investigator_affiliation TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE silver.study_status_details (
    study_id UUID PRIMARY KEY REFERENCES silver.studies(id),
    overall_status TEXT,
    why_stopped TEXT,
    status_verified_date DATE,
    status_verified_date_precision TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- +goose Down
DROP TABLE IF EXISTS silver.sponsors;
DROP TABLE IF EXISTS silver.collaborators;
DROP TABLE IF EXISTS silver.locations;
DROP TABLE IF EXISTS silver.interventions;
DROP TABLE IF EXISTS silver.outcomes;
DROP TABLE IF EXISTS silver.eligibility;
DROP TABLE IF EXISTS silver.design_details;
DROP TABLE IF EXISTS silver.responsible_parties;
DROP TABLE IF EXISTS silver.study_status_details;
DROP TABLE IF EXISTS silver.studies;