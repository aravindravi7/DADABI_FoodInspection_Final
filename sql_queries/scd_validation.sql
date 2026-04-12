-- =====================================================
-- SCD Type 2 Validation Checks
-- =====================================================

-- Check the SCD2 results 
SELECT restaurant_name, license_number, facility_type, risk_category,
       aka_name, is_current, effective_start_date, effective_end_date
FROM food_inspection.dim_restaurant
WHERE restaurant_name IN ('(K)  NEW  RESTAURANT', '1 2 3 EXPRESS', 'SCD2_TEST_NEW_RESTAURANT')
ORDER BY restaurant_name, is_current DESC;

-- =====================================================
-- Overall SCD2 state
-- =====================================================

SELECT is_current, COUNT(*) AS row_count
FROM food_inspection.dim_restaurant
GROUP BY is_current;

-- =====================================================
-- Integrity check: no restaurant has 2 current rows
-- =====================================================

SELECT restaurant_name, source_city, license_number, COUNT(*) AS current_count
FROM food_inspection.dim_restaurant
WHERE is_current = True
GROUP BY restaurant_name, source_city, license_number
HAVING COUNT(*) > 1;

-- =====================================================
-- Delta history
-- =====================================================

DESCRIBE HISTORY food_inspection.dim_restaurant;
