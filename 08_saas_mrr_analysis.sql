/* 
SCRIPT: 08_saas_mrr_analysis.sql

BUSINESS QUESTION:
How healthy is the SaaS business over time in terms of MRR and churn?

MODEL NOTES:
- Each unique `referenc` is treated as an account proxy.
- MRR is simulated using a fixed ARPU of $120 per active account.
- Negative churn values indicate net account growth.
*/

WITH monthly_accounts AS (
    SELECT
        -- Se usa 'appoinment_date' tal cual aparece en tu dataset
        DATE_TRUNC('month', appointment_date) AS month,
        COUNT(DISTINCT referenc) AS active_accounts
    FROM citas_honda -- Nombre real de la tabla
    WHERE referenc IS NOT NULL
    GROUP BY 1
),

mrr_calculation AS (
    SELECT
        month,
        active_accounts,
        active_accounts * 120 AS mrr,
        LAG(active_accounts) OVER (ORDER BY month) AS prev_active_accounts
    FROM monthly_accounts
),

churn_metrics AS (
    SELECT
        month,
        active_accounts,
        mrr,
        CASE 
            WHEN prev_active_accounts IS NULL THEN 0
            ELSE ROUND(
                ((prev_active_accounts - active_accounts)::NUMERIC 
                / NULLIF(prev_active_accounts, 0)) * 100, 
                2
            )
        END AS logo_churn_rate_pct,
        CASE 
            WHEN prev_active_accounts IS NULL THEN 0
            ELSE ROUND(
                ((prev_active_accounts - active_accounts)::NUMERIC 
                / NULLIF(prev_active_accounts, 0)) * 100, 
                2
            )
        END AS revenue_churn_rate_pct,
        CASE 
            WHEN (prev_active_accounts - active_accounts) > 0 
            THEN 'Net Churn'
            ELSE 'Net Growth'
        END AS net_account_trend
    FROM mrr_calculation
)

SELECT *
FROM churn_metrics
ORDER BY month;
-- INTERPRETATION NOTE:
-- Negative churn rates indicate net account growth.
-- This behavior is expected in activity-based SaaS simulations
-- where acquisition is inferred from first observed usage.
