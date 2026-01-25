/* BUSINESS CASE: Operational Capacity & Dead Rent.
Analysis of fixed cost (Rent) vs revenue generation by shift.
Fixed Monthly Rent: $32,500 USD.
*/

WITH shift_stats AS (
    SELECT 
        CASE WHEN hora < '12:00:00' THEN 'Morning' ELSE 'Afternoon' END AS shift,
        COUNT(*) AS total_appointments,
        (COUNT(*)::numeric / (SELECT COUNT(*) FROM citas_honda) * 100) AS volume_pct
    FROM citas_honda
    GROUP BY 1
)
SELECT 
    shift,
    total_appointments,
    ROUND(volume_pct, 2) AS volume_pct,
    -- Allocated Rent: We pay 50% of rent for each shift
    16250 AS rent_cost_usd,
    -- Efficiency Score: Revenue contribution vs Cost contribution
    CASE 
        WHEN volume_pct < 10 THEN 'CRITICAL: High Dead Rent Risk'
        ELSE 'OPTIMAL: High Utilization'
    END AS operational_status
FROM shift_stats;