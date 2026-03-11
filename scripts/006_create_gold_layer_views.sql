-- for dim_trials 
CREATE OR REPLACE VIEW gold.dim_trials AS 
select ct.nct_number, 
study_title, 
initcap(replace(study_status, '_', ' ')) AS study_status, 
study_results, 
initcap(replace(phases, '|', ' and ')) AS phases, 
study_design_model, 
study_design_model_details 
from 
silver.clinical_trials as ct 
left join silver.text_details as td 
on ct.nct_number=td.nct_number; 

-- for dim_interventions_and_outcomes 
CREATE OR REPLACE VIEW gold.dim_interventions_and_outcomes AS 
select iao.nct_number, 
initcap(replace(main_intervention, '_', ' ')) AS main_intervention, 
specific_intervention, 
primary_outcome_measures, 
secondary_outcome_measures 
from 
silver.interventions_and_outcomes as iao; 

-- for dim_dates 
CREATE OR REPLACE VIEW gold.dim_dates AS 
SELECT 
nct_number, 
start_date_year_month_fake_day as start_date, 
primary_completion_date_year_month as primary_completion_date, 
completion_date_date_year_month as completion_date, 
first_posted_date_year_month as first_posted_date, 
results_first_posted_date_year_month as results_posted_date, 
last_update_posted_date_year_month as last_update_date 
FROM 
silver.dates; 

-- for dim_sponsors 
CREATE OR REPLACE VIEW gold.dim_sponsors AS 
select 
nct_number, 
sponsor, 
collaborators, 
initcap(replace(funder_type, '_', ' ')) AS funder_type 
FROM 
silver.clinical_trials; 

-- for dim_locations: 
CREATE OR REPLACE VIEW gold.dim_locations AS 
select 
nct_number, 
country 
FROM 
silver.clinical_trials; 

-- for dim_population: 
CREATE OR REPLACE VIEW gold.dim_population AS 
SELECT 
nct_number, 
initcap(sex) as sex, 
initcap(replace(replace(age, ',', ' and '),'_', ' ')) AS age, 
enrollment 
FROM 
silver.clinical_trials; 

-- for facts_clinical_trial 
CREATE OR REPLACE VIEW gold.facts_clinical_trials AS 
select 
ct.nct_number, 
d.start_date_year_month_fake_day as start_date, 
d.completion_date_date_year_month as completion_date, 
ct.phases, 
ct.country, 
ct.sponsor, 
ct.enrollment, 
ct.numerical_enrollment 
from 
silver.clinical_trials as ct 
left join silver.dates as d 
on ct.nct_number=d.nct_number;