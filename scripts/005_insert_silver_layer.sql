\set ON_ERROR_STOP on
\timing on
\echo '==============================';
\echo 'Loading the silver layer';
\echo '==============================';
BEGIN;
truncate table silver.dates;
    insert into silver.dates(
        nct_number,
        start_date_year_month_fake_day,
        primary_completion_date_year_month,
        completion_date_date_year_month,
        first_posted_date_year_month,
        results_first_posted_date_year_month,
        last_update_posted_date_year_month)
    select nct_number, 
    -- start_date,
    coalesce(to_date(replace(nullif(concat(substring(start_date,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as start_date_year_month_fake_day,
    -- primary_completion_date,
    coalesce(to_date(replace(nullif(concat(substring(primary_completion_date,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as primary_completion_date_year_month,
    -- completion_date,
    coalesce(to_date(replace(nullif(concat(substring(completion_date,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as completion_date_date_year_month,
    -- first_posted,
    coalesce(to_date(replace(nullif(concat(substring(first_posted,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as first_posted_date_year_month,
    -- results_first_posted,
    coalesce(to_date(replace(nullif(concat(substring(results_first_posted,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as results_first_posted_date_year_month,
    -- last_update_posted
    coalesce(to_date(replace(nullif(concat(substring(last_update_posted,0,8),'-01'),'-01'),'-','/'),'YYYY/MM/DD')) as last_update_posted_date_year_month
    from bronze.multiple_sclerosis;
    truncate table silver.text_details;
    insert into silver.text_details(
        nct_number,
        study_title,
        study_url,
        brief_summary,
        study_documents
        )
    select 
    nct_number,
    study_title,
    study_url,
    brief_summary,
    study_documents
    from bronze.multiple_sclerosis;
    -- since this is a more text focused table, there will be no data transformation. it's purely for user consulting
    truncate table silver.interventions_and_outcomes;
    insert into silver.interventions_and_outcomes(
        nct_number,
        main_intervention,
        specific_intervention,
        primary_outcome_measures,
        secondary_outcome_measures
        )
    select
    nct_number,
    split_part(trim(interventions),':',1) as main_intervention,
    split_part(trim(interventions),':',2) as specific_intervention,
    primary_outcome_measures,
    secondary_outcome_measures
    from bronze.multiple_sclerosis;
    truncate table silver.clinical_trials;
    insert into silver.clinical_trials(
        nct_number,
        study_status,
        study_results,
        study_design_model,
        study_design_model_details,
        sponsor,
        collaborators,
        funder_type,
        enrollment,
        numerical_enrollment,
        sex,
        age,
        phases,
        country
        )
    select
    nct_number,
    trim(study_status) as study_status,
    trim(study_results) as study_results,
    split_part(study_design,':',1) as study_design_model,
    trim(leading ' |' from split_part(study_design,':',2)) as study_design_model_details,
    trim(sponsor) as sponsor,
    trim(collaborators) as collaborators,
    trim(funder_type) as funder_type,
    case when enrollment::int = 0 then 'No enrollment'
	    when enrollment::int >0 and enrollment::int <50 then '1-49'
	    when enrollment::int >= 50 and enrollment::int < 100 then '50-99'
	    when enrollment::int >= 100 and enrollment::int < 500 then '100-499'
	    when enrollment::int >500 then '>500'
	    else enrollment
    end as enrollment,
    enrollment::int,
    trim(sex) as sex,
    trim(age) as age,
        case when trim(phases) = 'NA' then 'Not applicable'
        else trim(phases)
    end as phases,
    trim(reverse(split_part(reverse(locations),',',1))) as country
    from bronze.multiple_sclerosis;
COMMIT;
\echo '-----------------------------------------';
\echo 'SUCCESS: silver layer loaded successfully';
\echo '-----------------------------------------';