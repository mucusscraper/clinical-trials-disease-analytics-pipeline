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

select study_status,COUNT(*) from bronze.multiple_sclerosis group by study_status having COUNT(*)>1 or study_status is NULL;
/* 
no nulls and 
TERMINATED	262
WITHDRAWN	92
ENROLLING_BY_INVITATION	46
UNKNOWN	486
RECRUITING	459
ACTIVE_NOT_RECRUITING	159
SUSPENDED	11
COMPLETED	2064
NO_LONGER_AVAILABLE	3
AVAILABLE	3
NOT_YET_RECRUITING	147
*/

select brief_summary,COUNT(*) from bronze.multiple_sclerosis group by brief_summary having COUNT(*)>1 or brief_summary is NULL;
-- a few studies with the same brif summary -> it can be studies with different sponsors or locations for example

select * from bronze.multiple_sclerosis where brief_summary='The study is to evaluate the efficacy and safety of evobrutinib administered orally twice daily versus Teriflunomide (Aubagio®), administered orally once daily in participants with Relapsing Multiple Sclerosis (RMS). Participants who complete the double-blind treatment period (DBTP) and double-blind extension period (DBEP) prior to approval of a separate long-term follow-up study in their country will get an option for evobrutinib treatment continuation through a 96-week open-label extension (OLE) period.'; -- different studies
