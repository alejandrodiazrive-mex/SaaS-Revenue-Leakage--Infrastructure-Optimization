/* SCRIPT: 04_product_mix.sql
BUSINESS CASE: Pareto Analysis & Product Segmentation.
OBJECTIVE: Identify high-LTV (Lifetime Value) segments ("Star Models") 
to prioritize retention efforts.
*/

SELECT 
    car_model, 
    COUNT(*) AS total_visits,
    
    -- Market Share: Contribution to total volume
    ROUND((COUNT(*)::numeric / (SELECT COUNT(*) FROM citas_honda) * 100), 2) AS volume_contribution_pct,
    
    -- Ranking: Identifying the Top Performers
    RANK() OVER (ORDER BY COUNT(*) DESC) AS market_rank
FROM citas_honda
GROUP BY 1
ORDER BY total_visits DESC
LIMIT 10; -- Focus on Top 10 key drivers