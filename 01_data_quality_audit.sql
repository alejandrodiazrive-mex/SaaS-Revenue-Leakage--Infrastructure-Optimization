/* SCRIPT: 01_data_quality_audit.sql
OBJECTIVE: Validate data integrity before financial modeling.
WHY: Flawed data leads to incorrect revenue projections.
*/

-- 1. Impossible Dates Check (Future or Legacy Data)
-- We need to exclude records that don't fit the analysis window.
SELECT 
    appointment_date,
    COUNT(*) as record_count
FROM citas_honda
WHERE appointment_date > CURRENT_DATE -- Error: Future appointments
OR appointment_date < '2020-01-01' -- Error: Legacy data outside scope
GROUP BY 1;

-- 2. Negative Billable Hours Check
-- Revenue cannot be generated from zero or negative time.
SELECT 
    COUNT(*) AS invalid_records
FROM citas_honda 
WHERE billable_hours <= 0;

-- 3. Duplicate Analysis (Concurrency Check)
-- Logic: The same advisor cannot service the same car model at the exact same time.
SELECT 
    advisor_name, 
    appointment_date, 
    car_model, 
    COUNT(*) as duplicate_events
FROM citas_honda
GROUP BY 1, 2, 3
HAVING COUNT(*) > 1;

-- 4. Contact Information Gaps
-- Critical for Churn Risk analysis. Identifying invalid phone numbers.
SELECT 
    COUNT(*) AS potential_bad_phones 
FROM citas_honda
WHERE LENGTH(customer_phone) < 10 
AND customer_phone IS NOT NULL;