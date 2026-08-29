USE hyderabadmetrotransitanalytics;

-- DUPLICATE RECORD VALIDATION

-- 1. AGENCY
SELECT
    'agency' AS table_name,
    agency_id,
    COUNT(*) AS duplicate_count
FROM agency
GROUP BY agency_id
HAVING COUNT(*) > 1;

-- 2. CALENDAR
SELECT
    'calendar' AS table_name,
    service_id,
    COUNT(*) AS duplicate_count
FROM calendar
GROUP BY service_id
HAVING COUNT(*) > 1;

-- 3. FARE_ATTRIBUTES
SELECT
    'fare_attributes' AS table_name,
    fare_id,
    COUNT(*) AS duplicate_count
FROM fare_attributes
GROUP BY fare_id
HAVING COUNT(*) > 1;

-- 4. FARE_RULES
-- fare_rules normally does NOT have a single-column primary key.
-- Check duplicate combinations of the columns that identify a rule.

SELECT
    'fare_rules' AS table_name,
    fare_id,
    origin_id,
    destination_id,
    COUNT(*) AS duplicate_count
FROM fare_rules
GROUP BY
    fare_id,
    origin_id,
    destination_id
HAVING COUNT(*) > 1
LIMIT 100;

-- 5. FEED_INFO
-- feed_info generally represents feed-level metadata.
-- Check for completely identical records.

SELECT
    'feed_info' AS table_name,
    feed_publisher_name,
    feed_publisher_url,
    feed_lang,
    feed_start_date,
    feed_end_date,
    COUNT(*) AS duplicate_count
FROM feed_info
GROUP BY
    feed_publisher_name,
    feed_publisher_url,
    feed_lang,
    feed_start_date,
    feed_end_date
HAVING COUNT(*) > 1;

-- 6. ROUTES
SELECT
    'routes' AS table_name,
    route_id,
    COUNT(*) AS duplicate_count
FROM routes
GROUP BY route_id
HAVING COUNT(*) > 1;

-- 7. SHAPES
-- shape_id alone is normally repeated because a shape
-- consists of multiple points.
-- Therefore validate duplicate points within a shape.

SELECT
    'shapes' AS table_name,
    shape_id,
    shape_pt_lat,
    shape_pt_lon,
    shape_pt_sequence,
    COUNT(*) AS duplicate_count
FROM shapes
GROUP BY
    shape_id,
    shape_pt_lat,
    shape_pt_lon,
    shape_pt_sequence
HAVING COUNT(*) > 1;

-- 8. STOPS
SELECT
    'stops' AS table_name,
    stop_id,
    COUNT(*) AS duplicate_count
FROM stops
GROUP BY stop_id
HAVING COUNT(*) > 1;

-- 9. STOP_TIMES
-- stop_times does not have one simple primary key.
-- A trip's stop sequence should uniquely identify a record.

SELECT
    'stop_times' AS table_name,
    trip_id,
    stop_sequence,
    COUNT(*) AS duplicate_count
FROM stop_times
GROUP BY
    trip_id,
    stop_sequence
HAVING COUNT(*) > 1;

-- 10. TRIPS
SELECT
    'trips' AS table_name,
    trip_id,
    COUNT(*) AS duplicate_count
FROM trips
GROUP BY trip_id
HAVING COUNT(*) > 1;