-- =====================================================
-- Fact Inspections Denormalized View
-- =====================================================

SELECT
    f.inspection_key,
    f.inspection_id,
    r.restaurant_name,
    r.aka_name,
    r.license_number,
    r.facility_type,
    r.risk_category,
    r.source_city,
    l.address,
    l.city,
    l.state,
    l.zip,
    l.latitude,
    l.longitude,
    d.full_date AS inspection_date,
    d.year AS inspection_year,
    d.month AS inspection_month,
    d.month_name,
    d.quarter,
    it.inspection_type_name,
    f.inspection_result,
    f.inspection_score
FROM food_inspection.fact_inspection f
JOIN food_inspection.dim_restaurant r 
    ON f.restaurant_key = r.restaurant_key 
    AND r.is_current = true
JOIN food_inspection.dim_location l 
    ON f.location_key = l.location_key
JOIN food_inspection.dim_date d 
    ON f.date_key = d.date_key
JOIN food_inspection.dim_inspection_type it 
    ON f.inspection_type_key = it.inspection_type_key;
