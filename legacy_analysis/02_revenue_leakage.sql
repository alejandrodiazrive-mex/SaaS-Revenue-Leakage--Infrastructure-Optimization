/* SCRIPT: 02_revenue_leakage.sql
OBJECTIVE: Quantify lost revenue opportunities due to missing user data.
BUSINESS CONTEXT: "Ghost Users" (missing contact info) cannot be retargeted, 
leading to increased churn risk.
*/

SELECT
    advisor_name,
    COUNT(*) AS total_appointments,
    
    -- Identifying the gap
    COUNT(*) FILTER (WHERE customer_phone IS NULL) AS missing_contact_info,
    
    -- KPI: Data Leakage Rate (%)
    ROUND(
        (COUNT(*) FILTER (WHERE customer_phone IS NULL)::numeric / COUNT(*)) * 100, 2
    ) AS leakage_rate_pct,
    
    -- FINANCIAL MODELING (Standard Ticket/ARPU: $120 USD)
    -- Projected Revenue if 100% of clients were retained
    (COUNT(*) * 120) AS total_opportunity_usd,
    
    -- Actual Realized Revenue (Contactable clients)
    (COUNT(*) FILTER (WHERE customer_phone IS NOT NULL) * 120) AS realized_revenue_usd,
    
    -- The "Leakage": Money left on the table
    (COUNT(*) FILTER (WHERE customer_phone IS NULL) * 120) AS potential_loss_usd

FROM citas_honda
GROUP BY 1
ORDER BY potential_loss_usd DESC;