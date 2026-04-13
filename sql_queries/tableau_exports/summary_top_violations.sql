-- =====================================================
-- Summary: Top Violations by City
-- =====================================================

SELECT
    r.source_city,
    v.violation_code,
    v.violation_description,
    v.violation_points,
    COUNT(*) AS violation_count
FROM food_inspection.fact_inspection f
JOIN food_inspection.bridge_inspection_violation b 
    ON f.inspection_key = b.inspection_key
JOIN food_inspection.dim_violation v 
    ON b.violation_key = v.violation_key
JOIN food_inspection.dim_restaurant r 
    ON f.restaurant_key = r.restaurant_key 
    AND r.is_current = true
GROUP BY 
    r.source_city, 
    v.violation_code, 
    v.violation_description, 
    v.violation_points
ORDER BY violation_count DESC;
