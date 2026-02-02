/* SCRIPT: 05_scenario_analysis.sql
OBJECTIVE: Realistic revenue recovery projection.
HYPOTHESIS: We will not recover 100% of lost customers. We are testing conservative scenarios.
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
-- Pessimistic Scenario: We only recover 5% (Basic Campaign)
    (total_exposure_usd * 0.05) AS recovery_pessimistic_usd,
-- Realistic Scenario: We recover 15% (Aggressive Campaign + Incentives)
    (total_exposure_usd * 0.15) AS recovery_realistic_usd,
-- Optimistic Scenario: We recover 30% (Best case in the industry)
    (total_exposure_usd * 0.30) AS recovery_optimistic_usd
FROM potential_revenue;