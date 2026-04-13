-- =====================================================
-- Summary: Inspection Results by Year and City
-- =====================================================

SELECT
    d.year AS inspection_year,
    r.source_city,
    f.inspection_result,
    COUNT(*) AS inspection_count
FROM food_inspection.fact_inspection f
JOIN food_inspection.dim_restaurant r 
    ON f.restaurant_key = r.restaurant_key 
    AND r.is_current = true
JOIN food_inspection.dim_date d 
    ON f.date_key = d.date_key
GROUP BY 
    d.year, 
    r.source_city, 
    f.inspection_result
ORDER BY 
    d.year, 
    r.source_city, 
    f.inspection_result;
