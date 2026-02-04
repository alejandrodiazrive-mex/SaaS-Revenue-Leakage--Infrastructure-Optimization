/* SCRIPT: 06_scenario_modeling.sql
OBJECTIVE: Financial forecasting of recovery strategies.
METHODOLOGY: Sensitivity analysis using Conservative, Realistic, and Optimistic recovery rates.
BASE METRIC: Standard Ticket (ARPU) = $120 USD.
*/

WITH potential_revenue AS (
    SELECT 
        COUNT(*) AS missing_contacts, 
        COUNT(*) * 120 AS total_exposure_usd
    FROM citas_honda
    WHERE customer_phone IS NULL
)
SELECT 
    missing_contacts, 
    total_exposure_usd AS max_potential_loss,
    
    -- Pessimistic: 5% Recovery (Passive Email Campaign)
    (total_exposure_usd * 0.05) AS recovery_pessimistic_usd,
    
    -- Realistic: 15% Recovery (Phone + SMS + Incentives)
    (total_exposure_usd * 0.15) AS recovery_realistic_usd,
    
    -- Optimistic: 30% Recovery (Full Account Management intervention)
    (total_exposure_usd * 0.30) AS recovery_optimistic_usd
FROM potential_revenue;