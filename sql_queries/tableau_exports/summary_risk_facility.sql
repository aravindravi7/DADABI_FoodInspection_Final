-- =====================================================
-- Summary: Inspections by Risk Category and Facility Type
-- =====================================================

SELECT
    r.source_city,
    r.risk_category,
    r.facility_type,
    COUNT(*) AS inspection_count
FROM food_inspection.fact_inspection f
JOIN food_inspection.dim_restaurant r 
    ON f.restaurant_key = r.restaurant_key 
    AND r.is_current = true
GROUP BY 
    r.source_city, 
    r.risk_category, 
    r.facility_type
ORDER BY inspection_count DESC;
