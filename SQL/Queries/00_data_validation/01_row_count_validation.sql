-- Checking the row count of all tables in the database

USE hyderabadmetrotransitanalytics;

SELECT 'agency' AS table_name, COUNT(*) FROM agency
UNION ALL

SELECT 'calendar', COUNT(*) FROM calendar
UNION ALL

SELECT 'fare_attributes', COUNT(*) FROM fare_attributes
UNION ALL

SELECT 'fare_rules', COUNT(*) FROM fare_rules
UNION ALL

SELECT 'feed_info', COUNT(*) FROM feed_info
UNION ALL

SELECT 'routes', COUNT(*) FROM routes
UNION ALL

SELECT 'shapes', COUNT(*) FROM shapes
UNION ALL

SELECT 'stop_times', COUNT(*) FROM stop_times
UNION ALL

SELECT 'stops', COUNT(*) FROM stops
UNION ALL

SELECT 'trips', COUNT(*) FROM trips;