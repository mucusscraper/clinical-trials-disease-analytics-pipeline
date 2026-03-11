DROP TABLE IF EXISTS silver.dates;
create table silver.dates (
    nct_number TEXT,
	start_date_year_month_fake_day DATE,
	primary_completion_date_year_month DATE,
    completion_date_date_year_month DATE,
    first_posted_date_year_month DATE,
    results_first_posted_date_year_month DATE,
    last_update_posted_date_year_month DATE,
	dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

DROP TABLE IF EXISTS silver.text_details;
create table silver.text_details (
	nct_number TEXT,
	study_title TEXT,
    study_url TEXT,
    brief_summary TEXT,
    study_documents TEXT,
	dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

DROP TABLE IF EXISTS silver.interventions_and_outcomes;
create table silver.interventions_and_outcomes (
	nct_number TEXT,
	main_intervention TEXT,
    specific_intervention TEXT,
    primary_outcome_measures TEXT,
    secondary_outcome_measures TEXT,
    other_outcome_measures TEXT,
	dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);
DROP TABLE IF EXISTS silver.clinical_trials;
create table silver.clinical_trials (
    nct_number TEXT,
    study_status TEXT,
    study_results TEXT,
    study_design_model TEXT,
    study_design_model_details TEXT,
    sponsor TEXT,
    collaborators TEXT,
    funder_type TEXT,
    enrollment TEXT,
    numerical_enrollment INT,
    sex TEXT,
    age TEXT,
    phases TEXT,
    country TEXT,
	dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);