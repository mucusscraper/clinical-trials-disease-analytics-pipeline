-- +goose Up
CREATE OR REPLACE VIEW gold.studies_by_phase_over_time AS
WITH cleaned AS (
    SELECT
        condition,
        date_trunc('year', start_date) AS year,
        CASE 
            WHEN phase IS NULL 
              OR trim(phase) = '' 
              OR upper(trim(phase)) IN ('NA', 'N/A') then 'UNKNOWN'
            else replace(initcap(trim(phase)),'_',' ')
        END AS phase
    FROM silver.studies
    WHERE start_date IS NOT NULL
)
SELECT
    condition,
    year,
    phase,
    COUNT(*) AS study_count
FROM cleaned
GROUP BY condition, year, phase
ORDER BY condition, year, phase;

CREATE OR REPLACE VIEW gold.studies_by_has_results_and_overall AS
SELECT
    s.condition,
case
	when ssd.overall_status is null then 'No Overall Available'
	else replace(initcap(trim(ssd.overall_status)),'_',' ')
end as overall_status,
    s.has_results,
    COUNT(*) as total
FROM silver.studies s
LEFT JOIN silver.study_status_details ssd ON s.id = ssd.study_id
GROUP BY s.condition, overall_status, s.has_results
ORDER BY s.condition, total DESC;

CREATE OR REPLACE VIEW gold.studies_collaborators_presence AS
SELECT
    s.condition,
    CASE 
        WHEN c.study_id IS NULL THEN 'No Collaborator'
        WHEN c.class IS NULL OR trim(c.class) = '' OR upper(c.class) IN ('NA', 'N/A') THEN 'Unknown'
        when c.class != 'FED' and c.class != 'NIH' then replace(initcap(trim(c.class)),'_',' ')
        ELSE c.class
    END AS collaborator_class,
    COUNT(DISTINCT s.id) AS total_studies
FROM silver.studies s
LEFT JOIN silver.collaborators c
    ON s.id = c.study_id
GROUP BY s.condition, collaborator_class
ORDER BY s.condition, total_studies DESC;

CREATE OR REPLACE VIEW gold.studies_design_details AS
select
s.condition,
case
	when d.allocation is null then 'NO DATA'
	when upper(trim(d.allocation)) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(d.allocation)),'_',' ')
end as allocation,
case
	when d.intervention_model is null then 'NO DATA'
	when upper(trim(d.intervention_model)) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(d.intervention_model)),'_',' ')
end as intervention_model,
case
	when d.primary_purpose is null then 'NO DATA'
	when upper(trim(d.primary_purpose )) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(d.primary_purpose)),'_',' ')
end as primary_purporse,
	count(distinct s.id) as total_studies
	from silver.studies s
    left join silver.design_details d
    on s.id=d.study_id
	group by s.condition, allocation, intervention_model,primary_purpose
order by s.condition,total_studies DESC;

CREATE OR REPLACE VIEW gold.eligibility AS
select
s.condition,
case
	when e.sex is null then 'NO DATA'
	when upper(trim(e.sex)) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(e.sex)),'_',' ')
end as sex,
case
	when e.std_ages is null then 'NO DATA'
	when upper(trim(e.std_ages)) = 'NA' then 'Not Applicable'
	else replace(replace(initcap(trim(e.std_ages)),'|',' and '),'_', ' ')
end as std_ages,
	count(distinct s.id) as total_studies
	from silver.studies s
    left join silver.eligibility e
    on s.id=e.study_id
	group by s.condition, sex, std_ages
order by s.condition, total_studies desc;

CREATE OR REPLACE VIEW gold.study_by_intervention_type AS
select
s.condition,
case
	when s.study_type is null then 'NO DATA'
	when upper(trim(s.study_type)) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(s.study_type)),'_',' ')
end as study_type,
case
	when i.type is null then 'NO DATA'
	when upper(trim(i.type)) = 'NA' then 'Not Applicable'
	else replace(initcap(trim(i.type)),'_',' ')
end as type,
count(distinct s.id) as total_studies
from silver.studies as s
left join silver.interventions i 
on i.study_id =s.id
group by condition,study_type,type
order by condition,total_studies DESC;

CREATE OR REPLACE VIEW gold.country_participation AS
select
s.condition,
case
	when l.country is null then 'No Locations'
	else replace(initcap(trim(l.country)),'_',' ')
end as country,
count(distinct s.id) as total_studies
from silver.studies as s
left join silver.locations l 
on l.study_id =s.id
group by condition,country
order by condition,total_studies DESC;

CREATE OR REPLACE VIEW gold.enrollment_phase_startdate AS
select 
condition,
enrollment,
CASE
        WHEN enrollment IS NULL THEN 'Not Specified'
        WHEN enrollment = 0 THEN '0'
        WHEN enrollment BETWEEN 1 AND 10 THEN '1-10'
        WHEN enrollment BETWEEN 11 AND 50 THEN '11-50'
        WHEN enrollment BETWEEN 51 AND 500 THEN '51-500'
        WHEN enrollment BETWEEN 501 AND 1000 THEN '501-1000'
        WHEN enrollment > 1000 THEN '>1000'
    END AS enrollment_class,
    CASE
    WHEN enrollment IS NULL THEN 0
    WHEN enrollment = 0 THEN 1
    WHEN enrollment BETWEEN 1 AND 10 THEN 2
    WHEN enrollment BETWEEN 11 AND 50 THEN 3
    WHEN enrollment BETWEEN 51 AND 500 THEN 4
    WHEN enrollment BETWEEN 501 AND 1000 THEN 5
    WHEN enrollment > 1000 THEN 6
END AS enrollment_class_order,
CASE 
            WHEN phase IS NULL 
              OR trim(phase) = '' 
              OR upper(trim(phase)) IN ('NA', 'N/A') then 'UNKNOWN'
            else replace(initcap(trim(phase)),'_',' ')
        END AS phase,
start_date,
date_trunc('year', start_date) AS year
from silver.studies;
-- +goose Down
DROP VIEW IF EXISTS gold.studies_by_phase_over_time;
DROP VIEW IF EXISTS gold.studies_by_has_results_and_overall;
DROP VIEW IF EXISTS gold.studies_collaborators_presence;
DROP VIEW IF EXISTS gold.studies_design_details;
DROP VIEW IF EXISTS gold.eligibility;
DROP VIEW IF EXISTS gold.study_by_intervention_type;
DROP VIEW IF EXISTS gold.country_participation;
DROP VIEW IF EXISTS gold.enrollment_phase_startdate;