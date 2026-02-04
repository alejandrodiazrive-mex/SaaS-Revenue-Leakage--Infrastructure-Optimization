/* SCRIPT: 03_operational_capacity.sql
BUSINESS CASE: Infrastructure Efficiency Analysis ("Dead Cloud Spend").
CONTEXT: Analyzing fixed costs vs. utilization rates. 
In SaaS, this simulates server load balancing between peak/off-peak hours.
ASSUMPTION: Fixed Monthly Operational Cost = $32,500 USD.
*/

WITH shift_stats AS (
    SELECT 
        -- Segmenting by shift (Morning vs Afternoon)
        CASE WHEN hora < '12:00:00' THEN 'Morning' ELSE 'Afternoon' END AS shift,
        COUNT(*) AS total_appointments,
        
        -- Utilization Rate Calculation
        (COUNT(*)::numeric / (SELECT COUNT(*) FROM citas_honda) * 100) AS volume_pct
    FROM citas_honda
    GROUP BY 1
)
SELECT 
    shift,
    total_appointments,
    ROUND(volume_pct, 2) AS volume_pct,
    
    -- Cost Allocation: 50% of overhead assigned to each shift block
    16250 AS allocated_cost_usd,
    
    -- Efficiency Diagnostic
    CASE 
        WHEN volume_pct < 10 THEN 'CRITICAL: Underutilized Capacity (Dead Rent)'
        ELSE 'OPTIMAL: High Utilization'
    END AS operational_status
FROM shift_stats;