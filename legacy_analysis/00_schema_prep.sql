/* SCRIPT: 00_schema_prep.sql
OBJECTIVE: Normalize database schema for SaaS simulation.
DESCRIPTION: Renames raw Spanish columns to English business standard terms 
to prepare the dataset for global analysis.
*/

-- 1. Initial Data Exploration (Sanity Check)
SELECT COUNT(*) AS total_records FROM citas_honda;

-- 2. Schema Normalization (Translating to Business English)
-- NOTE: In a production ETL pipeline, this would be a transformation layer (dbt/Airflow).
-- We are standardizing column names for consistency across scripts.

ALTER TABLE citas_honda RENAME COLUMN asesor TO advisor_name;
ALTER TABLE citas_honda RENAME COLUMN modelo TO car_model;
ALTER TABLE citas_honda RENAME COLUMN fec_cita TO appointment_date;
ALTER TABLE citas_honda RENAME COLUMN tiempo_horas TO billable_hours;
ALTER TABLE citas_honda RENAME COLUMN telefono TO customer_phone;
ALTER TABLE citas_honda RENAME COLUMN averia TO service_description;

-- 3. Verification
SELECT * FROM citas_honda LIMIT 5;