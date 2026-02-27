/* SCRIPT: 07_saas_metrics.sql
OBJECTIVE: Transform operational logs into SaaS North Star Metrics.
TRANSLATION LAYER: 
- Car Model -> Subscription Tier
- Inactivity -> Churn Proxy
- Appointment -> Active User Event
*/

WITH metrics_base AS (
    SELECT 
        car_model AS tier,
        COUNT(*) as total_users,
        
        -- INACTIVE: > 90 days without activity (Churned)
        COUNT(*) FILTER (WHERE appointment_date < CURRENT_DATE - INTERVAL '90 days') as inactive_users_90d,
        
        -- AT RISK: 30-90 days without activity (Warning Zone)
        COUNT(*) FILTER (WHERE appointment_date BETWEEN CURRENT_DATE - INTERVAL '90 days' AND CURRENT_DATE - INTERVAL '30 days') as at_risk_users_30_90d,
        
        -- RATE CALCULATION
        ROUND(COUNT(*) FILTER (WHERE appointment_date < CURRENT_DATE - INTERVAL '90 days')::numeric / COUNT(*) * 100, 2) as inactivity_rate_pct
    FROM citas_honda
    GROUP BY 1
)
SELECT 
    tier,
    total_users,
    inactive_users_90d,
    at_risk_users_30_90d,
    inactivity_rate_pct || '%' as inactivity_rate,
    
    -- REVENUE EXPOSURE CALCULATION (Weighted by Tier Value)
    (inactive_users_90d * CASE 
        WHEN tier ILIKE '%CR-V%' THEN 499 -- Premium Tier Value
        WHEN tier ILIKE '%HR-V%' THEN 149 -- Standard Tier Value
        ELSE 49                          -- Basic Tier Value
    END) as revenue_exposure_usd
    
FROM metrics_base 
WHERE total_users > 10 -- Filtering low-volume noise
ORDER BY revenue_exposure_usd DESC
LIMIT 20;