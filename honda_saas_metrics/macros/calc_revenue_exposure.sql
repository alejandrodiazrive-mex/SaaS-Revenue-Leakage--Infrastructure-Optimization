{% macro get_tier_revenue(car_model_column) %}
    CASE 
        WHEN {{ car_model_column }} ILIKE '%CR-V%' THEN 499
        WHEN {{ car_model_column }} ILIKE '%HR-V%' THEN 149
        ELSE 49
    END
{% endmacro %}