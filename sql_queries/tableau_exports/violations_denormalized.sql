-- =====================================================
-- Violations Denormalized View
-- =====================================================

SELECT
    f.inspection_key,
    f.inspection_id,
    r.restaurant_name,
    r.source_city,
    r.facility_type,
    r.risk_category,
    d.full_date AS inspection_date,
    d.year AS inspection_year,
    f.inspection_result,
    v.violation_code,
    v.violation_description
FROM food_inspection.fact_inspection f
JOIN food_inspection.bridge_inspection_violation b 
    ON f.inspection_key = b.inspection_key
JOIN food_inspection.dim_violation v 
    ON b.violation_key = v.violation_key
JOIN food_inspection.dim_restaurant r 
    ON f.restaurant_key = r.restaurant_key 
    AND r.is_current = true
JOIN food_inspection.dim_date d 
    ON f.date_key = d.date_key;
