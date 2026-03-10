-- Connect to the target database
\connect Multiple_Sclerosis_ClinicalTrials;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;