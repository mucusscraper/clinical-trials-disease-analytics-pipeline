-- IMPORTANT METRICS:

-- Total Studies:
select count(distinct(nct_number)) as Total_Studies from gold.facts_clinical_trials;

-- Trial By Year:
select count(distinct(nct_number)) as Total_Studies_By_Year,
extract(year from start_date) as year
from
gold.facts_clinical_trials
group by year;

-- Trial By Phase:
select count(distinct(nct_number)) as Total_Studies_By_Phase,
phases
from
gold.facts_clinical_trials
group by phases
order by Total_Studies_By_Phase DESC;


-- Top Sponsors:
select count(distinct(nct_number)) as Total_Studies_By_Sponsor,
sponsor
from
gold.facts_clinical_trials
group by sponsor
order by Total_Studies_By_Sponsor DESC;


-- Medium Number of Enrollment and std:
select avg(numerical_enrollment)::int, stddev(numerical_enrollment) from gold.facts_clinical_trials;

-- Metrics about population:
-- Trial By Country:
select count(distinct(nct_number)) as Total_Studies_By_Country,
country
from
gold.facts_clinical_trials
group by country
order by Total_Studies_By_Country DESC;

-- Trials by Sex
select count(distinct(fct.nct_number)) as Total_Studies_By_Sex,
dp.sex
from
gold.facts_clinical_trials as fct
left join gold.dim_population as dp
on fct.nct_number=dp.nct_number
group by dp.sex
order by Total_Studies_By_Sex DESC;

-- Trials by Age Range
select count(distinct(fct.nct_number)) as Total_Studies_By_Age,
dp.age
from
gold.facts_clinical_trials as fct
left join gold.dim_population as dp
on fct.nct_number=dp.nct_number
group by dp.age
order by Total_Studies_By_Age DESC;

-- Trials by Study Design Model
select count(distinct(fct.nct_number)) as Total_Studies_By_Design_Model,
dt.study_design_model
from
gold.facts_clinical_trials as fct
left join gold.dim_trials as dt
on fct.nct_number=dt.nct_number
group by dt.study_design_model
order by Total_Studies_By_Design_Model DESC;

-- Trials with published results:
select count(distinct(fct.nct_number)) as Total_Studies_By_Published_Results,
dt.study_results 
from
gold.facts_clinical_trials as fct
left join gold.dim_trials as dt
on fct.nct_number=dt.nct_number
group by dt.study_results
order by Total_Studies_By_Published_Results  DESC;


-- Interventions Metrics:
-- Types of Interventions:
select count(distinct(fct.nct_number)) as Total_Studies_By_Main_Intervention,
diao.main_intervention
from
gold.facts_clinical_trials as fct
left join gold.dim_interventions_and_outcomes as diao
on fct.nct_number=diao.nct_number
group by diao.main_intervention
order by Total_Studies_By_Main_Intervention DESC;

-- Duration Metrics:
-- Average Duration of a trial
select
round((avg(completion_date - start_date))/365,1) as avg_trial_duration_in_years,
round((avg(completion_date - start_date))/30,1) as avg_trial_duration_in_months,
round(avg(completion_date - start_date),1) as avg_trial_duration_in_days
from gold.facts_clinical_trials
where completion_date is not null; 

-- Status Metrics
-- Status Types:
select count(distinct(fct.nct_number)) as Total_Studies_By_Status,
dt.study_status
from
gold.facts_clinical_trials as fct 
left join gold.dim_trials dt 
on fct.nct_number=dt.nct_number
group by dt.study_status
order by Total_Studies_By_Status DESC;