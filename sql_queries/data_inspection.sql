-- =====================================================
-- Data Quality Checks: Food Inspection Dataset
-- =====================================================

-- Count rows with quotes in names
SELECT COUNT(*) AS count_with_quotes
FROM food_inspection.silver_chicago_inspections
WHERE DBA_Name LIKE '%"%'
   OR AKA_Name LIKE '%"%';

-- Sample rows with quotes
SELECT DBA_Name, AKA_Name
FROM food_inspection.silver_chicago_inspections
WHERE DBA_Name LIKE '%"%'
LIMIT 10;

-- =====================================================
-- Special Characters Check
-- =====================================================

SELECT DISTINCT DBA_Name 
FROM food_inspection.bronze_chicago_inspections
WHERE DBA_Name RLIKE '["\\/]'
LIMIT 20;

-- =====================================================
-- Latitude / Longitude Issues
-- =====================================================

SELECT DISTINCT Latitude 
FROM food_inspection.bronze_chicago_inspections
WHERE Latitude IS NOT NULL 
  AND try_cast(Latitude AS DOUBLE) IS NULL
LIMIT 20;

SELECT DISTINCT Longitude 
FROM food_inspection.bronze_chicago_inspections
WHERE Longitude IS NOT NULL 
  AND try_cast(Longitude AS DOUBLE) IS NULL
LIMIT 20;

-- =====================================================
-- ZIP Code Validation
-- =====================================================

SELECT 'Chicago' AS source, CAST(Zip AS STRING) AS zip_val, COUNT(*) AS cnt
FROM food_inspection.bronze_chicago_inspections
WHERE Zip IS NOT NULL 
  AND NOT CAST(Zip AS STRING) RLIKE '^[0-9]{5}$'
GROUP BY CAST(Zip AS STRING)

UNION ALL

SELECT 'Dallas', CAST(Zip_Code AS STRING), COUNT(*)
FROM food_inspection.bronze_dallas_inspections
WHERE Zip_Code IS NOT NULL 
  AND NOT CAST(Zip_Code AS STRING) RLIKE '^[0-9]{5}$'
GROUP BY CAST(Zip_Code AS STRING)

ORDER BY source, cnt DESC;

-- =====================================================
-- Date Parsing Issues
-- =====================================================

SELECT Inspection_Date, COUNT(*) AS cnt
FROM food_inspection.bronze_chicago_inspections
WHERE try_to_date(Inspection_Date, 'MM/dd/yyyy') IS NULL
  AND Inspection_Date IS NOT NULL
GROUP BY Inspection_Date
LIMIT 20;

SELECT Inspection_Date, COUNT(*) AS cnt
FROM food_inspection.bronze_dallas_inspections
WHERE try_to_date(Inspection_Date, 'MM/dd/yyyy') IS NULL
  AND Inspection_Date IS NOT NULL
GROUP BY Inspection_Date
LIMIT 20;

-- =====================================================
-- Score Validation
-- =====================================================

SELECT Inspection_Score, COUNT(*) AS cnt
FROM food_inspection.bronze_dallas_inspections
WHERE Inspection_Score IS NOT NULL 
  AND (Inspection_Score < 0 OR Inspection_Score > 100)
GROUP BY Inspection_Score
ORDER BY Inspection_Score;

-- =====================================================
-- Whitespace Issues
-- =====================================================

SELECT 'DBA_Name' AS col, COUNT(*) AS cnt
FROM food_inspection.bronze_chicago_inspections
WHERE DBA_Name != TRIM(DBA_Name)

UNION ALL

SELECT 'AKA_Name', COUNT(*)
FROM food_inspection.bronze_chicago_inspections
WHERE AKA_Name != TRIM(AKA_Name)

UNION ALL

SELECT 'Address', COUNT(*)
FROM food_inspection.bronze_chicago_inspections
WHERE Address != TRIM(Address)

UNION ALL

SELECT 'Facility_Type', COUNT(*)
FROM food_inspection.bronze_chicago_inspections
WHERE Facility_Type != TRIM(Facility_Type);

-- =====================================================
-- Duplicate Checks
-- =====================================================

SELECT Inspection_ID, COUNT(*) AS cnt
FROM food_inspection.bronze_chicago_inspections
GROUP BY Inspection_ID
HAVING COUNT(*) > 1
LIMIT 20;

-- =====================================================
-- Null / Empty Value Checks
-- =====================================================

SELECT 
  SUM(CASE WHEN DBA_Name = '' THEN 1 ELSE 0 END) AS empty_name,
  SUM(CASE WHEN Facility_Type = '' THEN 1 ELSE 0 END) AS empty_facility,
  SUM(CASE WHEN Risk = '' THEN 1 ELSE 0 END) AS empty_risk,
  SUM(CASE WHEN Results = '' THEN 1 ELSE 0 END) AS empty_results
FROM food_inspection.bronze_chicago_inspections;

-- =====================================================
-- Coordinate Outliers
-- =====================================================

SELECT 'Chicago' AS source, COUNT(*) AS outlier_count
FROM food_inspection.bronze_chicago_inspections
WHERE try_cast(Latitude AS DOUBLE) IS NOT NULL
  AND (
    try_cast(Latitude AS DOUBLE) < 41.0 OR try_cast(Latitude AS DOUBLE) > 43.0
    OR try_cast(Longitude AS DOUBLE) < -89.0 OR try_cast(Longitude AS DOUBLE) > -86.0
  )

UNION ALL

SELECT 'Dallas', COUNT(*)
FROM food_inspection.bronze_dallas_inspections
WHERE Latitude IS NOT NULL
  AND (
    Latitude < 32.0 OR Latitude > 34.0
    OR Longitude < -98.0 OR Longitude > -96.0
  );

-- =====================================================
-- License Validation
-- =====================================================

SELECT DISTINCT CAST(License AS STRING) AS license_val
FROM food_inspection.bronze_chicago_inspections
WHERE License IS NOT NULL 
  AND try_cast(CAST(License AS STRING) AS BIGINT) IS NULL
LIMIT 20;
