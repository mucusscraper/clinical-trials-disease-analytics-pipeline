select * from bronze.multiple_sclerosis;
-- Take a look at the dataset
-- the ID would be nct_number
-- since this dataset has not so many columns with measures, it's more a descritive dataset,
-- it will be divided in trial_description, trial_outcome, trial_patient, trial_dates

select count(distinct(nct_number)) as nct_number_repeated,
nct_number
from bronze.multiple_sclerosis 
group by nct_number
order by nct_number_repeated desc;
-- There is no nct_number repeated nor repeated rows

select * from bronze.multiple_sclerosis;

select nct_number,COUNT(*) from bronze.multiple_sclerosis group by nct_number having COUNT(*)>1 or nct_number is NULL;
select study_title,COUNT(*) from bronze.multiple_sclerosis group by study_title having COUNT(*)>1 or study_title is NULL;
-- 9 repeated study titles
select * from bronze.multiple_sclerosis where study_title='Telerehabilitation in Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='MEsenchymal StEm Cells for Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='A Study of Ocrelizumab in Comparison With Interferon Beta-1a (Rebif) in Participants With Relapsing Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='Magnetic Resonance Imaging to Detect Brain Damage in Patients With Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='Cannabis for Spasticity in Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='A Study of Ocrelizumab in Participants With Relapsing Remitting Multiple Sclerosis (RRMS) Who Have Had a Suboptimal Response to an Adequate Course of Disease-Modifying Treatment (DMT)'; -- different studies
select * from bronze.multiple_sclerosis where study_title='Efficacy and Safety of Remibrutinib Compared to Teriflunomide in Participants With Relapsing Multiple Sclerosis (RMS)'; -- different studies
select * from bronze.multiple_sclerosis where study_title='High Intensity Interval Gait Training in Multiple Sclerosis'; -- different studies
select * from bronze.multiple_sclerosis where study_title='A Study of Allogeneic Human UC-MSC and Liberation Therapy (When Associated With CCSVI) in Patients With RRMS'; -- different studies


select study_url,COUNT(*) from bronze.multiple_sclerosis group by study_url having COUNT(*)>1 or study_url is NULL;
-- no repeated urls and no nulls

select acronym,COUNT(*) from bronze.multiple_sclerosis group by acronym having COUNT(*)>1 or acronym is NULL;
-- 2.248 nulls and a few repeated acronyms

select study_status,COUNT(*) from bronze.multiple_sclerosis group by study_status having COUNT(*)>=1 or study_status is NULL;
/*
CATEGORIC VARIABLE 
no nulls and 
TERMINATED	262
WITHDRAWN	92
ENROLLING_BY_INVITATION	46
UNKNOWN	486
RECRUITING	459
ACTIVE_NOT_RECRUITING	159
SUSPENDED	11
COMPLETED	2064
TEMPORARILY_NOT_AVAILABLE 1
NO_LONGER_AVAILABLE	3
AVAILABLE	3
NOT_YET_RECRUITING	147
*/

select brief_summary,COUNT(*) from bronze.multiple_sclerosis group by brief_summary having COUNT(*)>1 or brief_summary is NULL;
select brief_summary from bronze.multiple_sclerosis where brief_summary is null or brief_summary='';

-- a few studies with the same brif summary -> it can be studies with different sponsors or locations for example

select * from bronze.multiple_sclerosis where brief_summary='The study is to evaluate the efficacy and safety of evobrutinib administered orally twice daily versus Teriflunomide (Aubagio®), administered orally once daily in participants with Relapsing Multiple Sclerosis (RMS). Participants who complete the double-blind treatment period (DBTP) and double-blind extension period (DBEP) prior to approval of a separate long-term follow-up study in their country will get an option for evobrutinib treatment continuation through a 96-week open-label extension (OLE) period.'; -- different studies

select study_results,COUNT(*) from bronze.multiple_sclerosis group by study_results having COUNT(*)>1 or study_results is NULL;
-- 579 YES study results and 3154 NO -> CATEGORIC VARIABLE

select conditions,COUNT(*) from bronze.multiple_sclerosis group by conditions having COUNT(*)>=1 or conditions is NULL;
select conditions,COUNT(*) from bronze.multiple_sclerosis group by conditions having conditions is NULL;

-- in general, serves information about the conditions and almost always has the disease name in it


select interventions,COUNT(*) from bronze.multiple_sclerosis group by interventions having COUNT(*)>=1 or interventions is NULL;
select interventions,COUNT(*) from bronze.multiple_sclerosis group by interventions having interventions is NULL;
-- in general, serves information about the interventions (can have nulls)


select primary_outcome_measures,COUNT(*) from bronze.multiple_sclerosis group by primary_outcome_measures having COUNT(*)>=1 or primary_outcome_measures is NULL;
-- in general, serves information about the primary outcome measures (can have nulls)

select secondary_outcome_measures,COUNT(*) from bronze.multiple_sclerosis group by secondary_outcome_measures having COUNT(*)>=1 or secondary_outcome_measures is NULL;
-- in general, serves information about the secondary outcome measures (can have nulls)

select other_outcome_measures,COUNT(*) from bronze.multiple_sclerosis group by other_outcome_measures having COUNT(*)>=1 or other_outcome_measures is NULL;
-- in general, serves information about the other outcome measures (many nulls)


select sponsor,COUNT(*) as count from bronze.multiple_sclerosis group by sponsor having COUNT(*)>=1 or sponsor is null order by count desc;
-- lists the sponsor of the trials
select sponsor,COUNT(*) as count from bronze.multiple_sclerosis group by sponsor having sponsor is null order by count desc;
-- no nulls

select collaborators,COUNT(*) as count from bronze.multiple_sclerosis group by collaborators having COUNT(*)>=1 or collaborators is null order by count desc;
-- lists the collaborators (many nulls)

select sex,COUNT(*) as count from bronze.multiple_sclerosis group by sex having COUNT(*)>=1 or sex is null order by count desc;
/*
CATEGORIC
ALL	3599
FEMALE	107
MALE	24
NULL	3
 */

select age,COUNT(*) as count from bronze.multiple_sclerosis group by age having COUNT(*)>=1 or age is null order by count desc;
/*
 * ADULT, OLDER_ADULT	2331
ADULT	1041
CHILD, ADULT, OLDER_ADULT	251
CHILD, ADULT	69
CHILD	38
OLDER_ADULT	3
 */

select phases,COUNT(*) as count from bronze.multiple_sclerosis group by phases having COUNT(*)>=1 or phases is null order by count desc;
/*
 * NA	1266
NULL	1085
PHASE2	395
PHASE3	331
PHASE4	234
PHASE1	220
PHASE1|PHASE2	119
PHASE2|PHASE3	51
EARLY_PHASE1	32
 */
-- here null and na can be aggregated in the same value

select enrollment,COUNT(*) as count from bronze.multiple_sclerosis group by enrollment having COUNT(*)>=1 or enrollment is null order by count desc;
/*
 * 30	185
60	142
40	123
20	120
50	95
0	90
...
 */
-- here it lists how many patients are listed to the study. the number 0 can mean that the study not stipulated yet
select enrollment,COUNT(*) as count from bronze.multiple_sclerosis group by enrollment having enrollment is null order by count desc;
-- it has 16 nulls -> the same as 0

select funder_type,COUNT(*) as count from bronze.multiple_sclerosis group by funder_type having COUNT(*)>=1 or funder_type is null order by count desc;
/*
 * OTHER	2459
INDUSTRY	1069
NIH	67
OTHER_GOV	61
FED	35
NETWORK	28
INDIV	14
 */
-- NO NULLS


select study_type,COUNT(*) as count from bronze.multiple_sclerosis group by study_type having COUNT(*)>=1 or study_type is null order by count desc;
/*
 * INTERVENTIONAL	2648
OBSERVATIONAL	1078
EXPANDED_ACCESS	7
 */
-- NO NULLS

select study_design,COUNT(*) as count from bronze.multiple_sclerosis group by study_design having COUNT(*)>=1 or study_design is null order by count desc;
/*
 * Observational Model: |Time Perspective: p	1078
Allocation: NA|Intervention Model: SINGLE_GROUP|Masking: NONE|Primary Purpose: TREATMENT	347
Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: QUADRUPLE (PARTICIPANT, CARE_PROVIDER, INVESTIGATOR, OUTCOMES_ASSESSOR)|Primary Purpose: TREATMENT	269
Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: SINGLE (OUTCOMES_ASSESSOR)|Primary Purpose: TREATMENT	205
Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: NONE|Primary Purpose: TREATMENT	191
Allocation: RANDOMIZED|Intervention Model: PARALLEL|Masking: DOUBLE (PARTICIPANT, INVESTIGATOR)|Primary Purpose: TREATMENT	133
...
 */
-- categorical but needs to be cleaned
-- NO NULLS

select other_ids,COUNT(*) as count from bronze.multiple_sclerosis group by other_ids having COUNT(*)>=1 or other_ids is null order by count desc;
select other_ids,COUNT(*) as count from bronze.multiple_sclerosis group by other_ids having other_ids is null order by count desc;
-- list with other ids, but the data is VERY messy and there is no nulls

select start_date,COUNT(*) as count from bronze.multiple_sclerosis group by start_date having COUNT(*)>=1 or start_date is null order by count desc;
/*
 * 2014-09	21
NULL	18
2012-09	17
2013-10	17
2014-10	17
2013-07	17
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)
select start_date from bronze.multiple_sclerosis where start_date='0';
-- no 0s

select primary_completion_date ate,COUNT(*) as count from bronze.multiple_sclerosis group by primary_completion_date having COUNT(*)>=1 or primary_completion_date is null order by count desc;
/*
 * 
NULL	110
2026-12	25
2025-12-31	25
2016-02	22
2014-12	20
2026-12-31	19
2015-12	16
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)
select primary_completion_date from bronze.multiple_sclerosis where primary_completion_date='0';
-- no 0s

select completion_date,COUNT(*) as count from bronze.multiple_sclerosis group by completion_date having COUNT(*)>=1 or completion_date is null order by count desc;
/*
NULL 	65
2025-12-31	28
2027-12-31	23
2014-12	22
2026-12	22
2026-12-31	20
2025-12	19
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)
select completion_date from bronze.multiple_sclerosis where completion_date='0';
-- no 0s

select first_posted,COUNT(*) as count from bronze.multiple_sclerosis group by first_posted having COUNT(*)>=1 or first_posted is null order by count desc;
/*
2005-09-20	14
2024-09-19	13
2005-09-22	9
2024-02-28	8
1999-11-04	7
2025-12-26	7
2010-03-03	6
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)

select first_posted from bronze.multiple_sclerosis where first_posted is null or first_posted='0';
-- no nulls and 0s

select results_first_posted,COUNT(*) as count from bronze.multiple_sclerosis group by results_first_posted having COUNT(*)>=1 or results_first_posted is null order by count desc;
/*
NULL 	3154
2025-06-18	4
2025-01-22	3
2020-10-19	3
2016-07-11	3
2012-09-19	3
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)
select results_first_posted from bronze.multiple_sclerosis where results_first_posted='0';
-- there is nulls and NO 0s

select last_update_posted,COUNT(*) as count from bronze.multiple_sclerosis group by last_update_posted having COUNT(*)>=1 or last_update_posted is null order by count desc;
/*
2026-02-27	19
2024-09-19	16
2026-02-20	12
2021-07-29	12
2026-02-03	12
2026-03-06	11
2026-02-17	11
 */
-- this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month)
select last_update_posted from bronze.multiple_sclerosis where last_update_posted='0' or last_update_posted is null;
-- no nulls or 0s

select locations,COUNT(*) as count from bronze.multiple_sclerosis group by locations having COUNT(*)>=1 or locations is null order by count desc;
/*
 NULL 	327
National Institutes of Health Clinical Center, Bethesda, Maryland, 20892, United States	16
National Institutes of Health Clinical Center, 9000 Rockville Pike, Bethesda, Maryland, 20892, United States	16
Kessler Foundation, West Orange, New Jersey, 07052, United States	16
Gazi University, Ankara, Turkey (Türkiye)	15
Johns Hopkins University, Baltimore, Maryland, 21287, United States	12
 */
-- in general here, we have the locations of the trials, and after the last ',' is the country -> needs data cleaning

select study_documents,COUNT(*) as count from bronze.multiple_sclerosis group by study_documents having COUNT(*)>=1 or study_documents is null order by count desc;
/*
 * 	3383
Study Protocol and Statistical Analysis Plan, https://cdn.clinicaltrials.gov/large-docs/87/NCT03594487/Prot_SAP_000.pdf	1
Study Protocol and Statistical Analysis Plan: Sub Study, https://cdn.clinicaltrials.gov/large-docs/10/NCT01970410/Prot_SAP_000.pdf|Study Protocol and Statistical Analysis Plan: Main Study, https://cdn.clinicaltrials.gov/large-docs/10/NCT01970410/Prot_SAP_001.pdf|Informed Consent Form: Sub Study, https://cdn.clinicaltrials.gov/large-docs/10/NCT01970410/ICF_002.pdf|Informed Consent Form: Main study, https://cdn.clinicaltrials.gov/large-docs/10/NCT01970410/ICF_003.pdf	1
Study Protocol, https://cdn.clinicaltrials.gov/large-docs/39/NCT03889639/Prot_000.pdf|Statistical Analysis Plan, https://cdn.clinicaltrials.gov/large-docs/39/NCT03889639/SAP_001.pdf	1
Study Protocol, https://cdn.clinicaltrials.gov/large-docs/16/NCT04486716/Prot_000.pdf|Statistical Analysis Plan, https://cdn.clinicaltrials.gov/large-docs/16/NCT04486716/SAP_001.pdf	1
 */
-- MANY nulls

-- overview:
-- nct_number: the ID and already unique and no nulls -> OK
-- study_title: large text data and a few can be repeated but are different considering the entirety of the row
-- study_url text with the url with no repeated and no nulls -> OK
-- acronym: text with 2.248 nulls and a few repeated acronyms -> FILTERED
-- study_status: CATEGORIC text value with no nulls -> OK
-- brief_summary: large text data and a few can be repeated but are different considering the entirety of the row
-- study_results: CATEGORIC text value with no nulls -> OK
-- conditions: text data which includes information about the disease (always has the disease in question and can have others) -> FILTERED
-- inverventions: text data which includes information about the interventions (can have null -> no intervention -> the study maybe was interrupted or was only observational...) -> IMPORTANT TO COLLECT
-- primary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- secondary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- other_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- sponsor: text data with the sponsor and has no nulls -> OK
-- collaborators: text data with the collaborators and can have nulls -> MAYBE unite the sponsor and collaborators in the same column?
-- sex: CATEGORIC text data and can have a few nulls -> OK
-- age: CATEGORIC text data and no nulls -> OK
-- phases: CATEGORIC text data but with many NA and NULLs -> NA is for not applicable and NULL for 'Unknown" -> NEEDS STANDARDIZATION 
-- enrollment: the only INT data and can have 0 when the number was not stipulated -> TRANSFORM IN A CATEGORICAL DATA
-- funder_type: CATEGORIC text data and no nulls -> OK
-- study_type: CATEGORIC text data and no nulls -> OK
-- study_design: CATEGORICAL text data but with HARD data standardization -> maybe use only allocation in a new column and have a few nulls
-- other_ids: text DATA with MANY nulls and not so important -> FILTERED
-- start_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- primary_completion_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- completion_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- first_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and NO nulls -> DATE STANDARDS
-- results_first_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- last_update_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and NO nulls -> DATE STANDARDS
-- locations: TEXT data in general here, we have the locations of the trials, and after the last ',' is the country -> needs data cleaning and have NULLS
-- study_documents: text data with documents related to the study with MANY nulls -> IMPORTANT TO COLLECT



-- study_status: CATEGORIC text value with no nulls -> OK
-- study_results: CATEGORIC text value with no nulls -> OK
-- sponsor: text data with the sponsor and has no nulls -> OK
-- collaborators: text data with the collaborators and can have nulls -> MAYBE unite the sponsor and collaborators in the same column?
-- sex: CATEGORIC text data and can have a few nulls -> OK
-- age: CATEGORIC text data and no nulls -> OK
-- phases: CATEGORIC text data but with many NA and NULLs -> NA is for not applicable and NULL for 'Unknown" -> NEEDS STANDARDIZATION 
-- enrollment: the only INT data and can have 0 when the number was not stipulated -> TRANSFORM IN A CATEGORICAL DATA
-- funder_type: CATEGORIC text data and no nulls -> OK
-- study_type: CATEGORIC text data and no nulls -> OK
-- study_design: CATEGORICAL text data but with HARD data standardization -> maybe use only allocation in a new column and have a few nulls
-- locations: TEXT data in general here, we have the locations of the trials, and after the last ',' is the country -> needs data cleaning and have NULLS

-- the silver layer will contain 4 tables:

-- dates with:
-- nct_number: the ID and already unique and no nulls -> OK
-- start_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- primary_completion_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- completion_date: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- first_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and NO nulls -> DATE STANDARDS
-- results_first_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and have nulls -> DATE STANDARDS
-- last_update_posted: this date is in the format (year)/(month) or (year)/(month)/(day) -> needs to be cleaned all to (year)/(month) and NO nulls -> DATE STANDARDS
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

-- written_details with:
-- nct_number: the ID and already unique and no nulls -> OK
-- study_title: large text data and a few can be repeated but are different considering the entirety of the row
-- study_url text with the url with no repeated and no nulls -> OK
-- brief_summary: large text data and a few can be repeated but are different considering the entirety of the row
-- study_documents: text data with documents related to the study with MANY nulls -> IMPORTANT TO COLLECT
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

-- interventions_and_outcomes with:
-- inverventions: text data which includes information about the interventions (can have null -> no intervention -> the study maybe was interrupted or was only observational...) -> IMPORTANT TO COLLECT
-- primary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- secondary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- other_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

-- clinical_trials with:
-- study_status: CATEGORIC text value with no nulls -> OK
-- study_results: CATEGORIC text value with no nulls -> OK
-- sponsor: text data with the sponsor and has no nulls -> OK
-- collaborators: text data with the collaborators and can have nulls -> MAYBE unite the sponsor and collaborators in the same column?
-- sex: CATEGORIC text data and can have a few nulls -> OK
-- age: CATEGORIC text data and no nulls -> OK
-- phases: CATEGORIC text data but with many NA and NULLs -> NA is for not applicable and NULL for 'Unknown" -> NEEDS STANDARDIZATION 
-- enrollment: the only INT data and can have 0 when the number was not stipulated -> TRANSFORM IN A CATEGORICAL DATA
-- funder_type: CATEGORIC text data and no nulls -> OK
-- study_type: CATEGORIC text data and no nulls -> OK
-- study_design: CATEGORICAL text data but with HARD data standardization -> maybe use only allocation in a new column and have a few nulls
-- locations: TEXT data in general here, we have the locations of the trials, and after the last ',' is the country -> needs data cleaning and have NULLS
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

-- Now, let's begin creating the queries to transform the data --> ALL THE DATAS WILL BE DAY 1 OF THE MONTH
select * from bronze.multiple_sclerosis
where start_date > completion_date or start_date > primary_completion_date;
-- First with dates:
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
-- dates ok

-- now, written_details:
-- nct_number: the ID and already unique and no nulls -> OK
-- study_title: large text data and a few can be repeated but are different considering the entirety of the row
-- study_url text with the url with no repeated and no nulls -> OK
-- brief_summary: large text data and a few can be repeated but are different considering the entirety of the row
-- study_documents: text data with documents related to the study with MANY nulls -> IMPORTANT TO COLLECT
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

select 
nct_number,
study_title,
study_url,
brief_summary,
study_documents
from bronze.multiple_sclerosis;
-- since this is a more text focused table, there will be no data transformation. it's purely for user consulting

-- now for interventions and outcomes:
-- interventions_and_outcomes with:
-- nct_number: the ID and already unique and no nulls -> OK
-- inverventions: text data which includes information about the interventions (can have null -> no intervention -> the study maybe was interrupted or was only observational...) -> IMPORTANT TO COLLECT -> separate in 2 columns
-- primary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- secondary_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- other_outcome_measures: text data which includes information about primary outcome measures (can have nulls) -> IMPORTANT TO COLLECT
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()

select
nct_number,
split_part(trim(interventions),':',1) as main_intervention,
split_part(trim(interventions),':',2) as specific_intervention,
primary_outcome_measures,
secondary_outcome_measures
from 
bronze.multiple_sclerosis;


-- now for the clinical_trials table:
-- clinical_trials with:
-- nct_number: the ID and already unique and no nulls -> OK
-- study_status: CATEGORIC text value with no nulls -> OK
-- study_results: CATEGORIC text value with no nulls -> OK
-- sponsor: text data with the sponsor and has no nulls -> OK
-- collaborators: text data with the collaborators and can have nulls -> MAYBE unite the sponsor and collaborators in the same column?
-- sex: CATEGORIC text data and can have a few nulls -> OK
-- age: CATEGORIC text data and no nulls -> OK
-- phases: CATEGORIC text data but with many NA and NULLs -> NA is for not applicable and NULL for 'Unknown" -> NEEDS STANDARDIZATION 
-- enrollment: the only INT data and can have 0 when the number was not stipulated -> TRANSFORM IN A CATEGORICAL DATA
-- funder_type: CATEGORIC text data and no nulls -> OK
-- study_type: CATEGORIC text data and no nulls -> OK
-- study_design: CATEGORICAL text data but with HARD data standardization -> maybe use only allocation in a new column and have a few nulls
-- locations: TEXT data in general here, we have the locations of the trials, and after the last ',' is the country -> needs data cleaning and have NULLS
-- dwh_create_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()


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
	when enrollment::int >0 and enrollment::int <50 then '0-50'
	when enrollment::int >= 50 and enrollment::int < 100 then '50-100'
	when enrollment::int >= 100 and enrollment::int < 500 then '100-500'
	when enrollment::int >500 then '>500'
	else enrollment
end as enrollment,
trim(sex) as sex,
trim(age) as age,
case when trim(phases) = 'NA' then 'Not applicable'
else trim(phases)
end as phases,
trim(reverse(split_part(reverse(locations),',',1))) as country
from bronze.multiple_sclerosis;


-- the data type of enrollment needed to be changed from int to text
-- now, creating the silver tables!

select * from bronze.multiple_sclerosis;